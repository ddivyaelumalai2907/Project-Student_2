<!DOCTYPE html>
<html>
    <head>
        <title>Register</title>
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
                height: 200px;
                border-style:solid;
                border-radius:s15px;
                padding: 50px;
                margin: 20px;
            }
            button{
                background-color:green;
                position: absolute;
                left:20%;
                top:75%;
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
        <label>Name</label>
        <input id="name" type="text">
        <button id="registerbtn">Register</button>
        </div>
    </body>
    <script>
        async function regData(url = "", data = {}) {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }

        document.getElementById("registerbtn").addEventListener("click",function(){
            let student_name = document.getElementById("name").value;
            if(student_name != "" && student_name != null){
            regData("/add/student",{name:student_name}).then((response)=>{
                console.log(response.data)
                if(response.status == "success") {
                    alert("Welcome "+student_name+"registered successfully,your student id is "+response.data.id+" login to see the dashboard")
                    window.location.href = '/login/student'
                } else {
                    window.location.href = '/login/register'
            }})
            }
            else{
                alert("Enter the name to register")
            }
        })

    </script>
</html>