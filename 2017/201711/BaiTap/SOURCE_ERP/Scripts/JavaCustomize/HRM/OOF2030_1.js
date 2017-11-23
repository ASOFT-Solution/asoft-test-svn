//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/08/2016     Quang Chiến       Tạo mới
//####################################################################
var IsCheckExecute = false;
$(document).ready(function () {
    OOF2030.grid = $('#GridOOT9000').data('kendoGrid');

    var cboDepartment = $("#DepartmentID_OOF2030").data("kendoComboBox");
    cboDepartment.bind("change", function (e) {
        $("#SectionID_OOF2030").data("kendoComboBox").text('');
        $("#SubsectionID_OOF2030").data("kendoComboBox").text('');
        $("#ProcessID_OOF2030").data("kendoComboBox").text('');

        cboDepartment.input.focus();
    });

    var cboSection = $("#SectionID_OOF2030").data("kendoComboBox");
    cboSection.bind("change", function (e) {
        $("#SubsectionID_OOF2030").data("kendoComboBox").text('');
        $("#ProcessID_OOF2030").data("kendoComboBox").text('');

        cboSection.input.focus();
    });

    var cboSubsection = $("#SubsectionID_OOF2030").data("kendoComboBox");
    cboSubsection.bind("change", function (e) {
        $("#ProcessID_OOF2030").data("kendoComboBox").text('');
        cboSubsection.input.focus();
    });
});

function PrintClick() {
    ASOFT.form.clearMessageBox();
    IsCheckExecute = true;
    // Do print or export action
    OOF2030.doPrintOrExport(true);
   
}

function onAfterFilter() {
    OOF2030.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2030', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    OOF2030.isSearch = false;
    $('#FromCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToCreateDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2030', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2030.grid.pager.options.buttonCount;
    var CurPage = OOF2030.grid.pager.page();
    if (IsCheckExecute) {
        OOF2030.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2030.grid.dataSource.page(1);
    }
}

function onShowEditorFrame() {
    IsCheckExecute = true;
}

function onAfterDeleteSuccess() {
    IsCheckExecute = true;
    onRefreshGrid();
}

OOF2030 = new function () {
    this.grid = null;
    this.isSearch = false;
    var isPrint = false;
    this.doPrintOrExport = function (ischecked) {
        var args = [];
        var grid = $('#GridOOT9000').data('kendoGrid');
        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_OOF2030');
        var dataFormFilters = JSON.parse(dataFormFilter);
        if (OOF2030.isSearch) {
            data = dataFormFilters;
        } else {
            data = ASOFT.helper.dataFormToJSON("FormFilter");
        }
        data.IsSearch = OOF2030.isSearch;

        data.IsCheckAll = $('#chkAll').prop('checked') ? 1 : 0;
        if (data.IsCheckAll == 0) {
            if (grid) { // Lấy danh sách các dòng đánh dấu
                var records = ASOFT.asoftGrid.selectedRecords(grid, 'FormFilter');
                if (records.length == 0) return;
                for (var i = 0; i < records.length; i++) {
                    args.push(records[i].APK);
                }
            }
        }
        data.ReportID = 'OOF2083Report';
        isPrint = ischecked;

        data.APKList = args.join(",");
        var urlPost = "/HRM/OOF2030/DoPrintOrExport";
        ASOFT.helper.postTypeJson(urlPost, data, OOF2030.exportOrPrintSuccess);
    }

    this.exportOrPrintSuccess = function (result) {
        if (result) {
            if (result.isDataSource) {
                var urlPrint = '/HRM/OOF2030/ReportViewer';
                var urlExcel = '/HRM/OOF2030/GetReportFile';
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
            //if( result.paramID)
            //    ASOFT.form.displayMessageBox('#FormFilter', [ASOFT.helper.getMessage('OOFML000035').f(result.paramID)], null);
        }
    }
}

function ParseDate(d) {
    return d.split(' ')[0];
}