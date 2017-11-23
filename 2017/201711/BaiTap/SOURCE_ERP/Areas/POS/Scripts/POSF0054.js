//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/04/2014      Thai Son        New
//####################################################################

var POSVIEW = POSVIEW || {};

$(document).ready(function () {
    var
        global = this,
        FORM_ID = '#FormFilter',
        FORM_NAME = 'FormFilter',
        GRID_NAME = 'GridVoucher',
        GRID_LINK_SELECTOR = '#{0} tbody tr a'.format(GRID_NAME),
        GRID_ID = '#' + GRID_NAME,
        BASE_URL = '/POS/POSF0054/',
        URL_DELETE = BASE_URL + 'Delete',
        grid = $('#GridVoucher').data('kendoGrid'),
    //URL_ENABLE = BASE_URL + 'SetEnabled',
    //URL_DISABLE = BASE_URL + 'SetDisabled',
        URL_ADD = BASE_URL + 'POSF00551',
        URL_DETAIL = BASE_URL + 'POSF0056',
    // Biến xác định trạng thái Search
        isSearch = true,
    // Grid danh mục hội viên
        grid = $(GRID_ID).data('kendoGrid'),

        elementIDs = [
            'btnFilter_',
            'btnClearFilter_',
            'btnSave',
            'btnDelete',
            'btnExport',
            'btnInActive',
            'btnActive',
            'chkAll'
        ],
        multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList'),

    // Các utility ASOFT
        showInfo = ASOFT.form.displayInfo,
        showWarning = ASOFT.form.displayWarning,
        showError = ASOFT.form.displayError,
        requestPost = ASOFT.helper.postTypeJson,
        getMessage = ASOFT.helper.getMessage,
        clearMessageBox = ASOFT.form.clearMessageBox,
        formToJSON = ASOFT.helper.dataFormToJSON,
        confirmDialog = ASOFT.dialog.confirmDialog,
        selectRecords = ASOFT.asoftGrid.selectedRecords,
        showErrorSeverOption = ASOFT.helper.showErrorSeverOption,

        btnFilter = $('#btnFillter'),
        btnClearFilter = $('#btnClearFilter')
        ;


    function initEvents() {
        grid.bind("dataBound", initAutoHideMessageBox);
        //btnFilter.on('click', btnFilter_Click);
        //btnClearFilter.on('click', btnClearFilter_Click);
    }

    //// Sự kiện click vào nút lọc dữ liệu
    //function btnFilter_Click(e) {
    //    isSearch = true;
    //    ASOFT.form.clearMessageBox();
    //    refreshGrid();
    //    return false;
    //}

    //// Sự kiện click vào nút làm lại
    //function btnClearFilter_Click(e) {
    //    ASOFT.form.clearMessageBox();
    //    resetDropDown(multiComboBox);
    //    // Reset các field còn lại
    //    $("#TranYear").val('');
    //    $("#IdentifyFilter").val('');
    //    $("#VoucherNo").val('');
    //    $("#EmployeeName").val('');
    //    $("#Description").val('');
    //    $("#ShopIDFilter").val('');

    //    isSearch = true;

    //    return false;
    //}

    function initAutoHideMessageBox() {
        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
    }

    function initGridLinkEvents() {
        $(GRID_LINK_SELECTOR).click(function (e) {
            var tr = $(e.target).closest('tr'),
                td = $(tr).find('td')[2],
                divisionID = $(td).text(),
                data = {},
                url = (URL_DETAIL + '?apk={0}').format(divisionID, e.target.text);

            if (e.ctrlKey) {
                //global.open(url, '_blank');
            }
            else if (e.altKey) {
            }
            else {
                ASOFT.asoftPopup.showIframe(url, data);
            }
        });
    }

    // Tạo dữ liệu từ form filter để post back
    function getDataFilter() {
        var from = ASOFT.helper.getFormData(null, 'FormFilter');
        var datamaster = {};
        var isCommon = $('form#FormFilter input:checkbox#IsCommonFilter').prop('checked');
        $.each(from, function () {
            if (datamaster[this.name]) {
                if (!datamaster[this.name].push) {
                    datamaster[this.name] = [datamaster[this.name]];
                }
                datamaster[this.name].push(this.value || '');
            } else {
                datamaster[this.name] = this.value || '';
            }
        });
        datamaster['IsSearch'] = isSearch;
        return datamaster;
    }


    // Xử lý kết quả từ server trả về sau khi xóa thành công
    // Tạm thời chỉ dựa vào độ dài của result.Message để xác định
    function deleteSuccess(result) {
        // Nếu xóa thành công
        if (result == null) {
            // Chuyển hướng hoặc refresh data
        ASOFT.form.displayInfo('#FormFilter', ASOFT.helper.getMessage('00ML000057'));
        }
        else {
            if (result.Params) {
                var msg = ASOFT.helper.getMessage(result.MessageID);
                msg = kendo.format(msg, result.Data.Period);
                ASOFT.form.displayWarning('#FormFilter', msg);
                grid.dataSource.page(1);
            }
        }
        if (grid) {
            grid.dataSource.page(1); // Refresh grid 
        }
    }


    function refreshGrid() {
        grid.dataSource.fetch();
    }

    // Xử lý khi click nút Xóa
    function btnDelete_Click() {
        var args = [];
        var data = {};
        ASOFT.form.clearMessageBox();
        if (grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(grid);
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].APK);
            }
        }
            //Delete 
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                data['apk'] = args;
                urlDelete = URL_DELETE;
                ASOFT.helper.postTypeJson(
                            urlDelete,
                            data,
                            deleteSuccess);
            });
       
    }

    // Xử lý khi click nút Add (thêm)
    function btnAdd_Click() {
        formMode = 0; //
        data = {};
        //alert('Hello');
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(URL_ADD, data);
        return false;
    }

    // Xử lý khi click nút Disable
    function btnDisable_Click() {
        var args = [];
        var data = {};

        if (POSF0011Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(POSF0011Grid);
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].MemberID);
            }
        }
        data['args'] = args;
        postTypeJson('/POS/POSF0011/SetDisabled', data, function (result) {
            showErrorSeverOption(1, result, FORM_NAME);
            thisParent.refreshGrid(); // Refresh grid 
        });
    }

    // Xử lý khi click nút Enable
    function btnEnable_Click() {
        var args = [];
        var data = {};

        if (POSF0011Grid) { // Lấy danh sách các dòng đánh dấu
            var records = selectRecords(POSF0011Grid);
            // Nếu không có dòng nào được chọn
            if (records.length == 0) {
                return;
            }
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].MemberID);
            }
        }
        data['args'] = args;
        postTypeJson('/POS/POSF0011/SetEnabled', data, function (result) {
            showErrorSeverOption(1, result, FORM_NAME);
            thisParent.refreshGrid(); // Refresh grid 
        });
    }


    // Sự kiện click vào nút lọc dữ liệu
    function btnFilter_Click() {
        isSearch = true;
        ASOFT.form.clearMessageBox();
        refreshGrid();
        return false;
    }

    // Sự kiện click vào nút làm lại
    function btnClearFilter_Click() {
        // Reset business combobox 
        ASOFT.form.clearMessageBox();
        resetDropDown(multiComboBox);
        // Reset các field còn lại
        $("#TranYear").val('');
        $("#VoucherNo").val('');
        $("#EmployeeName").val('');
        $("#Description").val('');
        $("#ShopIDFilter").val('');
        isSearch = true;
        return false;
    }


    function btnExport_Click() {
        isSearch = false;
        var data = {};
        var args = sendData();
        var postUrl = $("#UrlPreExportData").val();
        data['args'] = args;


        ASOFT.helper.postTypeJson(postUrl, data, preExportSuccess);
    }

    // click vào một dòng trong grid
    // e: Element 
    // divisionID: Mã đơn vị
    function memberDetail_Click(e, divisionID) {
        ASOFT.form.clearMessageBox();
        data['args'] = { "MemberID": e.text(), "DivisionID": divisionID };
        ASOFT.asoftPopup.showIframe('/POS/POSF0011/POSF00111?divisionID={0}&memberID={1}'
            .format(divisionID, $(e).text()), null);
        return false;
    }

    function preExportSuccess(data) {
        if (data) {
            var key = data.apk;
            var reportId = "POSR0002";
            var postUrl = $("#UrlExportData").val();

            var fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;
            window.location = fullPath;
        }
    }
    POSVIEW.refreshGrid = refreshGrid;
    POSVIEW.getDataFilter = getDataFilter;
    POSVIEW.btnAdd_Click = btnAdd_Click;
    POSVIEW.btnDelete_Click = btnDelete_Click;
    POSVIEW.btnFilter_Click = btnFilter_Click;
    POSVIEW.btnClearFilter_Click = btnClearFilter_Click;


    initEvents();

    $("#DivisionIDFilter").focusout(DivisionID_Focus)
});

function btnAdd_Click(e) {
    ASOFT.form.clearMessageBox();
    POSVIEW.btnAdd_Click(e);
}

function btnDelete_Click(e) {
    ASOFT.form.clearMessageBox();
    POSVIEW.btnDelete_Click(e);
}

function btnImport_Click(e) {
    var urlImport = "/Import?type=InventoryBalance";
    ASOFT.asoftPopup.showIframe(urlImport);
}

function btnFilter_Click(e) {
    console.log('btnFilter_Click');
    POSVIEW.isSearch = true;
    ASOFT.form.clearMessageBox();
    POSVIEW.btnFilter_Click(e);
}

// Sự kiện click vào nút làm lại
function btnClearFilter_Click(e) {
    ASOFT.form.clearMessageBox();
    POSVIEW.btnClearFilter_Click(e);
}

function sendDataSearch() {
    var from = ASOFT.helper.getFormData(null, 'FormFilter');
    var datamaster = {};
    var isCommon = $('form#FormFilter input:checkbox#IsCommonFilter').prop('checked');
    $.each(from, function () {
        if (datamaster[this.name]) {
            if (!datamaster[this.name].push) {
                datamaster[this.name] = [datamaster[this.name]];
            }
            datamaster[this.name].push(this.value || '');
        } else {
            datamaster[this.name] = this.value || '';
        }
    });
    datamaster['IsSearch'] = POSVIEW.isSearch || false;
    datamaster['ShopID'] = $('#ShopID').data('kendoDropDownList').value();
    datamaster['DivisionIDFilter'] = $('#DivisionIDFilter').data('kendoDropDownList').value();
    return datamaster;
}


function ShopIDMultiCheckList_Load() {
    var from = ASOFT.helper.dataFormToJSON('FormFilter');
    var datamaster = {};
    datamaster.DivisionID = from.DivisionIDFilter;
    return datamaster;
}


function DivisionID_Focus() {
    $('#ShopID').data('kendoDropDownList').dataSource.data([]);
    $('#TranYear').data('kendoComboBox').dataSource.data([]);
}