$(function() {
  const studentId = new URLSearchParams(window.location.search).get("id");

  if(!studentId || isNaN(studentId)) {
    $(".container-fluid").prepend('<div class="alert alert-danger mt-3">ID de estudiante no válido.</div>');
    return;
  }

  function loadStudentDetail() {
    $.get(API_BASE_URL + "/students/get_by_id.php?id=" + studentId, function(resp){
      if(resp.success && resp.data){
        const s = resp.data;
        $("#studentFullName").text((s.FirstName || "") + " " + (s.LastName || ""));
        $("#firstName").text(s.FirstName || "-");
        $("#lastName").text(s.LastName || "-");
        $("#birthDate").text(s.BirthDate || "-");
        $("#documentNumber").text(s.DocumentNumber || "-");
        $("#studentGender").text(s.Gender || "-");
        $("#email").text(s.Email || "-");
        $("#phoneNumber").text(s.PhoneNumber || "-");
        $("#address").text(s.Address || "-");
        $("#studentGrade").text(s.GradeID || "Sin grado");
        $("#enrollmentDate").text(s.EnrollmentDate || "-");
        $("#studentType").text(s.IsRecurrent == 1 ? "Recurrente" : "Ocasional")
          .toggleClass("badge-info", s.IsRecurrent == 1)
          .toggleClass("badge-warning", s.IsRecurrent == 0);
        $("#studentStatus").text(s.IsActive == 1 ? "Activo" : "Inactivo")
          .toggleClass("badge-success", s.IsActive == 1)
          .toggleClass("badge-danger", s.IsActive == 0);
        if(s.ProfilePicture && s.ProfilePicture.trim() !== ""){
          $("#studentPhoto").attr("src", s.ProfilePicture);
        }
        if(s.BirthDate) $("#studentAge").text(getAge(s.BirthDate)+" años"); 
          else $("#studentAge").text("-");
        if($('#withdrawalDate').length) $('#withdrawalDate').text(s.WithdrawalDate || "-");
        if(s.MedicalInfo && s.MedicalInfo.trim() !== ""){
          $("#medicalInfo").removeClass("alert-info").addClass("alert-success").html(s.MedicalInfo);
        } else {
          $("#medicalInfo").removeClass("alert-success").addClass("alert-info").html('<i class="fas fa-info-circle"></i> Sin información médica registrada');
        }
        $("#emergencyContact").text(s.EmergencyContact || "-");
        $("#emergencyPhone").text(s.EmergencyPhone || "-");
        if($('#createdAt').length) $('#createdAt').text(s.CreatedAt || "-");
        if($('#updatedAt').length) $('#updatedAt').text(s.UpdatedAt || "-");
      } else {
        $(".container-fluid").prepend('<div class="alert alert-danger mt-3">No se encontraron datos para este estudiante</div>');
      }
    });
  }

  function getAge(birthDate){
    const today = new Date();
    const bd = new Date(birthDate);
    let age = today.getFullYear() - bd.getFullYear();
    const m = today.getMonth() - bd.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < bd.getDate())) age--;
    return age;
  }

  $("#btnEditStudent").on("click", function(){
    window.location.href = "edit-student.html?id=" + studentId;
  });

  $("#btnDeleteStudent").on("click", function(){
    if(confirm("¿Seguro que deseas eliminar este estudiante?")){
      $.ajax({
        url: API_BASE_URL + "/students/delete.php",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ StudentID: studentId }),
        success: function(resp){
          if(resp.success){
            alert("Estudiante eliminado correctamente");
            window.location.href = "students.html";
          }else{
            alert("Error al eliminar estudiante");
          }
        }
      });
    }
  });

  function loadGuardians(){
    $.get(API_BASE_URL + "/guardians/get_by_student.php?studentId=" + studentId, function(resp){
      let b = "";
      if(resp.success && Array.isArray(resp.data) && resp.data.length){
        resp.data.forEach(g => {
          b += `<tr>
            <td>${g.FirstName} ${g.LastName}</td>
            <td>${g.Relationship||""}</td>
            <td>${g.PhoneNumber||""}</td>
            <td>${g.Email||""}</td>
            <td>${g.IsPrimary==1 ? "Sí" : "No"}</td>
          </tr>`;
        });
      } else {
        b = `<tr><td colspan="5" class="text-center text-muted">Sin tutores registrados</td></tr>`;
      }
      $("#guardiansTable").html(b);
    });
  }

  $("#btnAddGuardian").click(function(){
    var frm = document.getElementById("guardianForm");
    if (frm) frm.reset();
    $("#GuardianID").val("");
    $(".needs-validation").removeClass('was-validated');
    $("#guardianFormModal").modal("show");
  });

  // SOLO ESTE submit
  $("#guardianForm").on("submit", function(e) {
    e.preventDefault();
    e.stopPropagation();

    if (this.checkValidity() === false) {
      this.classList.add('was-validated');
      return;
    }

    let data = {
      FirstName: $("#FirstName").val(),
      LastName: $("#LastName").val(),
      DocumentNumber: $("#DocumentNumber").val(),
      Relationship: $("#Relationship").val(),
      PhoneNumber: $("#PhoneNumber").val(),
      Email: $("#Email").val(),
      Address: $("#Address").val(),
      Occupation: $("#Occupation").val(),
      WorkPhone: $("#WorkPhone").val(),
      IsEmergencyContact: $("#IsEmergencyContact").is(":checked") ? 1 : 0,
      IsAuthorizedPickup: $("#IsAuthorizedPickup").is(":checked") ? 1 : 0
    };

    $.ajax({
      url: API_BASE_URL + "/guardians/create.php",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if (resp.success) {
          // Vincula el tutor nuevo e hijo SÓLO aquí
          $.ajax({
            url: API_BASE_URL + "/guardians/link_to_student.php",
            method: "POST",
            contentType: "application/json",
            data: JSON.stringify({
              StudentID: studentId,
              GuardianID: resp.GuardianID || resp.id,
              IsPrimary: 0,
              Priority: 1
            }),
            success: function(linkResp) {
              if(linkResp.success) {
                alert("Tutor vinculado correctamente.");
                $("#guardianFormModal").modal("hide");
                loadGuardians();
              } else {
                alert("Error al vincular tutor.");
              }
            }
          });
        } else {
          let msg = resp.message ? resp.message : "Error al crear tutor.";
          alert(msg);
        }
      }
    });
  });

  $("#cancelGuardianForm").click(function(){
    var frm = document.getElementById("guardianForm");
    if (frm) frm.reset();
    $("#guardianFormModal").modal("hide");
  });

  function loadGuardians(){
  $.get(API_BASE_URL + "/guardians/get_by_student.php?studentId=" + studentId, function(resp){
    let b = "";
    if(resp.success && Array.isArray(resp.data) && resp.data.length){
      resp.data.forEach(g => {
        b += `<tr>
          <td>${g.FirstName} ${g.LastName}</td>
          <td>${g.Relationship||""}</td>
          <td>${g.PhoneNumber||""}</td>
          <td>${g.Email||""}</td>
          <td>${g.IsPrimary==1 ? "Sí" : "No"}</td>
        </tr>`;
      });
    } else {
      b = `<tr><td colspan="5" class="text-center text-muted">Sin tutores registrados</td></tr>`;
    }
    $("#guardiansTable").html(b);
  });
}
  loadStudentDetail();
  loadGuardians();
});
