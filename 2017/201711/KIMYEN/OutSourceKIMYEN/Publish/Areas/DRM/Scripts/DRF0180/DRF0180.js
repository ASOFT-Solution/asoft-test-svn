//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     20/10/2014      Đức Quý         Tạo mới
//####################################################################

DRF0180 = new function () {

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0180")) {
            return;
        }

        var data = ASOFT.helper.getFormData(null, 'DRF0180');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.post(url, data, DRF0180.drf0180SaveSuccess);
    };

    this.drf0180SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0180', function () {
            DRF0180.btnClose_Click();
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