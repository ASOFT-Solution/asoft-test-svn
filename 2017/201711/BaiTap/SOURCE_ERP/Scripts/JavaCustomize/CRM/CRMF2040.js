var GridCRMF2040 = null;
var urldeleteCRMF2040 = null;

$(document).ready(function () {
    var $btnPrint = $("#BtnPrint").data("kendoButton") || $("#BtnPrint");
    var $btnExportExcel = $("#BtnExportDetail").data("kendoButton") || $("#BtnExportDetail");
    if (typeof $btnPrint !== "undefined") {
        $btnPrint.unbind("click").bind("click", function () {
            PrintClick(0);
        })
    }
    if (typeof $btnExportExcel !== "undefined") {
        $btnExportExcel.unbind("click").bind("click", function () {
            PrintClick(1);
        })
    }

    urldeleteCRMF2040 = $('#DeleteCRMF2040').val();
    GridCRMF2040 = $("#GridCRMT20401").data("kendoGrid");
    $("#BtnDelete").unbind();
    $("#BtnDelete").kendoButton({
        "click": CustomDelete_Click
    });
})

function CustomDelete_Click() {
    var args = [];
    var key = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridCRMF2040);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        valuepk = records[i]["CampaignID"];
        args.push(valuepk);
    }
    key.push(tablecontent, pk);
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1(urldeleteCRMF2040, key, args, deleteSuccess);
    });
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
    })
    key1.push("PrintOrExport");
    value1.push(action);
    ASOFT.helper.postTypeJson1("/CRM/CRMF2040/DoPrintOrExport", key1, value1, ExportSuccess);
}


function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF2040/ReportViewer';
        var urlExcel = '/CRM/CRMF2040/ExportReport';
        var urlPost = !isMobile ? urlPrint : urlExcel;
        var options = !isMobile ? '&viewer=pdf' : '';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options;
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

