<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDateTime" %>
<!DOCTYPE html>
<html>
<head>
  <title>Locação Adicionada</title>
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
  <code><% 
    // Verificar se o usuário está logado
    String loggedInUser = (String) session.getAttribute("loggedInUser");

    // Obter a cidade e data selecionada dos parâmetros da requisição
    String selectedCity = request.getParameter("cidade");
    String selectedDateTime = request.getParameter("datetime");

    // Redirecionar para a página de login se o usuário não estiver logado
    if (loggedInUser == null) {
      response.sendRedirect("TelaLogin.jsp");
    } else {
      // Obter o CNPJ da locadora usando o nome de usuário selecionado
      String locadoraCNPJ = null;

      // Obter o CPF do usuário logado usando o e-mail
      String userCPF = null;

      // Definir os parâmetros de conexão com o banco de dados
      String url = "jdbc:postgresql://localhost:5432/locadora"; 
      String username = "paladino";
      String password = "1234";

      // Criar conexão
      Connection connection = null;
      try {
        Class.forName("org.postgresql.Driver");
        connection = DriverManager.getConnection(url, username, password);

        // Criar instrução SQL para obter o CNPJ da locadora
        String locadoraSQL = "SELECT \"CNPJ\" FROM usuariolocadora " + "JOIN usuariogeral ON \"CNPJ\" = \"CPF/CNPJ\" " + "WHERE \"Username\" = '" + selectedCity + "'";
        Statement locadoraStatement = connection.createStatement();
        ResultSet locadoraResult = locadoraStatement.executeQuery(locadoraSQL);
        if (locadoraResult.next()) {
          locadoraCNPJ = locadoraResult.getString("CNPJ");
        }

        // Criar instrução SQL para obter o CPF do usuário logado
        String cpfSQL = "SELECT \"CPF/CNPJ\" FROM usuariogeral WHERE \"Email\" = '" + loggedInUser + "'";
        Statement cpfStatement = connection.createStatement();
        ResultSet cpfResult = cpfStatement.executeQuery(cpfSQL);
        if (cpfResult.next()) {
          userCPF = cpfResult.getString("CPF/CNPJ");
        }

        LocalDateTime locacaoDateTime = LocalDateTime.parse(selectedDateTime);
        LocalDateTime horaLocacao = locacaoDateTime.withMinute(0).withSecond(0).withNano(0);

        // Calcular a HoraDevolucao como uma hora após a HoraLocacao
        LocalDateTime horaDevolucao = horaLocacao.plusHours(1);

        // Verificar se o usuário já possui uma locação durante a hora selecionada
        String checkUserSQL = "SELECT COUNT(*) AS count FROM locacoes " +
                              "WHERE \"CPF\" = '" + userCPF + "' " +
                              "AND (('" + horaLocacao + "' >= \"HoraLocacao\" AND '" + horaLocacao + "' < \"HoraDevolucao\") " +
                              "OR ('" + horaDevolucao + "' > \"HoraLocacao\" AND '" + horaDevolucao + "' <= \"HoraDevolucao\"))";
        Statement checkUserStatement = connection.createStatement();
        ResultSet checkUserResult = checkUserStatement.executeQuery(checkUserSQL);
        if (checkUserResult.next()) {
          int count = checkUserResult.getInt("count");
          if (count > 0) {
            // O usuário já possui uma locação durante a hora selecionada, fornecer resposta apropriada
            out.println("<h1>Erro</h1>");
            out.println("<p>Você já possui uma locação durante a hora selecionada.</p>");
            return;
          }
        }

        // Verificar se a locadora já possui uma locação durante a hora selecionada
        String checkLocadoraSQL = "SELECT COUNT(*) AS count FROM locacoes " +
                                  "WHERE \"CNPJ\" = '" + locadoraCNPJ + "' " +
                                  "AND (('" + horaLocacao + "' >= \"HoraLocacao\" AND '" + horaLocacao + "' < \"HoraDevolucao\") " +
                                  "OR ('" + horaDevolucao + "' > \"HoraLocacao\" AND '" + horaDevolucao + "' <= \"HoraDevolucao\"))";
        Statement checkLocadoraStatement = connection.createStatement();
        ResultSet checkLocadoraResult = checkLocadoraStatement.executeQuery(checkLocadoraSQL);
        if (checkLocadoraResult.next()) {
          int count = checkLocadoraResult.getInt("count");
          if (count > 0) {
            // A locadora já possui uma locação durante a hora selecionada, fornecer resposta apropriada
            out.println("<h1>Erro</h1>");
            out.println("<p>A locadora selecionada já possui uma locação durante a hora selecionada.</p>");
            return;
          }
        }

        // Inserir as informações da locação na tabela locacoes
        if (locadoraCNPJ != null && userCPF != null) {
          // Calcular a HoraLocacao como a hora mais próxima

          // Criar instrução SQL para inserir as informações da locação
          String insertSQL = "INSERT INTO locacoes (\"CPF\", \"CNPJ\", \"HoraLocacao\", \"HoraDevolucao\") " +
                             "VALUES ('" + userCPF + "', '" + locadoraCNPJ + "', '" + horaLocacao + "', '" + horaDevolucao + "')";
          Statement insertStatement = connection.createStatement();

          // Executar a instrução de inserção
          int rowsAffected = insertStatement.executeUpdate(insertSQL);

          if (rowsAffected > 0) {
            // Locação adicionada com sucesso, fornecer resposta apropriada
            out.println("<h1>Locação Adicionada</h1>");
            out.println("<p>Informações da locação:</p>");
            out.println("<p>Usuário: " + loggedInUser + "</p>");
            out.println("<p>Empresa: " + selectedCity + "</p>");
            out.println("<p>Data e Hora: " + selectedDateTime + "</p>");
          } else {
            // Falha ao adicionar a locação, fornecer resposta apropriada
            out.println("<h1>Erro</h1>");
            out.println("<p>Falha ao adicionar a locação.</p>");
          }

          // Fechar a instrução de inserção
          insertStatement.close();
        }

      } catch (ClassNotFoundException | SQLException e) {
        // Imprimir a mensagem de erro
        out.println("<h1>Erro</h1>");
        out.println("<p>Ocorreu um erro: " + e.getMessage() + "</p>");
        e.printStackTrace();
      } finally {
        // Fechar a conexão
        if (connection != null) {
          try {
            connection.close();
          } catch (SQLException e) {
            e.printStackTrace();
          }
        }
      }
    }
  %></code>
    <form action="indexPT.jsp">
      <button type="submit">Voltar</button>
    </form>
</body>
</html>
