//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

// module xử lý các sự kiện trên các nút tác vụ của màn hình bán hàng

// Template cho một module
ASOFTCORE.create_module('task-buttons', function (sb) {
    var
        LOG = ASOFTCORE.log,
        someVar = 0,
        otherVar = {},
        buttonList = [],
        Button;

    // hàm khởi tạo đối tượng button (lưu ý, không dùng "new")
    function Button(btnID) {
        var b = {};

        // lấy jQuery của button
        b.jElement = $('#' + btnID);

        // lấy ra tên sự kiện
        b.eventHandlerAttr = b.jElement.attr('data-event-handler');

        // kích hoạt sự kiện
        b.enableEvent = function () {
            // set lại tên sự kiện
            this.jElement.attr('data-event-handler', this.eventHandlerAttr);
            // bỏ class 'asf-btn-disabled' để hiện rõ button
            this.jElement.removeClass('asf-btn-disabled');
        };

        // disable button, bằng cách set rỗng thuộc tính 'data-event-handler'
        b.disableEvent = function () {
            this.jElement.attr('data-event-handler', '');
            // thêm class 'asf-btn-disabled' để "làm mờ" button
            this.jElement.addClass('asf-btn-disabled');
        };

        return b;
    };

    // disable button theo tên (id) button
    function disableButtonByID(btnID) {
        Button(btnID).disableEvent();
    }

    // enable tất cả các nút trong danh sách
    function enableAll() {
        buttonList.forEach(function (button) {
            button.enableEvent();
        });
    }

    // disable tất cả các nút trong danh sách
    function disableAll() {
        buttonList.forEach(function (button) {
            button.disableEvent();
            button.jElement.off();
        });
    }

    // disable các nút trong danh sách khi màn hình ở trạng thái edit
    function disableAllOnEdit() {
        buttonList.forEach(function (button) {
            button.disableEvent();
        });
        disableButtonByID('btnChooseTable');
    }

    return {
        // Hàm được core gọi tự động khi start module
        init: function () {
            // Thêm khởi tạo danh sách các button
            buttonList.push(Button('btnChooseDish'));
            buttonList.push(Button('btnMergeSplitTable'));
            buttonList.push(Button('btnMergeSplitBill'));
            buttonList.push(Button('btnReturnedInventory'));
            buttonList.push(Button('btnPromotion'));
            buttonList.push(Button('btnPrintProcessDish'));

            if (ASOFTCORE.globalVariables.isEditMode) {
                disableAll();
            }

            sb.listen({
                'enable-task-buttons': enableAll,
                'disable-task-buttons': disableAll,
                'disable-task-buttons-on-edit': disableAllOnEdit
            });

        },

        // Hàm được core gọi tự động khi stop module
        destroy: function () {
            // Cú pháp gỡ bỏ sự kiện trên một element
            sb.removeEvent(someElement, "click", handler);

            // cú pháp bỏ qua các sự kiện mà module này đã đăng ký
            sb.ignore(['change-filter', 'reset-filter', 'perform-search', 'quit-search']);
        },

        // Các phương thức public khác (nếu có)
        otherEventHandler: function () {

            sb.notify({
                type: 'perform-search',
                data: query
            });

        },
    };
});
