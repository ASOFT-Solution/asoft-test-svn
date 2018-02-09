//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/07/2014      Thai Son        Update
//####################################################################

// Xử lý tìm mặt hàng để đổi/trả

// Đối tượng toàn cục để interface với các hàm khác
var POSVIEW = POSVIEW || {};

// Hàm lấy dữ liệu form làm filter cho lưới
function sendDataSearch() {
    return ASOFT.helper.dataFormToJSON('FormFilter')
};

$(document).ready(function () {
    var
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = true,

        // lấy ra đối tượng global (window)
        global = function () { return this }(),

        // Tên lưới
        GRID_NAME = 'GridInventorySearch',

        // tên form
        FORM_NAME = 'FormFilter',

        // css selector cho các button trên màn hình
        BUTTON_SELECTOR = '.k-button',

        // Checked checkbox selector
        CHECKED_CHECKBOX_SELECTOR = "input[name='checkbox']:checked:enabled",

        // reference đối tượng kendo grid
        grid = $("#" + GRID_NAME).data("kendoGrid"),

        dataSource = grid.dataSource,

        // hàm log viết gọn
        //LOG = console.log,
        LOG = function(){},

        // Đối tượng chứa các hàm event-handler
        events = {},

        // URL của màn hình bán hàng
        url = getAbsoluteUrl("POSF0016/POSF00161"),

        // iframe chứa màn hình bán hàng
        ifFrameID = 'externalIframe',

        // hàm viết gọn
        formToJSON = ASOFT.helper.dataFormToJSON,

        // array chứa các inventoryID được chọn (checked)
        selectedIDs = [],
        selectedItems = [],

        apkDetail = $('#APK').val(),

        originalInventoryID = $('#OriginInventory').val()
    ;

    // Hàm khởi tạo màn hình
    function init() {
        // Khởi tạo hàm LOG
        initLOG();

        //grid.bind('dataBound', initButtonEvent);
        initButtonEvent();

        // Khởi tạo sự kiện cho cột checkbox trên lưới
        // Khi grid load dữ liệu mới
        grid.bind('dataBound', initCheckBoxEvent);
    }

    // Override hàm log
    function initLOG() {
        // Nếu không debug, thì hàm LOG đặt thành rỗng
        if (!DEBUG) {
            LOG = function () { };
            return;
        }

        // Tạo hàm log
        if (Function.prototype.bind) {
            LOG = Function.prototype.bind.call(console.log, console);
        }
        else {
            LOG = function () {
                Function.prototype.apply.call(console.log, console, arguments);
            };
        }
    }


    // Khởi tạo sự kiện của nút
    function initButtonEvent(e) {
        $(BUTTON_SELECTOR).on('click', function (e) {
            var
                // tạo đối tượng jquery của button
                element = $(this),
                // đọc ra thuộc tính data-event-handler
                eventString = element.attr('data-event-handler');

            // Kiểm tra xem sự kiện có được khai báo hay chưa
            // (tức là kiểm tra xem đối tượng events
            // có thuộc tính nào có tên giống như eventString hay không)
            if (events.hasOwnProperty(eventString)) {
                // Nếu có thì kiểm tra xem thuộc tính đó có phải 
                // là một function hay không
                // Nếu phải thì execute, với this là button được click
                var eventHandler = events[eventString];
                if (isFunction(eventHandler)) {
                    events[eventString].call(this, e);
                }
            }
        });
    }

    // Khởi tạo sự kiện cho cột checkbox trên lưới
    function initCheckBoxEvent() {
        // Khởi tạo sự kiện cho các checkbox
        $("input[name='checkbox']").on('click', function (e) {
            var checkBox = $(this);
            addSelectedCheckBox(checkBox);
            // chặn sự kiện click "chain reaction" lên thẻ <td>
            e.stopPropagation();
        });

        // Khởi tạo sự kiện cho các ô <td> chứa checkbox
        // (tăng tính tiện dụng)
        $("input[name='checkbox']").closest('td').on('click', function (e) {
            var checkBox = $(this).find('input[name="checkbox"]');
            checkBox.attr('checked', !checkBox.attr('checked'));
            addSelectedCheckBox(checkBox);
            e.stopPropagation();
        });

        // Check vào các checkbox đã được chọn trước đó
        selectedIDs.forEach(function (id) {
            var checkBox = $("input[data-inventoryid='{0}']".format(id));
            //LOG(checkBox);
            if (checkBox.length > 0) {
                $(checkBox[0]).attr('checked', 'checked');
            }
        });
    }

    // Thêm một id mới vào danh sách
    // dựa trên trạng thái hiện tại của checkbox
    function addSelectedCheckBox(checkBoxElement) {
        var
            // lấy ra trạng thái check của checkbox
            checked = checkBoxElement.is(':checked'),

            // lấy ra thuộc tính 'data-inventoryid'
            inventoryID = checkBoxElement.attr('data-inventoryid'),
            
            item = getItemByID(inventoryID)
        ;

        if (!item) {
            return;
        }
        
        // nếu checkbox đang có trạng thái checked
        // thì thêm id vào danh sách id
        // nếu không thì xóa bỏ id khỏi danh sách
        if (checked) {
            addStringToArray(inventoryID, selectedIDs);
            addItemToArray(item, selectedItems);
        } else {
            removeStringFromArray(inventoryID, selectedIDs);
            removeItemFromArray(item, selectedItems);
        }


    }

    // Tìm một item trong danh sách dựa vào id
    function getItemByID(id) {
        var i = 0,
            l = dataSource.total(),
            item
        ;

        for (; i < l; i += 1) {
            item = dataSource.at(i);
            if (item.InventoryID === id) {
                return item;
            }
        }
    }

    // Thêm một item vào danh sách
    function addItemToArray(item, arr) {
        var i = 0,
            l = arr.length,
            oldItem
        ;

        for (; i < l; i++) {
            oldItem = arr[i];
            if (oldItem.InventoryID === item.InventoryID) {
                return;
            }
        }
        arr.push(item);
    }

    // Bỏ một item khỏi danh sách
    function removeItemFromArray(item, arr) {
        var i = 0,
            l = arr.length,
            oldItem
        ;

        for (; i < l; i++) {
            oldItem = arr[i];
            if (oldItem.InventoryID === item.InventoryID) {
                arr.splice(i, 1);
                return;
            }
        }
    }

    // hàm thêm một chuỗi vào một array chứa chuổi
    function addStringToArray(str, arr) {
        var index = arr.indexOf(str);
        if (index !== -1) {
            return;
        }
        arr.push(str);
    }

    // hàm xóa một chuỗi khỏi một array chứa chuổi
    function removeStringFromArray(str, arr) {
        var index = arr.indexOf(str);
        if (index === -1) {
            return;
        }
        arr.splice(index, 1);
    }

    // Tạo các hàm xử lý sự kiện cho gán vào đối tượng events
    // Sự kiện click nút tìm
    events.btnSearch_Click = function (e) {
        LOG('btnSearch_Click');
        refreshGrid();
    }

    // Sự kiện click nút chọn
    events.btnChoose_Click = function (e) {
        if (global.parent && global.parent !== global) {
            if (isFunction(global.parent.btnChoose_Click)) {
                global.parent.btnChoose_Click(apkDetail, selectedItems);
            }
        }

        ASOFT.asoftPopup.closeOnly();
    }

    // Sự kiện click nút đóng
    events.btnCancel_Click = function (e) {
        LOG('btnCancel_Click');
        ASOFT.asoftPopup.closeOnly();
    }

    // Load lại lưới theo điều kiện lọc hiện tại
    function refreshGrid() {
        grid.dataSource.fetch();
        LOG('Reset selected inventory list');
        selectedIDs = [];
    }

    // Kiểm tra tham số truyền vào có phải một function hay không
    function isFunction(functionToCheck) {
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    }

    // Khởi tạo
    init();
});
