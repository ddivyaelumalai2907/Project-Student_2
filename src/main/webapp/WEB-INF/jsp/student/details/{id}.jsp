<!DOCTYPE html>
<html>

<head>
    <title>Student</title>
    <style>
        body {
            font-family: sans-serif;
        }
        .center {
            margin: auto;
            width: 57%;
            padding: 10px;
        }

        tr {
            border-bottom: 1px solid #ddd;
        }

        table {
            position: absolute;
            top: 20%;
            border-collapse: collapse;
            border: 3px solid rgba(1, 1, 1, 0);
            width: 50%;
        }

        .center {
            margin: auto;
            width: 57%;
            top:30%;
            left: 40%;
            padding: 10px;
        }

        #style {
            font-family: sans-serif;
            width: 100%;
        }

        td,
        th {
            padding: 15px;
            text-align: center;
        }

        th {
            background-color: cadetblue;
        }

        button {
            position:center;
            padding: 8px;
            border-radius: 15px;
        }
        
    </style>
</head>

<body>
    <p id="studentname">Student Name:<spam id="name"></spam> &nbsp;&nbsp;<button id = "update_btn">Change Name</button></p>
    <p id="sid">Student id:<span id="id"></span></p>
    <p id="joinedtime">Joined Time:<span id="jointime"></span></p>
    <div class="center">
      <table id="enrolled">
          <tr>
            <th>Subject id</th>
            <th>Subject Name</th>
            <th>Enrolled id</th>
            <th>Quit</th>
          </tr>
      </table>
    </div>
</body>
<script>
    async function getdata(url = "") {
        const response = await fetch(url);
        return response.json();
    }
    var student_id
    var student_name 
    getdata("/student/data").then((response) => {
        if (response.status == 'success') {
            student_id = document.getElementById("id").textContent = response.data.id;
            student_name = document.getElementById("name").textContent = response.data.name;
            let join_time = document.getElementById("jointime").textContent = response.data.joined_time;
        }
        else {
            alert(response.data);
        }
    })
    //function to change name.
    async function setNewname(url = "", data = {}) {
        const response = await fetch(url, {
            method: "PUT",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }
    update_btn.addEventListener("click",function(){
       let updated_name = prompt("Enter the new name")
       if(updated_name != "" && updated_name!= null){
       setNewname('/student/update/name',{old_name:student_name,new_name:updated_name}).then((response)=> {
                if(response.status == 'success'){
                    alert("Name changed!!!!!")
                }
            }),
             console.log(updated_name)
        }else{
            alert("Enter the new name to change!!")
        }
    })

    //function to enroll the course
    async function subscribeToSubject(url = "", data = {}) {
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }
    //function to quit the course
    async function toQuit(url = "", data = {}) {
        const response = await fetch(url, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }

    //getting enrolled details from controller
    async function getstudentsub(url = ""){
        const response = await fetch(url);
        return response.json();
    }
    getstudentsub("/students/erolled/subject").then((response) =>{
        if(response.status == "success"){
            for (let eachSub of response.data) {
                setenrolldeatils(eachSub);
        
            }
        }else{
            alert(response.message);
        }
    })
    //function to get details for table
    let listContainer = document.getElementById("enrolled")
    function setenrolldeatils(details){

        let elem=document.createElement("tr");

        let subjectid=document.createElement("td");
        let subname=document.createElement("td");
        let enrolledid=document.createElement("td");
        let td1 = document.createElement("td");
        let enrollbtn = document.createElement("button")
        let quit=document.createElement("button");

        td1.appendChild(quit);

        //if(deta)
        subjectid.textContent = details.subject_id;
        subname.textContent = details.subject_name;
        enrolledid.textContent = details.enrolled_id;
        if(details.enrolled_id == null){
            enrolledid.appendChild(enrollbtn);
            enrollbtn.textContent = "Enroll";
            quit.disabled=true;
        }
        quit.textContent = "Quit course";

        console.log(details.subject_id);

        elem.appendChild(subjectid);
        elem.appendChild(subname);
        elem.appendChild(enrolledid);
        elem.appendChild(td1);

        listContainer.appendChild(elem)


         //ONROLLING TO A SUBJECT
         enrollbtn.addEventListener("click", function () {
            subscribeToSubject("/subject/subscribe", {subject_id: details.subject_id}).then((response) => {
                if (response.status == 'success') {
                    alert("sucessfully enrolled the "+details.subject_name+" course")
                    quit.disabled = false
                    enrolledid.textContent = response.enrolled_id;
                    console.log(response)
                }
                else{
                    alert("something worng!!!!!!")
                }
            })
        })

        //Quiting course
        quit.addEventListener("click",function(){
            toQuit("/subject/delete",{subject_id:details.subject_id}).then((response) => {
                if(response.status == 'success'){
                    quit.textContent = "Quited!"
                    console.log(response)
                }else{
                    alert("something worng!!")
                }
            })
        })
    }
</script>
</html>