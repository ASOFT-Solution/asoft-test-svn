$(document)
    .ready(function () {

        CheckCanEdit();

        function DeleteViewNoDetail(pk) {
            return pk + "," + $(".DivisionID").text();
        }
        $("#A00_SystemInfo").remove();
    });

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/CSM/CSMF1040/CheckUpdateData?APK=' + pk,
        async: false,
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").data("kendoButton").enable(false);
            }
        }
    });
}
