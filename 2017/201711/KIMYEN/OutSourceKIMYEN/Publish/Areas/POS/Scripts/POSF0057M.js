//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/04/2014      Chánh Thi         Tạo mới
//####################################################################

var ASOFT = ASOFT || {},
    isSearch = false;

$(document).ready(function () {
    var
        btnSearchMember = $('#btnSearchMember'),
        btnCancel = $('#btnCancel'),
        btnChoose = $('#btnChoose'),
        element = $('#GridInventoryID'),
        grid = element.data('kendoGrid'),
        searchTextBox = $('#InventoryID')
    //isSearch = false
    ;

    searchTextBox.on('keypress', inventoryFilter_KeyPress);


    // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
    function inventoryFilter_KeyPress(e) {
        if (e.keyCode == 13 && $(this).val()) {
            grid.dataSource.fetch();
        }
    };

    grid.bind('dataBound', function (e) {
        var length = grid.dataSource.data().length;
        element.find('td:nth-child(3n+1)').addClass('asf-cols-align-center');
        initEventOnTableCell();
        searchTextBox.focus().select();
    });

    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        var td_Click = function (index) {
            var checkBox = $($(this).children()[0]);
            checkBox.attr('checked', !checkBox.attr('checked'));
        };

        var ckb_Click = function (e) {
            e.stopPropagation();
        }

        $('td').has('input[type="radio"]:not([disabled])').on('click', td_Click);
        $('input[type="radio"]').on('click', ckb_Click);
    }

    ASOFT.sendDataSearch = function () {
        var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
        datamaster['IsSearch'] = isSearch;
        datamaster['InventoryFilter'] = datamaster['InventoryID'];
        return datamaster;
    };

    btnSearchMember.on('click', btnSearchMember_Click);
    btnChoose.on('click', btnChoose_Click);
    btnCancel.on('click', ASOFT.asoftPopup.closeOnly);
    searchTextBox.on('keypress', function (e) {
        if (e.keyCode === 13) {
            btnSearchMember_Click();
            searchTextBox.focus();
        }
    });

    function btnSearchMember_Click() {
        isSearch = true;
        grid.dataSource.page(1);
    }

    function btnChoose_Click(e) {
        var checkedRadio = $('input[name=radio-check]:checked'),
            selectedMemberID = checkedRadio.attr('data-member-id'),
            selectedMemberName = checkedRadio.attr('data-member-name'),
            unitID = checkedRadio.attr('data-unit-id'),
            unitName= checkedRadio.attr('data-unit-name');

        if (!selectedMemberID) {
            console.log('NO MEMEBER CHOOSEN');
        } else {
            window.parent.recieveResult({
                InventoryID: selectedMemberID,
                InventoryName: selectedMemberName,
                UnitID: unitID,
                UnitName: unitName
            });
        }

        ASOFT.asoftPopup.closeOnly();
    }


});
///**
//* Đóng popup
//*/
//function Cancel_Click(event) {
//    parent.inherit_Close(event);
//}

//function posf00202Choose_Click() { }

// Hàm gởi dữ liệu từ FormFilter
function sendDataSearch() {
    var datamaster = ASOFT.helper.dataFormToJSON('FormFilter');
    datamaster['IsSearch'] = isSearch;
    datamaster['InventoryFilter'] = datamaster['InventoryID'];
    return datamaster;
}

//function btnSearchMember_Click() {
//    isSearch = true;
//    POSF00202Grid.dataSource.page(1);

//}

var POSF0030 = {};

$(document).ready(function () {
    console.log(arguments);
    var URL_SAVE = '/POS/POSF0012/SaveSelectedInventories';
    var GRID_ID = '#GridInventoryID';
    var FORM_ID = '#POSF0030';
    var FORM_NAME = 'POSF0030';
    var defautSelected = [];
    var resultSelected = [];
    var view = {};
    var posGrid = $(GRID_ID).data('kendoGrid');
    var log = console.log;

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

        // Khởi tạo danh sách các mặt hàng được chọn 
        // Khi lưới nhận dữ liệu từ server
        posGrid.dataSource.bind('requestEnd', dataSource_RequestEnd);

        // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
        $('#InventoryFilter').on('keypress', inventoryFilter_KeyPress);
        // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
        //initEventOnTableCell();
    }
    // Khởi tạo sự kiện click lên một ô chứa checkbox "chọn"
    function initEventOnTableCell() {
        var td_Click = function (index) {
            var checkBox = $($(this).children()[0]);
            checkBox.attr('checked', !checkBox.attr('checked'));
        };

        $('td').has('input[data-inventoryid]').each(function (i) {
            $(this).on('click', td_Click);

        });
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
        //$('#GridSelectInventories input[type="checkbox"]').each(function (index) {
        //    if (resultSelected.indexOf($(this).data('inventoryid')) !== -1) {
        //        $(this).attr('checked', true);
        //    }
        //});
    }

    // Thêm mã mặt hàng vào danh sách các mã được chọn từ đầu
    function joinToDefaultSeleted(idList) {

    };

    // Xử lý sự kiện ấn phím trong text box tìm mã hàng hóa
    function inventoryFilter_KeyPress(e) {
        if (e.keyCode == 13 && $(this).val()) {
            posGrid.dataSource.fetch();
        }
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


