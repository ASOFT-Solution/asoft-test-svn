//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#    23/09/2015      Quang Chiến         Tạo mới
//####################################################################

$(document).ready(function () {
    SF1040.SF1040Grid = ASOFT.asoftGrid.castName('SF1040Grid');
    SF1040.comboTableID = ASOFT.asoftComboBox.castName('TableID');
})

SF1040 = new function () {
    this.isSearch = false;
    this.SF1040Grid = null;
    this.comboTableID = null;
    this.urlUpdate = null;
    var ColumnPK = null;
    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SF1040.isSearch = true;
        SF1040.SF1040Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        SF1040.isSearch = false;
        $('#FormFilter input').val('');
        SF1040.SF1040Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        if (ColumnPK == null) {
            var combobox = $("#TableID").data("kendoComboBox");
            ColumnPK = combobox.dataSource._data[0].ColumnPK;
        }
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        dataMaster['IsSearch'] = SF1040.isSearch;
        dataMaster['ColumnPK'] = ColumnPK;
        return dataMaster;
    };

    this.CloseCombo = function (e) {
        if (e.sender.dataSource._data) {
            ColumnPK = e.sender.dataSource._data[e.sender.selectedIndex].ColumnPK;
        }
    }
}