$(document).ready(function () {
    $("#GR_LichSu").remove();
    $("#GR_DinhKem").remove();
});

function DeleteViewMasterDetail(pk) {
    pk = $(".PromoteID").text();
    return pk;
}


function getPromoteID() {
    return $(".PromoteID").text();
}

function getDivisionID() {
    var diviSionID = $(".DivisionID").text() != "" ? $(".DivisionID").text() : $("#DivisionID").val();
    return diviSionID;
}


function CustomRead() {
    var ct = [];
    ct.push($(".DivisionID").text());
    ct.push($(".PromoteID").text());
    return ct;
}


function CustomDeleteDetail(records) {
    var args = [];
    for (var i = 0; i < records.length; i++) {
        var valuepk = records[i]["APK"] + "," + records[i]["PromoteID"];
        args.push(valuepk);
    }
    return args;
}

function PrintClick() {
    ASOFT.helper.postTypeJson("/CI/CIF1260/DoPrintOrExportCIF1262?PromoteID=" + $(".PromoteID").text() + "&DivisionID=" + $(".DivisionID").text(), {}, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CI/CIF1260/ReportViewer';
        var options = '&viewer=pdf&actionPrint=2';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}