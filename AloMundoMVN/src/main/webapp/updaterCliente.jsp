<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Process Update Cliente</title>
</head>
<body>
  <h1>Process Update Cliente</h1>
  
  <% 
    // Database connection parameters
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    // Create connection
    Connection connection = null;
    PreparedStatement clienteStatement = null;
    PreparedStatement geralStatement = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);

      // Retrieve form data from the request
      String action = request.getParameter("action");
      String clienteCPF = request.getParameter("clienteCPF");
      String username = request.getParameter("username");
      String email = request.getParameter("email");
      String telefone = request.getParameter("telefone");
      String dataNascimento = request.getParameter("dataNascimento");
      String senha = request.getParameter("senha");
      String hierarquia = request.getParameter("hierarquia");
      String sexo = request.getParameter("sexo");

      // Prepare SQL statements
      String updateClienteQuery = "UPDATE usuariocliente SET \"Telefone\" = '" + telefone + "',\"Sexo\" = '" + sexo + "', \"Data de Nascimento\" = '" + dataNascimento + "' WHERE \"CPF\" = '" + clienteCPF + "'";
      clienteStatement = connection.prepareStatement(updateClienteQuery);
      
      String updateGeralQuery = "UPDATE usuariogeral SET \"Username\" = '" + username + "', \"Email\" = '" + email + "', \"Senha\" = '" + senha + "', \"Hierarquia\" = '" + hierarquia + "' WHERE \"CPF/CNPJ\" = '" + clienteCPF + "'";

      geralStatement = connection.prepareStatement(updateGeralQuery);

      // Execute the update queries
      int rowsUpdatedCliente = clienteStatement.executeUpdate();
      int rowsUpdatedGeral = geralStatement.executeUpdate();

      if (rowsUpdatedCliente > 0 && rowsUpdatedGeral > 0) {
        out.println("<p>Cliente updated successfully</p>");
      } else {
        out.println("<p>Failed to update cliente</p>");
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
        if (clienteStatement != null) {
          clienteStatement.close();
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
