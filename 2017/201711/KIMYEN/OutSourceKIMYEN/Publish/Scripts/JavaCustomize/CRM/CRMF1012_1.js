var acChoose = null;
$(document).ready(function () {
    //setTimeout(function () { 
    $("#refLinkCRMT90031").val("NotesSubject");

    var btnToolbar = '<div class="asf-panel-view-detail" id="toolBarCRMT10102"><div class="asfbtn asfbtn-right-3"><ul class="asf-toolbar"><li style="margin-right: 10px;"><a class="asfbtn-item-32  k-button k-button-icon" id="BtnSearch_CRMF9002" style="" title="Kế thừa" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="k-sprite asf-icon asf-icon-32 asf-i-search-24" style="padding: 0px;"></span></a></li><li style="margin-right: 6px;"><a class="asfbtn-item-32  k-button k-button-icon" id="BtnDeleteDetail_CRMF9002" style="" title="Xóa" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="k-sprite asf-icon asf-icon-32 asf-i-page-delete" style="padding: 0px;"></span></a></li></ul></div></div>';

    $("#toolBarCRMT10102").remove();

    $("#tb_CRMT10102").before(btnToolbar);

        //$("#BtnAddNew .asf-i-add-32").show();
        //$("#BtnAddNew").unbind();
        //$("#BtnDeleteDetail .asf-i-page-delete").show();
       $("#BtnDelete").unbind();

        $("#BtnDeleteDetail_CRMF9002").kendoButton({
            "click": CustomDeleteDetail_Click,
        });

        $("#BtnDelete").kendoButton({
            "click": CustomDeleteMaster_Click,
        });

        $("#BtnSearch_CRMF9002").kendoButton({
            "click": CustomAddDetail_Click,
        });

    //Ẩn các group không cần thiết
        $("#GR_LichSu").remove();
        $("#GR_DinhKem").remove();
    //}, 500);
        //$(".IsOrganize").parent().hide();
        //if ($(".IsOrganize").text() == "0" && GetCountDetail() < 1)
        //{
        //    $("#BtnAddNew").parent().hide();
        //}
});

function CustomAddDetail_Click() {
    acChoose = 7;
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CRMF9002?DivisionID=" + $("#EnvironmentDivisionID").val(), {});
};

function CustomDeleteDetail_Click() {
    GridKendo = $('#GridCRMT10102').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    if (GridKendo == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }

    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/CRM/CRMF1012/DeleteContact", records, deleteDetailSuccessCustom);
    });
};

function CustomDeleteMaster_Click() {
    data = { APK: $("#PK").val() };
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/CRM/CRMF1012/DeleteAccountID", data, deleteMasterSuccess);
    });
};

function deleteMasterSuccess(result) {
    ASOFT.helper.showErrorSeverOption(1, result, "contentMaster", function () {
        //Chuyển hướng hoặc refresh data
        window.location.href = urlcontent;
    }, null, null, true, false, "contentMaster");
}

function deleteDetailSuccessCustom(result) {
    refreshGrid("CRMT10102");
};

function GetCountDetail() {
    GridKendo = $('#GridCRMT10102').data('kendoGrid');
    return GridKendo.dataSource._data.length;
}

function BtnChoose_Custom(tb) {
    var urlChoose = "/PopupSelectData/Index/{1}/{0}?DivisionID=" + $("#EnvironmentDivisionID").val();
    if (tb == "CRMT90051") {
        urlChoose = kendo.format(urlChoose, "CRMF9010", "CRM");
        acChoose = 1;
    }
    if (tb == "CRMT90041") {
        urlChoose = kendo.format(urlChoose, "CRMF9011", "CRM");
        acChoose = 2;
    }
    if (tb == "CRMT20501") {
        urlChoose = kendo.format(urlChoose, "CRMF9013", "CRM");
        acChoose = 3;
    }
    if (tb == "CRMT20401") {
        urlChoose = kendo.format(urlChoose, "CRMF9008", "CRM");
        acChoose = 4;
    }
    if (tb == "CRMT20801") {
        urlChoose = kendo.format(urlChoose, "CRMF9015", "CRM");
        acChoose = 5;
    }
    if (tb == "OT2101") {
        urlChoose = kendo.format(urlChoose, "SOF2024", "SO");
        acChoose = 6;
    }

    ASOFT.asoftPopup.showIframe(urlChoose, {});
}

function receiveResult(result) {
    var tableReset = "";
    var dtSave = {};
    if (acChoose == 1) {
        tableReset = "CRMT90051";
        dtSave.TableREL = "CRMT90051_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "EventID";
        dtSave.ValueREAL = result["EventID"];
        dtSave.ValueHistory = result["EventSubject"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 3;
        dtSave.Table = "CRMT90051";
        dtSave.TableParent = "CRMT10101";
        dtSave.ColumnHistory = "EventSubject";
    }
    if (acChoose == 3) {
        tableReset = "CRMT20501";
        dtSave.TableREL = "CRMT20501_CRMT10101_REL";
        dtSave.ColumnREL = "AccountID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "OpportunityID";
        dtSave.ValueHistory = result["OpportunityID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20501";
        dtSave.TableParent = "CRMT10101";
    }

    if (acChoose == 2) {
        tableReset = "CRMT90041";
        dtSave.TableREL = "CRMT90041_REL";
        dtSave.ColumnREL = "RelatedToID";
        dtSave.ColumnREAL = "TaskID";
        dtSave.ValueHistory = result["Title"];
        dtSave.ValueREAL = result["TaskID"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.TypeREL = 3;
        dtSave.Table = "CRMT90041";
        dtSave.TableParent = "CRMT10101";
        dtSave.ColumnHistory = "Title";
    }

    if (acChoose == 4) {
        tableReset = "CRMT20401";
        dtSave.TableREL = "CRMT10101_CRMT20401_REL";
        dtSave.ColumnREL = "AccountID";
        dtSave.ColumnHistory = dtSave.ColumnREAL = "CampaignID";
        dtSave.ValueHistory = result["CampaignID"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20401";
        dtSave.TableParent = "CRMT10101";
    }

    if (acChoose == 5) {
        tableReset = "CRMT20801";
        dtSave.TableREL = "CRMT20801_CRMT10101_REL";
        dtSave.ColumnREL = "AccountID";
        dtSave.ColumnREAL = "RequestID";
        dtSave.ColumnHistory = "RequestSubject";
        dtSave.ValueHistory = result["RequestSubject"];
        dtSave.ValueREAL = result["RequestID"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "CRMT20801";
        dtSave.TableParent = "CRMT10101";
    }

    if (acChoose == 6) {
        tableReset = "OT2101";
        dtSave.TableREL = "CRMT10101_OT2101_REL";
        dtSave.ColumnREL = "AccountID";
        dtSave.ColumnREAL = "QuotationID";
        dtSave.ValueHistory = result["QuotationNo"];
        dtSave.ValueREAL = result["APK"];
        dtSave.ValueREL = $("#PK").val();
        dtSave.Table = "OT2101";
        dtSave.TableParent = "CRMT10101";
        dtSave.ColumnHistory = "QuotationNo";
    }

    if (acChoose != 7) {
        ASOFT.helper.postTypeJson("/PopupSelectData/SaveREL", dtSave, function (result1) {
            if (result1) {
                refreshGrid(tableReset);
            }
        })
    }
    else {
        data = { APK: $("#PK").val(), ContactID: result["ContactID"] };
        ASOFT.helper.postTypeJson("/CRM/CRMF1012/InsertContact", data, function (resultInsert) {
            if (resultInsert) {
                refreshGrid("CRMT10102");
            }
        });
    }
}

function CustomerPrint() {
    printHistoryCustomerInformation_Click();
}

var printHistoryCustomerInformation_Click = function () {
    var data = new Object();
    data.APK = $("#PK").val();
    data.PrintOrExport = 0;
    ASOFT.helper.postTypeJson("/CRM/CRMF1012/DoPrintOrExport", data, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF1012/ReportViewer';
        var urlExcel = '/CRM/CRMF1012/ExportReport';
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
