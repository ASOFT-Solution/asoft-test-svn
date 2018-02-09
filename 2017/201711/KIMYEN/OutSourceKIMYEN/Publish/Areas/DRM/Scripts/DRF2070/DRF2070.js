//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/09/2014      Đức Quý         Tạo mới
//####################################################################

DRF2070 = new function () {
    this.DRF2070Grid = null;

    // Filter button events
    this.btnFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        DRF2070.DRF2070Grid.dataSource.page(1);
    };

    // Reset filter button events
    this.btnClearFilter_Click = function () {
        ASOFT.form.clearMessageBox();
        $('#FormFilter input#ContractNoFilter').val('');

        DRF2070.DRF2070Grid.dataSource.page(1);
    };

    this.sendDataFilter = function () {
        var dataMaster = ASOFT.helper.dataFormToJSON("FormFilter");
        return dataMaster;
    }
}

// Xử lý ban đầu
$(document).ready(function () {
    DRF2070.DRF2070Grid = ASOFT.asoftGrid.castName('DRF2070Grid');
    $("#Config_win").mouseleave(function () {
        CloseWindowMenu();
    });
});


function OpenWinConfig(e) {
    var top = e.offsetHeight + 3;
    var dialog = $("#Config_win").data("kendoWindow");
    if (dialog) {
        var config = $('.asf-header-popupconfig .asf-icon-config').first();
        if (config) {
            config.closest('tr').remove();
        }
        dialog.wrapper.css("min-height", 0)
        dialog.wrapper.css({ top: top, left: e.offsetLeft - (e.offsetWidth - 40), right: 'auto' });
        dialog.open();
    }
}

function CloseWindowMenu() {
    var dialog = $("#Config_win").data("kendoWindow");
    if (dialog) {
        dialog.close();
    }
}