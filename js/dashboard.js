$(function(){
  requireAuth();

  // Carga métricas principales
  function loadSummary(){
    $.get(API_BASE_URL + "/dashboard/summary.php", function(res) {
      if(res.success){
        $("#totalStudents").text(res.data.students);
        $("#totalTeachers").text(res.data.teachers);
        $("#todayAttendance").text(res.data.todayAttendance+"%");
        $("#attendanceProgress").css("width", res.data.todayAttendance+"%");
        $("#monthlyRevenue").text(moneyFormat(res.data.monthlyRevenue));
      }
    });
  }

  // Carga gráfico de asistencia semanal (requiere Chart.js)
  function loadAttendanceChart(){
    $.get(API_BASE_URL + "/dashboard/weekly_attendance.php", function(res){
      if(res.success){
        var ctx = document.getElementById("attendanceChart").getContext("2d");
        new Chart(ctx, {
          type: "line",
          data: {
            labels: res.data.days, // Ej: ["Lunes","Martes",...]
            datasets: [{
              label: "Asistencias",
              data: res.data.values,
              backgroundColor: "rgba(78, 115, 223, 0.05)",
              borderColor: "rgba(78, 115, 223, 1)",
              pointRadius: 3,
              borderWidth: 2
            }]
          },
          options: {
            scales: { yAxes: [{ticks:{beginAtZero:true}}] }, legend:{display:false}
          }
        });
      }
    });
  }

  // Carga actividades recientes
  function loadRecentActivities(){
    $.get(API_BASE_URL + "/activities/recent.php", function(res){
      let b = "";
      if(res.success && res.data.length){
        res.data.forEach(a=>{
          b += `<div class="mb-2">
                  <strong>${a.Name}</strong> (${dateToString(a.Date)})<br>
                  <span class="text-muted">${a.Description||""}</span>
                </div>`;
        });
      } else {
        b = `<p class="text-center text-muted">Sin actividades recientes</p>`;
      }
      $("#recentActivities").html(b);
    });
  }

  // Carga pagos pendientes
  function loadPendingPayments(){
    $.get(API_BASE_URL + "/payments/student/pending.php", function(res){
      let b = "";
      if(res.success && res.data.length){
        res.data.forEach(p=>{
          b += `<tr>
                  <td>${p.StudentName}</td>
                  <td>${moneyFormat(p.Amount)}</td>
                  <td>${dateToString(p.DueDate)}</td>
                </tr>`;
        });
      } else {
        b = `<tr><td colspan="3" class="text-center text-muted">Sin pagos pendientes</td></tr>`;
      }
      $("#pendingPaymentsTable").html(b);
    });
  }

  // Próximas actividades
  function loadUpcomingActivities(){
    $.get(API_BASE_URL + "/activities/upcoming.php", function(res){
      let b = "";
      if(res.success && res.data.length){
        res.data.forEach(act=>{
          b += `<tr>
                  <td>${act.Name}</td>
                  <td>${dateToString(act.Date)}</td>
                  <td>${act.Status}</td>
                </tr>`;
        });
      } else {
        b = `<tr><td colspan="3" class="text-center text-muted">Sin actividades próximas</td></tr>`;
      }
      $("#upcomingActivitiesTable").html(b);
    });
  }

  // Inicializar Dashboard
  loadSummary();
  loadAttendanceChart();
  loadRecentActivities();
  loadPendingPayments();
  loadUpcomingActivities();
});
