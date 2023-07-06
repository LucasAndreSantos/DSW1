<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html>
<head>
  <title>Lista de Alugueis</title>
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
      <h1>Lista de locações de <%= loggedInUser %></h1>
    <%
    // Retrieve locacoes based on the loggedInUser
    String url = "jdbc:postgresql://localhost:5432/locadora";
    String username = "paladino";
    String password = "1234";

    try {
      Connection connection = DriverManager.getConnection(url, username, password);

      // Prepare and execute the SQL query
      String query = "SELECT * FROM locacoes " +
        "JOIN usuariocliente ON locacoes.\"CPF\" = usuariocliente.\"CPF\" " +
        "JOIN usuariolocadora ON locacoes.\"CNPJ\" = usuariolocadora.\"CNPJ\" " +
        "JOIN usuariogeral ON (usuariocliente.\"CPF\" = usuariogeral.\"CPF/CNPJ\" OR usuariolocadora.\"CNPJ\" = usuariogeral.\"CPF/CNPJ\") " +
        "WHERE usuariogeral.\"Email\" = '" + loggedInUser + "'";

      Statement statement = connection.createStatement();
      ResultSet resultSet = statement.executeQuery(query);

      // Process and display the retrieved locacoes information
      while (resultSet.next()) {
        String cpf = resultSet.getString("CPF");
        String cnpj = resultSet.getString("CNPJ");
        LocalDateTime horaLocacao = resultSet.getTimestamp("HoraLocacao").toLocalDateTime();
        LocalDateTime horaDevolucao = resultSet.getTimestamp("HoraDevolucao").toLocalDateTime();
        int id = resultSet.getInt("id");

        // Display the locacoes information
        out.println("CPF do locador: " + cpf + "<br>");
        out.println("CNPJ do locatario: " + cnpj + "<br>");
        out.println("Hora de Locação: " + horaLocacao.toString() + "<br>");
        out.println("Hora de Devolução: " + horaDevolucao.toString() + "<br>");
        out.println("<br>");
      }

      // Close the database resources
      resultSet.close();
      statement.close();
      connection.close();
    } catch (SQLException e) {
      // Display the SQL error on the HTML page
      out.println("An error occurred while executing the SQL query:<br>");
      out.println(e.getMessage());
      e.printStackTrace();
    }

  }
%>
<!-- Rest of the HTML content -->
</body>
</html>
