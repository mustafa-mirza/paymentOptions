<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Update Bank Card</title>
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
  <a class="active" href="/view-bankCards">Bank Cards</a>
  <a href="/view-eWallets">E-Wallets</a>
  <a style="float:right" href="/logout">Logout</a>
</div>
<font><h3 align="center">Update Bank Card</h3></font>
<h6>${message}</h6>
   <div class="container" class="mx-auto" style="width: 100%;">
	 <form action="/update-bankCard-details/${userBankCard.id}" method="post">
	 <table id="formTable">
       <tr>
         <td>Bank:</td>
         <td><input class = "input-style" type="text" name="bank" value = "${userBankCard.bank}" placeholder="Bank" required></td>
       </tr>
       <tr>
         <td>Type:</td>
         <td><select class = "input-style" name="type" value = "${userBankCard.type}" id="Type"">
              <option value="Credit Card">Credit Card</option>
              <option value="Debit Card">Debit Card</option>
            </select></td>
       </tr>
       <tr>
            <td>Card Type:</td>
            <td><select class = "input-style" name="cardType" id="CardType" value = "${userBankCard.cardType}" placeholder="Card Type">
                 <option value="Mastercard">Mastercard</option>
                 <option value="Visa">Visa</option>
                 <option value="American Express">American Express</option>
                 <option value="UnionPay">UnionPay</option>
                 <option value="JCB">JCB</option>
                 <option value="Maestro">Maestro</option>
               </select></td>
       </tr>
        <tr>
           <td>Card Number:</td>
           <td><input class = "input-style" type="text" name="cardNumber" value = "${userBankCard.cardNumber}" placeholder="Card Number" required></td>
        </tr>
        <tr>
           <td>Expiry Month:</td>
           <td><select class = "input-style" id="Expiry Month" placeholder="Expiry Month" name="expiryMonth" value = "${userBankCard.expiryMonth}" >
                <option name="" value="" style="display:none;">Select Expiry Month</option>
                <option name="January" value="January">January</option>
                <option name="February" value="February">February</option>
                <option name="March" value="March">March</option>
                <option name="April" value="April">April</option>
                <option name="May" value="May">May</option>
                <option name="June" value="June">June</option>
                <option name="July" value="July">July</option>
                <option name="August" value="August">August</option>
                <option name="September" value="September">September</option>
                <option name="October" value="October">October</option>
                <option name="November" value="November">November</option>
                <option name="December" value="December">December</option>
              </select></td>
        </tr>
        <tr>
           <td>Expiry Year:</td>
           <td><select class = "input-style" id="Expiry Year" placeholder="Expiry Year" name="expiryYear" value = "${userBankCard.expiryYear}">
               <option name="" value="" style="display:none;">Select Expiry Year</option>
               <option name="2022" value="2022">2022</option>
               <option name="2023" value="2023">2023</option>
               <option name="2024" value="2024">2024</option>
               <option name="2025" value="2025">2025</option>
               <option name="2026" value="2026">2026</option>
               <option name="2027" value="2027">2027</option>
             </select></td>
        </tr>
        <tr>
           <td>Name On Card:</td>
           <td><input class = "input-style" type="text" name="nameOnCard" value = "${userBankCard.nameOnCard}" placeholder="Name On Card" required></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" value="Update" name="update-bankCard-details" class="btn btn-success" class="mx-auto" style="width: 200px;"></td>
        </tr>
     </table>
	</form>
   </div>
</body>
</html>