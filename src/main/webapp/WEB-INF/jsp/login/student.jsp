<!DOCTYPE html>
<html>
    <head>
        <title>Student Login</title>
        <style>
            * {
                box-sizing: border-box;
                box-shadow: 5px 10px 8px #888888;
            }
            .container{
                font-family: sans-serif;
                position: absolute;
                left:31%;
                top:20%;
                width: 400px;
                border-style:solid;
                border-radius:s15px;
                box-shadow:0 0 5px 0;
                background:inherit;
                border:3px solid black;
                padding: 50px;
                margin: 20px;
                height:250px;
            }
            button{
                background-color:green;
                position: absolute;
                left:20%;
                top:55%;
                width:60%;
                padding:10px;
                border-radius: 10px
            }
            .center {
                position: absolute;
                left:40%;
            }
            input{
                padding: 12px 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
        <label>Student id</label>
        <input id="studentid"  placeholder="student id"/>
        <button id="loginbtn">Login</button><br><br>
        <br><br><br><br><a class="center"href="register">New user</a>
        </div>
    </body>

    <script>
        async function loginData(url=""){
            const response = await fetch(url)
            return await response.json()
        }

        document.getElementById("loginbtn").addEventListener("click",function(){
            let studentid = document.getElementById("studentid").value;
            if(studentid != "" && studentid != null){
            loginData("/check/student/"+studentid).then((response)=>{
                console.log(response.data)
                if(response.status == "success") {
                    window.location.href = '/student/details/'+studentid;
                } else {
                    alert("Invalid/not registered student id,you can re-enter a valid student id or register if you are a new user")
            }})
            }
            else{
                alert("enter the student id to login");
            }
        })
    </script>
</html>
