<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Bank Cards</title>

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
  <a class="active" href="/view-bankCards">Bank Cards</a>
  <a href="/view-eWallets">E-Wallets</a>
  <a style="float:right" href="/logout">Logout</a>
</div>
<h6>${message}</h6>
<font><h3 align="center">Bank Cards</h3></font>
	
	<div class="container my-2">
	<form action="search-bankCards" method="post">
	<br>
                      <table>
                        <tr>
                          <td>Search By Type:</td>
                          <td><select name="searchByType" id="searchByType">
                                                               <option value="All">All</option>
                                                               <option value="Credit Card">Credit Card</option>
                                                               <option value="Debit Card">Debit Card</option>
                                                             </select></td>
                                                             <td>&nbsp;<input type="submit" value="Search" style="width: 100px;"/></td>
                        </tr>
                      </table>
          </form>
            <a class="addbutton" aria-current="page" href="/add-bankCard">Add New Card</a>
            <br>
            <br>
            <table id="dataTable">
  				<tr>
                    <th scope="col">Bank</font></th>
  					<th scope="col">Type</font></th>
  					<th scope="col">Card Type</font></th>
  					<th scope="col">Card Number</font></th>
  					<th scope="col">Expiry Month</font></th>
  					<th scope="col">Expiry Year</font></th>
  					<th scope="col">Name On Card</font></th>
                    <th scope="col">Actions</font></th>
  				</tr>

  <c:forEach var="userBankCard" items="${userBankCardList}">
  					<tr>
  						<td >${userBankCard.bank}</td>
  						<td>${userBankCard.type}</td>
  						<td>${userBankCard.cardType}</td>
                          <td>${userBankCard.cardNumber}</td>
                          <td>${userBankCard.expiryMonth}</td>
                          <td>${userBankCard.expiryYear}</td>
                          <td>${userBankCard.nameOnCard}</td>
  						<td><a href="/update-bankCard/${userBankCard.id}"
  							name="update-bankCard" class="button" >Update</a>&nbsp;
  				 <a	href="/delete-bankCard/${userBankCard.id}" name="delete-bankCard"
  						class="button"	>Delete</a></td>

  					</tr>
  				</c:forEach>
</table>




</body>
</html>