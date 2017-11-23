//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/06/2016     Quang Chiến       Tạo mới
//####################################################################

var IsCheckExecute = false;
$(document).ready(function () {
    $("#IsConfirm_KPIF2000").data("kendoComboBox").select(0);
    KPIF2000.grid = $("#GridEffort").data("kendoGrid");
    //GridEffort = $("#GridEffort").data("kendoGrid");
    KPIF2000.grid.bind("dataBound", function (e) {
        var dataSource = e.sender._data;
        var TotalHours = 0;
        for (var i = 0; i < dataSource.length; i++) {
            TotalHours = (dataSource[i].IsHours && dataSource[i].IsHours >= 0) ? TotalHours + parseFloat(dataSource[i].IsHours) : TotalHours + 0;
        }
        $('div#totalFooterIsHours').text(kendo.toString(kendo.parseFloat(TotalHours), "#,#.#0"));
    });

})

function BtnExport_Click() {
    IsCheckExecute = true;
    // Do print or export action
    KPIF2000.doPrintOrExport(false);
}

function onAfterFilter() {
    KPIF2000.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_KPIF2000', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    KPIF2000.isSearch = false;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_KPIF2000', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = KPIF2000.grid.pager.options.buttonCount;
    var CurPage = KPIF2000.grid.pager.page();
    if (IsCheckExecute) {
        KPIF2000.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        KPIF2000.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

function CustomConfirmAll() {
    ASOFT.form.clearMessageBox();
    IsCheckExecute = true;
    if ($('#IsConfirm_KPIF2000').val() == 1) {
        ASOFT.form.displayError('#FormFilter', ASOFT.helper.getMessage("KPIFML000004"))
        return;
    }
    var args = [];
    var records = ASOFT.asoftGrid.selectedRecords(KPIF2000.grid, 'FormFilter');
    if (records.length == 0) return;
    var url = '/PopupLayout/Index/KPI/KPIF2001?Pk=ConfirmAll';
    ASOFT.asoftPopup.showIframe(url, {});
}

KPIF2000 = new function () {
    this.grid = null;
    this.isSearch = false;
    // chức năng in & xuất
    var isPrint = false;
    this.doPrintOrExport = function (ischecked) {
        var args = [];
        var grid = $('#GridEffort').data('kendoGrid');

        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_KPIF2000');

        var dataFormFilters = JSON.parse(dataFormFilter);
        if (KPIF2000.isSearch) {
            data = dataFormFilters;
        } else {
            data = ASOFT.helper.dataFormToJSON("FormFilter");
        }

        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        data.IsSearch = KPIF2000.isSearch;
        if (data.IsCheckAll == 0) {
            if (grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].EffortID);
                }
            }
        }
        data.ReportID = 'KPIR2000Report';
        isPrint = ischecked;
        data.EffortIDList = args.join(",");
        var urlPost = "/KPI/KPIF2000/DoPrintOrExport";
        ASOFT.helper.postTypeJson(urlPost, data, KPIF2000.exportOrPrintSuccess);
    }

    this.exportOrPrintSuccess = function (result) {
        if (result) {
            var urlPrint = '/KPI/KPIF2000/ReportViewer';
            var urlExcel = '/KPI/KPIF2000/GetReportFile';
            var urlPost = isPrint ? urlPrint : urlExcel;
            var options = isPrint ? '&viewer=pdf' : '';
            // Tạo path full
            var fullPath = urlPost + "?id=" + result.apk + "&reportId=" + result.reportId + "&host=" + result.host + options;

            // Getfile hay in báo cáo
            if (options) {
                window.open(fullPath, "_blank");
            } else {
                window.location = fullPath;
            }
        }
    }

    this.IsConfirm_Click = function (effortID) {
        var url = '/PopupLayout/Index/KPI/KPIF2001?Pk=' + effortID + '&Table=Effort&key=EffortID';
        ASOFT.asoftPopup.showIframe(url, {});
    }
}