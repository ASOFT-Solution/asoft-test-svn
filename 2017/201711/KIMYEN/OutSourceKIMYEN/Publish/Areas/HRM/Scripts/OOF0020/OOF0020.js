// Document ready
$(document).ready(function () {
    
});

OOF0020 = new function () {
    this.isSaved = false;
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        OOF0020.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('OOF0020') && !OOF0020.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                OOF0020.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };


    this.btnSave_Click = function () {
        var data = ASOFT.helper.getFormData(null, "OOF0020");
        var url = $('#UrlUpdate').val();
        var item = {
            TimeCompany: data[1].value,
            TimeLaw: data[0].value,
            MaxAllowedTime: data[2].value,
            EmailApprove: data[3].value,
            EmailSuggest: data[4].value
        }
        item.LastModifyDate = $('#LastModifyDate').val();
        ASOFT.helper.postTypeJson(url, item, OOF0020.saveSuccess); //post dữ liệu lên server
    }

    this.saveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'OOF0020', function () {
            OOF0020.isSaved = true;
            OOF0020.btnClose_Click();
        }, null, null, true);
    }
}