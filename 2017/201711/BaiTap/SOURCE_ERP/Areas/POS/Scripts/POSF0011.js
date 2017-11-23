//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//#     31/03/2014      Thai Son         Viết hàm xử lý filter / clear filter
//#     02/04/2014      Thai Son         Viết hàm xử lý CRUD
//#     04/04/2014      Thai Son         Edit: code cho các luồng xử lý
//#     29/09/2014      Thai Son         Edit: code tổng quát cho các màn hình danh sách
//####################################################################

var GridScreen = function () {
    var
        debug = true,

        elementIDs,

        _log = (function () {
            var _log;
            // Nếu không debug, thì hàm LOG đặt thành hàm rỗng
            if (!debug) {
                _log = function () { };
                return _log;
            }

            // Tạo hàm log thay thế cho console.log
            if (Function.prototype.bind) {
                _log = Function.prototype.bind.call(console.log, console);
            }
            else {
                _log = function () {
                    Function.prototype.apply.call(console.log, console, arguments);
                };
            }
            return _log;
        }()),

        options,

        meta = {},

        form,

        grid,

        urls = {
            'read': $('#UrlGridData').val(),
            'detail': $('#UrlDetail').val(),
            'create': $('#UrlInsert').val(),
            'update': $('#UrlUpdate').val(),
            'delete': $('#UrlDelete').val(),
            'active': $('#UrlActive').val(),
            'deactive': $('#UrlDeactive').val(),
            'export': $('#UrlExportData').val(),
            'pre-export': $('#UrlPreExportData').val(),
        },

        leftToolbar = {
            btnAddNew: {
                id: 'btnAddNew',
                jqObject: $('#btnAddNew'),
                onClick: function (e) {
                    e.preventDefault();
                    _log('btnAddNew');
                    ASOFT.asoftPopup.showIframe(urls.create, {});
                }
            },
            btnDelete: {
                id: 'btnDelete',
                jqObject: $('#btnDelete'),
                onClick: function (e) {
                    _log('btnDelete');
                    var args = [],
                        data = {},
                        records = ASOFT.asoftGrid.selectedRecords(grid),
                        i = 0, l = records.length
                    ;

                    if (records.length == 0) return;

                    for (; i < l; i += 1) {
                        args.push(records[i][options.grid.identityColumn]);
                    }

                    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
                        var datamaster = ASOFT.helper.dataFormToJSON(form.attr('id'));
                        data['DivisionIDFilter'] = datamaster.DivisionIDFilter;
                        data['args'] = args;

                        //Delete 
                        ASOFT.helper.postTypeJson(urls.delete, data, function (result) {
                            ASOFT.helper.showErrorSeverOption(
                                1,
                                result,
                                form.attr('id'),
                                refreshGrid,
                                refreshGrid,
                                refreshGrid,
                                true);
                        });
                    });
                }
            },
            btnExport: {
                id: 'btnExport',
                jqObject: $('#btnExport'),
                onClick: function (e) {
                    _log('btnExport');

                    var data = {},
                        args = formFilterData();

                    isSearch = false;
                    data['args'] = args;

                    ASOFT.helper.postTypeJson(urls['pre-export'], data, preExportSuccess);
                }
            },
            btnActive: {
                id: 'btnActive',
                jqObject: $('#btnActive'),
                onClick: function (e) {
                    _log('btnActive');
                    var args = [],
                        data = {},
                    // Lấy danh sách các dòng đánh dấu
                        records = ASOFT.asoftGrid.selectedRecords(grid);

                    if (records.length == 0) return;

                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i][options.grid.identityColumn]);
                    }

                    data['args'] = args;
                    ASOFT.helper.postTypeJson(urls.active, data, function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, form.attr('id'));
                        refreshGrid(); // Refresh grid 
                    });
                }
            },
            btnDeactive: {
                id: 'btnDeactive',
                jqObject: $('#btnDeactive'),
                onClick: function (e) {
                    _log('btnDeactive');
                    var args = [],
                        data = {},
                    // Lấy danh sách các dòng đánh dấu
                        records = ASOFT.asoftGrid.selectedRecords(grid);

                    if (records.length == 0) return;

                    for (var i = 0; i < records.length; i++) {
                        args.push(records[i][options.grid.identityColumn]);
                    }

                    data['args'] = args;
                    ASOFT.helper.postTypeJson(urls.deactive, data, function (result) {
                        ASOFT.helper.showErrorSeverOption(1, result, form.attr('id'));
                        refreshGrid(); // Refresh grid 
                    });
                }
            },
        },

        rightToolbar = {
            btnFilter: {
                id: 'btnFilter',
                jqObject: $('#btnFilter'),
                onClick: function (e) {
                    _log('btnFilter');
                    e.preventDefault();
                    isSearch = true;
                    refreshGrid();
                }
            },
            btnClearFilter: {
                id: 'btnClearFilter',
                jqObject: $('#btnClearFilter'),
                onClick: function (e) {
                    _log('btnClearFilter');
                    e.preventDefault;
                    resetNormalInputs();
                    resetDivisionDropDown();
                    resetMonthYear();
                }
            }
        },

        report = {
            id: "POSR0002"
        },

        isSearch = false
    ;

    function pad(n, width, z) {
        z = z || '0';
        n = n + '';
        return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }

    var preExportSuccess = function (data) {
        if (data) {
            var key = data.apk,
                reportId = report.id,
                postUrl = urls.export,
                fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;

            window.location = fullPath;
        }
    }

    function resetMonthYear() {

        var monthYear = '{0}/{1}'.format(pad(meta['tranMonth'], 2), meta['tranYear']),
            workingDate = new Date(meta['workingDate']),
            comboFromPeriod = $('#FromPeriodFilter').data('kendoComboBox'),
            comboToPeriod = $('#ToPeriodFilter').data('kendoComboBox'),
            fromDate = $('#FromDateFilter').data('kendoDatePicker'),
            toDate = $('#ToDateFilter').data('kendoDatePicker')
        ;

        if (!comboFromPeriod || !comboToPeriod
            || !fromDate || !toDate) {
            return;
        }


        comboFromPeriod.value(monthYear);
        comboToPeriod.value(monthYear);

        fromDate.value(workingDate);
        toDate.value(workingDate);
    }

    function resetDivisionDropDown() {
        var multiComboBox = form.find('input.asf-multiselectbox'),
            kDropDown;
        if (multiComboBox.length > 0) {
            multiComboBox.each(function () {
                kDropDown = $(this).data('kendoDropDownList');
                resetDropDown(kDropDown);
            });
        }

    }

    function resetNormalInputs() {
        form.find('input').val('')
    }

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
            if (POSF0011Grid) {
                POSF0011Grid.dataSource.read();
            }
            ASOFT.form.clearMessageBox();
            ASOFT.form.displayWarning('#' + FORM_ID, ASOFT.helper.getMessage(result.MessageID).format(result.Params));
        }
        refreshGrid(); // Refresh grid 
    }

    function formFilterData() {
        var data = ASOFT.helper.dataFormToJSON(form.attr('id'));
        data['IsSearch'] = isSearch;
        return data;
    }

    function handleForm(options) {
        var $form;
        if (!options.form.jqObject || options.form.jqObject.length === 0) {
            $form = $('#' + options.form.id);
        } else {
            $form = options.form.jqObject;
        }
        if (!$form || $form.length === 0) {
            throw "Cannot find form using id '{0}'".format(options.form.id);
        }

        form = $form;
    }

    function handleGrid(options) {
        grid = options.grid.kGrid
            || $('#' + options.grid.id).data('kendoGrid');

        if (!grid) {
            throw "Cannot find kendoGrid using id '{0}'".format(options.grid.id);
        }
    }

    function handleUrls(options) {
        options.urls = options.urls || {};
        urls = $.extend(urls, options.urls);
    }

    function handleReport(options) {
        options.report = options.report || {};
        report = $.extend(report, options.report);
    }

    function handleRightToolbar(options) {
        var
            btnFilter,
            btnClearFilter
        ;

        btnFilter = options.rightToolbar.btnFilter.jqObject
                        || $('#' + options.rightToolbar.btnFilter.id)
                        || rightToolbar.btnFilter.jqObject
                        || $('#' + rightToolbar.btnFilter.id);

        if (!btnFilter) {
            throw "Cannot find button 'filter' with id '{0}'".format(options.rightToolbar.btnFilter.id);
        }

        btnClearFilter = options.rightToolbar.btnClearFilter.jqObject
                        || $('#' + options.rightToolbar.btnClearFilter.id)
                        || rightToolbar.btnClearFilter.jqObject
                        || $('#' + rightToolbar.btnClearFilter.id);

        if (!btnClearFilter) {
            throw "Cannot find button 'clear filter' with id '{0}'".format(options.rightToolbar.btnClearFilter.id);
        }

        rightToolbar.btnFilter.jqObject = btnFilter;
        rightToolbar.btnClearFilter.jqObject = btnClearFilter;

    }

    function handleLeftToolbar(options) {
        var
            btnAddNew,
            btnDelete,
            btnExport,
            btnActive,
            btnDeactive
        ;

        btnAddNew = options.leftToolbar.btnAddNew.jqObject
                        || $('#' + options.leftToolbar.btnAddNew.id)
                        || leftToolbar.btnAddNew.jqObject
                        || $('#' + leftToolbar.btnAddNew.id);

        if (!btnAddNew || !btnAddNew.length) {
            //throw "Cannot find button 'add new' with id '{0}'".format(options.leftToolbar.btnAddNew.id);
        } else {
            leftToolbar.btnAddNew.jqObject = btnAddNew.prop('enable', btnAddNew.data('kendoButton').options.enable);

        }

        btnDelete = options.leftToolbar.btnDelete.jqObject
                        || $('#' + options.leftToolbar.btnDelete.id)
                        || leftToolbar.btnDelete.jqObject
                        || $('#' + leftToolbar.btnDelete.id);

        if (!btnDelete || !btnDelete.length) {
            //throw "Cannot find button 'delete' with id '{0}'".format(options.leftToolbar.btnDelete.id);
        } else {
            leftToolbar.btnDelete.jqObject = btnDelete.prop('enable', btnDelete.data('kendoButton').options.enable);

        }

        btnExport = options.leftToolbar.btnExport.jqObject
                        || $('#' + options.leftToolbar.btnExport.id)
                        || leftToolbar.btnExport.jqObject
                        || $('#' + leftToolbar.btnExport.id);

        if (!btnExport || !btnExport.length) {
            //throw "Cannot find button 'export' with id '{0}'".format(options.leftToolbar.btnExport.id);
        } else {
            leftToolbar.btnExport.jqObject = btnExport.prop('enable', btnExport.data('kendoButton').options.enable);

        }

        btnActive = options.leftToolbar.btnActive.jqObject
                        || $('#' + options.leftToolbar.btnActive.id)
                        || leftToolbar.btnActive.jqObject
                        || $('#' + leftToolbar.btnActive.id);

        if (!btnActive || !btnActive.length) {
            //throw "Cannot find button 'active(aka: enable)' with id '{0}'".format(options.leftToolbar.btnActive.id);
        } else {
            leftToolbar.btnActive.jqObject = btnActive.prop('enable', btnActive.data('kendoButton').options.enable);

        }

        btnDeactive = options.leftToolbar.btnDeactive.jqObject
                        || $('#' + options.leftToolbar.btnDeactive.id)
                        || leftToolbar.btnDeactive.jqObject
                        || $('#' + leftToolbar.btnActive.id);

        if (!btnDeactive || !btnDeactive.length) {
            //throw "Cannot find button 'deactive(aka: disable)' with id '{0}'".format(options.leftToolbar.btnDeactive.id);
        } else {
            leftToolbar.btnDeactive.jqObject = btnDeactive.prop('enable', btnDeactive.data('kendoButton').options.enable);

        }


    }

    function initOptions(opts) {
        options = opts;
        handleForm(opts);
        handleGrid(opts);
        handleUrls(opts);
        handleRightToolbar(opts);
        handleLeftToolbar(opts);
        handleReport(opts);
    }

    function initGridLinkEvents(e) {
        ASOFT.helper.initAutoClearMessageBox(getElementIDs(), grid);
        var anchors = grid.element.find('a[data-val="trigger-popup"]');
        anchors.click(function (e) {
            var tr = $(e.target).closest('tr'),
                td = $(tr).find('td')[2],
                divisionID = $(td).text(),
                data = {},
                url = '{2}?divisionID={0}&{3}={1}'.format(divisionID, e.target.text, urls.detail, urls['parameter-detail']);

            e.preventDefault();
            data['args'] = { "MemberID": e.target.text, "DivisionID": divisionID };

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

        elementIDs = elementIDs || getElementIDs();
        ASOFT.helper.initAutoClearMessageBox(elementIDs, grid);
    }

    function initGridEvents() {
        grid.dataSource.transport.options.read.data = formFilterData;
        grid.bind('dataBound', initGridLinkEvents);
    }

    function initFormEvents() {

    }

    function initLeftToolbarEvents() {
        var btn, prop;
        for (prop in leftToolbar) {
            if (leftToolbar.hasOwnProperty(prop)) {
                btn = leftToolbar[prop];
                if (btn.jqObject.prop('enable')) {
                    btn.jqObject.on('click', btn.onClick);
                }
            }
        }
    }

    function initRightToolbarEvents() {
        var btn, prop;

        for (prop in rightToolbar) {
            if (rightToolbar.hasOwnProperty(prop)) {
                btn = rightToolbar[prop];
                btn.jqObject.on('click', btn.onClick);

            }
        }
    }

    function getElementIDs() {
        var result = [];
        for (prop in leftToolbar) {
            if (leftToolbar.hasOwnProperty(prop)) {
                btn = leftToolbar[prop];
                result.push(btn.jqObject.attr('id'));
            }
        }
        for (prop in rightToolbar) {
            if (rightToolbar.hasOwnProperty(prop)) {
                btn = rightToolbar[prop];
                result.push(btn.jqObject.attr('id'));
            }
        }
        return result;
    }

    function initAutoClearMessage() {
        var
            btn,
            prop
        ;

        elementIDs = elementIDs || getElementIDs();
        ASOFT.helper.initAutoClearMessageBox(elementIDs, grid);
    }

    function initEvents() {
        initGridEvents();
        initFormEvents();
        initLeftToolbarEvents();
        initRightToolbarEvents();
        initAutoClearMessage();
    }

    function initMeta() {
        var metaTags = document.getElementsByTagName('meta'),
            i = 0,
            l = metaTags.length,
            name,
            content
        ;

        for (; i < l; i++) {
            if (name = metaTags[i].getAttribute("name")) {
                content = metaTags[i].getAttribute("content");
                meta[name] = content;
            }

        }
    }

    function refreshGrid() {
        grid.dataSource.fetch();
    }

    return {
        init: function (_options) {
            initOptions(_options);
            initEvents();
            initMeta();
        },
        api: {
            refreshGrid: refreshGrid
        }
    };
}();

$(document).ready(function () {
    x.sas
    GridScreen.init({
        form: {
            id: "FormFilter",
            jqObject: $('form'),
            controls: []
        },
        grid: {
            id: 'POSF0011Grid',
            kGrid: $('.k-grid').data('kendoGrid'),
            identityColumn: $('#IdentityColumn').val()
        },
        urls: {
            'read': $('#UrlGridData').val(),
            'detail': $('#UrlDetail').val(),
            'create': $('#UrlInsert').val(),
            'update': $('#UrlUpdate').val(),
            'delete': $('#UrlDelete').val(),
            'active': $('#UrlActive').val(),
            'deactive': $('#UrlDeactive').val(),
            'export': $('#UrlExportData').val(),
            'pre-export': $('#UrlPreExportData').val(),
            'parameter-detail': $('#UrlParameter').val(),
        },
        rightToolbar: {
            btnFilter: {
                id: 'BtnFilter',
                jqObject: $('#BtnFilter')
            },
            btnClearFilter: {
                id: 'BtnClearFilter',
                jqObject: $('#BtnClearFilter')
            }
        },
        leftToolbar: {
            btnAddNew: {
                id: 'BtnAddNew',
                jqObject: $('#BtnAddNew')
            },
            btnDelete: {
                id: 'BtnDelete',
                jqObject: $('#BtnDelete')
            },
            btnExport: {
                id: 'BtnExport',
                jqObject: $('#BtnExport')
            },
            btnActive: {
                id: 'BtnShow',
                jqObject: $('#BtnShow')
            },
            btnDeactive: {
                id: 'BtnHide',
                jqObject: $('#BtnHide')
            }
        },
        report: {
            id: $('#ReportID').val()
        }
    });
});
//function sendData() {
//    //return new POSF0011View().sendData();
//}

//var POSF0011View = function () {
//    //if (arguments.callee._singletonInstance)
//    //    return arguments.callee._singletonInstance;
//    //arguments.callee._singletonInstance = this;

//    var thisParent = this;

//    var FORM_ID = '#FormFilter';
//    var FORM_NAME = 'FormFilter';

//    var GRID_LINK_SELECTOR = '.asf-grid-link';

//    var GRID_NAME = 'POSF0011Grid';
//    var GRID_ID = '#POSF0011Grid';

//    var URL_DELETE = '/POS/POSF0011/Delete';
//    var URL_ENABLE = '/POS/POSF0011/SetEnabled';
//    var URL_DISABLE = '/POS/POSF0011/SetDisabled';

//    // Biến xác định trạng thái Search
//    var isSearch = true;
//    // Grid danh mục hội viên
//    var POSF0011Grid = $(GRID_ID).data('kendoGrid');

//    var elementIDs = [
//    'POSF0011BtnFilter',
//    'POSF0011BtnClearFilter',
//    'btnSave',
//    'btnDelete',
//    'btnExport',
//    'btnInActive',
//    'btnActive',
//    'chkAll',
//    'btnFilter'
//    ];

//    var initEvents = function () {
//        POSF0011Grid.bind("dataBound", initGridLinkEvent);
//    }

//    // Tạo dữ liệu từ form filter để post back
//    this.sendData = function () {
//        var datamaster = ASOFT.helper.dataFormToJSON("FormFilter");
//        datamaster['IsSearch'] = isSearch;
//        return datamaster;
//    }


//    // Xử lý kết quả từ server trả về sau khi xóa thành công
//    // Tạm thời chỉ dựa vào độ dài của result.Message để xác định
//    function deleteSuccess(result) {
//        // Nếu xóa thành công
//        if (result.Status == 0) {
//            // Thông báo msg: 'Xóa thành công.'
//            //ASOFT.dialog.messageDialog(ASOFT.helper.getMessage("00ML0000530").format(result.Data.join(', ')));
//            ASOFT.form.clearMessageBox();
//            ASOFT.form.displayInfo('#' + FORM_ID, ASOFT.helper.getMessage(result.MessageID));
//            refreshGrid(); // Refresh grid 

//        }
//        else {
//            if (POSF0011Grid) {
//                POSF0011Grid.dataSource.read();
//            }
//            ASOFT.form.clearMessageBox();
//            ASOFT.form.displayWarning('#' + FORM_ID, ASOFT.helper.getMessage(result.MessageID).format(result.Params));
//        }
//        refreshGrid(); // Refresh grid 
//    }

//    function initGridLinkEvent() {
//        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
//        $(GRID_LINK_SELECTOR).click(function (e) {
//            var tr = $(e.target).closest('tr');
//            var td = $(tr).find('td')[2];
//            var divisionID = $(td).text();
//            var data = {};
//            var url = '/POS/POSF0011/POSF00111?divisionID={0}&memberID={1}'
//                    .format(divisionID, e.target.text);

//            data['args'] = { "MemberID": e.target.text, "DivisionID": divisionID };

//            if (e.ctrlKey) {
//                console.log('Ctrl+Click');
//                window.open(url, '_blank');
//            }
//            else if (e.altKey) {
//                console.log('Alt+Click');
//            }
//            else {
//                ASOFT.asoftPopup.showIframe(url, data);
//            }
//        });
//    }

//    this.refreshGrid = function () {
//        POSF0011Grid.dataSource.fetch();
//    }

//    // Xử lý khi click nút Xóa
//    this.btnDelete_Click = function () {
//        var args = [];
//        var data = {};

//        if (POSF0011Grid) { // Lấy danh sách các dòng đánh dấu
//            var records = ASOFT.asoftGrid.selectedRecords(POSF0011Grid);
//            if (records.length == 0) return;
//            for (var i = 0; i < records.length; i++) {
//                args.push(records[i].MemberID);
//            }
//        }


//        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
//            var datamaster = ASOFT.helper.dataFormToJSON(FORM_NAME);
//            data['DivisionIDFilter'] = datamaster.DivisionIDFilter;
//            data['args'] = args;

//            //Delete 
//            ASOFT.helper.postTypeJson(URL_DELETE, data, function (result) {
//                ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME,
//                    thisParent.refreshGrid,
//                    thisParent.refreshGrid,
//                    thisParent.refreshGrid, true);
//            });
//        });
//    }

//    // Xử lý khi click nút Add (thêm)
//    this.btnAdd_Click = function () {
//        formMode = 0; //
//        data = {};
//        ASOFT.asoftPopup.showIframe('/POS/POSF0011/POSF00111', data);
//        // Thêm popup frame vào stack để đóng lại khi ấn esc
//        //iFramePopup = ASOFT.asoftPopup.castName("PopupIframe");
//        //frameStack.push(iFramePopup);
//        return false;
//    }

//    // Xử lý khi click nút Disable
//    this.btnDisable_Click = function () {
//        var args = [];
//        var data = {};

//        if (POSF0011Grid) { // Lấy danh sách các dòng đánh dấu
//            var records = ASOFT.asoftGrid.selectedRecords(POSF0011Grid);
//            if (records.length == 0) return;
//            for (var i = 0; i < records.length; i++) {
//                args.push(records[i].MemberID);
//            }
//        }
//        data['args'] = args;
//        ASOFT.helper.postTypeJson('/POS/POSF0011/SetDisabled', data, function (result) {
//            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME);
//            thisParent.refreshGrid(); // Refresh grid 
//        });
//    }

//    // Xử lý khi click nút Enable
//    this.btnEnable_Click = function () {
//        var args = [];
//        var data = {};

//        if (POSF0011Grid) { // Lấy danh sách các dòng đánh dấu
//            var records = ASOFT.asoftGrid.selectedRecords(POSF0011Grid);
//            // Nếu không có dòng nào được chọn
//            if (records.length == 0) {
//                return;
//            }
//            for (var i = 0; i < records.length; i++) {
//                args.push(records[i].MemberID);
//            }
//        }
//        data['args'] = args;
//        ASOFT.helper.postTypeJson('/POS/POSF0011/SetEnabled', data, function (result) {
//            ASOFT.helper.showErrorSeverOption(1, result, FORM_NAME);
//            thisParent.refreshGrid(); // Refresh grid 
//        });
//    }


//    // Sự kiện click vào nút lọc dữ liệu
//    this.POSF0011BtnFilter_Click = function () {
//        isSearch = true;
//        refreshGrid();
//        console.log('POSF0011BtnFilterClick');
//        return false;
//    }

//    // Sự kiện click vào nút làm lại
//    this.POSF0011BtnClearFilter_Click = function () {
//        // Reset business combobox
//        var multiComboBox = $('#DivisionIDFilter').data('kendoDropDownList');
//        resetDropDown(multiComboBox);
//        // Reset các field còn lại
//        $("#MemberIDFilter").val('');
//        $("#MemberNameFilter").val('');
//        $("#AddressFilter").val('');
//        $("#IdentifyFilter").val('');
//        $("#PhoneFilter").val('');
//        $("#TelFilter").val('');
//        $("#FaxFilter").val('');
//        $("#EmailFilter").val('');
//        $("#ShopIDFilter").val('');

//        isSearch = true;

//        console.log('POSF0011Btn Clear FilterClick');

//        return false;
//    }


//    this.btnExport_Click = function () {
//        isSearch = false;
//        var data = {};
//        var args = sendData();
//        var postUrl = $("#UrlPreExportData").val();
//        data['args'] = args;


//        ASOFT.helper.postTypeJson(postUrl, data, preExportSuccess);
//    }

//    // click vào một dòng trong grid
//    // e: Element 
//    // divisionID: Mã đơn vị
//    this.memberDetail_Click = function (e, divisionID) {
//        data['args'] = { "MemberID": e.text(), "DivisionID": divisionID };
//        ASOFT.asoftPopup.showIframe('/POS/POSF0011/POSF00111?divisionID={0}&memberID={1}'
//            .format(divisionID, $(e).text()), null);
//        return false;
//    }

//    var preExportSuccess = function (data) {
//        if (data) {
//            var key = data.apk;
//            var reportId = "POSR0002";
//            var postUrl = $("#UrlExportData").val();

//            var fullPath = postUrl + '?id=' + key + '&reportId=' + reportId;
//            window.location = fullPath;
//        }
//    }

//    ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);
//    initEvents();
//}

//function btnDelete_Click() {
//    view.btnDelete_Click()
//}
//function btnAdd_Click() { view.btnAdd_Click() }
//function btnDisable_Click() { view.btnDisable_Click() }
//function btnEnable_Click() { view.btnEnable_Click() }
//function POSF0011BtnFilterClick() { view.POSF0011BtnFilter_Click() }
//function POSF0011BtnClearFilterClick() { view.POSF0011BtnClearFilter_Click() }
//function btnExport_Click() { view.btnExport_Click() }
//function memberDetail_Click(e, divisionID) { view.memberDetail_Click(e, divisionID) }
//function sendData() {
//    return new POSF0011View().sendData();
//}
//function refreshGrid() {
//    view.refreshGrid();
//}

//var view;
//$(document).ready(function () {
//    view = new POSF0011View();
//});




