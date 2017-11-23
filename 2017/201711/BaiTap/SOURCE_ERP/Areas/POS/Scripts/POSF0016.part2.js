//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/07/2014      Thai Son        Tạo mới
//####################################################################

// Xử lý hiển thị đổi hàng trả hàng, trên màn hình danh mục phiếu bán hàng

$(document).ready(function () {
    var
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = true,

        // Tên của lưới danh mục
        GRID_NAME = 'POSF0016Grid',

        // css selector của các nút đổi hàng / trả hàng
        GRID_BUTTON_SELECTOR = "#{0} a.k-button".format(GRID_NAME),

        // css selector của các nút in phiếu giao hàng
        //GRID_BUTTON_PRINT = "#{0} a.k-button-print".format(GRID_NAME),

        // reference kendo grid
        grid = $("#" + GRID_NAME).data("kendoGrid"),

        // hàm log viết gọn, sẽ được override trong hàm initLOG
        LOG = console.log,

        // Đối tượng chứa các hàm xử lý sự kiện
        events = {},

        // URL dẫn đến màn hình bán hàng
        url = getAbsoluteUrl("POSF0016/POSF00161"),

        // Tên của thẻ iframe
        ifFrameID = 'externalIframe'
        
    ;

    // Khởi tạo
    function init() {
        // Khi grid nhận dữ liệu mới
        // Thì gán lại sự kiện click cho các nút đổi/trả
        grid.bind('dataBound', initButtonEvent);
        ASOFTCORE.start('master-data', false);
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
                cVoucherNo = element.attr('data-cvoucher-no'),
                
                receipt = element.attr('data-receipt'),

                vouchertype = element.attr('data-vouchertype'),

                apk = element.attr('data-apk'),

                exportstatus = element.attr('data-exportstatus')
            ;

            // Nếu pVoucherNo hoặc cVoucherNo khác null
            // (phiếu hiện tại là phiếu đổi/trả hàng
            // Thì không mở màn hình bán hàng để update
            if ((pVoucherNo !== 'null' || cVoucherNo !== 'null') && vouchertype == null) {
                LOG('No sale voucher');
                return;
            }            

            // Mở màn hình bán hàng
            if (vouchertype == null)
                openFullSreen(apk, status);
            else
            {
                if (vouchertype == 1 && receipt == 1) {
                    var UrlPOSF0081 = "/PopupMasterDetail/Index/POS/POSF0081?APKPOST00161=" + apk;
                    //var UrlPOSF0081 = ["/PopupMasterDetail/Index/POS/POSF0081?pk=", apk, "&table=POST00801", "&key=APK"].join("");
                    ASOFT.asoftPopup.showIframe(UrlPOSF0081, {});
                }

                if (vouchertype == 1 && exportstatus == 1) {
                    var UrlPOSF00281 = "/POS/POSF0027/POSF00282?APKPOST0016=" + apk;
                    //var UrlPOSF0081 = ["/PopupMasterDetail/Index/POS/POSF0081?pk=", apk, "&table=POST00801", "&key=APK"].join("");
                    ASOFT.asoftPopup.showIframe(UrlPOSF00281, {});
                }
            }

        });

        $(GRID_BUTTON_SELECTOR).each(function (index, btn) {
            var
                // tạo đối tượng jquery cho nút
                element = $(btn),

                // mã phiếu parent
                pVoucherNo = element.attr('data-pvoucher-no'),

                // mã phiếu children
                cVoucherNo = element.attr('data-cvoucher-no'),

                receipt = element.attr('data-receipt'),

                vouchertype = element.attr('data-vouchertype'),

                apk = element.attr('data-apk'),

                exportstatus = element.attr('data-exportstatus')
            ;

            // Nếu pVoucherNo hoặc cVoucherNo khác null
            // Thì disable nút hiện tại
            if (pVoucherNo !== 'null' || cVoucherNo !== 'null') {
                if (vouchertype == null) {
                    element.removeClass('asf-btn-plus');
                    element.addClass('asf-btn-plus-disable');
                }
            }

            if (vouchertype != null)
            {
                if (vouchertype == 0 || receipt == 0) {
                    element.removeClass('asf-btn-plus');
                    element.addClass('asf-btn-plus-disable');
                }
                if (vouchertype == 0 || exportstatus == 0) {
                    element.removeClass('asf-btn-plus');
                    element.addClass('asf-btn-plus-disable');
                }
            }

        });

        //$(GRID_BUTTON_PRINT).on('click', function (e) {
        //    var
        //        // tạo đối tượng jquery cho nút
        //        element = $(this),

        //        apk = element.attr('data-apk'),

        //        vouchertype = element.attr('data-vouchertype'),

        //        exportstatus = element.attr('data-exportstatus')
        //    ;

        //    if (vouchertype == 1)
        //    {
        //        if (exportstatus == 0) {
        //            ASOFT.helper.postTypeJson("/POS/POSF0016/CheckExportStatus", { apk: apk }, function (result) {
        //                if (result.Status == 1) {
        //                    var message = [ASOFT.helper.getMessage(result.Message)];
        //                    ASOFT.form.displayMultiMessageBox("FormFilter", 1, message);
        //                    return;
        //                }
        //                else {
        //                    PrintExport(apk);
        //                }
        //            })
        //        }
        //        else {
        //            PrintExport(apk);
        //        }
        //    }
        //});

        //$(GRID_BUTTON_PRINT).each(function (index, btn) {
        //    var
        //       // tạo đối tượng jquery cho nút
        //       element = $(btn),

        //       vouchertype = element.attr('data-vouchertype'),

        //       exportstatus = element.attr('data-exportstatus')
        //    ;

        //    if (vouchertype != 1)
        //    {
        //        element.removeClass('k-button-print');
        //        element.addClass('k-button-print-disable');
        //    }
        //});
    }

    function PrintExport(apk) {   
        ASOFT.helper.postTypeJson("/POS/POSF0016/DoPrintOrExport", { apkMaster: apk }, ExportSuccess);
    }

    function ExportSuccess(result) {
        if (result) {
            var urlPrint = '/POS/POSF0016/ReportViewer';
            var options = '&viewer=pdf';
            // Tạo path full
            var fullPath = urlPrint + "?id=" + result.apk + options;

            // Getfile hay in báo cáo
            window.open(fullPath, "_blank");
            refreshGrid();
        }
    }

    // Mở màn hình phiếu bán hàng (full screen)
    function openFullSreen(APK, status) {
        //show iframe for full screen
        var ifFrameSector = $(kendo.format("#{0}", ifFrameID));
        if (navigator.appName == 'Microsoft Internet Explorer') {
            window.open(url, "secondWindow",
                "fullscreen,scrollbars='yes',statusbar='yes',location='no'").focus();

        } else //if (screenfull.enabled) 
        {
            document.addEventListener(screenfull.raw.fullscreenchange, function () {
                if (!screenfull.isFullscreen) {
                    ifFrameSector.hide();
                    ifFrameSector.attr('src', '');
                }
            });
            if (APK != undefined && $.isPlainObject(APK)) {
                ifFrameSector.attr('src', url);
            } else {
                ifFrameSector.attr('src', kendo.format("{0}/{1}?status={2}", url, APK, status));
            }
            $("#Header").css("z-index", "0");
            ifFrameSector.show();
            //screenfull.request(document.getElementById(ifFrameID));
        }
        return false;
    }
       

    // Kiểm tra tham số truyền vào có phải function không
    function isFunction(functionToCheck) {
        var getType = {};
        return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    }

    
    // Khởi tạo
    init();
    
});
