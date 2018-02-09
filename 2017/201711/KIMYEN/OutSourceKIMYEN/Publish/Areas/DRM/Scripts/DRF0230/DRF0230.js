//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     21/10/2014      Đức Quý         Tạo mới
//####################################################################

DRF0230 = new function () {
    this.rowNum = 0;
    this.isChanged = false;
    this.DRF0230Grid = null;
    this.groupID = null;
    this.comboNames = ['GroupID'];

    this.sendEventPost = function () {
        var data = {
            groupID: $('#GroupID').val()
        };

        return data;
    }

    //Event button config
    this.btnConfig_Click = function () {
        DRF0230.saveData();
        return 1;
    };

    //Get data form DRF1041
    this.getFormData = function () {
        var data = ASOFT.helper.dataFormToJSON('DRF0230', 'List', DRF0230.DRF0230Grid);
        data.GroupID = DRF0230.groupID;
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('DRF0230', DRF0230.comboNames)) {
            return;
        }

        var data = DRF0230.getFormData();

        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0230.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('DRF0230', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0230', function () {
            //ASOFT.asoftPopup.hideIframe(true);
            DRF0230.isChanged = false;
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
    this.btnClose_Click = function () {
        if (DRF0230.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                DRF0230.btnConfig_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };


    this.checkBox_Changed = function (tag) {
        var row = $(tag).parent().closest('tr');
        var currentRecord = ASOFT.asoftGrid.selectedRecord(DRF0230.DRF0230Grid);
        currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;

        DRF0230.isChanged = true;
    }

    this.checkBox_ChangedAll = function (tag) {
        var checked = $(tag).prop('checked') ? 1 : 0;
        var dataSource = DRF0230.DRF0230Grid.dataSource._data;



        for (i = 0; i < dataSource.length; i++) {
            dataSource[i][tag.id] = checked;
        }

        if (checked == 1) {
            $('td #' + tag.id).prop('checked', true);
        } else {
            $('td #' + tag.id).prop('checked', false);
        }

        DRF0230.isChanged = true;
    }

    //ComboBox module data bound 
    this.groupID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Khởi tạo các giá trị mặc định
        DRF0230.groupID = dataItem.GroupID;
        $('#GroupName').val(dataItem.GroupName);
        $(this.element).attr('initValue', DRF0230.groupID);
    }

    //ComboBox group id load 
    this.groupID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'DRF0230');
        var combo = this;
        var dataItem = combo.dataItem(combo.selectedIndex);

        if (!dataItem || dataItem == null) return;
        $('#GroupName').val(dataItem.GroupName);
        //Dữ liệu đã thay đổi => thông báo lưu
        if (DRF0230.isChanged) {          
            $('input[type=checkbox]').prop('checked', false);
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                if (DRF0230.btnConfig_Click() == 1) {
                    DRF0230.groupID = dataItem.GroupID;
                    DRF0230.DRF0230Grid.dataSource.read();
                }
            }, function () {
                DRF0230.groupID = dataItem.GroupID;
                DRF0230.DRF0230Grid.dataSource.read();
            });

            return;
        }

        DRF0230.groupID = dataItem.GroupID;
        DRF0230.DRF0230Grid.dataSource.read();

    }

}

$(document).ready(function () {
    DRF0230.DRF0230Grid = ASOFT.asoftGrid.castName('DRF0230Grid');
})