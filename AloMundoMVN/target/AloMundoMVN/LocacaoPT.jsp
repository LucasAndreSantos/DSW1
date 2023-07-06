<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Locação de bicicletas</title>
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
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    // Redirect to login page if the user is not logged in
    if (loggedInUser == null) {
      response.sendRedirect("TelaLoginPT.jsp");
    } else {
  %>
    <h1>Locação de bicicletas</h1>
    <div class="welcome">
      <h2>Bem-vindo <%= loggedInUser %></h2>
    </div>
    <form action="CadastrarLocacaoPT.jsp" method="POST">
      <ul>
        <% 
          // Define database connection parameters
          String url = "jdbc:postgresql://localhost:5432/locadora"; 
          String username = "paladino";
          String password = "1234";

          // Create connection
          Connection connection = null;
          try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection(url, username, password);

            // Create SQL statement
            String sql = "SELECT \"Username\" " + "FROM usuariogeral " + "JOIN usuariolocadora ON \"CPF/CNPJ\" = \"CNPJ\"";


            Statement statement = connection.createStatement();

            // Execute the query
            ResultSet resultSet = statement.executeQuery(sql);
        %>
        <label for="cidade">Companhia:</label>
        <select name="cidade" id="cidade" required>
          <% // Process the result set
            while (resultSet.next()) {
              String user = resultSet.getString("Username");
          %>
              <option value="<%= user %>"><%= user %></option>
          <% 
            }
          %>
        </select>
      </br>
        <label for="datetime">Hora do aluguel:</label>
        <input type="datetime-local" name="datetime" id="datetime" required>
    </br>
        <button type="submit">Alugar</button>
        <% 
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
    </form>
  <% 
    }
  %>
</body>
<div class="top-right">
  <form action="Locacao.jsp">
    <button type="submit">English</button>
  </form>
</div>
</html>
