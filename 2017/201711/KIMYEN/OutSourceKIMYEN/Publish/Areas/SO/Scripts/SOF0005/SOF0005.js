$(document).ready(function () {
    SOF0005.SOF0005Grid = ASOFT.asoftGrid.castName('SOF0005Grid');
    SOF0005.SOF0005GridChoose = ASOFT.asoftGrid.castName('SOF0005GridChoose');
    SOF0005.searchbtnFilter = false;
});

SOF0005 = new function () {
    this.SOF0005Grid = null;
    this.SOF0005GridChoose = null;
    this.searchbtnFilter = false;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SOF0005.searchbtnFilter = true;
        SOF0005.SOF0005Grid.dataSource.read();
    };

    //Load lại grid
    this.sendDataFilter = function () {
        var arrdata = [];
        if (SOF0005.SOF0005GridChoose && SOF0005.SOF0005GridChoose.dataSource._data.length > 0) {
            var dataListUserID = SOF0005.SOF0005GridChoose.dataSource._data;
            $.each(dataListUserID, function (key, value) {
                arrdata.push(value.UserID);
            })
        }

        var dataMaster = [];
        dataMaster.TextSearch = $('#TextSearch').val();
        dataMaster.UserList = SOF0005.searchbtnFilter ? arrdata.join("','") : $('#UserList').val().split(",").join("','");
        dataMaster.VoucherTypeID = $('#VoucherTypeID').val();
        return dataMaster;
    };

    // Cancel button events
    this.btnCancel_Click = function () {
        // Hide Iframe
        ASOFT.asoftPopup.hideIframe(true);
    };
    
    this.btn_ChangeSingle = function () {
        //removeRowIsempty(SOF0005.SOF0005GridChoose);
        var record = ASOFT.asoftGrid.selectedRecord(SOF0005.SOF0005Grid);
        rowNumber = 0;
        if (!record || record.UserID == null) return;
        SOF0005.SOF0005GridChoose.dataSource.add(record);
        SOF0005.SOF0005Grid.dataSource.remove(record);
        SOF0005.SOF0005Grid.focus(0);
    }

    this.btn_UnChangeSingle = function () {
        //removeRowIsempty(SOF0005.SOF0005Grid);
        var record = ASOFT.asoftGrid.selectedRecord(SOF0005.SOF0005GridChoose);
        rowNumber = 0;
        if (!record || record.UserID == null) return;
        SOF0005.SOF0005Grid.dataSource.add(record);
        SOF0005.SOF0005GridChoose.dataSource.remove(record);
        SOF0005.SOF0005GridChoose.focus(0);
    }

    this.btn_ChangeAll = function () {
        //removeRowIsempty(SOF0005.SOF0005GridChoose);
        var userIndex = [];
        $.each(SOF0005.SOF0005Grid.dataSource.data(), function (index, value) {
            if (value || value.UserID != null || value.UserID != '') {
                userIndex.push(value);
                SOF0005.SOF0005GridChoose.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SOF0005.SOF0005Grid.dataSource.remove(val);
        });
        SOF0005.SOF0005GridChoose.focus(0);
    }

    this.btn_ReturnAll = function () {
        //removeRowIsempty(SOF0005.SOF0005Grid);
        var userIndex = [];
        $.each(SOF0005.SOF0005GridChoose.dataSource.data(), function (index, value) {
            if (value || value.UserID != null || value.UserID != '') {
                userIndex.push(value);
                SOF0005.SOF0005Grid.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SOF0005.SOF0005GridChoose.dataSource.remove(val);
        });
        SOF0005.SOF0005Grid.focus(0);
    }

    this.btnChoose_Click = function () {
        var VoucherTypeID = $('#VoucherTypeID').val();
        var data = [];
        if (SOF0005.SOF0005GridChoose && SOF0005.SOF0005GridChoose.dataSource._data.length > 0) {
            var dataListUserID = SOF0005.SOF0005GridChoose.dataSource._data;
            $.each(dataListUserID, function (key, value) {
                data.push({ VoucherTypeID: VoucherTypeID, UserID: value.UserID });
            })
        }
        data.push(VoucherTypeID);
        window.parent.ASOFT.helper.setObjectData(data);
        executeFunctionByName(window.parent.delegateFunction);

        ASOFT.asoftPopup.hideIframe(true);
    }
}