//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF1001.btnSave = $('#BtnSaveClose').data('kendoButton');
});

DRF1001 = new function () {
    this.formStatus = null;
    this.branchID = null;
    this.btnSave = null;
    this.actionType = 0;
    this.initData = null;
    this.isSaved = false;
    this.fieldName = null;
    this.fileUploaded = 0;
    this.countCombo = 0;
    this.isEndRequest = false;
    var urlImage = null;
    this.comboNames = ['EmployeeGroupID', 'BranchID', 'TeamID', 'DutyID', 'StatusID'];

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        DRF1001.closePopup();
    };

    this.getFormData = function () {
        var data = ASOFT.helper.getFormData(null, "DRF1001");
        return data;
    }

    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF1001', DRF1001.comboNames)) {
            return;
        }

        var data = DRF1001.getFormData();
        ASOFT.helper.post(window.parent.DRF1000.urlUpdate, data, DRF1001.saveSuccess); //post dữ liệu lên server
    };

    // Save Copy button events
    this.btnSaveCopy_Click = function () {
        DRF1001.actionType = 2;
        DRF1001.saveData();
    };

    // Save Next button events
    this.btnSaveNext_Click = function () {
        DRF1001.actionType = 1;
        DRF1001.saveData();
    };

    // Save button events
    this.btnSave_Click = function () {
        DRF1001.actionType = 3;
        DRF1001.saveData();
    };

    this.saveSuccess = function(result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF1001', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF1001', function () {
            // Chuyển hướng xử lý nghiệp vụ
            switch (DRF1001.actionType) {
                case 1: // Trường hợp lưu & nhập tiếp
                    //$('form#DRF1001 input').val(null);
                    window.location.reload(true);
                    break;
                case 2: // Trường hợp lưu & sao chép
                    $('#DRF1001').find('input[type="text"], textarea').change(function () {
                        DRF1001.isSaved = false;
                    });
                    DRF1001.isSaved = true;
                    break;
                case 3: // Trường hợp lưu và đóng
                    if (window.parent.$('#viewPartial').length > 0) {
                        ASOFT.helper.post(window.parent.$('#urlDRF1002M').val(),
                          { employeeID: result.Data }, function (data) {
                              window.parent.$('#viewPartial').html(data);
                          });
                        if (urlImage) {
                            window.parent.$('td img[height=250]').attr('src', urlImage);
                        }
                    }
                    else {
                        // Reload grid
                        window.parent.DRF1000.DRF1000Grid.dataSource.page(1);
                    }
                    ASOFT.asoftPopup.hideIframe(true);
                    break;
                default:
                    break;
            }

            // Refresh data
            if (window.parent.DRF1000.DRF1000Grid) {
                // Reload grid
                window.parent.DRF1000.DRF1000Grid.dataSource.page(1);
            } else {
                window.location.reload(true);
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
        if (!ASOFT.form.formClosing('DRF1001') && !DRF1001.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF1001.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    this.branchID_Changed = function () {
        this.bind('change', DRF1001.combo_Changed);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF1001.brachID = dataItem.AnaID;
        var comboTeamID = ASOFT.asoftComboBox.castName('TeamID');
        comboTeamID.dataSource.read();
    }

    this.branchID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        DRF1001.brachID = dataItem.AnaID;
        var comboTeamID = ASOFT.asoftComboBox.castName('TeamID');
        comboTeamID.dataSource.read();
    }

    this.teamID_Data = function () {
        var data = {};
        data.showAll = false;
        data.branchID = DRF1001.brachID;
        return data;
    }

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF1001');
    }

    // File uploader
    this.onUpload = function (data) {

        if (DRF1001.fileUploaded > 0) {
            $('.k-upload-files .k-file:first').remove();
        }

        DRF1001.fileUploaded++;
    }

    // File upload success
    this.onSuccess = function (data) {
        if (data && data.response.counter > 0) {

            DRF1001.fieldName = data.response.array[0];
        }
        var url = $('#UrlAvatar').val() + '?id=' + data.response.ImageLogo;
        urlImage = url;
        $('#DRF1001 .asf-table-view img').attr('src', url);       
    };

    //Combox loaded data
    this.comboBox_RequestEnd = function (e) {
        DRF1001.countCombo++;
        if (DRF1001.countCombo == (DRF1001.comboNames.length - 2)) {
            DRF1001.isEndRequest = true;
            DRF1001.btnSave.enable(true);
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

