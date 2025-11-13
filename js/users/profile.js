$(function(){
	requireAuth();

	// Ensure AJAX includes stored token and cookies (session) as fallback
	$.ajaxSetup({
		headers: {
			'Authorization': 'Bearer ' + (getToken()||''),
			'X-Auth-Token': getToken()||''
		},
		xhrFields: { withCredentials: true }
	});

	function showProfile(u){
		const full = ((u.FirstName||'').trim() + ' ' + (u.LastName||'').trim()).trim();
		$('#userFullName').text(full || u.UserName || 'Usuario');
		$('#userEmail').text(u.Email || '-');
		$('#userPhone').text(u.Phone || '-');
		$('#userAddress').text(u.Address || '-');
		$('#userLastLogin').text(u.LastLogin || '-');
		// photo handling placeholder
		if(u.ProfilePicture){
			$('#profilePhoto').attr('src', u.ProfilePicture);
		}
	}

	// Load profile (session-based) then attempt to resolve role via get_all
	function loadProfile(){
		$.ajax({
			url: API_BASE_URL + '/users/get_profile.php',
			method: 'GET',
			dataType: 'json'
		}).done(function(res){
			if(!res || res.success===false){
				const msg = (res && res.msg) ? res.msg : 'No autenticado';
				console.warn('get_profile:', msg);
				// redirect to login
				window.location.href = '../login.html';
				return;
			}
			// res is the user object
			showProfile(res);

			// try to fetch roles via users/get_all.php to find current role name
			$.ajax({
				url: API_BASE_URL + '/users/get_all.php',
				method: 'GET',
				dataType: 'json'
			}).done(function(list){
				let users = [];
				if(Array.isArray(list)) users = list;
				else if(list && list.success && Array.isArray(list.data)) users = list.data;

				const me = users.find(u=>String(u.UserID) === String(res.UserID));
				if(me){
					const roleName = me.Role || me.RoleName || '';
					$('#userRole').text(roleName || 'Sin rol');
				} else {
					$('#userRole').text('Sin rol');
				}
			}).fail(function(){
				$('#userRole').text('Sin rol');
			});

		}).fail(function(xhr){
			console.error('Failed to load profile', xhr.status, xhr.responseText);
			window.location.href = '../login.html';
		});
	}

	// initial load
	loadProfile();

	// Edit button placeholder (can be wired to an edit form)
	$('#btnEditProfile').on('click', function(){
		alert('Funcionalidad de edición aún no implementada');
	});

	// Change password handler (calls PHP/users/change_password.php)
	$('#changePasswordForm').on('submit', function(e){
		e.preventDefault();
		const current = $('#currentPassword').val();
		const nw = $('#newPassword').val();
		const conf = $('#confirmNewPassword').val();
		if(!current || !nw || !conf){ alert('Complete todos los campos'); return; }
		if(nw !== conf){ alert('Las contraseñas no coinciden'); return; }

		$.ajax({
			url: API_BASE_URL + '/users/change_password.php',
			method: 'POST',
			data: { currentPassword: current, newPassword: nw },
			dataType: 'json'
		}).done(function(res){
			if(res && res.success){ alert('Contraseña actualizada'); $('#changePasswordForm')[0].reset(); }
			else alert(res && (res.msg||res.message) ? (res.msg||res.message) : 'Error al actualizar contraseña');
		}).fail(function(xhr){
			alert('Error en la petición: ' + xhr.status);
		});
	});

});
