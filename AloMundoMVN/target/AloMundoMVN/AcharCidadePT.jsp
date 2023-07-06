<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Bicicletarias da cidade</title>
</head>
<body>
  <h1>Bicicletarias da cidade</h1>
  <ul>
    <% 
      // Define database connection parameters
      String url = "jdbc:postgresql://localhost:5432/locadora"; 
      String username = "paladino";
      String password = "1234";
      String cidade = request.getParameter("cidade");
    %>
      <p>Cidade: <%= cidade %></p>
    <% 
      // Create connection
      Connection connection = null;
      try {
        Class.forName("org.postgresql.Driver");
        connection = DriverManager.getConnection(url, username, password);

        // Create SQL statement
        String sql = "SELECT \"Username\" FROM usuariogeral JOIN usuariolocadora ul ON \"CPF/CNPJ\" = ul.\"CNPJ\" WHERE ul.\"Cidade\"  = '" + cidade + "'";

        Statement statement = connection.createStatement();

        // Execute the query
        ResultSet resultSet = statement.executeQuery(sql);

        // Process the result set
        while (resultSet.next()) {
          String user = resultSet.getString("Username");
    %>
      <li><%= user %></li>
    <% 
        }
      } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
      } finally {
        // Close the connection
        if (connection != null) {
          try {
            connection.close();
          } catch (SQLException e) {
            e.printStackTrace();
          }
        }
      }
    %>
  </ul>
  <button onclick="window.location.href='indexPT.jsp'">Voltar</button>
</body>
</html>
