<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
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
<head>
  <title>Resultado Inserção</title>
</head>
<body>
  <h1>Resultado Inserção</h1>
  <% 
    // Recuperar dados do formulário
    String username = request.getParameter("username");
    String cpf_cnpj = request.getParameter("cpf_cnpj");
    String email = request.getParameter("email");
    String hierarquia = request.getParameter("hierarquia");
    String senha = request.getParameter("senha");
    String datanascimento = request.getParameter("datanascimento");
    String telefone = request.getParameter("telefone");
    String sexo = request.getParameter("sexo");

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

      // Criar consulta SQL para o primeiro insert
      String sql = "INSERT INTO public.usuariogeral (\"Username\", \"Email\", \"CPF/CNPJ\", \"Hierarquia\", \"Senha\") " +
                   "VALUES ('" + username + "', '" + email + "', '" + cpf_cnpj + "', '" + hierarquia + "', '" + senha + "')";

      statement = connection.prepareStatement(sql);

      // Executar o primeiro insert
      rowsAffected = statement.executeUpdate();

      // Imprimir a mensagem de resultado para o primeiro insert
  %>

  <% 
      // Criar consulta SQL para o segundo insert
      String sql2 = "INSERT INTO public.usuariocliente (\"Sexo\", \"Telefone\", \"Data de Nascimento\", \"CPF\") " +
                    "VALUES ('" + sexo + "', '"+ telefone +"', '"+datanascimento+"', '"+ cpf_cnpj +"')";

      statement = connection.prepareStatement(sql2);

      // Executar o segundo insert
      rowsAffected = statement.executeUpdate();

      // Imprimir a mensagem de resultado para o segundo insert
      if (rowsAffected > 0) {
  %>
        <p>Sucesso!</p>
  <% } else { %>
        <p>Falha.</p>
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
  <div class="top-right">
    <form action="InsertClientePT.jsp">
      <button type="submit">Português (BR)</button>
    </form>
  </div>
  <form action="admPT.jsp">
    <button type="submit">Voltar</button>
  </form>
</body>
</html>
