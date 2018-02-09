//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################
var LanguageMethodIsConfirm = null;
var IsCheckExecute = false;
$(document).ready(function () {
    $("#HandleMethod_OOF2060").data("kendoComboBox").select(0);
    $("#IsApproved_OOF2060").data("kendoComboBox").select(0);
    OOF2060.grid = $('#GridOOT2060').data('kendoGrid');
    var fromdate = $('#FromDate').val().split('/');
    var todate = $('#ToDate').val().split('/');
    $('#FromDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
        max: new Date(todate[2], parseInt(todate[1]) - 1, todate[0]),
        min: new Date(fromdate[2], parseInt(todate[1])-1, fromdate[0]),
    }).data("kendoDatePicker");
    
    $('#ToDate').kendoDatePicker({
        format: 'dd/MM/yyyy',
        max: new Date(todate[2], parseInt(todate[1]) - 1, todate[0]),
        min: new Date(fromdate[2], parseInt(todate[1]) - 1, fromdate[0]),
    }).data("kendoDatePicker");
})
function BtnExport_Click() {
    // Do print or export action
    IsCheckExecute = true;
    OOF2060.doPrintOrExport(false);

}

function CustomEventChangeUnusualType() {
    ASOFT.form.clearMessageBox();
    var args = [];
    var records = ASOFT.asoftGrid.selectedRecords(OOF2060.grid, 'FormFilter');
    if (records.length == 0) return;

    url = '/PopupLayout/Index/HRM/OOF2061?key=APK_ChangeFact&Table=OOT2060&PK=' + records[0]["APK"];
    ASOFT.asoftPopup.showIframe(url, {});
}

function onAfterFilter() {
    OOF2060.isSearch = true;
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster.IsSearch = OOF2060.isSearch;
    sessionStorage.setItem('dataFormFilter_OOF2060', JSON.stringify(datamaster));
}

function onAfterClearFilter() {
    OOF2060.isSearch = false;
    $('#FromDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.BeginDate, "dd/MM/yyyy"),"dd/MM/yyyy"));
    $('#ToDate').val(kendo.toString(kendo.parseDate(ASOFTEnvironment.EndDate, "dd/MM/yyyy"), "dd/MM/yyyy"));
    $("#HandleMethod_OOF2060").data("kendoComboBox").select(0);
    $("#IsApproved_OOF2060").data("kendoComboBox").select(0);
    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
    datamaster.IsSearch = OOF2060.isSearch;
    sessionStorage.setItem('dataFormFilter_OOF2060', JSON.stringify(datamaster));
}

function onRefreshGrid() {
    var totalPage = OOF2060.grid.pager.options.buttonCount;
    var CurPage = OOF2060.grid.pager.page();
    if (IsCheckExecute) {
        OOF2060.grid.dataSource.page(CurPage <= totalPage ? CurPage : 1);
        IsCheckExecute = false;
    } else {
        OOF2060.grid.dataSource.page(1);
    }
}

OOF2060 = new function () {
    this.grid = null;
    this.IsSearch = false;
    this.ChooseEmployee_Click = function (apk) {
        url = '/PopupLayout/Index/HRM/OOF2061?key=APK&Table=OOT2060&PK=' + apk;
        ASOFT.asoftPopup.showIframe(url, {});
    }

    this.Method_Click = function (apk, type) {
        var url = null;
        switch (type) {
            case 'DXDC':
                url = '/PopupMasterDetail/Index/HRM/OOF2071?APK=' + apk;
                break;
            case 'DXP':
                url = '/PopupMasterDetail/Index/HRM/OOF2011?APK=' + apk;
                break;
            case 'DXRN':
                url = '/PopupMasterDetail/Index/HRM/OOF2021?APK=' + apk;
                break;
            case 'DXLTG':
                url = '/PopupMasterDetail/Index/HRM/OOF2031?APK=' + apk;
                break;
            case 'DXBSQT':
                url = '/PopupMasterDetail/Index/HRM/OOF2041?APK=' + apk;
                break;
            default:
                ASOFT.form.displayMessageBox('#FormFilter',[ASOFT.helper.getMessage('OOFML000023')], null);
                break;
        }
       
        ASOFT.asoftPopup.showIframe(url, {});
    }

    // chức năng in & xuất
    var isPrint = false;
    this.doPrintOrExport = function (ischecked) {
        var args = [];
        var grid = $('#GridOOT2060').data('kendoGrid');
        var data = null;

        var dataFormFilter = sessionStorage.getItem('dataFormFilter_OOF2060');
        var dataFormFilters = JSON.parse(dataFormFilter);
        if (OOF2060.isSearch) {
            data = dataFormFilters;
        } else {
            data = ASOFT.helper.dataFormToJSON("FormFilter");
        }
        data.IsSearch = OOF2060.isSearch;
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
        data.ReportID = 'OOF2060Report';
        isPrint = ischecked;
        data.APKList = args.join("','");
        data.IsApproved_OOF2060 = data.IsApproved_OOF2060 ? data.IsApproved_OOF2060 : 0;
        var urlPost = "/HRM/OOF2060/DoPrintOrExport";
        ASOFT.helper.postTypeJson(urlPost, data, OOF2060.exportOrPrintSuccess);
    }

    this.exportOrPrintSuccess = function (result) {
        if (result) {
            var urlPrint = '/HRM/OOF2060/ReportViewer';
            var urlExcel = '/HRM/OOF2060/GetReportFile';
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

function ChangeLanguage() {
    LanguageMethodIsConfirm = $('#Execute_OOF2060').val() ? $('#Execute_OOF2060').val() : LanguageMethodIsConfirm;
   var data = LanguageMethodIsConfirm;
    return data;
}