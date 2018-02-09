// Document ready
$(document).ready(function () {
    $('#IsWarnPayment').attr('onclick', 'LMF0001.ChangechkIsWarnPayment(this)');
    LMF0001.ChangechkIsWarnPayment($('#IsWarnPayment'));
});

LMF0001 = new function () {
    this.isSaved = false;

    // change chk popup
    this.ChangechkIsWarnPayment = function (e) {
        if (e.checked) {
            $('#BeforeDays').prop('readonly', false);
        } else {
            $('#BeforeDays').prop('readonly', true);
        }
    }

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
        LMF0001.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('LMF0001') && !LMF0001.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                LMF0001.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };


    this.btnSave_Click = function () {
        var url = $('#UrlConfirm').val();
        var data = {};
        data = ASOFT.helper.dataFormToJSON('LMF0001');
        data.IsWarnPayment = $('#IsWarnPayment').prop('checked');
        ASOFT.helper.postTypeJson(url, data, LMF0001.saveSuccess); //post dữ liệu lên server
    }

    this.saveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'LMF0001', function () {
            LMF0001.isSaved = true;
            LMF0001.btnClose_Click();
        }, null, null, true);
    }
}