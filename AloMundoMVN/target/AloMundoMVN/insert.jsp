<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Insert Result</title>
</head>
<body>
  <h1>Insert Result</h1>
  <% 
    // Retrieve form data
    String username = request.getParameter("username");
    String cpf_cnpj = request.getParameter("cpf_cnpj");
    String email = request.getParameter("email");
    String hierarquia = request.getParameter("hierarquia");
    String senha = request.getParameter("senha");

    // Database connection parameters
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    // Create connection
    Connection connection = null;
    PreparedStatement statement = null;
    int rowsAffected = 0;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);

      // Create SQL statement
      String sql = "INSERT INTO public.usuariogeral (\"Username\", \"Email\", \"CPF/CNPJ\", \"Hierarquia\", \"Senha\") " +
                   "VALUES ('" + username + "', '" + email + "', '" + cpf_cnpj + "', '" + hierarquia + "', '" + senha + "')";

      statement = connection.prepareStatement(sql);

      // Execute the insert statement
      rowsAffected = statement.executeUpdate();

      // Print the result message
      if (rowsAffected > 0) {
  %>
        <p>Registration successful!</p>
  <% } else { %>
        <p>Registration failed.</p>
  <% } %>
  <% 
    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Error: " + e.getMessage();
  %>
      <p><%= errorMessage %></p>
  <% 
    } finally {
      // Close the resources
      try {
          if (statement != null) {
              statement.close();
          }
          if (connection != null) {
              connection.close();
          }
      } catch (SQLException e) {
          e.printStackTrace();
      }
  } %>
</body>
</html>
