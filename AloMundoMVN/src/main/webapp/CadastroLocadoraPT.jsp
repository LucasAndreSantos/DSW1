<!DOCTYPE html>
<html>
<head>
  <title>Cadastro locadora</title>
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
</head>
<body>
  <h1>Cadastro Locadora</h1>
  
  <% 
    // Verificar se o usuário está logado e tem a hierarquia necessária
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser == null || !"1".equals(userHierarchy)) {
  %>
    <h2>Erro: Acesso Negado</h2>
    <p>Você precisa estar logado como administrador para registrar uma locadora.</p>
    <a href="TelaLoginPT.jsp">Ir para a página de login</a>
  <% 
    } else {
  %>
    <div class="welcome">
      <h2>Bem-vindo <%= loggedInUser %></h2>
    </div>
    <form action="InsertLocadoraPT.jsp" method="post">
      <label for="username">Nome de usuário:</label>
      <input type="text" name="username" id="username" required><br>
      
      <label for="cpf_cnpj">CNPJ:</label>
      <input type="text" name="cpf_cnpj" id="cpf_cnpj" required><br>
      
      <label for="email">Email:</label>
      <input type="email" name="email" id="email" required><br>

      <label for="Cidade">Cidade:</label>
      <input type="text" name="Cidade" id="Cidade" required><br>
      
      <label for="senha">Senha:</label>
      <input type="password" name="senha" id="senha" required><br>
      
      <button type="submit">Registrar</button>
    </form>
  <% 
    }
  %>
  <div class="top-right">
    <form action="CadastroLocadora.jsp">
      <button type="submit">English</button>
    </form>
  </div>
</body>
</html>
