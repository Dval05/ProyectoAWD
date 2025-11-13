$(function(){
  // Opcional: si es edición, obtén ID desde URL param (?id=xx)
  const urlParams = new URLSearchParams(window.location.search);
  const obsId = urlParams.get("id");

  // Cargar estudiantes
  function loadStudents(selectedId) {
    $.get("../../php/students/get_all.php", function(resp){
      let html = `<option value="">-- Seleccione --</option>`;
      if(resp.success && Array.isArray(resp.data)){
        resp.data.forEach(s=>{
          html += `<option value="${s.StudentID}" ${selectedId==s.StudentID?"selected":""}>${s.FirstName} ${s.LastName}</option>`;
        });
      }
      $("#studentId").html(html);
      if(selectedId) $("#studentId").val(selectedId);
    });
  }

  // Cargar docentes
  function loadTeachers(selectedId) {
    $.get("../../php/employees/get_all.php", function(resp){
      let html = `<option value="">-- Seleccione --</option>`;
      if(resp.success && Array.isArray(resp.data)){
        resp.data.forEach(t=>{
          html += `<option value="${t.EmpID}" ${selectedId==t.EmpID?"selected":""}>${t.FirstName} ${t.LastName}</option>`;
        });
      }
      $("#empId").html(html);
      if(selectedId) $("#empId").val(selectedId);
    });
  }

  // Si es edición: cargar datos y llenar
  function loadObservationDetail(){
    if(!obsId) return;
    $.get("../../php/observations/get_all.php", function(resp){
      if(resp.success && Array.isArray(resp.data)){
        const ob = resp.data.find(o=>o.ObservationID==obsId);
        if(ob){
          loadStudents(ob.StudentID);
          loadTeachers(ob.EmpID);
          $("#observationDate").val(ob.ObservationDate);
          $("#category").val(ob.Category);
          $("#isPrivate").val(ob.IsPrivate || 0);
          $("#observation").val(ob.Observation);
          $("#isPositive").val(ob.IsPositive !== undefined ? ob.IsPositive : "");
          $("#requiresAction").val(ob.RequiresAction !== undefined ? ob.RequiresAction : 0);
          $("#actionTaken").val(ob.ActionTaken || "");
        }
      }
    });
  }

  // Nueva: solo pobla combos vacíos (si es creación) al cargar
  if(!obsId){
    loadStudents();
    loadTeachers();
  } else {
    loadObservationDetail();
  }

  // Guardar (alta/edición según si hay obsId)
  $("#observationDetailForm").on("submit", function(e){
    e.preventDefault();
    let data = {
      StudentID: $("#studentId").val(),
      EmpID: $("#empId").val(),
      ObservationDate: $("#observationDate").val(),
      Category: $("#category").val(),
      IsPrivate: $("#isPrivate").val(),
      Observation: $("#observation").val(),
      IsPositive: $("#isPositive").val() || null,
      RequiresAction: $("#requiresAction").val() || 0,
      ActionTaken: $("#actionTaken").val() || ""
    };
    if(obsId) data.ObservationID = obsId;

    let url = obsId 
      ? "../../php/observations/update.php" 
      : "../../php/observations/create.php";

    $.ajax({
      url: url,
      method: "POST",
      contentType: "application/json",
      data: JSON.stringify(data),
      success: function(resp){
        if(resp.success){
          alert("Observación guardada.");
          window.location.href="observations.html";
        }else{
          alert(resp.message || "Error al guardar.");
        }
      }
    });
  });
});
