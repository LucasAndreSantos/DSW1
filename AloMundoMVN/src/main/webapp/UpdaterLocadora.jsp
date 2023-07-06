<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Process Update Locadora</title>
</head>
<body>
  <h1>Process Update Locadora</h1>
  
  <% 
    // Database connection parameters
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    // Create connection
    Connection connection = null;
    PreparedStatement locadoraStatement = null;
    PreparedStatement geralStatement = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);

      // Retrieve form data from the request
      String action = request.getParameter("action");
      String locadoraCNPJ = request.getParameter("locadoraCNPJ");
      String username = request.getParameter("username");
      String email = request.getParameter("email");
      String cidade = request.getParameter("cidade");
      String senha = request.getParameter("senha");

      // Prepare SQL statements
      String updateLocadoraQuery = "UPDATE usuariolocadora SET \"Cidade\" = '" + cidade + "' WHERE \"CNPJ\" = '" + locadoraCNPJ + "'";
      locadoraStatement = connection.prepareStatement(updateLocadoraQuery);
      
      String updateGeralQuery = "UPDATE usuariogeral SET \"Username\" = '" + username + "', \"Email\" = '" + email + "', \"Senha\" = '" + senha + "' WHERE \"CPF/CNPJ\" = '" + locadoraCNPJ + "'";
      geralStatement = connection.prepareStatement(updateGeralQuery);

      // Execute the update queries
      int rowsUpdatedLocadora = locadoraStatement.executeUpdate();
      int rowsUpdatedGeral = geralStatement.executeUpdate();

      if (rowsUpdatedLocadora > 0 && rowsUpdatedGeral > 0) {
        out.println("<p>Locadora updated successfully</p>");
      } else {
        out.println("<p>Failed to update locadora</p>");
      }

      // Redirect back to the admin page
      response.sendRedirect("adm.jsp");

    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Error: " + e.getMessage();
      out.println("<p>" + errorMessage + "</p>");
    } finally {
      // Close the resources
      try {
        if (locadoraStatement != null) {
          locadoraStatement.close();
        }
        if (geralStatement != null) {
          geralStatement.close();
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
