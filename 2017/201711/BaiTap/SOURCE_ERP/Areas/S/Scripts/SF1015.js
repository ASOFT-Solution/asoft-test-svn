
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/11/2014      Quốc Tuấn        Tạo mới
//####################################################################

$(document).ready(function () {
    SF1015.gridDivision = ASOFT.asoftGrid.castName("GridDivision");
    SF1015.gridDivisionGroup = ASOFT.asoftGrid.castName("GridDivisionGroup");
    SF1015.rowNumber = 0;
    //SF1015.gridDivision.bind("dataBound", function (e) {
    //    SF1015.rowNumber = 0;
    //});
    //SF1015.gridDivisionGroup.bind("dataBound", function (e) {
    //    SF1015.rowNumber = 0;
    //})

    //Set STT, save data => filter
    if (SF1015.gridDivision) {
        SF1015.gridDivision.bind('dataBound', function () {
            SF1015.rowNumber = 0;
        });
    }
    if (SF1015.gridDivisionGroup) {
        SF1015.gridDivisionGroup.bind('dataBound', function () {
            SF1015.rowNumber = 0;
        });
    }
});

SF1015 = new function () {
    this.gridDivision = null;
    this.gridDivisionGroup = null;
    this.rowNumber = 0;
    this.isSaved = false;

    this.sendDataFilter = function () {
        var data = {};
        data.GroupID = $('#GroupID').val();
        return data;
    }

    this.renderNumber = function () {
        return ++SF1015.rowNumber;
    }

    //function btnChangePassword() {
    //    var userIDinGroup = ASOFT.asoftGrid.selectedRecord(gridDivisionGroup);
    //    if (userIDinGroup && userIDinGroup.UserID != null) {
    //        ASOFT.asoftPopup.showIframe('/S/SF1010/SF1014?UserID={0}'
    //             .format(userIDinGroup.UserID), userIDinGroup);
    //    }
    //}
    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        SF1015.closePopup(this);
    };

    this.btn_ChangeSingle = function () {
        removeRowIsempty(SF1015.gridDivisionGroup);
        var record = ASOFT.asoftGrid.selectedRecord(SF1015.gridDivision);
        rowNumber = 0;
        if (!record || record.DivisionID == null) return;
        SF1015.gridDivisionGroup.dataSource.add(record);
        SF1015.gridDivision.dataSource.remove(record);
    }

    this.btn_UnChangeSingle = function () {
        removeRowIsempty(SF1015.gridDivision);
        var record = ASOFT.asoftGrid.selectedRecord(SF1015.gridDivisionGroup);
        rowNumber = 0;
        if (!record || record.DivisionID == null) return;
        SF1015.gridDivision.dataSource.add(record);
        SF1015.gridDivisionGroup.dataSource.remove(record);
    }

    this.btn_ChangeAll = function () {
        removeRowIsempty(SF1015.gridDivisionGroup);
        var userIndex = [];
        $.each(SF1015.gridDivision.dataSource.data(), function (index, value) {
            if (value || value.DivisionID != null || value.DivisionID != '') {
                userIndex.push(value);
                SF1015.gridDivisionGroup.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SF1015.gridDivision.dataSource.remove(val);
        });
    }

    this.btn_ReturnAll = function () {
        removeRowIsempty(SF1015.gridDivision);
        var userIndex = [];
        $.each(SF1015.gridDivisionGroup.dataSource.data(), function (index, value) {
            if (value || value.DivisionID != null || value.DivisionID != '') {
                SF1015.gridDivision.dataSource.add(value);
                userIndex.push(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SF1015.gridDivisionGroup.dataSource.remove(val);
        });
    }


    //Xóa dòng rỗng
    function removeRowIsempty(pGrid) {
        if (pGrid.dataSource.data().length > 0) {
            var item = pGrid.dataSource.data()[0];
            if (item && item.DivisionID == null) {
                pGrid.dataSource.remove(item);
            }
        }
    }

    //Get data form DRF1041
    function getFormData() {
        var data = ASOFT.helper.dataFormToJSON('SF1015', 'ListDivisionIDGroup', SF1015.gridDivisionGroup);
        return data;
    }
    this.Savedata = function ()
    {
        var data = getFormData();
        var Url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(Url, data, SF1015.saveSuccess);
    }
    this.btn_SaveUserGroup=function () {
        SF1015.Savedata();
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('SF1015', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SF1015', function () {
            ASOFT.asoftPopup.hideIframe(true);
        }, null, null, true);
    }

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('SF1015') && !SF1015.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                SF1015.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        SF1015.rowNum = 0;
    };
}