$(document).ready(function () {
    var btnPrint = $("#BtnPrint").data("kendoButton");
    if (btnPrint) {
        btnPrint.unbind("click").bind("click", print_Click);
    }

});


function print_Click() {
    var args = [];

    var apk = $(".APK").text();

    args.push(apk);

    ASOFT.helper.postTypeJson("/POS/POSF2010/PrintReport", args, printSuccess);
}

function printSuccess(result) {
    if (result) {
        var urlPrint = '/POS/POSF2010/ReportViewer';
        var options = !isMobile ? '&viewer=pdf' : '';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;
        window.open(fullPath, "_blank");
    }
}