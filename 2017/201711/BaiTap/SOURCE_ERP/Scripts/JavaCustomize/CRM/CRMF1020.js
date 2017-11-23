function PrintClick() {
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
    value1.push("0");
    ASOFT.helper.postTypeJson1("/CRM/CRMF1020/DoPrintOrExport", key1, value1, ExportSuccess);
}

function ExportExcel() {
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
    value1.push("1");
    ASOFT.helper.postTypeJson1("/CRM/CRMF1020/DoPrintOrExport", key1, value1, ExportSuccess);
}


function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF1020/ReportViewer';
        var urlExcel = '/CRM/CRMF1020/ExportReport';
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

function customerDelete_Click() {
    var key = [],

        $urldeleteCRMF1020 = $("#DeleteCRMF1020").val(),

        $gridCRMF1020 = $("#GridCRMT10201").data("kendoGrid"),

        records = ASOFT.asoftGrid.selectedRecords($gridCRMF1020);

    ASOFT.form.clearMessageBox();

    if (records.length == 0) return false;

    var args = $.map(records, function (record) {
        if (typeof record.LeadTypeID !== "undefined") {
            return record.LeadTypeID;
        }
    });

    key.push(tablecontent, pk);

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson1($urldeleteCRMF1020, key, args, deleteSuccess);
    });
    return false;
}

$(document).ready(function () {
    var btnExportExcel = $("#BtnExportDetail").data("kendoButton") || $("#BtnExportDetail"),
        $btnDelete = $("#BtnDelete").data("kendoButton") || $("#BtnDelete");
    if (typeof btnExportExcel !== "undefined") {
        btnExportExcel.unbind("click").bind("click", function (e) {
            ExportExcel();
        })
    }
    if (typeof $btnDelete !== "undefined")
        $btnDelete.unbind("click").bind("click", customerDelete_Click);
});


