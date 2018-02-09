//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF1031.btnSave = $('#BtnSaveClose').data('kendoButton');
});

DRF1031 = new function () {
    this.formStatus = null;
    this.btnSave = null;
    this.countCombo = 0;
    this.isEndRequest = false;
    this.actionType = 0;
    this.isSaved = false;

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF1031.closePopup();
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "DRF1031");
        return data;
    }

    this.saveData = function () {
        var data = DRF1031.getFormData();
        ASOFT.helper.post(window.parent.DRF1030.urlUpdate, data, DRF1031.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF1031.actionType = 2;
        DRF1031.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF1031.actionType = 1;
        DRF1031.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF1031.actionType = 3;
        DRF1031.saveData();
    };

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF1031', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF1031', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF1031.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF1031 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF1031').find('input[type="text"], textarea').change(function () {
                        DRF1031.isSaved = false;
                    });
                    DRF1031.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF1032M').val(),
                          { portID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });

                    }
                    else {
                        // Reload grid
                        window.parent.DRF1030.DRF1030Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF1030.DRF1030Grid) {
                // Reload grid
                window.parent.DRF1030.DRF1030Grid.dataSource.page(1);
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
        if (!ASOFT.form.formClosing('DRF1031') && !DRF1031.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF1031.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    ////load panel lịch sử
    this.expandPanel = function (e) {
        if (e.item.children[1].id == "panelbar-3") {
            ASOFT.helper.post($('#UrlHistory').val(),
                              null, function (data) {
                                  $('#panelbar-3').html(data);
                              });
        }
    }
}