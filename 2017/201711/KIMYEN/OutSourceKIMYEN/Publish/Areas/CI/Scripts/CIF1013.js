//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     30/10/2014      Đức Quý         Tạo mới
//####################################################################

$(document).ready(function () {
    CIF1013.grid1 = ASOFT.asoftGrid.castName('CIF1013Grid1');
    CIF1013.grid2 = ASOFT.asoftGrid.castName('CIF1013Grid2');
    CIF1013.comboTeamID = ASOFT.asoftComboBox.castName('TeamID');
    CIF1013.comboTeamLeaderID = ASOFT.asoftComboBox.castName('TeamLeaderID');
    CIF1013.popup = ASOFT.asoftPopup.castName("popupInnerIframe");

    //Set STT, save data => filter
    if (CIF1013.grid1) {
        CIF1013.grid1.bind('dataBound', function () {
            CIF1013.rowNum = 0;
            CIF1013.dataGrid1 = [];
            $.each(this.dataSource.data(), function () {
                CIF1013.dataGrid1.push(this);
            });
            //if (CIF1013.dataGrid1.length <= 0) {
            //    $.each(this.dataSource.data(), function () {
            //        CIF1013.dataGrid1.push(this);
            //    });
            //}
        });
    }

    //Set STT, save data => filter
    if (CIF1013.grid2) {
        CIF1013.grid2.bind('dataBound', function () {
            var dataTeamLeader = [];
            CIF1013.rowNum = 0;
            CIF1013.dataGrid2 = [];

            //if (this.dataSource.data().length > 1) {//Remove dòng rỗng
            //    var firstRow = this.dataSource.data()[0];
            //    if (firstRow && firstRow.EmployeeID === null
            //        && firstRow.EmployeeName === null
            //        && firstRow.TeamID === null
            //        && firstRow.TeamLeaderID === null) {
            //        this.dataSource.remove(firstRow);
            //    }
            //}

            $.each(this.dataSource.data(), function () {
                CIF1013.dataGrid2.push(this);
            });

            //Đổ nguồn cho combobox tổ trưởng
            $.each(this.dataSource.data(), function (index, row2Value) {
                dataTeamLeader.push({ TeamLeaderID: this.EmployeeID, TeamLeaderName: this.EmployeeName });
                $.each(CIF1013.grid1.dataSource.data(), function (indexGrid1, row1Value) {
                    if (row2Value.EmployeeID === this.EmployeeID) {
                        //CIF1013.dataGrid2.push(this);
                        CIF1013.grid1.dataSource.remove(this);
                        return false;
                    }
                });
            });
            CIF1013.comboTeamLeaderID.dataSource.data(dataTeamLeader);
        });
    }
});

CIF1013 = new function () {
    this.invalidGroup = false;
    this.popup = null;
    this.formStatus = null;
    this.grid1 = null;
    this.dataGrid1 = [];
    this.grid2 = null;
    this.dataGrid2 = [];
    this.isSaved = false;
    this.comboTeamID = null;
    this.comboTeamLeaderID = null;
    this.rowNum = 0;
    this.comboNames = ['TeamLeaderID'];

    this.renderNumber = function () {
        return ++CIF1013.rowNum;
    }

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        CIF1013.closePopup();
    };

    //Get data form DRF1041
    this.getFormData = function () {
        var data = ASOFT.helper.dataFormToJSON('CIF1013', 'List2', CIF1013.grid2);
        return data;
    }

    //Post data and update data
    this.saveData = function () {
        if (ASOFT.form.checkRequiredAndInList('CIF1013', CIF1013.comboNames)) {
            return;
        }

        var data = CIF1013.getFormData();

        if (data.List2.length == 1
            && data.List2[0].EmployeeID == null
            && data.List2[0].EmployeeName == null) { //Lưới địa chỉ rỗng => không post lên server
            data.List2 = null;
        }

        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, CIF1013.saveSuccess);
    }

    //Result sever return when save success
    this.saveSuccess = function (result) {
        // Update Save status
        ASOFT.form.updateSaveStatus('CIF1013', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'CIF1013', function () {
            //if (window.parent.$('#viewPartial').length > 0) {
            //    ASOFT.helper.post(window.parent.$('#UrlCIF1042M').val(),
            //      { templateID: result.Data }, function (data) {
            //          window.parent.$('#viewPartial').html(data);
            //      });
            //    window.parent.ASOFT.form.setSameWidth("asf-content-block");
            //}
            //else {
            //    // Reload grid
            //    window.parent.CIF1040.CIF1040Grid.dataSource.page(1);
            //}
            ASOFT.asoftPopup.hideIframe(true);
        }, null, null, true);
    }

    // Save button events
    this.btnSave_Click = function () {
        CIF1013.actionSaveType = 3;
        CIF1013.saveData();
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
        if (!ASOFT.form.formClosing('CIF1013') && !CIF1013.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                CIF1013.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        CIF1013.rowNum = 0;
    };

    this.grid2SendData = function () {
        var teamID = $('#TeamID').val();
        var data = { TeamID: teamID };
        return data;
    }

    //ComboBox TeamLeader load 
    this.teamLeaderID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'CIF1013');
    }

    this.teamLeaderID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        if (this.dataSource.data().length == 0) {
            this.value('');
        }
    }

    //ComboBox TeamID changed
    this.comboTeamID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'CIF1013');
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;
        
        //Filter grid 2
        var data = CIF1013.gridView_Filter(CIF1013.grid2, CIF1013.dataGrid2, 'TeamID', dataItem.TeamID);
        CIF1013.grid2.dataSource.data(data);

        //Filter grid 1: rows grid1 not in grid2
        CIF1013.grid1.dataSource.data(CIF1013.dataGrid1);
        $.each(CIF1013.grid2.dataSource.data(), function (index, row2Value) {
            $.each(CIF1013.grid1.dataSource.data(), function () {
                if (row2Value.EmployeeID === this.EmployeeID) {
                    CIF1013.grid1.dataSource.remove(this);
                    return false;
                }
            });
        });
    }

    //Add employee to team
    this.addEmpToTeam = function () {
        ASOFT.form.clearMessageBox();
        record = ASOFT.asoftGrid.selectedRecord(CIF1013.grid1, 'CIF1013');
        
        //Trả về cảnh báo khi chưa chọn dòng
        if (!record || record == null) return;

        CIF1013.addOneEmp(record, CIF1013.grid2, CIF1013.grid1);

        CIF1013.grid1.focus(0);
        CIF1013.grid2.focus(0);
        //Add row to grid 2
        //var result = CIF1013.addRow(CIF1013.grid2.dataSource, record);

        //if (result) { //Remove row grid 1 => grid2 added row
        //    var isRemoved = CIF1013.removeRow(CIF1013.grid1.dataSource, record);

        //    if (isRemoved && result) {
        //        CIF1013.dataGrid2.push(record);//Add temp data grid 2
        //    }
        //}       
    }

    //Remove employee to team
    this.removeEmpToTeam = function () {
        ASOFT.form.clearMessageBox();
        record = ASOFT.asoftGrid.selectedRecord(CIF1013.grid2, 'CIF1013');

        //Trả về cảnh báo khi chưa chọn dòng
        if (!record || record == null) return;

        CIF1013.removeOneEmp(record, CIF1013.grid1, CIF1013.grid2);
        CIF1013.grid1.focus(0);
        CIF1013.grid2.focus(0);
        ////Add row to grid 2
        //var result = CIF1013.addRow(CIF1013.grid1.dataSource, record);

        //if (result) { //Remove row grid 1 => grid2 added row
        //    var isRemoved = CIF1013.removeRow(CIF1013.grid2.dataSource, record);

        //    if (isRemoved && result) {
        //        CIF1013.dataGrid1.push(record);//Add temp data grid 1
        //        $.each(CIF1013.dataGrid2, function (index, value) {
        //            if (this.EmployeeID == record.EmployeeID) {
        //                CIF1013.dataGrid2.splice(index, 1);
        //            }
        //        })
        //        //CIF1013.dataGrid2.filter(function (row) {
        //        //    return row.EmployeeID !== record.EmployeeID;
        //        //});//remove temp data grid 2
        //    }
        //}
    }

    this.addAllEmpToTeam = function () {
        ASOFT.form.clearMessageBox();

        //Trả về cảnh báo khi chưa chọn dòng
        if (CIF1013.dataGrid1.length == 0) return;

        $.each(CIF1013.dataGrid1, function (index, value) {
            CIF1013.addOneEmp(value, CIF1013.grid2, CIF1013.grid1);
        });
        CIF1013.grid1.focus(0);
        CIF1013.grid2.focus(0);
    }

    this.removeAllEmpToTeam = function () {
        ASOFT.form.clearMessageBox();

        //Trả về cảnh báo khi chưa chọn dòng
        if (CIF1013.dataGrid2.length == 0) return;

        $.each(CIF1013.dataGrid2, function (index, value) {
            CIF1013.removeOneEmp(value, CIF1013.grid1, CIF1013.grid2);
        });
        CIF1013.grid1.focus(0);
        CIF1013.grid2.focus(0);
    }

    this.addOneEmp = function (record, destGrid, srcGrid) {

        //Add row to grid 2
        var result = CIF1013.addRow(destGrid.dataSource, record);

        //if (result) { //Remove row grid 1 => grid2 added row
        //    var isRemoved = CIF1013.removeRow(srcGrid.dataSource, record);
        //}
    }

    this.removeOneEmp = function (record, destGrid, srcGrid) {
        //Add row to grid 2
        var result = CIF1013.addRow(destGrid.dataSource, record);

        if (result) { //Remove row grid 1 => grid2 added row
            var isRemoved = CIF1013.removeRow(srcGrid.dataSource, record);
        }
    }

    //Add row to grid datasource
    this.addRow = function (dataSource, row) {
        var isAddedRow = true;
        $.each(dataSource.data(), function () {
            if (this.EmployeeID == row.EmployeeID) {
                isAddedRow = false;
                return isAddedRow;
            }
        });

        if (isAddedRow) {
            row.TeamID = $('#TeamID').val();
            dataSource.add(row);
        }

        return isAddedRow;
    }

    //Add row to grid datasource
    this.removeRow = function (dataSource, row) {
        var isRemoved = false;
        $.each(dataSource.data(), function () {
            if (this.EmployeeID == row.EmployeeID) {
                dataSource.remove(row);
                isRemoved = true;
                return isRemoved;
            }
        });

        return isRemoved;
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
