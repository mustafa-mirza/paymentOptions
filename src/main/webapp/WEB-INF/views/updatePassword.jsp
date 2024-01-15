<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="userHeader.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Add Product</title>
</head>
<body align="center">

	<p><font color="red">${error}</font></p>
	<p><font color="red">${update}</font></p>
 
  <div class="container" class="mx-auto" style="width: 200px;">
  
	<form action="update-password" method="post" enctype="multipart/form-data">
		<br>
		Old Password : 
		&nbsp;<input class = "input-style" type="password" name="oldPassword" placeholder="old password" required> <br> <br>
		
		New Password :
		&nbsp;<input type="password" name="newPassword" placeholder="New password" required> <br><br>
		
		Confirm Password :
		 &nbsp;<input type="password" name="confirmPassword" placeholder="confirm password" required> <br><br>
		 
		<input type="submit" value="update" name="update-password" class="btn btn-success" class="mx-auto" style="width: 200px;"><br><br>
	</form>
   </div>
</body>
</html>