console.log("✓ activities.js cargado");

(function(){
  const ACTIVITIES_KEY = "activities_v1";
  const TEACHERS_KEY = "teachers_v1";

  // ===== HELPERS =====
  function loadActivities(){
    try { return JSON.parse(localStorage.getItem(ACTIVITIES_KEY) || "[]"); }
    catch(e){ console.error("Error loading activities:", e); return []; }
  }

  function saveActivities(list){
    localStorage.setItem(ACTIVITIES_KEY, JSON.stringify(list));
    console.log("✓ Actividades guardadas:", list.length);
  }

  function loadTeachers(){
    try { return JSON.parse(localStorage.getItem(TEACHERS_KEY) || "[]"); }
    catch(e){ console.error("Error loading teachers:", e); return []; }
  }

  function uid(){ return Date.now().toString(36); }

  function getTeacherName(id){
    if(!id) return "Sin asignar";
    const t = loadTeachers().find(x => x.id === id);
    return t ? `${t.firstName || ""} ${t.lastName || ""}`.trim() : "Sin asignar";
  }

  // ===== RENDER ACTIVIDADES =====
  function renderActivitiesTable(filterTeacherId){
    console.log("renderActivitiesTable called with filter:", filterTeacherId);
    const tbody = document.getElementById("activitiesTableBody");
    if(!tbody) { console.warn("activitiesTableBody not found"); return; }
    
    const activities = loadActivities();
    const filtered = activities.filter(a => !filterTeacherId || String(a.teacherId) === String(filterTeacherId));
    
    if(filtered.length === 0){
      tbody.innerHTML = "<tr><td colspan='7' class='text-center text-muted'>No hay actividades</td></tr>";
      return;
    }
    
    tbody.innerHTML = filtered.map(a => `
      <tr data-id="${a.id}">
        <td><strong>${a.name || ""}</strong></td>
        <td>${a.date || ""}</td>
        <td>${a.grade || ""}</td>
        <td>${getTeacherName(a.teacherId)}</td>
        <td>${a.category || ""}</td>
        <td><span class="badge badge-info">${a.status || ""}</span></td>
        <td>
          <button class="btn btn-xs btn-info btn-edit" data-id="${a.id}" title="Editar"><i class="fas fa-edit"></i></button>
          <button class="btn btn-xs btn-danger btn-delete" data-id="${a.id}" title="Eliminar"><i class="fas fa-trash"></i></button>
        </td>
      </tr>
    `).join("");
  }

  // ===== POPULATE FILTRO DOCENTES =====
  function populateTeacherFilter(){
    const sel = document.getElementById("filterTeacher");
    if(!sel) { console.warn("filterTeacher not found"); return; }
    
    const teachers = loadTeachers();
    console.log("Teachers loaded:", teachers.length);
    const current = sel.value;
    sel.innerHTML = `<option value="">Todos los docentes</option>` + 
      teachers.map(t => `<option value="${t.id}">${(t.firstName||'') + ' ' + (t.lastName||'')}</option>`).join("");
    if(current) sel.value = current;
  }

  // ===== POPULATE MODAL SELECT =====
  function populateTeacherSelectModal(){
    const sel = document.getElementById("actTeacher");
    const noMsg = document.getElementById("noTeachersMsg");
    if(!sel) { console.warn("actTeacher not found"); return; }
    
    const teachers = loadTeachers();
    console.log("Teachers for modal select:", teachers.length);
    
    if(teachers.length === 0){
      sel.innerHTML = `<option value="">-- No hay docentes --</option>`;
      if(noMsg) noMsg.style.display = "block";
    } else {
      sel.innerHTML = `<option value="">-- Seleccione docente --</option>` + 
        teachers.map(t => `<option value="${t.id}">${(t.firstName||'') + ' ' + (t.lastName||'')}</option>`).join("");
      if(noMsg) noMsg.style.display = "none";
    }
  }

  // ===== BIND CREAR ACTIVIDAD BUTTON =====
  function bindCreateActivityButton(){
    console.log("bindCreateActivityButton called");
    const btn = document.getElementById("btnCreateActivity");
    const form = document.getElementById("createActivityForm");
    const modal = document.getElementById("createActivityModal");
    const assignSwitch = document.getElementById("assignTeacherSwitch");
    const wrapper = document.getElementById("teacherSelectWrapper");
    const actTeacher = document.getElementById("actTeacher");

    if(!btn) { console.warn("btnCreateActivity not found"); return; }
    if(!form) { console.warn("createActivityForm not found"); return; }
    if(!modal) { console.warn("createActivityModal not found"); return; }

    console.log("✓ All elements found, binding click handler");

    // Click en botón abre modal
    btn.addEventListener("click", (e)=>{
      e.preventDefault();
      console.log("btnCreateActivity clicked - opening modal");
      form.reset();
      assignSwitch.checked = false;
      wrapper.style.display = "none";
      actTeacher.removeAttribute("required");
      populateTeacherSelectModal();
      
      // Abrir modal con jQuery o vanilla
      try { 
        if(typeof jQuery !== 'undefined'){
          jQuery("#createActivityModal").modal("show");
          console.log("✓ Modal abierto con jQuery");
        } else {
          modal.style.display = "block";
          modal.classList.add("show");
          console.log("✓ Modal abierto modo vanilla");
        }
      } catch(e){ 
        console.error("Error abriendo modal:", e); 
      }
    });

    // Switch para mostrar/ocultar select de docente
    if(assignSwitch){
      assignSwitch.addEventListener("change", ()=>{
        console.log("assignTeacherSwitch toggled:", assignSwitch.checked);
        if(assignSwitch.checked){
          wrapper.style.display = "block";
          actTeacher.setAttribute("required", "required");
        } else {
          wrapper.style.display = "none";
          actTeacher.removeAttribute("required");
        }
      });
    }

    // Submit formulario
    form.addEventListener("submit", (e)=>{
      e.preventDefault();
      console.log("createActivityForm submitted");
      
      const payload = {
        id: 'a_' + uid(),
        name: document.getElementById("actName").value.trim(),
        date: document.getElementById("actDate").value || "",
        grade: document.getElementById("actGrade").value.trim(),
        category: document.getElementById("actCategory").value,
        status: document.getElementById("actStatus").value,
        description: document.getElementById("actDescription").value.trim(),
        teacherId: assignSwitch.checked && actTeacher.value ? actTeacher.value : null,
        createdAt: new Date().toISOString()
      };

      if(!payload.name){
        alert("El nombre de la actividad es obligatorio");
        return;
      }

      console.log("✓ Actividad a guardar:", payload);
      const list = loadActivities();
      list.push(payload);
      saveActivities(list);

      // Refrescar UI
      const filterSel = document.getElementById("filterTeacher");
      populateTeacherFilter();
      renderActivitiesTable(filterSel ? filterSel.value : "");

      // Cerrar modal
      try { 
        if(typeof jQuery !== 'undefined'){
          jQuery("#createActivityModal").modal("hide");
        } else {
          modal.style.display = "none";
          modal.classList.remove("show");
        }
      } catch(e){ console.error("Error cerrando modal:", e); }

      alert("✓ Actividad creada: " + payload.name);
      
      if(window.Security && typeof window.Security.logAction === "function"){
        window.Security.logAction("activity", `Actividad creada: ${payload.name}`);
      }
    });
  }

  // ===== BIND FILTER =====
  function bindFilter(){
    const sel = document.getElementById("filterTeacher");
    if(!sel) { console.warn("filterTeacher not found for binding"); return; }
    
    sel.addEventListener("change", ()=> {
      console.log("Filter changed to:", sel.value);
      renderActivitiesTable(sel.value);
    });
  }

  // ===== BIND TABLE ACTIONS =====
  function bindTableActions(){
    const tbody = document.getElementById("activitiesTableBody");
    if(!tbody) { console.warn("activitiesTableBody not found for binding"); return; }
    
    tbody.addEventListener("click", (ev) => {
      const btn = ev.target.closest("button");
      if(!btn) return;
      const id = btn.getAttribute("data-id");
      if(!id) return;
      
      if(btn.classList.contains("btn-delete")){
        if(confirm("¿Eliminar actividad?")){
          console.log("Eliminando actividad:", id);
          const list = loadActivities().filter(a => a.id !== id);
          saveActivities(list);
          const filterSel = document.getElementById("filterTeacher");
          renderActivitiesTable(filterSel ? filterSel.value : "");
          if(window.Security && typeof window.Security.logAction === "function"){
            window.Security.logAction("activity", `Actividad eliminada: ${id}`);
          }
        }
      } else if(btn.classList.contains("btn-edit")){
        alert("Editar actividad: " + id + " (próximamente)");
      }
    });
  }

  // ===== INIT =====
  function init(){
    console.log("=== activities.js INIT ===");
    populateTeacherFilter();
    populateTeacherSelectModal();
    bindFilter();
    bindCreateActivityButton();
    renderActivitiesTable("");
    bindTableActions();
    
    window.ActivitiesManager = {
      loadActivities, saveActivities, loadTeachers, renderActivitiesTable
    };
    console.log("=== activities.js INIT COMPLETO ===");
  }

  // Ejecutar cuando DOM esté listo
  if(document.readyState === "loading"){
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

  // Sincronizar con otras pestañas
  window.addEventListener("storage", () => { 
    console.log("Storage event detectado, refrescando...");
    try{ 
      populateTeacherFilter();
      renderActivitiesTable(document.getElementById("filterTeacher")?.value || ""); 
    }catch(e){ console.error("Error en storage event:", e); }
  });
})();
