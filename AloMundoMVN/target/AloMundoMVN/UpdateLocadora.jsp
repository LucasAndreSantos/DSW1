<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Update Company Information</title>
</head>
<body>
  <h1>Update Company Information</h1>
  
  <% 
    // Database connection parameters
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    // Create connection
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);
      statement = connection.createStatement();

      // Retrieve the usuariolocadora parameter from the request
      String usuariolocadora = request.getParameter("usuariolocadora");

      // Retrieve locadora information from the database
      String selectLocadoraQuery = "SELECT * FROM usuariolocadora INNER JOIN usuariogeral ON usuariolocadora.\"CNPJ\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariolocadora + "'";
      resultSet = statement.executeQuery(selectLocadoraQuery);

      if (resultSet.next()) {
        String username = resultSet.getString("Username");
        String email = resultSet.getString("Email");
        String cnpj = resultSet.getString("CNPJ");
        String cidade = resultSet.getString("Cidade");
        String senha = resultSet.getString("Senha");

        %>
        <form action="UpdaterLocadora.jsp" method="POST">
          <input type="hidden" name="action" value="updateLocadora">
          <input type="hidden" name="locadoraCNPJ" value="<%= cnpj %>">
          <label>Username:</label>
          <input type="text" name="username" value="<%= username %>" ><br>
          <label>Email:</label>
          <input type="text" name="email" value="<%= email %>"><br>
          <label>Company Registration:</label>
          <input type="text" name="cnpj" value="<%= cnpj %>" readonly><br>
          <label>City:</label>
          <input type="text" name="cidade" value="<%= cidade %>"><br>
          <label>password:</label>
          <input type="password" name="senha" value="<%= senha %>"><br>

          <input type="submit" value="Update">
        </form>
        
        <p><a href="adm.jsp">Go back</a></p>
        <% // Display the form fields with the current locadora information
      } else {
        %>
        <p>Locadora not found</p>
        <p><a href="adm.jsp">Go back</a></p>
        <% // Display an error message if the locadora entry is not found
      }

    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Error: " + e.getMessage();
      %>
      <p><%= errorMessage %></p>
      <p><a href="adm.jsp">Go back</a></p>
      <% // Display or handle the error message with a clickable link
    } finally {
      // Close the resources
      try {
        if (resultSet != null) {
          resultSet.close();
        }
        if (statement != null) {
          statement.close();
        }
        if (connection != null) {
          connection.close();
        }
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  %>
</body>
</html>
