//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     19/07/2014      Thai Son        Tạo mới
//####################################################################

/**
 * Xử lý thêm hàng khuyến mãi cho màn hình bán hàng KINGCOM
 * Đối tượng toàn cục để interface với các hàm khác
 */
;
var POSF00161 = {};
$(document).ready(function () {
    var
        // Xác định trạng thái debug, nếu release thì đặt lại false
        DEBUG = false,

        // log method
        // Debug
        LOG = function () { },

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

        promotionList = [],

        promotionTitles = []

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
            LOG(result);
            promotionList = result.PromotionDetails;
            promotionTitles = result.PromotionTitles;

            displayPromotionTitles(promotionTitles);

        });
    }

    // Xử lý hiến thị thông báo khuyến mãi (marquee);
    function displayPromotionTitles(titleList) {
        if (titleList.length === 0) {
            return;
        }
        var title = titleList[0];
        $('#Gifts').html(title);
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

/**
 * jQuery.putCursorAtEnd - put cursor at the end of textbox
 * use when edit grid
 */;
(function ($) {
    $.fn.putCursorAtEnd = function () {
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
/**
 * jQuery.marquee - scrolling text like old marquee element
 * http://aamirafridi.com/jquery/jquery-marquee-plugin
 */;
(function ($) {
    $.fn.marquee = function (options) {
        return this.each(function () {
            // Extend the options if any provided
            var o = $.extend({}, $.fn.marquee.defaults, options),
                $this = $(this),
                $marqueeWrapper, containerWidth, animationCss, verticalDir, elWidth,
                loopCount = 3,
                playState = 'animation-play-state',
                css3AnimationIsSupported = false,

                //Private methods
                _prefixedEvent = function (element, type, callback) {
                    var pfx = ["webkit", "moz", "MS", "o", ""];
                    for (var p = 0; p < pfx.length; p++) {
                        if (!pfx[p]) type = type.toLowerCase();
                        element.addEventListener(pfx[p] + type, callback, false);
                    }
                },

                _objToString = function (obj) {
                    var tabjson = [];
                    for (var p in obj) {
                        if (obj.hasOwnProperty(p)) {
                            tabjson.push(p + ':' + obj[p]);
                        }
                    }
                    tabjson.push();
                    return '{' + tabjson.join(',') + '}';
                },

                _startAnimationWithDelay = function () {
                    $this.timer = setTimeout(animate, o.delayBeforeStart);
                },

                //Public methods
                methods = {
                    pause: function () {
                        if (css3AnimationIsSupported && o.allowCss3Support) {
                            $marqueeWrapper.css(playState, 'paused');
                        } else {
                            //pause using pause plugin
                            if ($.fn.pause) {
                                $marqueeWrapper.pause();
                            }
                        }
                        //save the status
                        $this.data('runningStatus', 'paused');
                        //fire event
                        $this.trigger('paused');
                    },

                    resume: function () {
                        //resume using css3
                        if (css3AnimationIsSupported && o.allowCss3Support) {
                            $marqueeWrapper.css(playState, 'running');
                        } else {
                            //resume using pause plugin
                            if ($.fn.resume) {
                                $marqueeWrapper.resume();
                            }
                        }
                        //save the status
                        $this.data('runningStatus', 'resumed');
                        //fire event
                        $this.trigger('resumed');
                    },

                    toggle: function () {
                        methods[$this.data('runningStatus') == 'resumed' ? 'pause' : 'resume']();
                    },

                    destroy: function () {
                        //Clear timer
                        clearTimeout($this.timer);
                        //Unbind all events
                        $this.find("*").andSelf().unbind();
                        //Just unwrap the elements that has been added using this plugin
                        $this.html($this.find('.js-marquee:first').html());
                    }
                };

            //Check for methods
            if (typeof options === 'string') {
                if ($.isFunction(methods[options])) {
                    //Following two IF statements to support public methods
                    if (!$marqueeWrapper) {
                        $marqueeWrapper = $this.find('.js-marquee-wrapper');
                    }
                    if ($this.data('css3AnimationIsSupported') === true) {
                        css3AnimationIsSupported = true;
                    }
                    methods[options]();
                }
                return;
            }

            /* Check if element has data attributes. They have top priority
               For details https://twitter.com/aamirafridi/status/403848044069679104 - Can't find a better solution :/
               jQuery 1.3.2 doesn't support $.data().KEY hence writting the following */
            var dataAttributes = {},
            attr;
            $.each(o, function (key, value) {
                //Check if element has this data attribute
                attr = $this.attr('data-' + key);
                if (typeof attr !== 'undefined') {
                    //Now check if value is boolean or not
                    switch (attr) {
                        case 'true':
                            attr = true;
                            break;
                        case 'false':
                            attr = false;
                            break;
                    }
                    o[key] = attr;
                }
            });

            //since speed option is changed to duration, to support speed for those who are already using it
            o.duration = o.speed || o.duration;

            //Shortcut to see if direction is upward or downward
            verticalDir = o.direction == 'up' || o.direction == 'down';

            //no gap if not duplicated
            o.gap = o.duplicated ? o.gap : 0;

            //wrap inner content into a div
            $this.wrapInner('<div class="js-marquee"></div>');

            //Make copy of the element
            var $el = $this.find('.js-marquee').css({
                'margin-right': o.gap,
                'float': 'left'
            });

            if (o.duplicated) {
                $el.clone(true).appendTo($this);
            }

            //wrap both inner elements into one div
            $this.wrapInner('<div style="width:100000px" class="js-marquee-wrapper"></div>');

            //Save the reference of the wrapper
            $marqueeWrapper = $this.find('.js-marquee-wrapper');

            //If direction is up or down, get the height of main element
            if (verticalDir) {
                var containerHeight = $this.height();
                $marqueeWrapper.removeAttr('style');
                $this.height(containerHeight);

                //Change the CSS for js-marquee element
                $this.find('.js-marquee').css({
                    'float': 'none',
                    'margin-bottom': o.gap,
                    'margin-right': 0
                });

                //Remove bottom margin from 2nd element if duplicated
                if (o.duplicated) $this.find('.js-marquee:last').css({
                    'margin-bottom': 0
                });

                var elHeight = $this.find('.js-marquee:first').height() + o.gap;

                // adjust the animation speed according to the text length
                // formula is to: (Height of the text node / Height of the main container) * speed;
                o.duration = ((parseInt(elHeight, 10) + parseInt(containerHeight, 10)) / parseInt(containerHeight, 10)) * o.duration;

            } else {
                //Save the width of the each element so we can use it in animation
                elWidth = $this.find('.js-marquee:first').width() + o.gap;

                //container width
                containerWidth = $this.width();

                // adjust the animation speed according to the text length
                // formula is to: (Width of the text node / Width of the main container) * speed;
                o.duration = ((parseInt(elWidth, 10) + parseInt(containerWidth, 10)) / parseInt(containerWidth, 10)) * o.duration;
            }

            //if duplicated than reduce the speed
            if (o.duplicated) {
                o.duration = o.duration / 2;
            }

            if (o.allowCss3Support) {
                var
                elm = document.body || document.createElement('div'),
                    animationName = 'marqueeAnimation-' + Math.floor(Math.random() * 10000000),
                    domPrefixes = 'Webkit Moz O ms Khtml'.split(' '),
                    animationString = 'animation',
                    animationCss3Str = '',
                    keyframeString = '';

                //Check css3 support
                if (elm.style.animation) {
                    keyframeString = '@keyframes ' + animationName + ' ';
                    css3AnimationIsSupported = true;
                }

                if (css3AnimationIsSupported === false) {
                    for (var i = 0; i < domPrefixes.length; i++) {
                        if (elm.style[domPrefixes[i] + 'AnimationName'] !== undefined) {
                            var prefix = '-' + domPrefixes[i].toLowerCase() + '-';
                            animationString = prefix + animationString;
                            playState = prefix + playState;
                            keyframeString = '@' + prefix + 'keyframes ' + animationName + ' ';
                            css3AnimationIsSupported = true;
                            break;
                        }
                    }
                }

                if (css3AnimationIsSupported) {
                    animationCss3Str = animationName + ' ' + o.duration / 1000 + 's ' + o.delayBeforeStart / 1000 + 's infinite ' + o.css3easing;
                    $this.data('css3AnimationIsSupported', true);
                }
            }

            var _rePositionVertically = function () {
                $marqueeWrapper.css('margin-top', o.direction == 'up' ? containerHeight + 'px' : '-' + elHeight + 'px');
            },
            _rePositionHorizontally = function () {
                $marqueeWrapper.css('margin-left', o.direction == 'left' ? containerWidth + 'px' : '-' + elWidth + 'px');
            };

            //if duplicated option is set to true than position the wrapper
            if (o.duplicated) {
                if (verticalDir) {
                    $marqueeWrapper.css('margin-top', o.direction == 'up' ? containerHeight + 'px' : '-' + ((elHeight * 2) - o.gap) + 'px');
                } else {
                    $marqueeWrapper.css('margin-left', o.direction == 'left' ? containerWidth + 'px' : '-' + ((elWidth * 2) - o.gap) + 'px');
                }
                loopCount = 1;
            } else {
                if (verticalDir) {
                    _rePositionVertically();
                } else {
                    _rePositionHorizontally();
                }
            }

            //Animate recursive method
            var animate = function () {
                if (o.duplicated) {
                    //When duplicated, the first loop will be scroll longer so double the duration
                    if (loopCount === 1) {
                        o._originalDuration = o.duration;
                        if (verticalDir) {
                            o.duration = o.direction == 'up' ? o.duration + (containerHeight / ((elHeight) / o.duration)) : o.duration * 2;
                        } else {
                            o.duration = o.direction == 'left' ? o.duration + (containerWidth / ((elWidth) / o.duration)) : o.duration * 2;
                        }
                        //Adjust the css3 animation as well
                        if (animationCss3Str) {
                            animationCss3Str = animationName + ' ' + o.duration / 1000 + 's ' + o.delayBeforeStart / 1000 + 's ' + o.css3easing;
                        }
                        loopCount++;
                    }
                        //On 2nd loop things back to normal, normal duration for the rest of animations
                    else if (loopCount === 2) {
                        o.duration = o._originalDuration;
                        //Adjust the css3 animation as well
                        if (animationCss3Str) {
                            animationName = animationName + '0';
                            keyframeString = $.trim(keyframeString) + '0 ';
                            animationCss3Str = animationName + ' ' + o.duration / 1000 + 's 0s infinite ' + o.css3easing;
                        }
                        loopCount++;
                    }
                }

                if (verticalDir) {
                    if (o.duplicated) {

                        //Adjust the starting point of animation only when first loops finishes
                        if (loopCount > 2) {
                            $marqueeWrapper.css('margin-top', o.direction == 'up' ? 0 : '-' + elHeight + 'px');
                        }

                        animationCss = {
                            'margin-top': o.direction == 'up' ? '-' + elHeight + 'px' : 0
                        };
                    } else {
                        _rePositionVertically();
                        animationCss = {
                            'margin-top': o.direction == 'up' ? '-' + ($marqueeWrapper.height()) + 'px' : containerHeight + 'px'
                        };
                    }
                } else {
                    if (o.duplicated) {

                        //Adjust the starting point of animation only when first loops finishes
                        if (loopCount > 2) {
                            $marqueeWrapper.css('margin-left', o.direction == 'left' ? 0 : '-' + elWidth + 'px');
                        }

                        animationCss = {
                            'margin-left': o.direction == 'left' ? '-' + elWidth + 'px' : 0
                        };

                    } else {
                        _rePositionHorizontally();
                        animationCss = {
                            'margin-left': o.direction == 'left' ? '-' + elWidth + 'px' : containerWidth + 'px'
                        };
                    }
                }

                //fire event
                $this.trigger('beforeStarting');

                //If css3 support is available than do it with css3, otherwise use jQuery as fallback
                if (css3AnimationIsSupported) {
                    //Add css3 animation to the element
                    $marqueeWrapper.css(animationString, animationCss3Str);
                    var keyframeCss = keyframeString + ' { 100%  ' + _objToString(animationCss) + '}',
                        $styles = $('style');

                    //Now add the keyframe animation to the head
                    if ($styles.length !== 0) {
                        //Bug fixed for jQuery 1.3.x - Instead of using .last(), use following
                        $styles.filter(":last").append(keyframeCss);
                    } else {
                        $('head').append('<style>' + keyframeCss + '</style>');
                    }

                    //Animation iteration event
                    _prefixedEvent($marqueeWrapper[0], "AnimationIteration", function () {
                        $this.trigger('finished');
                    });
                    //Animation stopped
                    _prefixedEvent($marqueeWrapper[0], "AnimationEnd", function () {
                        animate();
                        $this.trigger('finished');
                    });

                } else {
                    //Start animating
                    $marqueeWrapper.animate(animationCss, o.duration, o.easing, function () {
                        //fire event
                        $this.trigger('finished');
                        //animate again
                        if (o.pauseOnCycle) {
                            _startAnimationWithDelay();
                        } else {
                            animate();
                        }
                    });
                }
                //save the status
                $this.data('runningStatus', 'resumed');
            };

            //bind pause and resume events
            $this.bind('pause', methods.pause);
            $this.bind('resume', methods.resume);

            if (o.pauseOnHover) {
                $this.bind('mouseenter mouseleave', methods.toggle);
            }

            //If css3 animation is supported than call animate method at once
            if (css3AnimationIsSupported && o.allowCss3Support) {
                animate();
            } else {
                //Starts the recursive method
                _startAnimationWithDelay();
            }

        });
    }; //End of Plugin
    // Public: plugin defaults options
    $.fn.marquee.defaults = {
        //If you wish to always animate using jQuery
        allowCss3Support: true,
        //works when allowCss3Support is set to true - for full list see http://www.w3.org/TR/2013/WD-css3-transitions-20131119/#transition-timing-function
        css3easing: 'linear',
        //requires jQuery easing plugin. Default is 'linear'
        easing: 'linear',
        //pause time before the next animation turn in milliseconds
        delayBeforeStart: 1000,
        //'left', 'right', 'up' or 'down'
        direction: 'left',
        //true or false - should the marquee be duplicated to show an effect of continues flow
        duplicated: false,
        //speed in milliseconds of the marquee in milliseconds
        duration: 5000,
        //gap in pixels between the tickers
        gap: 20,
        //on cycle pause the marquee
        pauseOnCycle: false,
        //on hover pause the marquee - using jQuery plugin https://github.com/tobia/Pause
        pauseOnHover: false
    };
})(jQuery);


/**
 * Xử lý Kích hoạt jQuery marquee để hiển thị thông báo khuyến mãi
 */
$(document).ready(function () {
    var
        searchButtonCaption = $('input[name="_Select"]').val(),
        marquee;
    
    function init() {
        posViewModel.formatNumbers();
        startMarquee();
        initJQueryAutoComplete();
        showNumericTextboxes();
    }

    function showNumericTextboxes() {
        $("#TotalAmount, #TotalTaxAmount, #TotalDiscountRate, #TotalDiscountAmount, #TotalRedureRate, #TotalRedureAmount, #PaymentObjectAmount01, #PaymentObjectAmount02, #TotalInventoryAmount, #Change").removeClass('asf-temporary-hidden');
    }

    // Dừng hoạt động của jQuery marquee
    function stopMarquee() {
        if (marquee) {
            marquee('destroy');
            marquee = undefined;
        }
    }

    // Kích hoạt jQuery marquee để hiển thị thông báo khuyến mãi
    // nội dung thông báo sẽ được thêm vào $('#Gifts') sau khi load xong dữ liệu khuyến mãi
    function startMarquee() {
        marquee = $('.asf-marquee').marquee({
            duration: 7000,
            duplicated: false
        });
    }   

    // Tạo control search mặt hàng
    function initJQueryAutoComplete() {
        var ace = $("#asf-barcode-multiselect").asoftAutoMultiSelect({
            kName: 'InventoryIDBarCode',
            kType: 'kendoDropDownList',
            fakeInputName: 'InventoryIDBarCode_input',

            select: function (inventoryObjects) {
                if (inventoryObjects) {
                    if (Array.isArray(inventoryObjects)) {
                        inventoryObjects.forEach(function (item) {
                            var dtSeacrh = {};
                            dtSeacrh.keyword = item.InventoryID;
                            dtSeacrh.IsPackage = item.IsPackage;
                            ASOFT.helper.postTypeJson("/POS/POSF0016/GetInventoriesPOSP0067", dtSeacrh, function (listInventory) {
                                listInventory.forEach(function (it) {
                                    AddRow(it);
                                })
                            })
                        });
                    }
                }
            },

            startDisabled: false,
            showSearchButton: true,
            showFooterButton: false,
            buttonSelectCaption: searchButtonCaption,

            multiSelect: true,

            buttonSelect: {
                show: true,
                caption: searchButtonCaption
            }
        });

        ace.focus();
    };

    init();
});
