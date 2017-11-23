//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/04/2014      Minh Lâm         Tạo mới
//####################################################################
//Grid
var posGrid = null;
//MVVM object
var posViewModel = null;
//Row number of grid
var rowNumber = 0;
//Empty GUID
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
//IFrame fullscreen
var ifFrameID = 'externalIframe';
var pVoucherNo = null;
var cVoucherNo = null;

/**
* After load HTML
*/
$(document).ready(function () {
    posGrid = $("#POSF0016Grid").data("kendoGrid");

    //pVoucherNo = posGrid.PVoucherNo;
    //cVoucherNo = postGrid.CVoucherNo;
    //viewmode
    createViewModel();
    //Insall Period control
    installPeriod();
});

/******************************************************************************
                            ViewModel
*******************************************************************************/

/**
* Tạo viewmodel
*/
function createViewModel() {

    posViewModel = kendo.observable({
        url: getAbsoluteUrl("POSF0016/POSF00161"),
        fromMonth: null,
        fromYear: null,
        toMonth: null,
        toYear: null,
        isDate: true,
        isSearch: false,
        defaultFromDate: $("#FromDateFilter").data("kendoDatePicker").value(),
        defaultToDate: $("#ToDateFilter").data("kendoDatePicker").value(),
        fromPeriodFilter: $("#FromPeriodFilter").data("kendoDropDownList").value(),
        //toPeriodFilter: $("#ToPeriodFilter").data("kendoComboBox").value(),
        pVoucherType: $("#PVoucherType").val(),
        cVoucherType: $("#CVoucherType").val(),
        /**
        * add/ edit POSF00161
        */
        add: function (e, APK) {
            //show iframe for full screen
            var ifFrameSector = $(kendo.format("#{0}", ifFrameID));
            if (navigator.appName == 'Microsoft Internet Explorer') {
                window.open(url, "secondWindow",
                    "fullscreen,scrollbars='yes',statusbar='yes',location='no'").focus();

            } else //if (screenfull.enabled) 
            {
                document.addEventListener(screenfull.raw.fullscreenchange, function () {
                    if (!screenfull.isFullscreen) {
                        ifFrameSector.hide();
                        ifFrameSector.attr('src', '');
                    }
                });
                if (APK != undefined) { // && $.isPlainObject(APK)
                    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK,0));
                } else {
                    ifFrameSector.attr('src', kendo.format("{0}?status={1}", this.url, 0));
                }
                //if (APK != undefined && status == 1) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                //if (APK != undefined && status == 2) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                $("#Header").css("z-index", "0");
                ifFrameSector.show();
                //screenfull.request(document.getElementById(ifFrameID));
            }
            return false;
        },
        editStatus1: function (e, APK) {
            //show iframe for full screen
            var ifFrameSector = $(kendo.format("#{0}", ifFrameID));//$.browser.msie
            //if (navigator.appName) {
            //    window.open(url, "secondWindow",
            //        "fullscreen,scrollbars='yes',statusbar='yes',location='no'").focus();

            //} else //if (screenfull.enabled) 
            //    {
                document.addEventListener(screenfull.raw.fullscreenchange, function () {
                    if (!screenfull.isFullscreen) {
                        ifFrameSector.hide();
                        ifFrameSector.attr('src', '');
                    }
                });
                if (APK != undefined) { // && $.isPlainObject(APK)
                    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                } else {
                    ifFrameSector.attr('src', kendo.format("{0}?status={1}", this.url, 1));
                }
                //if (APK != undefined && status == 1) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                //if (APK != undefined && status == 2) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                $("#Header").css("z-index", "0");
                ifFrameSector.show();
                //screenfull.request(document.getElementById(ifFrameID));
            //}
            return false;
        },
        editStatus2: function (e, APK) {
            //show iframe for full screen
            var ifFrameSector = $(kendo.format("#{0}", ifFrameID));//$.browser.msie
            //if (navigator.appName) {
            //    window.open(url, "secondWindow",
            //        "fullscreen,scrollbars='yes',statusbar='yes',location='no'").focus();

            //} else //if (screenfull.enabled) 
            //{
                document.addEventListener(screenfull.raw.fullscreenchange, function () {
                    if (!screenfull.isFullscreen) {
                        ifFrameSector.hide();
                        ifFrameSector.attr('src', '');
                    }
                });
                if (APK != undefined) { // && $.isPlainObject(APK)
                    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 2));
                } else {
                    ifFrameSector.attr('src', kendo.format("{0}?status={1}", this.url, 2));
                }
                //if (APK != undefined && status == 1) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                //if (APK != undefined && status == 2) {
                //    ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", this.url, APK, 1));
                //}
                $("#Header").css("z-index", "0");
                ifFrameSector.show();
                //screenfull.request(document.getElementById(ifFrameID));
            //}
            return false;
        },
        /**
        * Search
        */
        search: function (e) {
            $("#FormFilter .asf-message").remove();
            posGrid.dataSource.page(0);
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON("FormFilter");
            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        reset: function (e) {
            ASOFT.form.clearMessageBox('FormFilter');
            
            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            //this.set('ToPeriodFilter', this.toPeriodFilter);
            this.set('DivisionIDFilter', '');
            this.set('ShopIDFilter', '');
            this.set('VoucherTypeIDFilter', '');
            this.set('VoucherNoFilter', '');
            this.set('MemberIDFilter', '');
            this.set('MemberNameFilter', '');
            this.set('CurrencyNameFilter', '');
            this.set('PaymentNameFilter', '');
            this.set('IMEI1Filter', '');
            this.set('IMEI2Filter', '');

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            //this.isSearch = false;
            //posGrid.dataSource.page(0);
        },
        //Xóa trên dòng
        deleteMany: function (e) {
            var that = this;
            var args = [];
            var data = {};
            var records = ASOFT.asoftGrid.selectedRecords(posGrid);
            if (records.length == 0) {
                return false;
            };
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
                data['args'] = args;
                var url = getAbsoluteUrl("POSF0016/DeleteMany");
                //Delete Json
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    ASOFT.helper.showErrorSeverOption(1, result, "FormFilter", function () {
                        posGrid.dataSource.page(0);
                    }, null, null, true);
                });
            });
        }
    });
    kendo.bind($("#FormFilter"), posViewModel);
}

/******************************************************************************
                            Function
*******************************************************************************/
/**
* Send data to with grid
*/
function sendDataFilter() {
    if (posViewModel != null) {
        return posViewModel.dataFilter();
    }
    return null;
}

/******************************************************************************
                            EVENTS
*******************************************************************************/

/**
* detail popup
*/
function detail_Click(e,apk,eVoucherNo,pVoucherNo,cVoucherNo) {
    if (posViewModel != null && eVoucherNo == 'null') {
        return posViewModel.add(e, apk);
    }
    if (posViewModel != null && eVoucherNo != 'null' && pVoucherNo != 'null' && cVoucherNo == 'null') {
        return posViewModel.editStatus1(e, apk);
    }
    if (posViewModel != null && eVoucherNo != 'null' && pVoucherNo == 'null' && cVoucherNo != 'null') {
        return posViewModel.editStatus2(e, apk);
    }

    return false;
}

/**
* add detail popup
*/
function btnAdd_Click(e) {
    if (posViewModel != null) {
        return posViewModel.add(e);
    }
}


/**
* close popup
*/
function detailPopup_Close(event) {
    var iframe = parent.document.getElementById("externalIframe");
    parent.screenfull.exit();
    $(iframe).hide();
    iframe.src = "";
    ASOFT.asoftPopup.closeOnly();
}

/**
* Refresh grid
*/
function refreshGrid(event) {
    posViewModel.search();
}

/**
* delete many apk
*/
function btnDelete_Click(e) {
    posViewModel.deleteMany(e);
    return false;
}


function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}

function ExportClick() {
    var records = ASOFT.asoftGrid.selectedRecords(posGrid, 'FormFilter');
    if (records.length == 0) return;

    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");

    var URLDoPrintorExport = '/POS/POSF0016/DoPrintOrExportPOSR0016';
    var apkList = "";

    if (!$("#chkAll").is(':checked')) {
        for (var i = 0; i < records.length - 1; i++) {
            apkList += records[i].APK + ",";
        }
    }

    apkList += records[records.length - 1].APK;

    datamaster.APKList = $("#chkAll").is(':checked') ? null : apkList;
    datamaster.IsCheckAll = $("#chkAll").is(':checked') ? 1 : 0;

    ASOFT.helper.postTypeJson(URLDoPrintorExport, datamaster, ExportSuccessPrint);
}

function ExportSuccessPrint(result) {
    if (result) {
        var urlExcel = '/POS/POSF0016/ExportReportPOSR0016';
        // Tạo path full
        var fullPath = urlExcel + "?id=" + result.apk;

        window.location = fullPath;
    }
}