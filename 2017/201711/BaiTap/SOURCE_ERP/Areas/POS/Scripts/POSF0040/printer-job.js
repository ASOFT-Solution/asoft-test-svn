//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

ASOFTCORE.create_module("printer-job", function (sb) {
    var
        // Thời gian timeout cho một request in
        PRINT_TIME_OUT = 5000, // (5s)
        // Thành công (có hồi đáp)
        PRINT_SUCCESS = 1,
        // KHÔNG có hồi đáp
        PRINT_ERROR = 0,
        // Trạng thái hồi đáp hiện tại
        responseStatus = PRINT_ERROR,
        // 
        input,
        // Hàm log thay cho console.log
        LOG = ASOFTCORE.log,
        //defaultPrinterName = 'Foxit Phantom Printer',
        //defaultOrderPrinterName = 'Snagit 10',
        WEB_CLIENT_NAME = 'Web Client',
       // TYPE1 = 'BILL FOOD',
        //TYPE2 = 'BILL DRINKS',

        // Reference đến printer Hub POSF0040
        printerHub = $.connection.Posf0040Hub,

        // Lấy các giá trị của trang web hiện tại
        // .. để hub thêm vào danh sách web client
        userID = $("input[name*='_UserID']").val(),
        divisionID = $("input[name*='_DivisionID']").val(),
        shopID = $("input[name*='_ShopID']").val()
    ;

    // In chế biến
    function printProcess(result) {
        // Chuẩn bị dữ liệu để gửi yêu cầu in lên server
        /*var data = {
            userID: userID,
            divisionID: divisionID,
            shopID: shopID,
            post0033Apk: posViewModel.TempAPKMaster || '657D5426-4803-4396-BA03-A100C1C866F4'
        };*/
        var data = result.Data;
        LOG(data);

        // Kết chuổi để gửi lên server
        // Để thuận tiện: chỉ cần gửi 1 tham số duy nhất
        var stringToSend = JSON.stringify(data);

        // Gỡ sự kiện click của nút 'In chế biến'
        // sb.ignore(['btnPrintProcessDish_Click']);

        // Gửi yêu câu in lên server
        printerHub.server.printProcess(stringToSend);

        // TODO: Đặt thời gian 10s, nếu server không hồi đáp,
        // Thì xem như in không thành công
        setTimeout(considerFailedPrint, PRINT_TIME_OUT);
    }

    function printBill(data) {
        /*var
            // Chuẩn bị dữ liệu để gửi yêu cầu in lên server
            data = {
                userID: userID,
                divisionID: divisionID,
                shopID: shopID,
                post0033Apk: posViewModel.TempAPKMaster || '657D5426-4803-4396-BA03-A100C1C866F4'
            },*/
        // Kết chuổi để gửi lên server
        // Để thuận tiện: chỉ cần gửi 1 tham số duy nhất
        var stringToSend = JSON.stringify(data);

        // Gỡ sự kiện click của nút 'In chế biến'
        sb.ignore(['btnPrintBill_Click']);
        // Gửi yêu câu in lên server
        printerHub.server.printBill(stringToSend);

        // TODO: Đặt thời gian 10s, nếu server không hồi đáp,
        // Thì xem như in không thành công

        setTimeout(considerFailedPrint, PRINT_TIME_OUT);
    }

    // Hàm được gọi nếu sau 10s, server không hồi đáp
    function considerFailedPrint() {
        // Nếu trong 10s giây mà status vẫn là error
        if (responseStatus === PRINT_ERROR) {
            LOG("ERROR: printer Client not responsed");
        } else {

        }
        responseStatus = PRINT_ERROR;
        // Gán lại sự kiện cho nút 'In chế biến'
        resetEventHandlers();
    }

    // Gán lại sự kiện cho các nút 'In ...'
    function resetEventHandlers() {
        // Gán lại sự kiện cho nút 'In chế biến'
        //sb.ignore(['btnPrintProcessDish_Click', 'btnPrintBill_Click']);
        //sb.listen({
        //    'btnPrintProcessDish_Click': printProcess,
        //    'btnPrintBill_Click': printBill
        //});
    }

    return {

        //In chế biến
        printBill: function (apk) {
            printerHub.server.printBill(userID, apk);
        },
        printProcess: printProcess,
        init: function () {
            // Gán hàm xử lý sự kiện cho 2 nút in
            resetEventHandlers();

            // Hàm được server gọi khi in thành công
            printerHub.client.onSuccess = function (ajaxObj) {
                LOG('Success');
                LOG(ajaxObj);
                responseStatus = PRINT_SUCCESS;
                resetEventHandlers();
            };

            // Hàm được server gọi khi in KHÔNG thành công
            printerHub.client.onError = function (ajaxObj) {
                LOG('Error');
                LOG(ajaxObj);
                responseStatus = PRINT_SUCCESS;
                resetEventHandlers();
            };
            //printerHub.client.getPrinterNames = function (printers) {
            //    LOG(printers);
            //};

            /**
            * Máy in không có
            */
            printerHub.client.printerError = function (message) {
                LOG('Máy in không đúng!');
            };

            // Bắt đầu kết nối với hub
            $.connection.hub.start().done(function () {
                // Sau khi kết nối thành công
                // Web sẽ gửi thông tin của nó lên server
                // Để server lưu lại
                var
                    // Chuẩn bị dữ liệu để gửi yêu cầu in lên server
                    data = {
                        divisionID: divisionID,
                        shopID: shopID,
                        userID: userID
                    },
                    // Kết chuổi để gửi lên server
                    // Để thuận tiện: chỉ cần gửi 1 tham số duy nhất
                    stringToSend = JSON.stringify(data);
                // Gửi thông tin xác định web client lên server
                printerHub.server.webClientConnect(stringToSend);
            });


        },

        destroy: function () {
            // sb.ignore([]);
        },
    };
});
