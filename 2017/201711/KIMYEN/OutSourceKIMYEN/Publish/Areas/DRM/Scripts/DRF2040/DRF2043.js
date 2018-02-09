//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     14/11/2014      Trí Thiện       Tạo mới
//####################################################################

$(document).ready(function () {
    DRF2043.cboPeriod = ASOFT.asoftComboBox.castName('Period');
    $('#rdbSal').change(function () {
        DRF2043.cboPeriod.enable(true);
    });
    $('#rdbEmp').change(function () {
        DRF2043.cboPeriod.enable(false);
    });
});

DRF2043 = new function () {
    this.formStatus = null;
    this.comboNames = [];
    this.cboPeriod = null;
    this.month = null;
    this.year = null;

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2043.closePopup();
    };

    //Get data form DRF2043
    this.getFormData = function () {
        if (DRF2043.cboPeriod) {
            var dataItem = DRF2043.cboPeriod.dataItem(DRF2043.cboPeriod.selectedIndex);
            if (dataItem) {
                // Lấy giá trị tranmonth, tranyear
                DRF2043.month = dataItem.TranMonth;
                DRF2043.year = dataItem.TranYear;
            }
        }
        var data = ASOFT.helper.getFormData(null, 'DRF2043');
        data.push({ name: "TranMonth", value: DRF2043.month });
        data.push({ name: "TranYear", value: DRF2043.year });

        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2043', DRF2043.comboNames)) {
            return;
        }
        var urlPost = $("#UrlInherit").val();
        var data = DRF2043.getFormData();
        ASOFT.helper.post(urlPost, data, DRF2043.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2043', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2043', function () {
            // Trường hợp lưu và đóng
            window.parent.DRF2040.DRF2040Grid.dataSource.page(1);
            ASOFT.asoftPopup.hideIframe(true);
        }, null, null, true);
    }

    // Save button events
    this.btnSave_Click = function () {
        DRF2043.actionSaveType = 3;
        DRF2043.saveData();
    };

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

}