<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Cities with available bike rental shops</title>
</head>
<body>
  <h1>Cities with available bike rental shops</h1>
  <button style="position: absolute; top: 10px; right: 10px;" onclick="window.location.href='CidadesPT.jsp'">Português</button>
  <form action="AcharCidade.jsp" method="POST">
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
          String sql = "SELECT DISTINCT \"Cidade\" FROM usuariolocadora";

          Statement statement = connection.createStatement();

          // Execute the query
          ResultSet resultSet = statement.executeQuery(sql);
      %>
      <select name="cidade" id="cidade" required>
        <% // Process the result set
          while (resultSet.next()) {
            String cidade = resultSet.getString("Cidade");
        %>
            <option value="<%= cidade %>"><%= cidade %></option>
        <% 
          }
        %>
      </select>
      <button type="submit">Submit</button>
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
</body>
</html>
