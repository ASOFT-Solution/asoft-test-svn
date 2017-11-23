/// <reference path="http://localhost:3227/Scripts/jquery.inputmask.date.extensions.js" />
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/04/2014      Thai Son        Tạo mới
//####################################################################
// Empty GUID
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';

// Tên form filter
var FORM_NAME = 'POSF00171';

// CSS ID của form filter
var FORM_ID = '#POSF00171';

// CSS ID của lưới chi tiét
var GRID_ID = '#POSF00171Grid';

var TIME_BETWEEN_KEY_PRESS_HUMANLY = 40;

// Lưới hiển thị chi tiết phiếu kiểm kê
var posGrid = null;

// kendo ViewModel cho màn hình cập nhật phiếu kiểm kê
var posViewModel = null;

// Số thứ tự của dòng
var rowNumber = 0;

// Biến xác định ấn phím enter trong autoComplete
var ifKey = 0;

// Biến xác định sự kiện ấn enter đã được xử lý
var ifKeyDone = false;

// Biến xác định người dùng chọn item bằng cách ấn phím enter
var isSelectedByEnter = 0;

var MULTIFLY_CHARACTER = "*";

var autoComplete;

var currentNumberOfRows = 0;

var vars = {
    gridChanged: false,
    firstLoad: true
};

function filter(keyWord) {    //keyWord = autoComplete.value();
    var res = keyWord.split(MULTIFLY_CHARACTER);
    if (res.length == 1) {
        keyWord = res[0];
    } else {
        keyWord = res[1];
        quantity = res[0] * 1;
        ////console.log('QUANTITY = ' + quantity);
    }

    if (!isEmpty(keyWord)) {
        ////console.log(keyWord + ' going to server');
        ASOFT.helper.postTypeJson(
            createURL(keyWord, 'GetInventories'),
            {},
            function (result) {
                ////console.log('Server back: ');
                autoComplete.setDataSource(result.Data);
                //autoComplete.bind('change', autoComplete_Select2);
                autoComplete.search(keyWord);
                return result.Data;
            }
        );
    }
}

function filterExact(keyWord) {    //keyWord = autoComplete.value();
    //var data = filter(keyWord);
    var res = keyWord.split(MULTIFLY_CHARACTER);
    var quantity = 1;
    if (res.length == 1) {
        keyWord = res[0];
    } else {
        keyWord = res[1];
        quantity = res[0] * 1;
        //console.log('QUANTITY = ' + quantity);
    }
    //console.log(keyWord);
    if (!isEmpty(keyWord)) {
        //console.log(keyWord + ' going to server');

        ASOFT.helper.postTypeJson(
            createURL(keyWord, 'GetOneInventory'),
            {},
            function (result) {
                //console.log('Server back: ');
                //console.log(result);
                autoComplete.setDataSource(result.Data);
                //autoComplete.bind('change', autoComplete_Select2);
                if (result.Data.length > 0) {
                    addInventoryToGrid(result.Data[0]);
                    resetautoComplete();
                };
            }
        );
    }


}

function createURL(keyWord, actionName) {
    var shopID = $('#ShopID').val();
    var voucherDate = $('#VoucherDateFilter').val();
    return '/POS/POSF0017/{0}?keyWord={1}&shopID={2}&voucherDateTicks={3}'.format(actionName, keyWord, shopID, voucherDate);
}

function autoComplete_Select(e) {
    //console.log('autoComplete_Select is called ');
    var item = e.item;
    var searchWord = this.value();
    var selected = null;

    var ds = autoComplete.dataSource;
    for (var i = 0; i < ds.total() ; i++) {
        var dataitem = ds.at(i);
        if (!dataitem) {
            break;
        }
        if (searchWord.valueOf().indexOf(dataitem.InventoryID.valueOf()) == 0) {
            selected = dataitem;
            break;
        }
    }

    if (selected) {
        selectedItem = true;
        addInventoryToGrid(selected);
        resetautoComplete();
        //ifKeyDone = true;
        //ifKey = 0;
        //isSelectedByEnter++;
    } else {
        selectedItem = false;
    }
}

var milisecond = 0;
var firstStroke = true;
var isHuman = false;
var selectedItem = false;

function resetautoComplete() {
    firstStroke = true;
    isHuman = false;
    milisecond = 0;
    $(autoComplete.element).focus();
    $(autoComplete.element).val('');
    autoComplete.value('');
}

function initAutoComplete() {
    autoComplete = $("#InventoryID").data("kendoAutoComplete");
    autoComplete.focus();
    $(autoComplete.element).attr('placeholder', $("label[for|='IntentoryOrBardcode']").text());

    //autoComplete = $("#InventoryID").data("kendoComboBox");
    autoComplete.bind('change', autoComplete_Select);
    //$(autoComplete.element).focus();
    $("input[name='InventoryID']").focus();
    var oldT = +new Date();
    var newT = +new Date();

    $(autoComplete.element).on('keydown', function (e) {
        ////console.log('KEY DOWN ');
        if (e.keyCode == 13) {
            ////console.log('ENTER DOWN');
            //$(autoComplete.element).focus();
            //$(autoComplete.element).select();

            //resetautoComplete();
            return false;
        }
    });

    $(autoComplete.element).on('focus', function (e) {
        //autoComplete.element.select();
        return false;
    });

    $(autoComplete.element).on('keyup', function (e) {
        ////console.log('KEY UP');
        var valueText = autoComplete.value();
        var char = String.fromCharCode(e.keyCode);
        if (e.keyCode == 13) {
            ////console.log('ENTER UP');
            //if (selectedItem) {
            //    $(autoComplete.element).focus();
            //    $(autoComplete.element).select();
            //}
            filterExact(autoComplete.value());
            resetautoComplete();
            if (selectedItem) {
                ////console.log('THERE IS selectedItem');
                selectedItem = false;
            } else {
                ////console.log('LET\'S FILTER EXACT');
                //filterExact(valueText);
            }
            return false;
        }

        if (e.keyCode == 106) {
            ////console.log('Asterix');
            firstStroke = true;
            return false;
        }

        if (e.keyCode == 27) {
            resetautoComplete();
            firstStroke = true;
            return false;
        }

        if (isAlphanum(char) || e.keyCode == 8 || e.keyCode == 46) {

            var res = valueText.split(MULTIFLY_CHARACTER);
            var quantity = 1;
            var keyWord = '';
            if (res.length == 1) {
                keyWord = res[0];
            } else {
                keyWord = res[1];
                quantity = res[0] * 1;
                //console.log('QUANTITY = ' + quantity);
            }

            if (firstStroke && keyWord && keyWord.length == 1) {
                //milisecond = +new Date();
                ////console.log('FIRST STROKE');
                setTimeout(function () {
                    var valueText = autoComplete.value();
                    if (valueText && valueText.length > 1) {
                        //console.log('SECOND STROKE MACHINE INPUT');
                        isHuman = false
                    }
                    else {
                        //console.log('SECOND STROKE HUMAN INPUT');
                        filter(valueText);
                        isHuman = true;
                    }
                }, TIME_BETWEEN_KEY_PRESS_HUMANLY);


                firstStroke = false;
                return false;
            } else if (valueText && valueText.length == 0) {
                resetautoComplete();
            }

            ////console.log('CHAR FOUND = ' + char);
            newT = +new Date();
            var diff = newT - oldT;
            ////console.log('DIFF = ' + diff);
            if (diff < TIME_BETWEEN_KEY_PRESS_HUMANLY) {
                ////console.log('MACHINE INPUT');
            }
            else if (isHuman) {
                ////console.log('HUMAN INPUT');
                keyWord = autoComplete.value();
                filter(keyWord);
            }
        }

    });
}

function addInventoryToGrid(inventory) {
    //////console.log("EXEC: addInventoryToGrid");
    //////console.log('ifKey Add starts: ' + ifKey + ' ' + ifKeyDone + ' ' + isSelectedByEnter);

    // copy (nhân bản một item để chuẩn bị add vào grid)
    var autoComplete = $('#IntentoryOrBardcode').data('kendoautoComplete');
    var newItem = $.extend({}, inventory);
    var dataSource = posGrid.dataSource;

    // Kiểm tra xem sản phẩm này đã tồn tại trên grid chưa?
    var oldItem = null;
    for (var i = 0; i < dataSource.total() ; i++) {
        var dataitem = dataSource.at(i);
        // Nếu dữ liệu bị rỗng, thì dừng tìm
        if (!dataitem) {
            break;
        }
        // Nếu tìm thấy, thì lấy item đó, và dừng tìm
        if (dataitem.InventoryID.valueOf() == newItem.InventoryID.valueOf()) {
            oldItem = dataitem;
            break;
        }
    }

    // Nếu không có thì thêm sản phẩm này vào, 
    // nếu có thì cộng dồn số lượng kiểm kê    
    if (!oldItem) {
        posGrid.dataSource.add(newItem);
        scrollGrid();
        //console.log(posGrid.dataSource.total());
        posGrid.refresh();
        animateChangedRow(posGrid.dataSource.total());
        //selectedItem = newItem;
    }
    else {
        oldItem.ActualQuantity++;
        oldItem.AdjustQuantity--;
        posGrid.refresh();
        rowIndex = posGrid.dataSource.indexOf(oldItem) + 1;
        animateChangedRow(rowIndex);
        scrollGrid(rowIndex);
    }

    vars.gridChanged = true;

    //posGrid.refresh();

}

function animateChangedRow(rowIndex) {
    //console.log('animateChangedRow ' + rowIndex);
    var newRowElement = $(".k-grid-content tr:nth-child({0})".format(rowIndex));
    newRowElement.css('transition', 'background-color .5s linear');
    newRowElement.css('background-color', 'cyan');

    if (newRowElement.attr('class') == 'k-alt') {
        setTimeout(function () { newRowElement.css('background-color', '#F0F0F0'); }, 500);
    } else {
        setTimeout(function () { newRowElement.css('background-color', '#FFFFFF'); }, 500);
    }

}

function scrollGrid(rowIndex) {
    //console.log('scroll to ' + rowIndex);
    var gridContentClassName = '.k-grid-content';
    if ($(gridContentClassName).height() == $(gridContentClassName)[0].scrollHeight) {
        return false;
    }

    if (!rowIndex) {
        $(gridContentClassName).animate({
            scrollTop: $(gridContentClassName).offset().top
        }, 500);
    } else {
        var currentRowElement = $(".k-grid-content tr:nth-child({0})".format(rowIndex));

        if (currentRowElement.position().top < 0
            || currentRowElement.position().top > ($(gridContentClassName).height() - currentRowElement.height())) {
            var scrollDistance = 0;
            for (var i = 1; i < rowIndex; i++) {
                var rowElement = $(".k-grid-content tr:nth-child({0})".format(i));
                scrollDistance += rowElement.height()
            }
            $(gridContentClassName).animate({
                scrollTop: scrollDistance
            }, 500);
        }
    }
}

function initGrid() {
    posGrid = $(GRID_ID).data('kendoGrid');
    posGrid.bind('dataBound', function (e) {
        //console.log('dataBound');
        rowNumber = 0;
        autoComplete.focus();
    });
    posGrid.dataSource.bind("requestEnd", function () {
        if (vars.firstLoad) {
            vars.gridChanged = false;
            vars.firstLoad = false;
        } else {
            vars.gridChanged = true;
        }
    });
    posGrid.dataSource._events.change.push(gridEditor_Change);
    posGrid.dataSource.bind("change", function () {
        //console.log('gridChanged');
    });
}
var keyCode = -1;
// Xử lý ban đầu
$(document).ready(function () {
    initAutoComplete();


    var inputs = $(':input').keypress(function (e) {
        if (e.which == 13) {
            e.preventDefault();
            var nextInput = inputs.get(inputs.index(this) + 1);
            if (nextInput) {
                nextInput.focus();
            }
        }
    });
    var e = $.Event("keypress", { which: 13 });
    //$('#Description').trigger(e);
    setTimeout(function () {
        $('#Description').trigger(e);
    }, 500);
    initGrid();
    createViewModel();
    ////console.log();
    //if (window.parent != window) {
    //    //.log(window.parent);
    //    //console.log(window.parent.ASOFT.asoftPopup.hideIframe);
    //    window.parent.popupClose = function () {
    //        window.parent.ASOFT.asoftPopup.hideIframe();
    //    }
    //}

    //Lưu sau khi nhập cột 

});

var numb = '0123456789';
var lwr = 'abcdefghijklmnopqrstuvwxyz';
var upr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


function isNumber(parm) { return isValid(parm, numb); }
function isLower(parm) { return isValid(parm, lwr); }
function isUpper(parm) { return isValid(parm, upr); }
function isAlpha(parm) { return isValid(parm, lwr + upr); }
function isAlphanum(parm) { return isValid(parm, lwr + upr + numb); }

function isValid(parm, val) {
    if (parm == "") return true;
    for (i = 0; i < parm.length; i++) {
        if (val.indexOf(parm.charAt(i), 0) == -1) return false;
    }
    return true;
}

/**
* Send data to with grid
*/
function SendDataMaster() {
    if ($('#APK').val() != '') {
        return { APK: $('#APK').val() };
    }
    return null;
}

/*
* rendernumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

// So sánh 2 đối tượng có các thuộc tính tương ứng bằng nhau 
// (2 trạng thái của form)
var isRelativeEqual = function (data1, data2) {
    var KENDO_INPUT_SUFFIX = '_input';

    if (data1 && data2
        && typeof data1 === "object"
        && typeof data2 === "object") {
        for (var prop in data1) {
            // So sánh thuộc tính của 2 data
            if (!data2.hasOwnProperty(prop)) {
                continue;
            }
            else {
                // loại bỏ các thuộc tính là input "giả" của kendo widget
                if (prop.indexOf(KENDO_INPUT_SUFFIX) !== -1) {
                    continue;
                }
                // Nếu giá trị hai thuộc tính không bằng nhau, 
                // thì data có khác biệt
                if (data1[prop].valueOf() !== data2[prop].valueOf()) {
                    return false;
                }
            }
        }

        return true;
    }

    throw 'Arguments are not valid: must be 2 object';
}


/**
* create viewmodel
*/
function createViewModel() {

    posViewModel = kendo.observable({
        gridDataSourceChanged: false,
        defaultViewModel: ASOFT.helper.dataFormToJSON(FORM_NAME),
        gridDataSource: posGrid.dataSource,
        EmployeeIDFilter: $('#EmployeeID').val(),
        Description: $('#Description').val(),
        isDataChanged: function () {
            var that = this;
            var dataPost = this.getInfo();
            var equal = isRelativeEqual(dataPost, this.defaultViewModel);
            return !equal || vars.gridChanged;
        },
        isDataChangedOffGrid: function () {
            var that = this;
            var dataPost = this.getInfo();
            var equal = isRelativeEqual(dataPost, this.defaultViewModel);
            return !equal;
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON(FORM_NAME);
            dataPost.DetailList = this.gridDataSource.data();
            dataPost.IsDataChanged = this.gridDataSourceChanged;
            var selectedItem = $('#EmployeeID').data('kendoComboBox').dataItem()
            if (selectedItem) {
                dataPost['EmployeeID'] = selectedItem.ID;
                dataPost['EmployeeName'] = selectedItem.Name;
            }

            return dataPost;
        },
        isInvalid: function () {
            //checkgrid
            $(GRID_ID).removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);

            var check = ASOFT.form.checkRequiredAndInList(FORM_NAME, ['EmployeeID']);
            if (!check) {
                if (this.gridDataSource.data().length <= 0) {
                    $(GRID_ID).addClass('asf-focus-input-error');
                    //display message
                    var msg = ASOFT.helper.getMessage('00ML000061');
                    ASOFT.form.displayError(FORM_ID, msg);
                } else {
                    //show quantity
                    if (ASOFT.asoftGrid.editGridValidate(posGrid, ['Description'])) {
                        var msg = ASOFT.helper.getMessage('00ML000060');
                        ASOFT.form.displayError(FORM_ID, msg);
                        check = true;
                    }
                }
            }

            return (check || this.gridDataSource.data().length <= 0);
        },
        reset: function () {
            $('#APK').val('');
            $('#VoucherNo').val(this.defaultViewModel.VoucherNo);
            this.set('VoucherDate', this.defaultViewModel.VoucherDate);
            //this.set('EmployeeID', '');
            //this.set('EmployeeName', '');
            //this.set('EmployeeID', '');
            this.set('DelivererName', '');
            this.set('Description', '');
            //var row = this.gridDataSource.get(0);
            //var rebindData = [ASOFT.asoftGrid.resetRow(row)];
            this.gridDataSource.data([]);
        },
        close: function () {
            ASOFT.asoftPopup.closeOnly();
        },
        deleteItems: function (tagA) {
            var row = $(tagA).closest('tr');
            var that = this;

            var inventory = posGrid.dataItem(row);
            var inventories = posGrid.dataSource.data();

            var index = inventories.indexOf(inventory);
            if (index >= 0) {
                posGrid.removeRow(row);
                posGrid.refresh();
                return false;
            }

        },
        /**
        * save 
        * action = 1 : saveAndContinue
        * action = 2 : saveAndCopy
        * action = 3 : update
        */
        save: function (e, actionFlg) {
            if (this.isInvalid()) {
                return false;
            }
            var that = this;
            var dataPost = this.getInfo();
            //var emID = $('#EmployeeID').data('kendoComboBox').value();


            var isUpdate = ($('#APK').val() != null
                && $('#APK').val() != ''
                && $('#APK').val() != EMPTY_GUID);
            var action = '/POS/POSF0017/Insert';
            if (isUpdate) {
                action = '/POS/POSF0017/Update';
                dataPost.APK = $('#APK').val();
            }
            var theThis = this;
            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    if (data.Status == 0) {
                        var msg = ASOFT.helper.getMessage(data.Message);
                        logMsg(data.Message);
                        if (data.Data != null) {
                            msg = kendo.format(msg, data.Data);
                        }
                        //display message
                        ASOFT.form.displayWarning(FORM_ID, msg);
                        //debugger
                        //vars.gridChanged = false;
                        //vars.firstLoad = false;
                    } else {
                        //refresh grid master
                        if (parent.refreshGrid
                            && typeof (parent.refreshGrid) === 'function') {
                            parent.refreshGrid();
                        }
                        vars.gridChanged = false;
                        vars.firstLoad = false;
                        theThis.defaultViewModel = theThis.getInfo();

                        switch (actionFlg) {
                            case 0:
                                //close form
                                that.close();
                                break;
                            case 1:
                                ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel.VoucherNo = data.Data;
                                that.reset();
                                break;
                            case 2:
                                ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(data.Message));
                                //set default VoucherNo
                                that.defaultViewModel.VoucherNo = data.Data;
                                $('#VoucherNo').val(that.defaultViewModel.VoucherNo);
                                break;
                            case 3:
                                ASOFT.form.displayInfo(FORM_ID, ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel = ASOFT.helper.dataFormToJSON(FORM_NAME);
                                if (data.Data != null) {
                                    $('#LastModifyDateValue').val(data.Data.LastModifyDateValue);
                                }
                                //that.gridDataSource.saveChanges();                                
                                break;
                        }

                    }
                }
            );
        },//end save (function)
        //Tính tổng 
        callTotal: function () {
            $.each(posGrid.dataSource.data(), function (index, inventory) {
                if (inventory.ActualQuantity != null && inventory.BooksQuantity != null) {
                    inventory.AdjustQuantity = inventory.BooksQuantity - inventory.ActualQuantity
                }
            });

            posGrid.refresh();
        }
    });
    kendo.bind($(FORM_ID), posViewModel);
}

/**
* delete voucher
*/
function deleteVoucher_Click(e) {
    var row = $(e).closest("tr");
    var item = posGrid.dataItem(row);
    items = posGrid.dataSource.data();
    var index = items.indexOf(item);
    ////console.log(item.APK);

    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000024'),
        function () {
            //if (items.length == 1 && index == 0) {
            //    ASOFT.asoftGrid.resetRow(item);
            //}
            //else {
            posGrid.removeRow(row);
            if (item.APK && item.APK.length > 0) {
                itemClone = JSON.parse(JSON.stringify(item));

            }
            //}
        },
        function () {
            ////console.log('User clicked NO');
        }
    );
    return false;
}

/**
* delete voucher
*/
function gridEditor_Change(e) {
    posViewModel.callTotal();
    posViewModel.gridDataSourceChanged = true;
    return true;
}

/**
* Close popup
*/
function btnClose_Click(event) {
    if (posViewModel.isDataChanged()) {
        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016'),
            //yes
            function () {
                posViewModel.save(null, 0);
            },
            //no
            function () {
                posViewModel.close();
            });
    } else {
        //Close popup
        posViewModel.close();
    }
}

/**
* Close popup
*/
function inherit_Close(event) {
    //Close popup
    ASOFT.asoftPopup.hideIframe();
}

/*
* Inherit click
*/
function inherit_Click(e) {
    var data = {};
    ASOFT.asoftPopup.showIframe('/POS/POSF00172', data);
    return false;
}

/**
* Change combox
*/
function cboEmployeeID_Cascade(e) {
    var dataItem = this.dataItem(this.selectedIndex);
    if (!posViewModel) {
        return;
    }
    if (dataItem == null) {
        return null;
    };

    // get tranmonth, tranyear value
    posViewModel.set('EmployeeName', dataItem.Name);
    posViewModel.set('EmployeeID', dataItem.ID);
}

/**
* Save
*/
function btnSaveNew_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(null, 1);
        },
        null
    );
}

/**
* Save and copy
*/
function btnSaveCopy_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            if (posViewModel.isDataChanged()) {
                posViewModel.save(null, 2);
            }
        }, null);
}

/**
* Save and copy
*/
function btnUpdate_Click(e) {
    if (posViewModel.isDataChangedOffGrid() || posViewModel.gridDataSource.hasChanges()) {
        ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(null, 3);
        });
    }
}

/**
* Grid Save
*/
function Grid_Save(e) {
    if (e.values == null) {
        return true;
    }
    var cboInventoryIDModel = e.values.CboInventoryName;
    //Business
    if (cboInventoryIDModel) {
        var currentlySelectedValue = $(e.container.find('#CboInventoryName')[0]).data('kendoComboBox').value();
        e.model.set('InventoryID', currentlySelectedValue);
        e.model.set('InventoryName', cboInventoryIDModel.InventoryName);
        e.model.set('UnitName', cboInventoryIDModel.UnitName);
        e.model.set('UnitID', cboInventoryIDModel.UnitID);
        e.model.set('UnitName', cboInventoryIDModel.UnitName);
        e.model.set('WareHouseID', cboInventoryIDModel.WareHouseID);
        e.model.set('WareHouseName', cboInventoryIDModel.WareHouseName);
        e.model.set('UnitName', cboInventoryIDModel.UnitName);
        e.model.set('MarkQuantity', cboInventoryIDModel.MarkQuantity);
        e.model.set('ActualQuantity', cboInventoryIDModel.ActualQuantity);
    }
}

/**
* Gen delete button
*/
function genDeleteBtn(data) {
    return "<a href='\\#' onclick='return deleteVoucher_Click(this)' class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
}

/**
* Xử lý hiển thị BookQuantity
*/
function getBooksQuantity(data) {
    if (data) {
        return data.BooksQuantity;
    }
    return 0;
}

/**
* Xử lý hiển thị ActualQuantity
*/
function getActualQuantity(data) {
    if (data) {
        return data.ActualQuantity;
    }
    return 0;
}

/**
* Xử lý hiển thị AdjustQuantity
*/
function getAdjustQuantity(data) {
    if (data) {
        return data.AdjustQuantity;
    }
    return 0;
}

/**
* Lấy từ khóa để lọc dữ liệu cho autoComplete
*/
function getKeyWord() {
    var keyWord = $('#IntentoryOrBardcode').val().trim();
    return {
        'keyWord': keyWord
    };
}

function autoCompleteHeaderTemplate() {
    return '<div class="dropdown-header">' +
                '<span class="k-widget k-header">Photo</span>' +
                '<span class="k-widget k-header">Contact info</span>' +
            '</div>';
}
/**
* Hiển thị log message
*/
function logMsg(msg) {
    //console.log(msg);
}

/**
* Cập nhật dataSource hiển thị lên lưới
*/
function refreshGrid() {
    posGrid.refresh();
}

function isEmpty(val) {
    return (val === undefined || val == null || val.length <= 0) ? true : false;
}