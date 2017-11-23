//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     16/05/2014      Thai Son        New
//####################################################################


function ViewPOSF0006() {
    var thisParent = this;
    // Tên form
    var FORM_NAME = 'POSF0006';
    // css id của form
    var FORM_ID = '#POSF0006';
    // Tên grid
    var GRID_ID = '#POSF0006Grid';
    // css id của grid
    var GRID_NAME = 'POSF0006Grid';

    var METHOD_CASH = 'TM';

    var URL_SAVE = '/POS/POSF0006/Save';

    // Số cột của bảng
    var COL_COUNT = 7;

    var posGrid = $(GRID_ID).data('kendoGrid');

    this.Grid = {
        posGrid: $(GRID_ID).data('kendoGrid'),
        rowNum: 0,
        gridChanged: false,
        renderIndex: function (data) {
            //console.log(this.rowNum);
            return ++this.rowNum;
        },
        deletedItems: []
    }

    var gridChanged = false;
    var firstLoad = true;

    var closeWindow = function () {
        ASOFT.asoftPopup.closeOnly();
    };

    var initEvent = function () {
        var initEventsOnButtons = function () {
            console.log('init Events on Buttons');
            $('#btnClose').on('click', btnClose_Click);
            $('#btnSave').on('click', btnSave_Click);

        }

        var initGridEvents = function () {
            var timeOfChange = 0;
            posGrid.dataSource.bind("requestEnd", function () {

            });

            posGrid.dataSource.bind("change", function () {
                if (firstLoad) {
                    gridChanged = false;
                    firstLoad = false;
                } else {
                    gridChanged = true;
                }
            });

            posGrid.bind('dataBound', function (e) {
                rowNumber = 0;
                thisParent.Grid.rowNum = 0;
                var data = posGrid.dataSource.at(0);
                if (data) {
                    data.fields["APK"].editable = false;
                }
                oldPaymentList = posGrid.dataSource.data().slice(0); //$.extend({}, posGrid.dataSource.data());
            });
            posGrid.bind('edit', grid_Edit);
            posGrid.bind('save', grid_Save);
        }

        initEventsOnButtons();
        initGridEvents();
        console.log('init Event');
    };

    var grid_Save = function (e) {
        if (e.values == null) {
            return false;
        }

        var cboPaymentTypesModel01 = e.values.CboPaymentTypes01;
        var cboObjectTypesModel01 = e.values.CboObjectTypes01;

        if (cboPaymentTypesModel01) {
            var selectedValue = cboPaymentTypesModel01.PaymentID;
            var selectedText = cboPaymentTypesModel01.PaymentName;

            e.model.set('PaymentID01', selectedValue.trim());
            e.model.set('PaymentName01', selectedText.trim());
        }

        if (cboObjectTypesModel01) {
            var selectedValue = cboObjectTypesModel01.ObjectTypeID;
            var selectedText = cboObjectTypesModel01.ObjectTypeName;

            e.model.set('ObjectTypeID01', selectedValue.trim());
            e.model.set('ObjectTypeName01', selectedText.trim());
        }

        var cboPaymentTypesModel02 = e.values.CboPaymentTypes02;
        var cboObjectTypesModel02 = e.values.CboObjectTypes02;

        if (cboPaymentTypesModel02) {
            var selectedValue = cboPaymentTypesModel02.PaymentID;
            var selectedText = cboPaymentTypesModel02.PaymentName;

            e.model.set('PaymentID02', selectedValue.trim());
            e.model.set('PaymentName02', selectedText.trim());
        }

        if (cboObjectTypesModel02) {
            var selectedValue = cboObjectTypesModel02.ObjectTypeID;
            var selectedText = cboObjectTypesModel02.ObjectTypeName;

            e.model.set('ObjectTypeID02', selectedValue.trim());
            e.model.set('ObjectTypeName02', selectedText.trim());
        }
    }

    // Xử lý sự kiện bắt đầu chỉnh sửa một ô trên lưới
    // Gán từ View
    var grid_Edit = function (e) {
        if (!e) {
            return false;
        }

        var CboObjectTypes01 = $('#CboObjectTypes01')
            .data('kendoDropDownList');
        var CboPaymentTypes01 = $('#CboPaymentTypes01')
            .data('kendoDropDownList');

        if (CboPaymentTypes01) {
            //console.log(e.model.PaymentID01);
            CboPaymentTypes01.select(function (dataItem) {
                if (dataItem.PaymentID && e.model.PaymentID01) {
                    var equal =
                    (dataItem.PaymentID.valueOf() == e.model.PaymentID01.valueOf());
                    return equal;
                }
                return false;
            });
        }

        if (CboObjectTypes01) {
            //console.log(e.model.ObjectTypeID01);
            CboObjectTypes01.select(function (dataItem) {
                if (dataItem.ObjectTypeID && e.model.ObjectTypeID01) {
                    var equal =
                    (dataItem.ObjectTypeID.valueOf() == e.model.ObjectTypeID01.valueOf());
                    return equal;
                }
                return false;
            });
        }


        var CboObjectTypes02 = $('#CboObjectTypes02')
            .data('kendoDropDownList');
        var CboPaymentTypes02 = $('#CboPaymentTypes02')
            .data('kendoDropDownList');

        if (CboPaymentTypes02) {
            //console.log(e.model.PaymentID02);
            CboPaymentTypes02.select(function (dataItem) {
                if (dataItem.PaymentID && e.model.PaymentID02) {
                    var equal =
                        (dataItem.PaymentID.valueOf() == e.model.PaymentID02.valueOf());
                    return equal
                };
                return false;
            });
        }

        if (CboObjectTypes02) {
            //console.log(e.model.ObjectTypeID02);
            CboObjectTypes02.select(function (dataItem) {
                if (dataItem.ObjectTypeID && e.model.ObjectTypeID02) {
                    var equal =
                        (dataItem.ObjectTypeID.valueOf() == e.model.ObjectTypeID02.valueOf());
                    return equal;
                }
                return false;
            });
        }

    }


    var close = function () {
        if (gridChanged) {
            ASOFT.dialog.confirmDialog(
                ASOFT.helper.getMessage('00ML000016'),
                //yes
                function () {
                    save();
                    //closeWindow();
                },
                //no
                function () {
                    closeWindow();
                });
        } else {
            //Close popup
            closeWindow();
        }
    };

    var isInvalid = function () {
        //checkgrid
        $(GRID_ID).removeClass('asf-focus-input-error');

        ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);
        var check = false;

        if (posGrid.dataSource.total() <= 0) {
            $(GRID_ID).addClass('asf-focus-input-error');
            //display message
            var msg = ASOFT.helper.getMessage('00ML000061');
            ASOFT.form.displayError(FORM_ID, msg);
            check = true;
        } else {
            //show quantity
            var noneRequired = ['PaymentName01', 'PaymentName02',
                                      'ObjectTypeName01',
                                      'ObjectTypeName02'];

            // Kiểm tra (các) cột bắt buộc nhập
            if (ASOFT.asoftGrid
                .editGridValidate(posGrid, noneRequired)) {
                var msg = ASOFT.helper.getMessage('00ML000060');
                ASOFT.form.displayError(FORM_ID, msg);
                check = true;
                return check;
            }
            else {
                // Kiểm tra phương thức bị trùng
                $.each(posGrid.dataSource.data(),
                    function (index, theItem) {
                        $.each(posGrid.dataSource.data(),
                            function (i, item) {
                                if (theItem != item
                                    && stringEmptyOrEqual(theItem.PaymentID01, item.PaymentID01)
                                    && stringEmptyOrEqual(theItem.PaymentID02, item.PaymentID02)
                                    ) {

                                    $(GRID_ID).removeClass('asf-focus-input-error');
                                    var msg = ASOFT.helper.getMessage('POSM000031');
                                    ASOFT.form.displayError(FORM_ID, msg);

                                    $(posGrid.tbody.find('td')[COL_COUNT * i + 1])
                                        .addClass('asf-focus-input-error');
                                    $(posGrid.tbody.find('td')[COL_COUNT * index + 1])
                                        .addClass('asf-focus-input-error');

                                    $(posGrid.tbody.find('td')[COL_COUNT * i + 2])
                                        .addClass('asf-focus-input-error');
                                    $(posGrid.tbody.find('td')[COL_COUNT * index + 2])
                                        .addClass('asf-focus-input-error');
                                    check = true;
                                    return true;
                                }

                            });
                    });

                var isInfoValid = true;

                // Kiểm tra ràng buột cho từng dòng
                $.each(posGrid.dataSource.data(),
                    function (index, item) {

                        if (isNullEmptyWhiteSpace(item.PaymentID01)
                            && isNullEmptyWhiteSpace(item.PaymentID02)) {
                            $(GRID_ID).removeClass('asf-focus-input-error');
                            var msg = AsoftMessage['POSM000033'];
                            ASOFT.form.displayError(FORM_ID, msg);
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 1])
                                        .addClass('asf-focus-input-error');
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 2])
                                        .addClass('asf-focus-input-error');

                            isInfoValid = false;
                            return (check || !isInfoValid);
                        }

                        // Phương thức 1 trùng phương thức 2
                        if (stringEmptyOrEqual(item.PaymentID01, item.PaymentID02)) {
                            $(GRID_ID).removeClass('asf-focus-input-error');
                            var msg = AsoftMessage['POSM000032'];
                            ASOFT.form.displayError(FORM_ID, msg);
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 1])
                                        .addClass('asf-focus-input-error');
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 2])
                                        .addClass('asf-focus-input-error');

                            isInfoValid = false;
                            return (check || !isInfoValid);
                        }

                        // Trường hợp không chọn phương thức thanh toán 2 mà chọn  obj 2
                        // thông báo:
                        if (!isNullEmptyWhiteSpace(item.ObjectTypeID02) && isNullEmptyWhiteSpace(item.PaymentID02)) {
                            $(GRID_ID).removeClass('asf-focus-input-error');
                            var msg = ASOFT.helper.getMessage('POSM000034');
                            ASOFT.form.displayError(FORM_ID, msg);
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 2])
                                        .addClass('asf-focus-input-error');

                            isInfoValid = false;
                            return (check || !isInfoValid);
                        }

                        // Trường hợp không chọn phương thức thanh toán 1 mà chọn  obj 1
                        // thông báo:
                        if (!isNullEmptyWhiteSpace(item.ObjectTypeID01) && isNullEmptyWhiteSpace(item.PaymentID01)) {
                            $(GRID_ID).removeClass('asf-focus-input-error');
                            var msg = ASOFT.helper.getMessage('POSM000034');
                            ASOFT.form.displayError(FORM_ID, msg);
                            $(posGrid.tbody.find('td')[COL_COUNT * index + 1])
                                        .addClass('asf-focus-input-error');

                            isInfoValid = false;
                            return (check || !isInfoValid);
                        }

                    });
            }
        }

        return (check || !isInfoValid);
    };

    var getData = function () {
        var dataPost = {};
        dataPost.PaymentList = posGrid.dataSource.data();
        dataPost.DeletedPayments = this.deletedItems;
        return dataPost;
    };

    var save = function () {
        if (isInvalid()) {
            return false;
        }
        var dataPost = getData(),
            radioButtons = $('input[name=radio-check]'),
            checkedRadio = $('input[name=radio-check]:checked'),
            apk = checkedRadio.attr('data-apk'),
            selectedIndex = radioButtons.index(checkedRadio)

        ;

        dataPost.PaymentList.forEach(function (item) {
            item.IsDefault = 0;
        });
        if (selectedIndex !== -1) {
            dataPost.PaymentList[selectedIndex].IsDefault = 1;
        }

        ASOFT.helper.postTypeJson(
        URL_SAVE,
        dataPost,
        function (result) {
            console.log(result);
            if (result.Status == 0) {
                ASOFT.form.clearMessageBox();
                ASOFT.form.displayInfo(
                    FORM_ID,
                    ASOFT.helper.getMessage(result.MessageID));
                thisParent.Grid.gridChanged = false;
                gridChanged = false;
                firstLoad = true;
            } else {
                // Xử lý hiển thị nếu có phương thức thanh toán không xóa được
                ASOFT.form.clearMessageBox();
                ASOFT.form.displayWarning(
                    FORM_ID,
                    ASOFT.helper.getMessage(result.MessageID).format(result.Data.Payments));

                if (result.Message == '00ML000015') {
                    posViewModel.isInvalid();
                }
            }
            thisParent.Grid.posGrid.dataSource.page(1);
            errorAPKs = result.Data.APKs;
            posGrid.unbind('dataBound', showErrorRow).bind('dataBound', showErrorRow);
            deletedItems = []
        });
    };
    var errorAPKs;
    function showErrorRow() {

        if (Array.isArray(errorAPKs)) {
            errorAPKs.forEach(function (item) {
                $("tr:has(a[data-apk='{0}'])".format(item))
                .addClass('asf-focus-input-error')
            });
        }
    }

    function btnClose_Click(e) {
        console.log('btnClose_Click');
        close();
    }

    function btnSave_Click(e) {
        console.log('btnSave_Click');
        save();
    };

    this.deleteRow_Click = function (e) {
        var row = $(e).closest("tr");
        var item = posGrid.dataItem(row);
        items = posGrid.dataSource.data();
        var index = items.indexOf(item);

        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000024'),
            function () {
                if (items.length == 1 && index == 0) {
                    ASOFT.asoftGrid.resetRow(item);
                    thisParent.Grid.deletedItems.push(item);
                }
                else {
                    posGrid.removeRow(row);
                    thisParent.Grid.deletedItems.push(item);
                    if (item.APK && item.APK.length > 0) {
                        itemClone = JSON.parse(JSON.stringify(item));
                    }
                }
            },
            function () {
            }
        );
        return false;
    };

    this.genDeleteBtn = function (data) {
        return "<a href='javascript:void(0)' onclick='return view.deleteRow_Click(this)' class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
    };

    this.deletedItems = [];

    initEvent();

    // Tạo số cho cột số thứ tự
    function renderNumber(data) {
        return ++view.Grid.rowNum;
    }

    // Tạo nút xóa dòng dữ liệu
    function genDeleteBtn(data) {
        return "<a href='javascript:void(0)' onclick='return view.deleteRow_Click(this)' class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
    }

    function isNullEmptyWhiteSpace(val) {
        return (val === undefined || val == null || val.length <= 0 || val.match(/^ *$/) !== null) ? true : false;
    }


    // Kiểm tra bằng nhau của 2 chuổi
    // các giá trị null, rỗng, xem như bằng nhau
    function stringEmptyOrEqual(str1, str2) {

        if (isNullEmptyWhiteSpace(str1) && isNullEmptyWhiteSpace(str2)) {
            return true;
        }
        return (str1 && str2 && str1.valueOf() == str2.valueOf())
    }
}

var view;

$(document).ready(function () {
    view = new ViewPOSF0006();

    var
        currentUID = '',

        DEBUG = true,

        that = this,
        // Tên form
        FORM_NAME = 'POSF0006',
        // css id của form
        FORM_ID = '#POSF0006',
        // Tên grid
        GRID_ID = '#POSF0006Grid',
        // css id của grid
        GRID_NAME = 'POSF0006Grid',

        METHOD_CASH = 'TM',

        URL_SAVE = '/POS/POSF0006/Save',

        // Số cột của bảng
        COL_COUNT = 6,

        kGrid = $(GRID_ID).data('kendoGrid'),

        deletedItems = [],

        dataSource = kGrid.dataSource,

        _log = initLOG(0);
    ;

    function init() {
        initLOG();
        kGrid.bind('dataBound', addDeleteButtonEvents);
        kGrid.bind('dataBound', addRadioButtonEvents);
        kGrid.bind('dataBound', alignCellContent);
        kGrid.bind('dataBound', checkOnPreviousRadio);

        view.deletedItems = deletedItems;
        alignCellContent();
    }

    function checkOnPreviousRadio(e) {
        var tr = $('tr[data-uid="{0}"]'.format(currentUID)),
            radio = tr.find('input[name=radio-check]');
        radio.attr('checked', true);
        _log(radio);
    }

    function alignCellContent() {
        $(GRID_ID).find('td:nth-child(7n-1)').addClass('asf-cols-align-center');
    }

    function addDeleteButtonEvents(e) {
        $(FORM_ID).find('a[data-role="btnDelete"]').on('click', btnDelete_Click);

    }

    function addRadioButtonEvents(e) {
        $(FORM_ID).find('input[name=radio-check]').on('click', radioButton_Click);

    }

    function radioButton_Click(e) {
        _log(e);
        _log(this.checked);
        //e.preventDefault();
        currentUID = $(this).closest('tr').attr('data-uid')
    }

    function btnDelete_Click(e) {
        var
            apk = getApkFromDeleteEvent(this)
        ;

        e.preventDefault();
        e.stopPropagation();

        if (!apk) {
            return;
        }

        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000024'),
            function () {
                var deletedItem = removeItemByAPK(apk);
                deletedItems.push(deletedItem);
            },
            function () {
                _log('User clicked NO');
            }
        );
        return false;
    }

    function removeItemByAPK(apk) {
        var i = 0,
            item = null
        ;

        _log(apk);
        if (apk === 'null') {
            return removeLastRow();
        }

        while (item = (dataSource.at(i++))) {
            if (item.APK.toUpperCase() === apk.toUpperCase()) {
                dataSource.remove(item);
                return item;
            }
        }
    }

    function removeLastRow() {
        dataSource.remove(dataSource.at(dataSource.total() - 1));
    }

    function getApkFromDeleteEvent(that) {
        // Lấy đối tượng jQuery của nút xóa
        var jElement = $(that),
        // Lấy ra apk Detail
            apk = jElement.attr('data-apk');

        return apk;
    }

    function initLOG() {
        var _log;
        // Nếu không debug, thì hàm LOG đặt thành rỗng
        if (!DEBUG) {
            _log = function () { };
            return;
        }

        // Tạo hàm log
        if (Function.prototype.bind) {
            _log = Function.prototype.bind.call(console.log, console);
        }
        else {
            _log = function () {
                Function.prototype.apply.call(console.log, console, arguments);
            };
        }

        return _log;
    }

    init();

});