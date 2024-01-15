<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
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
<body>
<div class="topnav">
  <a class="active" href="/view-homeDashboard">Home</a>
  <a href="#home">Home</a>
  <a href="/view-billingAddress">Billing Address</a>
  <a href="/view-bankCards">Bank Cards</a>
  <a href="/view-eWallets">E-Wallets</a>
</div>

	 <nav class="navbar navbar-expand-lg navbar-light bg-light">
  <div class="container-fluid">
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/view-homeDashboard">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/view-billingAddress">Billing Address</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/view-bankCards">Bank Cards</a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" aria-current="page" href="/view-eWallets">E-Wallets</a>
        </li>
      </ul>
      <form class="d-flex">

      <a class="nav-link">${username}</a>
       <a class="nav-link" href="/logout">Logout</a>

      </form>
    </div>
  </div>
</nav>


<script>
const search= () =>{
	
var a=document.getElementById("searching").value.toUpperCase();

let myTable=document.getElementById("t1");
let tr=myTable.getElementsByTagName('tr');

for(var i=0;i<tr.length;i++)
{
let td=tr[i].getElementsByTagName('td')[1];
if(td){
let textValue=td.textContent || td.innerHTML;
if(textValue.toUpperCase().indexOf(a)>-1){
tr[i].style.display="";
}
else{
tr[i].style.display="none";

}
}
}
}
</script>


</body>
</html>