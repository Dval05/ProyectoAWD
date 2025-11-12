$(function(){
  const guardianId = new URLSearchParams(window.location.search).get("id");
  if (!guardianId || isNaN(guardianId)) {
    $(".container").prepend('<div class="alert alert-danger mt-3">ID de representante no válido.</div>');
    $("form").hide();
    return;
  }

  // Cargar datos en el formulario al llegar a la edición
  $.get(API_BASE_URL + "/guardians/get_by_id.php?id=" + guardianId, function(resp){
    if(resp.success && resp.data){
      const g = resp.data;
      $("#GuardianID").val(g.GuardianID);
      $("#FirstName").val(g.FirstName || "");
      $("#LastName").val(g.LastName || "");
      $("#DocumentNumber").val(g.DocumentNumber || "");
      $("#Relationship").val(g.Relationship || "");
      $("#PhoneNumber").val(g.PhoneNumber || "");
      $("#Email").val(g.Email || "");
      $("#Address").val(g.Address || "");
      $("#Occupation").val(g.Occupation || "");
      $("#WorkPhone").val(g.WorkPhone || "");
      $("#IsEmergencyContact").prop("checked", g.IsEmergencyContact == 1);
      $("#IsAuthorizedPickup").prop("checked", g.IsAuthorizedPickup == 1);
    } else {
      $(".container").prepend('<div class="alert alert-danger mt-3">No se encontraron datos para este tutor</div>');
      $("form").hide();
    }
  });

  // Validación visual Bootstrap
  $("#editGuardianForm").on("submit", function(e){
    e.preventDefault();
    e.stopPropagation();
    if (this.checkValidity() === false) {
      this.classList.add('was-validated');
      return;
    }
    let data = {
      GuardianID: guardianId,
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
      url: API_BASE_URL + "/guardians/update.php",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if(resp.success){
          alert("Representante actualizado correctamente.");
          window.location.href = "guardian-detail.html?id=" + guardianId;
        }else{
          let msg = resp.message ? resp.message : "Error al actualizar.";
          alert(msg);
        }
      }
    });
  });
});
