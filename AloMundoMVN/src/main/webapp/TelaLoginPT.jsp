<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
</head>
<body>
  <h1>Login</h1>
  
  <button style="position: absolute; top: 10px; right: 10px;" onclick="window.location.href='TelaLogin.jsp'">English</button>
  
  <form method="post" action="LoginPT.jsp">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required><br>
      
      <label for="password">Senha:</label>
      <input type="password" id="password" name="password" required><br>
      
      <input type="submit" value="Entrar">
  </form>
</body>
</html>
