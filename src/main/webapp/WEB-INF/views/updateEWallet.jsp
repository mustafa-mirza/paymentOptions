<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update eWallet</title>
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
<font><h3 align="center">Update e-Wallet</h3></font>

<h6>${message}</h6>
   <div class="container" class="mx-auto" style="width: 100%;">
	 <form action="/update-eWallet-details/${userEWallet.id}" method="post"><br><br>
			<br>
			<table id="formTable">
              <tr>
                <td>Provider:</td>
                <td><select class = "input-style" name="provider" value = "${userEWallet.provider}" placeholder="Provider" required>
                              <option value="PayPal">PayPal</option>
                              <option value="Amazon Pay">Amazon Pay</option>
                              <option value="Google Pay">Google Pay</option>
                              <option value="Apple Pay">Apple Pay</option>
                              <option value="Yandex">Yandex</option>
                              <option value="Qiwi">Qiwi</option>
                              <option value="Skrill">Skrill</option>
                            </select></td>
              </tr>
              <tr>
                <td>Wallet ID:</td>
                <td><input type="text" name="walletID" value = "${userEWallet.walletID}" placeholder="Wallet ID" required></td>
              </tr>
              <tr>
                <td>Wallet Balance:</td>
                <td><input type="text" name="walletBalance" value = "${userEWallet.walletBalance}" placeholder="Wallet Balance" required></td>
              </tr>
            <tr>
              <td></td>
              <td><input type="submit" value="Update" name="update-eWallet-details" class="btn btn-success" class="mx-auto" style="width: 200px;"></td>
            </tr>
            </table>
	</form>
   </div>
</body>
</html>