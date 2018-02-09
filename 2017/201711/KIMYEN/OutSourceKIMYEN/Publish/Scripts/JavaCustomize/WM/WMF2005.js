//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/01/2017      Văn Tài          Tạo mới
//####################################################################
var IsCheckExecute = false;
$(document).ready(function () {
    WMF2005.grid = $('#GridWT0095').data('kendoGrid');
    var fromdate = $('#FromDate').val().split('/');
    var todate = $('#ToDate').val().split('/');
    $('#FromDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
    }).data("kendoDatePicker");

    $('#ToDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
    }).data("kendoDatePicker");

    $('#BtnPrint').unbind();
    $('#BtnPrint').parent().css('position','relative');
    $('#BtnPrint').parent().append("<ul class='submenu'><li><a  onclick='PrintClick(\"WR0096Report\")'>" + $("#Report01_WMF2005").val() + "</li><li><a onclick='PrintClick(\"WR0096BReport\")'>" + $("#Report02_WMF2005").val() + "</li></ul>");
})

function onAfterFilter() {
    WMF2005.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_WMF2005', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    WMF2005.isSearch = false;
    $('#FromDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_WMF2005', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = WMF2005.grid.pager.options.buttonCount;
    var CurPage = WMF2005.grid.pager.page();
    if (IsCheckExecute) {
        WMF2005.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        WMF2005.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

WMF2005 = new function () {
    this.grid = null;
    this.isSearch = false;    
}


function PrintClick(reportID) {
    ASOFT.form.clearMessageBox();
    IsCheckExecute = true;
    // Do print or export action
    WMF2005.doPrintOrExport(true, reportID);

}

WMF2005 = new function () {
    this.grid = null;
    this.isSearch = false;
    var isPrint = false;
    this.doPrintOrExport = function (ischecked, reportID) {
        var args = [];
        var grid = $('#GridWT0095').data('kendoGrid');
        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_WMF2005');
        var dataFormFilters = JSON.parse(dataFormFilter);
        if (WMF2005.isSearch) {
            data = dataFormFilters;
        } else {
            data = ASOFT.helper.dataFormToJSON("FormFilter");
        }
        data.IsSearch = WMF2005.isSearch;
        data.Mode = 2;
        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].VoucherID);
                }
            }
        }
        data.ReportID = reportID;
        isPrint = ischecked;

        data.VoucherIDList = args;
        var urlPost = "/WM/WMF2005/DoPrintOrExport";
        ASOFT.helper.postTypeJson(urlPost, data, WMF2005.exportOrPrintSuccess);
    }

    this.exportOrPrintSuccess = function (result) {
        if (result) {
            if (result.isDataSource) {
                var urlPrint = '/WM/WMF2005/ReportViewer';
                var urlExcel = '/WM/WMF2005/GetReportFile';
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
    }
}

function ParseDate(d) {
    return kendo.toString(kendo.parseDate(d), 'dd/MM/yyyy')
}