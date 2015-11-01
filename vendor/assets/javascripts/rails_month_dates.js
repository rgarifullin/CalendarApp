$(function(){
  railsMonthDates();
  $("select[id*=_2i], select[id*=_1i]").change( railsMonthDates );
});

function railsMonthDates() {
  $("select[id*=_2i]").each(function(){
    $monthSelect = $(this);
    $daySelect = $(this).siblings("select[id*=_3i]");
    $yearSelect = $(this).siblings("select[id*=_1i]");

    var year = parseInt($yearSelect.val());
    var month = parseInt($monthSelect.val());
    var days = new Date(year, month, 0).getDate();

    var selectedDay = $daySelect.val();
    $daySelect.html('');
    for(var i=1; i<=days; i++) {
      $daySelect.append('<option value="'+i+'">'+i+'</option>');
    }
    $daySelect.val(selectedDay);
  });
}