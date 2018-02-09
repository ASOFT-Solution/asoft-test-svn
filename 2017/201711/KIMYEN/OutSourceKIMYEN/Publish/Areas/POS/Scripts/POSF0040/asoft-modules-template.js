//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//#     27/08/2014      Thai Son        Update
//####################################################################

// Template cho một module
ASOFTCORE.create_module('POSF0041-module', function (sb) {
    // Khai báo tất cả các biến private
    var
        // Nêu sử dụng hàm log sau:
        log = ASOFTCORE.log,
        someVar = 0,
        otherVar = null,
        someElement = null;

    // Hàm xử lý sự kiện, 
    // data do module phát sinh sự kiện truyền vào
    function eventHandler(data) {
        if (data) {
            // TO DO
        }
    }

    // return object với tất cả các phương thức public
    // bắt buột phải có 2 hàm init, và destroy
    return {
        // Hàm được core gọi tự động khi start module
        init: function () {
            log('module starting ...');
            // cú pháp thêm một sự kiện click vào một element
            sb.addEvent(someElement, "click", this.quitSearch);

            // cú pháp đăng ký xử lý một sự kiện do module khác phát sinh
            sb.listen({
                'some-event': eventHandler,
                'some-extra-event': this.otherEventHandler,
            });

            // cú pháp để module
            // Type: chính là tên của sự kiện
            // Data: là bất kỳ thứ gì cần truyền vào hàm xử lý sự kiện
            sb.notify({
                type: 'do-some-thing',
                data: anything
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
                type: 'do-some-thing',
                data: query
            });

        },
    };
});

// Cú pháp để start một module khi start page/popup/...
$(document).ready(function () {
    window.parent.ASOFTCORE.start('choose-tables', true);
});

// Cú pháp để stop một module khi close page/popup/...
$(window).unload(function () {
    window.parent.ASOFTCORE.stop('choose-tables');
});
