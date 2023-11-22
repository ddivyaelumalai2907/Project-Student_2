<%@page import ="com.training.TrainingUiApplication"%> 
<!DOCTYPE html>
<html>

<head>
    <title>Home</title>
    <style>
        body {
            font-family: sans-serif;
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
        <table id="mytable">
            <tr>
                <th>Subject id</th>
                <th>Subject Name</th>
                <th>Enroll</th>
                <th>Quit</th>
            </tr>
        </table>
    </div>
</body>
<script type="text/javascript">
    async function getdata(url = "") {
        const response = await fetch(url)
        return response.json()
    }
    var student_id
    var student_name 
    getdata("/details").then((response) => {
        if (response.status == 'success') {
            student_id = document.getElementById("id").textContent = response.data.id
            student_name = document.getElementById("name").textContent = response.data.name
            let join_time = document.getElementById("jointime").textContent = response.data.joined_time
        }
        else {
            alert(response.data.message)
        }
    })
//SETTING NEW NAME USING PUT METHOD
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
       setNewname('/student/update/name',{old_name:student_name,new_name:updated_name}).then((response)=> {
                if(response.status == 'success'){
                    alert("Name changed!!!!!")
                }
            }),
             console.log(updated_name)
    })

    let listContainerEl = document.getElementById("mytable")
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
    //FUNCTION TO FECTH ALL SUBJECTS
    async function getsubject(url) {
        const response = await fetch(url)
        return response.json()
    }
    function populate(response) {
        if (response.status == 'success') {
            for (let eachSub of response.data) {
                appendsubjects(eachSub)
            }
        } else {
            alert(response.message)
        }
    }
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
    populate(<%=TrainingUiApplication.getsubjects()%>)
    function appendsubjects(sub) {

        let listEl = document.createElement("tr")
        let subEl = document.createElement("td")
        let subidEl = document.createElement("td")
        let td1 = document.createElement("td")
        let btnEl = document.createElement("button")
        let td2 = document.createElement("td")
        let delbtn = document.createElement("button")
        delbtn.disabled = true
        td1.appendChild(btnEl)
        td2.appendChild(delbtn)
        subidEl.textContent = sub.id
        subEl.textContent = sub.name
        btnEl.textContent = "Enroll"
        delbtn.textContent = "Quit Course"
        console.log(sub.id)
        listEl.appendChild(subidEl)
        listEl.appendChild(subEl)
        listEl.appendChild(td1)
        listEl.appendChild(td2)
        listContainerEl.appendChild(listEl)
        //ONROLLING TO A SUBJECT
        btnEl.addEventListener("click", function () {
            subscribeToSubject("/subject/subscribe", {subject_id: sub.id }).then((response) => {
                if (response.status == 'success' && response.data != "already exits") {
                    btnEl.textContent = "Enrolled"
                    alert("sucessfully enrolled the "+sub.name+" course")
                    btnEl.disabled = true
                    delbtn.disabled = false
                    console.log(response)
                }
                else if(response.data == "already exits"){
                    alert("You have already enrolled the course")
                }
                else{
                    alert("something worng!!!!!!")
                }
            })
        })
        //QUITING SUBJECT
        delbtn.addEventListener("click",function(){
            toQuit("/subject/delete",{subject_id:sub.id}).then((response) => {
                if(response.status == 'success' && (btnEl.textContent == "Enrolled")){
                    delbtn.textContent = "Quited!"
                    btnEl.textContent = "Enroll Again"
                    if(btnEl.textContent == "Enroll Again"){
                       delbtn.textContent = "Quit Again!"
                       delbtn.disabled = true
                    }
                    btnEl.disabled = false
                    console.log(response)
                }else{
                    alert("something worng!!")
                }
            })
        })
    }

</script>
</body>

</html>