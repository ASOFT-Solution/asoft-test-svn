//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/03/2014      Chánh Thi        Tạo mới
//####################################################################

var POSVIEW = {
    rowNum : 0
};

$(document).ready(function () {    
    var URL_MASTER= '/POS/POSF0054/POSF00551',
        URL_DETAIL = '/POS/POSF0054/POSF0057',
        URL_DELETE = '/POS/POSF0054/DeleteMany',
        URL_DELETEMASTER = '/POS/POSF0054/Delete',
        GRID_ID = 'GridVoucherDetail',
        gridLinkSelector = '#GridVoucherDetail .asf-grid-link',
        grid = $('#GridVoucherDetail').data('kendoGrid'),
        elementIDs = [],
        //LOG = console.log;
        apkNew = null;
        FORM_NAME = 'POSF0056',
        posGridData = $('#GridVoucherDetail').data('kendoGrid')
        

    grid.bind('dataBound', initGridLinkEvent);
    function initGridLinkEvent() {
        POSVIEW.rowNum = 0;
        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
        //LOG($(gridLinkSelector));
        $('#GridVoucherDetail .asf-grid-link').on('click', function (e) {
            //LOG(e); 
            var data = {},
                apk = $(e.target).attr('data-apk'),
                url = (URL_DETAIL + '?apk={0}').format(apk);
                apkNew = apk;

            if (e.ctrlKey) {
                //window.open(url, '_blank');
            }
            else if (e.altKey) {
                //console.log('Alt+Click');
            }
            else {
                ASOFT.asoftPopup.showIframe(url, data);
            }
        });
    }

    function postData() {
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        return data;
    }

    function refreshGrid() {
        posGridData.dataSource.page(1);
    }

    function deleteSuccess(result) {
        if (result == null) {
            ASOFT.form.displayInfo('#POSF0056', ASOFT.helper.getMessage('00ML000057'));
            grid.dataSource.page(1);
        }
        else {
            if (result.Params) {
                var msg = ASOFT.helper.getMessage(result.MessageID);
                msg = kendo.format(msg, result.Data.Period);
                ASOFT.form.displayWarning('#POSF0056', msg);
                grid.dataSource.page(1);
            }
        }
        if (grid) {
            grid.dataSource.page(1);
        }
    }


    function deleteMasterSuccess(result) {
        var url = getAbsoluteUrl("POSF0054");
        if (result == null) {
            window.parent.location.href = url;
        }
        else {
            var msg = ASOFT.helper.getMessage(result.MessageID);
            msg = kendo.format(msg, result.Data.Period);
            ASOFT.form.displayWarning('#POSF0056', msg);
            grid.dataSource.page(1);
        }
    }

    POSVIEW.refreshGrid = refreshGrid;

    POSVIEW.btnDeleteMaster_Click = function () {
        ASOFT.form.clearMessageBox();
        var apkMaster = null;
        var apk = [];
        var data = {};
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        data.APK = $('#APK').val();
        apkMaster = data.APK;
        apk.push(apkMaster);
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            data['apk'] = apk;
            ASOFT.helper.postTypeJson(
                        URL_DELETEMASTER,
                        data,
                        deleteMasterSuccess);
        });
    };

    POSVIEW.btnEditMaster_Click = function () {
        ASOFT.form.clearMessageBox();
        formMode = 1; //
        data = {};
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        data.APK = $('#APK').val();
        url = (URL_MASTER + '?apk={0}').format(data.APK);
        ASOFT.asoftPopup.showIframe(url, data);
        return false;
    };

    POSVIEW.btnAddDetail_Click = function () {
        ASOFT.form.clearMessageBox();
        formMode = 0; //
        data = {};
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        data.APK = $('#APK').val();
        url = (URL_DETAIL + '?apk={0}&&formMode={1}').format(data.APK,formMode);
        ASOFT.asoftPopup.showIframe(url, data);
        return false;
    };

    POSVIEW.btnDeleteDetail_Click = function () {
        ASOFT.form.clearMessageBox();
        var args = [];
        var data = {};
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        data.APK = $('#APK').val();
        var urlDelete = url = (URL_DELETE + '?apkMaster={0}').format(data.APK);
        ASOFT.form.clearMessageBox();
        if (grid) {
            var records = ASOFT.asoftGrid.selectedRecords(grid);
            if (records.length == 0)
                return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            data['args'] = args;
            ASOFT.helper.postTypeJson(
                        urlDelete,
                        data,
                        deleteSuccess);
        });
    };

});


function popupClose(event) {
    parent.popupClose();
}
/**
* Xử lý sự kiện click vào nút lưu
*/
function POSF0025Save(event) {
}

function btnClose_Click(event) {

}

function sendDataFilter() {
    var data = {};
    data.APK = $('#APK').val();
    return data;
}

function showPopup(id) {
    var voucherNo =  $('#VoucherNo').val();
    var url = '/POS/POSF0024/POSF0026?InventoryID={0}&VoucherNo={1}'.format(id, voucherNo);
    ASOFT.asoftPopup.showIframe(url);
    return false;
}

/**
* Gen rowNumber
*/
function renderNumber(data) {
    return ++POSVIEW.rowNum;
}

function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

function btnDeleteMaster_Click() {
    POSVIEW.btnDeleteMaster_Click();
}

function btnEditMaster_Click() {
    POSVIEW.btnEditMaster_Click();
}

function btnAddDetail_Click() {
    POSVIEW.btnAddDetail_Click();
}

function btnDeleteDetail_Click() {
    POSVIEW.btnDeleteDetail_Click();
}



