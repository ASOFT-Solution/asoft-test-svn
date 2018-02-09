$(document).ready(function () {
    CheckCanEdit();
})

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF1002/CheckUpdateData?ResourceID=' + pk + "&Mode=0",
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").parent().addClass('asf-disabled-li');          
            }
        }
    });
}