//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/05/2014      Chánh Thi     Tạo mới
//####################################################################

var posGrid = null;
var posViewModel = null;
var rowNumber = 0;

$(document).ready(function () {
    var elementIDs = [
        'POSF0027BtnFilter',
        'POSF0027BtnClearFilter',
        'btnFilter'
    ];
    initAutoClearMessageBox(elementIDs);

    posGrid = $("#POSF0027Grid").data("kendoGrid");
    //viewmode
    createViewModel();

    installPeriod(1);

    setTimeout(function () {
        if (localStorage.getItem("OpenExWare") != null) {
            $("#BtnAddNew").trigger("click");
            localStorage.removeItem("OpenExWare");
        }
    }, 200)
});

function initAutoClearMessageBox(elementIDs) {
    // Gán sự kiện cho các nút truyền vào
    if (elementIDs && typeof elementIDs == 'object') {
        elementIDs.forEach(function (id) {
            var element = $('#' + id);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                });
            }
        });
    }

    // Gán sự kiện cho các nút của thanh phân trang
    var tagAnchors = $('div[data-role="pager"] a');
    console.log(tagAnchors[0]);
    $.each(tagAnchors, function (i, anchor) {
        console.log(i + '  ' + $(anchor).attr('class'));
        $(anchor).on('click', function () {
            if ($(anchor).attr('class').indexOf('k-state-disabled') == -1) {
                ASOFT.form.clearMessageBox();
            }

        });
    });

    // Gán sự kiện cho các link trên grid
    var gridLinks = $('#POSF0027Grid.k-widget div.k-grid-content table.k-selectable tbody tr td a');

    $.each(gridLinks, function (i, link) {
        var element = $(link);
        if (element) {
            element.on('click', function () {
                ASOFT.form.clearMessageBox();
            });
        }
    });
    // Gán sự kiện cho các checkbox trên grid
    var gridCheckBoxs = $('#POSF0027Grid.k-widget div.k-grid-content table.k-selectable tbody tr td input.asoftcheckbox');
    $.each(gridCheckBoxs, function (i, checkbox) {
        var element = $(checkbox);
        if (element) {
            element.on('click', function () {
                ASOFT.form.clearMessageBox();
            });
        }
    });
}

/**
* detail popup
*/
function voucherDetail_Click(apk) {
    var url = "";
    if (apk != null) {
        url = kendo.format("/POS/POSF0027/POSF0028/{0}", apk);
    }
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
    return false;
}

/**
* add detail popup
*/
//function addVoucher_Click(apk) {
//    var url = "/POS/POSF0021/POSF0022";
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe(url, {});
//    //location.reload();
//}


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
        status: null,
        defaultFromDate: $("#FromDateFilter").data("kendoDatePicker").value(),
        defaultToDate: $("#ToDateFilter").data("kendoDatePicker").value(),
        fromPeriodFilter: $("#FromPeriodFilter").data("kendoDropDownList").value(),
        //toPeriodFilter: $("#ToPeriodFilter").data("kendoComboBox").value(),
        search: function (e) {
            ASOFT.form.clearMessageBox();
            posGrid.dataSource.page(0);
            //location.reload();
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
            this.set('DivisionIDFilter', '');
            //this.set('ShopIDFilter', '');
            //this.set('VoucherNoFilter', '');
            //this.set('VoucherDateFilter', '');
            //this.set('EmployeeIDFilter', '');
            //this.set('EmployeeNameFilter', '');
            $('#ShopIDFilter').val('');
            $('#VoucherNoFilter').val('');
            $('#VoucherDateFilter').val('');
            $('#WarehouseIDFilter').val('');
            $('#EmployeeIDFilter').val('');
            $('#EmployeeNameFilter').val('');

            var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
            resetDropDown(multiComboBox);
            resetDropDown($('#Status').data('kendoComboBox'));

            //resetComboBox(multiComboBox2);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
            //this.isSearch = false;
            ASOFT.form.clearMessageBox(); // dùng clear Message Box
            //posGrid.dataSource.page(0);
            //location.reload();
        },
        //Xóa trên dòng
    });
    kendo.bind($("#FormFilter"), posViewModel);
}

/**
* Đóng popup
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}

/**
* Refresh grid
*/
function refreshGrid(event) {
    posGrid.dataSource.page(0);
}

/**
* delete many apk
*/
//function btnDelete_Click(e) {
//    posViewModel.deleteMany(e);
//    return false;
//}

function btnFilter_Click() {
    posViewModel.search(this);
}

// Xử lý sự kiện click nút reset
function btnReset_Click() {
    posViewModel.reset(this);
}

function btnAdd_Click() {
    var url = "/POS/POSF0027/POSF00282";

    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(url, {});
}

function btnDelete_Click() {
    var args = [];
    ASOFT.form.clearMessageBox();
    var records = ASOFT.asoftGrid.selectedRecords(posGrid);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {
        args.push(records[i]["APK"]);
    }

    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
        ASOFT.helper.postTypeJson("/POS/POSF0027/Delete", args, deleteSuccess);
    });
}

function deleteSuccess(result) {
    ASOFT.helper.showErrorSeverOption(1, result, "FormFilter", function () {

    }, null, null, true, false, "FormFilter");
    if (posGrid) {
        posGrid.dataSource.page(1); // Refresh grid 
    }
}

/**
* Đóng popup
*/
function popupClose(event) {
    ASOFT.asoftPopup.hideIframe();
}