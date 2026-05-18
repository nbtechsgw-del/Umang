
        const students = [
            { id: 1, name: "Ritesh", roll: "19007001" },
            { id: 2, name: "Saloni", roll: "19007002" },
            { id: 3, name: "Arjun", roll: "19007003" },
            { id: 4, name: "Krishna", roll: "19007004" },
            { id: 5, name: "Ritika", roll: "19007005" }
        ];

        const tableBody = document.getElementById("attendanceBody");

        students.forEach(student => {
            let row = `
                <tr>
                    <td>${student.id}</td>
                    <td>${student.name}</td>
                    <td>${student.roll}</td>
                    <td>
                        <input type="radio" name="status_${student.id}" value="present">
                    </td>
                    <td>
                        <input type="radio" name="status_${student.id}" value="absent">
                    </td>
                </tr>
            `;
            tableBody.innerHTML += row;
        });