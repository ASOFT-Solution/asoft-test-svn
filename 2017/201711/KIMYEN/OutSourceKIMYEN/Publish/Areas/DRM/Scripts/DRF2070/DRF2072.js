//####################################################################
//# Copyright (C) 2010-2072, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF2072.DRF2072GridEveryDay = ASOFT.asoftGrid.castName('DRF2072GridEveryDay');
    DRF2072.DRF2072GridAddressData = ASOFT.asoftGrid.castName('DRF2072GridEveryDay');

    if (DRF2072.DRF2072GridEveryDay) {
        DRF2072.DRF2072GridEveryDay.bind('dataBound', function () {
            DRF2072.rowNum = 0;
        });
    }

    if (DRF2072.DRF2072GridAddressData) {
        DRF2072.DRF2072GridAddressData.bind('dataBound', function () {
            DRF2072.rowNum = 0;
        });
    }
});

DRF2072 = new function () {
    this.formStatus = null;
    this.rowNum = 0;
    this.DRF2072GridEveryDay = null;
    this.DRF2072GridAddressData = null;

    this.renderNumber = function () {
        return ++DRF2072.rowNum;
    }
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    //Load data => Grid Address, EveryDay, Payment
    this.drf2072GridSendData = function () {
        var data = {};
        data.ContractNo = $('td#ContractNo').text();
        if (!$('td#ContractNo').text()) {
            data.ContractNo = window.parent.$('td#ContractNo').text();
        }
        return data;
    }
}