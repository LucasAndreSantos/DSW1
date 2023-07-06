<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>User Emails</title>
</head>
<body>
<%
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userEmail = (String) session.getAttribute("userEmail");
    if (loggedInUser != null) {
%>
    <h1>User Emails</h1>
    <div style="text-align: right;">
      Welcome <%= loggedInUser %> 
    </div>
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
        String sql = "SELECT \"Email\" FROM usuariogeral";

        Statement statement = connection.createStatement();

        // Execute the query
        ResultSet resultSet = statement.executeQuery(sql);

        // Process the result set
        while (resultSet.next()) {
          String email = resultSet.getString("Email");
    %>
      <li><%= email %></li>
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
<%
    } else {
%>
    <h1>Error: Access Denied</h1>
    <p>You need to be logged in to view this page.</p>
    <a href="TelaLogin.jsp">Go to Login Page</a>
<%
    }
%>
</body>
</html>
