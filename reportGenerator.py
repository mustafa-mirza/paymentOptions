import json
import requests
import os
import sys
import argparse
import urllib
import time
import getpass
from datetime import datetime
import logging
from logging.handlers import RotatingFileHandler
import configparser
#--------------------------------------------------------------------------------------------------------------------------------------------------
#Python version check
if sys.version_info < (3, 0):
    sys.stdout.write("Requires Python 3.x\n")
    sys.exit(1)

FIELD_APPID = "appId"
FIELD_APPNAME = "appName"
FIELD_APPALIASNAME = "appAliasName"
FIELD_APPPATH = "appPath"
FIELD_SHA2CHECKSUM = "sha2Checksum"
FIELD_CUSTOMER = "customer"
FIELD_DEPARTMENT = "department"
FIELD_PROTOCOL = "protocol"
FIELD_IS_ADPL_ENABLED = "isAdplEnabled"
FIELD_ACTION = "action"
FIELD_COMPLIANCE = "compliance"
FIELD_CERTIFICATENICKNAME = "certificateNickname"
FIELD_CERTIFICATECONTENT = "certificateContent"
FIELD_CERTIFICATEHOSTNAME = "certificateHostName"
FIELD_NSSDBDIR = "nssDBDir"
FIELD_NSSDBPASSWORD = "nssDBPassword"
FIELD_CONTAINER = "container"
FIELD_IS_REGISTERED = "isRegistered"

FIELD_SERVER_INFO_MANAGEMENT_ID = "managementIP"
FIELD_SERVER_INFO_HOST_NAME = "hostname"
FIELD_SERVER_INFO_CLIENT_ID = "clientId"
FIELD_SERVER_INFO_ACTIVE = "active"

FIELD_MANAGEMENT_IP = "managementIP"
FIELD_HOST_NAME = "hostname"
FIELD_PLUGINID = "pluginId"
FIELD_STATUS = "status"

ACTIVE_VALUE = "Active"
IN_ACTIVE_VALUE = "Inactive"

FIELD_CUSTNAME = "custName"
FIELD_DEPTNAME = "deptName"
FIELD_CUST_ID = "custId"
FIELD_DEPT_ID = "deptId"

FIELD_LISTAPPLICATIONS = "listApplications"
FIELD_LIST_SERVER_INFO = "listServerInfo"

FIELD_LIST_APPLICATIONS = "listApplications"
FIELD_TOTALROWS = "totalRows"
PAGE_SIZE = 10000

EXPORT_CSV_APPLICATION_WITH_HOST_INFO_FIELDS = [FIELD_APPID,
												FIELD_APPNAME,
												FIELD_APPALIASNAME,
												FIELD_APPPATH,
												FIELD_SHA2CHECKSUM,
												FIELD_CUSTOMER,
												FIELD_DEPARTMENT,
												FIELD_PROTOCOL,
												FIELD_ACTION,
												FIELD_COMPLIANCE,
												FIELD_CONTAINER,
												FIELD_CERTIFICATENICKNAME,
												FIELD_CERTIFICATECONTENT,
												FIELD_CERTIFICATEHOSTNAME,
												FIELD_NSSDBDIR,
												FIELD_NSSDBPASSWORD,
												FIELD_PLUGINID,
												FIELD_HOST_NAME,
												FIELD_MANAGEMENT_IP,
												FIELD_STATUS]

token_expire_time = 0
access_token_from_orch = ''

REPORT_GENERATION_STATUS_SUCCESS = "Success"
REPORT_GENERATION_STATUS_FAILED = "Failed"
REPORT_GENERATION_STATUS_INPROGRESS = "Inprogress"
REPORT_GENERATION_STATUS_NO_DATA_FOUND = "NoData"

REPORT_GENERATION_STATUS_CHECK_INTERVAL = 10

DATE_TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

FILE_DATE_TIME_FORMAT = "%Y%m%d-%I%M%S"
LOG_FILE_PREFIX = "reportGenerator_"
log_formatter = logging.Formatter('%(asctime)s %(levelname)s %(name)s %(message)s')

parser = argparse.ArgumentParser(
 description='Start report generation at Orchestrator and download report after successful generation' ,
 epilog="Start report generation at Orchestrator and download report after successful generation"
 )
parser.add_argument('--username', help='(Optional) Orchestrator user username')
parser.add_argument('--password', help='(Optional) Orchestrator user password')
parser.add_argument('--fromdate',
					help="(Mandatory) Filter out records from the date. Expected Date format is 'yyyy-mm-dd HH:MM:SS'.")
parser.add_argument('--todate',
					help="(Optional) Filter out records to date. Expected Date format is 'yyyy-mm-dd HH:MM:SS'.")
parser.add_argument('--domain', help='(Mandatory) Filter out records with the domain name')
parser.add_argument('--subdomain', help='(Mandatory) Filter out records with the subdomain name')
parser.add_argument('--format', help='(Optional) Set report format CSV or PDF. This option is applicable only for vulnerabilities_stride type reports. Default is CSV.')
parser.add_argument('--reportType', help='(Mandatory) Set required report type value from application_details, application_forensic, secure_application_policy_details, attacked_applications_details, discovered_application_details, owasp_top_10_report, vulnerabilities_stride_short, vulnerabilities_stride_long, application_forensic_session_details, pcre_policy_details, application_model, application_model_default, application_model_threat_dragon, application_model_threat_dragon_plus, application_model_microsoft_tmt and application_model_architecture.')
args = parser.parse_args()

class Arg:
    fromdate = args.fromdate
    if fromdate is None:
        print("argument --fromdate is missing")
        parser.print_help()
        exit()

    todate = args.todate

    start_timestamp = None
    end_timestamp = None
    try:
        timestamp = time.time()
        utcOffset = (datetime.fromtimestamp(timestamp) - datetime.utcfromtimestamp(
            timestamp)).total_seconds()

        if fromdate:
            start_timestamp = datetime.strptime(fromdate, DATE_TIME_FORMAT)
            start_timestamp = int(start_timestamp.timestamp() + utcOffset)
        else:
            print("argument --fromdate is missing")
            exit()

        if todate:
            end_timestamp = datetime.strptime(todate, DATE_TIME_FORMAT)
            end_timestamp = int(end_timestamp.timestamp() + utcOffset)

        if not end_timestamp:
            end_timestamp = int(timestamp + utcOffset)

    except ValueError as e:
        print("Error while parsing data : ", e)
        print(e)
        exit()

    domain = args.domain
    if domain is None:
        print("argument --domain is missing")
        parser.print_help()
        exit()

    subDomain = args.subdomain
    if subDomain is None:
        print("argument --subdomain is missing")
        parser.print_help()
        exit()

    format = args.format
    if format and (str(format).lower() != 'pdf' and str(format).lower() != 'csv'):
        print("Invalid value for --format. Please set it to pdf or csv")
        parser.print_help()
        exit()

    report_type = args.reportType
    if report_type is None:
        print("argument --reportType is missing")
        parser.print_help()
        exit()


execution_date_time_str = datetime.now().strftime(FILE_DATE_TIME_FORMAT)

log_file = LOG_FILE_PREFIX + execution_date_time_str + ".log"

log_handler = RotatingFileHandler(log_file, mode='a', maxBytes=10 * 1024 * 1024,
								  backupCount=1, encoding=None, delay=0)
log_handler.setFormatter(log_formatter)
log_handler.setLevel(logging.DEBUG)
app_log = logging.getLogger()
app_log.setLevel(logging.DEBUG)
app_log.addHandler(log_handler)


def print_info(message):
	print(message)
	logging.info(message)


def print_error(message, e, data):
    print(message)
    logging.error(message)
    if e:
        print(e)
        logging.error(e)
    if data:
        print(data)
        logging.error(data)


def print_warning(message):
	print(message)
	logging.warning(message)

CONFIG_FILE_NAME = 'commonConfig.cnf'
common_file_locations = ["./", '../common/']
CONFIG_FILE = None

for config_path in common_file_locations:
	config_file_path = os.path.join(config_path, CONFIG_FILE_NAME)
	if os.path.exists(config_file_path):
		CONFIG_FILE = config_file_path

if not CONFIG_FILE:
	print_error("Config file " +  CONFIG_FILE_NAME + " not found.", None, None)
	exit()

config = configparser.RawConfigParser()
config.read(CONFIG_FILE)
if not config.has_section('Orchestrator'):
    print_error("Invalid config file, Section 'Orchestrator' is not found in the config file.", None, None)
    exit()

if not config.has_option('Orchestrator', 'ORCH_URL'):
    print_error("ORCH_URL is not set, please set it in the config file.", None, None)
    exit()

if not config.has_option('Orchestrator', 'CA_FILE'):
    print_error("CA_FILE is not set, please set it in the config file.", None, None)
    exit()

ORCH_URL = config.get('Orchestrator', 'ORCH_URL')
ca_file_Path = config.get('Orchestrator', 'CA_FILE')

CA_FILE = None
ca_file_name = None

if not ca_file_Path:
	print_error("CA file not found. Please configure the 'CA_FILE' property in " + CONFIG_FILE_NAME, None, None)
	exit()

if os.path.exists(ca_file_Path):
	CA_FILE = ca_file_Path
else:
	print_warning("Configured CA file " + ca_file_Path + " not found. Searching for common locations.")
	ca_file_name = os.path.basename(ca_file_Path)

if not CA_FILE:
	for config_path in common_file_locations:
		config_file_path = os.path.join(config_path, ca_file_name)
		if os.path.exists(config_file_path):
			CA_FILE = config_file_path
			print_info("Using CA file at location " + CA_FILE)

if not CA_FILE:
	print_error("CA file not found. Please configure the 'CA_FILE' property in " + CONFIG_FILE_NAME, None, None)
	exit()

USERNAME = None
if config.has_option('Orchestrator', 'USERNAME'):
    USERNAME = config.get('Orchestrator', 'USERNAME')

PASSWORD = None
if config.has_option('Orchestrator', 'PASSWORD'):
    PASSWORD = config.get('Orchestrator', 'PASSWORD')


def validate_and_get_username(username):
    # Validate Orchestrator user username argument
    if username is None:
        username = USERNAME
    if username is None or len(username.strip()) == 0:
        username = str(input("Enter Orchestrator username:"))
        if username is None or len(username.strip()) == 0:
            print("Invalid or empty Orchestrator username")
            validate_and_get_username(username)
    return username


def validate_and_get_password(password):
    # Validate Orchestrator user password argument
    if password is None:
        password = PASSWORD
    if password is None or len(password.strip()) == 0:
        password = getpass.getpass(prompt="Enter Orchestrator user password:")
        if password is None or len(password.strip()) == 0:
            print("Invalid or empty Orchestrator user password")
            validate_and_get_password(password)
    return password


username = validate_and_get_username(args.username)
password = validate_and_get_password(args.password)


def get_access_token_from_orch(username, password):
    # -----Getting access token from Orchestrator BEGIN-----
    print_info("Getting access token from orchestrator")
    oauth_url = ORCH_URL + "/oauth/token"
    data = dict(
        username=username,
        password=password,
        grant_type='password',
    )

    headers = {}
    try:
        response = requests.post(oauth_url, data=data, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            jsonResponse = response.json()
            return jsonResponse
        elif response.status_code == 401 or response.status_code == 403:
            print_error("Invalid user credentials", None, None)
            exit()
        elif response.status_code == 400:
            print_error("Bad Request or Invalid user credentials", None, None)
            exit()
        else:
            print_error("Cannot get accessToken from Orchestrator", None, None)
            exit()
    except requests.exceptions.ConnectionError as e:  # quests.packages.urllib3.exceptions.NewConnectionError :
        print_error("Cannot connect to Orchestrator", e, None)
        print(e)
        exit()


def get_access_token():
    seconds = int(round(time.time()))
    global access_token_from_orch
    global token_expire_time
    if seconds < token_expire_time:
        return access_token_from_orch
    else:
        token_response = get_access_token_from_orch(username, password)
        token_response = json.loads(token_response)
        access_token_from_orch = token_response["access_token"]
        expires_in = token_response["access_token_expires_in"]
        seconds = int(round(time.time()))

        token_expire_time = seconds + expires_in - 10
        return access_token_from_orch

def get_customer_information(access_token, customer_name):
    # -----Getting customer information from Orchestrator BEGIN-----
    print_info("Getting Customer information from the Orchestrator")
    url_params = {'custName': customer_name}
    encoded_url_params = urllib.parse.urlencode(url_params)
    request_url = ORCH_URL + "/api/customer/views.ws?" + encoded_url_params
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token
    }
    try:
        response = requests.get(request_url, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            customer_response = response.json()
            customers = customer_response["listCustomers"]
            if len(customers) > 0:
                customer_json = customers[0]
                return customer_json
            else:
                print_error("No Customer with the name " + customer_name + " found for user.", None, None)
                return None
        else:
            print_error("Error while getting customer details: " + response.text, None, None)
            return None
    except requests.exceptions.RequestException as e:
        print_error("Error occurred while getting Customer information from the Orchestrator: ", e, None)
        exit()


def get_department_information(access_token, department_name, customer_id):
    # -----Getting department information from Orchestrator BEGIN-----
    print_info("Getting Department information from the Orchestrator")
    url_params = {'custId': str(customer_id), 'deptName': department_name}
    encoded_url_params = urllib.parse.urlencode(url_params)
    request_url = ORCH_URL + "/api/department/views.ws?" + encoded_url_params

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token
    }
    try:
        response = requests.get(request_url, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            department_response = response.json()
            departments = department_response["listDepartments"]
            if len(departments) > 0:
                department_json = departments[0]
                return department_json
            else:
                print_error("No Department with the name " + department_name + " found for user.", None, None)
                return None
        else:
            print_error("Error while getting Department details: " + response.text, None, None)
            return None
    except requests.exceptions.RequestException as e:
        print_error("Error occurred while getting Department information from the Orchestrator: ", e, None)
        exit()


def generate_report(access_token, customer_id, department_id, start_timestamp, end_timestamp, report_format, report_type):
    # -----Generating report at Orchestrator BEGIN-----
    print_info("Sending report generation request to Orchestrator")
    url_params = {'domainId': customer_id,
                  'subDomainId': department_id,
                  'startTimestamp':start_timestamp*1000,
                  'endTimestamp': end_timestamp*1000,
                  'reportType':report_type
                  }
    if report_format:
        url_params["reportFormat"] = report_format

    encoded_url_params = urllib.parse.urlencode(url_params)
    request_url = ORCH_URL + "/api/report/generate?" + encoded_url_params

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token
    }
    try:
        response = requests.get(request_url, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            json_response = response.json()
            return json_response["uniqueId"]
        else:
            print_error("Error while generating report with type " + report_type + ": " + response.text, None, None)
            return None
    except requests.exceptions.RequestException as e:
        print_error("Error occurred while generating report from the Orchestrator: ", e, None)
        exit()


def get_report_status(access_token, report_unique_id):
    # -----Getting report status from Orchestrator BEGIN-----
    print_info("Getting report generation status from Orchestrator")
    url_params = {'uniqueId': report_unique_id}

    encoded_url_params = urllib.parse.urlencode(url_params)
    request_url = ORCH_URL + "/api/report/status?" + encoded_url_params

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token
    }
    try:
        response = requests.get(request_url, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            json_response = response.json()
            return json_response["status"]
        else:
            print_error("Error while getting report status for report uniqueId " + report_unique_id + ": " + response.text, None, None)
            return None
    except requests.exceptions.RequestException as e:
        print_error("Error while getting report status for report uniqueId: ", e, None)
        exit()


def download_report_file(access_token, report_unique_id):
    # -----Getting report status from Orchestrator BEGIN-----
    print_info("Downloading report from Orchestrator")
    url_params = {'uniqueId': report_unique_id}

    encoded_url_params = urllib.parse.urlencode(url_params)
    request_url = ORCH_URL + "/api/report/download?" + encoded_url_params

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + access_token
    }
    try:
        response = requests.get(request_url, headers=headers, verify=CA_FILE)
        if response.status_code == 200:
            content_disposition = response.headers.get("Content-Disposition")
            file_name = content_disposition.split("filename=")[1]
            open(file_name, 'wb').write(response.content)
            return file_name
        else:
            print_error("Error while getting report status for report uniqueId " + report_unique_id + ": " + response.text, None, None)
            return None
    except requests.exceptions.RequestException as e:
        print_error("Error while getting report status for report uniqueId: ", e, None)
        exit()


def execute():
    print("----------------------------------------------------------------------------")
    customer_json = get_customer_information(get_access_token(), Arg.domain)
    if customer_json is None:
        print_warning("Domain " + Arg.domain + " not found for the user")
        return None

    customer_id = customer_json[FIELD_CUST_ID]

    department_json = get_department_information(get_access_token(), Arg.subDomain, customer_id)
    if department_json is None:
        print_warning("Subdomain  " + Arg.subDomain + " with domain " + Arg.domain + " not found for the user")
        return None

    department_id = department_json[FIELD_DEPT_ID]

    unique_id = generate_report(get_access_token(), customer_id, department_id, Arg.start_timestamp, Arg.end_timestamp, Arg.format, Arg.report_type)
    print("Unique Id to report generation is " + unique_id)
    status = get_report_status(get_access_token(), unique_id)
    print("Status of the Report generation process: " + unique_id)
    if status == REPORT_GENERATION_STATUS_INPROGRESS:
        while(status == REPORT_GENERATION_STATUS_INPROGRESS):
            status = get_report_status(get_access_token(), unique_id)
            print("Status of the Report generation process: " + status)
            time.sleep(REPORT_GENERATION_STATUS_CHECK_INTERVAL)

    if status == REPORT_GENERATION_STATUS_SUCCESS:
        file_name = download_report_file(get_access_token(), unique_id)
        print_info("Report generated successfully. Report file available at location :" + os.path.abspath(file_name))
    elif status == REPORT_GENERATION_STATUS_NO_DATA_FOUND:
        print("No data found for provided criteria for report generation.")
    else:
        print("Report generation failed at Orchestrator.")


def main():
	execute()
	print("Please refer log file '" + log_file + "' for more details.")


#---START-------------------------------------------------------------------------------------------------------------
main()	
