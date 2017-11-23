//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/11/2014      Như Huyên         Tạo mới
//####################################################################

$(document).ready(function () {
    CIF1031.comboAnaType = ASOFT.asoftComboBox.castName('AnaTypeID');
})

CIF1031 = new function () {
    //this.formStatus = null;
    this.actionSaveType = 0;
    this.comboNames = ['AnaTypeID'];
    this.comboAnaType = null;
    this.isSaved = false;

    //Savecopy button events
    this.btnSaveCopy_Click = function () {
        CIF1031.actionSaveType = 2;
        CIF1031.saveData();
    }

    // Save Next button events
    this.btnSaveNext_Click = function () {
        CIF1031.actionSaveType = 1;
        CIF1031.saveData();
    }

    // Save button events
    this.btnSave_Click = function () {
        CIF1031.actionSaveType = 3;
        CIF1031.saveData();
    }

    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('CIF1031', CIF1031.comboNames)) {
            return;
        }
        var data = CIF1031.getFormData();

        ASOFT.helper.post(window.parent.CIF1030.urlUpdate, data, CIF1031.saveSuccess);
    }

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'CIF1031');
        if ($(CIF1031.comboAnaType.element).prop('disabled')) {// AnaTypeID disable
            data.push({
                name: 'AnaTypeID',
                value: CIF1031.comboAnaType.value()
            });
        }
        return data;
    }

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('CIF1031', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF1031', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (CIF1031.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#CIF1031 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#CIF1031').find('input[type="text"], textarea').change(function () {
                        CIF1031.isSaved = false;
                    });
                    CIF1031.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng  
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlCIF1032M').val(),
                          { anaID: result.Data, anaTypeID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        window.parent.CIF1030.CIF1030Grid.dataSource.page(1);
                    }
                    window.parent.ASOFT.form.setSameWidth("asf-content-block");
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.CIF1030.CIF1030Grid) {
                // Reload grid
                window.parent.CIF1030.CIF1030Grid.dataSource.page(1);
            }
            else {
                window.location.reload(true);
            }
        }, null, null, true);
    }

    // Close button events
    this.btnClose_Click = function () {
        CIF1031.closePopup();
    };

    //Combo CustomerID Changed
    this.combo_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'CIF1031');
    }

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('CIF1031') && !CIF1031.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CIF1031.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };
}