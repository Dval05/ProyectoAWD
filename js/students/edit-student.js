$(function(){
  // Obtener el ID desde la URL
  function getQueryParam(param) {
    let params = new URLSearchParams(window.location.search);
    return params.get(param);
  }
  const studentId = getQueryParam("id");

  // Cargar datos del alumno en el formulario
  if(studentId && !isNaN(studentId)){
    $.get(API_BASE_URL + "/students/get_by_id.php?id=" + studentId, function(resp){
      if(resp.success && resp.data){
        let s = resp.data;
        $("#firstName").val(s.FirstName || "");
        $("#lastName").val(s.LastName || "");
        $("#birthDate").val(s.BirthDate || "");
        $("#gender").val(s.Gender || "");
        $("#documentNumber").val(s.DocumentNumber || "");
        $("#address").val(s.Address || "");
        $("#email").val(s.Email || "");
        $("#phoneNumber").val(s.PhoneNumber || "");
        $("#gradeId").val(s.GradeID || "");
        $("#medicalInfo").val(s.MedicalInfo || "");
        $("#emergencyContact").val(s.EmergencyContact || "");
        $("#emergencyPhone").val(s.EmergencyPhone || "");
        $("#enrollmentDate").val(s.EnrollmentDate || "");
        $("input[name='isActive'][value='" + (s.IsActive || 1) + "']").prop("checked", true);
        $("input[name='isRecurrent'][value='" + (s.IsRecurrent || 1) + "']").prop("checked", true);
        // Si tienes profile picture, muestra preview
        if(s.ProfilePicture){
          $("#profilePicturePreview").attr("src", s.ProfilePicture);
        }
      } else {
        alert("No se encontró el estudiante.");
        window.location.href = "students.html";
      }
    });
  }

  // Actualizar datos alumno
  $("#editStudentForm").on("submit", function(e){
    e.preventDefault();

    const data = {
      StudentID: studentId,
      FirstName: $("#firstName").val(),
      LastName: $("#lastName").val(),
      BirthDate: $("#birthDate").val(),
      Gender: $("#gender").val(),
      DocumentNumber: $("#documentNumber").val(),
      Address: $("#address").val(),
      Email: $("#email").val(),
      PhoneNumber: $("#phoneNumber").val(),
      GradeID: $("#gradeId").val(),
      MedicalInfo: $("#medicalInfo").val(),
      EmergencyContact: $("#emergencyContact").val(),
      EmergencyPhone: $("#emergencyPhone").val(),
      IsActive: $("input[name='isActive']:checked").val(),
      IsRecurrent: $("input[name='isRecurrent']:checked").val(),
      EnrollmentDate: $("#enrollmentDate").val()
    };

    $.ajax({
      url: API_BASE_URL + "/students/update.php",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if(resp.success){
          alert("Estudiante actualizado correctamente.");
          window.location.href = "student-detail.html?id=" + studentId;
        } else {
          alert("Error al actualizar estudiante.");
        }
      }
    });
  });
});
