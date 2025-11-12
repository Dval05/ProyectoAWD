$(function() {
    const token = localStorage.getItem("authToken");
    if (!token) {
        $("#accordionSidebar").html('<li class="nav-item"><span class="nav-link text-danger">Sin sesión</span></li>');
        return;
    }

    $.ajax({
        url: API_BASE_URL + "/users/get_sidebar_links.php",
        method: "GET",
        headers: {
            "Authorization": "Bearer " + token
        },
        success: function(resp) {
            // Debug links recibidos
            console.log(resp.links); 

            if (resp.success && resp.links.length > 0) {
                let html = `<a class="sidebar-brand d-flex align-items-center justify-content-center" href="#" onclick="goHTML('dashboard.html'); return false;">
                    <div class="sidebar-brand-icon"><i class="fas fa-child"></i></div>
                    <div class="sidebar-brand-text mx-3">NICEKIDS</div>
                </a>
                <hr class="sidebar-divider">`;
                resp.links.forEach(item => {
                    // Debug de cada ruta
                    console.log(item.Link, item.Title);
                    html += `<li class="nav-item">
                        <a class="nav-link" href="#" onclick="goHTML('${item.Link}'); return false;">
                            <i class="fas fa-fw ${item.Icon}"></i>
                            <span>${item.Title}</span>
                        </a>
                    </li>`;
                });
                $("#accordionSidebar").html(html);
            } else {
                $("#accordionSidebar").html('<li class="nav-item"><span class="nav-link text-muted">Sin permisos</span></li>');
            }
        },
        error: function() {
            $("#accordionSidebar").html('<li class="nav-item"><span class="nav-link text-danger">Error al cargar menú</span></li>');
        }
    });
});