$(function(){
  // Cargar todos los tutores
  function loadGuardians(){
    $.get(API_BASE_URL + "/guardians/get_all.php", function(resp){
      let html = "";
      if(resp.success && Array.isArray(resp.data)){
        resp.data.forEach(g => {
          html += `<tr>
            <td>${g.GuardianID}</td>
            <td>${g.FirstName} ${g.LastName}</td>
            <td>${g.Relationship || "-"}</td>
            <td>${g.PhoneNumber || "-"}</td>
            <td>${g.Email || "-"}</td>
            <td class="text-center">
              <button class="btn btn-link btn-sm show-students" data-id="${g.GuardianID}">
                <i class="fas fa-users"></i>
              </button>
            </td>
            <td>${g.IsEmergencyContact ? "Sí" : "No"}</td>
            <td>
              <a href="guardian-detail.html?id=${g.GuardianID}" class="btn btn-info btn-sm">
                <i class="fas fa-eye"></i>
              </a>
            </td>
          </tr>`;
        });
      } else {
        html = '<tr><td colspan="8" class="text-center text-muted">Sin tutores registrados.</td></tr>';
      }
      $("#guardiansTableBody").html(html);
    });
  }

  // Opcional: mostrar estudiantes vinculados a un tutor (popup/modal)
  $("#guardiansTableBody").on("click", ".show-students", function(){
    let guardianId = $(this).data("id");
    $.get(API_BASE_URL + "/guardians/get_by_guardian.php?guardianId=" + guardianId, function(resp){
      // Muestra los estudiantes vinculados al tutor en un alert/simple modal
      if(resp.success && Array.isArray(resp.data)){
        let info = resp.data.map(stu => `${stu.FirstName} ${stu.LastName}`).join(", ");
        alert("Estudiantes vinculados: " + info);
      }else{
        alert("Sin estudiantes vinculados.");
      }
    });
  });

  loadGuardians();
});
