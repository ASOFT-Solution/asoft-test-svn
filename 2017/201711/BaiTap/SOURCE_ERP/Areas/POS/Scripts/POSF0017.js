//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Thai Son        Tạo mới
//####################################################################

// Lưới hiển thị danh sách phiếu kiểm kê
var posGrid = null;

// kendo ViewModel cho màn hình phiếu kiểm kê
var posViewModel = null;

// Số thứ tự của dòng
var rowNumber = 0;

// Tên form filter
var FORM_NAME = 'FormFilter';

// CSS ID của form filter
var FORM_ID = '#FormFilter';

var CONST = {
    GRID_NAME: 'POSF0017Grid',
    GRID_ID: '#POSF0017Grid'
};

// Xử lý ban đầu
$(document).ready(function () {
    var elementIDs = [
'POSF0017BtnFilter',
        'POSF0017BtnClearFilter',
        'btnSave',
        'btnDelete',
        'btnExport',
        'btnInActive',
        'btnActive',
        'chkAll',
        'btnFilter'
    ];
    posGrid = $(CONST.GRID_ID).data('kendoGrid');
    ASOFT.helper.initAutoClearMessageBox(elementIDs, CONST.GRID_ID);
    //initAutoClearMessageBox(elementIDs)

    posGrid.bind('dataBound', function (e) {
        ASOFT.helper.initAutoClearMessageBox(elementIDs, CONST.GRID_ID);
        //initAutoClearMessageBox(elementIDs)
    });
    //viewmode
    createViewModel();
    //posGrid.dataSource.page(0);
    installPeriod(true);

    //
    //var height = $('div#FilterArea div.grid_4').first().height();
    //$('div#FilterArea div.grid_4').css('height', height + 'px');
});

function initAutoClearMessageBox(elementIDs) {
    $(CONST.GRID_ID).data('kendoGrid').bind('dataBound', function (e) {
        // Gán sự kiện cho các nút truyền vào
        if (elementIDs && typeof elementIDs == 'object') {
            elementIDs.forEach(function (id) {
                var element = $('#' + id);
                if (element) {
                    element.on('click', function () {
                        ASOFT.form.clearMessageBox();
                        ASOFT.asoftGrid.setHeight($(CONST.GRID_ID).data('kendoGrid'));
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
                    ASOFT.asoftGrid.setHeight($(CONST.GRID_ID).data('kendoGrid'));
                }

            });
        });

        // Gán sự kiện cho các link trên grid
        //var gridLinks = $(CONST.GRID_ID + '.k-widget div.k-grid-content table.k-selectable tbody a');
        var gridLinks = $('#POSF0017Grid.k-widget div.k-grid-content table.k-selectable tbody tr td a');
        $.each(gridLinks, function (i, link) {
            var element = $(link);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftGrid.setHeight($(CONST.GRID_ID).data('kendoGrid'));
                });
            }
        });
        // Gán sự kiện cho các checkbox trên grid
        //var gridCheckBoxs = $(CONST.GRID_ID + '.k-widget div.k-grid-content table.k-selectable tbody tr td input.asoftcheckbox');
        var gridCheckBoxs = $('#POSF0017Grid.k-widget div.k-grid-content table.k-selectable tbody tr td input.asoftcheckbox');
        $.each(gridCheckBoxs, function (i, checkbox) {
            var element = $(checkbox);
            if (element) {
                element.on('click', function () {
                    ASOFT.form.clearMessageBox();
                    ASOFT.asoftGrid.setHeight($(CONST.GRID_ID).data('kendoGrid'));
                });
            }
        });
    });
}


/**
* detail popup
*/
function voucherDetail_Click(e) {
    var url = '';
    // Nếu đối tượng hợp lệ
    if (e) {
        url = kendo.format('/POS/POSF0017/POSF00171/{0}', $(e).data('apk'));
    }

    ASOFT.asoftPopup.showIframe(url, {});
    return false;
}

/**
* add detail popup
*/
function addVoucher_Click(apk) {
    var url = '/POS/POSF0017/POSF00171';
    ASOFT.asoftPopup.showIframe(url, {});
}

/**
* Send data to with grid
*/
function sendDataFilter() {
    // Nếu view model hợp lệ
    if (posViewModel) {
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
        defaultFromDate: $('#FromDateFilter').data('kendoDatePicker').value(),
        defaultToDate: $('#ToDateFilter')
            .data('kendoDatePicker').value(),
        fromPeriodFilter: $('#FromPeriodFilter')
            .data('kendoDropDownList').value(),
        //toPeriodFilter: $('#ToPeriodFilter').data('kendoComboBox').value(),

        // Lọc danh sách phiếu
        search: function (e) {
            posGrid.dataSource.page(0);
        },
        // Tạo dữ liệu filter
        dataFilter: function (e) {
            var dataFilter = ASOFT.helper.dataFormToJSON('FormFilter');
            dataFilter.fromMonth = this.fromMonth;
            dataFilter.fromYear = this.fromYear;
            dataFilter.toMonth = this.toMonth;
            dataFilter.toYear = this.toYear;

            return dataFilter;
        },
        // Reset form filter
        reset: function (e) {
            $('#FromDateFilter').data('kendoDatePicker').value(this.defaultFromDate);
            $('#ToDateFilter').data('kendoDatePicker').value(this.defaultToDate);

            $('#ShopIDFilter').val('');
            $('#VoucherNoFilter').val('');
            $('#EmployeeNameFilter').val('');
            $('#DescriptionFilter').val('');

            //$('#FromPeriodFilter').data('kendoComboBox').value('');
            //$('#ToPeriodFilter').data('kendoComboBox').value('');

            var multiComboBox = $('#DivisionIDFilter')
                .data('kendoDropDownList');
            resetDropDown(multiComboBox);

            this.fromMonth = null;
            this.fromYear = null;
            this.toMonth = null;
            this.toYear = null;

            resetPeriod();
        },
        // Xóa (các) dòng trên lưới
        deleteMany: function (e) {
            var that = this;
            var args = [];
            var data = {};
            var records = ASOFT.asoftGrid.selectedRecords(posGrid);

            // Nếu không có dòng nào được chọn, thì thoát
            if (records.length == 0) {
                return false;
            };
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                // nếu đối tượng lưới hợp lệ
                if (posGrid) { // Get all row select
                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i].APK);
                    }
                }
                data['args'] = args;
                //Delete Json
                ASOFT.helper.postTypeJson(
                    '/POS/POSF0017/DeleteMany',
                    data,
                    function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, 'FormFilter', function () {
                            posGrid.dataSource.page(0);
                        }, null, null, true);
                    });
            });
        },

        // Kiểm tra tính hợp lệ của form
        //formIsInvalid: function () {
        //    var nonRequired = [
        //        'FromPeriodFilter',
        //        'ToPeriodFilter'
        //    ];
        //    var result = ASOFT.form.checkRequiredAndInList(FORM_NAME, nonRequired);
        //    return !result;
        //}
    });
    var form = $('#FormFilter');
    kendo.bind(form, posViewModel);
}

// Xử lý sự kiện click nút filter
function btnFilter_Click() {
    posViewModel.search(this);
}

// Xử lý sự kiện click nút reset
function btnReset_Click() {
    posViewModel.reset(this);
}

/**
* Đóng popup
*/
//function popupClose(event) {
//    ASOFT.asoftPopup.hideIframe();
//}

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

function ExportClick() {
    var records = ASOFT.asoftGrid.selectedRecords(posGrid, 'FormFilter');
    if (records.length == 0) return;

    var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");

    var URLDoPrintorExport = '/POS/POSF0017/DoPrintOrExport';
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
        var urlExcel = '/POS/POSF0017/ExportReport';
        // Tạo path full
        var fullPath = urlExcel + "?id=" + result.apk;

        window.location = fullPath;
    }
}