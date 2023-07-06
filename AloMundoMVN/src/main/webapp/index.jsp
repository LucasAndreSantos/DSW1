<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Bicycle Rental</title>
</head>
<style>
  .welcome {
    text-align: right;
  }

  .left-link {
    float: left;
    margin-right: 20px;
  }

  .top-right {
    position: absolute;
    top: 10px;
    right: 10px;
  }
</style>
<body>
  <h1>Bicycle Rental</h1>
  <div class="welcome">
    <% 
      String loggedInUser = (String) session.getAttribute("loggedInUser");
      if (loggedInUser != null) {
    %>
      <h2>Welcome <%= loggedInUser %></h2>
      <a href="adm.jsp">User Administration</a>
      <br>
      <a href="ListarAluguel.jsp">My Rentals</a>
    <% } else { %>
      <p>You need to <a href="TelaLogin.jsp">log in</a> to perform certain actions.</p>
    <% } %>
  </div>
  <div class="left-link">
    <a href="Locacao.jsp">Rent Bicycle</a>
    <br>
    <a href="ListaBicicletarias.jsp">Our Business Partners</a>
    <br>
    <a href="Cidades.jsp">Find a Shop in Your City!</a>
  </div>
  <div class="top-right">
    <form action="indexPT.jsp">
      <button type="submit">Português (BR)</button>
    </form>
  </div>
</body>
</html>
