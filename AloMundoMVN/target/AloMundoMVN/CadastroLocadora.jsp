<!DOCTYPE html>
<html>
<head>
  <title>Rental Registration</title>
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
  <h1>Rental Registration</h1>
  
  <% 
    // Check if the user is logged in and has the required hierarchy
    String loggedInUser = (String) session.getAttribute("loggedInUser");
    String userHierarchy = (String) session.getAttribute("userHierarchy");
    if (loggedInUser == null || !"1".equals(userHierarchy)) {
  %>
    <h2>Error: Access Denied</h2>
    <p>You need to be logged in as an administrator to register a movie rental.</p>
    <a href="TelaLogin.jsp">Go to Login Page</a>
  <% 
    } else {
  %>
    <div class="welcome">
      <h2>Welcome <%= loggedInUser %></h2>
    </div>
    <form action="InsertLocadora.jsp" method="post">
      <label for="username">Username:</label>
      <input type="text" name="username" id="username" required><br>
      
      <label for="cpf_cnpj">CNPJ:</label>
      <input type="text" name="cpf_cnpj" id="cpf_cnpj" required><br>
      
      <label for="email">Email:</label>
      <input type="email" name="email" id="email" required><br>

      <label for="Cidade">City:</label>
      <input type="text" name="Cidade" id="Cidade" required><br>
      
      <label for="senha">Password:</label>
      <input type="password" name="senha" id="senha" required><br>
      
      <button type="submit">Register</button>
    </form>
  <% 
    }
  %>
  <div class="top-right">
    <form action="CadastroLocadoraPT.jsp">
      <button type="submit">Português (BR)</button>
    </form>
  </div>
</body>
</html>
