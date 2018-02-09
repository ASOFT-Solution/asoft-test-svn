//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF2051.comboLeader = ASOFT.asoftComboBox.castName('TeamLeaderConfirm');
    DRF2051.comboManager = ASOFT.asoftComboBox.castName('ManagerConfirm');
    DRF2051.comboInfo = ASOFT.asoftComboBox.castName('InfoRoomConfirm');
    DRF2051.suggestDate = ASOFT.asoftDateEdit.castName('SuggestDate');
});

DRF2051 = new function () {
    this.formStatus = null;
    this.comboLeader = null;
    this.comboManager = null;
    this.comboInfo = null;
    this.suggestDate = null;
    this.comboNames = ['TeamLeaderConfirm', 'ManagerConfirm', 'InfoRoomConfirm'];

    //Thêm xử lý hàng ngày
    this.btnDailyProcess = function () {
        // [1] Tạo form status : Add new
        DRF2020 = new function () {
            this.urlUpdate = null;
        };
        DRF2020.urlUpdate = $('#UrlInsertDRF2020').val();
        DRF2020.formStatus = 4

        // [2] Url load dữ liệu lên form
        var postUrl = $("#UrlDRF2021").val();

        // [3] Data load dữ liệu lên form
        var data = {
            FormStatus: 4,
            IsCall: 1,
            ContractNo: $('#ContractNo').val(),
            DebtorName: $('#DebtorName').val()
        };

        // [4] Hiển thị popup
        DRF2021.showPopup(postUrl, data);

    }
    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2051.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'DRF2051');

        if ($(DRF2051.comboLeader.element).prop('disabled')) {//TeamLeader disable
            data.push({
                name: 'TeamLeaderConfirm',
                value: DRF2051.comboLeader.value()
            });
        }
        if ($(DRF2051.comboManager.element).prop('disabled')) {// Manager disable
            data.push({
                name: 'ManagerConfirm',
                value: DRF2051.comboManager.value()
            });
        }
        if ($(DRF2051.comboInfo.element).prop('disabled')) {// Info disable
            data.push({
                name: 'InfoRoomConfirm',
                value: DRF2051.comboInfo.value()
            });
        }
        data.push({
            name: 'SuggestDate',
            value: kendo.toString(DRF2051.suggestDate.value(), 'dd/MM/yyyy')
        });
        return data;
    }

    //Post data and update data
    this.btnSave_Click = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2051', DRF2051.comboNames)) {
            return;
        }

        var data = DRF2051.getFormData();
        ASOFT.helper.post(window.parent.$('#UrlConfirm').val(), data, DRF2051.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2051', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2051', function () {

            if (window.parent.$("#TableID").val() == "DRT2000") {
                window.parent.DRF2001.DRF2074GridCloseResume.dataSource.read();
                ASOFT.asoftPopup.hideIframe(true);
            }
            if (window.parent.$("#TableID").val() == "DRT2010") {
                window.parent.DRF2011.DRF2074GridCloseResume.dataSource.read();
                ASOFT.asoftPopup.hideIframe(true);
            }

            // Refresh data
            if (window.parent.DRF2050.DRF2050Grid) {
                // Reload grid
                window.parent.DRF2050.DRF2050Grid.dataSource.page(1);
            }
            if (result.Status == 0) {
                ASOFT.asoftPopup.hideIframe(true);
            }
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
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('DRF2051')) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2051.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2051');
    }
}