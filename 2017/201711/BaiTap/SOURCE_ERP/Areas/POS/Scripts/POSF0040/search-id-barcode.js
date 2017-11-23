//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

// module điều khiển hoạt động của control search id/barcode
;
// Template cho một module
ASOFTCORE.create_module('search-id-barcode', function (sb) {
    var
        ace,
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = true,

        // Nêu sử dụng hàm log sau:
        LOG = ASOFTCORE.log,
        someVar = 0,
        otherVar = {},
        someElement = null,
        util = ASOFTCORE.utils,
        action = 'GetInventoriesByKeyWord',
        controller = 'POSF0039',
        area = 'POS',
        autoCompleteName = 'InventoryIDBarCode',
        fakeInput,
        TIME_BETWEEN_KEY_PRESS_HUMANLY = 40,

        // Lưới hiển thị chi tiết
         posGrid = null,

        // Biến xác định ấn phím enter trong autoComplete
         ifKey = 0,

        // Biến xác định sự kiện ấn enter đã được xử lý
         ifKeyDone = false,

        // Biến xác định người dùng chọn item bằng cách ấn phím enter
         isSelectedByEnter = 0,

         MULTIFLY_CHARACTER = "*",

         autoComplete,

         currentNumberOfRows = 0,
         milisecond = 0,
         firstStroke = true,
         isHuman = false,
         selectedItem = false,
         searchButtonCaption = $('input[name="_Select"]').val()
    ;

    function initJQueryAutoComplete() {
        ace = $("#asf-barcode-multiselect").asoftAutoMultiSelect({
            kName: 'InventoryIDBarCode',
            kType: 'kendoDropDownList',
            fakeInputName: 'InventoryIDBarCode_input',
            select: function (items) {
                items.forEach(function (item) {
                    item.StatusRecordID = 0;
                });
                chooseDishes(items)
            },
            startDisabled: true,

            showSearchButton: true,
            showFooterButton: false,

            server: {
                controller: "POSF0039",
                action: "GetInventoriesByKeyWord",
                routeArgument: {
                    keyword: "keyWord"
                }
            },

            buttonSelect: {
                show: true,
                caption: searchButtonCaption
            }
        });
    }

    // Hàm xử lý sự kiện click lên nút chọn
    function chooseDishes(items) {
        if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE CHOOSEN');
            ASOFT.asoftPopup.hideIframe();
            return;
        }

        if (!Array.isArray(items)
            || items.length === 0) {
            return;
        }

        var
            i = 0,
            l = items.length,
            inventoryIDList = [],
            inventoryQuantityList = [],
            currentTable = ASOFTCORE.globalVariables.currentTable
        ;

        // Lấy danh sách mã mặt hàng và danh sách số lượng tương ứng
        for (; i < l; i++) {
            inventoryIDList.push(items[i].InventoryID);
            inventoryQuantityList.push(1);
        }

        // Gửi dữ liệu lên server
        // gọi lại hàm afterLoadDishFromServer khi nhận được response
        sb.notify({
            type: 'get-ajax-data',
            data: {
                action: 'GetSelectedInventories',
                controller: 'POSF0038',
                typeGetParameter: {
                    inventoryIDList: inventoryIDList,
                    apk: posViewModel.TempAPKMaster,
                    inventoryQuantityList: inventoryQuantityList,
                    areaID: currentTable.Area.AreaID,
                    totalDiscountAmount: posViewModel.TotalDiscountAmount,
                    totalRedureAmount: posViewModel.TotalRedureAmount,
                    fromAutoComplete: true
                },
                callBack: function (result) {
                    sb.notify({
                        type: 'add-items-to-grid-refresh-master',
                        data: {
                            result: result,
                            fromAutoComplete: true

                        }
                    });
                }

            }
        });
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

    // Disable các control trên màn hình bán hàng
    // nếu trạng thái của phiếu khác 0
    function disableElement() {
        if (posViewModel.Status === '0') {
            return;
        }

        var
            // Nút "+" thêm hội viên
            btnAddObject = $('#btnAddObject'),

            // ô search hội viên
            kendoSearchMember = $('#MemberID').data('kendoAutoComplete'),

            // ô search mặt hàng
            kendoSearchInventory = $('#InventoryID').data('kendoAutoComplete')
        ;

        // disable Nút "+" thêm hội viên
        btnAddObject.unbind();
        btnAddObject.css('background-color', '#eee');
        btnAddObject.find('span').css('background-color', '#eee');

        // disable  ô search hội viên
        kendoSearchMember.element.attr('disabled', true);
        kendoSearchMember.element.css('background-color', '#eee');
        kendoSearchMember.destroy();

        // disable  ô search mặt hàng
        kendoSearchInventory.element.attr('disabled', true);
        kendoSearchInventory.element.css('background-color', '#eee');
        kendoSearchInventory.destroy();


    }

    return {
        // Hàm được core gọi tự động khi start module
        init: function () {
            initLOG();
            //initAutoComplete();
            initJQueryAutoComplete();
            posGrid = $('#mainGrid').data('kendoGrid');
            sb.listen({
                'enable-multy-select': function () {
                    ace.enable()
                }
            });

        },



        // Hàm được core gọi tự động khi stop module
        destroy: function () {
            // Cú pháp gỡ bỏ sự kiện trên một element
            sb.removeEvent(someElement, "click", handler);

            // cú pháp bỏ qua các sự kiện mà module này đã đăng ký
            sb.ignore(['change-filter', 'reset-filter', 'perform-search', 'quit-search']);
        }
    };
});


//fakeInput.off('focus').on('focus', function (e) {
//    console.log('focus');
//    kWidget.open();
//    e.preventDefault();
//    e.stopPropagation();
//    return false;
//});

//fakeInput.off('click').on('click', function (e) {
//    console.log('click');
//    kWidget.open();
//    e.preventDefault();
//    e.stopPropagation();

//})