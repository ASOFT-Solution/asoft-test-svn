var ID = 'SF1050';
var SF1050Grid = null;
var FORM_ID = 'FormFilter';
var URL_SHOWPOPUP = '/S/SF1050/SF1051';
var URL_DELETE = '/S/SF1050/DeleteMany';

$(document).ready(function () {
    SF1050Grid = $('#SF1050Grid').data('kendoGrid');
});

function sendDataFilter() {
    var datamaster = ASOFT.helper.dataFormToJSON(FORM_ID);
    return datamaster;
}

function SF1050BtnFilter_Click() {
    ASOFT.form.clearMessageBox();
    refreshGrid();
}

function refreshGrid() {
    SF1050Grid.dataSource.page(1);
}

function SF1050BtnClearFilter_Click() {
    ASOFT.form.clearMessageBox();
    $('#FormFilter input').val('');
    refreshGrid();
}

function ShowEditorFrame() {
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(URL_SHOWPOPUP, {});
}

function btnDelete_Click() {
    var args = [];
    var data = {};
    ASOFT.form.clearMessageBox();
    if (SF1050Grid) {
        var records = ASOFT.asoftGrid.selectedRecords(SF1050Grid);
        if (records.length == 0)
            return;
        for (var i = 0; i < records.length; i++) {
            args.push(records[i].RoleID);
        }
    }
    //Bạn có muốn xóa không?
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        data['args'] = args;
        ASOFT.helper.postTypeJson(
                    URL_DELETE,
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, FORM_ID, function () {
                            refreshGrid();
                        }, null, function () {
                            refreshGrid();
                        }, true);
                    });
    });

}

function shopDetail_Click(apkRole) {
    var url = URL_SHOWPOPUP + "?APK=" + apkRole;
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}
