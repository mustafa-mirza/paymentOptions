<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Billing Addresses</title>

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

#dataTable {
  font-family: Arial, Helvetica, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

#dataTable td, #dataTable th {
  border: 1px solid #ddd;
  padding: 8px;
}

#dataTable tr:nth-child(even){background-color: #f2f2f2;}

#dataTable tr:hover {background-color: #ddd;}

#dataTable th {
  padding-top: 12px;
  padding-bottom: 12px;
  text-align: left;
  background-color: #04AA6D;
  color: white;
}

input[type=text], select {
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

 .button {
        display: inline-block;
        padding: 5px 20px;
        text-align: center;
        text-decoration: none;
        color: #ffffff;
        background-color: #7aa8b7;
        border-radius: 6px;
        outline: none;
        margin-right: 0.5em;
      }
  .button:hover{
                 background-color: #45a049;
               }
.addbutton {
        display: inline-block;
        padding: 5px 20px;
        text-align: center;
        text-decoration: none;
        color: #ffffff;
        background-color: #7aa8b7;
        border-radius: 6px;
        outline: none;
        float: right;
        margin-right: 0.5em;
      }
  .addbutton:hover{
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
<h6>${message}</h6>
<font><h3 align="center">Billing Addresses</h3></font>
	
	<div class="container my-2">
		<form action="search-address" method="post">
    	<br>
                          <table>
                            <tr>
                              <td>Search Address:</td>
                              <td><input class = "input-style" type="text" name="addressLine" placeholder="Address Line"></td>
                                                                 <td>&nbsp;<input type="submit" value="Search" style="width: 100px;"/></td>
                            </tr>
                          </table>
              </form>
			<br>
	<a class="addbutton" aria-current="page" href="/add-billingAddress">Add New Address</a>
		<br>

		<h5>${message}</h5>
		<h5>${msg}</h5>
		<table id="dataTable">
				<tr>
				    <th scope="col">Address Type</font></th>
					<th scope="col">Address Line</font></th>
					<th scope="col">City</font></th>
					<th scope="col">State</font></th>
					<th scope="col">Country</font></th>
					<th scope="col">ZipCode</font></th>
					<th scope="col">Actions</font></th>
				
				</tr>
				<c:forEach var="userAddress" items="${userAddressList}">
					<tr>
					    <td>${userAddress.type}</td>
						<td>${userAddress.addressLine}</td>
						<td>${userAddress.city}</td>
						<td>${userAddress.state}</td>
                        <td>${userAddress.country}</td>
                        <td>${userAddress.zipCode}</td>
						<td><a href="/update-address/${userAddress.id}"
							name="update-address" class="button" >Update</a>
							
				 <a	href="/delete-address/${userAddress.id}" name="delete-address"
						class="button"	>Delete</a></td>

					</tr>
				</c:forEach>
		</table>




</body>
</html>