//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################
//Grid
var posGrid = null;
//MVVM for kendo
var posViewModel = null;
//rownumber
var rowNumber = 0;
//ID for jquery sector
var GRID_ID = 'POSF0015Grid';
var FORM_ID = 'FormFilter';
var SCREEN_ID = 'POSF0015';

/**
* Sự kiện load
*/
$(document).ready(function () {
    posGrid = $(sectorEl(GRID_ID)).data('kendoGrid');
    //viewmode
    createViewModel();
    //install period
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
        fromMonth: null,
        fromYear: null,
        toMonth: null,
        toYear: null,
        isDate: true,
        isSearch: false,
        defaultFromDate: $('#FromDateFilter').data('kendoDatePicker').value(),
        defaultToDate: $('#ToDateFilter').data('kendoDatePicker').value(),
        fromPeriodFilter: $("#FromPeriodFilter").data("kendoDropDownList").value(),
        //toPeriodFilter: $('#ToPeriodFilter').data('kendoComboBox').value(),
        search: function (e) {
            posGrid.dataSource.page(0);
        },
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON(FORM_ID);

            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        reset: function (e) {
            //Close div message if have
            ASOFT.form.clearMessageBox(FORM_ID);
            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            this.set('ToPeriodFilter', this.toPeriodFilter);
            this.set('DivisionIDFilter', '');
            this.set('ShopIDFilter', '');
            this.set('VoucherNoFilter', '');
            this.set('RefVoucherNoFilter', '');
            this.set('ReceiverIDFilter', '');
            this.set('ReceiverNameFilter', '');
            this.set('SenderNameFilter', '');
            this.set('DescriptionFilter', '');
            this.set('StatusFilter', -1);

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            //search
            //posGrid.dataSource.page(0);
        },
        //Xóa trên lưới
        deleteMany: function (e) {
            var args = [];
            var data = {};
            var records = ASOFT.asoftGrid.selectedRecords(posGrid);
            if (records.length == 0) {
                return false;
            };

            //confirm
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
                data['args'] = args;
                //Delete Json
                var url = getAbsoluteUrl('POSF0015/DeleteMany');
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    ASOFT.helper.showErrorSeverOption(1, result, FORM_ID, function () {
                        posGrid.dataSource.page(0);
                    }, null, null, true);
                });
            });

            return false;
        }
    });
    kendo.bind($(sectorEl(FORM_ID)), posViewModel);
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

/**
* Refresh grid
*/
function refreshGrid(event) {
    posViewModel.search();
}

/******************************************************************************
                            EVENTS
*******************************************************************************/
/**
* add detail popup
*/
function addVoucher_Click(apk) {
    ASOFT.form.clearMessageBox(FORM_ID);
    var url = getAbsoluteUrl('POSF0015/POSF00151');
    ASOFT.asoftPopup.showIframe(url, {});
}

/**
* detail popup
*/
function voucherDetail_Click(apk) {
    var url = '';
    if (apk != null) {
        ASOFT.form.clearMessageBox(FORM_ID);
        var action = kendo.format('POSF0015/POSF00151/?apk={0}', apk);
        url = getAbsoluteUrl(action);
        ASOFT.asoftPopup.showIframe(url, {});
    }

    return false;
}

/**
* Đóng popup
*/
function popup_Close(event) {
    ASOFT.asoftPopup.hideIframe();
}

/**
* delete many apk
*/
function btnDelete_Click(e) {
    ASOFT.form.clearMessageBox(FORM_ID);
    posViewModel.deleteMany(e);
    return false;
}

/**
* Search
*/
function btnSearch_Click(e) {
    ASOFT.form.clearMessageBox(FORM_ID);
    posViewModel.search();
    return false;
}