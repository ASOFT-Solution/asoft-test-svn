$(document).ready(function () {
    SOF0006.SOF0006Grid = ASOFT.asoftGrid.castName('SOF0006Grid');
    SOF0006.SOF0006GridChoose = ASOFT.asoftGrid.castName('SOF0006GridChoose');
    SOF0006.searchbtnFilter = false;
});

SOF0006 = new function () {
    this.SOF0006Grid = null;
    this.SOF0006GridChoose = null;
    this.searchbtnFilter = false;
    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SOF0006.searchbtnFilter = true;
        SOF0006.SOF0006Grid.dataSource.read();        
    };

    //Load lại grid
    this.sendDataFilter = function () {
        
        var arrdata = [];
        if (SOF0006.SOF0006GridChoose && SOF0006.SOF0006GridChoose.dataSource._data.length > 0) {
            var dataListInventoryTypeID = SOF0006.SOF0006GridChoose.dataSource._data;
            $.each(dataListInventoryTypeID, function (key, value) {
                arrdata.push(value.InventoryTypeID);
            })
        }
        var dataMaster = [];
        dataMaster.TextSearch = $('#TextSearch').val();
        dataMaster.ListInventoryTypeID = SOF0006.searchbtnFilter ? arrdata.join("','") : $('#InventoryTypeList').val().split(",").join("','");
        dataMaster.InventoryTypeList = $('#InventoryTypeList').val().split(",").join("','");
        
        return dataMaster;
    };

    // Cancel button events
    this.btnCancel_Click = function () {
        // Hide Iframe
        ASOFT.asoftPopup.hideIframe(true);
    };

    this.btn_ChangeSingle = function () {
        //removeRowIsempty(SOF0006.SOF0006GridChoose);
        var record = ASOFT.asoftGrid.selectedRecord(SOF0006.SOF0006Grid);
        rowNumber = 0;
        if (!record || record.InventoryTypeID == null) return;
        SOF0006.SOF0006GridChoose.dataSource.add(record);
        SOF0006.SOF0006Grid.dataSource.remove(record);
        SOF0006.SOF0006Grid.focus(0);
    }

    this.btn_UnChangeSingle = function () {
        //removeRowIsempty(SOF0006.SOF0006Grid);
        var record = ASOFT.asoftGrid.selectedRecord(SOF0006.SOF0006GridChoose);
        if (!record || record.InventoryTypeID == null) return;
        SOF0006.SOF0006Grid.dataSource.add(record);
        SOF0006.SOF0006GridChoose.dataSource.remove(record);
        SOF0006.SOF0006GridChoose.focus(0);
    }

    this.btn_ChangeAll = function () {
        //removeRowIsempty(SOF0006.SOF0006GridChoose);
        var userIndex = [];
        $.each(SOF0006.SOF0006Grid.dataSource.data(), function (index, value) {
            if (value || value.InventoryTypeID != null || value.InventoryTypeID != '') {
                userIndex.push(value);
                SOF0006.SOF0006GridChoose.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SOF0006.SOF0006Grid.dataSource.remove(val);
        });
        SOF0006.SOF0006GridChoose.focus(0);
    }

    this.btn_ReturnAll = function () {
        //removeRowIsempty(SOF0006.SOF0006Grid);
        var userIndex = [];
        $.each(SOF0006.SOF0006GridChoose.dataSource.data(), function (index, value) {
            if (value || value.InventoryTypeID != null || value.InventoryTypeID != '') {
                userIndex.push(value);
                SOF0006.SOF0006Grid.dataSource.add(value);
            }
        });
        if (userIndex.length == 0) return;
        $.each(userIndex, function (index, val) {
            SOF0006.SOF0006GridChoose.dataSource.remove(val);
        });
        SOF0006.SOF0006Grid.focus(0);
    }

    this.btnChoose_Click = function () {
        var data = []
        if (SOF0006.SOF0006GridChoose && SOF0006.SOF0006GridChoose.dataSource._data.length > 0) {
            var dataListInventoryTypeID = SOF0006.SOF0006GridChoose.dataSource._data;
            $.each(dataListInventoryTypeID, function (key, value) {
                data.push(value.InventoryTypeID);
            })
        }
        window.parent.ASOFT.helper.setObjectData(data);
        executeFunctionByName(window.parent.delegateFunction);

        ASOFT.asoftPopup.hideIframe(true);        
    }
}