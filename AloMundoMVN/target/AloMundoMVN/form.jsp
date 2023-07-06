<!DOCTYPE html>
<html>
<head>
  <title>User Registration</title>
</head>
<body>
  <h1>User Registration</h1>
  <form action="insert.jsp" method="post">
    <label for="username">Username:</label>
    <input type="text" name="username" id="username" required><br>
    
    <label for="cpf_cnpj">CPF/CNPJ:</label>
    <input type="text" name="cpf_cnpj" id="cpf_cnpj" required><br>
    
    <label for="email">Email:</label>
    <input type="email" name="email" id="email" required><br>
    
    <label for="hierarquia">Hierarquia:</label>
    <select name="hierarquia" id="hierarquia" required>
      <option value="1">Administrador</option>
      <option value="0">Usuário</option>
    </select><br>
    
    <label for="senha">Senha:</label>
    <input type="password" name="senha" id="senha" required><br>
    
    <button type="submit">Register</button>
  </form>
</body>
</html>
