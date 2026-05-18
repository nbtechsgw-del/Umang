const form=document.getElementById('regForm');

form.addEventListener('submit',function(e){
    e.preventDefault();

    let isValid=true;

    const name=document.getElementById('fullname');
    if(name.value.trim()===""){
        document.getElementById('nameError').innerText="Name is required";
        isValid = false;
    }else{
        document.getElementById('nameError').innerText="";
    }

    const email = document.getElementById('email');
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!emailPattern.test(email.value)){
        document.getElementById('emailError').innerText="Enter a valid email";
        isValid=false;
    }else{
        document.getElementById('emailError').innerText="";
    }

    const pass=document.getElementById('password');
    const confpass=document.getElementById('confirmPass');
    if(pass.value.length<6){
        document.getElementById('passError').innerText="Min 6 characters required";
        isValid=false;
    }else{
        document.getElementById('passError').innerText="";
    }

    if(pass.value !== confpass.value || confpass.value===""){
        document.getElementById('confirmError').innerText="Passwords do not match";
        isValid=false;
    }else{
        document.getElementById('confirmError').innerText="";
    }

    const gender = document.querySelector('input[name="gender"]:checked');
    if(!gender){
        document.getElementById('genderError').innerText="Please select a gender";
        isValid=false;
    }else{
        document.getElementById('genderError').innerText="";
    }

    const skills = document.querySelectorAll('input[name="skills"]:checked');
    if(skills.length === 0){
        document.getElementById('skillsError').innerText="Select atleast one skill";
        isValid=false;
    }else{
        document.getElementById('skillsError').innerText="";
    }

    if(isValid){
        document.getElementById('successMsg').innerText="Registration Successful";
        setTimeout(()=>{
            form.reset();
            document.getElementById('successMsg').innerText="";
        },3000);
    }
});