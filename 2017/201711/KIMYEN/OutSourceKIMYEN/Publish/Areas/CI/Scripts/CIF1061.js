$(document).ready(function () {
    CIF1061.btnSave = $('#BtnSaveClose').data('kendoButton');
});

CIF1061 = new function () {
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
        CIF1061.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('CIF1061') && !CIF1061.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CIF1061.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "CIF1061");
        return data;
    }

    this.saveData = function () {
        var data = CIF1061.getFormData();
        ASOFT.helper.post(window.parent.CIF1060.urlUpdate, data, CIF1061.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        CIF1061.actionType = 2;
        CIF1061.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        CIF1061.actionType = 1;
        CIF1061.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        CIF1061.actionType = 3;
        CIF1061.saveData();
    };

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('CIF1061', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF1061', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (CIF1061.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#CIF1061 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#CIF1061').find('input[type="text"], textarea').change(function () {
                        CIF1061.isSaved = false;
                    });
                    CIF1061.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#urlCIF1062M').val(),
                          { cityID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        // Reload grid
                        window.parent.CIF1060.CIF1060Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.CIF1060.CIF1060Grid) {
                // Reload grid
                window.parent.CIF1060.CIF1060Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    }
}