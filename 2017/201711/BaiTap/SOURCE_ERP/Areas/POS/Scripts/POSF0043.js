//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/07/2013      Thai Son        Tạo mới
//####################################################################

var POSF0043View = function () {
    //if (arguments.callee._singletonInstance)
    //    return arguments.callee._singletonInstance;
    //arguments.callee._singletonInstance = this;

    var thisParent = this;

    var FORM_ID = '#FormFilter';
    var FORM_NAME = 'FormFilter';

    var GRID_LINK_SELECTOR = '.asf-grid-link';

    var GRID_NAME = 'POSF0043Grid';
    var GRID_ID = '#POSF0043Grid';

    var URL_DELETE = '/POS/POSF0043/Delete';
    var URL_ENABLE = '/POS/POSF0043/SetEnabled';
    var URL_DISABLE = '/POS/POSF0043/SetDisabled';

    // Biến xác định trạng thái Search
    var isSearch = true;
    // Grid danh mục hội viên
    var POSF0043Grid = $(GRID_ID).data('kendoGrid');

    var elementIDs = [
    'POSF0043BtnFilter',
    'POSF0043BtnClearFilter',
    'btnSave',
    'btnDelete',
    'btnExport',
    'btnInActive',
    'btnActive',
    'chkAll',
    'btnFilter'
    ];

    var initEvents = function () {
        POSF0043Grid.bind("dataBound", initGridLinkEvent);
    }

    // Tạo dữ liệu từ form filter để post back
    this.sendData = function () {
        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
        datamaster['IsSearch'] = isSearch;
        return datamaster;
    }


    // Xử lý kết quả từ server trả về sau khi xóa thành công
    // Tạm thời chỉ dựa vào độ dài của result.Message để xác định
    function deleteSuccess(result) {
        // Nếu xóa thành công
        if (result.Status == 0) {
            // Thông báo msg: 'Xóa thành công.'
            //ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("00ML0000530").format(result.Data.join(', ')));
            ASOFT.form.clearMessageBox();
            ASOFT.form.displayInfo('#' + FORM_ID, ASOFT.helper.getMessage(result.MessageID));
            refreshGrid(); // Refresh grid 

        }
        else {
            if (POSF0043Grid) {
                POSF0043Grid.dataSource.read();
            }
            ASOFT.form.clearMessageBox();
            ASOFT.form.displayWarning('#' + FORM_ID, ASOFT.helper.getMessage(result.MessageID).format(result.Params));
        }
        refreshGrid(); // Refresh grid 
    }

    function initGridLinkEvent() {
        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
        $(GRID_LINK_SELECTOR).click(function (e) {
            var tr = $(e.target).closest('tr');
            var td = $(tr).find('td')[2];
            var divisionID = $(td).text();
            var data = {};
            var url = '/POS/POSF0043/POSF0044?divisionID={0}&typeNo={1}'
                    .format(divisionID, e.target.text);

            data['args'] = { "TypeNo": e.target.text, "DivisionID": divisionID };

            if (e.ctrlKey) {
                console.log('Ctrl+Click');
                window.open(url, '_blank');
            }
            else if (e.altKey) {
                console.log('Alt+Click');
            }
            else {
                ASOFT.asoftPopup.showIframe(url, data);
            }
        });
    }

    this.refreshGrid = function () {
        POSF0043Grid.dataSource.fetch();
    }

    // Xử lý khi click nút Xóa
    this.btnDelete_Click = function () {
        var args = [];
        var data = {};

        if (POSF0043Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(POSF0043Grid);
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].TypeNo);
            }
        }


        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            var datamaster = ASOFT.helper.dataFormToJSON(FORM_NAME);
            data['DivisionIDFilter'] = datamaster.DivisionIDFilter;
            data['args'] = args;

            //Delete 
            ASOFT.helper.postTypeJson(URL_DELETE, data, function (result) {
                ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME,
                    thisParent.refreshGrid,
                    thisParent.refreshGrid,
                    thisParent.refreshGrid, true);
            });
        });
    }

    // Xử lý khi click nút Add (thêm)
    this.btnAdd_Click = function () {
        formMode = 0; //
        data = {};
        ASOFT.asoftPopup.showIframe('/POS/POSF0043/POSF0044', data);
        // Thêm popup frame vào stack để đóng lại khi ấn esc
        //iFramePopup = ASOFT.asoftPopup.castName("PopupIframe");
        //frameStack.push(iFramePopup);
        return false;
    }

    // Xử lý khi click nút Disable
    this.btnDisable_Click = function () {
        var args = [];
        var data = {};

        if (POSF0043Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(POSF0043Grid);
            if (records.length == 0) return;
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].TypeNo);
            }
        }
        data['args'] = args;
        ASOFT.helper.postTypeJson('/POS/POSF0043/SetDisabled', data, function (result) {
            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME);
            thisParent.refreshGrid(); // Refresh grid 
        });
    }

    // Xử lý khi click nút Enable
    this.btnEnable_Click = function () {
        var args = [];
        var data = {};

        if (POSF0043Grid) { // Lấy danh sách các dòng đánh dấu
            var records = ASOFT.asoftGrid.selectedRecords(POSF0043Grid);
            // Nếu không có dòng nào được chọn
            if (records.length == 0) {
                return;
            }
            for (var i = 0; i < records.length; i++) {
                args.push(records[i].TypeNo);
            }
        }
        data['args'] = args;
        ASOFT.helper.postTypeJson('/POS/POSF0043/SetEnabled', data, function (result) {
            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME);
            thisParent.refreshGrid(); // Refresh grid 
        });
    }


    // Sự kiện click vào nút lọc dữ liệu
    this.POSF0043BtnFilter_Click = function () {
        isSearch = true;
        refreshGrid();
        console.log('POSF0043BtnFilterClick');
        return false;
    }

    // Sự kiện click vào nút làm lại
    this.POSF0043BtnClearFilter_Click = function () {
        // Reset business combobox
        var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
        resetDropDown(multiComboBox);
        // Reset các field còn lại
        $("#MemberIDFilter").val('');
        $("#MemberNameFilter").val('');
        $("#AddressFilter").val('');
        $("#IdentifyFilter").val('');
        $("#PhoneFilter").val('');
        $("#TelFilter").val('');
        $("#FaxFilter").val('');
        $("#EmailFilter").val('');
        $("#ShopIDFilter").val('');

        isSearch = true;

        console.log('POSF0043Btn Clear FilterClick');

        return false;
    }


    this.btnExport_Click = function () {
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
    this.memberDetail_Click = function (e, divisionID) {
        data['args'] = { "TypeNo": e.text(), "DivisionID": divisionID };
        ASOFT.asoftPopup.showIframe('/POS/POSF0043/POSF0044?divisionID={0}&typeNo={1}'
            .format(divisionID, $(e).text()), null);
        return false;
    }

    this.btnPrint_Click = function () {
        var datamaster = this.sendData();
        ASOFT.helper.postTypeJson("/POS/POSF0043/DoPrintOrExport", datamaster, this.ExportSuccess);
    }

    this.ExportSuccess = function (result) {
        if (result) {
            var urlPrint = '/POS/POSF0043/ReportViewer';
            var options = '&viewer=pdf';
            // Tạo path full
            var fullPath = urlPrint + "?id=" + result.apk + options;

            // Getfile hay in báo cáo
            window.open(fullPath, "_blank");
        }
    }

    var preExportSuccess = function (data) {
        if (data) {
            var key = data.apk;
            var reportId = "POSR0002";
            var postUrl = $("#UrlExportData").val();

            var fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;
            window.location = fullPath;
        }
    }

    ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
    initEvents();
}

function btnDelete_Click() {
    view.btnDelete_Click()
}
function btnAdd_Click() { view.btnAdd_Click() }
function btnDisable_Click() { view.btnDisable_Click() }
function btnEnable_Click() { view.btnEnable_Click() }
function POSF0043BtnFilterClick() { view.POSF0043BtnFilter_Click() }
function POSF0043BtnClearFilterClick() { view.POSF0043BtnClearFilter_Click() }
function btnExport_Click() { view.btnExport_Click() }
function memberDetail_Click(e, divisionID) { view.memberDetail_Click(e, divisionID) }

function sendData() {
    return new POSF0043View().sendData();
}
function refreshGrid() {
    view.refreshGrid();
}

var view;
$(document).ready(function () {
    view = new POSF0043View();   
});


