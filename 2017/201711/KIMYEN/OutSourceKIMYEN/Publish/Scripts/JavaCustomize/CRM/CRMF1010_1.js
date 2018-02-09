
$(document).ready(function () {

    $("#BtnDelete").unbind();
    $("#BtnShow").unbind();
    $("#BtnHide").unbind();

    $("#BtnDelete").kendoButton({
        "click": CustomBtnDelete_Click,
    });

    $("#BtnShow").kendoButton({
        "click": CustomBtnShow_Click,
    });

    $("#BtnHide").kendoButton({
        "click": CustomBtnHide_Click,
    });

    $("#btnImport").kendoButton({
        "click": CustomBtnImport_Click,
    });
});

function CustomBtnImport_Click() {
    var urlImport = "/Import?type=ListObject";
    ASOFT.asoftPopup.showIframe(urlImport);
}

function CustomBtnDelete_Click() {
    var url = "/CRM/CRMF1010/DeleteAccountID";
    GridKendo = $('#GridCRMT10101').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    var APKList = records[0].APK;
    for (i = 1; i < records.length; i++)
    {
        APKList += "," + records[i].APK;
    }
    data = { APKList: APKList };
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson(url, data, CRMF1010deleteSuccess);
    });
};

function CRMF1010deleteSuccess(result)
{
    ASOFT.helper.showErrorSeverOption(1, result, "FormFilter", function () {
        //Chuyển hướng hoặc refresh data
        $('#GridCRMT10101').data('kendoGrid').dataSource.page(1);
    }, null, null, true, false, "FormFilter");
}

function CustomBtnShow_Click() {
    GridKendo = $('#GridCRMT10101').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    var url = "/CRM/CRMF1010/EnableOrDisableAccountID?Type=0";
    var data = { args: records };
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000019'), function () {
        ASOFT.helper.postTypeJson(url, records, CRMF1010UpdateSuccess);
    });
};

function CustomBtnHide_Click() {
    GridKendo = $('#GridCRMT10101').data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    var url = "/CRM/CRMF1010/EnableOrDisableAccountID?Type=1";
    var data = {args: records };
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000019'), function () {
        ASOFT.helper.postTypeJson(url, records, CRMF1010UpdateSuccess);
    });
};

function CRMF1010UpdateSuccess(result) {
    ASOFT.helper.showErrorSeverOption(0, result, "FormFilter", function () {
        //Chuyển hướng hoặc refresh data
        
    }, null, null, true, false, "FormFilter");
    $('#GridCRMT10101').data('kendoGrid').dataSource.page(1);
};
