<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>eWallets</title>
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
  <a href="/view-billingAddress">Billing Address</a>
  <a href="/view-bankCards">Bank Cards</a>
  <a class="active" href="/view-eWallets">E-Wallets</a>
  <a style="float:right" href="/logout">Logout</a>
</div>
<h6>${message}</h6>
<font><h3 align="center">e-Wallets</h3></font>
			<br>
	<div class="container my-2">
	<a class="addbutton" aria-current="page" href="/add-eWallet">Add New eWallet</a>
		<br>

		<h5>${message}</h5>
		<h5>${msg}</h5>
		<table id="dataTable">
				<tr>
					<th scope="col">Service Provider</font></th>
					<th scope="col">Wallet ID</font></th>
					<th scope="col">Wallet Balance</font></th>
					<th scope="col">Actions</font></th>
				</tr>
				<c:forEach var="userEWallet" items="${userEWalletList}">
					<tr>
						<td>${userEWallet.provider}</td>
						<td>${userEWallet.walletID}</td>
						<td>${userEWallet.walletBalance}</td>
						<td><a href="/update-eWallet/${userEWallet.id}"
							name="update-eWallet" class="button" >Update</a>
							
				 <a	href="/delete-eWallet/${userEWallet.id}" name="delete-eWallet"
						class="button"	>Delete</a></td>

					</tr>
				</c:forEach>
		</table>
</body>
</html>