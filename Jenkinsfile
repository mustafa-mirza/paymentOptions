pipeline {
    agent any
    tools{
        maven 'mvn3.9.6'
    }
    stages{
        stage('Build Maven'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/mustafa-mirza/paymentOptions']]])
                sh 'mvn clean install'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t mustafamirza/paymentoptions .'
                }
            }
        }
        stage('Push image to Hub'){
            steps{
                script{
                   withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                   sh 'docker login -u mustafamirza -p ${dockerhubpwd}'

}
                   sh 'docker push mustafamirza/paymentoptions'
                }
            }
        }
        stage('Deploy to k8s'){
            steps{
                script{
                    kubernetesDeploy (configs: 'deploymentservice.yaml',kubeconfigId: 'k8s01config')
                    sleep(time: 10, unit: "SECONDS")
                }
            }
        }
        
        stage('Access First URL') {
            steps {
                script {
                    def firstUrl = 'http://192.168.103.101:30000'
                    sh "curl -sS $firstUrl"
                }
            }
        }

        stage('Access and Register at Second URL') {
            steps {
                script {
                    def registerUrl = 'http://192.168.103.101:30000/register'
                    def username = 'admin'
                    def email = 'admin@avocadosys.com'
                    def password = 'avcd'
                    def confirmPassword = 'avcd'
                    def mobile = '9999999999'

                    def registerCommand = """
                        curl -sS -X POST -H "Content-Type: application/json" -d '{
                            "username": "${username}",
                            "email": "${email}",
                            "password": "${password}",
                            "confirmPassword": "${confirmPassword}",
                            "mobile": "${mobile}"
                        }' ${registerUrl}
                    """

                    sh registerCommand
                }
            }
        }

        // Add more stages as needed

         stage('Generate Report'){
            steps{
                script{
                    sh 'python3 reportGenerator.py --fromdate "2024-01-15 00:00:01" --domain ACME --subdomain IT --reportType application_model_architecture'
                }
            }
        }
    }
}
