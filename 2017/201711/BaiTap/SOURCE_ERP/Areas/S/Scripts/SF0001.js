//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     30/10/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    SF0001.SF0001Grid = ASOFT.asoftGrid.castName('SF0001Grid');
    SF0001.comboGroupID = ASOFT.asoftComboBox.castName('GroupID');
    SF0001.comboModuleID = ASOFT.asoftComboBox.castName('ModuleID');

    SF0001.SF0001Grid.bind('dataBound', function () {
        SF0001.rowNum = 0;
        $('.sf0001-div-screen-type').height($(this.element).height());

        if (SF0001.SF0001GridData.length <= 0
            || (SF0001.SF0001GridData.length == 1
                && (SF0001.SF0001GridData[0].ModuleID === null
                    || SF0001.SF0001GridData[0].ScreenID === null
                    || SF0001.SF0001GridData[0].GroupID === null
                    || SF0001.SF0001GridData[0].DivisionID === null
                    || SF0001.SF0001GridData[0].ScreenType === null))) {
            $.each(this.dataSource.data(), function () {
                SF0001.SF0001GridData.push(this);
            });
        }

        //Focus row
        SF0001.SF0001Grid.focus(0);
        SF0001.SF0001Grid.bind('change', function () {
            if (!SF0001.isFirst) {
                SF0001.isFirst = true; //Chỉ filter lại khi dữ liệu lần đầu tiên bind vào lưới 

                //Mặc định load loại màn hình báo cáo đầu tiên
                SF0001.getScreenID($('.sf0001-li-selected').attr('value'));
            }
        })
    });

    $('.sf0001-div-screen-type ul li').click(function () {
        //checkbox ở title bỏ check
        $(SF0001.SF0001Grid.element).find('tr .k-header input[type=checkbox]').prop('checked', false);

        $('.sf0001-div-screen-type li').removeClass('sf0001-li-selected');
        $(this).addClass('sf0001-li-selected');
        SF0001.getScreenID($(this).attr('value'));
    })

    //Mặc định load loại màn hình báo cáo đầu tiên
    SF0001.getScreenID(1);
});

SF0001 = new function () {
    this.isFirst = false;
    this.isChanged = false;
    this.SF0001Grid = null;
    this.SF0001GridData = [];
    this.moduleID = null;
    this.groupID = null;
    this.comboGroupID = null;
    this.comboModuleID = null;
    this.screenTypeID = 1;
    this.rowNum = 0;
    this.comboNames = ['GroupID', 'ModuleID'];

    this.renderNumber = function () {
        return ++SF0001.rowNum;
    }

    //Hiện và ẩn cột trên lưới theo loại màn hình
    this.showHideColumn = function (screenType) {
        if (parseInt(screenType) == 1) {
            SF0001.SF0001Grid.showColumn(7);
            SF0001.SF0001Grid.showColumn(8);

            SF0001.SF0001Grid.hideColumn(4);
            SF0001.SF0001Grid.hideColumn(5);
            SF0001.SF0001Grid.hideColumn(6);
            SF0001.SF0001Grid.hideColumn(3);
        }
        else if (parseInt(screenType) == 2) {
            SF0001.SF0001Grid.showColumn(4);
            SF0001.SF0001Grid.showColumn(6);
            SF0001.SF0001Grid.showColumn(7);
            SF0001.SF0001Grid.showColumn(8);

            SF0001.SF0001Grid.hideColumn(3);
            SF0001.SF0001Grid.hideColumn(5);
        }
        else if (parseInt(screenType) == 3) {
            SF0001.SF0001Grid.showColumn(3);
            SF0001.SF0001Grid.showColumn(4);
            SF0001.SF0001Grid.showColumn(5);
            SF0001.SF0001Grid.showColumn(7);
            SF0001.SF0001Grid.showColumn(8);

            SF0001.SF0001Grid.hideColumn(6);
        }
        else if (parseInt(screenType) == 4) {
            SF0001.SF0001Grid.showColumn(3);

            SF0001.SF0001Grid.hideColumn(4);
            SF0001.SF0001Grid.hideColumn(5);
            SF0001.SF0001Grid.hideColumn(7);
            SF0001.SF0001Grid.hideColumn(8);
            SF0001.SF0001Grid.hideColumn(6);
        }
        else if (parseInt(screenType) == 5) {
            SF0001.SF0001Grid.showColumn(4);

            SF0001.SF0001Grid.hideColumn(3);
            SF0001.SF0001Grid.hideColumn(6);
            SF0001.SF0001Grid.hideColumn(5);
            SF0001.SF0001Grid.hideColumn(7);
            SF0001.SF0001Grid.hideColumn(8);
        }

        //Resize coulum on grid
        $(SF0001.SF0001Grid.element).find('div.k-grid-header > div > table').css({ width: '100%' });
        $(SF0001.SF0001Grid.element).find('div.k-grid-content > table').css({ width: '100%' });

        SF0001.screenTypeID = parseInt(screenType);
    }

    this.checkBox_ChangedAll = function (tag) {
        var checked = $(tag).prop('checked') ? 1 : 0;
        var dataSource = SF0001.SF0001Grid.dataSource._data;

       

        for (i = 0; i < dataSource.length; i++) {
            if (checked == 0 && tag.id == 'IsView' && SF0001.screenTypeID === 3) {
                dataSource[i].IsUpdate = 0;
                dataSource[i].IsPrint = 0;
                dataSource[i].IsExportExcel = 0;
            }
            dataSource[i][tag.id] = checked;
        }

        if (checked == 1) {
            $('td #' + tag.id).prop('checked', true);
        } else {
            $('td #' + tag.id).prop('checked', false);
            if (tag.id == 'IsView' && SF0001.screenTypeID === 3) {
                $('td #IsUpdate').prop('checked', false);
                $('td #IsPrint').prop('checked', false);
                $('td #IsExportExcel').prop('checked', false);
            }
        }
        

        
        //var row = $(tag).parent().closest('tr');
        //var currentRecord = ASOFT.asoftGrid.selectedRecord(SF0001.SF0001Grid);
        //currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;
        //if (currentRecord.IsView === 0
        //    && SF0001.screenTypeID === 3) {
        //    currentRecord.IsUpdate = 0;
        //    currentRecord.IsPrint = 0;
        //    currentRecord.IsExportExcel = 0;

        //    row.find('input#IsUpdate').removeAttr('checked');
        //    row.find('input#IsPrint').removeAttr('checked');
        //    row.find('input#IsExportExcel').removeAttr('checked');
        //}

        SF0001.isChanged = true;
    }

    this.checkBox_Changed = function (tag) {
        var row = $(tag).parent().closest('tr');
        //var currentRecord = ASOFT.asoftGrid.selectedRecord(SF0001.SF0001Grid);
        //currentRecord[tag.id] = $(tag).prop('checked') ? 1 : 0;
        var currentRecord = SF0001.SF0001Grid.dataItem(row);
        currentRecord.set(tag.id, $(tag).prop('checked') ? 1 : 0);
        if (currentRecord.IsView === 0
            && SF0001.screenTypeID === 3) {
            //currentRecord.IsUpdate = 0;
            //currentRecord.IsPrint = 0;
            //currentRecord.IsExportExcel = 0;
            currentRecord.set("IsUpdate", 0);
            currentRecord.set("IsPrint", 0);
            currentRecord.set("IsExportExcel", 0);

            row.find('input#IsUpdate').removeAttr('checked');
            row.find('input#IsPrint').removeAttr('checked');
            row.find('input#IsExportExcel').removeAttr('checked');
        }

        SF0001.isChanged = true;
    }

    //Filter data
    this.getScreenID = function (screenTypeID) {
        var data = SF0001.gridView_Filter(SF0001.SF0001Grid, SF0001.SF0001GridData, 'ScreenType', screenTypeID);
        SF0001.SF0001Grid.dataSource.data(data);
        //var sorter = SF0001.SF0001Grid.dataSource.sort({ field: "ScreenName", dir: "asc" })

        SF0001.showHideColumn(screenTypeID);
    }

    //Send filter data
    this.gridSendData = function () {
        var moduleID = SF0001.moduleID;
        var groupID = SF0001.groupID;
        var data = {
            ModuleID: moduleID,
            GroupID: groupID
        }
        return data;
    }

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        SF0001.closePopup();
    };

    //Get data form DRF1041
    this.getFormData = function () {
        var data = ASOFT.helper.dataFormToJSON('SF0001', 'List', SF0001.SF0001Grid);
        data.List = SF0001.SF0001GridData;
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('SF0001', SF0001.comboNames)) {
            return;
        }

        var data = SF0001.getFormData();

        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, SF0001.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('SF0001', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SF0001', function () {
            //ASOFT.asoftPopup.hideIframe(true);
            SF0001.isChanged = false;
        }, null, null, true);
    }

    // Save button events
    this.btnSave_Click = function () {
        SF0001.saveData();
        return 1;
    };


    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        if (/*!ASOFT.form.formClosing('SF0001') &&*/ SF0001.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                SF0001.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        SF0001.rowNum = 0;
    };

    //ComboBox module data bound 
    this.groupID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Khởi tạo các giá trị mặc định
        SF0001.groupID = dataItem.GroupID;
        $(this.element).attr('initValue', SF0001.groupID);
    }

    //ComboBox group id load 
    this.groupID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'SF0001');
        var combo = this;
        var dataItem = combo.dataItem(combo.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Dữ liệu đã thay đổi => thông báo lưu
        var isUpdated = 0;
        if (SF0001.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                if (SF0001.btnSave_Click() == 1) {
                    SF0001.SF0001GridData = [];
                    SF0001.groupID = dataItem.GroupID;
                    SF0001.SF0001Grid.dataSource.read();
                }
            }, function () {
                SF0001.SF0001GridData = [];
                SF0001.groupID = dataItem.GroupID;
                SF0001.SF0001Grid.dataSource.read();
            });
            SF0001.isChanged = false;
            return;
        }

        SF0001.SF0001GridData = [];
        SF0001.groupID = dataItem.GroupID;
        SF0001.SF0001Grid.dataSource.read();

        SF0001.isFirst = false;
    }

    //ComboBox module data bound 
    this.moduleID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Khởi tạo các giá trị mặc định
        SF0001.moduleID = dataItem.ModuleID;
        $(this.element).attr('initValue', SF0001.moduleID);
    }

    //ComboBox module id changed
    this.moduleID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'SF0001');
        var combo = this;
        var dataItem = combo.dataItem(combo.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Dữ liệu đã thay đổi => thông báo lưu
        if (SF0001.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                if (SF0001.btnSave_Click() == 1) {
                    SF0001.SF0001GridData = [];
                    SF0001.moduleID = dataItem.ModuleID;
                    SF0001.SF0001Grid.dataSource.read();
                }
            }, function () {
                SF0001.SF0001GridData = [];
                SF0001.moduleID = dataItem.ModuleID;
                SF0001.SF0001Grid.dataSource.read();
            });
            SF0001.isChanged = false;
            return;
        }

        SF0001.SF0001GridData = [];
        SF0001.moduleID = dataItem.ModuleID;
        SF0001.SF0001Grid.dataSource.read();

        SF0001.isFirst = false;
    }

    //Lọc dữ liệu
    this.gridView_Filter = function (grid, data, field, value) {
        grid.dataSource.data(data);
        $filter = new Array();
        $filter.push({ field: field, operator: "eq", value: value });
        var query = new kendo.data.Query(grid.dataSource.data());
        return query.filter($filter).data;
    }

    //Group data source => ShowDescriptionID
    this.groupBy_DataSource = function (data) {
        var groupList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i].ShowDescriptionID;
            if (typeof groupList[temp] === 'undefined') {
                groupList[temp] = [];
            }
            groupList[temp].push(i);
        }
        return groupList;
    }
}
