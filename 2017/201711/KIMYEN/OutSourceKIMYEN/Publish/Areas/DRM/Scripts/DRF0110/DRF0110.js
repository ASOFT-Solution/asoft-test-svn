//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF0110 = new function () {
    this.rowNum = 0;
    this.DRF0110Grid = null;

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0110")) {
            return;
        }

        var data = ASOFT.helper.dataFormToJSON('DRF0110', 'List', DRF0110.DRF0110Grid);
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0110.drf0110SaveSuccess);
    };

    this.drf0110SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0110', function () {
            DRF0110.btnClose_Click();
        }, null, null, true);
    }

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        if (DRF0110.DRF0110Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF0110.DRF0110Grid.dataSource.data();
            var row = DRF0110.DRF0110Grid.dataSource.data()[0];
            row.set('FromPercent', null);
            row.set('ToPercent', null);
            row.set('TeamPercent', null);
            row.set('LeaderPercent', null);
            row.set('PGDNTDPercent', null);
            row.set('AdminPercent', null);
            row.set('InfoPercent', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF0110.DRF0110Grid, null);
    }

    this.rowNumber = function () {
        return ++DRF0110.rowNum;
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
        DRF0110.rowNum = 0;
    };   
}

$(document).ready(function () {
    DRF0110.DRF0110Grid = ASOFT.asoftGrid.castName('DRF0110Grid');
    DRF0110.DRF0110Grid.bind('dataBound', function () {
        DRF0110.rowNum = 0;
    });
})