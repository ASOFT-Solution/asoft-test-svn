// Document ready
$(document).ready(function () {
    
});

HF0390 = new function () {
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
        HF0390.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('HF0390') && !HF0390.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                HF0390.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };


    this.btnSave_Click = function () {        
        var url = $('#UrlUpdate').val();
        var data = {};
        data = ASOFT.helper.dataFormToJSON("HF0390");
        data.IsTranEntrySalary = $('#IsTranEntrySalary').is(':checked');
        data.IsTranferEmployee = $('#IsTranferEmployee').is(':checked');
        data.ConvertedProductAbsent = $('#ConvertedProductAbsent').is(':checked');
        
        ASOFT.helper.postTypeJson(url, data, HF0390.saveSuccess); //post dữ liệu lên server
    }

    this.saveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'HF0390', function () {
            HF0390.isSaved = true;
            HF0390.btnClose_Click();
        }, null, null, true);
    }

    this.combo_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'HF0390');
    }

    //this.comboPeriod_Changed = function (e) {
    //    ASOFT.form.checkItemInListFor(this, 'HF0390');
    //    var url = $('#UrlGetDataOfPeriodChange').val();
    //    var data = {
    //        Period: e.sender.value()
    //    };

    //    ASOFT.helper.postTypeJson(url, data, HF0390.comboPeriod_ChangedSuccess); //post dữ liệu lên server

    //}

    //this.comboPeriod_ChangedSuccess = function (result) {
    //    ASOFT.helper.post($('#UrlHF0390M').val(),
    //                     result, function (data) {
    //                         $('#viewPartial').html(data);
    //                     });
    //}
}