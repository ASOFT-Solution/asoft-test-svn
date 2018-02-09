//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF1011.btnSave = $('#BtnSaveClose').data('kendoButton');
});

DRF1011 = new function () {
    this.formStatus = null;
    this.btnSave = null;
    this.actionType = 0;
    this.countCombo = 0;
    this.isEndRequest = false;
    this.isSaved = false;
    this.comboNames = ['NTDFeeGroupID', 'NTMFeeGroupID'];

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF1011.closePopup();
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "DRF1011");
        return data;
    }

    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF1011', DRF1011.comboNames)) {
            return;
        }

        var data = DRF1011.getFormData();
        ASOFT.helper.post(window.parent.DRF1010.urlUpdate, data, DRF1011.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF1011.actionType = 2;
        DRF1011.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF1011.actionType = 1;
        DRF1011.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF1011.actionType = 3;
        DRF1011.saveData();
    };

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF1011', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF1011', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF1011.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF1011 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF1011').find('input[type="text"], textarea').change(function () {
                        DRF1011.isSaved = false;
                    });
                    DRF1011.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF1012M').val(),
                          { customerID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                        window.parent.ASOFT.form.setSameWidth("asf-content-block");
                    }
                    else {
                        // Reload grid
                        window.parent.DRF1010.DRF1010Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF1010.DRF1010Grid) {
                // Reload grid
                window.parent.DRF1010.DRF1010Grid.dataSource.page(1);
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
        if (!ASOFT.form.formClosing('DRF1011') && !DRF1011.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF1011.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF1011');
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF1011.countCombo++;
        if (DRF1011.countCombo == DRF1011.comboNames.length) {
            DRF1011.isEndRequest = true;
            DRF1011.btnSave.enable(true);
        }
    }

    //load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-4") {
            ASOFT.helper.post($('#UrlHistory').val(),
                              null, function (data) {
                                  $('#panelbar-4').html(data);
                              });
        }    
    }
}