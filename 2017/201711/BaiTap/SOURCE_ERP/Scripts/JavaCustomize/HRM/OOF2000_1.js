//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################
var tablecontent = null;
var screen = null;
var IsCheckExecute = false;
$(document).ready(function () {
    OOF2000.grid = $('#GridOOT9000').data('kendoGrid');
    $('#BtnInherit').unbind();
    $("#BtnInherit").kendoButton({
        "click": CustomBtnInherit_Click,
    });

    $("#btnImport").kendoButton({
        "click": btnImport_Click,
    });
    screen = $("#sysScreenID").val();
    tablecontent = $("#sysTable" + screen).val();

    if ($("#CheckDetail").val() == 1) {
        $("#DepartmentID").data("kendoComboBox").readonly();
        $("#SectionID").data("kendoComboBox").readonly();
        $("#SubsectionID").data("kendoComboBox").readonly();
        $("#ProcessID").data("kendoComboBox").readonly();
    }else{
 var cboDepartment = $("#DepartmentID_OOF2000").data("kendoComboBox");
    cboDepartment.bind("change", function (e) {
        $("#SectionID_OOF2000").data("kendoComboBox").text('');
        $("#SubsectionID_OOF2000").data("kendoComboBox").text('');
        $("#ProcessID_OOF2000").data("kendoComboBox").text('');

        cboDepartment.input.focus();
    });

    var cboSection = $("#SectionID_OOF2000").data("kendoComboBox");
    cboSection.bind("change", function (e) {
        $("#SubsectionID_OOF2000").data("kendoComboBox").text('');
        $("#ProcessID_OOF2000").data("kendoComboBox").text('');

        cboSection.input.focus();
    });

    var cboSubsection = $("#SubsectionID_OOF2000").data("kendoComboBox");
    cboSubsection.bind("change", function (e) {
        $("#ProcessID_OOF2000").data("kendoComboBox").text('');
        cboSubsection.input.focus();
    });
	}
})
// Add new button events
function btnImport_Click() {
    IsCheckExecute = true;
    // [1] Tạo form status : Add new
    //DRF2000.formStatus = 1;

    // [2] Url load dữ liệu lên form
    var postUrl = "/Import/Index";

    // [3] Data load dữ liệu lên form
    var data = {
        type: "TableAssignShift"
    };

    // [4] Hiển thị popup
    showPopup(postUrl, data);
};

// show popup
function showPopup (url, data) {
    // [1] Format url with object data
    var postUrl = ASOFT.helper.renderUrl(url, data);

    // [2] Render iframe
    ASOFT.asoftPopup.showIframe(postUrl, {});
};

function CustomBtnInherit_Click() {
    IsCheckExecute = true;
    var args = [];
    var key = [];
    var grid = $('#Grid' + tablecontent).data('kendoGrid');
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(grid);
    if (records.length == 0) return;

    if (records.length > 1) {
        ASOFT.dialog.showMessage('OOFML000025');
        return;
    }

    var valuepk = records[0].APK;
    args.push(valuepk);
   

    url = '/PopupLayout/Index/HRM/OOF2001?key=APK_1&Table=OOT9000&PK='+args;
    ASOFT.asoftPopup.showIframe(url, {});
}

function ParseDate(d) {
    return d.split(' ')[0];
}

function onAfterFilter() {
    OOF2000.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster.IsSearch = OOF2000.isSearch;
    sessionStorage.setItem('dataFormFilter_OOF2000', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    OOF2000.isSearch = false;
    $('#FromCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster.IsSearch = OOF2000.isSearch;
    sessionStorage.setItem('dataFormFilter_OOF2000', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2000.grid.pager.options.buttonCount;
    var CurPage = OOF2000.grid.pager.page();
    if (IsCheckExecute) {
        OOF2000.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2000.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

OOF2000 = new function () {
    this.grid = null;
    this.IsSearch = false;
};
