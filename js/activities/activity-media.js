$(function() {
  requireAuth();

  // Cambia este endpoint si tienes filtro por activityID
  const ENDPOINT = "../../php/activities/get_media.php";

  // Cargar todos los archivos/media de actividades (o de una en particular si tienes el parámetro)
  function loadMediaGallery() {
    // Si quieres filtrar por actividad: ?ActivityID=xx
    $.get(ENDPOINT, function(resp){
      let html = "";
      if(resp.success && Array.isArray(resp.data) && resp.data.length > 0){
        resp.data.forEach(m => {
          let mediaHtml = "";
          // Imagen
          if(m.MediaType && m.MediaType.toLowerCase() === "image") {
            mediaHtml = `
              <img src="${m.FilePath}" class="img-fluid rounded mb-2" style="max-height:180px; border:1px solid #eee;">
            `;
          }
          // Video
          else if(m.MediaType && m.MediaType.toLowerCase() === "video") {
            mediaHtml = `
              <video controls class="w-100 mb-2" style="max-height:180px;">
                <source src="${m.FilePath}">
                Tu navegador no soporta video.
              </video>
            `;
          }
          // Documento
          else if(m.MediaType && m.MediaType.toLowerCase() === "document") {
            mediaHtml = `
              <a href="${m.FilePath}" target="_blank" class="btn btn-outline-secondary w-100 mb-2">
                <i class="fas fa-file-alt"></i> Ver documento
              </a>
            `;
          }
          html += `
            <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
              <div class="card h-100 shadow-sm">
                <div class="card-body text-center p-2">
                  ${mediaHtml}
                  <div class="text-truncate"><strong>${m.Caption || ''}</strong></div>
                  <small class="text-muted">${m.CreatedAt ? m.CreatedAt.split(' ')[0] : ''}</small>
                </div>
              </div>
            </div>
          `;
        });
      } else {
        html = `<div class="col-12"><div class="alert alert-info text-center">No hay material multimedia cargado.</div></div>`;
      }
      $("#activityMediaGallery").html(html);
    });
  }

  loadMediaGallery();
});
