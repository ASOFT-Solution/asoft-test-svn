//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     12/01/2017      Văn Tài          Tạo mới
//####################################################################
var IsCheckExecute = false;
$(document).ready(function () {
    WMF2000.grid = $('#GridWT0095').data('kendoGrid');
    var fromdate = $('#FromDate').val().split('/');
    var todate = $('#ToDate').val().split('/');
    $('#FromDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
    }).data("kendoDatePicker");

    $('#ToDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
    }).data("kendoDatePicker");
})

function onAfterFilter() {
    WMF2000.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_WMF2000', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    WMF2000.isSearch = false;
    $('#FromDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_WMF2000', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = WMF2000.grid.pager.options.buttonCount;
    var CurPage = WMF2000.grid.pager.page();
    if (IsCheckExecute) {
        WMF2000.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        WMF2000.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

WMF2000 = new function () {
    this.grid = null;
    this.isSearch = false;    
}