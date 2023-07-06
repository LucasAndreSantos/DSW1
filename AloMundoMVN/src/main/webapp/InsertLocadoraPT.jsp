<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Inserir Resultado</title>
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
  <h1>Inserir Resultado</h1>
  <% 
    // Recuperar dados do formulário
    String username = request.getParameter("username");
    String cpf_cnpj = request.getParameter("cpf_cnpj");
    String email = request.getParameter("email");
    String hierarquia = request.getParameter("hierarquia");
    String senha = request.getParameter("senha");
    String Cidade = request.getParameter("Cidade");


    // Parâmetros de conexão com o banco de dados
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Substitua pelo seu nome de usuário do banco de dados
    String dbPassword = "1234"; // Substitua pela sua senha do banco de dados

    // Criar conexão
    Connection connection = null;
    PreparedStatement statement = null;
    int rowsAffected = 0;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);

      // Criar declaração SQL para a primeira consulta
      String sql = "INSERT INTO public.usuariogeral (\"Username\", \"Email\", \"CPF/CNPJ\", \"Hierarquia\", \"Senha\") " +
                   "VALUES ('" + username + "', '" + email + "', '" + cpf_cnpj + "', '" + "0" + "', '" + senha + "')";

      statement = connection.prepareStatement(sql);

      // Executar a primeira instrução de inserção
      rowsAffected = statement.executeUpdate();

      // Imprimir a mensagem de resultado para a primeira consulta
  %>
  <% 
      // Criar declaração SQL para a segunda consulta

      String sql2 = "INSERT INTO public.usuariolocadora (\"CNPJ\", \"Cidade\")" + " VALUES('"+ cpf_cnpj +"', '"+ Cidade +"')";

      statement = connection.prepareStatement(sql2);

      // Executar a segunda instrução de inserção
      rowsAffected = statement.executeUpdate();

      // Imprimir a mensagem de resultado para a segunda consulta
      if (rowsAffected > 0) {
  %>
        <p>bem-sucedido!</p>
  <% } else { %>
        <p>Falha</p>
  <% } %>

  <% 
    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Erro: " + e.getMessage();
  %>
      <p><%= errorMessage %></p>
  <% 
    } finally {
      // Fechar os recursos
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
  } %>
  <form action="admPT.jsp">
    <button type="submit">Voltar</button>
  </form>
</body>
</html>
