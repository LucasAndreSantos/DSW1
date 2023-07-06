<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>Administração de Usuários</title>
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
  <h1>Administração de Usuários</h1>
  <% 
    // Verificar se o usuário está logado
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser == null || !"1".equals(userHierarchy)) {
  %>
    <h2>Erro: Acesso Negado</h2>
    <p>Você precisa estar logado como um usuário com hierarquia 1 para visualizar esta página.</p>
    <a href="TelaLoginPT.jsp">Ir para a Página de Login</a>
  <% 
    } else {
  %>
    <div class="welcome">
      <h2>Bem-vindo <%= loggedInUser %></h2>
    </div>
    <form action="processPT.jsp" method="post">
      <% 
        // Parâmetros de conexão com o banco de dados
        String url = "jdbc:postgresql://localhost:5432/locadora"; 
        String dbUsername = "paladino"; // Substitua pelo nome de usuário do seu banco de dados
        String dbPassword = "1234"; // Substitua pela senha do seu banco de dados

        // Criar conexão
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;

        try {
          Class.forName("org.postgresql.Driver");
          connection = DriverManager.getConnection(url, dbUsername, dbPassword);

          // Consulta para recuperar os nomes de usuário da tabela usuariogeral para usuariolocadora
          String locadoraQuery = "SELECT \"Username\" FROM usuariogeral JOIN usuariolocadora ON \"CPF/CNPJ\" = \"CNPJ\"";
          statement = connection.prepareStatement(locadoraQuery);
          resultSet = statement.executeQuery();
      %>
          <label for="usuariolocadora">Locadoras:</label>
          <select id="usuariolocadora" name="usuariolocadora">
      <% 
          while (resultSet.next()) {
            String username = resultSet.getString("Username");
      %>
            <option value="<%= username %>"><%= username %></option>
      <% } %>
          </select>
        </br>
          <button type="submit" name="action" value="consultLocadora">Consultar</button>
          <button type="submit" formaction="CadastroLocadoraPT.jsp" name="action" value="createLocadora">Criar</button>
          <button type="submit" name="action" value="updateLocadora">Atualizar</button>
          <button type="submit" name="action" value="deleteLocadora">Excluir</button>

      <% 
          // Resetar o result set e preparar a consulta para usuariocliente
          resultSet.close();
          statement.close();

          String clienteQuery = "SELECT \"Username\" FROM usuariogeral JOIN usuariocliente ON \"CPF/CNPJ\" = \"CPF\"";
          statement = connection.prepareStatement(clienteQuery);
          resultSet = statement.executeQuery();
      %>
          <br><br>
          <label for="usuariocliente">Clientes:</label>
          <select id="usuariocliente" name="usuariocliente">
      <% 
          while (resultSet.next()) {
            String username = resultSet.getString("Username");
      %>
            <option value="<%= username %>"><%= username %></option>
      <% } %>
          </select>
          </br>
          <button type="submit" name="action" value="consultCliente">Consultar</button>
          <button type="submit" formaction="CadastroClientePT.jsp" name="action" value="createCliente">Criar</button>
          <button type="submit" name="action" value="updateCliente">Atualizar</button>
          <button type="submit" name="action" value="deleteCliente">Excluir</button>
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
  </form>
  <% 
  }
  %>
  <div class="top-right">
    <form action="adm.jsp">
      <button type="submit">English</button>
    </form>
  </div>
  <form action="indexPT.jsp">
    <button type="submit">Voltar</button>
  </form>
</body>
</html>
