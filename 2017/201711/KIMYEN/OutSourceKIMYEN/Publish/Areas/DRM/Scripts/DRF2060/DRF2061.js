//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF2061.comboLeader = ASOFT.asoftComboBox.castName('TeamLeaderConfirm');
    DRF2061.comboManager = ASOFT.asoftComboBox.castName('ManagerConfirm');
    DRF2061.comboInfo = ASOFT.asoftComboBox.castName('InfoRoomConfirm');
    DRF2061.sendDate = ASOFT.asoftDateEdit.castName('SendDate');
});

DRF2061 = new function () {
    this.formStatus = null;
    this.comboLeader = null;
    this.comboManager = null;
    this.comboInfo = null;
    this.sendDate = null;
    this.comboNames = ['TeamLeaderConfirm', 'ManagerConfirm', 'InfoRoomConfirm'];

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2061.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'DRF2061');

        if ($(DRF2061.comboLeader.element).prop('disabled')) {//TeamLeader disable
            data.push({
                name: 'TeamLeaderConfirm',
                value: DRF2061.comboLeader.value()
            });
        }
        if ($(DRF2061.comboManager.element).prop('disabled')) {// Manager disable
            data.push({
                name: 'ManagerConfirm',
                value: DRF2061.comboManager.value()
            });
        }
        if ($(DRF2061.comboInfo.element).prop('disabled')) {// Info disable
            data.push({
                name: 'InfoRoomConfirm',
                value: DRF2061.comboInfo.value()
            });
        }
        data.push({
            name: 'SendDate',
            value: kendo.toString(DRF2061.sendDate.value(), 'dd/MM/yyyy')
        });
        return data;
    }

    //Post data and update data
    this.btnSave_Click = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2061', DRF2061.comboNames)) {
            return;
        }

        var data = DRF2061.getFormData();

        ASOFT.helper.post(window.parent.$('#UrlConfirmDRF2060').val(), data, DRF2061.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2061', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2061', function () {

            var urlGetCV = $('#UrlGetDataCV').val();
            var tableName = window.parent.$('#TableID').val();

            if (tableName == undefined || tableName == null) {
                if (typeof window.parent.CatchContractDetails === "function") {
                    var record = window.parent.CatchContractDetails($("#ContractNo").val());
                    if (record != null) {
                        //! TODO: HARDCODE: setting TableID
                        if (record.DebtGroupID === "NTD") {
                            tableName = "DRT2110";
                        }
                        if (record.DebtGroupID === "NTM") {
                            tableName = "DRT2000";
                        }
                    }
                }
            }

            if (urlGetCV) {
                var data = {
                    ContractNo: $('#ContractNo').val(),
                    TableName: tableName
                }
                ASOFT.helper.postTypeJson(urlGetCV, data, DRF2061.saveSuccess2);
            }

            if (window.parent.$("#TableID").val() == "DRT2000") {
                if (window.parent.DRF2001) {
                    window.parent.DRF2001.DRF2073GridDocument.dataSource.read();
                    ASOFT.asoftPopup.hideIframe(true);
                }
            }
            if (window.parent.$("#TableID").val() == "DRT2010") {
                if (window.parent.DRF2011) {
                    window.parent.DRF2011.DRF2073GridDocument.dataSource.read();
                    ASOFT.asoftPopup.hideIframe(true);
                }
            }



            // Refresh data
            if (window.parent.DRF2060.DRF2060Grid) {
                // Reload grid
                window.parent.DRF2060.DRF2060Grid.dataSource.page(1);
            }

            if (result.Status == 0) {
                ASOFT.asoftPopup.hideIframe(true);
            }
        }, null, null, true);
    }

    this.saveSuccess2 = function (data) {
        if (data != null) {

            btnSendXR = window.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPL = window.parent.$('#btnSendVPL').data('kendoButton');
            btnClose = window.parent.$('#btnClose').data('kendoButton');

            btnSendXRparent = window.parent.parent.$('#btnSendXR').data('kendoButton');
            btnSendVPLparent = window.parent.parent.$('#btnSendVPL').data('kendoButton');
            btnCloseparent = window.parent.parent.$('#btnClose').data('kendoButton');

            btnSendXR.enable(true);
            btnSendXRparent.enable(true);

            btnSendVPL.enable(true);
            btnSendVPLparent.enable(true);

            btnClose.enable(true);
            btnCloseparent.enable(true);


            var isSendXR = data.IsXR;
            var isSendVPL = data.IsVPL;
            var isClose = data.IsClose;
            var isClosed = data.IsClosed;

            if (btnSendXR && btnSendVPL && btnClose && btnSendXRparent && btnSendVPLparent && btnCloseparent) {
                if (!(isSendXR == 0
                    || isSendXR == 3
                    || isSendXR == 5
                    || isSendXR == 7
                    || (isSendXR == null || isSendXR == ''))
                    || isClosed == 1) {
                    btnSendXR.enable(false);
                    btnSendXRparent.enable(false);
                }

                if (!(isSendVPL == 0
                    || isSendVPL == 3
                    || isSendVPL == 5
                    || isSendVPL == 7
                    || (isSendVPL == null || isSendVPL == ''))
                    || isClosed == 1) {
                    btnSendVPL.enable(false);
                    btnSendVPLparent.enable(false);
                }

                if (!(isClose == 0
                    || isClose == 3
                    || isClose == 5
                    || isClose == 7
                    || (isClose == null || isClose == ''))
                    || isClosed == 1) {
                    btnClose.enable(false);
                    btnCloseparent.enable(false);
                }
            }


            window.parent.$('#IsSendXR').val(isSendXR);
            window.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.$('#IsClose').val(isClose);
            window.parent.$('#IsClosed').val(isClosed);

            window.parent.parent.$('#IsSendXR').val(isSendXR);
            window.parent.parent.$('#IsSendVPL').val(isSendVPL);
            window.parent.parent.$('#IsClose').val(isClose);
            window.parent.parent.$('#IsClosed').val(isClosed);
        }
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
        if (!ASOFT.form.formClosing('DRF2061')) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2061.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };


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

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2061');
    }
}