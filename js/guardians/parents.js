$(function(){
  loadGuardians();

  $("#btnNewGuardian").click(function(){
    $("#GuardianID").val("");
    $("#guardianForm")[0].reset();
    $("#IsEmergencyContact").prop("checked", false);
    $("#IsAuthorizedPickup").prop("checked", false);
    $("#guardianFormModal").modal("show");
  });

  $("#cancelGuardianForm").click(function(){
    $("#guardianFormModal").modal("hide");
    $("#guardianForm")[0].reset();
    $("#GuardianID").val("");
  });

 $("#guardianForm").on("submit", function(e){
  e.preventDefault();
  e.stopPropagation();
    let data = {
      GuardianID: $("#GuardianID").val(),
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
    let url = API_BASE_URL + "/guardians/" + (data.GuardianID ? "update.php" : "create.php");
    $.ajax({
      url: url,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if(resp.success){
          alert("Guardado correctamente");
          $("#guardianFormModal").modal("hide");
          $("#guardianForm")[0].reset();
          loadGuardians();
        } else {
          alert("Error al guardar");
        }
      }
    });
  });

  function loadGuardians(){
    $.get(API_BASE_URL + "/guardians/get_all.php", function(resp){
      let b = "";
      if(resp.success && Array.isArray(resp.data) && resp.data.length){
        resp.data.forEach(g => {
          b += `<tr>
            <td>${g.FirstName} ${g.LastName}</td>
            <td>${g.DocumentNumber||""}</td>
            <td>${g.Relationship||""}</td>
            <td>${g.PhoneNumber||""}</td>
            <td>${g.Email||""}</td>
            <td>${g.IsEmergencyContact==1?"Sí":"No"}</td>
            <td>${g.IsAuthorizedPickup==1?"Sí":"No"}</td>
            <td>
              <button class="btn btn-sm btn-primary btn-edit" data-id="${g.GuardianID}">Editar</button>
            </td>
          </tr>`;
        });
      } else {
        b = `<tr><td colspan="8" class="text-center text-muted">Sin tutores registrados</td></tr>`;
      }
      $("#guardiansTableBody").html(b);

      $(".btn-edit").click(function(){
        let id = $(this).data("id");
        $.get(API_BASE_URL + "/guardians/get_all.php", function(resp){
          let g = (resp.data || []).find(o=>o.GuardianID==id);
          if(g){
            $("#GuardianID").val(g.GuardianID);
            $("#FirstName").val(g.FirstName);
            $("#LastName").val(g.LastName);
            $("#DocumentNumber").val(g.DocumentNumber);
            $("#Relationship").val(g.Relationship);
            $("#PhoneNumber").val(g.PhoneNumber);
            $("#Email").val(g.Email);
            $("#Address").val(g.Address);
            $("#Occupation").val(g.Occupation);
            $("#WorkPhone").val(g.WorkPhone);
            $("#IsEmergencyContact").prop("checked", g.IsEmergencyContact==1);
            $("#IsAuthorizedPickup").prop("checked", g.IsAuthorizedPickup==1);
            $("#guardianFormModal").modal("show");
          }
        });
      });
    });
  }
});
