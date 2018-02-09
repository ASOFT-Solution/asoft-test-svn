//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF2041.comboEmployee = ASOFT.asoftComboBox.castName('EmployeeID');
    DRF2041.btnSave = $('#BtnSaveClose').data('kendoButton');
});

DRF2041 = new function () {
    this.formStatus = null;
    this.actionSaveType = 0;
    this.branchID = null;
    this.btnSave = null;
    this.comboEmployee = null;
    this.isSaved = false;
    this.isEndRequest = false;
    this.countCombo = 0;
    this.comboNames = ['EmployeeID'];

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF2041.closePopup();
    };

    //Get data form DRF2041
    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, 'DRF2041');

        if ($(DRF2041.comboEmployee.element).prop('disabled')) {//Employee disable
            data.push({
                name: 'EmployeeID',
                value: DRF2041.comboEmployee.value()
            });
        }
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF2041', DRF2041.comboNames)) {
            return;
        }

        var data = DRF2041.getFormData();
        ASOFT.helper.post(window.parent.DRF2040.urlUpdate, data, DRF2041.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF2041', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF2041', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF2041.actionSaveType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF2041 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    DRF2041.comboEmployee.dataSource.read();
                    DRF2041.comboEmployee.value('');
                    $('#EmployeeName').val('');
                    $('#TeamID').val('');
                    $('#DRF2041').find('input[type="text"], textarea').change(function () {
                        DRF2041.isSaved = false;
                    });
                    DRF2041.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#UrlDRF2042M').val(),
                          { apk: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                    }
                    else {
                        // Reload grid
                        window.parent.DRF2040.DRF2040Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF2040.DRF2040Grid) {
                // Reload grid
                window.parent.DRF2040.DRF2040Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
            }
        }, null, null, true);
    }

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF2041.actionSaveType = 2;
        DRF2041.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF2041.actionSaveType = 1;
        DRF2041.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF2041.actionSaveType = 3;
        DRF2041.saveData();
    };

    //Event combobox employeeID changed
    this.employeeID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2041');
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;
        $('#EmployeeName').val(dataItem.EmployeeName);
        $('#TeamID').val(dataItem.TeamID);
        ASOFT.asoftSpinEdit.castName('BaseSalary').value(dataItem.BaseSalary);
        ASOFT.asoftSpinEdit.castName('InsuranceSalary').value(dataItem.InsuranceSalary);
        ASOFT.asoftSpinEdit.castName('TradeUnion').value(dataItem.TradeUnion);
        ASOFT.asoftSpinEdit.castName('RiceAllowance').value(dataItem.RiceAllowance);
        ASOFT.asoftSpinEdit.castName('GasAllowance').value(dataItem.GasAllowance);
        ASOFT.asoftSpinEdit.castName('PhoneAllowance').value(dataItem.PhoneAllowance);
        ASOFT.asoftSpinEdit.castName('OnsiteFee').value(dataItem.OnsiteFee);
        ASOFT.asoftSpinEdit.castName('Remuneration').value(dataItem.Remuneration);
        ASOFT.asoftSpinEdit.castName('Other').value(dataItem.Other);

        //$('#EmployeeName').val(dataItem.EmployeeName);
        //$('#BaseSalary').val(dataItem.BaseSalary);
        //$('#InsuranceSalary').val(dataItem.InsuranceSalary);
        //$('#TradeUnion').val(dataItem.TradeUnion);
        //$('#RiceAllowance').val(dataItem.RiceAllowance);
        //$('#GasAllowance').val(dataItem.GasAllowance);
        //$('#PhoneAllowance').val(dataItem.PhoneAllowance);
        //$('#OnsiteFee').val(dataItem.OnsiteFee);
        //$('#Remuneration').val(dataItem.Remuneration);
        //$('#Other').val(dataItem.Other);

        //TODO: Version 1.0 TeamID
        //var comboTeamID = ASOFT.asoftComboBox.castName('TeamID');
        //comboTeamID.value(dataItem.TeamID);
    }

    //Event databound combobox employeeID
    this.employeeID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        this.bind('change', DRF2041.combo_Changed);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#EmployeeName').val(dataItem.EmployeeName);
        $('#TeamID').val(dataItem.TeamID);
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
        if (!ASOFT.form.formClosing('DRF2041') && !DRF2041.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF2041.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF2041');
    }

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF2041.countCombo++;
        if (DRF2041.countCombo == DRF2041.comboNames.length) {
            DRF2041.isEndRequest = true;
            DRF2041.btnSave.enable(true);
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