<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Insert Result</title>
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
  <h1>Insert Result</h1>
  <% 
    // Retrieve form data
    // Retrieve form data
    String username = request.getParameter("username");
    String cpf_cnpj = request.getParameter("cpf_cnpj");
    String email = request.getParameter("email");
    String hierarquia = request.getParameter("hierarquia");
    String senha = request.getParameter("senha");
    String Cidade = request.getParameter("Cidade");


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

      // Create SQL statement for first query
      String sql = "INSERT INTO public.usuariogeral (\"Username\", \"Email\", \"CPF/CNPJ\", \"Hierarquia\", \"Senha\") " +
                   "VALUES ('" + username + "', '" + email + "', '" + cpf_cnpj + "', '" + "0" + "', '" + senha + "')";

      statement = connection.prepareStatement(sql);

      // Execute the first insert statement
      rowsAffected = statement.executeUpdate();

      // Print the result message for the first query
  %>

  <% 
      // Create SQL statement for second query

      String sql2 = "INSERT INTO public.usuariolocadora (\"CNPJ\", \"Cidade\")" + " VALUES('"+ cpf_cnpj +"', '"+ Cidade +"')";

      statement = connection.prepareStatement(sql2);

      // Execute the second insert statement
      rowsAffected = statement.executeUpdate();

      // Print the result message for the second query
      if (rowsAffected > 0) {
  %>
        <p>Successful!</p>
  <% } else { %>
        <p>Failed.</p>
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
  <form action="adm.jsp">
    <button type="submit">Go back</button>
  </form>
</body>
</html>
