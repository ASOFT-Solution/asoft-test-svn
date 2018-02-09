//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2006 = new function () {
    this.isSearch = false;
    this.dataItem = null;
    this.DRF2006Grid = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2006.DRF2006Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("formFilter");
        return dataMaster;
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2006.closePopup();
    };

    // Save Copy button events
    this.btnSave_Click = function () {
        DRF2006.dataItem = ASOFT.asoftGrid.selectedRecord(DRF2006.DRF2006Grid);
        window.parent.ASOFT.helper.setObjectData(DRF2006.dataItem);
        executeFunctionByName(window.parent.delegateFunction);
        DRF2006.closePopup();        
    };

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };
}

// Xử lý ban đầu
$(document).ready(function () {
    DRF2006.DRF2006Grid = ASOFT.asoftGrid.castName('DRF2006Grid');
});
