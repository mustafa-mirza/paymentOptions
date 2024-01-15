<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update-Product</title>
<style>
body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
}

.topnav {
  overflow: hidden;
  background-color: #333;
}

.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

.topnav a:hover {
  background-color: #ddd;
  color: black;
}

.topnav a.active {
  background-color: #04AA6D;
  color: white;
}
#formTable {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 50%;
  margin-left: 10%
}

input[type=text], input[type=number], select {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type=submit] {
  width: 100%;
  background-color: #4CAF50;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

input[type=submit]:hover {
  background-color: #45a049;
}
</style>
</head>
<body>
<div class="topnav">
  <a href="/view-homeDashboard">Home</a>
  <a class="active" href="/view-billingAddress">Billing Address</a>
  <a href="/view-bankCards">Bank Cards</a>
  <a href="/view-eWallets">E-Wallets</a>
  <a style="float:right" href="/logout">Logout</a>
</div>
<font><h3 align="center">Update Billing Address</h3></font>
<h6>${message}</h6>
   <div class="container" class="mx-auto" style="width: 100%;">
	 <form action="/update-address-details/${userAddress.id}" method="post">
	 		<table id="formTable">
	 		  <tr>
                <td>Address Type:</td>
                <td><select class = "input-style" name="type" id="Type" value = "${userAddress.type}" placeholder="Address Type" required>
                   <option value="Home">Home</option>
                   <option value="Office">Office</option>
                   <option value="Other">Other</option>
                 </select></td>
              </tr>
              <tr>
                <td>Address Line:</td>
                <td><input class = "input-style" type="text" name="addressLine" value = "${userAddress.addressLine}" placeholder="Address Line" required></td>
              </tr>
              <tr>
                <td>City:</td>
                <td><input type="text" name="City" value = "${userAddress.city}" placeholder="City" required></td>
              </tr>
              <tr>
                <td>State:</td>
                <td><input type="text" name="State" value = "${userAddress.state}" placeholder="State" required></td>
              </tr>
              <tr>
                <td>Country:</td>
                <td><input type="text" name="Country" value = "${userAddress.country}" placeholder="Country" required></td>
              </tr>
              <tr>
                <td>ZipCode:</td>
                <td><input type="number" name="zipCode" value = "${userAddress.zipCode}" placeholder="ZipCode" required></td>
              </tr>
              <tr>
                <td></td>
                <td>&nbsp;<input type="submit" value="Update" name="update-address-details" class="btn btn-success" class="mx-auto" style="width: 200px;"></td>
              </tr>
            </table>

	</form> 
   </div>
</body>
</html>