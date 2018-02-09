//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/09/2014      Thai Son        Tạo mới
//####################################################################

/**
 * jQuery.asoftAutoMultiSelect - control tìm mặt hàng 
 * theo kiểu auto complete
 * có hỗ trợ quét mã vạch
 */;
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
        textMessageTemplate = '<p>{0}</p>'.format(ASOFT.helper.getMessage('00ML000031')),

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

        // đối tượng timeout để thực hiện filter
        timeout,

        // keyword hiện tại
        currentKeyWord,

        currentServerData,

        currentWidgetData,

        pageSize
    ;

    // Lấy ra một item từ dataSource của dropDownList
    // dựa trên id truyền vào
    function getItemByID(id) {
        var
            i = 0,
            dataSource = kWidget.dataSource,
            item
        ;
        // Lệnh while với điều kiện là dataSource.at(i++) có giá trị
        // item = dataSource.at(i++) vừa là  lệnh gán, vừa là điều kiện của vòng lập while
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

        return dataItem;
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

        if (!controller || !action) {
            return;
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
        //clearDataSource(kWidget.dataSource);
        kWidget.dataSource.data([]);
        focusedItem = undefined;
    }

    var currentDataList = [];
    // Gửi yêu cầu tìm mặt hàng lên server
    // để thực hiện filter
    function filter(keyWord, byEnter) {
        var
            // shortcut cho data source của dropdown list
            dataSource = kWidget.dataSource,
            // định dạng lại chuỗi tìm kiếm
            keyWord = keyWord.trim(),

            url = createURL(keyWord)
        ;

        if (!url) {
            throw "URL not valid";
        }

        if (!keyWord) {
            keyWord = '';
        }

        // đặt lại giá trị cho textbox
        fakeInput.val(keyWord);
        currentKeyWord = keyWord;

        // Gửi yêu cầu tìm mặt hàng lên server
        // để thực hiện filter
        var voucherDate = $("#VoucherDate").val();

        ASOFT.helper.postTypeJson(createURL(keyWord), {
                keyWord: keyWord,
                voucherDate: voucherDate
            },
            recieveServerData);
    }

    function moveDataToWidget(currentServerData, dataSource) {
        var
            diff = currentDataList.length - dataSource.data().length,
            additional = currentDataList.splice(dataSource.data().length, pageSize)
        ;
        if (diff === 0) {
            return;
        }

        additional.forEach(function (item) {
            dataSource.add(item);
        });
        setTimeout(function () {
            moveDataToWidget(currentServerData, currentWidgetData);
        }, 1000);
        

    }

    function async(fn) {
        setTimeout(fn, 20);
    }

    // Hàm được gọi khi có dữ liệu trả về từ server
    function recieveServerData(result) {
        var inventories = result && result.Data && result.Data.Inventories || result,
            // shortcut cho data source của dropdown list
            dataSource = kWidget.dataSource,
            topResult
        ;
        currentWidgetData = dataSource;
        currentDataList = inventories;
        currentServerData = inventories;

        // Nếu dữ liệu trả về có ít nhất 1 item, thì hiển thị popup suggest
        if (inventories.length > 0) {
            // nếu thiết lập chọn nhiều item, thì hiển thị nút chọn
            if (multiSelect) {
                footerButton.show();
                textMessage.hide();
            }
            // clear data source hiện tại của dropdown
            //clearDataSource(kWidget.dataSource);
            dataSource.data([]);

            dataSource.data(inventories);

            // lấy data nhận được từ server thêm vào data source của dropdown 
            //inventories.forEach(function (item) {
            //    dataSource.add(item);
            //});
            
            
            //(function add() {
            //    if (currentServerData.length === 0) {
            //        //kWidget.refresh();
            //        return;
            //    }
            //    currentWidgetData.add(currentServerData.pop());
            //    setTimeout(add, 4);
            //}());

            
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
            ul.find('li').removeClass("k-state-selected");
            ul.find('li').removeClass("k-state-focused");
            $("#InventoryIDBarCode_option_selected").removeAttr("id");

            $(focusedItem).attr("id", "InventoryIDBarCode_option_selected");
            $(focusedItem).addClass(KENDO_FOCUS_CSS);

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
                clearDataSource(kWidget.dataSource);
                setTimeout(function () {
                    if (posGrid != undefined) {
                        var i = 0;
                        for (; i < posGrid.columns.length; i++) {
                            if (posGrid.columns[i].field == "ActualQuantity") {
                                break;
                            }
                        }
                        var cell = $("#mainGrid").find('tbody tr:eq(' + ($("#mainGrid").data("kendoGrid").dataSource.data().length - 1) + ') td:eq(' + i + ')'); // or different cell
                        $("#mainGrid").data("kendoGrid").editCell(cell);
                    }
                }, 800)
            }
        }
            // nếu không có item nào trả về từ server
        else {
            if (multiSelect) {
                kWidget.open();
                clearDataSource(kWidget.dataSource);
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
            utils.toggleCheckBox(checkBox);
            addItemByCheckBox(checkBox);
            e.stopImmediatePropagation();
            e.preventDefault();
        });
    }

    // cuộn danh sách trong pupup
    function scrollList(rowIndex) {
        var
                currentListItem
        ;
        if (ul.height() === ul[0].scrollHeight) {
            return false;
        }

        if (rowIndex <= 0) {
            ul.animate({
                scrollTop: ul.position().top - INITIAL_OFFSET
            }, SCROLL_DURATION);

        } else {
            currentListItem = ul.find("li:nth-child({0})".format(rowIndex));
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
        var
            currentLi = ul.find('li#InventoryIDBarCode_option_selected'),
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
        var
            currentLi = ul.find('li#InventoryIDBarCode_option_selected'),
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
        } else {

        }
    }

    // xử lý sự kiện keypress trong ô nhập liệu
    // (để override "enter replace tab" trong common.js)
    function fakeInput_KeyPress(e) {
        e.stopPropagation();
    }

    // xử lý sự kiện keyup trong ô nhập liệu
    function fakeInput_KeyUp(e) { _log('keyup');
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
                    if (focusedItem && fakeInput.val().toString().trim() === previousValue) {
                        _log('focusedItem | ', focusedItem);
                        inventoryID = focusedItem.find('.id-container').text();
                        callBackWhenSelect.call(that, [getItemByID(inventoryID)]);
                        reset();

                        setTimeout(function () {
                            if (posGrid != undefined) {
                                var i = 0;
                                for (; i < posGrid.columns.length; i++)
                                {
                                    if (posGrid.columns[i].field == "ActualQuantity")
                                    {
                                        break;
                                    }
                                }
                                var cell = $("#mainGrid").find('tbody tr:eq(' + ($("#mainGrid").data("kendoGrid").dataSource.data().length - 1) + ') td:eq(' + i + ')'); // or different cell
                                $("#mainGrid").data("kendoGrid").editCell(cell);
                            }
                        }, 800)
                    } else {
                        filter(fakeInput.val().toString().trim());
                    }
                    previousValue = fakeInput.val().toString().trim();
                }
                    // nếu thiết lập chọn NHIỀU item
                else {
                    _log(inSelectingMode);
                    if (!inSelectingMode || fakeInput.val() !== previousValue) {
                        filter(fakeInput.val().toString().trim());
                        previousValue = fakeInput.val().toString().trim();
                    } else {
                        kWidget.close();
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
                if (utils.isAlphanum(char) || e.keyCode === 8 || e.keyCode === 46) {
                    //if (!multiSelect) {
                    //    clearTimeout(timeout);
                    //    timeout = setTimeout(function () {
                    //        if (valueText = fakeInput.val().toString().trim()) {
                    //            filter(fakeInput.val().toString().trim());
                    //        } else {
                    //            reset();
                    //        }
                    //    }, TIME_BETWEEN_KEY_PRESS_HUMANLY);
                    //}
                }
                break;
        }
    }

    //
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

        pageSize = opts.pageSize || 10;

        if (opts.server) {
            controller = opts.server.controller;
            action = opts.server.action;
        }

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

            footerButton.on('click', function (e) {
                //kWidget.unbind('close');
                e.stopPropagation();
                kWidget.close();
                callBackWhenSelect.call(that, selectedItems);

                reset();
            });            
        }

        if (!!opts.showSearchButton || multiSelect) {
            this.append(btnSearch);
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
            focusedItem = undefined;
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
    $.fn.asoftAutoMultiSelect = function (options) {
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
