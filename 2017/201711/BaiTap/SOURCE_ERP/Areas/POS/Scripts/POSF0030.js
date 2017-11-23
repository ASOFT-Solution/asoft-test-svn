//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/04/2014      Chánh Thi         Tạo mới
//####################################################################


var POSF0030 = {};

$(document).ready(function () {
    console.log(arguments);
    var URL_SAVE = '/POS/POSF0012/SaveSelectedInventories';
    var GRID_ID = '#GridSelectInventories';
    var FORM_ID = '#POSF0030';
    var FORM_NAME = 'POSF0030';
    var defautSelected = [];
    var resultSelected = [];
    var view = {};
    var posGrid = $(GRID_ID).data('kendoGrid');
    var log = console.log;

    $("#GridSelectInventories").data('kendoGrid').bind('dataBound', function (e) {
        var checkALL = [];
        $('#GridSelectInventories input[type="checkbox"][id != "chkAll"]').each(function (index) {
            if (this.checked) {
                checkALL.push($(this).data('inventoryid'));
            }
        });

        if (checkALL.length == $("#GridSelectInventories").data('kendoGrid')._data.length) {
            $("#chkAll").attr("checked", "checked");
        }
        else {
            $("#chkAll").attr("checked", false);
        }
    }); 

    // Khởi tạo xử lý các sự kiện
    function initEvents() {
        // Tự động ấn thông báo khi có thao tác mới
        var elementIDs = [
            'btnInventoryIDFilter',
            'btnSave'
        ];
        ASOFT.helper.initAutoClearMessageBox(elementIDs, GRID_ID);

        // Tự động focus vào text box tìm mã hàng hóa
        posGrid.bind('dataBound', grid_DataBound);
        // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
        $('#InventoryFilter').on('keypress', inventoryFilter_KeyPress);

        // Khởi tạo danh sách các mặt hàng được chọn 
        // Khi lưới nhận dữ liệu từ server
        posGrid.dataSource.bind('requestEnd', dataSource_RequestEnd);
    
    }
    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        var td_Click = function (index) {
            var checkBox = $($(this).children()[0]);
            checkBox.attr('checked', !checkBox.attr('checked'));
        };

        var ckb_Click = function (e) {
            e.stopPropagation();
        }

        $('td').has('input[type="checkbox"]').on('click', td_Click);
        $('input[type="checkbox"]').on('click', ckb_Click);
    }

    function arrayUnique(array) {
        var a = array.concat();
        for (var i = 0; i < a.length; ++i) {
            for (var j = i + 1; j < a.length; ++j) {
                if (a[i] === a[j])
                    a.splice(j--, 1);
            }
        }
        return a;
    };

    // Khởi tạo danh sách các mặt hàng được chọn 
    // Khi lưới nhận dữ liệu từ server
    function dataSource_RequestEnd(e) {
        var i = 0;
        var data = e.response.Data;
        var l = data.length;
        var inventory = null;
        var result = [];
        for (i = 0; i < l; i++) {
            inventory = data[i];
            if (inventory.Selected === 1) {
                result.push(inventory.InventoryID);
            }
        }
        defautSelected = result;
        return result;
    }
    // Khởi tạo danh sách các mặt hàng được chọn 
    // Khi lưới nhận dữ liệu từ server
    function getDefaultSelectedFromResponse(e) {
        var i = 0;
        var data = e.response.Data;
        var l = data.length;
        var inventory = null;
        var result = [];
        for (i = 0; i < l; i++) {
            inventory = data[i];
            if (inventory.Selected === 1) {
                result.push(inventory.InventoryID);
            }
        }
        defautSelected = arrayUnique(defautSelected.concat(result));

        log('getDefaultSelectedFromResponse')
        log(defautSelected);
        return result;
    };

    // Lấy tất cả mặt mã mặt hàng đang được chọn
    function getResultSeleted() {
        var result = [];
        $('#GridSelectInventories input[type="checkbox"]').each(function (index) {
            if (this.checked) {
                result.push($(this).data('inventoryid'));
            }
        });
        return result;
    };

    function grid_DataBound() {
        $('#InventoryFilter').focus().select();
        initEventOnTableCell();
    }

    // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
    function inventoryFilter_KeyPress(e) {
        if (e.keyCode == 13 && $(this).val()) {
            posGrid.dataSource.fetch();
        }
    };

    // Thêm mã mặt hàng vào danh sách các mã được chọn từ đầu
    function joinToDefaultSeleted(idList) {

    };

   

    // Lấy tất cả mặt mã mặt hàng đang được chọn
    function getSelectedInventoryIDs() {
        var result = [];
        $('#GridSelectInventories input[type="checkbox"]').each(function (index) {
            if (this.checked) {
                result.push($(this).data('inventoryid'));
            }
        });
        return result;
    };

    // Lấy tất cả mặt mã mặt hàng đang có trên lưới hiện tại
    function getAllInventoryID() {
        var result = [];
        $('#GridSelectInventories input[type="checkbox"]').each(function (index) {
            result.push($(this).data('inventoryid'));
        });
        return result;
    };

    function saveSelectedInventories(afterSaveHandler) {
        var data = getData();
        ASOFT.helper.postTypeJson(URL_SAVE, data, afterSaveHandler);
    };

    // Kết tạo dữ liệu để lưu
    function getData() {
        var data = {};
        resultSelected = getSelectedInventoryIDs();
        data['defautSelected'] = defautSelected;
        data['resultSelected'] = resultSelected;
        data['shopID'] = $('#ShopIDFilter').data('kendoComboBox').dataItem().ShopID;
        data['allIDs'] = getAllInventoryID();
        return data;
    };

    // Load lại dữ liệu cho lưới
    function refreshGrid() {
        posGrid.dataSource.fetch();
    };

    // Kiểm tra 2  array chứa các phần tử (chuổi, số) giống nhau
    function hasSameElements(array1, array2) {
        var result = $(array1).not(array2).length == 0 && $(array2).not(array1).length === 0;
        return result;
    }

    // Tạo dữ liệu từ form filter
    view.filterData = function () {
        var data = ASOFT.helper.dataFormToJSON(FORM_NAME);
        return data;
    };

    // Xử lý nút đóng
    view.btnClose_Click = function () {
        var currentSeleted = getSelectedInventoryIDs();
        // nếu danh sách các mặt hàng được chọn không có gì thay đổi, thì đóng popup
        if (hasSameElements(currentSeleted, defautSelected)) {
            ASOFTVIEW.closeOnly();
        }

        var save = function () {
            saveSelectedInventories(function (result) {
                if (result.Status != 0) {
                    ASOFT.form.displayWarning(
                        FORM_ID,
                        ASOFT.helper.getMessage(result.MessageID));
                }
                else {
                    if (window.parent != window) {
                        window.parent.refreshGrid();
                    }
                    defautSelected = currentSeleted;
                    ASOFTVIEW.closeOnly();
                }
            });
        };

        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), save, ASOFTVIEW.closeOnly);
    };

    // Xử lý lưu dữ liệu
    view.btnSave_Click = function () {
        // Hàm lưu dữ liệu
        var save = function () {
            saveSelectedInventories(function (result) {
                // Nếu lưu KHÔNG thành công
                if (result.Status != 0) {
                    ASOFT.form.displayWarning(
                        FORM_ID,
                        ASOFT.helper.getMessage(result.MessageID));
                } else { // Nếu lưu KHÔNG thành công
                    ASOFT.form.displayInfo(
                        FORM_ID,
                        ASOFT.helper.getMessage(result.MessageID));
                    refreshGrid();
                    if (window.parent != window) {
                        window.parent.refreshGrid();
                    }
                    //defautSelected = resultSelected;
                }
            });
        };
        // Hiển thị confirm và lưu
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), save);
    }

    // Xử lý sự kiện click nút tìm
    view.btnInventoryIDFilter_Click = function () {
        posGrid.dataSource.fetch();
        $('#CurrentShop').text($('#ShopIDFilter').data('kendoComboBox').dataItem().SHopName);
    };

    POSF0030 = view;

    initEvents();
});

// Xử lý sự kiện click nút đóng
function btnClose_Click() {
    POSF0030.btnClose_Click();
}

// Xử lý sự kiện click nút lưu
function btnSave_Click() {
    POSF0030.btnSave_Click();
}

function filterData() {
    if (POSF0030.filterData) {
        return POSF0030.filterData();
    }
    return {};
}

// Xử lý sự kiện click nút tìm
function btnInventoryIDFilter_Click() {
    POSF0030.btnInventoryIDFilter_Click();
};


function checkAllCustom(e) {
    var state = $(e).is('.chkbx:checked');
    var listCheckBox = null;
    var gridDOM = $(e).closest('div.asf-grid');
    var checkDatas = [];
    if (gridDOM != undefined) {
        var id = gridDOM.prop('id');
        var sector = kendo.format("#{0} {1}", id, ".chkbx");
        listCheckBox = $(sector);
        listCheckBox.prop('checked', state);
        var grid = ASOFT.asoftGrid.castName(id);
        checkDatas = getDataCheckedCustom(grid);
    }
    return { check: state, items: checkDatas };
}

getDataCheckedCustom = function (grid) {
    var checkDatas = [];
    if (grid != undefined) {
        var data = grid.dataSource.data();
        var id = grid.element.prop('id');
        var sector = kendo.format("#{0} {1}", id, ".chkbx:checked");
        var items = $(sector);
        items.each(function (index, item) {
            var tr = $(item).closest('tr');
            if ($(item).closest('td').length > 0) {
                var rowIndex = tr.index();
                var row = data[rowIndex];
                checkDatas.push(row);
            }
        });
    }
    return checkDatas;
};