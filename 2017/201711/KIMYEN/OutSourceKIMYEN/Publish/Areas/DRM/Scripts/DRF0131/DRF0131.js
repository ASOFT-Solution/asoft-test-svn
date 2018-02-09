//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     03/09/2015      Quang Chiến         Tạo mới
//####################################################################

DRF0131 = new function ()
{
    this.DRF0131Grid = null;
    this.rowNum = 0;
    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    this.btnSave_Click = function () {

        if (DRF0131.DRF0131Grid.dataSource.data().length <= 0) { //Lưới không có dòng nào ko có cho lưu
            ASOFT.form.displayMessageBox('#DRF0131', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }
        
        var data = ASOFT.helper.dataFormToJSON('DRF0131', 'List', DRF0131.DRF0131Grid);
        data.EditAllContactInfo= $('#EditAllContactInfo').prop('checked');
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0131.drf0131SaveSuccess);
    };

    this.drf0131SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0131', function () {
            DRF0131.btnClose_Click();
        }, null, null, true);
    }

    this.rowNumber = function () {
        return ++DRF0131.rowNum;
    }

    this.checkBox_Changed = function (tag) {
        //var row = $(tag).parent().closest('tr');
        //var currentRecord = ASOFT.asoftGrid.selectedRecord(DRF0131.DRF0131Grid);
        //var checked = $(tag).prop('checked') ? true : false;
        //alert(checked.toString());
        //var currentRecord = ASOFT.asoftGrid.selectedRecord(DRF0131.DRF0131Grid);
        //currentRecord[tag.id] = checked ;

        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index-1].IsPermission = checked;
    }
    this.checkBox_ChangedAll = function (tag) {       
        
        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].IsPermission = checked;
        }
        if (checked) {
            $('td #IsPermission').prop('checked', true);
        } else {
            $('td #IsPermission').prop('checked', false);
        }
    }

    //check IsSend
    this.checkBox_IsSendChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].IsSend = checked;
    }
    this.checkBox_IsSendChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].IsSend = checked;
        }
        if (checked) {
            $('td #IsSend').prop('checked', true);
        } else {
            $('td #IsSend').prop('checked', false);
        }
    }

    //check City
    this.checkBox_CityChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].City = checked;
    }
    this.checkBox_CityChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].City = checked;
        }
        if (checked) {
            $('td #City').prop('checked', true);
        } else {
            $('td #City').prop('checked', false);
        }
    }

    //check District
    this.checkBox_DistrictChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].District = checked;
    }
    this.checkBox_DistrictChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].District = checked;
        }
        if (checked) {
            $('td #District').prop('checked', true);
        } else {
            $('td #District').prop('checked', false);
        }
    }

    //check Ward
    this.checkBox_WardChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].Ward = checked;
    }
    this.checkBox_WardChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].Ward = checked;
        }
        if (checked) {
            $('td #Ward').prop('checked', true);
        } else {
            $('td #Ward').prop('checked', false);
        }
    }

    //check AddressDescription
    this.checkBox_AddressDescriptionChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].AddressDescription = checked;
    }
    this.checkBox_AddressDescriptionChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].AddressDescription = checked;
        }
        if (checked) {
            $('td #AddressDescription').prop('checked', true);
        } else {
            $('td #AddressDescription').prop('checked', false);
        }
    }

    //check Note
    this.checkBox_NoteChanged = function (tag) {
        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        DRF0131.DRF0131Grid.dataSource._data[index - 1].Note = checked;
    }
    this.checkBox_NoteChangedAll = function (tag) {

        var checked = $(tag).prop('checked') ? true : false;
        var num = DRF0131.DRF0131Grid.dataSource._data.length;//10
        for (i = 0; i < num; i++) {
            DRF0131.DRF0131Grid.dataSource._data[i].Note = checked;
        }
        if (checked) {
            $('td #Note').prop('checked', true);
        } else {
            $('td #Note').prop('checked', false);
        }
    }
}

$(document).ready(function () {
    DRF0131.DRF0131Grid = ASOFT.asoftGrid.castName('DRF0131Grid');
    DRF0131.DRF0131Grid.bind('dataBound', function () {
        DRF0131.rowNum = 0;
    });
})