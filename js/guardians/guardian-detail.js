$(function(){
  const guardianId = new URLSearchParams(window.location.search).get("id");
  if (!guardianId || isNaN(guardianId)) {
    $(".container-fluid").prepend('<div class="alert alert-danger mt-3">ID de representante no válido.</div>');
    return;
  }

  // Cargar info del tutor
  $.get(API_BASE_URL + "/guardians/get_by_id.php?id=" + guardianId, function(resp){
    if(resp.success && resp.data){
      const g = resp.data;
      $("#guardianFullName").text((g.FirstName || '') + " " + (g.LastName || ''));
      $("#guardianRelationship").text(g.Relationship || "-");
      $("#guardianDocumentNumber").text(g.DocumentNumber || "-");
      $("#guardianPhoneNumber").text(g.PhoneNumber || "-");
      $("#guardianEmail").text(g.Email || "-");
      $("#guardianAddress").text(g.Address || "-");
      $("#guardianOccupation").text(g.Occupation || "-");
      $("#guardianWorkPhone").text(g.WorkPhone || "-");
      $("#guardianIsEmergencyContact").text(g.IsEmergencyContact == 1 ? "Sí" : "No");
      $("#guardianIsAuthorizedPickup").text(g.IsAuthorizedPickup == 1 ? "Sí" : "No");
      // ...si tienes foto, podrías hacer $("#guardianPhoto").attr("src", g.ProfilePicture);
    } else {
      $(".container-fluid").prepend('<div class="alert alert-danger mt-3">No se encontraron datos para este tutor</div>');
    }
  });

  // Cargar estudiantes vinculados
  $.get(API_BASE_URL + "/guardians/students_by_guardian.php?guardianId=" + guardianId, function(resp){
    if(resp.success && Array.isArray(resp.data) && resp.data.length){
      let lis = "";
      resp.data.forEach(st => {
        lis += `<li class="list-group-item">${st.FirstName} ${st.LastName} (ID: ${st.StudentID})</li>`;
      });
      $("#linkedStudents").html(lis);
    } else {
      $("#linkedStudents").html('<li class="list-group-item text-muted">Sin estudiantes vinculados</li>');
    }
  });

  // Navegación a editar
  $("#btnEditGuardian").on("click", function(){
    window.location.href = "edit-guardian.html?id=" + guardianId;
  });
});
