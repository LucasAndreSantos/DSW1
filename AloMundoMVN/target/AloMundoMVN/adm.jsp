<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>User administration</title>
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
  <h1>User administration</h1>
  <% 
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser == null || !"1".equals(userHierarchy)) {
  %>
    <h2>Error: Access Denied</h2>
    <p>You need to be logged in as a user with hierarchy 1 to view this page.</p>
    <a href="TelaLogin.jsp">Go to Login Page</a>
  <% 
    } else {
  %>
    <div class="welcome">
      <h2>Welcome <%= loggedInUser %></h2>
    </div>
    <form action="process.jsp" method="post">
      <% 
        // Database connection parameters
        String url = "jdbc:postgresql://localhost:5432/locadora"; 
        String dbUsername = "paladino"; // Replace with your database username
        String dbPassword = "1234"; // Replace with your database password

        // Create connection
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
          Class.forName("org.postgresql.Driver");
          connection = DriverManager.getConnection(url, dbUsername, dbPassword);

          // Query to retrieve usernames from usuariogeral for usuariolocadora
          String locadoraQuery = "SELECT \"Username\" FROM usuariogeral JOIN usuariolocadora ON \"CPF/CNPJ\" = \"CNPJ\"";
          statement = connection.prepareStatement(locadoraQuery);
          resultSet = statement.executeQuery();
      %>
          <label for="usuariolocadora">Company:</label>
          <select id="usuariolocadora" name="usuariolocadora">
      <% 
          while (resultSet.next()) {
            String username = resultSet.getString("Username");
      %>
            <option value="<%= username %>"><%= username %></option>
      <% } %>
          </select>
        </br>
          <button type="submit" name="action" value="consultLocadora">Consult</button>
          <button type="submit" formaction="CadastroLocadora.jsp" name="action" value="createLocadora">Create</button>
          <button type="submit" name="action" value="updateLocadora">Update</button>
          <button type="submit" name="action" value="deleteLocadora">Delete</button>

      <% 
          // Reset the result set and prepare query for usuariocliente
          resultSet.close();
          statement.close();

          String clienteQuery = "SELECT \"Username\" FROM usuariogeral JOIN usuariocliente ON \"CPF/CNPJ\" = \"CPF\"";
          statement = connection.prepareStatement(clienteQuery);
          resultSet = statement.executeQuery();
      %>
          <br><br>
          <label for="usuariocliente">Client:</label>
          <select id="usuariocliente" name="usuariocliente">
      <% 
          while (resultSet.next()) {
            String username = resultSet.getString("Username");
      %>
            <option value="<%= username %>"><%= username %></option>
      <% } %>
          </select>
          </br>
          <button type="submit" name="action" value="consultCliente">Consult</button>
          <button type="submit" formaction="CadastroCliente.jsp" name="action" value="createCliente">Create</button>
          <button type="submit" name="action" value="updateCliente">Update</button>
          <button type="submit" name="action" value="deleteCliente">Delete</button>
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
  </form>
  <% 
  }
  %>
  <div class="top-right">
    <form action="admPT.jsp">
      <button type="submit">Português (BR)</button>
    </form>
  </div>
  <form action="index.jsp">
    <button type="submit">Go back</button>
  </form>
</body>
</html>
