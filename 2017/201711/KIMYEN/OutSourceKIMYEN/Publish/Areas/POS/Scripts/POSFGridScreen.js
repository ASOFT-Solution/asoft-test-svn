//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     29/09/2014      Thai Son        New: code tổng quát cho các màn hình danh sách
//#                                     Dùng cho POSF0011, POSF0043, POSF0015
//####################################################################
var ASOFT = ASOFT || {};
ASOFT.GridScreen = function () {
    var
        debug = false,

        elementIDs,

        _log = (function () {
            var _log;
            // Nếu không debug, thì hàm LOG đặt thành hàm rỗng
            if (!debug) {
                return function () { };
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
                    //e.preventDefault();
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

                    if (records.length == 0) return false;

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
                                refreshGrid(),
                                null,
                                null,
                                true);
                        });
                    });
                    return false;
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
            btnPrint: {
                id: 'btnPrint',
                jqObject: $('#btnPrint'),
                onClick: function (e) {
                    _log('btnPrint');
                    var datamaster = formFilterData();
                    ASOFT.helper.postTypeJson("/POS/POSF0011/DoPrintOrExport", datamaster, ExportSuccess);
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
                    grid.dataSource.page(1);
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
                    resetKendoInputs();
                }
            }
        },

        report = {
            id: "POSR0002"
        },

        isSearch = false,

        kendoInputs = [],

        defaultFilter = {},

        hasPeriod = false
    ;

    function ExportSuccess(result) {
        if (result) {
            var urlPrint = '/POS/POSF0011/ReportViewer';
            var options = '&viewer=pdf';
            // Tạo path full
            var fullPath = urlPrint + "?id=" + result.apk + options;

            // Getfile hay in báo cáo
            window.open(fullPath, "_blank");
        }
    }


    function pad(n, width, z) {
        z = z || '0';
        n = n + '';
        return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }

    function preExportSuccess(data) {
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

        $('#rdbUseDates').trigger('click');
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

    function resetKendoInputs() {
        kendoInputs.forEach(function (item) {
            var prop = item.element.attr('id');
            item.value(defaultFilter[prop]);
        });

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
        var
            data = ASOFT.helper.dataFormToJSON(form.attr('id')),
            fromDate,
            toDate,
            fromPeriod,
            toPeriod,
            useDate,
            usePeriod
        ;

        if (hasPeriod) {
            fromPeriod = $('#FromPeriodFilter').data('kendoDropDownList').dataItem();
            //toPeriod = $('#ToPeriodFilter').data('kendoComboBox').dataItem();

            //if ($('#rdbUsePeriods').prop('checked')) {
            //    data['fromMonth'] = fromPeriod.TranMonth;
            //    //data['fromYear'] = fromPeriod.TranYear;
            //    //data['toMonth'] = toPeriod.TranMonth
            //    //data['toYear'] = toPeriod.TranYear;
            //}
        }

        data['IsSearch'] = isSearch;
        return data;
    }

    function handleForm(options) {
        var $form, kendoWidgets;

        if (!options.form.jqObject || options.form.jqObject.length === 0) {
            $form = $('#' + options.form.id);
        } else {
            $form = options.form.jqObject;
        }
        if (!$form || $form.length === 0) {
            throw "Cannot find form using id '{0}'".format(options.form.id);
        }

        kendoWidgets = $form.find('input[data-role]');
        kendoWidgets.each(function (index) {
            var kInput;
            $this = $(this);
            switch ($this.data('role')) {
                case 'dropdownlist':
                    kInput = $this.data('kendoDropDownList');
                    break;
                case 'combobox':
                    kInput = $this.data('kendoComboBox');
                    break;
                case 'datepicker':
                    kInput = $this.data('kendoDatePicker');
                    break;
                default:
                    kInput = 0;
                    break;
            }
            if (kInput) {
                kendoInputs.push(kInput);
            }
        });


        kendoInputs.forEach(function (item) {
            defaultFilter[item.element.attr('id')] = item.value();
        });
        _log(defaultFilter);

        form = $form;
    }

    function handleGrid(options) {
        grid = options.grid.kGrid
            || $('#' + options.grid.id).data('kendoGrid');

        if (!grid) {
            throw "Cannot find kendoGrid using id '{0}'".format(options.grid.id);
        }
    }

    // Xử lý filter period
    function handlePeriods(options) {
        var element;

        if ($('#asf-periods-marker').length > 0) {
            hasPeriod = true;
            element = $('.tr-zero-height')[0];
            $(element).html('<td class="container_period_label"></td> <td class="container_period_control"></td> <td class="container_period_space"></td> <td class="container_period_label"></td> <td class="container_period_control"></td>');

            $("#rdbUseDates").trigger('click');
            $("input[name='IsDate']").click(function (e) {
                var value = $(this).attr('value');
                var isDateCheck = (value == '0');
                $("#FromDateFilter").data("kendoDatePicker").enable(isDateCheck);
                $("#ToDateFilter").data("kendoDatePicker").enable(isDateCheck);

                $("#FromPeriodFilter").data("kendoDropDownList").enable(!isDateCheck);
                //$("#ToPeriodFilter").data("kendoComboBox").enable(!isDateCheck);
            });
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
            btnDeactive,
            btnPrint
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

        btnPrint = options.leftToolbar.btnPrint.jqObject
                        || $('#' + options.leftToolbar.btnPrint.id)
                        || leftToolbar.btnPrint.jqObject
                        || $('#' + leftToolbar.btnPrint.id);

        if (!btnPrint || !btnPrint.length) {
            //throw "Cannot find button 'active(aka: enable)' with id '{0}'".format(options.leftToolbar.btnActive.id);
        } else {
            leftToolbar.btnPrint.jqObject = btnPrint.prop('enable', btnPrint.data('kendoButton').options.enable);

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
        handlePeriods(opts);
    }

    function initGridLinkEvents(e) {

        //ASOFT.form.clearMessageBox();
        ASOFT.helper.initAutoClearMessageBox(getElementIDs(), grid);
        var anchors = grid.element.find('a[data-val="trigger-popup"]');
        anchors.click(function (e) {
            e.preventDefault();
            ASOFT.form.clearMessageBox();
            var
                $target = $(e.target),
                tr = $target.closest('tr'),
                td = $(tr).find('td')[2],
                divisionID = $(td).text(),
                data = {},
                parameterValue = $target.attr('data-url-parameter-value'),
                url = '{2}?divisionID={0}&{3}={1}'.format(divisionID, parameterValue, urls.detail, urls['parameter-name']);

            data['args'] = { "MemberID": e.target.text, "DivisionID": divisionID };
            data['args'][urls['parameter-name']] = e.target.text;

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
        var result = [], btn;
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


function refreshGridParent() {
    $("#POSF0011Grid").data('kendoGrid').dataSource.page(1);
}


$(document).ready(function () {
    setTimeout(function () {
        if (localStorage.getItem("OpenWare") != null) {
            $("#BtnAddNew").trigger("click");
            localStorage.removeItem("OpenWare");
            ASOFT.asoftPopup.showIframe($('#UrlInsert').val(), {});
        }
    }, 200)

    ASOFT.GridScreen.init({
        form: {
            id: "FormFilter",
            jqObject: $('form'),
            controls: [],
            hasPeriods: false
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
            'parameter-name': $('#UrlParameter').val(),
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
            },
            btnPrint: {
                id: 'BtnPrint',
                jqObject: $('#BtnPrint')
            }
        },
        report: {
            id: $('#ReportID').val()
        }
    });
});
