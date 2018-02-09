//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################
var IsCheckExecute = false;
$(document).ready(function () { 
    OOF2070.grid = $('#GridOOT9000').data('kendoGrid');

    var cboDepartment = $("#DepartmentID_OOF2070").data("kendoComboBox");
    cboDepartment.bind("change", function (e) {
        $("#SectionID_OOF2070").data("kendoComboBox").text('');
        $("#SubsectionID_OOF2070").data("kendoComboBox").text('');
        $("#ProcessID_OOF2070").data("kendoComboBox").text('');

        cboDepartment.input.focus();
    });

    var cboSection = $("#SectionID_OOF2070").data("kendoComboBox");
    cboSection.bind("change", function (e) {
        $("#SubsectionID_OOF2070").data("kendoComboBox").text('');
        $("#ProcessID_OOF2070").data("kendoComboBox").text('');

        cboSection.input.focus();
    });

    var cboSubsection = $("#SubsectionID_OOF2070").data("kendoComboBox");
    cboSubsection.bind("change", function (e) {
        $("#ProcessID_OOF2070").data("kendoComboBox").text('');
        cboSubsection.input.focus();
    });
})

function onAfterFilter() {
    OOF2070.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2070', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    OOF2070.isSearch = false;
    $('#FromCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2070', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2070.grid.pager.options.buttonCount;
    var CurPage = OOF2070.grid.pager.page();
    if (IsCheckExecute) {
        OOF2070.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2070.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

function ParseDate(d) {
    return d.split(' ')[0];
}

OOF2070 = new function () {
    this.grid = null;
    this.IsSearch = false;
};
