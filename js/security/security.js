(function () {
  const ROLES_KEY = "security_roles_v1";
  const LOGS_KEY = "security_logs_v1";
  const INACTIVITY_MINUTES = 30; // timeout en minutos

  function loadRoles() {
    try { return JSON.parse(localStorage.getItem(ROLES_KEY) || "[]"); } catch(e){ return []; }
  }
  function saveRoles(r) { localStorage.setItem(ROLES_KEY, JSON.stringify(r)); }

  function loadLogs() {
    try { return JSON.parse(localStorage.getItem(LOGS_KEY) || "[]"); } catch(e){ return []; }
  }
  function saveLogs(l) { localStorage.setItem(LOGS_KEY, JSON.stringify(l)); }

  function addRole(name) {
    const roles = loadRoles();
    if (!name) return;
    if (roles.includes(name)) return;
    roles.push(name);
    saveRoles(roles);
    renderRolesList();
    logAction("role", `Rol creado: ${name}`);
  }
  function removeRole(name) {
    const roles = loadRoles().filter(r => r !== name);
    saveRoles(roles);
    renderRolesList();
    logAction("role", `Rol eliminado: ${name}`);
  }

  function logAction(type, description) {
    const user = (document.getElementById("userName") && document.getElementById("userName").textContent) || "Anon";
    const logs = loadLogs();
    logs.push({ id: Date.now().toString(36), type, description, user, ts: new Date().toISOString() });
    saveLogs(logs);
    updateNotificationCount();
  }

  function updateNotificationCount() {
    const el = document.getElementById("notificationCount");
    if (!el) return;
    const logs = loadLogs();
    el.textContent = logs.length || 0;
  }

  // Role modal binding (teachers page)
  function renderRolesList() {
    const ul = document.getElementById("rolesList");
    if (!ul) return;
    const roles = loadRoles();
    ul.innerHTML = roles.map(r => `<li class="list-group-item d-flex justify-content-between align-items-center">${r}<button class="btn btn-sm btn-danger btn-remove-role" data-role="${r}">Eliminar</button></li>`).join("");
  }

  function bindRoleModal() {
    const modal = document.getElementById("roleModal");
    const form = document.getElementById("roleForm");
    if (!modal || !form) return;
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const name = document.getElementById("roleName").value.trim();
      if (!name) return;
      addRole(name);
      document.getElementById("roleName").value = "";
    });
    document.addEventListener("click", (ev) => {
      if (ev.target.classList && ev.target.classList.contains("btn-remove-role")) {
        const role = ev.target.getAttribute("data-role");
        if (confirm(`Eliminar rol ${role}?`)) removeRole(role);
      }
    });
    renderRolesList();
  }

  // Auto logout por inactividad
  let inactivityTimer = null;
  function resetInactivity() {
    clearTimeout(inactivityTimer);
    inactivityTimer = setTimeout(() => {
      doLogout();
    }, INACTIVITY_MINUTES * 60 * 1000);
  }
  function doLogout() {
    logAction("security", "Cierre de sesión automático por inactividad");
    // comportamiento simple: redirigir a login (ajusta segun proyecto)
    alert("Sesión cerrada por inactividad.");
    try { location.href = "/login.html"; } catch (e) {}
  }

  function bindInactivity() {
    ["mousemove","keydown","click","touchstart"].forEach(ev => {
      document.addEventListener(ev, resetInactivity, { passive: true });
    });
    resetInactivity();
  }

  function init() {
    // expose global for other modules
    window.Security = {
      addRole, removeRole, logAction, loadRoles, loadLogs
    };
    updateNotificationCount();
    bindRoleModal();
    bindInactivity();
    // if there is a rolesList element, render
    renderRolesList();
  }

  document.addEventListener("DOMContentLoaded", init);

  // auto update notification when new logs from other tabs
  window.addEventListener("storage", () => updateNotificationCount());

})();
