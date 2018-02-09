//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF0100 = new function () {

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0100")) {
            return;
        }

        var data = ASOFT.helper.getFormData(null, 'DRF0100');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.post(url, data, DRF0100.drf0100SaveSuccess);
    };

    this.drf0100SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0100', function () {
            DRF0100.btnClose_Click();
        }, null, null, true);
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
    };
}
