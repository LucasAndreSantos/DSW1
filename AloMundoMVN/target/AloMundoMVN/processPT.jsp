<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Processar Formulário</title>
</head>
<body>
  <h1>Processando os Dados do Formulário</h1>
  
  <% 
    // Parâmetros de conexão com o banco de dados
    String url = "jdbc:postgresql://localhost:5432/locadora"; 
    String dbUsername = "paladino"; // Substitua pelo seu nome de usuário do banco de dados
    String dbPassword = "1234"; // Substitua pela sua senha do banco de dados

    // Criar conexão
    Connection connection = null;
    Statement statement = null;

    try {
      Class.forName("org.postgresql.Driver");
      connection = DriverManager.getConnection(url, dbUsername, dbPassword);
      statement = connection.createStatement();

      // Recuperar os dados do formulário
      String action = request.getParameter("action");
      String usuariolocadora = request.getParameter("usuariolocadora");
      String usuariocliente = request.getParameter("usuariocliente");

      if (action.equals("consultCliente")) {
        String selectClienteQuery = "SELECT * FROM usuariocliente INNER JOIN usuariogeral ON usuariocliente.\"CPF\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariocliente + "'";
        ResultSet clienteResult = statement.executeQuery(selectClienteQuery);

        if (clienteResult.next()) {
          %>
          <h2>Informações do Cliente</h2>
          <p>Nome de Usuário: <%= clienteResult.getString("Username") %></p>
          <p>Email: <%= clienteResult.getString("Email") %></p>
          <p>CPF/CNPJ: <%= clienteResult.getString("CPF/CNPJ") %></p>
          <p>Hierarquia: <%= clienteResult.getInt("Hierarquia") %></p>
          <p>Sexo: <%= clienteResult.getString("Sexo") %></p>
          <p>Telefone: <%= clienteResult.getString("Telefone") %></p>
          <p>Data de Nascimento: <%= clienteResult.getDate("Data de Nascimento") %></p>
          <% // Exibir as informações desejadas do registro do cliente
        } else {
          %>
          <p>Cliente não encontrado</p>
          <% // Exibir uma mensagem de erro se o registro do cliente não for encontrado
        }
      }

      if (action.equals("consultLocadora")) {
        String selectLocadoraQuery = "SELECT * FROM usuariolocadora INNER JOIN usuariogeral ON usuariolocadora.\"CNPJ\" = usuariogeral.\"CPF/CNPJ\" WHERE usuariogeral.\"Username\" = '" + usuariolocadora + "'";
        ResultSet locadoraResult = statement.executeQuery(selectLocadoraQuery);

        if (locadoraResult.next()) {
          %>
          <h2>Informações da Locadora</h2>
          <p>Nome de Usuário: <%= locadoraResult.getString("Username") %></p>
          <p>Email: <%= locadoraResult.getString("Email") %></p>
          <p>CPF/CNPJ: <%= locadoraResult.getString("CPF/CNPJ") %></p>
          <p>Hierarquia: <%= locadoraResult.getInt("Hierarquia") %></p>
          <p>CNPJ: <%= locadoraResult.getString("CNPJ") %></p>
          <p>Cidade: <%= locadoraResult.getString("Cidade") %></p>
          <% // Exibir as informações desejadas do registro da locadora
        } else {
          %>
          <p>Locadora não encontrada</p>
          <% // Exibir uma mensagem de erro se o registro da locadora não for encontrado
        }
      }


      if (action.equals("updateLocadora")) {
        response.sendRedirect("UpdateLocadoraPT.jsp?usuariolocadora=" + usuariolocadora);
      } else if (action.equals("deleteLocadora")) {
        String deleteLocacoesQuery = "DELETE FROM locacoes WHERE \"CNPJ\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariolocadora + "')";
        int rowsAffectedLocacoes = statement.executeUpdate(deleteLocacoesQuery);

        String deleteLocadoraQuery = "DELETE FROM usuariolocadora WHERE \"CNPJ\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariolocadora + "')";
        int rowsAffectedLocadora = statement.executeUpdate(deleteLocadoraQuery);

        String deleteUsuariogeralQuery = "DELETE FROM usuariogeral WHERE \"Username\" = '" + usuariolocadora + "'";
        int rowsAffectedUsuariogeral = statement.executeUpdate(deleteUsuariogeralQuery);

        if (rowsAffectedLocadora > 0 && rowsAffectedUsuariogeral > 0) {
          %>
          <p>Exclusão realizada com sucesso</p> 
          <p><a href="admPT.jsp">Voltar</a></p>
          <% // Você pode redirecionar ou exibir uma mensagem de sucesso com um link clicável
        } else {
          %>
          <p>Erro ao excluir</p> 
          <p><a href="admPT.jsp">Voltar</a></p>
          <% // Você pode redirecionar ou exibir uma mensagem de erro com um link clicável
        }
      } else if (action.equals("updateCliente")) {
        response.sendRedirect("UpdateClientePT.jsp?usuariocliente=" + usuariocliente);
      } else if (action.equals("deleteCliente")) {
        String deleteLocacoesQuery = "DELETE FROM locacoes WHERE \"CPF\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "')";
        int rowsAffectedLocacoes = statement.executeUpdate(deleteLocacoesQuery);

        String deleteClienteQuery = "DELETE FROM usuariocliente WHERE \"CPF\" IN (SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "')";
        int rowsAffectedCliente = statement.executeUpdate(deleteClienteQuery);

        String deleteUsuariogeralQuery = "DELETE FROM usuariogeral WHERE \"Username\" = '" + usuariocliente + "'";
        int rowsAffectedUsuariogeral = statement.executeUpdate(deleteUsuariogeralQuery);

        if (rowsAffectedCliente > 0 && rowsAffectedUsuariogeral > 0) {
          %>
          <p>Exclusão realizada com sucesso</p> 
          <p><a href="admPT.jsp">Voltar</a></p>
          <% // Você pode redirecionar ou exibir uma mensagem de sucesso com um link clicável
        } else {
          %>
          <p>Erro ao excluir</p> 
          <p><a href="admPT.jsp">Voltar</a></p>
          <% // Você pode redirecionar ou exibir uma mensagem de erro com um link clicável
        }
      } else {
        // Lidar com ação inválida ou não suportada
        // Exibir uma mensagem de erro ou redirecionar para uma página de erro
      }

    } catch (ClassNotFoundException | SQLException e) {
      e.printStackTrace();
      String errorMessage = "Erro: " + e.getMessage();
      %>
      <p><%= errorMessage %></p>
      <p><a href="admPT.jsp">Voltar</a></p>
      <% // Exibir ou lidar com a mensagem de erro com um link clicável
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
    }
  %>
</body>
</html>
