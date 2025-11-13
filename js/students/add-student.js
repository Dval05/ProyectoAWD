$("#addStudentForm").on("submit", function(e){
    e.preventDefault();

    const data = {
        FirstName: $("#firstName").val(),
        LastName: $("#lastName").val(),
        BirthDate: $("#birthDate").val(),
        Gender: $("#gender").val(),
        DocumentNumber: $("#documentNumber").val(),
        Address: $("#address").val(),
        Email: $("#email").val(),
        PhoneNumber: $("#phoneNumber").val(),
        GradeID: $("#gradeId").val(),
        ProfilePicture: "", // Si necesitas manejo de archivo real, usa FormData
        MedicalInfo: $("#medicalInfo").val(),
        EmergencyContact: $("#emergencyContact").val(),
        EmergencyPhone: $("#emergencyPhone").val(),
        IsActive: $("input[name='isActive']:checked").val(),
        IsRecurrent: $("input[name='isRecurrent']:checked").val(),
        EnrollmentDate: $("#enrollmentDate").val(),
        WithdrawalDate: null // O maneja el campo si tienes input en el formulario
    };

    $.ajax({
        url: API_BASE_URL + "/students/create.php",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: function(resp){
            if(resp.success){
                $("#alertText").text("Estudiante guardado correctamente.");
                $("#alertMessage").removeClass("alert-danger").addClass("alert-success").show();
                setTimeout(function(){
                    window.location.href = "students.html";
                }, 1800);
            }else{
                $("#alertText").text("No se pudo guardar el estudiante. " + (resp.message || ""));
                $("#alertMessage").removeClass("alert-success").addClass("alert-danger").show();
            }
        },
        error: function(xhr){
            let txt = "Error de red o del servidor.";
            if(xhr.responseJSON && xhr.responseJSON.message){
                txt = xhr.responseJSON.message;
            }
            $("#alertText").text(txt);
            $("#alertMessage").removeClass("alert-success").addClass("alert-danger").show();
        }
    });
});
