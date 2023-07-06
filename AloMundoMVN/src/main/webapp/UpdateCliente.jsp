<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Update Cliente</title>
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
  <h1>Update Client Information</h1>
  
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

      // Retrieve the usuariocliente parameter from the request
      String usuariocliente = request.getParameter("usuariocliente");

      // Retrieve cliente information from the database
      String selectClienteQuery = "SELECT * FROM usuariocliente INNER JOIN usuariogeral ON usuariocliente.\"CPF\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariocliente + "'";
      resultSet = statement.executeQuery(selectClienteQuery);

      if (resultSet.next()) {
        String username = resultSet.getString("Username");
        String email = resultSet.getString("Email");
        String cpf = resultSet.getString("CPF/CNPJ");
        String sexo = resultSet.getString("Sexo");
        String telefone = resultSet.getString("Telefone");
        Date dataNascimento = resultSet.getDate("Data de Nascimento");
        int hierarquia = resultSet.getInt("Hierarquia");
        String senha = resultSet.getString("Senha");

        %>
        <form action="updaterCliente.jsp" method="POST">
          <input type="hidden" name="action" value="updateCliente">
          <input type="hidden" name="clienteCPF" value="<%= cpf %>">
          <label>Username:</label>
          <input type="text" name="username" value="<%= username %>"><br>
          <label>Email:</label>
          <input type="text" name="email" value="<%= email %>"><br>
          <label>Document:</label>
          <input type="text" name="cpf" value="<%= cpf %>" readonly><br>
          <label>Gender:</label>
          <select name="sexo">
            <option value="Masculino" <%= (sexo.equals("Masculino")) ? "selected" : "" %>>Masculine</option>
            <option value="Feminino" <%= (sexo.equals("Feminino")) ? "selected" : "" %>>Feminine</option>
          </select><br>
          <label>Phone:</label>
          <input type="number" name="telefone" value="<%= telefone %>"><br>
          <label>Birthday</label>
          <input type="date" name="dataNascimento" value="<%= dataNascimento %>"><br>
          <label>Hierarchy:</label>
          <select name="hierarquia">
            <option value="0" <%= (hierarquia == 0) ? "selected" : "" %>>User</option>
            <option value="1" <%= (hierarquia == 1) ? "selected" : "" %>>Admin</option>
          </select><br>
          <label>Password:</label>
          <input type="password" name="senha" value="<%= senha %>"><br>

          <input type="submit" value="Update">
        </form>
        
        <p><a href="adm.jsp">Go back</a></p>
        <% // Display the form fields with the current cliente information
      } else {
        %>
        <p>Client not found</p>
        <p><a href="adm.jsp">Go back</a></p>
        <% // Display an error message if the cliente entry is not found
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
