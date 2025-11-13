$(function(){
  requireAuth();

  // Ensure AJAX requests include the auth token so server middleware authorizes them.
  $.ajaxSetup({
    headers: {
      'Authorization': 'Bearer ' + (getToken()||''),
      'X-Auth-Token': getToken()||''
    }
  });

  // caches
  var rolesCache = [];
  var rolesOptionsHtml = '<option value="">-- Seleccione un rol --</option>';

  // Load users and roles into the tables
  function loadUsers(){
    $.ajax({
      url: API_BASE_URL+"/users/get_all.php",
      method: 'GET',
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + (getToken()||''),
        'X-Auth-Token': getToken()||''
      }
    }).done(function(r){
        let users = [];
        if (Array.isArray(r)) users = r;
        else if (r && r.success && Array.isArray(r.data)) users = r.data;
        else if (r && Array.isArray(r.data)) users = r.data;

        let b = "";
        if (users.length){
          users.forEach(u=>{
            b += `<tr>
              <td>${u.UserName||''}</td>
              <td>${u.FirstName||''}</td>
              <td>${u.LastName||''}</td>
              <td>${u.Email||''}</td>
              <td>${u.Phone||''}</td>
              <td>${u.Address||''}</td>
              <td>${u.IsActive && (u.IsActive==1 || u.IsActive==true) ? "Sí" : "No"}</td>
              <td>${u.LastLogin||''}</td>
              <td><a href="#" class="btn btn-info btn-sm">Editar</a></td>
            </tr>`;
          });
        } else {
          b = '<tr><td colspan="9" class="text-center">Sin usuarios</td></tr>';
        }
        $("#usersTableBody").html(b);
      })
      .fail(function(xhr){
        var msg = 'Error al cargar usuarios';
        try {
          var j = JSON.parse(xhr.responseText);
          if (j && j.msg) msg = j.msg;
          else if (j && j.message) msg = j.message;
        } catch(e){}
        $("#usersTableBody").html('<tr><td colspan="9" class="text-center text-danger">'+msg+'</td></tr>');
        console.error('loadUsers error', xhr.status, xhr.responseText);
      });
  }

  function loadRoles(){
    // return the promise so callers can chain when roles are ready
    return $.ajax({
      url: API_BASE_URL+"/roles/get_all.php",
      method: 'GET',
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + (getToken()||''),
        'X-Auth-Token': getToken()||''
      }
    }).done(function(r){
      let roles = [];
      if (r && r.success && Array.isArray(r.data)) roles = r.data;
      else if (Array.isArray(r)) roles = r;

      let b = "";
      rolesOptionsHtml = '<option value="">-- Seleccione un rol --</option>';
      rolesCache = roles;
      if (roles.length){
        roles.forEach(role=>{
          b += `<tr>
            <td>${role.RoleName||''}</td>
            <td>${role.Description||''}</td>
            <td>${role.IsActive && (role.IsActive==1 || role.IsActive==true) ? 'Sí' : 'No'}</td>
            <td><a href="#" class="btn btn-sm btn-info">Editar</a></td>
          </tr>`;
          // build global select options but skip the Director role (don't include it in selects)
          const roleName = (role.RoleName||role.name||'').toString().trim();
          const roleId = role.RoleID||role.id||'';
          if (roleName.toLowerCase() !== 'director' && String(roleId) !== '1') {
            rolesOptionsHtml += `<option value="${roleId}">${roleName}</option>`;
          }
        });
      } else {
        b = '<tr><td colspan="4" class="text-center">Sin roles</td></tr>';
      }
      $("#rolesTableBody").html(b);
      // populate the Role select in the add-user modal if present
      if($('#RoleID').length){
        $('#RoleID').html(rolesOptionsHtml);
      }
    });
  }

  // initial load
  loadUsers();
  loadRoles();

  // Open select-user modal and populate table
  function loadUsersForModal(){
    $.ajax({
      url: API_BASE_URL+"/users/get_all.php",
      method: 'GET',
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + (getToken()||''),
        'X-Auth-Token': getToken()||''
      }
    }).done(function(r){
        let users = [];
        if (Array.isArray(r)) users = r;
        else if (r && r.success && Array.isArray(r.data)) users = r.data;
        else if (r && Array.isArray(r.data)) users = r.data;

        let b = "";
        if (users.length){
          users.forEach(u=>{
            const currentRole = u.Role || u.RoleName || '';
            const userId = u.UserID || u.id || '';
            b += `<tr>
              <td>${u.UserName||''}</td>
              <td>${(u.FirstName||'') + ' ' + (u.LastName||'')}</td>
              <td>${u.Email||''}</td>
              <td class="current-role">${currentRole}</td>
              <td>
                <select class="form-control form-control-sm role-select" data-userid="${userId}">
                  ${rolesOptionsHtml}
                </select>
              </td>
              <td><button class="btn btn-sm btn-primary btn-assign-role" data-userid="${userId}">Asignar</button></td>
            </tr>`;
          });
        } else {
          b = '<tr><td colspan="6" class="text-center">Sin usuarios</td></tr>';
        }
        $('#selectUserTableBody').html(b);
        // If rolesCache has values and some users already have role id, preselect
        // Try to preselect by matching role name -> option text
        if(rolesCache.length){
          $('#selectUserTableBody tr').each(function(){
            const curRole = $(this).find('.current-role').text().trim();
            if(curRole){
              const sel = $(this).find('select.role-select');
              sel.find('option').each(function(){
                if($(this).text().trim() === curRole){ $(this).prop('selected', true); }
              });
            }
          });
        }
      })
      .fail(function(xhr){
        alert('Error al cargar usuarios: ' + xhr.status);
      });
  }

  // show modal on button click
  $('#btnSelectUser').on('click', function(e){
    e.preventDefault();
    // ensure roles are loaded first, then open modal
    loadRoles().done(function(){
      loadUsersForModal();
      $('#selectUserModal').modal('show');
    }).fail(function(){
      alert('No se pudieron cargar los roles. Intente de nuevo.');
    });
  });

  // delegate assign button click
  $(document).on('click', '.btn-assign-role', function(e){
    e.preventDefault();
    const userId = $(this).data('userid');
    const row = $(this).closest('tr');
    const selectedRole = row.find('select.role-select').val();
    if(!selectedRole){ alert('Seleccione un rol para asignar'); return; }
    const token = getToken();
    if(!token){ alert('No autenticado'); return; }

    const btn = $(this);
    btn.prop('disabled', true).text('Asignando...');

    $.ajax({
      url: API_BASE_URL + '/roles/assign_to_user.php',
      method: 'POST',
      data: { UserID: userId, RoleID: selectedRole },
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + token,
        'X-Auth-Token': token
      },
      success: function(res){
        if(res && res.success){
          // update current role cell
          const roleName = rolesCache.find(r=>String(r.RoleID||r.id) === String(selectedRole));
          row.find('.current-role').text(roleName ? (roleName.RoleName||roleName.name) : selectedRole);
          // refresh main lists
          loadUsers();
          loadRoles();
        } else {
          const msg = (res && (res.msg||res.message)) ? (res.msg||res.message) : 'Error al asignar rol';
          alert(msg);
        }
      },
      error: function(xhr){
        var msg = 'Error en la petición: ' + xhr.status;
        try { var j = JSON.parse(xhr.responseText); if(j && (j.msg||j.message)) msg = j.msg||j.message; } catch(e){}
        alert(msg);
      },
      complete: function(){ btn.prop('disabled', false).text('Asignar'); }
    });
  });

  // Open modal
  $("#btnAddUser").on('click', function(e){
    e.preventDefault();
    // reset form
    $("#addUserForm")[0].reset();
    $("#addUserAlert").removeClass('alert-success alert-danger').addClass('d-none').text('');
    $('#addUserModal').modal('show');
  });

  // Save new user
  $("#saveUserBtn").on('click', function(){
    const data = {
      UserName: $("#UserName").val().trim(),
      Email: $("#Email").val().trim(),
      FirstName: $("#FirstName").val().trim(),
      LastName: $("#LastName").val().trim(),
      Phone: $("#Phone").val().trim(),
      Address: $("#Address").val().trim(),
      RoleID: $('#RoleID').length ? $('#RoleID').val() : '',
      Password: $("#Password").val()
    };
    const pwdConfirm = $("#PasswordConfirm").val();

    // basic validation
    if(!data.UserName){ showAddUserAlert('El usuario es requerido','danger'); return; }
    if(!data.Email){ showAddUserAlert('El email es requerido','danger'); return; }
    if(!data.Password){ showAddUserAlert('La contraseña es requerida','danger'); return; }
    if(data.Password !== pwdConfirm){ showAddUserAlert('Las contraseñas no coinciden','danger'); return; }

    // submit
    $.ajax({
      url: API_BASE_URL + '/users/create.php',
      method: 'POST',
      data: data,
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + (getToken()||''),
        'X-Auth-Token': getToken()||''
      },
      success: function(res){
        if(res && res.success){
          showAddUserAlert('Usuario creado correctamente','success');
          // small delay to show success then close
          setTimeout(function(){
            $('#addUserModal').modal('hide');
            // refresh lists so the new user appears everywhere (main table and select-user modal)
            loadUsers();
            // refresh roles (in case role lists depend on counts) and update modal if it's open
            loadRoles().done(function(){
              if($('#selectUserModal').hasClass('show')){
                loadUsersForModal();
              }
            });
          }, 800);
        } else {
          const msg = (res && res.msg) ? res.msg : 'Error al crear usuario';
          showAddUserAlert(msg,'danger');
        }
      },
      error: function(xhr){
        showAddUserAlert('Error en la petición: ' + xhr.status,'danger');
      }
    });
  });

  function showAddUserAlert(msg, type){
    const a = $("#addUserAlert");
    a.removeClass('d-none alert-success alert-danger').addClass('alert-' + (type=='success'?'success':'danger'));
    a.text(msg);
  }

});
