<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<h1>Update Password</h1>
	
	<form action="updatePassword" method="post">
		<input type="text" name="password" placeholder="old password" required> <br>
		<input type="password" name="newPassword" placeholder="new password" required> <br>
		<input type="password" name="confirmPassword" placeholder="confirm password" required> <br>
		<input type="submit" value="update" name="update"><br>
	</form>
	
</body>
</html>