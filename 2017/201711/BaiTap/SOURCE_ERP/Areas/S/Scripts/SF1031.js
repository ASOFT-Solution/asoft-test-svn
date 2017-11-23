//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     28/11/2014      Như Huyên         Tạo mới
//####################################################################

$(document).ready(function () {
    SF1031.comboLanguageID = ASOFT.asoftComboBox.castName('LanguageID');
    SF1031.comboModule = ASOFT.asoftComboBox.castName('Module');
})

SF1031 = new function () {
    this.actionSaveType = 0;
    this.isSaved = false;
    this.comboLanguageID = null;
    this.comboModule = null;
    this.comboNames = ['LanguageID','Module'];
    //Savecopy button events
    this.btnSaveCopy_Click = function () {
        SF1031.actionSaveType = 2;
        SF1031.saveData();
    }

    // Save Next button events
    this.btnSaveNext_Click = function () {
        SF1031.actionSaveType = 1;
        SF1031.saveData();
    }

    // Save button events
    this.btnSave_Click = function () {
        SF1031.actionSaveType = 3;
        SF1031.saveData();
    }

    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('SF1031', SF1031.comboNames)) {
            return;
        }
        var data = SF1031.getFormData();

        ASOFT.helper.post(window.parent.SF1030.urlUpdate, data, SF1031.saveSuccess);
    }

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'SF1031');
        if (($(SF1031.comboLanguageID.element).prop('disabled'))
            && ($(SF1031.comboModule.element).prop('disabled'))) {
            data.push(
                {
                    name: 'LanguageID',
                    value: SF1031.comboLanguageID.value()
                },
                {
                    name: 'Module',
                    value: SF1031.comboModule.value()
                });
        }
        return data;
    }

    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('SF1031', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SF1031', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (SF1031.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#CIF1031 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    //$('#CIF1031').find('input[type="text"], textarea').change(function () {
                    //    CIF1031.isSaved = false;
                    //});
                    SF1031.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng  
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlSF1032M').val(),
                          { ID: result.Data.ID, LanguageID:result.Data.LanguageID, Module: result.Data.Module }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        window.parent.SF1030.SF1030Grid.dataSource.page(1);
                    }
                    window.parent.ASOFT.form.setSameWidth("asf-content-block");
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.SF1030.SF1030Grid) {
                // Reload grid
                window.parent.SF1030.SF1030Grid.dataSource.page(1);
            }
            else {
                window.location.reload(true);
            }
        }, null, null, true);
    }

    // Close button events
    this.btnClose_Click = function () {
        //CIF1031.closePopup();
        ASOFT.asoftPopup.hideIframe(true);
    };

    //this.combo_Changed = function (e) {
    //    ASOFT.form.checkItemInListFor(this, 'SF1031');
    //}
}