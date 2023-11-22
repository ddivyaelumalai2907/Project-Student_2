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
            top: 15%;
            left:15%;
            border-collapse: collapse;
            border: 3px solid rgba(1, 1, 1, 0);
            width: 70%;
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
    <button id="new_sub">Add new Subject</button>
    <div class="center">
        <table id="mytable">
            <tr>
                <th>Subject id</th>
                <th>Subject Name</th>
                <th>Total students Enrolled</th>
                <th>Modify</th>
                <th>View Students</th>
            </tr>
        </table>
    </div>
</body>
<script type="text/javascript">
    let listContainerEl = document.getElementById("mytable")
    async function addSubject(url = "",data={}){
        const response = await fetch(url, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }

    async function updateSubject(url = "",data={}){
        const response = await fetch(url, {
            method: "PUT",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }

    new_sub.addEventListener("click", function () {
        let sub_name = prompt("Enter new Subject Name")
        if(sub_name != "" && sub_name != null){
            addSubject("/new/subject", {subject_name:sub_name}).then((response) => {
                if (response.status == 'success') {
                    alert("sucessfully added the new "+name+" course")
                    console.log(response)
                }
            }),
             console.log(sub_name)
         }else{
            alert("Enter the subject name to add it")
         }
        })

    //FUNCTION TO FECTH ALL SUBJECTS
    async function getsubjects(url = "") {
        const response = await fetch(url)
        return await response.json()
    }
    getsubjects("/allsubjectdetails").then((response) => {
        console.log(response.data)
        if (response.status == 'success') {
            for (let eachSub of response.data) {
                appendsubjects(eachSub)
            }
        } else {
            alert("Failed")
        }
    })
//DELETING THE SUBJECT
    async function removeSubject(url = "", data = {}) {
        const response = await fetch(url, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams(data).toString()
        })
        return response.json();
    }
    async function getStudentsenrolled(url = "") {
        const response = await fetch(url);
        return response.json();
  }

        function appendsubjects(sub) {
            let listEl = document.createElement("tr")
            let subEl = document.createElement("td")
            let subidEl = document.createElement("td")
            let studentcount = document.createElement("td")
            let td1 = document.createElement("td")
            let btnEl = document.createElement("button")
            let td2 = document.createElement("td")
            let viewStudents = document.createElement("button")

            td1.appendChild(btnEl)
            td2.appendChild(viewStudents)
            
            subidEl.textContent = sub.id
            subEl.textContent = sub.name
            studentcount.textContent = sub.countofstudent
            btnEl.textContent = "Modify"
            viewStudents.textContent = "View Students"
            
            console.log(sub.id)
            listEl.appendChild(subidEl)
            listEl.appendChild(subEl)
            listEl.appendChild(studentcount)
            listEl.appendChild(td1)
            listEl.appendChild(td2)
            
            listContainerEl.appendChild(listEl)
    
            //UPDATING SUBJECT NAME
            btnEl.addEventListener("click", function () {
                let new_subName = prompt("Enter the new Subject Name")
                if(new_subName != "" && new_subName != null){
                updateSubject("/modify/subject", {old_name:sub.name,new_name:new_subName}).then((response) => {
                    if (response.status == 'success') {
                        alert("sucessfully modified the course name")
                    }
                    console.log(response)
                })
                }
                else{
                    alert("Enter the new subject name to modify")
                }
            })

            var id =subidEl.toString()
            console.log(id)
        //VIEWING STUDENT
            viewStudents.addEventListener("click",function(){
                getStudentsenrolled("/get/studentsubject/subid/"+sub.id).then((response)=>{
                   //let subject_id = value["subidEl"]
                    if(response.status == 'success'){
                        console.log(sub.id)
                        window.location.href = '/students/enrolled/'+sub.name
                    }else {
                        alert(response.message);
                    }
            })

        })       
    }


</script>
</body>
</html>