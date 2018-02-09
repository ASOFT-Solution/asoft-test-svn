//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     08/08/2014      Thai Son        Tạo mới
//####################################################################

// Xử lý hiển thị đổi hàng , trên màn hình danh mục phiếu bán hàng

$(document).ready(function () {
    var
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = true,

        // Tên của lưới danh mục
        GRID_NAME = 'POSF0039Grid',

        // css selector của các nút đổi hàng / trả hàng
        GRID_BUTTON_SELECTOR = "#{0} a.k-button".format(GRID_NAME),
        GRID_LINK_SELECTOR = "#{0} a.grid-link".format(GRID_NAME),
        // reference kendo grid
        grid = $("#" + GRID_NAME).data("kendoGrid"),

        // hàm log viết gọn, sẽ được override trong hàm initLOG
        LOG = console.log,

        // Đối tượng chứa các hàm xử lý sự kiện
        events = {},

        // URL dẫn đến màn hình bán hàng
        url = getAbsoluteUrl("POSF0039/POSF0040"),

        // Tên của thẻ iframe
        ifFrameID = 'externalIframe'

    ;

    // Khởi tạo
    function init() {
        // Khi grid nhận dữ liệu mới
        // Thì gán lại sự kiện click cho các nút đổi/trả
        grid.bind('dataBound', initGridEvents);

        // Khởi tạo hàm LOG
        initLOG();

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

    function initGridEvents(e) {
        initGridLinkEvent(e);
        initButtonEvent(e);
    }

    // Khởi tạo xử lý sự kiện cho các nút đổi/trả
    function initGridLinkEvent(e) {
        // Khởi tạo sự kiện click
        $(GRID_LINK_SELECTOR).on('click', function (e) {
            var
                // tạo đối tượng jquery cho nút
                element = $(this),

                // lấy ra các thuộc tính cần thiết
                // apk master
                apk = element.attr('data-apk'),

                // trạng thái của detail
                status = element.attr('data-status'),

                // mã phiếu parent
                pVoucherNo = element.attr('data-pvoucher-no'),

                // mã phiếu children
                cVoucherNo = element.attr('data-cvoucher-no'),

                url = "/POS/POSF0039/POSF0040"
            ;

            // Nếu pVoucherNo hoặc cVoucherNo khác null
            // (phiếu hiện tại là phiếu đổi/trả hàng
            // Thì không mở màn hình bán hàng để update
            //if (pVoucherNo !== 'null' || cVoucherNo !== 'null') {
            //    LOG('No sale voucher');
            //    return;
            //}
            if (cVoucherNo !== 'null') {
                url = "/POS/POSF0039/POSF0066/{0}?status={1}".format(apk, status);
            } else {
                url = "/POS/POSF0039/POSF0040/?APK={0}&status={1}".format(apk, status);
            }
            // Mở màn hình bán hàng
            openFullSreen(apk, status, url);

        });
    }

    // Khởi tạo xử lý sự kiện cho các nút đổi/trả
    function initButtonEvent(e) {
        // Khởi tạo sự kiện click
        $(GRID_BUTTON_SELECTOR).on('click', function (e) {
            var
                // tạo đối tượng jquery cho nút
                element = $(this),

                // lấy ra các thuộc tính cần thiết
                // apk master
                apk = element.attr('data-apk'),

                // trạng thái của detail
                status = element.attr('data-status'),

                // mã phiếu parent
                pVoucherNo = element.attr('data-pvoucher-no'),

                // mã phiếu children
                cVoucherNo = element.attr('data-cvoucher-no')
            ;

            // Nếu pVoucherNo hoặc cVoucherNo khác null
            // (phiếu hiện tại là phiếu đổi/trả hàng
            // Thì không mở màn hình bán hàng để update
            if (pVoucherNo !== 'null' || cVoucherNo !== 'null') {
                LOG('No sale voucher');
                return;
            }

            // Mở màn hình bán hàng
            openFullSreen(apk, status);

        });

        $(GRID_BUTTON_SELECTOR).each(function (index, btn) {
            var
                // tạo đối tượng jquery cho nút
                element = $(btn),

                // mã phiếu parent
                pVoucherNo = element.attr('data-pvoucher-no'),

                // mã phiếu children
                cVoucherNo = element.attr('data-cvoucher-no')
            ;

            // Nếu pVoucherNo hoặc cVoucherNo khác null
            // Thì disable nút hiện tại
            if (pVoucherNo !== 'null' || cVoucherNo !== 'null') {
                element.removeClass('asf-btn-plus');
                element.addClass('asf-btn-plus-disable');
            }
        });
    }

    // Mở màn hình phiếu bán hàng (full screen)
    function openFullSreen(APK, status, url) {

        //enterFullScreen();
        if (!url) {
            if (APK) {
                ASOFT.asoftPopup.showIframe('/POS/POSF0039/POSF0066/{0}?status={1}'.format(APK, status), {});
            }
            else {
                ASOFT.asoftPopup.showIframe('/POS/POSF0039/POSF0040', {});
            }
        } else {
            ASOFT.asoftPopup.showIframe(url);
        }
    }


    // Kiểm tra tham số truyền vào có phải function không
    function isFunction(functionToCheck) {
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    }


    // Khởi tạo
    init();

});
