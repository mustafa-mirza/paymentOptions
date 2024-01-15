							<!-- this is login page -->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<title>Payment Options Vault</title>

<style>
body {
  background-color: #7aa8b7;
  font: 1em Helvetica;
}

#container {
  width: 100%;
  align: center
  margin-left: 30% auto;
  margin-top: 50px;
}

.whysign {
  float: left;
  background-color: white;
  width: 480px;
  height: 528px;
  border-radius: 0 5px 5px 0;
  padding-top: 20px;
  padding-right: 20px;
}
.whysignLogin
{
	float: left;
  background-color: white;
  width: 480px;
  height: 347px;
  border-radius: 0 5px 5px 0;
  padding-top: 20px;
  padding-right: 20px;
}
.whyforgotPassword
{
	float: left;
  background-color: white;
  width: 480px;
  height: 470px;
  border-radius: 0 5px 5px 0;
  padding-top: 20px;
  padding-right: 20px;
}
.signup {
  margin-left: 35%;
  width: 30%;
  padding: 30px 20px;
  background-color: white;
  text-align: center;
  border-radius: 5px;
}


[type=text],[type=email],[type=number],[type=password],select,option {
  display: block;
  margin: 0 auto;
  width: 80%;
  border: 0;
  border-bottom: 1px solid rgba(0,0,0,.2);
  height: 45px;
  line-height: 45px;
  margin-bottom: 10px;
  font-size: 1em;
  color: black;
}

[type=submit] {
  margin-top: 25px;
  width: 80%;
  border: 0;
  background-color: #7aa8b7;;
  border-radius: 5px;
  height: 48px;
  color: white;
  font-weight: 400;
  font-size: 1em;
}

[type='text']:focus {
  outline: none;
  border-color: #53CACE;
}

h1 {
  color: red;
  font-weight: 900;
  font-size: 2.5em;
}

p {
  color: rgba(0,0,0,.6);
  font-size: 1.2em;
  margin: 50px 0 50px 0;
}

span {
  font-size: .75em;
  background-color: white;
  padding: 2px 5px;
  color: rgba(0,0,0,.6);
  border-radius: 2px;
  box-shadow: 1px 1px 1px rgba(0,0,0,.3);
  margin: 5px;
}

span:hover {
  color: #53CACE;
}

p:nth-of-type(2) {
  font-size: 1em;
}

</style>




</head>
<body>
<div id='container'>
  <div class='signup'>
 <h2 style="color: #7aa8a1;">Payment Options Vault</h2>
    <form  method="post">
      <input type="text"  name="username" placeholder="Enter Username">
      <input type="password"  name="password" placeholder="Enter Password">
      <input type="submit" value="Login" name="login">
    </form>
    <h4>${message}<h4>
      <h5><a href="/register" name="register">SignUp</a></h5>
       <h5><a href="/forgetpassword" name="forgetpassword">Forgot Password?</a></h5>
  </div>
</div>

</body>
</html>