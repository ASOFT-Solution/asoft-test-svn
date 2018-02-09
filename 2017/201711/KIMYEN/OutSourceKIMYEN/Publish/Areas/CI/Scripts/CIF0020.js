//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     23/10/2014      Đức Quý         Tạo mới
//####################################################################

CIF0020 = new function () {
    this.fileUploaded = 0;
    this.fileName = null;

    //Event button config
    this.btnConfig_Click = function () {
        if (ASOFT.form.checkRequired("CIF0020")) {
            return;
        }

        var data = ASOFT.helper.getFormData(null, 'CIF0020');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postMultiForm(url, 'CIF0020', this.cif0020SaveSuccess);
    };

    this.cif0020SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, JSON.parse(result), 'CIF0020', function () {
            CIF0020.btnClose_Click();
        }, null, null, true);
    }

    // File uploader
    this.onUpload = function (data) {

        if (CIF0020.fileUploaded > 0) {
            $('.k-upload-files .k-file:first').remove();
        }

        CIF0020.fileUploaded++;
    }

    // File upload success
    this.onSuccess = function (data) {
        if (data && data.response.counter > 0) {

            CIF0020.fileName = data.response.array[0];
        }
        var url = $('#UrlLogo').val() + '?id=' + data.response.ImageLogo;
        $('#CIF0020 .asf-table-view img').attr('src', url);
    };

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





require(["/Scripts/lib/helperFunction.js"], function (result) {

    var numerics = ["CommissionManageRate", "CommissionEmployeeRate"];

    numerics.forEach(function (val, index) {
        var $current = $("#" + val.toString());
        if ($current) {
            $current.css("text-align", "right")
                .keydown(result.spinEditForTextBox)
                .on("keyup", function (e) {
                    this.value = result.minMaxIntTyping(this.value, 0, 100);
                })
        }
    });
});