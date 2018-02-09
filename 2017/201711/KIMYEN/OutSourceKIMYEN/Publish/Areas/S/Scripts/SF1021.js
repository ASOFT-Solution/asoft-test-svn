var isSaved = false;
var urlUpdate = null;
$(document).ready(function () {
    SF1021.comboLanguageID = ASOFT.asoftComboBox.castName('LanguageID');
    SF1021.comboModule = ASOFT.asoftComboBox.castName('Module');
})
var SF1021 = new function () {
    this.comboNames = ['LanguageID', 'Module'];
    this.comboLanguageID = null;
    this.comboModule = null;
    //close popup
    this.btnClose_Click = function () {
        // Hide Iframe
        ASOFT.asoftPopup.hideIframe(true);;
    };

    //Get data form SF1021
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'SF1021');
        if ($(SF1021.comboLanguageID.element).prop('disabled')) {
            data.push({
                name: 'LanguageID',
                value: SF1021.comboLanguageID.value()
            });
        }
        if ($(SF1021.comboModule.element).prop('disabled')) {
            data.push({
                name: 'Module',
                value: SF1021.comboModule.value()
            });
        }
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequired('SF1021')) {
            return;
        }
        var data = SF1021.getFormData();
        urlUpdate = $("#urlUpdate").val();
        ASOFT.helper.post(urlUpdate, data, SF1021.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('SF1021', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SF1021', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (SF1021.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#SF1021 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#SF1021').find('input[type="text"], textarea').change(function () {
                        SF1021.isSaved = false;
                    });
                    SF1021.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    ASOFT.helper.post($('#UrlSF1022M').val(),
                      { ID: result.Data.ID, LanguageID: result.Data.LanguageID, Module: result.Data.Module }, function (data) {
                          window.parent.$('#viewPartial').html(data);
                      });
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Reload grid
            window.parent.SF1020.SF1020Grid.dataSource.page(1);
            
        }, null, null, true);
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        SF1021.actionSaveType = 2;
        SF1021.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        SF1021.actionSaveType = 1;
        SF1021.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        SF1021.actionSaveType = 3;
        SF1021.saveData();
    };

};

