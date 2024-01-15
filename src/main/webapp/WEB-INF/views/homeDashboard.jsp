<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>Payment Options Vault</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
	crossorigin="anonymous">
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
</style>
</head>
<body>
<div class="topnav">
  <a class="active" href="/view-homeDashboard">Home</a>
  <a href="/view-billingAddress">Billing Address</a>
  <a href="/view-bankCards">Bank Cards</a>
  <a href="/view-eWallets">E-Wallets</a>
  <a style="float:right" href="/logout">Logout</a>
</div>
<h6>${message}</h6>
<div class="text-center" >
			<font><h4 align="center">Payment Options Summary</h4></font>
            <br><br>

    <div class="d-flex justify-content-center flex-nowrap">
            <div class="card" style="width: 18rem; background-color: #7aa8b7;">
  <div class="card-body">
    <h5 class="card-title">Total Billing Addresses</h5>
    <h2 class="card-text">${addressCount}</h2>
  </div>
</div>&nbsp;&nbsp;&nbsp;&nbsp;


<div class="card" style="width: 18rem; background-color: #7aa8b7;">
  <div class="card-body">
    <h5 class="card-title">Total Bank Cards</h5>
    <h2 class="card-text">${bankCardCount}</h2>
  </div>
</div>&nbsp;&nbsp;&nbsp;&nbsp;


<div class="card" style="width: 18rem; background-color: #7aa8b7;">
  <div class="card-body">
    <h5 class="card-title">Total eWallets</h5>
    <h2 class="card-text"> ${eWalletCount}</h2>
  </div>
</div>
</div>
</body>
</html>