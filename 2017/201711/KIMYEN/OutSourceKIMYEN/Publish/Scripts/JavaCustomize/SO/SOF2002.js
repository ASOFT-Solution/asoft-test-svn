var msgDebts = null;
var IsConfirm = 0;
$(document).ready(function () {
    var related = '<div class="RelatedToTypeID" hidden="">7</div>';
    $("#RefLink").after(related);

    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();

    //$("#BtnEdit").unbind();
    //$("#BtnEdit").kendoButton({
    //    "click": CustomEdit_Click
    //});
})

function GetCheckConfirm() {
    return IsConfirm;
}

//function CustomEdit_Click() {
//    var data = [];
//    data.push($(".DivisionID").text());
//    data.push($(".TranMonth").text());
//    data.push($(".TranYear").text());
//    data.push($(".SOrderID").text());
//    var urlEdit = $("#urlEdit").val();
//    if ($(".DivisionID").text() != undefined)
//        urlEdit = urlEdit + "&DivisionID=" + $(".DivisionID").text();

//    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckConfirm", data, function (result) {
//        if (result.Message != null && result.Message != "") {
//            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(result.Message),
//            function () {
//                IsConfirm = 1;
//                ASOFT.form.clearMessageBox();
//                ASOFT.asoftPopup.showIframe(urlEdit, {});
//            },
//            function () {
//                IsConfirm = 0;
//                return false;
//            });
//        }
//        else {
//            IsConfirm = 0;
//            ASOFT.form.clearMessageBox();
//            ASOFT.asoftPopup.showIframe(urlEdit, {});
//        }
//    });
//}

function CustomerConfirm() {
    var data = [];
    var dt = getDetail("OT2002").Detail;
    var OriginalAmount = 0;
    for (i = 0; i < dt.length; i++) {
        OriginalAmount = parseFloat(OriginalAmount) + parseFloat(dt[i]["OriginalAmount"]);
    }
    data.push($("#DivisionID").val(), $("#ObjectID").val(), $("#OrderDate").val(), OriginalAmount);
    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckDebts", data, CheckDebtsSOF2000);
    return msgDebts;
}

function CheckDebtsSOF2000(result) {
    msgDebts = result;
}

function DeleteViewMasterDetail(pk) {
    var divisionID = $(".DivisionID").text();
    return pk + "," + divisionID;
}