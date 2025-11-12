(function(){
  const KEY = "teachers_v1";
  const USERS_KEY = "users_v1";
  const ROLES_KEY = "security_roles_v1";
  const q = id => document.getElementById(id);
  const param = name => new URLSearchParams(location.search).get(name);

  function load(){
    try { return JSON.parse(localStorage.getItem(KEY) || "[]"); }
    catch(e){ return []; }
  }
  function save(list){
    localStorage.setItem(KEY, JSON.stringify(list));
    // notificar a otras pestañas
    try { window.dispatchEvent(new Event('storage')); } catch(e){}
  }
  function uid(){ return Date.now().toString(36); }

  // Users sync helpers
  function loadUsers(){
    try { return JSON.parse(localStorage.getItem(USERS_KEY) || "[]"); }
    catch(e){ return []; }
  }
  function saveUsers(list){
    localStorage.setItem(USERS_KEY, JSON.stringify(list));
    try { window.dispatchEvent(new Event('storage')); } catch(e){}
  }
  // Roles helper: aseguran que el rol exista para que Manage Users lo muestre
  function ensureRoleExists(roleName){
    if(!roleName) return;
    // Si hay módulo Security, preferimos usar su API (mantiene UI sincronizada)
    if(window.Security && typeof window.Security.loadRoles === "function" && typeof window.Security.addRole === "function"){
      const roles = window.Security.loadRoles() || [];
      if(!roles.includes(roleName)) window.Security.addRole(roleName);
      return;
    }
    // Fallback directo a localStorage
    try{
      const roles = JSON.parse(localStorage.getItem(ROLES_KEY) || "[]");
      if(!roles.includes(roleName)){
        roles.push(roleName);
        localStorage.setItem(ROLES_KEY, JSON.stringify(roles));
        try { window.dispatchEvent(new Event('storage')); } catch(e){}
      }
    }catch(e){}
  }

  function findUserByTeacherId(teacherId){
    return loadUsers().find(u => u.teacherId === teacherId);
  }
  function createOrUpdateUserFromTeacher(teacher){
    if(!teacher || !teacher.id) return;
    // Asegurar rol "teacher" presente
    ensureRoleExists("teacher");
    const users = loadUsers();
    let user = users.find(u => u.teacherId === teacher.id);
    const username = (teacher.email && teacher.email.trim()) || ((teacher.firstName||'').toLowerCase()+'.'+(teacher.lastName||'').toLowerCase());
    const userPayload = {
      username: username,
      email: teacher.email || "",
      firstName: teacher.firstName || "",
      lastName: teacher.lastName || "",
      role: "teacher",
      teacherId: teacher.id,
      isActive: teacher.isActive != null ? teacher.isActive : "1",
      updatedAt: new Date().toISOString()
    };
    if(user){
      Object.assign(user, userPayload);
    } else {
      user = Object.assign({ id: "u_" + uid(), createdAt: new Date().toISOString() }, userPayload);
      users.push(user);
    }
    saveUsers(users);
    if(window.Security) window.Security.logAction("user", `Usuario sincronizado para docente: ${teacher.id}`);
  }
  function removeUserByTeacherId(teacherId){
    const users = loadUsers().filter(u => u.teacherId !== teacherId);
    saveUsers(users);
    if(window.Security) window.Security.logAction("user", `Usuario eliminado (docente): ${teacherId}`);
  }

  // Render en teachers.html
  function renderTable(){
    const body = q("teachersTableBody");
    if(!body) return;
    const list = load();
    body.innerHTML = list.map(t => `
      <tr data-id="${t.id}">
        <td>${t.id}</td>
        <td><img src="${t.photo || '../../img/undraw_profile.svg'}" style="width:40px;border-radius:50%"/></td>
        <td>${(t.firstName||'') + ' ' + (t.lastName||'')}</td>
        <td>${t.email||''}</td>
        <td>${t.phone||''}</td>
        <td>${t.position||''}</td>
        <td>${t.isActive == "0" ? 'Inactivo' : 'Activo'}</td>
        <td>
          <a class="btn btn-sm btn-info" href="teacher-detail.html?id=${t.id}">Editar</a>
          <button class="btn btn-sm btn-danger btn-delete" data-id="${t.id}">Eliminar</button>
        </td>
      </tr>
    `).join("") || "<tr><td colspan='8' class='text-center'>No hay docentes</td></tr>";
  }

  function bindTableActions(){
    const body = q("teachersTableBody");
    if(!body) return;
    body.addEventListener("click", e=>{
      const btn = e.target.closest(".btn-delete");
      if(!btn) return;
      const id = btn.getAttribute("data-id");
      if(!id) return;
      if(!confirm("Eliminar docente?")) return;
      const list = load().filter(x => x.id !== id);
      save(list);
      // eliminar usuario asociado
      removeUserByTeacherId(id);
      renderTable();
      if(window.Security) window.Security.logAction("teacher", `Docente eliminado: ${id}`);
    });
  }

  // Form en teacher-detail.html
  function bindDetailForm(){
    const form = q("teacherDetailForm");
    if(!form) return;
    const id = param("id");
    if(id){
      const t = load().find(x => x.id === id);
      if(t){
        q("firstName").value = t.firstName || "";
        q("lastName").value = t.lastName || "";
        q("email").value = t.email || "";
        q("phone").value = t.phone || "";
        q("position").value = t.position || "";
        q("isActive").value = t.isActive != null ? t.isActive : "1";
        q("qualifications").value = t.qualifications || "";
        const photo = q("teacherPhoto"); if(photo && t.photo) photo.src = t.photo;
        const viewBtn = q("viewTasksBtn"); if(viewBtn) viewBtn.href = `employee-tasks.html?empId=${id}`;
      }
    } else {
      const viewBtn = q("viewTasksBtn"); if(viewBtn) viewBtn.href = `employee-tasks.html?empId=`;
    }

    form.addEventListener("submit", e=>{
      e.preventDefault();
      const payload = {
        firstName: q("firstName").value.trim(),
        lastName: q("lastName").value.trim(),
        email: q("email").value.trim(),
        phone: q("phone").value.trim(),
        position: q("position").value.trim(),
        isActive: q("isActive").value,
        qualifications: q("qualifications").value.trim(),
        photo: q("teacherPhoto") ? q("teacherPhoto").src : null,
        updatedAt: new Date().toISOString()
      };
      const list = load();
      if(id){
        const idx = list.findIndex(x => x.id === id);
        if(idx >= 0){
          list[idx] = Object.assign({}, list[idx], payload);
          save(list);
          // actualizar usuario vinculado
          createOrUpdateUserFromTeacher(Object.assign({ id: id }, list[idx]));
          if(window.Security) window.Security.logAction("teacher", `Docente editado: ${id}`);
        }
      } else {
        payload.id = uid();
        payload.createdAt = new Date().toISOString();
        list.push(payload);
        save(list);
        // crear usuario vinculado
        createOrUpdateUserFromTeacher(Object.assign({ id: payload.id }, payload));
        // asegurar rol en el sistema para que aparezca en Manage Users / Roles
        ensureRoleExists("teacher");
        if(window.Security) window.Security.logAction("teacher", `Docente creado: ${payload.id}`);
      }
      // redirigir a la lista y forzar recarga
      location.href = "teachers.html";
    });
  }

  function init(){
    renderTable();
    bindTableActions();
    bindDetailForm();
    window.Teachers = { load, save, renderTable };
  }

  document.addEventListener("DOMContentLoaded", init);
  // sincronizar entre pestañas
  window.addEventListener("storage", () => { try{ renderTable(); }catch(e){} });
})();
