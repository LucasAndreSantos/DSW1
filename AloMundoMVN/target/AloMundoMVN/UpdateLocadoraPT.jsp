<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Atualizar Informações da Empresa</title>
</head>
<body>
  <h1>Atualizar Informações da Empresa</h1>
  
  <% 
    // Parâmetros de conexão com o banco de dados
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Substitua pelo seu nome de usuário do banco de dados
    String dbPassword = "1234"; // Substitua pela sua senha do banco de dados

    // Criar conexão
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);
      statement = connection.createStatement();

      // Recuperar o parâmetro usuariolocadora da requisição
      String usuariolocadora = request.getParameter("usuariolocadora");

      // Recuperar informações da locadora do banco de dados
      String selectLocadoraQuery = "SELECT * FROM usuariolocadora INNER JOIN usuariogeral ON usuariolocadora.\"CNPJ\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariolocadora + "'";
      resultSet = statement.executeQuery(selectLocadoraQuery);

      if (resultSet.next()) {
        String username = resultSet.getString("Username");
        String email = resultSet.getString("Email");
        String cnpj = resultSet.getString("CNPJ");
        String cidade = resultSet.getString("Cidade");
        String senha = resultSet.getString("Senha");

        %>
        <form action="UpdaterLocadora.jsp" method="POST">
          <input type="hidden" name="action" value="updateLocadora">
          <input type="hidden" name="locadoraCNPJ" value="<%= cnpj %>">
          <label>Usuário:</label>
          <input type="text" name="username" value="<%= username %>" ><br>
          <label>Email:</label>
          <input type="text" name="email" value="<%= email %>"><br>
          <label>CNPJ da Empresa:</label>
          <input type="text" name="cnpj" value="<%= cnpj %>" readonly><br>
          <label>Cidade:</label>
          <input type="text" name="cidade" value="<%= cidade %>"><br>
          <label>Senha:</label>
          <input type="password" name="senha" value="<%= senha %>"><br>

          <input type="submit" value="Atualizar">
        </form>
        
        <p><a href="admPT.jsp">Voltar</a></p>
        <% // Exibir os campos do formulário com as informações atuais da locadora
      } else {
        %>
        <p>Locadora não encontrada</p>
        <p><a href="admPT.jsp">Voltar</a></p>
        <% // Exibir uma mensagem de erro se a entrada da locadora não for encontrada
      }

    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Erro: " + e.getMessage();
      %>
      <p><%= errorMessage %></p>
      <p><a href="admPT.jsp">Voltar</a></p>
      <% // Exibir ou tratar a mensagem de erro com um link clicável
    } finally {
      // Fechar os recursos
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
