$(function(){
  requireAuth();
  loadGrades();
  loadStudents();

  $("#btnApplyFilters").click(function(e){
    e.preventDefault();
    loadStudents();
  });

  $("#btnClearFilters").click(function(e){
    e.preventDefault();
    $("#filterGrade,#filterStatus,#filterType,#filterGender").val("");
    loadStudents();
  });

  function loadGrades() {
    $.get(API_BASE_URL+"/grades/get_all.php", function(d){
      let o='<option value="">Todos</option>';
      if(d.success && Array.isArray(d.data)){
        d.data.forEach(function(g){
          o+=`<option value="${g.GradeID}">${g.GradeName}</option>`;
        });
      }
      $("#filterGrade").html(o);
    });
  }

  function loadStudents() {
    let p={
      gradeId: $("#filterGrade").val(),
      status: $("#filterStatus").val(),
      type: $("#filterType").val(),
      gender: $("#filterGender").val()
    };
    $.get(API_BASE_URL+"/students/get_all.php", p, function(r){
      let b="";
      if(r.success && Array.isArray(r.data) && r.data.length){
        r.data.forEach(function(stu){
          b+=`<tr>
            <td>${stu.StudentID}</td>
            <td><img src="${stu.ProfilePicture||'../../img/undraw_profile.svg'}" width="32" class="rounded-circle"></td>
            <td>${stu.FirstName} ${stu.LastName}</td>
            <td>${stu.BirthDate||"-"}</td>
            <td>${stu.Age||"-"}</td>
            <td>${stu.Gender||"-"}</td>
            <td>${stu.GradeName||"-"}</td>
            <td>${stu.IsRecurrent?"Recurrente":"Ocasional"}</td>
            <td><span class="badge badge-${stu.IsActive?"success":"secondary"}">${stu.IsActive?"Activo":"Inactivo"}</span></td>
            <td><a href="student-detail.html?id=${stu.StudentID}" class="btn btn-info btn-sm"><i class="fas fa-eye"></i></a></td>
          </tr>`;
        });
      } else {
        b='<tr><td colspan="10" class="text-center text-muted">Sin registros</td></tr>';
      }
      $("#studentsTableBody").html(b);
    });
  }
});
