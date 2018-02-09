//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/08/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    $('#ContractNo').change(function () {
        if (DRF2031.checkContractNo()) {
            DRF2031.getVoucherNo($(this).val());
            //$(this).focus();
        }
    });
});

DRF2031 = new function () {
    this.formStatus = null;
    this.actionSaveType = 0;
    this.isSaved = false;
    this.debtorName = null;

    this.btnChoose_Click = function () {
        var data = {};
        var postUrl = $('#DRF2006Url').val();
        DRF2006.showPopup(postUrl, data);

        ASOFT.helper.registerFunction('window.parent.DRF2031.getVoucherNo');
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2031.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'DRF2031');
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequired("DRF2031")) {
            return;
        }

        if (window.parent.DRF2030.formStatus === 1) {
            if (!DRF2031.checkContractNo()) {
                return;
            }
        }

        var data = DRF2031.getFormData();
        ASOFT.asoftLoadingPanel.panelText = AsoftMessage['DRFML000045'];
        ASOFT.helper.postXR(window.parent.DRF2030.urlUpdate, data, DRF2031.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        if (result.Data
            && result.Data.PaidDate)
        {
            var paidDate = ASOFT.format.jsonToDate(result.Data.PaidDate);
            result.Data.PaidDate = kendo.format("{0}/{1}/{2}", paidDate.getDate(), paidDate.getMonth() + 1, paidDate.getFullYear());
        }

        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2031', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2031', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF2031.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF2031 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    DRF2031.getVoucherNo(result.Data);
                    $('#DRF2031').find('input[type="text"], textarea').change(function () {
                        DRF2031.isSaved = false;
                    });
                    DRF2031.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF2032M').val(),
                          { apk: result[0].Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        // Reload grid
                        window.parent.DRF2030.DRF2030Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF2030.DRF2030Grid) {
                // Reload grid
                window.parent.DRMPeriodFilter.isDate = 0
                window.parent.DRF2030.DRF2030Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);

        ASOFT.asoftLoadingPanel.panelText = 'Loading.....';
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF2031.actionSaveType = 2;
        DRF2031.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF2031.actionSaveType = 1;
        DRF2031.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2031.actionSaveType = 3;
        DRF2031.saveData();
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
        if (!ASOFT.form.formClosing('DRF2031') && !DRF2031.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2031.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.contractNo_Changed = function (e) {
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF2031.getVoucherNo();
    };

    this.getVoucherNo = function (contractNo) {
        var dataItem = ASOFT.helper.getObjectData();
        var debtorName = dataItem ? dataItem.DebtorName : DRF2031.debtorName;

        if (contractNo && !dataItem) {
            dataItem = {
                ContractNo: contractNo
            };
        }
        var data = {
            contractNo: dataItem ? dataItem.ContractNo : '',
            voucherTypeID: 'PaidID'
        }
        ASOFT.helper.post(window.parent.$('#UrlCreatePaidID').val(), data, function (result) {
            $('#PaidID').val(result.VoucherNo);
            $('#APKDRT4444').val(result.LastKeyAPK);
            $('#LastKey').val(result.LastKey);
        });
        $('#ContractNo').val(dataItem.ContractNo);
        $('#DebtorName').val(debtorName);
    }

    this.checkContractNo = function () {
        var inValid = true;
        var data = {
            contractNo: $('#ContractNo').val()
        };
        ASOFT.helper.post(window.parent.$('#UrlCheckContractNo').val(), data, function (result) {
            ASOFT.form.clearMessageBox();
            DRF2031.debtorName = result.Data.debtorName;
            if (result.Status == 2) {
                ASOFT.form.displayMessageBox('#DRF2031', [ASOFT.helper.getMessage(result.MessageID)]);
                inValid = false;
            }
        });
        return inValid;
    }

    //load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-3") {
            ASOFT.helper.post($('#UrlHistory').val(),
                              null, function (data) {
                                  $('#panelbar-3').html(data);
                              });
        }
    }
}