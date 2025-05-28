<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>eStock Login</title>
    <style>
    body{
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    .container{
        background-color: #fff;
        padding: 20px;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 300px;
    }
    h1{
        text-align: center;
    }
    .input-group{
        margin-bottom: 15px;
    }
    label{
        display: block;
        margin-bottom: 5px;
    }
    input{
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }
    button{
        width: 100%;
        padding: 10px;
        background-color: #007BFF;
        color: white;
        border: none;
        border-radius: 3px;
        cursor: pointer;
    }
    button:hover{
        background-color: #0056b3;
    }
    .message{
        text-align: center;
        margin-top: 15px;
    }
    </style>
</head>
<body>
    <div class="container">
        <h1>eStock Login</h1>
        <form id="loginForm" action="LoginServlet" method="post">
            <div class="input-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
        </form>
        <p class="message">Don't have an account? <a href="signup.jsp">Sign up</a></p>
    </div>
    <script>
        document.getElementById("loginForm").addEventListener("submit", function(event) {
            event.preventDefault();
            const username = document.getElementById("username").value;
            const password = document.getElementById("password").value;
            if (username === "" || password === "") {
                alert("Please fill in all fields");
            } else {
                alert(`Logging in as ${username}`);
            }
        });
    </script>
</body>
</html>
