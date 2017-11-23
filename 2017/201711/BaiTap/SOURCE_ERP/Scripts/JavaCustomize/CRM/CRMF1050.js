
function customerDelete_Click() {
    var key = [],

        $urldeleteCRMF1050 = $("#DeleteCRMF1050").val(),

        $gridCRMF1050 = $("#GridCRMT10501").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridCRMF1050);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.CauseID !== "undefined") {
            return record.CauseID;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteCRMF1050, key, args, deleteSuccess);
    });
    return false;
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

    if (typeof $btnDelete !== "undefined")
        $btnDelete.unbind("click").bind("click", customerDelete_Click);
});

function PrintClick(action) {
    var key1 = Array(),
        value1 = Array(),
        datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
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
    })
    key1.push("PrintOrExport");

    value1.push(action);

    ASOFT.helper.postTypeJson1("/CRM/CRMF1050/DoPrintOrExport", key1, value1, ExportSuccess);
}


function ExportSuccess(result) {
    if (result) {

        var urlPrint = '/CRM/CRMF1050/ReportViewer',

            urlExcel = '/CRM/CRMF1050/ExportReport',

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

