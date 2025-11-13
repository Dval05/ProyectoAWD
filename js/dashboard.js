$(function(){
  // Total estudiantes
  $.get("../php/dashboard/total_students.php", resp=>{
    if(resp.success) $("#totalStudents").text(resp.total);
  });

  // Total teachers
  $.get("../php/dashboard/total_teachers.php", resp=>{
    if(resp.success) $("#totalTeachers").text(resp.total);
  });

  // Asistencia hoy
  $.get("../php/dashboard/today_attendance.php", resp=>{
    if(resp.success){
      $("#todayAttendance").text(resp.percent+"%");
      $("#attendanceProgress").css("width", resp.percent+"%").attr("aria-valuenow", resp.percent);
    }
  });

  // Ingresos mes
  $.get("../php/dashboard/monthly_revenue.php", resp=>{
    if(resp.success) $("#monthlyRevenue").text("$"+(resp.revenue||0).toLocaleString("es-EC",{minimumFractionDigits:2}));
  });

  // Actividades recientes
  $.get("../php/dashboard/recent_activities.php", resp=>{
    if(resp.success && resp.data.length){
      let b = "<ul class='list-group'>";
      resp.data.forEach(a=>{
        b += `<li class='list-group-item d-flex justify-content-between align-items-center'>
          <span>${a.Name} (${a.Category||''})<br/><small>${a.ScheduledDate}</small></span>
          <span class="badge badge-${a.Status=='Completed'?'success':a.Status=='In Progress'?'info':a.Status=='Cancelled'?'danger':'secondary'}">${a.Status}</span>
        </li>`;
      });
      b+="</ul>";
      $("#recentActivities").html(b);
    }else{
      $("#recentActivities").html("<p class='text-muted text-center'>Sin actividades recientes</p>");
    }
  });

  // Pagos pendientes
  $.get("../php/dashboard/pending_payments.php", resp=>{
    let b = "";
    if(resp.success && resp.data.length){
      resp.data.forEach(p=>{
        b += `<tr><td>${p.FirstName} ${p.LastName}</td><td>$${p.TotalAmount}</td><td>${p.DueDate}</td></tr>`;
      });
    } else {
      b = `<tr><td colspan="3" class="text-center text-muted">Sin pagos pendientes</td></tr>`;
    }
    $("#pendingPaymentsTable").html(b);
  });

  // Próximas actividades
  $.get("../php/dashboard/upcoming_activities.php", resp=>{
    let b = "";
    if(resp.success && resp.data.length){
      resp.data.forEach(a=>{
        b += `<tr><td>${a.Name}</td><td>${a.ScheduledDate}</td><td>${a.Status}</td></tr>`;
      });
    } else {
      b = `<tr><td colspan="3" class="text-center text-muted">Sin próximas actividades</td></tr>`;
    }
    $("#upcomingActivitiesTable").html(b);
  });

  // Chart asistencia semanal
  $.get("../php/dashboard/attendance_week.php", resp=>{
    if(resp.success && window.Chart){
      let ctx = document.getElementById('attendanceChart').getContext('2d');
      new Chart(ctx, {
        type: 'line',
        data: {
          labels: resp.labels,
          datasets: [{
            label: "Asistencia %",
            data: resp.data,
            borderColor: "#4e73df",
            backgroundColor: "rgba(78,115,223,0.1)",
            fill: true
          }]
        },
        options: {
          scales: {
            y: {beginAtZero: true,max:100}
          }
        }
      });
    }
  });
});
