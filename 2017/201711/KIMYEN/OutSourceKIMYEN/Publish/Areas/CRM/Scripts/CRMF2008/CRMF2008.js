$(document).ready(function () {
    setTimeout(function () {
        $(".k-window-actions").html("<button onclick='btnClose_Click()' style='background-color: rgba(0, 0, 0, 0);border:0'><img src='/Areas/SO/Content/images/close.png'></button>");
    }, 500);
});

function btnClose_Click() {
    ASOFT.asoftPopup.closeOnly();
};


function GetDataBottle() {
    var datamaster = ASOFT.helper.dataFormToJSON("CRMF2008");

    var splitL = $("#VoucherDate").val();
    var res = splitL.split("/");

    var oderdate = res[1] + "/" + res[0] + "/" + res[2];
    datamaster["VoucherDate"] = oderdate;
    return datamaster;
}

function GetDataBorrow() {
    var datamaster = ASOFT.helper.dataFormToJSON("CRMF2008");
    var splitL = $("#VoucherDate").val();
    var res = splitL.split("/");

    var oderdate = res[1] + "/" + res[0] + "/" + res[2];
    datamaster["VoucherDate"] = oderdate;
    return datamaster;
}