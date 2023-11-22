<!DOCTYPE html>
<html>
    <head>
        <title>Adim Login</title>
        <style>
            * {
                box-sizing: border-box;
             }
             .container{
                font-family: sans-serif;
                position: absolute;
                left:31%;
                top:20%;
                width: 400px;
                border: 5px solid black ;
                border-style:solid;
                border-radius:s15px;
                padding: 50px;
                margin: 20px;
             }
             button{
                background-color:green;
                position: absolute;
                left:20%;
                width:60%;
                padding:10px;
                border-radius: 10px
             }
             input{
                padding: 12px 20px;
                margin: 8px 0;
             }

        </style>
    </head>
    <body>
        <div class="container">
        <div>
            <label>User Name</label>
            <input type="text" id="username" placeholder="User Name" /><br><br><br>
        </div>
        <div>
            <label>Password</label>
            <input type="password" id="password" placeholder="Password" /><br><br><br>
        </div>
        <div>
            <button id="loginbtn">Login</button><br><br>
        </div></div>

        <script type="text/javascript">
            async function postData(url = "", data = {}) {
                const response = await fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams(data).toString()
                });

                return response.json();
            }

            document.getElementById('loginbtn').addEventListener('click', function() {
                let username = document.getElementById('username').value;
                let password = document.getElementById('password').value;
                postData("/adminlogin", { userName: username, password: password }).then((response) => {
                    if(response.status == 'success') {
                        window.location.href = '/admin';
                    } else {
                        alert(response.message);
                    }
                });
            });
        </script>
    </body>

    
</html>