//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF0090 = new function () {

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("DRF0090")) {
            return;
        }

        var data = ASOFT.helper.getFormData(null, 'DRF0090');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.post(url, data, DRF0090.drf0090SaveSuccess);
    };

    this.drf0090SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0090', function () {
            DRF0090.btnClose_Click();
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