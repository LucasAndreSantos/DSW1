<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login Result</title>
</head>
<body>
<%
    // Get the submitted username and password from the request
    String submittedUsername = request.getParameter("email");
    String submittedPassword = request.getParameter("password");

    // Set up the database connection
    String url = "jdbc:postgresql://localhost:5432/locadora";
    String dbUsername = "paladino"; // Replace with your database username
    String dbPassword = "1234"; // Replace with your database password

    boolean isValidUser = false; // Flag to track if the user is valid
    String userHierarquia = null; // Variable to store the user's hierarchy

    try {
        // Load the JDBC driver
        Class.forName("org.postgresql.Driver");

        // Establish the database connection
        Connection connection = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Prepare the SQL query to check the username and password
        String sql = "SELECT * FROM usuariogeral WHERE \"Email\" = ? AND \"Senha\" = ?";
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setString(1, submittedUsername);
        statement.setString(2, submittedPassword);

        // Execute the query
        ResultSet resultSet = statement.executeQuery();

        // Check if the query returned a result
        if (resultSet.next()) {
            // If the result set is not empty, the username and password are valid
            // Get the user's hierarchy from the result set
            userHierarquia = resultSet.getString("Hierarquia");

            // Set the loggedInUser and userHierarchy attributes in the session
            session.setAttribute("loggedInUser", submittedUsername);
            session.setAttribute("userHierarchy", userHierarquia);

            isValidUser = true; // Set the flag to true
            // Redirect to the protected page
            response.sendRedirect("index.jsp");
        }

        // Close the database resources
        resultSet.close();
        statement.close();
        connection.close();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<%
    // If the user is not valid, display an error message
    if (!isValidUser) {
%>
    <h2>Invalid username or password. Please try again.</h2>
    <a href="TelaLogin.jsp">Go back to login page</a>
<%
    }
%>

</body>
</html>
