$(function(){
    // Configurar URL base de la API
    if (typeof API_BASE_URL === "undefined" || !API_BASE_URL) {
        window.API_BASE_URL = window.location.origin + "/ProyectoAWD/api";
    }

    // Abrir modal para crear rol
    $("#btnAddRole").on("click", function(e){
        e.preventDefault();
        $("#formAddRole")[0].reset();
        $("#roleActive").prop("checked", true);
        $("#modalAddRole").modal("show");
    });

    // Crear nuevo rol
    $("#btnSaveRole").on("click", function(){
        if ($(this).prop("disabled")) return;

        const roleName = $("#roleName").val().trim();
        const roleDescription = $("#roleDescription").val().trim();
        const isActive = $("#roleActive").is(":checked");

        // Validaciones básicas
        if (!roleName) {
            alert("El nombre del rol es requerido");
            $("#roleName").focus();
            return;
        }
        if (!roleDescription) {
            alert("La descripción es requerida");
            $("#roleDescription").focus();
            return;
        }

        const token = localStorage.getItem("authToken");

        // Preparar datos
        const roleData = {
            Name: roleName,
            Description: roleDescription,
            IsActive: isActive ? 1 : 0
        };

        console.log("Datos del rol a enviar:", roleData);

        // Deshabilitar botón
        $("#btnSaveRole").prop("disabled", true).text("Creando...");

        // URLs a probar para localhost
        const urlsToTry = [
            API_BASE_URL + "/roles/create.php",
            window.location.origin + "/ProyectoAWD/api/roles/create.php",
            window.location.origin + "/ProyectoAWD/roles/create.php",
            window.location.origin + "/ProyectoAWD/create_role.php"
        ];

        let currentUrlIndex = 0;

        function tryNextUrl() {
            if (currentUrlIndex >= urlsToTry.length) {
                // Último intento: inserción directa para localhost
                tryDirectRoleInsert();
                return;
            }

            const currentUrl = urlsToTry[currentUrlIndex];
            console.log("Probando URL para rol:", currentUrl);

            $.ajax({
                url: currentUrl,
                method: "POST",
                data: roleData,
                timeout: 5000,
                success: function(response) {
                    console.log("Éxito con URL:", currentUrl);
                    console.log("Respuesta:", response);
                    
                    // Normalize response to role object if possible
                    let created = null;
                    try {
                        if (typeof response === "string") {
                            const parsed = JSON.parse(response);
                            created = parsed.data || parsed.role || parsed;
                        } else if (typeof response === "object") {
                            created = response.data || response.role || response;
                        }
                    } catch(e) {
                        created = null;
                    }
                    // fallback to sent data
                    if (!created) created = roleData;
                    addRoleToUI(created);
                    alert("Rol creado exitosamente");
                    $("#modalAddRole").modal("hide");
                    $("#formAddRole")[0].reset();
                    $("#btnSaveRole").prop("disabled", false).text("Crear Rol");
                },
                error: function(xhr, textStatus, errorThrown) {
                    console.log("Error con URL:", currentUrl, "Status:", xhr.status);
                    currentUrlIndex++;
                    tryNextUrl();
                }
            });
        }

        function tryDirectRoleInsert() {
            console.log("Intentando inserción directa de rol...");
            
            $.ajax({
                url: window.location.origin + "/ProyectoAWD/temp_create_role.php",
                method: "POST",
                data: {
                    name: roleData.Name,
                    description: roleData.Description,
                    is_active: roleData.IsActive,
                    create_role: true
                },
                success: function(response) {
                    console.log("Respuesta directa rol:", response);
                    let created = null;
                    try {
                        if (typeof response === "string") {
                            const parsed = JSON.parse(response);
                            created = parsed.data || parsed.role || parsed;
                        } else if (typeof response === "object") {
                            created = response.data || response.role || response;
                        }
                    } catch(e) {
                        created = null;
                    }
                    if (!created) created = roleData;
                    addRoleToUI(created);
                    alert("Rol creado exitosamente");
                    $("#modalAddRole").modal("hide");
                    $("#formAddRole")[0].reset();
                    $("#btnSaveRole").prop("disabled", false).text("Crear Rol");
                },
                error: function() {
                    alert("No se pudo crear el rol. Verifica que el servidor esté funcionando y la base de datos esté disponible.");
                },
                complete: function() {
                    $("#btnSaveRole").prop("disabled", false).text("Crear Rol");
                }
            });
        }

        /* new helper: safely escape HTML for insertion */
        function escapeHtml(str) {
            if (typeof str !== "string") return str;
            return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
                      .replace(/"/g, "&quot;").replace(/'/g, "&#039;");
        }

        /* new helper: add role to roles table and to role <select> used when creating users */
        function addRoleToUI(role) {
            if (!role) return;
            const name = role.Name || role.name || role.Role || role.role || "";
            const desc = role.Description || role.description || "";
            const isActive = (role.IsActive !== undefined) ? (role.IsActive ? 1 : 0) : (role.is_active ? 1 : 0);
            const id = role.Id || role.id || ("local-" + Date.now());

            // Avoid duplicate option / row by checking existing entries (by name or id)
            if ($("#rolesTableBody").find(`tr[data-role-id="${escapeHtml(id)}"]`).length === 0) {
                const activeText = isActive ? "Sí" : "No";
                const row = `<tr data-role-id="${escapeHtml(id)}">
                    <td>${escapeHtml(name)}</td>
                    <td>${escapeHtml(desc)}</td>
                    <td>${escapeHtml(activeText)}</td>
                    <td><button class="btn btn-sm btn-danger btn-delete-role">Eliminar</button></td>
                </tr>`;
                $("#rolesTableBody").append(row);
            }

            // Add option to the user-role <select> if not present
            const select = $("#role");
            if (select.length) {
                const existingOpt = select.find(`option[value="${escapeHtml(name)}"]`);
                if (existingOpt.length === 0) {
                    select.append(`<option value="${escapeHtml(name)}">${escapeHtml(name)}</option>`);
                }
            }
        }

        // Iniciar el proceso
        tryNextUrl();
    });
});
