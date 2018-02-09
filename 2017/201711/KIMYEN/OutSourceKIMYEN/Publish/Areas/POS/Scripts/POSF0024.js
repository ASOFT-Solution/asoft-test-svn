//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     08/05/2014     Đam Mơ        Tạo mới
//####################################################################

var posGrid = null;
var posViewModel = null;
var rowNumber = 0;


$(document).ready(function () {
    posGrid = $("#POSF0024Grid").data("kendoGrid");

    createViewModel();
    installPeriod();

    if (ASOFTEnvironment.IsADivision) {
        if ($("#FormFilter").length > 0) {
            if ($("#DivisionIDFilter").length > 0) {
                $("#DivisionIDFilter").parent().parent().parent().remove();
            }

            $("#ShopIDFilter").parent().parent().find("td").attr("colspan", "1");
            $("#ShopIDFilter").parent().attr("colspan", "4");
            $(".alpha tbody").append($("#ShopIDFilter").parent().parent());
        }
    }
});

/**
* Refresh grid
*/
function refreshGrid(event) {
    posViewModel.search();
}
/**
* Send data to with grid
*/
function sendDataFilter() {
    if (posViewModel != null) {
        return posViewModel.dataFilter();
    }
    return null;
}

function voucherDetail_Click(apk) {
    var url = ''; // Chuỗi đường dẫn.
    // If APK exist
    if (apk != null) {
        url = kendo.format('/POS/POSF0024/POSF0025/{0}', apk);
    }
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
    return false;
}

function btnDelete_Click(e) {
    //posViewModel.deleteMany(e);
    return false;
}

function createViewModel() {
    posViewModel = kendo.observable({
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
        search: function (e) {
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
            this.set('FromDateFilter', this.defaultFromDate);
            this.set('ToDateFilter', this.defaultToDate);
            this.set('FromPeriodFilter', this.fromPeriodFilter);
            this.set('ToPeriodFilter', this.toPeriodFilter);
            this.set('VoucherNoFilter', '');
            this.set('ShopIDFilter', '');
            this.set('DivisionIDFilter', '');
            this.set('EmployeeIDFilter', '');
            this.set('EmployeeIDFilter', '');
            this.set('EmployeeNameFilter', '');

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
                ASOFT.helper.postTypeJson('/POS/POSF0024/DeleteMany', data, function (result) {
                    if (result && result.Status == 0) { // Can not delete data
                        if (result.Message) { // Message isn't null
                            ASOFT.form.displayInfo('#FormFilter', ASOFT.helper.getMessage(result.Message));
                        }
                    } else {
                        //TODO: delete sussess
                        var errors = result.Data;
                        var msgs = [];
                        for (var j = 0; j < errors.length; j++) {
                            var error = errors[j];
                            var msg = ASOFT.helper.getMessage(result.Message);
                            if (error.Param) { // Nếu có param trong errors
                                msg = kendo.format(msg, error.Param);
                            }
                            msgs.push(msg);
                        }
                        //show message
                        if (msgs.length > 0) {
                            ASOFT.form.displayWarning('#FormFilter', msgs);
                        }
                    }
                    that.search();
                });
            });
        }

    });
    kendo.bind($("#FormFilter"), posViewModel);
}

function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

