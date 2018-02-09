//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     21/10/2014      Đức Quý         Tạo mới
//####################################################################

DRF0130 = new function () {
    this.rowNum = 0;
    this.DRF0130Grid = null;
    this.invalidGroup = false;
    this.checkboxs = ['EditContractInfo', 'LeaderSendDispath', 'ManagerSendDispath', 'InfoSendDispath',
    'LeaderCloseContract', 'ManagerCloseContract', 'InfoCloseContract', 'ViewCloseContract'];

    //Event button config
    this.btnConfig_Click = function () {
        if (DRF0130.DRF0130Grid.dataSource.data().length <= 0) { //Lưới không có dòng nào ko có cho lưu
            ASOFT.form.displayMessageBox('#DRF0130', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }

        //Check required
        $('#DRF0130').removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(DRF0130.DRF0130Grid);
        if (ASOFT.asoftGrid.editGridValidate(DRF0130.DRF0130Grid, DRF0130.checkboxs)) {
            msg = ASOFT.helper.getMessage('DRFML000025');
            ASOFT.form.displayError('#DRF0130', msg);
            return;
        }

        //Kiểm tra trùng GroupID
        if (DRF0130.invalidGroup) {
            var data = DRF0130.DRF0130Grid.dataSource.data();
            var groupIDList = DRF0130.groupBy_DataSource(data);
            var result = true;

            //Check GroupID
            $.each(groupIDList, function () {
                if (this.length > 1) {
                    msg = ASOFT.helper.getMessage('DRFML000026');
                    ASOFT.form.displayError('#DRF0130', msg);
                    DRF0130.invalidGroup = true;
                    result = false;
                    return result;
                }
            })

            if (!result) return;//Không cho lưu
        }

        var data = ASOFT.helper.dataFormToJSON('DRF0130', 'List', DRF0130.DRF0130Grid);
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0130.drf0130SaveSuccess);
    };

    this.drf0130SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0130', function () {
            DRF0130.btnClose_Click();
        }, null, null, true);
    }

    this.rowNumber = function () {
        return ++DRF0130.rowNum;
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
        ASOFT.asoftPopup.hideIframe(true);
        DRF0130.rowNum = 0;
    };

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        if (DRF0130.DRF0130Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = DRF0130.DRF0130Grid.dataSource.data();
            var row = DRF0130.DRF0130Grid.dataSource.data()[0];
            row.set('GroupID', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, DRF0130.DRF0130Grid, null);
    }

    this.checkBox_Changed = function (tag) {
        var row = $(tag).parent().closest('tr');
        var currentRecord = ASOFT.asoftGrid.selectedRecord(DRF0130.DRF0130Grid);
        currentRecord[tag.id] = $(tag).prop('checked') ? true : false;
    }

    this.check_GroupID = function (data, obj) {
        var groupIDList = DRF0130.groupBy_DataSource(data);

        if (groupIDList[obj.value()].length > 1) {
            msg = ASOFT.helper.getMessage('DRFML000026');
            ASOFT.form.displayError('#DRF0130', msg);
            $(obj.element).parent().addClass('asf-focus-input-error');
            $(obj.element).focus();
            DRF0130.invalidGroup = true;
            return;
        }
        else {
            ASOFT.form.clearMessageBox();
        }

        DRF0130.invalidGroup = false;
    }

    //Group data source => GroupID
    this.groupBy_DataSource = function (data) {
        var groupIDList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i].GroupID;
            if (typeof groupIDList[temp] === 'undefined') {
                groupIDList[temp] = [];
            }
            groupIDList[temp].push(i);
        }
        return groupIDList;
    }

    this.openDetails = function (e) {
        var url = $('#UrlDRF0131').val();
        var child = e.parentElement.parentElement.children[1].textContent;
        data = {
            groupID:child
        };
        DRF0130.showPopup(url,data);
    }
}

function groupID_Changed() {
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
            "DRF0130Grid",
            DRF0130.DRF0130Grid,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );

    var data = DRF0130.DRF0130Grid.dataSource.data();
    DRF0130.check_GroupID(data, this);
}

$(document).ready(function () {
    DRF0130.DRF0130Grid = ASOFT.asoftGrid.castName('DRF0130Grid');
    DRF0130.DRF0130Grid.bind('dataBound', function () {
        DRF0130.rowNum = 0;
    });

    //DRF0130.DRF0130Grid.bind('edit', function () {
    //    var row = $(this.select());
    //    var cell = row.find('input#EditContractInfo');
    //    if (cell.prop('checked')) {
            
    //    }
    //    else {
    //        this.closeCell();
    //    }
    //});
})