
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/11/2014      Quốc Tuấn        Tạo mới
//####################################################################

//biến sort 
//var dsSort = [];
//dsSort.push({ field: "UserID", dir: "asc" });
$(document).ready(function () {
    SF1013.gridUserID = ASOFT.asoftGrid.castName("GridUserID");
    SF1013.gridUserGroup = ASOFT.asoftGrid.castName("GridUserGroup");
    //SF1013.gridUserID.dataSource.sort(dsSort);
    //SF1013.gridUserGroup.dataSource.sort(dsSort);
    SF1013.rowNumber = 0;
    //SF1013.gridUserID.bind("dataBound", function (e) {
    //    SF1013.rowNumber = 0;
    //});
    //SF1013.gridUserGroup.bind("dataBound", function (e) {
    //    SF1013.rowNumber = 0;
    //})

    //Set STT, save data => filter
    if (SF1013.gridUserID) {
        SF1013.gridUserID.bind('dataBound', function () {
            SF1013.rowNumber = 0;
        });
    }
    if (SF1013.gridUserGroup) {
        SF1013.gridUserGroup.bind('dataBound', function () {
            SF1013.rowNumber = 0;
        });
    }
});

SF1013 = new function () {
    this.gridUserID = null;
    this.gridUserGroup = null;
    this.rowNumber = 0;
    this.isSaved = false;

    sendDataFilter = function () {
        var data = {};
        data.GroupID = $('#GroupID').val();
        return data;
    }

    this.renderNumber = function () {
        return ++SF1013.rowNumber;
    }

    //function btnChangePassword() {
    //    var userIDinGroup = ASOFT.asoftGrid.selectedRecord(gridUserGroup);
    //    if (userIDinGroup && userIDinGroup.UserID != null) {
    //        ASOFT.asoftPopup.showIframe('/S/SF1010/SF1014?UserID={0}'
    //             .format(userIDinGroup.UserID), userIDinGroup);
    //    }
    //}
    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        SF1013.closePopup(this);
    };

    this.btn_ChangeSingle = function () {
        //removeRowIsempty(SF1013.gridUserGroup);
        var record = ASOFT.asoftGrid.selectedRecord(SF1013.gridUserID);
        rowNumber = 0;
        if (!record || record.UserID == null) return;
        SF1013.gridUserGroup.dataSource.add(record);
        SF1013.gridUserID.dataSource.remove(record);
        SF1013.gridUserID.focus(0);
    }

    this.btn_UnChangeSingle = function () {
        //removeRowIsempty(SF1013.gridUserID);
        var record = ASOFT.asoftGrid.selectedRecord(SF1013.gridUserGroup);
        rowNumber = 0;
        if (!record || record.UserID == null) return;
        SF1013.gridUserID.dataSource.add(record);
        SF1013.gridUserGroup.dataSource.remove(record);
        SF1013.gridUserGroup.focus(0);
    }

    this.btn_ChangeAll = function () {
        //removeRowIsempty(SF1013.gridUserGroup);
        var userIndex = [];
        $.each(SF1013.gridUserID.dataSource.data(), function (index, value) {
            if (value || value.UserID != null || value.UserID != '') {
                userIndex.push(value);
                SF1013.gridUserGroup.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SF1013.gridUserID.dataSource.remove(val);
        });
        SF1013.gridUserGroup.focus(0);
    }

    this.btn_ReturnAll = function () {
        //removeRowIsempty(SF1013.gridUserID);
        var userIndex = [];
        $.each(SF1013.gridUserGroup.dataSource.data(), function (index, value) {
            if (value || value.UserID != null || value.UserID != '') {
                userIndex.push(value);
                SF1013.gridUserID.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SF1013.gridUserGroup.dataSource.remove(val);
        });
        SF1013.gridUserID.focus(0);
    }


    //Xóa dòng rỗng
    function removeRowIsempty(pGrid) {
        if (pGrid.dataSource.data().length > 0) {
            var item = pGrid.dataSource.data()[0];
            if (item && item.UserID == null) {
                pGrid.dataSource.remove(item);
            }
        }
    }

    //Get data form DRF1041
    function getFormData() {
        var data = ASOFT.helper.dataFormToJSON('SF1013', 'ListUserGroup', SF1013.gridUserGroup);
        return data;
    }
    this.Savedata = function ()
    {
        var data = getFormData();
        var Url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(Url, data, SF1013.saveSuccess);
    }
    this.btn_SaveUserGroup=function () {
        SF1013.Savedata();
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('SF1013', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SF1013', function () {
            window.parent.grid.dataSource.read();
            ASOFT.asoftPopup.hideIframe(true);
        }, null, null, true);
    }

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('SF1013') && !SF1013.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                SF1013.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        SF1013.rowNum = 0;
    };
}