<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
</head>
<body>
  <h1>Login</h1>
  
  <button style="position: absolute; top: 10px; right: 10px;" onclick="window.location.href='TelaLoginPT.jsp'">Português</button>
  
  <form method="post" action="Login.jsp">
      <label for="email">Email:</label>
      <input type="email" id="email" name="email" required><br>
      
      <label for="password">Password:</label>
      <input type="password" id="password" name="password" required><br>
      
      <input type="submit" value="Login">
  </form>
</body>
</html>
