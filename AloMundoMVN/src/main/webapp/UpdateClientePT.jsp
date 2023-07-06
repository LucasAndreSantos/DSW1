<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Atualizar Cliente</title>
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
  <h1>Atualizar Informações do Cliente</h1>
  
  <% 
    // Parâmetros de conexão com o banco de dados
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Substitua pelo seu nome de usuário do banco de dados
    String dbPassword = "1234"; // Substitua pela sua senha do banco de dados

    // Criação da conexão
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);
      statement = connection.createStatement();

      // Recupera o parâmetro "usuariocliente" da requisição
      String usuariocliente = request.getParameter("usuariocliente");

      // Recupera informações do cliente do banco de dados
      String selectClienteQuery = "SELECT * FROM usuariocliente INNER JOIN usuariogeral ON usuariocliente.\"CPF\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariocliente + "'";
      resultSet = statement.executeQuery(selectClienteQuery);

      if (resultSet.next()) {
        String username = resultSet.getString("Username");
        String email = resultSet.getString("Email");
        String cpf = resultSet.getString("CPF/CNPJ");
        String sexo = resultSet.getString("Sexo");
        String telefone = resultSet.getString("Telefone");
        Date dataNascimento = resultSet.getDate("Data de Nascimento");
        int hierarquia = resultSet.getInt("Hierarquia");
        String senha = resultSet.getString("Senha");

        %>
        <form action="updaterCliente.jsp" method="POST">
          <input type="hidden" name="action" value="updateCliente">
          <input type="hidden" name="clienteCPF" value="<%= cpf %>">
          <label>Usuário:</label>
          <input type="text" name="username" value="<%= username %>"><br>
          <label>Email:</label>
          <input type="text" name="email" value="<%= email %>"><br>
          <label>Documento:</label>
          <input type="text" name="cpf" value="<%= cpf %>" readonly><br>
          <label>Gênero:</label>
          <select name="sexo">
            <option value="Masculino" <%= (sexo.equals("Masculino")) ? "selected" : "" %>>Masculino</option>
            <option value="Feminino" <%= (sexo.equals("Feminino")) ? "selected" : "" %>>Feminino</option>
          </select><br>
          <label>Telefone:</label>
          <input type="number" name="telefone" value="<%= telefone %>"><br>
          <label>Data de Nascimento:</label>
          <input type="date" name="dataNascimento" value="<%= dataNascimento %>"><br>
          <label>Hierarquia:</label>
          <select name="hierarquia">
            <option value="0" <%= (hierarquia == 0) ? "selected" : "" %>>Usuário</option>
            <option value="1" <%= (hierarquia == 1) ? "selected" : "" %>>Administrador</option>
          </select><br>
          <label>Senha:</label>
          <input type="password" name="senha" value="<%= senha %>"><br>

          <input type="submit" value="Atualizar">
        </form>
        
        <p><a href="admPT.jsp">Voltar</a></p>
        <% // Exibe os campos do formulário com as informações atuais do cliente
      } else {
        %>
        <p>Cliente não encontrado</p>
        <p><a href="admPT.jsp">Voltar</a></p>
        <% // Exibe uma mensagem de erro se a entrada do cliente não for encontrada
      }

    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Erro: " + e.getMessage();
      %>
      <p><%= errorMessage %></p>
      <p><a href="admPT.jsp">Voltar</a></p>
      <% // Exibe ou manipula a mensagem de erro com um link clicável
    } finally {
      // Fecha os recursos
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
