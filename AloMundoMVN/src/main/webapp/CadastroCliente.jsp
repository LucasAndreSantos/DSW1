<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Client Registration</title>
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
</head>
<body>
  <% 
    // Check if the user is logged in and has a hierarchy of 1
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser != null && "1".equals(userHierarchy)) {
  %>
    <h1>Client Registration</h1>
    <div class="welcome">
      Welcome <%= loggedInUser %> 
    </div>
    <form action="InsertCliente.jsp" method="post">
      <label for="username">Username:</label>
      <input type="text" name="username" id="username" required><br>
      
      <label for="cpf_cnpj">Document:</label>
      <input type="text" name="cpf_cnpj" id="cpf_cnpj" required><br>
      
      <label for="email">Email:</label>
      <input type="email" name="email" id="email" required><br>

      <label for="data">Bithday:</label>
      <input type="date" name="datanascimento" id="datanascimento" required><br>

      <label for="telefone">Phone:</label>
      <input type="number" name="telefone" id="telefone" required><br>
      
      <label for="Sexo">Gender:</label>
      <select name="Sexo" id="Sexo" required>
        <option value="Masculino">Masculine</option>
        <option value="Feminino">Feminine</option>
      </select><br>

      <label for="hierarquia">Hierarchy:</label>
      <select name="hierarquia" id="hierarquia" required>
        <option value="1">Admin</option>
        <option value="0">User</option>
      </select><br>
      
      <label for="senha">Password:</label>
      <input type="password" name="senha" id="senha" required><br>
      
      <button type="submit">Register</button>
    </form>
  <% 
    } else {
  %>
    <h1>Error: Access Denied</h1>
    <p>You need to be logged in as a user with hierarchy 1 to view this page.</p>
    <a href="TelaLogin.jsp">Go to Login Page</a>
  <% 
    }
  %>
  <div class="top-right">
    <form action="CadastroClientePT.jsp">
      <button type="submit">Português (BR)</button>
    </form>
  </div>
  <form action="adm.jsp">
    <button type="submit">Go Back</button>
  </form>
</body>
</html>
