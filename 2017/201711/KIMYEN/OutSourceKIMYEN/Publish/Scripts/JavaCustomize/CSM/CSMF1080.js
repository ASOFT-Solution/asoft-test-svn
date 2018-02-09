

function customDataReport() {
    var dtReportCus = {};
    dtReportCus.IsCheckAll = $("#isAll").is(":checked") ? 1 : 0;

    if (dtReportCus.IsCheckAll == 0) {
        var XML = "";
        var APKList = "";
        var data = [];
        //var grid = castName(name);
        var grid = $("#GridCSMT1080").data("kendoGrid");

        grid.tbody.find('.asoftcheckbox:checked').closest('tr')
            .each(function () {
                if (typeof grid.dataItem(this) !== 'undefined') {
                    var dataItem = grid.dataItem(this);
                    //APKList += dataItem.APK + ",";
                    XML += "<Data><APK>{0}</APK></Data>".format(dataItem.APK);
                }
            });
        dtReportCus.XML = XML;
        dtReportCus.XML_Content_DataType = 7;
        dtReportCus.XML_Type_Fields = 4;
    }
    return dtReportCus;
}

function BtnImport_Click() {
    IsCheckExecute = true;
    // [1] Tạo form status : Add new
    //DRF2003.formStatus = 1;

    // [2] Url load dữ liệu lên form
    var postUrl = "/Import";

    // [3] Data load dữ liệu lên form
    var data = {
        type: "ReasonDenyFileID"
    };

    // [4] Hiển thị popup
    ASOFT.asoftPopup.showIframe(postUrl);
};