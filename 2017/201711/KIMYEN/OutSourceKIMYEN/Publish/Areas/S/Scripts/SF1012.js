//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     13/10/2014      Chánh Thi        Tạo mới
//####################################################################

var POSVIEW = {
    rowNum: 0
};

$(document).ready(function () {
    //var URL_MASTER = '/POS/POSF0054/POSF0055',
    //    URL_DETAIL = '/POS/POSF0054/POSF0057',
    //    URL_DELETE = '/POS/POSF0054/DeleteMany',
        //URL_DELETEMASTER = '/POS/POSF0054/Delete',
        GRID_ID = 'GridGroupDetail',
        gridLinkSelector = '#GridGroupDetail .asf-grid-link',
        grid = $('#GridGroupDetail').data('kendoGrid'),
        elementIDs = [],
        //LOG = console.log;
        apkNew = null;
    FORM_NAME = 'SF1012',
    posGridData = $('#GridGroupDetail').data('kendoGrid')
    formStatus = null;

    grid.bind('dataBound', initGridLinkEvent);
    function initGridLinkEvent() {
        POSVIEW.rowNum = 0;
        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
        //LOG($(gridLinkSelector));
        $('#GridGroupDetail .asf-grid-link').on('click', function (e) {
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

    POSVIEW.refreshGrid = refreshGrid;

    POSVIEW.btnDelete_Click = function () {
        ASOFT.form.clearMessageBox();
        var data = {};
        var groupID = $('#GroupID').val();
        //Bạn có muốn xóa không?
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            data['args'] = groupID;
            ASOFT.helper.postTypeJson(
                        '/S/SF1010/Delete',
                        data,
                       POSVIEW.deleteSuccess);
        });
    };

    POSVIEW.deleteSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(1, result, 'viewdetail', function () {
            var UrlSF101 = $('#SF1010').val();
            if (UrlSF101 != null)
            {
                window.location.href = UrlSF101; // redirect index
            }
        }, null, function () {
            refreshGrid();
        }, true);
    }

    POSVIEW.btnEdit_Click = function () {
        ASOFT.form.clearMessageBox();
        var groupID = $('#GroupID').val();
        formStatus = 2;
        var data = {};
        data['args'] = { 'GroupID': groupID, 'FormStatus': formStatus };
        var url = "";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/S/SF1010/SF1011?FormStatus={0}&GroupID={1}'
           .format(formStatus, groupID), data);
        return false;
    };

});


function popupClose(event) {
    parent.popupClose();
}

function sendDataFilter() {
    var data = {};
    data.GroupID = $('#GroupID').val();
    return data;
}

function showPopup(id) {
    var voucherNo = $('#VoucherNo').val();
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

function btnDelete_Click() {
    POSVIEW.btnDelete_Click();
}

function btnEdit_Click() {
    POSVIEW.btnEdit_Click();
}

function ShowPopup_AddUser(url){
    ASOFT.asoftPopup.showIframe(url, {});
    POSVIEW.refreshGrid;
}

function ShowPopup_AddDivision(url) {
    ASOFT.asoftPopup.showIframe(url, {});
}