//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/07/2014      Thai Son        Tạo mới
//####################################################################

(function ($) {
    var

        // Xác định trạng thái debug 
        // khi release, đặt lại DEBUG = false để disable tất cả hàm _log,
        DEBUG = true,
        // that for this
        that,

        // css của item được focus (màu xanh đậm)
        KENDO_FOCUS_CSS = 'k-state-selected k-state-focused',

        // khi một item được focus bằng phím, kendo sẽ tạo thuộc tính id cho nó
        KENDO_FOCUS_CSS_ID = 'InventoryIDBarCode_option_selected',

        // hàm log, sẽ được khởi tạo trong hàm initLOG()
        _log,

        // options truyền từ bên ngoài vào
        opts,

        // đối tượng jquery của dropdown list 
        // được khai báo trong partial BarcodeSearch.html
        jInput,

        // đối tượng kendo dropdown list
        // được khai báo trong partial BarcodeSearch.html
        kWidget,

        // textbox nhập liệu hiển thị trên màn hình
        // được khai báo trong partial BarcodeSearch.html
        fakeInput,

        // xác định giá trị trước thời điểm lấy giá trị hiện tại
        // (dùng để kiểm tra thay đổi của fakeInput)
        previousValue = '',

        // xác định trạng thái của control
        // là select 1, hoặc select nhiều
        multiSelect,

        // shortcut cho ASOFTCORE.utils 
        utils = ASOFTCORE.utils,

        // thời gian ít nhất giữa 2 lần ấn phím
        TIME_BETWEEN_KEY_PRESS_HUMANLY = 40,

        // Tên action để lấy mặt hàng
        action = 'GetInventories',

        // Tên controller để lấy mặt hàng
        controller = 'POSF0016',

        // Tên phân hệ
        area = 'POS',

        // html template cho footer của popup
        footerTemplate = '<div class="asf-multi-select-footer"></div>',

        // thông báo hiển thị khi không có mặt hàng
        textMessageTemplate = '<p>Inventory not found</p>',

        // html template của nút chọn
        buttonTempate = '<a class="asf-button k-button" aria-disabled="false" role="button">'
                        + '<span class="asf-button-text">Chọn</span>'
                        + '</a>',

        // html template cho nút tìm (biểu tượng kính lúp)
        btnSearchTemplate = '<a id="" class="asfbtn-item-32 k-button k-button-icon" tabindex="0" aria-disabled="false" role="button" data-role="button" style="position: absolute; right: 0px; top: 2px;" style="position:absolute">'
                        + '<span class="k-sprite asf-icon asf-icon-32 asf-i-search-24"></span>'
                        + '</a>',
        
        // Element chứa thông báo, sẽ hiển thị phía dưới popup
        textMessage = $(textMessageTemplate),

        // Element chứa nút chọn (khi thiết lập chọn nhiều item)
        footerButton = $(buttonTempate),

        // Danh sách các item đang được chọn
        // (nếu thiết lập chọn nhiều item
        selectedItems = [],

        // chứa thuộc tính ul của dropdown list
        ul,

        // chứa thuộc tính list của dropdown list
        list,

        // số item hiển thị trên popup
        MAX_NUMBER_OF_ITEM = 5,

        // chiều cao của mỗi item (px)
        LI_HEIGHT = 40,

        // khoảng cách từ item đầu tiên đến cạnh trên của popup
        INITIAL_OFFSET = 32,

        // chỉ số của item đang được chọn
        currentIndex = 0,

        // thời gian để thực hiện scroll popup (ms)
        // Khi người dùng dùng phím lên xuống để scroll
        SCROLL_DURATION = 100,

        // Item hiện đang được focus (bằng bàn phím)
        focusedItem = null,

        // Hàm sẽ được gọi khi ngừi dùng ấn enter để chọn item
        // Hoặc click chuột để chọn item
        callBackWhenSelect,

        // Biến xác định trạng thái của nút search
        disabledButtonSearch = false,

        // Biến xác định trạng thái của widget, đang trong chế độ  chọn item
        // (so với trạng thái đang filter)
        inSelectingMode = false,

        // timeout để thực hiện filter
        timeout,

         currentKeyWord
    ;

    // Lấy ra một item từ dataSource của dropDownList
    // dựa trên id truyền vào
    function getItemByID(id) {
        var i = 0,
            dataSource = kWidget.dataSource,
            item
        ;
        // Lệnh while với điều kiện là dataSource.at(i++) có giá trị
        // lệnh gán item = dataSource.at(i++) là có mục đích
        while (item = dataSource.at(i++)) {
            if (item.InventoryID === id) {
                return item;
            }
        }
    }

    // Thêm 1 item vào dang sách item được chọn
    // dựa trên trạng thái của checkbox tương ứng
    function addItemByCheckBox(checkBox) {
        var
            // Mã mặt hàng, sẽ lấy giá trị từ attribute của checkbox
            inventoryID,

            // Item được chọn
            dataItem
        ;

        // Kiểm tra tham số truyền vào
        if (checkBox instanceof jQuery && checkBox.is(':checkbox')) {
            _log('argument is a jQuery object, of a checkbox');
        } else {
            if (jQuery.contains(document, checkBox)) {
                checkBox = $(checkBox);
            } else if (typeof checkBox === 'string') {
                checkBox = $('#' + checkBox);
                if (checkBox.length === 0) {
                    throw 'argument is NOT valid: cannot find element with that id';
                }
            } else {
                throw 'argument is NOT valid, not provided, or not a checkbox';
            }
        }

        // Nếu tham số đúng là checkbox
        // thì lấy ra inventoryID và tìm dataItem tương ứng
        inventoryID = checkBox.attr('name').toString();
        dataItem = getItemByID(inventoryID);

        // Nếu checkbox được check thì thêm item vào danh sách,
        // nếu không thì gở bỏ item khỏi danh sách
        if (checkBox.is(':checked')) {
            addItem(dataItem);
        } else {
            removeItem(dataItem);
        }
    }

    // Thêm một item vào danh sách selectedItems
    function addItem(newItem) {
        var found;

        // Tìm item cũ trong danh sách selectedItems
        selectedItems.forEach(function (item) {
            if (item.InventoryID === newItem.InventoryID) {
                found = item;
                return;
            }
        });

        // Nếu không tìm thấy thì thêm item này vào
        if (!found) {
            selectedItems.push(newItem);
        }
    }

    // Gở bỏ một item khỏi danh sách selectedItems
    function removeItem(item) {
        var found;
        // Tìm item cũ trong danh sách selectedItems
        selectedItems.forEach(function (_item) {
            if (_item.InventoryID === item.InventoryID) {
                found = _item;
                return;
            }
        });

        // Nếu tìm thấy thì gở bỏ nó
        if (found) {
            //https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/splice
            selectedItems.splice(selectedItems.indexOf(found), 1);
        }
    }

    // trả về danh sách các item được chọn
    function getSelectedItems() {
        return selectedItems;
    }

    // Xóa bỏ tất cả các item đang có trong selectedItems
    function clearSelectedItems() {
        if (!Array.isArray(selectedItems)
            || selectedItems.length <= 0) {
            return;
        }
        selectedItems.splice(0, selectedItems.length);
    }

    // Tạo url để gửi request tìm mặt hàng
    function createURL(keyWord) {
        if (keyWord === null || keyWord === '') {
            keyWord = '*'
        }
        return '/{0}/{1}/{2}?keyWord={3}'.format(area, controller, action, keyWord);
    }

    // xóa dữ liệu trong dataSource của dropdown list
    function clearDataSource(dataSource) {
        while (dataSource.total() > 0) {
            dataSource.remove(dataSource.at(0));
        }
    }

    // reset control tìm mặt hàng
    function reset() {
        kWidget.close();
        fakeInput.val('');
        fakeInput.focus();
        clearDataSource(kWidget.dataSource);

    }
    
    // xóa dữ liệu trong dataSource của dropdown list
    function clearKendoDataSource(kds) {
        clearDataSource(kds);
    }

    // Gửi yêu cầu tìm mặt hàng lên server
    // để thực hiện filter
    function filter(keyWord, byEnter) {
        var
            // shortcut cho data source của dropdown list
            dataSource = kWidget.dataSource,

            // định dạng lại chuỗi tìm kiếm
            keyWord = keyWord.trim()
        ;

        if (!keyWord) {
            keyWord = '';
        }

        // đặt lại giá trị cho textbox
        fakeInput.val(keyWord);
        currentKeyWord = keyWord;

        // Gửi yêu cầu tìm mặt hàng lên server
        // để thực hiện filter
        ASOFT.helper.postTypeJson.call({
            keyWord: keyWord
        },
            createURL(keyWord),
            {},
            recieveServerData);
    }

    // Hàm được gọi khi có dữ liệu trả về từ server
    function recieveServerData(result) { _log(this)
        var inventories = result || [],
            // shortcut cho data source của dropdown list
            dataSource = kWidget.dataSource
        
        // Nếu dữ liệu trả về có ít nhất 1 item, thì hiển thị popup suggest
        if (inventories.length > 0) {
            // nếu thiết lập chọn nhiều item, thì hiển thị nút chọn
            if (multiSelect) {
                footerButton.show();
                textMessage.hide();
            }
            // clear data source hiện tại của dropdown
            clearKendoDataSource(kWidget.dataSource);

            // lấy data nhận được từ server thêm vào data source của dropdown 
            inventories.forEach(function (item) {
                dataSource.add(item);
            });

            kWidget.refresh();

            // Khởi tạo sự kiện click nếu thiết lập chọn nhiều item,
            if (multiSelect) {
                initClickEvent();
            }

            // gọi hàm search để dropdown focus vào item
            kWidget.search(currentKeyWord);

            // tạo lại danh sách item được chọn
            selectedItems = [];

            currentIndex = 1;
            kWidget.open();            
            focusedItem = ul.find('li').first();

            // xác định trạng thái là "đang chọn"
            inSelectingMode = true;

            // Nếu chỉ có duy nhất 1 item, thì chọn item này ngay
            // không cần hiện popup suggest
            if (inventories.length === 1) {
                if (multiSelect) {
                    chooseFocusedItem();
                }
                kWidget.close();
                callBackWhenSelect.call(that, [inventories[0]]);
                inSelectingMode = false;
                reset();
                clearKendoDataSource(kWidget.dataSource);
            }
        }
        // nếu không có item nào trả về từ server
        else {
            if (multiSelect) {
                kWidget.open();
                clearKendoDataSource(kWidget.dataSource);
                kWidget.refresh();
                footerButton.hide();
                textMessage.show();
                fakeInput.focus();
            }
        }
    }

    // Khởi tạo sự kiện click nếu thiết lập chọn nhiều item,
    function initClickEvent() {
        var
            // lấy thuộc tính ul của dropdown
            ul = kWidget.ul,

            // lấy ra các item (thẻ <li>) của danh sách
            li = ul.find('li'),

            // // lấy ra các checkbox của danh sách
            checkBoxes = ul.find(':checkbox')

        ;

        // Nếu click vào check box, thì add item, dựa trên checkbox được click
        checkBoxes.on('click', function (e) {
            e.stopImmediatePropagation();
            addItemByCheckBox(this);
        });

        // Nếu click vào item (thẻ <li>), (không click vào checkbox)
        // thì tìm checkbox trong thẻ <li>, rồi add item vào
        li.on('click', function (e) {
            var checkBox = $(this).find(':checkbox');
            utils.toggleCheckBox(checkBox)
            ;
            addItemByCheckBox(checkBox);
            e.stopImmediatePropagation();
            e.preventDefault();
        });

    }

    // cuộn danh sách trong pupup
    function scrollList(rowIndex) {
        if (ul.height() === ul[0].scrollHeight) {
            return false;
        }

        if (rowIndex <= 0) {
            ul.animate({
                scrollTop: ul.position().top - INITIAL_OFFSET
            }, SCROLL_DURATION);

        } else {
            var currentListItem = ul.find("li:nth-child({0})".format(rowIndex));

            if (currentListItem.position().top < 0
                || currentListItem.position().top > (ul.height() - currentListItem.height())) {
                var scrollDistance = 0;
                for (var i = 1; i < rowIndex; i++) {
                    var rowElement = ul.find("li:nth-child({0})".format(i));
                    scrollDistance += rowElement.height()
                }

                ul.animate({
                    scrollTop: scrollDistance
                }, SCROLL_DURATION);
            }
        }
    }

    // Xử lý sự kiện ấn phím down
    function downKey_Pressed(e) {
        var currentLi = ul.find('li#InventoryIDBarCode_option_selected'),
            nextLi = currentLi.next(),
            firstLi = ul.find('li').first(),
            currentPosition,
            inventoryID
        ;


        if (nextLi.length === 0) {
            return;
            firstLi.addClass(KENDO_FOCUS_CSS);

            ul.animate({ scrollTop: 0 }, 10);
            currentIndex = 1;
            scrollList(currentIndex)
        } else {
            currentIndex += 1;
            scrollList(currentIndex)
            nextLi.addClass(KENDO_FOCUS_CSS);
            nextLi.attr('id', KENDO_FOCUS_CSS_ID);
            currentLi.removeClass(KENDO_FOCUS_CSS);
            currentLi.removeAttr('id');
            currentLi = nextLi;

            inventoryID = currentLi.find('.asf-combo-item-col-value').text().toString().trim();
            kWidget.search(inventoryID);
        }

        focusedItem = currentLi;
    }

    // Xử lý sự kiện ấn phím up
    function upKey_Pressed(e) {
        var currentLi = ul.find('li#InventoryIDBarCode_option_selected'),
            prevLi = currentLi.prev(),
            lastLi = ul.find('li').last(),
            currentPosition
        ;

        if (prevLi.length === 0) {
            return;
            lastLi.addClass(KENDO_FOCUS_CSS);
            ul.scrollTop(ul[0].scrollHeight);
            currentIndex = kWidget.dataSource.total();
            scrollList(currentIndex)
        } else {
            currentIndex -= 1;
            scrollList(currentIndex)
            prevLi.addClass(KENDO_FOCUS_CSS);
            prevLi.attr('id', KENDO_FOCUS_CSS_ID);
            currentLi.removeClass(KENDO_FOCUS_CSS);
            currentLi.removeAttr('id');
            currentLi = prevLi;

            inventoryID = currentLi.find('.asf-combo-item-col-value').text().toString().trim();
            kWidget.search(inventoryID);
        }


        focusedItem = currentLi;
    }

    // Xử lý sự kiện ấn phím left
    function leftKey_Pressed(e) {
        chooseFocusedItem();
    }

    // chọn item đang được focus
    // (người dùng dùng phím lên xuống đề focus, và ấn phím space để chọn
    function chooseFocusedItem() {
        if (multiSelect) {
            var
                // lấy check box trong thẻ <li> đang được focus
                checkBox = focusedItem.find(':checkBox');
            
            // đổi trạng thái của checkbox
            utils.toggleCheckBox(checkBox);

            // thêm/ hoặc xóa item tương ứng
            addItemByCheckBox(checkBox);
        }
    }
    
    // xử lý sự kiện keypress trong ô nhập liệu
    // (để override "enter replace tab" trong common.js)
    function fakeInput_KeyPress(e) {
        e.stopPropagation();
    }

    // xử lý sự kiện keyup trong ô nhập liệu
    function fakeInput_KeyUp(e) {
        var
            // lấy text hiện có trong ôn nhập liệu
            valueText = fakeInput.val().toString().trim(),
            keyWord = valueText,

            // lấy ra ký tự mà người dùng vừa nhập
            char = String.fromCharCode(e.keyCode),
            changed = false,
            oldT = +new Date(),
            newT = +new Date(),
            inventoryID
        ;

        e.preventDefault();
        e.stopPropagation();

        // Kiểm tra keycode
        switch (e.keyCode) {
            case 13: //_log('enter'); 
                // nếu thiết lập chọn 1 item
                if (!multiSelect) {
                    // lấy inventoryID của item đang được chọn, 
                    // thực hiện filter để chon item này
                    if (focusedItem) {
                        filter(focusedItem.find('.id-container').text());
                    }
                }
                // nếu thiết lập chọn NHIỀU item
                else {
                    if (!inSelectingMode) {
                        filter(valueText, true);
                    } else {
                        _log(selectedItems);
                        callBackWhenSelect.call(that, selectedItems);
                        inSelectingMode = false;
                        reset();
                    }
                }
                break;
            case 32: //_log('space'); 
                if (multiSelect) {
                    if (inSelectingMode) {
                        chooseFocusedItem();
                        fakeInput.val(valueText);
                    }
                }
                break;
                //case 8: //_log('backspace');
                //    //break;
            case 106: //_log('multiply');
                break;
            case 106:// _log('delete');
                break;
            case 27: //_log('esc');
                clearSelectedItems();
                kWidget.close();
                fakeInput.val('');
                break;

            case 37: //_log('37 left');
                //leftKey_Pressed(e);
                break;

            case 38: //_log('38 up');
                upKey_Pressed(e);
                break;

            case 39: //_log('39 right');
                break;

            case 40: //_log('40 down');
                downKey_Pressed(e);
                break;

            default: //_log('other key');                
                if (!multiSelect) {
                    if (utils.isAlphanum(char) || e.keyCode === 8 || e.keyCode === 46) {
                        clearTimeout(timeout);
                        timeout = setTimeout(function () {
                            if (valueText = fakeInput.val().toString().trim()) {
                                filter(fakeInput.val().toString().trim());
                            } else {
                                reset();
                            }
                        }, TIME_BETWEEN_KEY_PRESS_HUMANLY);

                    }
                } else {

                }
                break;
        }
    }


    function enable() {
        fakeInput.removeAttr('disabled');
        fakeInput.css('background-color', '#fff');
        disabledButtonSearch = false;
    }

    // Khởi tạo sự kiện "ấn và giữ" phím
    // để di chuyển focus của item
    function initLongKeyPress() {
        var pressTimer;

        fakeInput.keyup(function (e) {
            clearTimeout(pressTimer)
        }).keydown(function (e) {
            // Set timeout
            pressTimer = window.setTimeout(function () {
                if (e.keyCode === 40) {
                    downKey_Pressed(e);
                } else if (e.keyCode === 38) {
                    upKey_Pressed(e);
                }
            }, 500);

        });
    }

    // Khởi tạo control dựa trên option truyền vào
    function init(options) {
        var footer = $(footerTemplate),
            btnSearch = $(btnSearchTemplate),
            kOptions

        ;

        opts = $.extend({}, options);
        jInput = $('#' + opts.kName);
        kWidget = jInput.data(opts.kType);
        kOptions = kWidget.options;
        fakeInput = $('#' + opts.fakeInputName);
        previousValue = fakeInput.val();
        ul = kWidget.ul;
        list = kWidget.list;
        multiSelect = (jInput.attr('data-multi-select') === 'True');

        callBackWhenSelect = options.select || function () { };

        fakeInput.attr('placeholder', $("label[for|='SearchInventoryID']").text());
        fakeInput.val('');

        if (multiSelect) {
            if (opts.buttonSelect) {
                if (opts.buttonSelect.show) {
                    if (opts.buttonSelect.caption) {
                        footer.find('span').text(opts.buttonSearchCaption);
                    }
                    footer.append(footerButton);
                    footer.append(textMessage);
                    $('#{0}-list'.format(opts.kName)).append(footer);
                }
            }

            if (!!opts.showSearchButton) {
                this.append(btnSearch);
            }

            footerButton.on('click', function (e) {
                //kWidget.unbind('close');
                e.stopPropagation();
                kWidget.close();
                callBackWhenSelect.call(that, selectedItems);

                reset();
            });

            // Khởi tạo sự kiện click vào nút chọn
            btnSearch.on('click', function (e) {
                if (disabledButtonSearch) {
                    return;
                }
                var valueText = fakeInput.val().toString().trim(),
                    char = String.fromCharCode(e.keyCode),
                    changed = false
                ;
                e.preventDefault();
                e.stopImmediatePropagation();
                filter(valueText);

            });
        }

        // Khởi tạo sự kiện khi scroll
        // detect khi nào cuộn đến item cuối cùng
        // dùng cho tính năng auto load more
        $('#{0}_listbox'.format(opts.kName)).scroll(function (e) {
            var element = $(this);
            if (element.scrollTop() + element.innerHeight() >= this.scrollHeight) {
                _log('hit the bottom');

            }
        });

        

        // Khởi tạo sự kiện đóng popup
        kWidget.bind('close', function () {
            inSelectingMode = false;
        });

        // Khởi tạo sự kiện select item
        kWidget.bind('select', function (e) {
            kWidget.close();
            inventoryID = e.item.find('.id-container').text();
            callBackWhenSelect.call(that, [getItemByID(inventoryID)]);
            reset();
        });

        // Nếu thiết lập disable control, thì disable
        if (opts.startDisabled) {
            fakeInput.attr('disabled', 'disabled');
            fakeInput.css('background-color', '#fff');
            disabledButtonSearch = true;
        }
    }

    // tạo jQuery extension cho control search mặt hàng
    $.fn.asoftAutoMultySelect = function (options) {
        init.call(this, options);
        fakeInput.unbind();
        fakeInput.off('keyup')
            .off('keydown')
            .off('keypress')
            .on('keyup', fakeInput_KeyUp)
            .on('keypress', fakeInput_KeyPress);

        initLongKeyPress();

        that = this;
        that.getSelectedItems = getSelectedItems
        that.enable = enable;
        that.focus = function () {
            fakeInput.focus();
        }
        return that;
    };

    // Khởi tạo hàm log 
    (function initLOG() {
        // Nếu không debug, thì hàm LOG đặt thành rỗng
        if (!DEBUG) {
            _log = function () { };
            return;
        }

        // Tạo hàm log
        if (Function.prototype.bind) {
            _log = Function.prototype.bind.call(console.log, console);
        }
        else {
            _log = function () {
                Function.prototype.apply.call(console.log, console, arguments);
            };
        }
    }());

}(jQuery));

// Xử lý thêm hàng khuyến mãi cho màn hình bán hàng KINGCOM
// Đối tượng toàn cục để interface với các hàm khác
var POSF00161 = {};

$(document).ready(function () {
    var
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = false,

        // log method
        // Debug
        LOG = console.log,

        gridElement = $("#mainGrid"),

        // Release
        //LOG = function () { },

        // posGrid
        posGrid = gridElement.data("kendoGrid"),

        // inventory auto complete
        iac = $('#InventoryID').data('kendoAutoComplete'),

        // quick reference
        dataSource = posGrid.dataSource,

        // quick reference        
        itemList = dataSource.data(),

        // shortcut hàm postTypeJson
        post = ASOFT.helper.postTypeJson,

        // danh sách nhóm
        groups = [],

        // URL search inventory
        URL_INVENTORY = '/POSF0016/GetPromotionInventories?inventoryID={0}&quantity={1}',

        // URL lấy hàng khuyến mã
        URL_PROMOTION = '/POSF0016/GetInventoriesPromotion',

        promotionList = []

    ;

    // Khởi tạo các biến và sự kiện
    function init() {
        initLOG();

        posGrid.bind('change', grid_dataBound);
        // Gán sự kiện: khi bắt đầu edit, tự động đặt con trỏ vào cuối của text
        posGrid.bind('edit', putCursorAtEnd);

        // Các hàm toàn cục để interface với posViewModel 
        POSF00161.btnDeleteRow_Click = btnDeleteRow_Click;
        POSF00161.grid_Save = grid_Save;
        POSF00161.addRowItem = addRowItem;
        POSF00161.isPromotionRow = isPromotionRow;

        // Lấy danh sách các mặt hàng khuyến mãi 
        loadPromotionList();

        // Disable các control trên màn hình bán hàng, khi ở trạng thái edit/change
        disableElement();


    }

    function putCursorAtEnd(e) {
        gridElement.find('input[type="text"]').select().putCursorAtEnd();
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

        return LOG;
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

    function grid_dataBound(e) {
        disableDeletionOnPromotion();
    }

    function disableDeletionOnPromotion() {
        var allTr = $("#mainGrid tbody tr")
        ;

        allTr.each(function (tr) {
            //LOG(tr);
        });
    }

    // Lấy danh sách các mặt hàng khuyến mãi 
    function loadPromotionList() {
        var
            // Tạo url
            url = getAbsoluteUrl(URL_PROMOTION);

        post(url, {}, function (result) {
            promotionList = result;
        });
    }

    // Xử lý sau khi người dùng ấn YES khi xóa dòng
    function btnDeleteRow_Click(tr) {
        var
            // lấy guid của dòng hiện tại
            rowGuid = tr.attr('data-uid'),

            // Tìm group chứa guid lấy ra, 
            // tức là group chứa mặt hàng tương ứng trong danh sách hàng bán
            group = tryGetGroup(rowGuid),

            // roup chứa mặt hàng khuyến mãi tương ứng với guid lấy ra
            groupPromotion = tryGetGroupPromotion(rowGuid)
        ;

        // nếu tìm thấy group, thì xóa bỏ mặt hàng khỏi group
        if (group) {
            group.removeItem(rowGuid);
        }
    }

    // xác định một dòng trên lưới có phải là dòng của hàng khuyến mãi hay không
    function isPromotionRow(anchor) {
        var
            // lấy ra thẻ <tr>
            tr = $(anchor).closest('tr'),

            // lấy ra guid của dòng dữ liệu
            rowGuid = $(tr).attr('data-uid'),

            // biến xác định dòng này có phải dòng khuyến mãi hay không
            deletable = false;

        // duyệt từng nhóm, kiểm tra guid lấy ra có phải hàng khuyến mãi hay không
        // nếu tìm thấy thì deletable = true;
        groups.forEach(function (g) {
            if (g.promoItems.hasOwnProperty(rowGuid)) {
                deletable = true;
                return;
            }
        });

        return false;
        //return deletable;
    }

    // Xử lý sự kiện thêm một item vào lưới
    // (Được gọi từ posViewModel)
    function addRowItem(tr, item) {
        var uid = $('#mainGrid tr').last().attr('data-uid'),
            group = tryCreateGroup(item);

        if (group) {
            group.addItem(uid, item);
        }
        //LOG(groups);
    }

    // Tìm một group có inventoryID bằng inventoryID của item
    // trả về group đã có, nếu tìm được
    // trả về group mới nếu không tìm được
    function tryCreateGroup(newItem) {
        var found = null,
            promotionRules = getPromotionRules(newItem);

        if (!promotionRules || promotionRules.length === 0) {
            return;
        }

        LOG(newItem);
        LOG('Has promotion');

        groups.forEach(function (g) {
            if (g.inventoryID === newItem.InventoryID) {
                found = g;
                return;
            }
        });
        if (found) {
            return found;
        }
        found = Group();
        found.promotionRules = promotionRules;
        return found;
    }

    function getPromotionRules(item) {
        var i = 0,
            l = promotionList.length,
            promotionRules = []
        ;

        for (; i < l; i += 1) {
            if (item.InventoryID === promotionList[i].ParentInventoryID) {
                promotionRules.push(promotionList[i]);
            }
        }

        return promotionRules;

    }

    // Tìm group  chứa item có row guid truyền vào
    function tryGetGroup(rowGuid) {
        var found = null,
            i = 0,
            l = groups.length;
        for (; i < l; i += 1) {
            if (groups[i].items.hasOwnProperty(rowGuid)) {
                if (groups[i].items[rowGuid]) {
                    return groups[i];
                }
            }
        }

        return null;
    }

    // Tìm group  chứa item có row guid truyền vào
    function tryGetGroupPromotion(rowGuid) {
        var found = null,
            i = 0,
            l = groups.length;
        for (; i < l; i += 1) {
            if (groups[i].promoItems.hasOwnProperty(rowGuid)) {
                if (groups[i].promoItems[rowGuid]) {
                    return groups[i];
                }
            }
        }

        return null;
    }

    // Xử lý sự kiện grid DataBound
    function gridDataBound_Handler(e) {
        dataSource = posGrid.dataSource;
        itemList = dataSource.data();
    }

    // Xử lý sự kiện grid save
    function gridSave_Handler(e) {
        LOG('gridSave_Handler');
        var rowGuid = e.container.closest('tr').attr('data-uid');
        LOG(this);
    }

    // Xử lý sự kiện grid save
    function grid_Save(e) {
        LOG('gridSave_Handler');
        // Nếu cột bị sửa không phải cột ActualQuantity thì bỏ qua
        if (!e.values.hasOwnProperty('ActualQuantity')) {
            return;
        }


        var
            // Lấy guid của dòng vừa được sửa
            rowGuid = e.container.closest('tr').attr('data-uid'),

            // Tìm group chứa mặt hàng với guid vừa lấy ra
            group = tryGetGroup(rowGuid),

            // lấy số lượng mới do người dùng nhập vào
            newQuantity = e.values.ActualQuantity
        ;

        // nếu tìm thấy nhóm, thì cập nhật số lượng của mặt hàng trong nhóm
        if (group) {
            group.updateQuantity(rowGuid, newQuantity);
        }

        LOG(this);
    }

    // Request server để lấy hàng khuyển mã của mặt hàng hiện tại
    function getPromotions(inventory, callBack) {
        var
            url = getAbsoluteUrl(URL_PROMOTION).format(
            inventory.inventoryID,
            inventory.getSumQuantity(),
            inventory.discountRate);

        post(url, {}, callBack);
    }

    // Khởi tạo đối tượng Group để quản lý các mặt hàng cùng loại
    // (và hàng khuyển mãi của chúng)
    function Group(conf) {
        // Đối tượng g là đối tượng group sẽ được trả về
        var g = {},
            dictRuleAndRowUID = [],
            ignoredRules = []
        ;


        function isRuleApplied(rule) {
            var found = null;

            dictRuleAndRowUID.forEach(function (item) {
                if (item.rule === rule) {
                    found = item.rule;
                    return;
                }
            });

            if (found) {
                return true;
            }
        }

        function getRuleOfRowUID(uid) {
            var found = null;

            dictRuleAndRowUID.forEach(function (item) {
                if (item.uid === uid) {
                    found = item.rule;
                    return;
                }
            });

            return found;
        }

        function isRuleIgnored(rule) {
            if (ignoredRules.indexOf(rule) !== -1) {
                return true;
            }
        }

        // Thêm nhóm vào danh sách nhóm
        groups.push(g);

        // nếu không có conf, thì trả về object rỗng
        conf = conf || {};

        // đối tượng danh sách các item (mặt hàng) của nhóm
        g.items = conf.items || {};

        // đối tượng danh sách các item (mặt hàng) khuyến mãi của nhóm
        g.promoItems = conf.promoItems || {};

        // số lượng từ
        g.fromQuantity = conf.fromQuantity || 0;

        // số lượng đến
        g.toQuantity = conf.toQuantity || 0;

        // guid của nhóm
        g.guid = conf.guid || GUID();

        // mã của mặt hàng mà nhóm sẽ chứa
        g.inventoryID = conf.inventoryID || '';

        // hàm được gọi khi khởi tạo nhóm
        g.init = function (newItem) {

        };

        // Cập nhật số lượng của một mặt hàng
        // Dựa trên guid của row element
        g.updateQuantity = function (guid, quantity) {
            var
                sumQuantity = 0,
                prop,
                quantity = quantity || 0;

            // save check
            if (!guid) {
                return;
            }

            // Duyệt qua danh sách mặt hàng
            // cập nhật mặt hàng có guid tương ứng
            for (prop in this.items) {
                if (this.items.hasOwnProperty(prop)) {
                    if (prop === guid) {
                        this.items[prop].ActualQuantity = quantity;
                    }
                }
            }

            this.applyRules();


        }

        // Tính tổng số lượng mặt hàng của nhóm
        g.getSumQuantity = function () {
            var
                i = 0,
                l = 0,
                sumQuantity = 0,
                items = this.items,
                prop = null;

            // safe check
            if (!this.items) {
                return 0;
            }
            // Nếu danh sách không có phần tử
            l = this.items.length;
            if (l === 0) {
                return 0;
            }
            // Duyệt danh sách để tính tổng số lượng
            for (prop in items) {
                if (items.hasOwnProperty(prop)) {
                    sumQuantity += items[prop].ActualQuantity;
                }
            }

            return sumQuantity;
        };

        // Thêm một item vào group
        g.addItem = function (guid, gridItem) {
            var sumQuantity = 0;
            // safe check
            if (!guid || !gridItem) {
                return;
            }
            // nếu group vừa được khởi tạo
            // thì thiết lập loại mặt hàng của group
            // nếu không thì thêm mặt hàng vào group
            if ($.isEmptyObject(this.items)) {
                this.inventoryID = gridItem.InventoryID;
                this.items[guid] = gridItem;
                this.fromQuantity = gridItem.FromQuantity;
                this.actualQuantity = gridItem.ActualQuantity;
                this.discountRate = gridItem.DiscountRate;
            } else {
                if (gridItem.InventoryID === this.inventoryID) {
                    this.items[guid] = gridItem;
                }
            }

            this.applyRules();
        }

        // áp dụng một các luật khuyến mãi lên nhóm hiện tại
        g.applyRules = function (removed) {
            //if (!$.isEmptyObject(this.promoItems) && !$.isEmptyObject(this.items)) {
            //    return;
            //}

            var i = 0,
                l = this.promotionRules.length,
                rule,
                promotionItems = [],
                promotionItem,
                sumQuantity = this.getSumQuantity(),
                requiredQuantity = 0,
                additionalQuantity = 0,
                cycle = 0
            ;

            for (; i < l; i++) {
                rule = this.promotionRules[i];
                if ((isRuleApplied(rule) && rule.PromoteTypeID === 1) && !removed) {
                    continue;
                }
                //if (isRuleIgnored(rule)) {
                //    continue;
                //}
                if (rule.PromoteTypeID === 1) {
                    requiredQuantity = rule.FromQuantity;
                    additionalQuantity = rule.PromoteQuantity;

                    if (sumQuantity < requiredQuantity) {
                        LOG('NOT ENOUGH');
                        this.removePromotion(rule);
                    } else {
                        LOG('ENOUGH');
                        this.addPromotionRule1(rule, additionalQuantity);
                    }

                } else if (rule.PromoteTypeID === 2) {
                    requiredQuantity = rule.FromQuantity;
                    additionalQuantity = sumQuantity * rule.PromotePercent / 100;
                    cycle = rule.PromotePercent / 100;

                    if (sumQuantity < requiredQuantity) {
                        LOG('NOT ENOUGH');
                        this.removePromotion(rule);
                    } else {
                        LOG('ENOUGH');
                        this.addPromotionRule2(rule, additionalQuantity);
                    }
                }


            }
        }

        // Thêm hàng khuyến mãi theo rule 2, (phần trăm)
        g.addPromotionRule2 = function (rule, quantity) {
            var
                // Đếm các mặt hàng khuyến mãi đang có trong nhóm
                // những mặt hàng này có mã tương ứng với rule
                count = this.countPromotionItem(rule.InventoryID)

            ;
            if (count < quantity) {
                do {
                    this.addPromotion(rule, 1);
                    count = this.countPromotionItem(rule.InventoryID);
                } while (count < quantity);

            } else if (count > quantity) {
                do {
                    this.removeOnePromotion(rule, 1);
                    count = this.countPromotionItem(rule.InventoryID);
                } while (count > quantity);
            }

            lockCell();
        }

        g.countPromotionItem = function (inventoryID) {
            var prop,
                item,
                sum = 0
            ;

            for (prop in this.promoItems) {
                if (this.promoItems.hasOwnProperty(prop)) {
                    item = this.promoItems[prop];
                    if (item.InventoryID === inventoryID) {
                        sum += 1;
                    }
                }
            }
            return sum;
        }

        // gõ bỏ mặt hàng bán, dựa vào guid của dòng
        g.removeItem = function (guid) {
            var sumQuantity = 0;

            if (!guid) {
                return;
            }

            if (this.items.hasOwnProperty(guid)) {
                delete this.items[guid];
            }

            this.applyRules(true);

            if (0 === this.getSumQuantity()) {
                dictRuleAndRowUID.splice(0);
                ignoredRules.splice(0);
            }
        }

        // Gở bỏ mặt hàng khuyến mãi khỏi lưới dựa vào guid của dòng
        g.removePromotionItem = function (guid) {
            var sumQuantity = 0;

            if (!guid) {
                return;
            }

            if (this.promoItems.hasOwnProperty(guid)) {
                delete this.promoItems[guid];
            }
        }

        // Thêm hàng khuyến mãi cho mặt hàng, 
        // (khi số lượng đủ chuẩn khuyến mãi)
        g.addPromotionRule1 = function (item, quantity) {
            var uid,
                newTr,
                i = 0,
                l = item.ActualQuantity,
                clonedItem = null,
                rowIndex = 0,
                count = this.countPromotionItem(item.InventoryID)
            ;

            if (count === quantity) {
                return;
            }

            if (quantity === 0) {

            } else if (quantity === 1) {
                // Thêm item vào grid datasource
                dataSource.add(item);
                // refresh để tạo lại html
                posGrid.refresh();
                // Lấy đối tượng jquery dòng mới thêm
                newTr = $('#mainGrid tr').last();
                // Lấy guid của dòng mới
                uid = newTr.attr('data-uid');
                // Thêm dòng mới vào danh sách khuyến mãi
                g.promoItems[uid] = item;
                dictRuleAndRowUID.push({
                    rule: item,
                    uid: uid
                });

            } else {
                // Nếu số lượng nhiều hơn 1,
                // thì nhân bản và thêm vào danh sách hàng khuyến mãi
                for (; i < quantity; i++) {
                    clonedItem = $.extend({}, item);
                    clonedItem.ActualQuantity = 1;
                    // Thêm item vào grid datasource
                    dataSource.add(clonedItem);
                    // refresh để tạo lại html
                    posGrid.refresh();
                    // Lấy đối tượng jquery dòng mới thêm
                    newTr = $('#mainGrid tr').last();
                    // Lấy guid của dòng mới
                    uid = newTr.attr('data-uid');
                    // Thêm dòng mới vào danh sách khuyến mãi
                    g.promoItems[uid] = clonedItem;

                    dictRuleAndRowUID.push({
                        rule: item,
                        uid: uid
                    });
                }
            }
            // disable edit các dòng là hàng khuyến mãi
            lockCell();
        }

        // Thêm hàng khuyến mãi cho mặt hàng, 
        // (khi số lượng đủ chuẩn khuyến mãi)
        g.addPromotion = function (item, quantity) {
            var uid,
                newTr;

            var i = 0,
                l = item.ActualQuantity,
                clonedItem = null,
                rowIndex = 0,
                count = this.countPromotionItem(item.InventoryID)
            ;

            if (quantity === 0) {

            } else if (quantity === 1) {
                // Thêm item vào grid datasource
                dataSource.add(item);
                // refresh để tạo lại html
                posGrid.refresh();
                // Lấy đối tượng jquery dòng mới thêm
                newTr = $('#mainGrid tr').last();
                // Lấy guid của dòng mới
                uid = newTr.attr('data-uid');
                // Thêm dòng mới vào danh sách khuyến mãi
                g.promoItems[uid] = item;

                dictRuleAndRowUID.push({
                    rule: item,
                    uid: uid
                });
                ignoredRules.push(item);
            } else {
                // Nếu số lượng nhiều hơn 1,
                // thì nhân bản và thêm vào danh sách hàng khuyến mãi
                for (; i < quantity; i++) {
                    clonedItem = $.extend({}, item);
                    clonedItem.ActualQuantity = 1;
                    // Thêm item vào grid datasource
                    dataSource.add(clonedItem);
                    // refresh để tạo lại html
                    posGrid.refresh();
                    // Lấy đối tượng jquery dòng mới thêm
                    newTr = $('#mainGrid tr').last();
                    // Lấy guid của dòng mới
                    uid = newTr.attr('data-uid');
                    // Thêm dòng mới vào danh sách khuyến mãi
                    g.promoItems[uid] = clonedItem;

                    dictRuleAndRowUID.push({
                        rule: item,
                        uid: uid
                    });
                }
                ignoredRules.push(item);
            }

            // disable edit các dòng là hàng khuyến mãi
            lockCell();
        }

        // Gỡ bỏ hàng khuyến mãi của một mặt hàng
        // Khi mặt hàng đó bị xóa, hoặc giảm số lượng
        // ... dưới số lượng chuẩn
        g.removePromotion = function (rule) {
            var prop = null,
                uid,
                targetRule
            ;

            // Duyệt qua danh sách guid của hàng khuyến mã
            for (prop in this.promoItems) {
                // safe check
                if (this.promoItems.hasOwnProperty(prop)) {
                    var
                        // Lấy danh sách row element (thẻ tr) của lưới
                        allTr = $('#mainGrid tbody tr'),
                        // Lấy ra row element tương ứng 
                        // với mặt hàng khuyến mãi trong danh sách
                        targetTr = $('#mainGrid tbody').find('tr[data-uid*="{0}"]'.format(prop)),

                        uid = targetTr.attr('data-uid'),

                        // Lấy ra chỉ số dòng trên lưới
                        // tương ứng với chỉ số của mặt hàng trong datasource
                        rowIndex = allTr.index(targetTr)
                    ;

                    targetRule = getRuleOfRowUID(uid);

                    if (targetRule !== rule) {
                        continue;
                    }

                    //delete targetRule;

                    // Gỡ bỏ mặt hàng khỏi datasource
                    // -> kendo tự động gỡ khỏi lưới
                    if (rowIndex !== -1) {
                        dataSource.remove(dataSource.at(rowIndex));
                    }
                    // Xóa bỏ phần tử trong danh sách hàng khuyến mãi
                    delete this.promoItems[prop];
                }
            }
            // disable edit các dòng là hàng khuyến mãi
            lockCell();
        }

        g.removeOnePromotion = function (rule) {
            var prop = null;

            // Duyệt qua danh sách guid của hàng khuyến mã
            for (prop in this.promoItems) {
                // safe check
                if (this.promoItems.hasOwnProperty(prop)
                    && this.promoItems[prop].InventoryID === rule.InventoryID) {
                    var
                        // Lấy danh sách row element (thẻ tr) của lưới
                        allTr = $('#mainGrid tbody tr'),
                        // Lấy ra row element tương ứng 
                        // với mặt hàng khuyến mãi trong danh sách
                        targetTr = $('#mainGrid tbody').find('tr[data-uid*="{0}"]'.format(prop)),
                        // Lấy ra chỉ số dòng trên lưới
                        // tương ứng với chỉ số của mặt hàng trong datasource
                        rowIndex = allTr.index(targetTr);

                    // Gỡ bỏ mặt hàng khỏi datasource
                    // -> kendo tự động gỡ khỏi lưới
                    if (rowIndex !== -1) {
                        dataSource.remove(dataSource.at(rowIndex));
                    }
                    // Xóa bỏ phần tử trong danh sách hàng khuyến mãi
                    delete this.promoItems[prop];
                    return;
                }
            }
        }


        return g;
    }

    // disable edit các dòng là hàng khuyến mãi
    function lockCell() {
        var allTr = $('#mainGrid tr');
        groups.forEach(function (group) {
            var prop,
                targetTr,
                promoItems = group.promoItems
            ;
            for (prop in group.promoItems) {
                if (promoItems.hasOwnProperty(prop)) {
                    targetTr = $('#mainGrid tbody').find('tr[data-uid*="{0}"]'.format(prop));
                    targetTr.find('td').attr('data-edit-disabled', 1);
                    targetTr.find("td:eq( 10 )").removeAttr('data-edit-disabled');
                    targetTr.find("td:eq( 9 )").removeAttr('data-edit-disabled');
                }
            }
        });
    }

    // Override hàm editCell của kendoGrid
    kendo.ui.Grid.fn.editCell = (function (editCell) {
        return function (cell) {
            cell = $(cell);

            var that = this,
                column = that.columns[that.cellIndex(cell)],
                model = that._modelForContainer(cell),
                event = {
                    container: cell,
                    model: model,
                    preventDefault: function () {
                        this.isDefaultPrevented = true;
                    }
                };

            //if (model && typeof this.options.beforeEdit === "function") {
            //    this.options.beforeEdit.call(this, event);

            // don't edit if prevented in beforeEdit
            //    if (event.isDefaultPrevented) return;
            // }

            // Nếu ô (<td>) hiện tại có thuộc tính data-edit-disabled
            // ... thì chặn không cho edit
            if (cell.attr('data-edit-disabled')) {
                console.log(cell.attr('data-edit-disabled'));
                return;
            }
            editCell.call(this, cell);
        };
    })(kendo.ui.Grid.fn.editCell);
    // Hàm tạo guid
    function GUID() {
        function s4() {
            return Math.floor((1 + Math.random()) * 0x10000)
                       .toString(16)
                       .substring(1);
        }
        return function () {
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
                   s4() + '-' + s4() + s4() + s4();
        };
    }

    init();
});


(function ($) {
    jQuery.fn.putCursorAtEnd = function () {
        return this.each(function () {
            $(this).focus()

            // If this function exists...
            if (this.setSelectionRange) {
                // ... then use it
                // (Doesn't work in IE)

                // Double the length because Opera is inconsistent about whether a carriage return is one character or two. Sigh.
                var len = $(this).val().length * 2;
                this.setSelectionRange(len, len);
            }
            else {
                // ... otherwise replace the contents with itself
                // (Doesn't work in Google Chrome)
                $(this).val($(this).val());
            }

            // Scroll to the bottom, in case we're in a tall textarea
            // (Necessary for Firefox and Google Chrome)
            this.scrollTop = 999999;
        });
    };
})(jQuery);

$(document).ready(function () {
    var searchButtonCaption = $('input[name="_Select"]').val();

    posViewModel.formatNumbers();

    $('#btnFinishShift').removeClass('asf-btn-disabled');

});
