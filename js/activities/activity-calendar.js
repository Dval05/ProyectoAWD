$(function(){
  requireAuth();

  // Asegúrate de haber incluido FullCalendar y moment.js en tu HTML:
  // 

  $('#activityCalendar').fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay,listMonth'
    },
    buttonText: {
      today:    'Hoy',
      month:    'Mes',
      week:     'Semana',
      day:      'Día',
      list:     'Lista'
    },
    locale: 'es',
    eventLimit: true,
    events: function(start, end, timezone, callback) {
      $.get("../../php/activities/get_all.php", function(resp){
        if(resp.success && Array.isArray(resp.data)){
          const events = resp.data.map(function(a){
            return {
              id: a.ActivityID,
              title: a.Name,
              start: a.ScheduledDate,
              description: a.Description || "",
              allDay: true, // Si tus actividades son solo de día
              extendedProps: {
                grade: a.GradeName || "",
                teacher: ((a.TeacherFirstName||"") + " " + (a.TeacherLastName||"")).trim(),
                status: a.Status || ""
              }
            };
          });
          callback(events);
        } else {
          callback([]);
        }
      });
    },
    eventRender: function(event, element) {
      // Tooltip simple
      if(event.description){
        element.attr('title', event.description);
      }
    },
    eventClick: function(event) {
      // Muestra un modal básico con el detalle
      let html = `
        <strong>Nombre:</strong> ${event.title}<br>
        <strong>Fecha:</strong> ${event.start ? event.start.format("YYYY-MM-DD") : ""}<br>
        <strong>Estado:</strong> ${event.extendedProps.status || ""}<br>
        <strong>Grado:</strong> ${event.extendedProps.grade || ""}<br>
        <strong>Docente:</strong> ${event.extendedProps.teacher || ""}<br>
        <strong>Descripción:</strong><br>
        <span>${event.description||""}</span>
      `;
      $('<div class="modal fade" tabindex="-1" role="dialog">' +
        '<div class="modal-dialog" role="document">' +
        '<div class="modal-content">' +
        '<div class="modal-header"><h5 class="modal-title">Detalle de Actividad</h5>' +
        '<button type="button" class="close" data-dismiss="modal">&times;</button></div>' +
        '<div class="modal-body">'+ html +'</div>' +
        '<div class="modal-footer"><button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button></div>' +
        '</div></div></div>'
      ).appendTo('body').modal('show').on('hidden.bs.modal', function(){
        $(this).remove();
      });
    }
  });
});
