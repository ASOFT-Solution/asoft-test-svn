//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/10/2014      Trí Thiện         Tạo mới
//####################################################################

$(document).ready(function () {
    DRF0200.DRF0200Grid = ASOFT.asoftGrid.castName('DRF0200Grid');
    DRF0200.DRF0200Grid.bind('dataBound', DRF0200.gridBound);
    DRF0200.DRF0200Grid.bind('change', DRF0200.gridChange);
})

//Array.prototype.remove = function (value) {
//    this.splice(this.indexOf(value), 1);
//    return true;
//};

DRF0200 = new function () {
    this.DRF0200Grid = null;
    this.DRF0200GridData = [];
    this.DRF0200GridDataCopy = [];
    this.rowNum = 0;
    this.invalidGroup = false;
    this.firstBound = true;
    this.CustomerID = null;
    this.deletedItems = [];
    this.addedItems = [];
    
    this.gridBound = function () {
        DRF0200.rowNum = 0;
        if (DRF0200.firstBound) {
            DRF0200.DRF0200GridData = [];
            $.each(this.dataSource.data(), function () {
                DRF0200.DRF0200GridData.push(this);
            });

            DRF0200.firstBound = false;
            DRF0200.filter();
        }
        
    };

    this.gridChange = function () {
        var item = this.dataItem(this.select());
        if (item && item.CustomerID != null & item.BranchID != null) {
            // Update current item
            var index = DRF0200.DRF0200GridData.indexOf(item);
            if (index > 0) {
                var current = DRF0200.DRF0200GridData[index];
                current.BranchID = item.BranchID;
                current.CustomerID = item.CustomerID;
                current.FeePercent = item.FeePercent;
            }
        }
    };

    this.filter = function (field, value) {
        var data = DRF0200.gridView_Filter(
            DRF0200.DRF0200Grid,
            DRF0200.DRF0200GridData,
            'CustomerID',
            DRF0200.CustomerID);

        var empty = {
            APK: null,
            BranchID: "",
            CreateDate: null,
            CreateUserID: null,
            CustomerID: "",
            DivisionID: null,
            FeePercent: 0,
            TranMonth: null,
            TranYear: null
        }

        if (!data || (data && data.length == 0))
        {
            data.push(empty);
        }

        DRF0200.DRF0200Grid.dataSource.data(data);
    }

    // Cập nhật dữ liêu danh sách
    this.changeData = function () {

        DRF0200.addedItems = DRF0200.gridView_Filter(
            DRF0200.DRF0200Grid,
            DRF0200.DRF0200Grid.dataSource.data(),
            'APK',
            null);

        if (DRF0200.addedItems.length > 0) {
            for (var i = 0; i < DRF0200.addedItems.length; i++) {
                var item = DRF0200.addedItems[i];
                if (item.CustomerID == null || item.CustomerID == "") {
                    item.CustomerID = DRF0200.CustomerID;
                    DRF0200.DRF0200GridData.push(item);
                }
            }
        }

        if (DRF0200.deletedItems.length > 0) {
            for (var i = 0; i < DRF0200.deletedItems.length; i++) {
                DRF0200.DRF0200GridData.splice(
                    DRF0200.DRF0200GridData.indexOf(DRF0200.deletedItems[i]), 1)
            }
        }

        // Reset all
        DRF0200.deletedItems = [];
        DRF0200.addedItems = [];
    };

    this.rowNumber = function () {
        return ++DRF0200.rowNum;
    }

    // Xóa dòng rỗng trước khi lưu
    this.removeEmpty = function () {
        var currentData = DRF0200.DRF0200Grid.dataSource.data();
        var items = [];
        for (var i = 0; i < currentData.length; i++) {
            if ((currentData[i].BranchID == null || currentData[i].BranchID == "")
                && currentData[i].FeePercent == 0) {
                items.push(currentData[i]);
            }
        }
        if (items) {
            items.forEach(function (e, i) {
                DRF0200.DRF0200Grid.dataSource.data().remove(e);
            });
        }
        
    }

    //Event button config
    this.btnConfig_Click = function () {

        DRF0200.removeEmpty();
        // Update data before change
        DRF0200.changeData();

        if (DRF0200.DRF0200GridData.length <= 0) { //Lưới không có dòng nào ko có cho lưu
            ASOFT.form.displayMessageBox('#DRF0200', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }

        if (ASOFT.form.checkRequiredAndInList('DRF0200', ["CustomerID"])) {
            return;
        }

        //Check required
        $('#DRF0200').removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(DRF0200.DRF0200Grid);
        if (ASOFT.asoftGrid.editGridValidate(DRF0200.DRF0200Grid, [])) {
            msg = ASOFT.helper.getMessage('DRFML000028');
            ASOFT.form.displayError('#DRF0200', msg);
            return;
        }

        //Kiểm tra trùng GroupID
        var data = DRF0200.DRF0200Grid.dataSource.data();
        var groupIDList = DRF0200.groupBy_DataSource(data);
        var result = true;

        //Check GroupID
        $.each(groupIDList, function () {
            if (this.length > 1) {
                msg = ASOFT.helper.getMessage('DRFML000029');
                ASOFT.form.displayError('#DRF0200', msg);
                DRF0200.DRF0200Grid.focus(DRF0200.DRF0200Grid.dataSource.indexOf(this[0]));
                DRF0200.invalidGroup = true;
                result = false;
                return;
            }
        })

        if (!result) return;//Không cho lưu

        var data = {
            List: DRF0200.DRF0200GridData
        }
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, DRF0200.drf0200SaveSuccess);
    };

    this.drf0200SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'DRF0200', function () {
            DRF0200.btnClose_Click();
        }, function () {
            DRF0200.filter();
        }, null, true);
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
    };

    this.check_BrandID = function (data, obj) {
        var groupIDList = DRF0200.groupBy_DataSource(data);

        if (groupIDList[obj.value()].length > 1) {
            msg = ASOFT.helper.getMessage('DRFML000029');
            ASOFT.form.displayError('#DRF0200', msg);
            $(obj.element).parent().addClass('asf-focus-input-error');
            $(obj.element).focus();
            DRF0200.invalidGroup = true;
            return;
        }
        else {
            ASOFT.form.clearMessageBox();
        }

        DRF0200.invalidGroup = false;
    }

    //Group data source => GroupID
    this.groupBy_DataSource = function (data) {
        var groupIDList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i].BranchID;
            if (typeof groupIDList[temp] === 'undefined') {
                groupIDList[temp] = [];
            }
            groupIDList[temp].push(data[i]);
        }
        return groupIDList;
    }

    this.deleteItem = function (e) {
        row = $(e).parent();
        var data = DRF0200.DRF0200Grid.dataSource.data();

        if (DRF0200.DRF0200Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var row = data[0];
            row.set('BranchID', null);
            row.set('FeePercent', 0);
            return;
        }

        var deleted = DRF0200.DRF0200Grid.dataItem(DRF0200.DRF0200Grid.select());
        if (deleted && (deleted.APK != null || (deleted.APK == null && deleted.CustomerID != null))) {
            DRF0200.deletedItems.push(deleted);
        }
        
        ASOFT.asoftGrid.removeEditRow(row, DRF0200.DRF0200Grid, null);
    };

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.customer_Changed = function () {

        DRF0200.removeEmpty();
        // Update data before change
        DRF0200.changeData();

        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#CustomerName').val(dataItem.CustomerName);
        DRF0200.CustomerID = dataItem.CustomerID;

        //Filter grid
        DRF0200.filter();
    };

    //Sự kiên selectedIndexChanged combo chi nhánh
    this.customer_Bound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (dataItem == null) return;

        $('#CustomerName').val(dataItem.CustomerName);
        DRF0200.CustomerID = dataItem.CustomerID;
    };

    //Lọc dữ liệu
    this.gridView_Filter = function (grid, data, field, value) {
        //grid.dataSource.data(data);
        $filter = new Array();
        $filter.push({ field: field, operator: "eq", value: value });
        var query = new kendo.data.Query(data);
        return query.filter($filter).data;
    }
}


function brand_Changed() {
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
            "DRF0200Grid",
            DRF0200.DRF0200Grid,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );

    var data = DRF0200.DRF0200Grid.dataSource.data();
    DRF0200.check_BrandID(data, this);
}

