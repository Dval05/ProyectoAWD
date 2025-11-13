$(function() {

  // Renderiza la tabla
  function renderObservationsTable(list) {
    let html = "";
    if(!list.length) {
      html = "<tr><td colspan='7' class='text-center text-muted'>Sin observaciones</td></tr>";
    } else {
      list.forEach(o => {
        html += `
          <tr>
            <td>${o.FirstName} ${o.LastName}</td>
            <td>${o.ObservationDate || ""}</td>
            <td>${o.Category || ""}</td>
            <td>${o.Observation}</td>
            <td>${o.EmpFirstName} ${o.EmpLastName}</td>
            <td>${o.IsPrivate == 1 ? "Sí" : "No"}</td>
            <td>
              <button class='btn btn-secondary btn-sm btn-edit' data-id='${o.ObservationID}'>Editar</button>
              <button class='btn btn-danger btn-sm btn-delete' data-id='${o.ObservationID}'>Eliminar</button>
            </td>
          </tr>`;
      });
    }
    $("#observationsTableBody").html(html);
  }

  // Carga todas las observaciones
  function loadObservations() {
    $.get("../../php/observations/get_all.php", function(resp) {
      if(resp.success && Array.isArray(resp.data)) {
        renderObservationsTable(resp.data);
      }
    });
  }

  // Eliminar
  $("#observationsTableBody").on("click", ".btn-delete", function() {
    let id = $(this).data("id");
    if(confirm("¿Eliminar observación?")) {
      $.ajax({
        url: "../../php/observations/delete.php",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify({ObservationID: id}),
        success: function(resp){ 
          if(resp.success) loadObservations();
          else alert(resp.message || "Error al eliminar");
        }
      });
    }
  });

  // ---- Modal de editar ----
  // Abre el modal con los datos cargados
  $("#observationsTableBody").on("click", ".btn-edit", function() {
    let id = $(this).data("id");
    $.get("../../php/observations/get_all.php", function(resp) {
      if(resp.success && Array.isArray(resp.data)) {
        let ob = resp.data.find(x => x.ObservationID == id);
        if (ob) {
          $("#editObservationID").val(ob.ObservationID);
          $("#editCategory").val(ob.Category);
          $("#editObservation").val(ob.Observation);
          $("#editIsPrivate").prop("checked", ob.IsPrivate == 1);
          $("#editObservationModal").modal("show");
        }
      }
    });
  });

  // Guardar edición
  $("#editObservationForm").on("submit", function(e){
    e.preventDefault();
    let data = {
      ObservationID: $("#editObservationID").val(),
      Category: $("#editCategory").val(),
      Observation: $("#editObservation").val(),
      IsPrivate: $("#editIsPrivate").is(":checked") ? 1 : 0
    };
    $.ajax({
      url: "../../php/observations/update.php",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if(resp.success){
          $("#editObservationModal").modal("hide");
          loadObservations();
          alert("Observación actualizada.");
        } else {
          alert(resp.message || "Error al actualizar.");
        }
      }
    });
  });

  
  $("#btnCreateObservation").click(function(){
    $("#createObservationForm")[0].reset();
    $("#createObservationModal").modal("show");
  });
  
  $("#createObservationForm").on("submit",function(e){
    e.preventDefault();
    // Prepara payload desde los inputs
    // ...
    $.ajax({
      url: "../../php/observations/create.php",
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(payload),
      success: function(resp){
        if(resp.success){
          $("#createObservationModal").modal("hide");
          loadObservations();
        }
      }
    });
  });
  

  // Inicialización al inicio
  loadObservations();
});
