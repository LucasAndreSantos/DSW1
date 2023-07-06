<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Process Form</title>
</head>
<body>
  <h1>Processing Form Data</h1>
  
  <% 
    // Database connection parameters
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    // Create connection
    Connection connection = null;
    Statement statement = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);
      statement = connection.createStatement();

      // Retrieve form data
      String action = request.getParameter("action");
      String usuariolocadora = request.getParameter("usuariolocadora");
      String usuariocliente = request.getParameter("usuariocliente");

      if (action.equals("consultCliente")) {
        String selectClienteQuery = "SELECT * FROM usuariocliente INNER JOIN usuariogeral ON usuariocliente.\"CPF\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariocliente + "'";
        ResultSet clienteResult = statement.executeQuery(selectClienteQuery);

        if (clienteResult.next()) {
          %>
          <h2>Cliente Information</h2>
          <p>Username: <%= clienteResult.getString("Username") %></p>
          <p>Email: <%= clienteResult.getString("Email") %></p>
          <p>CPF/CNPJ: <%= clienteResult.getString("CPF/CNPJ") %></p>
          <p>Hierarquia: <%= clienteResult.getInt("Hierarquia") %></p>
          <p>Sexo: <%= clienteResult.getString("Sexo") %></p>
          <p>Telefone: <%= clienteResult.getString("Telefone") %></p>
          <p>Data de Nascimento: <%= clienteResult.getDate("Data de Nascimento") %></p>
          <% // Display the desired information from the cliente entry
        } else {
          %>
          <p>Cliente not found</p>
          <% // Display an error message if the cliente entry is not found
        }
      }

      if (action.equals("consultLocadora")) {
        String selectLocadoraQuery = "SELECT * FROM usuariolocadora INNER JOIN usuariogeral ON usuariolocadora.\"CNPJ\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariolocadora + "'";
        ResultSet locadoraResult = statement.executeQuery(selectLocadoraQuery);

        if (locadoraResult.next()) {
          %>
          <h2>Locadora Information</h2>
          <p>Username: <%= locadoraResult.getString("Username") %></p>
          <p>Email: <%= locadoraResult.getString("Email") %></p>
          <p>CPF/CNPJ: <%= locadoraResult.getString("CPF/CNPJ") %></p>
          <p>Hierarquia: <%= locadoraResult.getInt("Hierarquia") %></p>
          <p>CNPJ: <%= locadoraResult.getString("CNPJ") %></p>
          <p>Cidade: <%= locadoraResult.getString("Cidade") %></p>
          <% // Display the desired information from the locadora entry
        } else {
          %>
          <p>Locadora not found</p>
          <% // Display an error message if the locadora entry is not found
        }
      }


      if (action.equals("updateLocadora")) {
        response.sendRedirect("UpdateLocadora.jsp?usuariolocadora=" + usuariolocadora);




      } else if (action.equals("deleteLocadora")) {
        String deleteLocacoesQuery = "DELETE FROM locacoes WHERE \"CNPJ\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "')";
        int rowsAffectedLocacoes = statement.executeUpdate(deleteLocacoesQuery);

        String deleteLocadoraQuery = "DELETE FROM usuariolocadora WHERE \"CNPJ\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariolocadora + "')";
        int rowsAffectedLocadora = statement.executeUpdate(deleteLocadoraQuery);

        String deleteUsuariogeralQuery = "DELETE FROM usuariogeral WHERE \"Username\" = '" + usuariolocadora + "'";
        int rowsAffectedUsuariogeral = statement.executeUpdate(deleteUsuariogeralQuery);

        if (rowsAffectedLocadora > 0 && rowsAffectedUsuariogeral > 0) {
          %>
          <p>Deletion Successful</p> 
          <p><a href="adm.jsp">Go back</a></p>
          <% // You can redirect or display a success message with a clickable link
        } else {
          %>
          <p>Deletion Error</p> 
          <p><a href="adm.jsp">Go back</a></p>
          <% // You can redirect or display an error message with a clickable link
        }
      } else if (action.equals("updateCliente")) {
        response.sendRedirect("UpdateCliente.jsp?usuariocliente=" + usuariocliente);
      } else if (action.equals("deleteCliente")) {
        String deleteLocacoesQuery = "DELETE FROM locacoes WHERE \"CPF\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "')";
        int rowsAffectedLocacoes = statement.executeUpdate(deleteLocacoesQuery);

        String deleteClienteQuery = "DELETE FROM usuariocliente WHERE \"CPF\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "')";
        int rowsAffectedCliente = statement.executeUpdate(deleteClienteQuery);

        String deleteUsuariogeralQuery = "DELETE FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "'";
        int rowsAffectedUsuariogeral = statement.executeUpdate(deleteUsuariogeralQuery);
        

        if (rowsAffectedCliente > 0 && rowsAffectedUsuariogeral > 0) {
          %>
          <p>Deletion Successful</p> 
          <p><a href="adm.jsp">Go back</a></p>
          <% // You can redirect or display a success message with a clickable link
        } else {
          %>
          <p>Deletion Error</p> 
          <p><a href="adm.jsp">Go back</a></p>
          <% // You can redirect or display an error message with a clickable link
        }
      } else {
        // Handle invalid or unsupported action
        // Display an error message or redirect to an error page
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
