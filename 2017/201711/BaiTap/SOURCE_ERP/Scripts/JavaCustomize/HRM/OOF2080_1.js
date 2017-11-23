//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################
var IsCheckExecute = false;
$(document).ready(function () {
    OOF2080.grid = $('#GridOOT9000').data('kendoGrid');
    var fromdate = $('#FromDate').val().split('/');
    var todate = $('#ToDate').val().split('/');
    $('#FromDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
        //max: new Date(todate[2], parseInt(todate[1]) - 1, todate[0]),
        //min: new Date(fromdate[2], parseInt(todate[1])-1, fromdate[0]),
    }).data("kendoDatePicker");
    
    $('#ToDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
        //max: new Date(todate[2], parseInt(todate[1]) - 1, todate[0]),
        //min: new Date(fromdate[2], parseInt(todate[1]) - 1, fromdate[0]),
    }).data("kendoDatePicker");
})
function BtnExport_Click() {
    ASOFT.form.clearMessageBox();
    IsCheckExecute = true;
    // Do print or export action
    OOF2080.doPrintOrExport(false);

}

function onAfterFilter() {
    OOF2080.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2080', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    OOF2080.isSearch = false;
    $('#FromDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $('#ToDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    sessionStorage.setItem('dataFormFilter_OOF2080', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2080.grid.pager.options.buttonCount;
    var CurPage = OOF2080.grid.pager.page();
    if (IsCheckExecute) {
        OOF2080.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2080.grid.dataSource.page(1);
    }
}

OOF2080 = new function () {
    this.grid = null;
    this.isSearch = false;
    // chức năng in & xuất
    var isPrint = false;
    this.doPrintOrExport = function (ischecked) {
        var args = [];
        var grid = $('#GridOOT9000').data('kendoGrid');

        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_OOF2080');

        var dataFormFilters = JSON.parse(dataFormFilter);
        if (OOF2080.isSearch) {
            data = dataFormFilters;
        } else {
            data = ASOFT.helper.dataFormToJSON("FormFilter");
        }

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
        data.ReportID = 'OOF2080Report';
        isPrint = ischecked;
        data.APKList = args.join("','");
        var urlPost = "/HRM/OOF2080/DoPrintOrExport";
        ASOFT.helper.postTypeJson(urlPost, data, OOF2080.exportOrPrintSuccess);
    }

    this.exportOrPrintSuccess = function (result) {
        if (result) {
            var urlPrint = '/HRM/OOF2080/ReportViewer';
            var urlExcel = '/HRM/OOF2080/GetReportFile';
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

    //link dưới field ID
    this.ShowDetail_Click = function (apkMaster, type) {
        var url = null;
        switch (type) {
            case 'BPC':
                url = '/ViewMasterDetail/Index/HRM/OOF2002?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXP':
                url = '/ViewMasterDetail/Index/HRM/OOF2012?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXRN':
                url = '/ViewMasterDetail/Index/HRM/OOF2022?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXLTG':
                url = '/ViewMasterDetail/Index/HRM/OOF2032?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXBSQT':
                url = '/ViewMasterDetail/Index/HRM/OOF2042?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
            case 'DXDC':
                url = '/ViewMasterDetail/Index/HRM/OOF2072?PK=' + apkMaster + '&Table=OOT9000&key=APK&DivisionID=MK&Status=1';
                break;
        }

        window.open(url);
    }
}

function ChangeLanguage() {
    var data = $('#Execute_OOF2080').val()
    return data;
}