//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

// Module màn hình chọn món
ASOFTCORE.create_module("choose-dishes", function (sb) {
    var
        LOG = ASOFTCORE.log,
        // Đối tượng quản lý danh sách món ăn
        dishPanel,
        // Đối tượng quản lý danh mục phân loại
        categoryPanel = null,
        // Đối tượng quản lý các món được chọn
        choosenDishes = null,

        // mẫu html hiển thị món ăn
        htmlString = '<li class="asf-disabled-selection">'
                    + '<img class="dish-img" src="/Areas/POS/Content/Images/PhucLong/{0}" />'
                    + '<span class="dish-quantity">'
                    + '<span class="dish-quantity-input asf-disabled-selection" name="quantity" data-quantity="0" disabled="disabled">{4}</span>'
                    + '</span>'
                    + '<span class="dish-name-background">&nbsp;</span>'
                    + '<span class="slider-container" id="slider-container">&nbsp;</span>'
                    + '<span class="dish-name"><p>{1}</p></span>'
                    + '<span>'
                    + '<input id="{2}" class="dish-choose" type="checkbox" {3} data-id="{2}" />'
                    + '<label for="{2}"></label>'
                    + '</span>'
                    + '</li>',

        // html hiển thị slider
        htmlSlider = '<input class="slider" value="0" />'

    ;

    // Đối tượng quản lý danh sách các món được chọn
    choosenDishes = function () {
        var
            // Đối tượng trả về
            o = {}
        ;

        // Danh sách các món được chọn
        o.dishes = [];

        // Thêm một món vào danh sách
        o.add = function (dish) {
            var i = 0,
                l = this.dishes.length,
                found = null
            ;

            this.dishes.forEach(function (d) {
                if (dish.InventoryID === d.InventoryID) {
                    found = d;
                    return;
                }
            });

            if (!found) {
                this.dishes.push(dish);
            }
        }

        // Thêm một danh sách món ăn vào danh sách
        o.addMany = function (dishes) {
            if (!Array.isArray(dishes)) {
                return;
            }
            dishes.forEach(function (d) {
                this.add(d);
            }, this);

        }

        // Xóa bỏ một món khỏi danh sách
        o.remove = function (dish) {
            var i = 0,
                l = this.dishes.length;

            for (; i < l; i += 1) {
                if (this.dishes[i].InventoryID === dish.InventoryID) {
                    this.dishes.splice(i, 1);
                    return;
                }
            }
        }

        // trả về true nếu danh sách có món ăn vói id truyền vào
        o.hasDishByID = function (id) {
            var i = 0,
                l = this.dishes.length;

            for (; i < l; i += 1) {
                if (this.dishes[i].InventoryID === id) {
                    return true;
                }
            }
            return false;
        }

        // Lấy số lượng hiện tại của món ăn có id truyền vào
        o.oldQuantityByID = function (id) {
            var i = 0; l = this.dishes.length;
            for (; i < l; i += 1) {
                if (this.dishes[i].InventoryID === id) {
                    return this.dishes[i].Quantity;
                }
            }
        }

        // Xóa bỏ tất cả  món ăn đang có trong danh sách
        o.clear = function () {
            while (this.dishes.length > 0) {
                this.dishes.pop();
            }
        };

        return o;
    }();

    // Đối tượng quản lý danh mục các phân loại
    categoryPanel = function (elementID) {
        var
            // Đối tượng trả về
            p = {}
        ;
        // đối tượng jQuery 
        p.jElement = null;

        // Danh sách chứa các category
        p.categoryList = [];

        // Thêm một category vào danh sách
        p.addCategory = function (category) {
            LOG(category);
            panel.categoryList.push(category);
            panel.jElement.append(category.jElement);
        };

        // Thêm nhiều category vào danh sách
        p.addCategories = function (ajaxCategories) {
            var i = 0,
            l = ajaxCategories.length,
            newCategoryObj;

            for (; i < l; i += 1) {
                newCategoryObj = createCategory(ajaxCategories[i]);
                this.categoryList.push(newCategoryObj);
                this.jElement.append(newCategoryObj.jElement);
            }
        };

        // chọn một category, xử lý hiên thị html
        p.selectCategory = function (category) {
            var i = 0,
                l = this.categoryList.length;

            for (; i < l; i += 1) {
                if (this.categoryList[i].AnaID === category.AnaID) {
                    this.categoryList[i].select();
                }
            }
        };

        // Hàm khởi tạo
        p.init = function (elmtID) {
            var that = this
            return function (categories) {
                p.jElement = $(sb.find("#category_list", true)[0]);
                p.jElement.text('');
                p.addCategories(categories);
            }
        }(elementID);

        return p;
    }('category_list');

    // Đối tượng quản lý danh sách món ăn
    dishPanel = function (elementID) {
        var
            // Đối tượng trả về
            p = {},
            // Tiêu đề của loại món ăn
            dishPanelTitleElement = $(sb.find("#dishes h2", true)[0]);

        // Đối tượng jquery của 
        p.jElement = null;

        // Danh sách chứa các món ăn
        p.dishList = [];

        // Thêm một món ăn vào danh sách
        p.addDish = function (ajaxDish) {
            var newDishObj = Object.create(ajaxDish);

            panel.dishList.push(newDishObj);
            panel.jElement.append(newDishObj.jElement);
        };

        // Thêm nhiều món ăn vào danh sách
        p.addDishes = function (ajaxDishes) {
            var
                i = 0,
                l = ajaxDishes.length,
                newDishObj
            ;

            p.jElement.text('');
            for (; i < l; i += 1) {
                newDishObj = createDish(ajaxDishes[i]);
                this.dishList.push(newDishObj);
                this.jElement.append(newDishObj.jElement);
            }
        };
        // Thêm nhiều món ăn vào danh sách
        // với dữ liệu là kết quả json trả về từ server
        p.addAjaxDishes = function (result) {
            var ajaxDishes = result && result.Data && result.Data.Inventories,
                imageFolderURL = result && result.Data && result.Data.ImageFolder;

            if (!ajaxDishes) {
                ajaxDishes = [];
            }
            p.addDishes(ajaxDishes);

        };

        // Tìm một món ăn có id truyền vào
        p.findByID = function (id) {
            var i = 0; l = this.dishList.length;
            for (; i < l; i += 1) {
                if (this.dishList[i].InventoryID === id) {
                    return this.dishList[i];
                }
            }
        };

        // Khởi tạo
        p.init = function (elmtID) {
            var that = this;
            return function () {
                p.jElement = $(sb.find('#' + elementID, true)[0]);
                //p.jElement.text('');
                //p.addDishes(dishes);
            }
        }(elementID);

        // 
        p.changeTitleText = function (text) {
            dishPanelTitleElement.text(text);
        };


        return p;
    }('dish_list');

    // Xử lý sự kiện click vào một phân loại
    function category_Click(e) {
        var jElement = $(this),
            c = e.data;

        jElement.addClass('asf-disabled-selection');
        categoryPanel.jElement.find('li').removeClass('selected');
        $(this).addClass('selected');
        dishPanel.changeTitleText(c.AnaName);

        if (c.dishList) {
            dishPanel.addAjaxDishes({ Data: { Inventories: c.dishList } });
        } else {
            sb.notify({
                type: 'get-ajax-data',
                data: {
                    controller: 'POSF0038',
                    action: 'GetInventories',
                    categoryID: c.AnaID,
                    inventoryTypeID: c.InventoryTypeID,
                    queryString: '?inventoryTypeID={0}&anaID={1}'.format(c.InventoryTypeID, c.AnaID),
                    callBack: c.addAjaxDishes
                }
            });
        }
    }

    // Khởi tạo đối tượng phân loại món ăn
    function createCategory(ajaxCategory) {
        var
            // Khởi tạo đối tượng trả về
            c = Object.create(ajaxCategory)
        ;

        // Đối tượng chứ danh sách món ăn
        c.dishList = undefined;
        // Khởi tạo đối tượng jQuery  của category hiện tại
        c.jElement = $('<li></li>').append('<p>{0}</p>'.format(c.AnaName));
        // Thêm tên hiển thị
        c.jElement.attr('data-categoryid', c.AnaID);
        // gán sự kiện click
        c.jElement.on('click', null, c, category_Click);

        // Xử lý khi category được chọn
        c.select = function () {
            categoryPanel.jElement.find('li.selected').removeClass('selected');
            this.jElement.addClass('selected');
            dishPanel.changeTitleText(c.AnaName);
        }

        // Thêm món ăn vào danh sách, tạo và và hiển thị html
        // Dữ liệu nhận được từ server
        c.addAjaxDishes = function (result) {
            c.dishList = result.Data.Inventories;
            dishPanel.addAjaxDishes(result);
        }

        return c;
    }

    // Hàm xử lý khi click vào số lượng của món ăn
    function dishQuantityInput_Click(e) {
        var d = e.data,
            quantityInput = $(this),
            quantityBox = d.jElement.find('.dish-quantity'),
            offset = quantityBox.offset(),
            offsetX = offset.left + quantityBox.width(),
            offsetY = offset.top + quantityBox.height(),
            sliderContainer,
            currentOffset,
            slider
        ;

        e.stopPropagation();

        $(window.frames[0].document).trigger('click');
        $(window.frames[0].document).unbind().bind('click', function (e) {
            d.jElement.find('.slider-container').html('').css('display', 'none');
            d.sliderOn = false;
        });

        if (!d.sliderOn) {
            slider = d.jElement.find('.slider-container').html(htmlSlider)
                  .css('display', 'block')
                  .css('position', 'absolute')
                  .css('top', quantityBox.width() + 'px')
                  .css('left', quantityBox.height() + 'px')
                  .on('click', function (e) { e.stopPropagation() });

            sliderContainer = d.jElement.find('.slider-container');
            currentOffset = sliderContainer.offset();

            if (currentOffset.left + sliderContainer.width() + 50 > $(window).width()) {
                d.jElement.find('.slider-container').html(htmlSlider)
                   .css('display', 'block')
                   .css('position', 'absolute')
                   .css('top', (quantityBox.height()) + 'px')
                   .css('left', (-quantityBox.width() - sliderContainer.width()) + 'px');
            }

            $(d.jElement.find('.slider-container .slider')[0]).kendoSlider({
                increaseButtonTitle: "Right",
                decreaseButtonTitle: "Left",
                min: 0,
                max: 10,
                smallStep: 1,
                largeStep: 1,
                value: d.Quantity,
                tooltip: {
                    enabled: false
                }
            }).data("kendoSlider").bind('change', function (e) {
                d.Quantity = e.value;
                if (d.Quantity > 0) {
                    var checkBox = d.jElement.find('input[type = "checkbox"]');
                    checkBox.attr('checked', true);
                    d.Selected = true;
                    quantityInput.text(d.Quantity);
                    choosenDishes.add(d);
                } else {
                    d.Quantity = 0;
                    quantityInput.text(d.Quantity);
                    var checkBox = d.jElement.find('input[type = "checkbox"]');
                    checkBox.attr('checked', false);
                    d.Selected = false;
                    d.jElement.find('.dish-quantity').slideUp("fast");
                    choosenDishes.remove(d);
                    d.jElement.find('.slider-container').html('').css('display', 'none');
                    d.sliderOn = false;
                }
            });

            d.sliderOn = true;
        } else {
            d.jElement.find('.slider-container').html('').css('display', 'none');
            d.sliderOn = false;
        }

    }

    // Hàm xử lý khi click vào hình món ăn
    function dishImg_Click(e) {
        var d = e.data,
            quantityInput = d.jElement.find('.dish-quantity')
        ;

        e.stopPropagation();

        var checkBox = $(this).parent().find('input[type = "checkbox"]');
        if (checkBox.attr('checked')) {
            d.Selected = false;
            choosenDishes.remove(d);
            d.Quantity = 0;
            quantityInput.text(d.Quantity);
            quantityInput.slideUp("fast");
            checkBox.attr('checked', false);
            d.jElement.find('.slider-container').html('').css('display', 'none');
            d.sliderOn = false;

        } else {
            d.Selected = true;
            choosenDishes.add(d);
            d.Quantity = 1;
            quantityInput.text(d.Quantity);
            quantityInput.slideDown("fast");
            checkBox.attr('checked', true);
            quantityInput.trigger('click');

        }
    }

    // Hàm xử lý khi click vào tên món ăn
    function dishName_Click(e) {
        var d = e.data,
            dishName = d.jElement.find('.dish-img')
        ;
        e.stopPropagation();
        dishName.trigger('click');
    }

    // Khởi tạo đối tượng món ăn
    // nhận vào một đối tượng ajax từ server
    // sau đó khởi tạo các thộc tính, phương thức, sự kiên cần thiết
    // và hiển thị html
    // LƯU Ý: khởi tạo không dùng 'new'
    function createDish(ajaxDish) {
        var
            // Tạo đối tượng món ăn từ đối tượng ajax
            d = Object.create(ajaxDish),
            // chuổi thể hiện thuộc tính html xác định trạng thái được check của món ăn
            checked = '',
            quantityInput,
            minus,
            plus;

        // Biến xác định trạng thái hiển thị của slider
        d.sliderOn = false;

        // Thuộc tính xác định món ăn đã được chọn từ trước
        d.Selected = choosenDishes.hasDishByID(d.InventoryID);

        // Nếu món đã được chọn từ trước
        // Thì lấy đối tượng đã lưu trong danh sách
        if (d.Selected) {
            // Thuộc tính số lượng, tạm thời khởi tạo là 1
            d.Quantity = choosenDishes.oldQuantityByID(d.InventoryID) || 0;
        } else {
            d.Quantity = 0;
        }

        // Nếu món ăn đã được chọn từ trước, thì sẽ được đánh dấu check
        if (d.Selected) {
            checked = 'checked = "checked"';
        }

        //// Tạo đối tượng jQuery
        var s = htmlString.format(d.InventoryImageName, d.InventoryName, d.InventoryID, checked, d.Quantity);
        d.jElement = $(s);

        if (d.Selected) {
            d.jElement.find('.dish-quantity').show();
        }
        d.jElement.find('.dish-quantity').on('click', null, d, dishQuantityInput_Click);

        // Xử lý sự kiện click lên món ăn
        d.jElement.find('.dish-img').on('click', null, d, dishImg_Click);

        d.jElement.find('.dish-name').on('click', null, d, dishName_Click);


        return d;
    }

    // Khởi tạo màn hình
    function initMenu(result) {
        var
            // Danh sách các phân loại từ db
            ajaxCategories = result && result.Data && result.Data.Categories,
            // Danh sách các mặt hàng từ db
            ajaxInventories = result && result.Data && result.Data.Inventories,
            i = 0,
            l = 0;
        if (!ajaxCategories) {
            ajaxCategories = [];
        }

        if (!ajaxInventories) {
            ajaxInventories = [];
        }
        // Khởi tạo khu vực phân loại
        categoryPanel.init(ajaxCategories);
        // Tự động chọn phân loại đầu tiên
        categoryPanel.selectCategory(ajaxCategories[0]);
        // Tự động thêm các mặt hàng của phân loại đầu tiên
        dishPanel.addAjaxDishes(result);
        // Thêm danh sách mặt hàng vào đối tượng categoryPanel
        categoryPanel.dishList = ajaxInventories;
    }

    // Xử lý sau khi nhận được response lấy mặt hàng
    function afterLoadDishFromServer(result) {
        // notify master-data thêm mặt hàng vào lưới
        sb.notify({
            type: 'add-items-to-grid-refresh-master',
            data: { result: result, fromAutoComplete: true }
        });

        // Đóng màn hình chọn món
        ASOFT.asoftPopup.hideIframe();
    }

    return {
        // Hàm được gọi khi khởi chạy module
        init: function () {
            var i = 0, s, c,
                currentTable = sb.currentTable,
                btnChoose = sb.find("#btnSave", true)[0],
                btnClose = sb.find("#btnClose", true)[0]
            ;

            sb.addEvent(btnChoose, "click", this.chooseDishes_Click);
            sb.addEvent(btnClose, "click", this.closePopup_Click);
            dishPanel.init();
            // Lấy dữ liệu
            sb.notify({
                type: 'get-init-data',
                data: {
                    action: 'GetCategories',
                    controller: 'POSF0038',
                    queryString: '',
                    callBack: initMenu
                }
            });
        },

        // Hàm được gọi khi tắt module
        destroy: function () {
            //sb.removeEvent(button, "click", this.handleSearch);
            //sb.removeEvent(button, "click", this.quitSearch);
            //input = button = reset = null;
        },

        // Hàm xử lý sự kiện click lên nút chọn
        chooseDishes_Click: function (e) {
            if (!posViewModel.TempAPKMaster) {
                LOG('NO TABLE CHOOSEN');
                ASOFT.asoftPopup.hideIframe();
                return;
            }

            var dishes = choosenDishes.dishes,
                i = 0,
                l = dishes.length,
                inventoryIDList = [],
                inventoryQuantityList = [],
                currentTable = ASOFTCORE.globalVariables.currentTable;

            // Lấy danh sách mã mặt hàng và danh sách số lượng tương ứng
            for (; i < l; i += 1) {
                inventoryIDList.push(dishes[i].InventoryID);
                inventoryQuantityList.push(dishes[i].Quantity);
            }

            if (inventoryIDList.length === 0) {
                LOG('NO DISH CHOOSEN');
                ASOFT.asoftPopup.hideIframe();
                return;
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
                        totalRedureAmount: posViewModel.TotalRedureAmount
                    },
                    callBack: afterLoadDishFromServer

                }
            });
        },

        // Đóng màn hình chọn món
        closePopup_Click: function (e) {
            ASOFT.asoftPopup.hideIframe();
        }
    };
}, true);
