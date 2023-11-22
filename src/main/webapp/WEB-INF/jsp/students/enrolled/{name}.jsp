<%@page import ="com.training.controller.TrainingController"%> 
<!DOCTYPE html>
<html>
    <head>
        <title>Students</title>
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
        <div class="center">
            <table id="mytable">
                <tr>
                    <th>Enrolled id</th>
                    <th>Student id</th>
                    <th>Student Name</th>
                    <th>Enrolled time</th>
                </tr>
            </table>
        </div>
    </body>
    <script>
    async function getstudents(url = "") {
        const response = await fetch(url)
        return response.json()
    }
    function populate(response) {
        if (response.status == 'success') {
            for (let eachSub of response.data) {
                getstudentsubjects(eachSub)
            }
        } else {
            alert(response.message)
        }
    }

    let listContainerEl = document.getElementById("mytable")
    populate(<%=TrainingController.getstudents()%>)
    function getstudentsubjects(sub) {

        let listEl = document.createElement("tr")
        let enrolledid = document.createElement("td")
        let studentid = document.createElement("td")
        let studentName = document.createElement("td")
        let jointime = document.createElement("td")
        enrolledid.textContent= sub.id
        studentid.textContent = sub.student_id
        studentName.textContent = sub.student_name
        jointime.textContent = sub.subscription_time
        console.log(sub.id)
        listEl.appendChild(enrolledid)
        listEl.appendChild(studentid)
        listEl.appendChild(studentName)
        listEl.appendChild(jointime)
        listContainerEl.appendChild(listEl)
    }
</script>
 
</html>