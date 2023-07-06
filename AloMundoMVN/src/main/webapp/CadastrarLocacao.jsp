<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html>
<head>
  <title>Rental Added</title>
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
  <% 
    // Check if the user is logged in
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    // Retrieve the selected city and date from the request parameters
    String selectedCity = request.getParameter("cidade");
    String selectedDateTime = request.getParameter("datetime");

    // Redirect to login page if the user is not logged in
    if (loggedInUser == null) {
      response.sendRedirect("TelaLogin.jsp");
    } else {
      // Retrieve the CNPJ of the locadora using the selected username
      String locadoraCNPJ = null;

      // Retrieve the CPF of the logged-in user using the email
      String userCPF = null;

      // Define database connection parameters
      String url = "jdbc:postgresql://localhost:5432/locadora"; 
      String username = "paladino";
      String password = "1234";

      // Create connection
      Connection connection = null;
      try {
        Class.forName("org.postgresql.Driver");
        connection = DriverManager.getConnection(url, username, password);

        // Create SQL statement to retrieve CNPJ of the locadora
        String locadoraSQL = "SELECT \"CNPJ\" FROM usuariolocadora " + "JOIN usuariogeral ON \"CNPJ\" = \"CPF/CNPJ\" " + "WHERE \"Username\" = '" + selectedCity + "'";
        Statement locadoraStatement = connection.createStatement();
        ResultSet locadoraResult = locadoraStatement.executeQuery(locadoraSQL);
        if (locadoraResult.next()) {
          locadoraCNPJ = locadoraResult.getString("CNPJ");
        }

        // Create SQL statement to retrieve CPF of the logged-in user
        String cpfSQL = "SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Email\" = '" + loggedInUser + "'";
        Statement cpfStatement = connection.createStatement();
        ResultSet cpfResult = cpfStatement.executeQuery(cpfSQL);
        if (cpfResult.next()) {
          userCPF = cpfResult.getString("CPF/CNPJ");
        }

        LocalDateTime locacaoDateTime = LocalDateTime.parse(selectedDateTime);
        LocalDateTime horaLocacao = locacaoDateTime.withMinute(0).withSecond(0).withNano(0);

        // Calculate HoraDevolucao as one hour after HoraLocacao
        LocalDateTime horaDevolucao = horaLocacao.plusHours(1);

// Check if the user already has a rental during the selected hour
String checkUserSQL = "SELECT COUNT(*) AS count FROM locacoes " +
                      "WHERE \"CPF\" = '" + userCPF + "' " +
                      "AND (('" + horaLocacao + "' >= \"HoraLocacao\" AND '" + horaLocacao + "' < \"HoraDevolucao\") " +
                      "OR ('" + horaDevolucao + "' > \"HoraLocacao\" AND '" + horaDevolucao + "' <= \"HoraDevolucao\"))";
Statement checkUserStatement = connection.createStatement();
ResultSet checkUserResult = checkUserStatement.executeQuery(checkUserSQL);
if (checkUserResult.next()) {
  int count = checkUserResult.getInt("count");
  if (count > 0) {
    // User already has a rental during the selected hour, provide appropriate response
    out.println("<h1>Error</h1>");
    out.println("<p>You already have a rental during the selected hour.</p>");
    return;
  }
}

// Check if the locadora already has a rental during the selected hour
String checkLocadoraSQL = "SELECT COUNT(*) AS count FROM locacoes " +
                          "WHERE \"CNPJ\" = '" + locadoraCNPJ + "' " +
                          "AND (('" + horaLocacao + "' >= \"HoraLocacao\" AND '" + horaLocacao + "' < \"HoraDevolucao\") " +
                          "OR ('" + horaDevolucao + "' > \"HoraLocacao\" AND '" + horaDevolucao + "' <= \"HoraDevolucao\"))";
Statement checkLocadoraStatement = connection.createStatement();
ResultSet checkLocadoraResult = checkLocadoraStatement.executeQuery(checkLocadoraSQL);
if (checkLocadoraResult.next()) {
  int count = checkLocadoraResult.getInt("count");
  if (count > 0) {
    // Locadora already has a rental during the selected hour, provide appropriate response
    out.println("<h1>Error</h1>");
    out.println("<p>The selected locadora already has a rental during the selected hour.</p>");
    return;
  }
}


        // Insert the rental information into the locacoes table
        if (locadoraCNPJ != null && userCPF != null) {
          // Calculate HoraLocacao as the nearest hour

          // Create SQL statement to insert rental information
          String insertSQL = "INSERT INTO locacoes (\"CPF\", \"CNPJ\", \"HoraLocacao\", \"HoraDevolucao\") " +
                             "VALUES ('" + userCPF + "', '" + locadoraCNPJ + "', '" + horaLocacao + "', '" + horaDevolucao + "')";
          Statement insertStatement = connection.createStatement();

          // Execute the insert statement
          int rowsAffected = insertStatement.executeUpdate(insertSQL);

          if (rowsAffected > 0) {
            // Rental successfully added, provide appropriate response
            out.println("<h1>Rental Added</h1>");
            out.println("<p>Rental information:</p>");
            out.println("<p>Username: " + loggedInUser + "</p>");
            out.println("<p>Company: " + selectedCity + "</p>");
            out.println("<p>Date and Time: " + selectedDateTime + "</p>");
          } else {
            // Failed to add rental, provide appropriate response
            out.println("<h1>Error</h1>");
            out.println("<p>Failed to add rental.</p>");
          }

          // Close the insert statement
          insertStatement.close();
        }

      } catch (ClassNotFoundException | SQLException e) {
        // Print the error message
        out.println("<h1>Error</h1>");
        out.println("<p>An error occurred: " + e.getMessage() + "</p>");
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
    }
  %>
    <form action="index.jsp">
      <button type="submit">Go back</button>
    </form>
</body>
</html>
