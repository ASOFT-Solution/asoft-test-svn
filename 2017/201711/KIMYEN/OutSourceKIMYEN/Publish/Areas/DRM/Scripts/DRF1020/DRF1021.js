//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF1021.btnSave = $('#BtnSaveClose').data('kendoButton');
});

DRF1021 = new function () {
    this.formStatus = null;
    this.btnSave = null;
    this.countCombo = 0;
    this.isEndRequest = false;
    this.actionType = 0;
    this.isSaved = false;
    this.comboNames = ['InfoTypeID'];

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF1021.closePopup();
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "DRF1021");
        return data;
    }

    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF1021', DRF1021.comboNames)) {
            return;
        }

        var data = DRF1021.getFormData();
        ASOFT.helper.post(window.parent.DRF1020.urlUpdate, data, DRF1021.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF1021.actionType = 2;
        DRF1021.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF1021.actionType = 1;
        DRF1021.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF1021.actionType = 3;
        DRF1021.saveData();
    };

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF1021', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF1021', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF1021.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF1021 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF1021').find('input[type="text"], textarea').change(function () {
                        DRF1021.isSaved = false;
                    });
                    DRF1021.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF1022M').val(),
                          { infoID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });

                    }
                    else {
                        // Reload grid
                        window.parent.DRF1020.DRF1020Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF1020.DRF1020Grid) {
                // Reload grid
                window.parent.DRF1020.DRF1020Grid.dataSource.page(1);
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
        if (!ASOFT.form.formClosing('DRF1021') && !DRF1021.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF1021.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF1021');
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF1021.countCombo++;
        if (DRF1021.countCombo == DRF1021.comboNames.length) {
            DRF1021.isEndRequest = true;
            DRF1021.btnSave.enable(true);
        }
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