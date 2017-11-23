

function customerDelete_Click() {
    var key = [],

        $urldeleteCRMF1060 = $("#DeleteCRMF1060").val(),

        $gridCRMF1060 = $("#GridCRMT10601").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridCRMF1060);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if(typeof record.SalesTagID !== "undefined"){
            return record.SalesTagID;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteCRMF1060, key, args, deleteSuccess);
    });
    return false;
}

function PrintClick(action) {
    var key1 = Array();
    var value1 = Array();
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    $.each(datamaster, function (key, value) {
        if (key.indexOf("_input") == -1) {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                if (datamaster[key.split('_')[0] + "_Type_Fields"] == 2) {
                    if (value == "Có") {
                        value1.push(1);
                    }
                    else {
                        if (value == "Không") {
                            value1.push(0);
                        }
                        else {
                            if (value == "%") {
                                value1.push("");
                            }
                            else {
                                value1.push(value);
                            }
                        }
                    }
                }
                else {
                    value1.push(value);
                }
                key1.push(key.split('_')[0]);
            }
        }
    });

    key1.push("PrintOrExport");

    value1.push(action);

    ASOFT.helper.postTypeJson1("/CRM/CRMF1060/DoPrintOrExport", key1, value1, ExportSuccess);
}


function ExportSuccess(result) {

    if (result) {

        var urlPrint = '/CRM/CRMF1060/ReportViewer',

            urlExcel = '/CRM/CRMF1060/ExportReport',

            urlPost = !isMobile ? urlPrint : urlExcel,

            options = !isMobile ? '&viewer=pdf' : '',

            fullPath = urlPost + "?id=" + result.apk + options;

        if (result.PrintOrExport == 1) {
            window.location = urlExcel + "?id=" + result.apk + "";
        }
        else {
            // Getfile hay in báo cáo
            if (!isMobile)
                window.open(fullPath, "_blank");
            else {
                window.location = fullPath;
            }
        }
    }
}


$(document).ready(function () {

    var $btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete"),

        $btnPrint = $("#BtnPrint").data("kendoButton") || $("#BtnPrint");

    if (typeof $btnPrint !== "undefined") {
        $btnPrint.unbind("click").bind("click", function () {
            PrintClick(0);
            return false;
        });
    }

    if(typeof $btnDelete !=="undefined")
        $btnDelete.unbind("click").bind("click", customerDelete_Click);
});
