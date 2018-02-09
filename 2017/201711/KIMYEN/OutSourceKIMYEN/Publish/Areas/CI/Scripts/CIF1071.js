$(document).ready(function () {
    CIF1071.btnSave = $('#BtnSaveClose').data('kendoButton');
});

CIF1071 = new function () {
    this.formStatus = null;
    this.btnSave = null;
    this.actionType = 0;

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
        CIF1071.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('CIF1071') && !CIF1071.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CIF1071.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "CIF1071");
        return data;
    }

    this.saveData = function () {
        var data = CIF1071.getFormData();
        ASOFT.helper.post(window.parent.CIF1070.urlUpdate, data, CIF1071.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        CIF1071.actionType = 2;
        CIF1071.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        CIF1071.actionType = 1;
        CIF1071.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        CIF1071.actionType = 3;
        CIF1071.saveData();
    };

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('CIF1071', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF1071', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (CIF1071.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#CIF1071 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#CIF1071').find('input[type="text"], textarea').change(function () {
                        CIF1071.isSaved = false;
                    });
                    CIF1071.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#urlCIF1072M').val(),
                          { districtID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        // Reload grid
                        window.parent.CIF1070.CIF1070Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.CIF1070.CIF1070Grid) {
                // Reload grid
                window.parent.CIF1070.CIF1070Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    }
}