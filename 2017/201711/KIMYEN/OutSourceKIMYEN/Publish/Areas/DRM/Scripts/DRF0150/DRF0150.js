//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     27/10/2014      Trí Thiện       Tạo mới
//####################################################################

$(document).ready(function () {
});


DRF0150 = new function () {

    // In phí thu hồi nợ theo khách hàng
    this.btnPrintDebtRecoveryFee_Click = function () {
        // Post data
        var data = {};

        // Render URL
        var postUrl = ASOFT.helper.renderUrl('/DRM/DRF0190', data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    }

    //Sự kiện hiển thị các màn hình in
    this.item_Click = function (e) {
        var gridElement = $(e).closest('.asf-grid');

        grid = ASOFT.asoftGrid.castName(gridElement.attr('id'));

        //if(grid.name)
        var selectedRecord = ASOFT.asoftGrid.selectedRecord(grid);

        var data = {
            ReportID: selectedRecord.ReportID,
            ReportName: selectedRecord.ReportName,
            Title: selectedRecord.Title,            
        };

        var postUrl = $(e).closest('#DRF0150_GridDebtPersonal').length > 0
            || $(e).closest('#DRF0150_GridDebtBussiness').length > 0 ?
            ASOFT.helper.renderUrl('/DRM/DRF0140', data) :
            ASOFT.helper.renderUrl('/DRM/DRF0190', {});

        // Render URL
        //var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    }
}