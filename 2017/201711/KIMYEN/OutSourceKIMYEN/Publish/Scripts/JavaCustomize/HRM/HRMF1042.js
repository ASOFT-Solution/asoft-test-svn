$(document)
    .ready(function() {

        CheckCanEdit();
//        CheckEdit();

    });

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF1040/CheckUpdateData?TrainingFieldID=' + pk + "&Mode=0",
        async: false,
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").data("kendoButton").enable(false);
            }
        }
    });
}
function CheckEdit() {
    divisionID = ASOFTEnvironment.DivisionID;
    if ($(".DivisionID").text() == divisionID) {
        $("#BtnEdit").data("kendoButton").enable(true);
    } else {
        $("#BtnEdit").data("kendoButton").enable(false);
    }
}
