//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//#     27/08/2014      Thai Son        Update
//####################################################################
;


// Module cho các widget trên form
// và quản lý lưới mặt hàng, 


ASOFTCORE.create_module("master-data", function (sb) {
    var
        // Tên của grid
        GRID_NAME = 'mainGrid',

        // Hàm LOG thay cho console.log
        LOG = ASOFTCORE.log,
        //LOG = console.log,

        // Đối tượng form để quản lý các widget (html dom, jquery, kendo) trên màn hình
        form = null,

        // Đối tượng grid để quản lý các lưới trên màn hình trên màn hình
        grid = null,

        // shortcut cho các utils
        utils = ASOFTCORE.utils,

        // đối tượng dữ liệu master hiện tại
        currentMaster,

        // đối tượng dữ liệu detail hiện tại
        currentDetails,

        // css class để ẩn một element
        CSS_HIDDEN = 'asf-disabled-visibility',

        // biến xác định dữ liệu để fresh form và grid, đến từ đâu
        fromAutoComplete = false,

        // đối tượng chứa các hàm để các đối tượng khác sử dụng
        functionFactory,

        // jQuery của  2 nút khuyến mãi, 
        // được hiển thị khi click vào nút "khuyến mãi"
        floatingButtons = $('#floating-buttons-container'),

        // format số thành chuỗi dạng số thập phân thông thường
        formatGeneralDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoGeneralDecimalsFormatString;
            return kendo.toString(value, format);
        },

        // format số thành chuỗi dạng số "thành tiền/ tiền sau khi tính toán"
        formatConvertedDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
            return kendo.toString(value, format);
        },

        // format số thành chuỗi dạng số "phần trăm"
        formatPercentDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
            return kendo.toString(value, format);
        },

        // format số thành chuỗi dạng số "đơn giá"
        formatUnitCostDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoUnitCostDecimalsFormatString;
            return kendo.toString(value, format);
        },

        // format số thành chuỗi dạng "số lượng"
        formatQuantityDecimal = function (value) {
            //return value;
            var format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
            return kendo.toString(value, format);
        }
    ;

    // Đối tượng form để quản lý các widget (html dom, jquery, kendo) trên màn hình
    form = function () {
        // đối tượng trả về
        var f = {};

        // danh sách các widget của form 
        //(mỗi phần tử là một đối tượng tạo ra từ hàm Widget)
        f.widgets = [];

        // Tìm một widget trong danh sách widgets theo tên
        f.findWidgetByID = function (name) {
            var widget = null;
            this.widgets.forEach(function (w) {
                if (w.name === name) {
                    widget = w;
                    return;
                }
            });

            return widget;
        }

        // Lấy giá trị (thô) của một widget
        f.getValueOf = function (name) {
            var i = 0, // biến đếm
                l = this.widgets.length, // lấy kích thước array
                widget = null;

            for (; i < l; i++) {
                widget = this.widgets[i];
                if (widget.name === name) {
                    return widget.getValue();
                }
            }
        };

        // gán giá trị cho một widget
        f.setValueOf = function (name, value) {
            var i = 0, l = this.widgets.length, widget = null;
            for (; i < l; i++) {
                widget = this.widgets[i];
                if (widget.name === name) {
                    return widget.setValue(value);
                }
            }
        };

        // Gán sự kiên cho các widget trên form
        f.initEvents = function () {
            var i = 0, l = this.widgets.length, widget;

            for (; i < l; i++) {
                widget = this.widgets[i];

                // Nếu widget là một kendo widget
                if (widget.element && widget.type === 'kendo') {
                    widget.element.bind('change', function (e) {

                    });
                    // Nếu là jquery
                } else if (widget.element && widget.type === 'jquery') {

                } else {

                }
            }
        }

        // Disable các control/widget khi màn hình ở trạng thái edit (view only)
        f.disableForm = function () {
            var disabledColor = "#f0f0f0";

            $('#InventoryID').prop('disabled', true).css('background-color', disabledColor).data('kendoAutoComplete').destroy();

            $('#MemberID').prop('disabled', true).css('background-color', disabledColor).data('kendoAutoComplete').destroy();

            $('#btnAddObject').prop('disabled', true);

            $('#VoucherDate').prop('disabled', true).data('kendoDatePicker').destroy();

            $('#VoucherNo').prop('disabled', true).css('background-color', disabledColor);
            $('#MemberName').prop('disabled', true).css('background-color', disabledColor);

            $('#CurrencyID').data('kendoComboBox').destroy();
            $('input[name="CurrencyID_input"]').prop('disabled', true).css('background-color', disabledColor);

            $('#APKPaymentID').data('kendoComboBox').destroy();
            $('input[name="APKPaymentID_input"]').prop('disabled', true).css('background-color', disabledColor);
            $('#PaymentObjectID01').data('kendoComboBox').destroy();
            $('input[name="PaymentObjectID01_input"]').prop('disabled', true).css('background-color', disabledColor);

            $('#PaymentObjectID02').data('kendoComboBox').destroy();
            $('input[name="PaymentObjectID02_input"]').prop('disabled', true).css('background-color', disabledColor);

            $('#TotalDiscountRate').prop('disabled', true).css('background-color', disabledColor);
            $('#TotalRedureRate').prop('disabled', true).css('background-color', disabledColor);
            $('#TotalDiscountAmount').prop('disabled', true).css('background-color', disabledColor);
            $('#TotalRedureAmount').prop('disabled', true).css('background-color', disabledColor);
            $('#AccruedScore').prop('disabled', true).css('background-color', disabledColor);
            $('#PayScore').prop('disabled', true).css('background-color', disabledColor);
            $('#AccountNumber01').prop('disabled', true).css('background-color', disabledColor);
            $('#AccountNumber02').prop('disabled', true).css('background-color', disabledColor);

            $('#PaymentObjectAmount01').prop('disabled', true).css('background-color', disabledColor);
            $('#PaymentObjectAmount02').prop('disabled', true).css('background-color', disabledColor);

            $('#btnAddObject').unbind();
            $('#btnSave').unbind();

            $('#status-bar ul').remove();

            $('input[name="PaymentObjectID02_input"]').prop('disabled', true).css('background-color', disabledColor);
        }

        // refresh thông tin trên form khi form ở trạng thái edit
        // master: đối tượng chưa thông tin master
        // forcedInclude: danh sách tên các widget bắt buột KHÔNG ĐƯỢC cập nhật
        // forcedExclude: danh sách tên các widget bắt buột được cập nhật
        f.refetchOnEdit = function (master, forcedExclude, forcedInclude) {
            if (!master) {
                return;
            }

            var forcedExclude = Array.isArray(forcedExclude) ? forcedExclude : [];
            var forcedInclude = Array.isArray(forcedInclude) ? forcedInclude : [];

            // đặt lại currentMaster để các hàm khác sửa dụng
            currentMaster = master;

            // Thay đổi tên khu vực, tên bàn trên màn hình
            if (master.TableID) {
                $('#table-name').text(master.TableID);
            }
            if (master.AreaName) {
                $('#area-name').text(master.AreaName);
            }

            // Cập nhật giá trị các control có commit db (cần theo dõi thay đổi)
            f.widgets.forEach(function (widget) {
                if (master.hasOwnProperty(widget.name)) {
                    if (widget.commitDB === false) {
                    }
                    else if (widget.dataType === 'number') {
                        widget.setValue(master[widget.name]);
                    } else {
                        widget.setValue(master[widget.name]);
                    }
                }
            });

            // Cập nhật giá trị các control bắt buột cập nhật giá trị
            forcedInclude.forEach(function (item) {
                var widget = form.findWidgetByID(item);
                if (!widget) {
                    return;
                }
                if (master.hasOwnProperty(item)) {
                    if (widget.dataType === 'number') {
                        widget.setValue(master[item]);
                    } else {
                        widget.setValue(master[item]);
                    }
                }
            });
            // Disable các control/widget
            this.disableForm();
        }

        // refresh thông tin trên form
        // master: đối tượng chưa thông tin master
        // forcedInclude: danh sách tên các widget bắt buột KHÔNG ĐƯỢC cập nhật
        // forcedExclude: danh sách tên các widget bắt buột được cập nhật
        f.refetch = function (master, forcedExclude, forcedInclude) {
            if (!master) {
                return;
            }

            var forcedExclude = Array.isArray(forcedExclude) ? forcedExclude : [];
            var forcedInclude = Array.isArray(forcedInclude) ? forcedInclude : [];

            currentMaster = master;

            // Cập nhât tên bàn và tên khu vực lên màn hình
            if (master.TableID) {
                $('#table-name').text(master.TableID);
            }
            if (master.AreaName) {
                $('#area-name').text(master.AreaName);
            }

            // Cập nhật giá trị các control có commit db
            f.widgets.forEach(function (widget) {
                if (master.hasOwnProperty(widget.name)) {
                    if (widget.commitDB === false) {

                    }
                    else if (widget.dataType === 'number') {
                        widget.setValue(master[widget.name]);
                    } else {
                        widget.setValue(master[widget.name]);
                    }
                }
            });
            // Cập nhật giá trị các control bắt buột cập nhật giá trị
            forcedInclude.forEach(function (item) {
                var widget = form.findWidgetByID(item);
                if (!widget) {
                    return true;
                }
                if (master.hasOwnProperty(item)) {
                    if (widget.dataType === 'number') {
                        widget.setValue(master[item]);
                    } else {
                        widget.setValue(master[item]);
                    }
                }
            });

            this.findWidgetByID('MemberIDHidden').setValue(master.MemberID)
        }

        // Lấy widget kế tiếp widget hiện tại
        f.nextOf = function (widget) {
            var nextIndex = this.widgets.indexOf(widget) + 1;
            return this.widgets[nextIndex];
        };

        // Lấy widget kế TRƯỚC widget hiện tại
        f.prevOf = function (widget) {
            var prevIndex = this.widgets.indexOf(widget) - 1;
            return this.widgets[prevIndex];
        };

        // tạo đối tượng chứa thông tin master
        f.JSON = function () {
            var json = {};
            this.widgets.forEach(function (w) {
                if (w.name) {
                    json[w.name] = w.getValue();
                }
            });
            json.VoucherID = currentMaster.VoucherID;
            return json;
        }

        return f;
    }();

    // Tạo mối một đối tượng widget
    // dựa trên một đối tượng jQuery, kendo, hoặc dom element
    function Widget(config) {
        var w = {};

        function init() {
            var kInput;
            //mapConfig(w, config);
            if (config.dataType) {
                if (config.dataType === 'number') {
                    w.defaultValue = 0;
                } else if (config.dataType === 'string') {
                    w.defaultValue = '';
                }
            }

            // Bật/tắt sự kiện change
            if (config.disableChangeEvent) {
                w.turnOffChange();
            } else {
                w.turnOnChange();
            }
        }

        function mapConfig(cfg) {
            w = $.extend(w, cfg);
        }

        w.defaultValue = null;
        w.input = null;
        w.jInput = null;
        w.isChangeOn = false;
        w.name = config.name;
        w.type = config.type;
        w.dataType = config.dataType;
        w.element = config.element;
        w.commitDB = config.commitDB;
        w.disableChangeEvent = config.disableChangeEvent;
        w.additionalChangeHandler = config.additionalChangeHandler;
        w.format = config.format;


        w.getBaseEntiry = function () {
            return {
                APK: posViewModel.TempAPKMaster
            }
        };

        w.isKendoCombobox = function () {
            return this.element.options.name === "ComboBox";
        };

        w.getValue = function () {
            var value = null;
            if (this.type === 'kendo') {
                if (this.element.options.name === "DatePicker") {
                    value = kendo.toString(this.element.value(), "g")
                }
                value = this.element.value().toString();
            } else if (this.type === 'jquery') {
                value = this.element.val();
            } else {
                value = $(this.element).text();
            }

            if (this.dataType === 'number') {
                //return Number.parseFloat(value.toString().replace(/,/g, '')) || 0;
                value = kendo.parseFloat(value.toString())
                //return kendo.toString(value, ASOFTEnvironment.UnitPriceDecimalFormat);

            }
            return value;
        };

        w.getEntityForUpdate = function () {
            var postData = [],
                   item = {};
            // Lấy các thông tin cần thiết
            item['DbTableName'] = 'POST0033';
            item['DbColumnName'] = w.element.options.dataValueField;
            item['DbValue'] = w.getValue();
            item['DbWhere'] = 'APK';
            item['DbEqual'] = posViewModel.TempAPKMaster;

            postData.push(item);

            if (this.isKendoCombobox()) {
                item = {};
                item['DbTableName'] = 'POST0033';
                item['DbColumnName'] = w.element.options.dataTextField;
                item['DbValue'] = w.element.text();
                item['DbWhere'] = 'APK';
                item['DbEqual'] = posViewModel.TempAPKMaster;
                postData.push(item);
            }

            return postData;
        };

        w.setValue = function (newValue) {
            var newValue = newValue || this.defaultValue
            ;

            if (w.dataType === 'number') {
                if (typeof newValue === "string") {
                    newValue = kendo.parseFloat(newValue);
                }
                if (w.format === 'money') {
                    newValue = formatConvertedDecimal(newValue);
                } else if (w.format === 'percent') {
                    newValue = formatPercentDecimal(newValue);
                }

            };

            posViewModel.set(this.name, newValue);

            if (this.type === 'kendo') {
                this.element.value(newValue);
            } else if (this.type === 'jquery') {
                this.element.val(newValue);
            } else {
                this.element.text(newValue);
            }

            if (this.additionalChangeHandler) {
                this.additionalChangeHandler(this);
            }

        };
        // hàm xử lý sự kiện change
        w.changeHandler = function (e) {
            var postData = null,
                value = w.getValue();
            if (!value) {
                if (w.dataType === 'number') {
                    w.setValue(0);
                } else {
                    w.setValue('');
                }
            }
            if (!posViewModel.TempAPKMaster) {
                LOG('APK master is UNDEFINED - changes ignored');
                return;
            }

            // Tắt sự kiện change
            w.turnOffChange();
            if (w.commitDB !== false) {
                // Tiến hành cập nhật
                sb.notify({
                    type: 'post-ajax-data',
                    data: {
                        action: 'Update' + w.name,
                        controller: 'POSF0039',
                        typePostParameter: function () {
                            var dataPost = {
                                APK: posViewModel.TempAPKMaster
                            };
                            if (w.dataType === 'number') {
                                dataPost[w.name] = w.getValue().toString().replace(/,/g, '');
                            } else {
                                dataPost[w.name] = w.getValue();
                            }
                            return dataPost;
                        }(),
                        callBack: function (result) {
                            grid.refetch(result && result.Data && result.Data.Details);
                            form.refetch(result && result.Data && result.Data.Master, w.name);
                            w.turnOnChange();
                        }
                    }
                });
            } else {

            }
            // Nếu có thêm sự kiện nào khác, thì xử lý
            if (w.additionalChangeHandler) {
                w.additionalChangeHandler(w);
                w.turnOnChange();
            }
        };

        // Hàm được gọi sau khi cập nhật thành công
        w.updateSuccess = function (result) {
            LOG('updateSuccess');
            LOG(result);
            w.turnOnChange();
        };

        // Hủy các sự kiện change
        w.turnOffChange = function () {
            // Nếu widget là một kendo widget
            // thì hủy sự kiện kiểu kendo
            if (w.element && w.type === 'kendo') {
                if (this.element.options.name === "ComboBox") {
                    w.element.unbind('select', w.changeHandler);
                } else {
                    w.element.unbind('change', w.changeHandler);
                }
                // Nếu là jquery
                // thì hủy sự kiện kiểu jquery
            } else if (w.element && w.type === 'jquery') {
                w.element.off('change', w.changeHandler);
            } else {

            }
        };

        w.turnOnChange = function () {
            // Nếu widget là một kendo widget
            // thì hủy sự kiện kiểu kendo
            if (this.disableChangeEvent) {
                return;
            }
            if (this.element && this.type === 'kendo') {
                if (this.element.options.name === "ComboBox") {
                    this.element.unbind('select', this.changeHandler);
                    this.element.bind('select', this.changeHandler);
                } else {
                    this.element.unbind('change', this.changeHandler);
                    this.element.bind('change', this.changeHandler);
                }
                // Nếu là jquery
                // thì hủy sự kiện kiểu jquery
            } else if (this.element && this.type === 'jquery') {
                this.element.off('change', this.changeHandler);
                this.element.on('change', this.changeHandler);
            } else {

            }

        };

        w.focus = function () {
            this.jInput.focus();
        }

        init();
        return w;
    }

    // Hàm tạo đối tượng grid item để thêm vào lưới
    function GridItem(ajaxItem) {
        var gi = Object.create(ajaxItem);

        gi.ajaxItem = ajaxItem;

        gi.recalculate = function () {
            //gi.InventoryAmount = gi.UnitPrice * gi.Quantity;
            //gi.ajaxItem.Quantity = gi.Quantity;
            //gi.ajaxItem.UnitPrice = gi.UnitPrice;
            //gi.ajaxItem.InventoryAmount = gi.InventoryAmount;
        }

        gi.recalculate();
        return gi;
    }

    // Đối tượng grid để quản lý grid mặt hàng
    grid = function (name) {
        // đối tượng sẽ được trả về
        var g = {},
            element = $('#' + name);

        // Nếu tên grid không phải control kendoGrid, thì trả về undefined
        if (!(g.kGrid = element.data('kendoGrid'))) {
            return;
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

                // Nếu ô (<td>) hiện tại có thuộc tính data-edit-disabled
                // ... thì chặn, không cho edit
                if (cell.attr('data-edit-disabled')) {
                    return;
                }
                // Ngược lại thì cho phép edit
                editCell.call(this, cell);
            };
        })(kendo.ui.Grid.fn.editCell);

        // lấy class css chỉ định màu cho item, dựa trên statusID
        function getRowCSSClassName(statusID) {
            switch (statusID) {
                case 1: return "black";
                case 2: return "red";
                case 3: return "green";
                default: return "black-text";
            }
        }

        // Xử lý sự kiện click nút xóa mặt hàng trên grid
        function btnDeleteItem_Click(e) {

            var
                // Lấy đối tượng jQuery của nút xóa
                jElement = $(this),
                // lấy thuộc tính 'disabled' (nếu có)
                disabled = jElement.attr('data-disabled-delete')
            ;

            // Nếu có thuộc tính disable, thì dừng
            if (disabled) {
                return;
            }

            var
                // Lấy ra apk Detail
                apkDetail = jElement.attr('data-apk'),

                // Lấy ra statusRecordID
                statusRecordID = jElement.attr('data-status-record-id'),

                // Tạo dữ liệu để gửi lên server
                dataPost = {
                    apkMaster: posViewModel.TempAPKMaster,
                    apkDetail: apkDetail,
                    statusRecordID: statusRecordID
                }
            ;

            // Xác nhận trước khi xóa
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'),
                // YES
                function () {
                    // Gửi yêu cầu xóa cho module sever-communicator
                    sb.notify({
                        type: 'post-ajax-data',
                        data: {
                            action: 'UpdateStatusCancel',
                            controller: 'POSF0039',
                            typePostParameter: dataPost,
                            callBack: function (result) {
                                // Nếu xóa thành công, thì refresh form và grid
                                // bằng trên kết quả trả về từ server
                                if (result && result.Data) {
                                    if (result.Data.Master) {
                                        form.refetch(result.Data.Master);
                                    }
                                    if (result.Data.Details) {
                                        grid.refetch(result.Data.Details);
                                    }
                                }
                            }
                        }
                    });
                },
            // NO
            function () {
                LOG(e);
                LOG($(e.currentTarget));
            });
        }

        // Disable edit cell, by row index and column index
        function disableCellAt(row, col) {
            var cell = g.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(row, col));
            // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
            cell.attr('data-edit-disabled', 1);
        }

        // Lấy ra một ô trên lưới 
        function getCellAt(row, col) {
            var cell = g.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(row, col));
            // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
            return cell;
        }

        // shortcut đến dataSource của lưới
        g.dataSource = g.kGrid.dataSource;

        // Xóa một item khỏi lưới, dựa trên apk
        g.removeItemByAPK = function (apk) {
            LOG(apk);
            var i = 0,
                itemList = this.kGrid.dataSource.data(),
                l = itemList.length,
                found = null;

            if (apk) {
                for (; i < l; i++) {
                    if (itemList[i].APK === apk) {
                        found = itemList[i];
                    }
                }
            }
            if (found) {
                this.kGrid.dataSource.remove(found);
                this.refetch();

            } else {
                LOG('Error: apk not found');
            }
        };

        // Lấy dataSource
        g.getDataSource = function () {
            return this.kGrid.dataSource;
        };

        // Lấy dataSource
        g.getDataItems = function () {
            return this.kGrid.dataSource.data();
        };

        // Thêm một item vào lưới, 
        // nếu trên lưới đã tồn tại item thì cộng dồn số lượng, không thêm dòng mới
        g.addItem = function (ajaxItem) {
            var i = 0,
                l = this.kGrid.dataSource.data().length,
                oldItem,
                newItem = GridItem(ajaxItem);

            for (; i < l; i++) {
                oldItem = this.kGrid.dataSource.at(i);
                if (oldItem.InventoryID === newItem.InventoryID) {
                    oldItem.Quantity += newItem.Quantity;
                    oldItem.InventoryAmount += newItem.Quantity * newItem.UnitPrice;
                    this.kGrid.refresh();
                    return;
                }
            }
            this.kGrid.dataSource.add(newItem);
            this.kGrid.refresh();
            return newItem;
        };

        // Thêm item vào lưới, luôn thêm dòng mới, không cộng dồn số lượng
        g.addItemNew = function (ajaxItem) {
            var
                // Tạo đối tượng GridItem từ đối tượng ajax trả về
                newItem = GridItem(ajaxItem.ajaxItem || ajaxItem)
            ;

            newItem.APKMaster = posViewModel.TempAPKMaster;
            this.kGrid.dataSource.add(newItem);
            this.kGrid.refresh();
            return newItem;
        };

        // Thêm một DANH SÁCH nhiều item vào lưới
        // nếu item đã tồn tại thì cộng dồn số lượng
        g.addDistinctItems = function (itemList) {
            var i = 0, l = 0, addedItem, returnList = [];
            if (Array.isArray(itemList)) {
                l = itemList.length;
                for (; i < l; i++) {
                    addedItem = this.addItem(itemList[i]);

                    if (addedItem) {
                        returnList.push(addedItem);
                    }
                }
                this.kGrid.refresh();

                if (returnList && returnList.length > 0) {
                    for (i = 0, l = returnList.length; i < l; i++) {
                        $(this.kGrid
                            .tbody
                            .find("tr")[i]).css('color', getRowCSSClassName(returnList[i].StatusRecordID));
                    }
                }
                return returnList;
            }
        };

        // refresh grid mặt hàng
        // có bao gồm một số tính năng như đổi màu chữ, lock chỉnh sửa một số ô
        // @itemList : nếu có, thì hàm clear dataSource và thêm các item này vào,
        //             nếu không có, thì grid refresh bằng dataSource hiện tại
        g.refetch = function (itemList, onEdit) {
            var
                i = 0,
                l = 0,
                addedItem,
                returnList = [],
                cell,
                btnDelete,
                counting = 0
            ;

            // Nếu itemList chính là dataSource hiện tại của list
            //  (tức là lưới đang refresh dữ liệu hiện tại, chứ không nhận dữ liệu mới)
            // thì backup lại dữ liệu của lưới, để thêm lại
            if (!itemList || this.kGrid.dataSource.data() === itemList) {
                itemList = this.clearDataSource();
            } else {
                // Nếu lưới nhận dữ liệu mới, thì clear dữ liệu hiện tại
                this.clearDataSource();
            }

            // Nếu itemList là array
            if (Array.isArray(itemList)) {
                // cache kích thước danh sách
                l = itemList.length;
                // Duyệt qua từng phần tử để thêm vào lưới
                for (; i < l; i++) {
                    addedItem = this.addItemNew(itemList[i]);
                    if (addedItem) {
                        returnList.push(addedItem);
                    }
                }
                // Duyệt từng phần tử của lưới để "tô màu"
                // (tô màu bằng jQuery.css('color') để override css mặc định của kendo
                // và gán sự kiện cho btn xóa
                for (i = 0 ; i < l; i++) {
                    $(this.kGrid
                        .tbody
                        .find("tr")[i]).css('color', getRowCSSClassName(returnList[i].StatusRecordID));

                    //Nếu status là 3 (đã in hóa đơn)
                    //Thì lock ô số lượng (không  cho sửa)
                    if (returnList[i].StatusRecordID === 2
                        || returnList[i].StatusRecordID === 3
                        || returnList[i].IsPromotion === 1) {
                        disableCellAt(i, 4);
                    }

                    // Nếu mặt hàng là đã được in hóa đơn hoặc 
                    // mặt hàng là hàng khuyến mãi
                    // thì disable và "làm mờ" nút xóa
                    if (returnList[i].StatusRecordID === 3
                        || returnList[i].IsPromotion === 1) {
                        cell = getCellAt(i, 11);
                        cell.find('a').attr('data-disabled-delete', 1).css('cursor', 'auto').css('opacity', '0.4');
                    }


                    // Nếu là hàng khuyến mãi thì disable edit số lượng, disable xóa
                    if (returnList[i].IsPromotion === 1) {
                        disableCellAt(i, 6);
                        disableCellAt(i, 8);
                    }

                    // Chặn sự kiện gây thay đổi nút xóa 
                    // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
                    disableCellAt(i, 11);
                    disableCellAt(i, 7);
                    disableCellAt(i, 9);
                }

                btnDelete = this.kGrid.tbody.find('>tr a[data-role="btnDelete"]')

                // nếu không ở trạng thái edit
                if (!onEdit) {
                    // Gán sự kiện cho nút delete
                    btnDelete.on('click', btnDeleteItem_Click);
                    if (fromAutoComplete) {
                        this.focusLastRowQuantity();
                        fromAutoComplete = false;
                    }
                } else {
                    btnDelete.addClass('asf-btn-delete-disabled');
                    this.kGrid.tbody.find('td').attr('data-edit-disabled', 1).css('cursor', 'auto').css('opacity', '0.4');;
                }
                return returnList;
            }
        };

        // focus vào tại vị trí index của lưới khi lưới được thêm dòng mới
        // nếu không truyền vào index thì duyệt tự dưới lên, 
        // focus vào dòng đầu tiên được phép sửa
        g.focusLastRowQuantity = function (index) {
            var
                // index sẽ bằng index truyền vào, 
                // hoặc bằng index dòng cuối cùng của lưới
                index = index || this.dataSource.data().length - 1,

                // phần tử tại vị trí index trong dataSource
                targetItem = this.dataSource.at(index),

                // reference tới một ô trên lưới
                cell
            ;

            // Nếu không tìm thấy phần tử thì dừng
            if (!targetItem) {
                return;
            }

            // Nếu item đã được "in hóa đơn/ in chế biến", hoặc là khuyến mãi
            // thì không focus, tiến hành đệ quy, 
            // focus dòng ngay trên item hiện tại
            if (targetItem.StatusRecordID !== 1
                || targetItem.IsPromotion === 1) {
                return this.focusLastRowQuantity(index - 1);
            }

            // Lấy ra ô "số lượng" của dòng hiện tại
            cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(index, 4));

            // set Timeout focus vào ô số lượng
            // (vì kendo grid tạo textbox để edit số lượng trễ hơn hàm này
            setTimeout(function () {
                kendo.ui.Grid.fn.editCell.call(g.kGrid, cell);
                $('input#ActualQuantity').focus().select();
                fromAutoComplete = false;
            }, 200);
        };

        // refresh grid, khi grid ở trạng thái edit
        g.refetchOnEdit = function (itemList, onEdit) {
            var
                i = 0,
                l = 0,
                addedItem,
                returnList = [],
                cell,
                btnDelete,
                counting = 0;
            ;

            // Nếu itemList chính là dataSource hiện tại của list
            //  (tức là lưới đang refresh dữ liệu hiện tại, chứ không nhận dữ liệu mới)
            // thì backup lại dữ liệu của lưới, để thêm lại
            if (!itemList || this.kGrid.dataSource.data() === itemList) {
                itemList = this.clearDataSource();
            } else {
                // Nếu lưới nhận dữ liệu mới, thì clear dữ liệu hiện tại
                this.clearDataSource();
            }

            // Nếu itemList laf array
            if (Array.isArray(itemList)) {
                // cache kích thước danh sách
                l = itemList.length;
                // Duyệt qua từng phần tử để thêm vào lưới
                for (; i < l; i++) {
                    addedItem = this.addItemNew(itemList[i]);
                    if (addedItem) {
                        returnList.push(addedItem);
                    }
                }
                // Duyệt từng phần tử của lưới để "tô màu"
                // và gán sự kiện cho btn xóa

                for (i = 0 ; i < l; i++) {
                    $(this.kGrid
                        .tbody
                        .find("tr")[i]).css('color', getRowCSSClassName(returnList[i].StatusRecordID));

                    // Nếu status là 2 (đã chế biến)
                    // Thì lock ô số lượng (không  cho sửa)
                    if (returnList[i].StatusRecordID === 2) {
                        cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 4));
                        // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
                        cell.attr('data-edit-disabled', 1);
                    }

                    //Nếu status là 3 (đã in hóa đơn)
                    //Thì lock ô số lượng (không  cho sửa)
                    if (returnList[i].StatusRecordID === 3) {
                        cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 4));
                        // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
                        cell.attr('data-edit-disabled', 1);

                        cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 11));
                        cell.find('a').attr('data-disabled-delete', 1);
                    }

                    // Chặn sự kiện gây thay đổi nút xóa 
                    // Thêm thuộc tính data-edit-disabled sẽ tự động làm cho ô không sửa được
                    cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 11));
                    cell.attr('data-edit-disabled', 1);
                    cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 7));
                    cell.attr('data-edit-disabled', 1);
                    cell = this.kGrid.tbody.find(">tr:eq({0}) >td:eq({1})".format(i, 9));
                    cell.attr('data-edit-disabled', 1);
                }

                btnDelete = this.kGrid.tbody.find('>tr a[data-role="btnDelete"]')
                if (!onEdit) {
                    // Gán sự kiện cho nút delete
                    btnDelete.on('click', btnDeleteItem_Click);
                } else {
                    btnDelete.addClass('asf-btn-delete-disabled');
                    this.kGrid.tbody.find('td').attr('data-edit-disabled', 1);
                }

                return returnList;
            }
        };

        // remove tất cả item trong dataSource
        // Trả về một array (backup) các phần tử trong dataSource 
        g.clearDataSource = function () {
            var
                backupList = [],
                dataSource = g.kGrid.dataSource,
                item;

            while (dataSource.data().length > 0) {
                item = dataSource.at(0);
                backupList.push(item);
                dataSource.remove(item);
            }

            return backupList;
        };

        // remove tất cả item trong dataSource
        // return undefined
        g.resetDataSource = function () {
            var dataSource = this.kGrid.dataSource,
                item;

            while (dataSource.data().length > 0) {
                item = dataSource.at(0);
                dataSource.remove(item);
            }
        };

        // Tính lại giá trị của các trường, theo công thức
        g.recalculateItems = function () {
            this.eachItem(function (i, item) {
                item.recalculate();
            });
        };

        // Tìm một đối tượng row item theo apk
        g.findByAPKDetail = function (apk) {
            var i = 0,
                l = this.kGrid.dataSource.data().length,
                items = this.kGrid.dataSource.data();

            for (; i < l; i++) {
                if (items[i].APK === apk) {
                    return items[i];
                }
            }
        };

        g.updateDetailSucceeded = function (result) {
            form.refetch(result && result.Data && result.Data.Master);
            g.refetch(result && result.Data && result.Data.Details);
            currentMaster = result.Data.Master;
            currentDetails = result.Data.Details;
        };

        // Xử lý sự kiện grid save
        g.gridSave = function (e) {
            LOG(JSON.stringify(e.values));
            LOG(this);
            var
                // Tìm item tương ứng trong dataSource
                item = g.findByAPKDetail(e.model.APK),
                // model vừa được thay đổi
                model = e.model,
                // giá trị vừa được thay đổi
                values = e.values,
                // illiterator
                value = null,
                dataPost = {};

            // Cập nhật các giá trị thay đổi vào model
            for (value in values) {
                if (values.hasOwnProperty(value)) {
                    if (model.hasOwnProperty(value)) {
                        model[value] = values[value];
                    }
                }
            }
            dataPost.Master = null;
            dataPost.Details = [];
            dataPost.Details.push(e.model);
            dataPost.CommitDB = true;
            // gửi item vừa thay đổi lên server
            sb.notify({
                type: 'post-ajax-data',
                data: {
                    action: 'UpdateMasterDetail',
                    controller: 'POSF0039',
                    typePostParameter: dataPost,
                    callBack: function (result) {
                        grid.refetch(result && result.Data && result.Data.Details);
                        form.refetch(result && result.Data && result.Data.Master);

                        currentMaster = result.Data.Master;
                        currentDetails = result.Data.Details;

                        throw 'TO TO: if this continues, grid text will turn black ...';
                        //w.turnOnChange();
                    }
                }
            });
        }

        g.gridEdit = function (e) {
            element.find('input[type="text"]').select().putCursorAtEnd();
            setTimeout(function () {
                element.find('input[type="text"]').select();
            }, 40);

        }

        g.gridChange = function (e) {
            //LOG('grid gridChange');
        }

        g.kGrid.bind('save', g.gridSave);
        g.kGrid.bind('edit', g.gridEdit);
        //g.kGrid.bind('change', g.gridChange);
        return g;
    }(GRID_NAME);


    // Lấy dữ liệu ajax, hiển thị lên màn hình
    function populateMasterAndDetails(data) {
        var master = data.MasterData,
            detail = data.DetailData,
            forcedInclude = ['VoucherDate', 'CurrencyID', 'APKPaymentID', 'PaymentObjectID01', 'AccountNumber01', 'PaymentObjectID02', 'AccountNumber02', 'Change', 'TotalDiscountAmount', 'TotalDiscountRate', 'TotalInventoryAmount', 'MemberName'];

        currentMaster = data.Master;
        currentDetails = data.Details;

        grid.clearDataSource();
        // Nếu có dữ liệu master
        if (master) {
            posViewModel.set("VoucherNo", master.VoucherNo);
            // Gán apk vào posViewModel
            posViewModel.TempAPKMaster = master.APK;
            // notify task-button
            sb.notify({
                type: 'enable-task-buttons', // content-master listens
                data: {
                    TempAPKMaster: master.APK
                }
            });

            form.refetch(master, [], forcedInclude);
        }

        // Nếu có dữ liệu detail
        if (detail) {
            grid.refetch(detail);
        }

        refetchMasterAndDetails(master, detail)
    }

    // Khởi tạo các widget
    function initFormWidget() {
        var widget = null;
        // Ngày chứng từ
        form.widgets.push(Widget({
            name: 'VoucherDate',
            type: 'kendo',
            element: $('#VoucherDate').data('kendoDatePicker'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'VoucherNo',
            type: 'jquery',
            element: $('#VoucherNo'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'MemberName',
            type: 'jquery',
            element: $('#MemberName'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'CurrencyID',
            type: 'kendo',
            element: $('#CurrencyID').data('kendoComboBox'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'APKPaymentID',
            type: 'kendo',
            element: $('#APKPaymentID').data('kendoComboBox'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'AccountNumber01',
            type: 'jquery',
            element: $('#AccountNumber01'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'AccountNumber02',
            type: 'jquery',
            element: $('#AccountNumber02'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'PaymentObjectID01',
            type: 'kendo',
            element: $('#PaymentObjectID01').data('kendoComboBox'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        form.widgets.push(Widget({
            name: 'PaymentObjectID02',
            type: 'kendo',
            element: $('#PaymentObjectID02').data('kendoComboBox'),
            disableChangeEvent: true,
            commitDB: false,
        }));

        // Tên hội viên
        form.widgets.push(Widget({
            name: 'MemberIDHidden',
            type: 'jquery',
            element: $('#PaymentObjectID02'),
            disableChangeEvent: true,
            commitDB: false,
        }));


        //  Tổng tiền thuế
        form.widgets.push(Widget({
            name: 'TotalTaxAmount',
            type: 'span',
            element: $('#TotalTaxAmount'),
            dataType: 'number',
            format: 'money'
        }));

        //  tiền thừa
        form.widgets.push(Widget({
            name: 'Change',
            type: 'span',
            element: $('#Change'),
            dataType: 'number',
            format: 'money'
        }));

        // Chiết khấu 
        form.widgets.push(Widget({
            name: 'TotalDiscountRate',
            type: 'jquery',
            element: $('#TotalDiscountRate'),
            dataType: 'number',
            format: 'percent'
        }));
        form.widgets.push(Widget({
            name: 'TotalDiscountAmount',
            type: 'jquery',
            element: $('#TotalDiscountAmount'),
            dataType: 'number',
            format: 'money'
        }));

        // Tiền giảm giá
        form.widgets.push(Widget({
            name: 'TotalRedureRate',
            type: 'jquery',
            element: $('#TotalRedureRate'),
            dataType: 'number',
            format: 'percent'
        }));
        form.widgets.push(Widget({
            name: 'TotalRedureAmount',
            type: 'jquery',
            element: $('#TotalRedureAmount'),
            dataType: 'number',
            format: 'money'

        }));


        // Tổng tiền
        form.widgets.push(Widget({
            name: 'TotalAmount',
            type: 'span',
            element: $('#TotalAmount'),
            dataType: 'number',
            format: 'money'
        }));

        // Tổng tiền
        form.widgets.push(Widget({
            name: 'TotalInventoryAmount',
            type: 'span',
            element: $('#TotalInventoryAmount'),
            dataType: 'number',
            format: 'money',
            additionalChangeHandler: function (w) {
                //LOG('PaymentObjectAmount01');
                var change = form.findWidgetByID('PaymentObjectAmount01').getValue()
                + form.findWidgetByID('PaymentObjectAmount02').getValue()
                - form.findWidgetByID('TotalInventoryAmount').getValue();

                form.findWidgetByID('Change').setValue(change)
            },
        }));

        form.widgets.push(Widget({
            name: 'PaymentObjectAmount01',
            type: 'jquery',
            element: $('#PaymentObjectAmount01'),
            additionalChangeHandler: function (w) {
                //LOG('PaymentObjectAmount01');
                var change = form.findWidgetByID('PaymentObjectAmount01').getValue()
                + form.findWidgetByID('PaymentObjectAmount02').getValue()
                - form.findWidgetByID('TotalInventoryAmount').getValue();

                form.findWidgetByID('Change').setValue(change)
            },
            commitDB: true,
            dataType: 'number',
            format: 'money'
        }));

        // {1}
        form.widgets.push(Widget({
            name: 'PaymentObjectAmount02',
            type: 'jquery',
            element: $('#PaymentObjectAmount02'),
            additionalChangeHandler: function (w) {
                var change = form.findWidgetByID('PaymentObjectAmount01').getValue()
                + form.findWidgetByID('PaymentObjectAmount02').getValue()
                - form.findWidgetByID('TotalInventoryAmount').getValue();

                form.findWidgetByID('Change').setValue(change)
            },
            commitDB: true,
            format: 'money',
            dataType: 'number'
        }));


        //$("#TotalDiscountAmount").keyup(function (e) {
        //    var value = posViewModel.convertToNumber($(this).val());
        //    //value = kendo.toString(value, "#,##0.##");
        //    value = formatConvertedDecimal(value);
        //    $(this).val(value);
        //});

        //$("#TotalRedureAmount").keyup(function (e) {
        //    var value = posViewModel.convertToNumber($(this).val());
        //    value = formatConvertedDecimal(value);
        //    $(this).val(value);
        //});

        //$("#PaymentObjectAmount01").keyup(function (e) {
        //    var value = posViewModel.convertToNumber($(this).val());
        //    value = formatConvertedDecimal(value);
        //    $(this).val(value);
        //});

        //$("#PaymentObjectAmount02").keyup(function (e) {
        //    var value = posViewModel.convertToNumber($(this).val());
        //    value = formatConvertedDecimal(value);
        //    $(this).val(value);
        //});
    }

    // Hàm xử lý khi 
    function addItemsToGrid(data) {
        var result = data.result;

        if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE CHOOSEN');
            return;
        }
        fromAutoComplete = data.fromAutoComplete || false;
        if (!result || !result.Data) {
            LOG('result is undefined');
            return;
        }

        if (result.MessageID) {
            utils.warn("POSF0040", result.MessageID);
            data.fromAutoComplete = false;
        }

        //form.refetch(result.Data.Master);

        sb.notify({
            type: 'get-ajax-data', // db listens
            data: {
                action: 'GetMasterDetailAfterChooseInventories',
                controller: 'POSF0039',
                queryString: '?apk={0}'.format(posViewModel.TempAPKMaster),
                callBack: function (result) {
                    refetchMasterAndDetails(result.Data.Master, result.Data.Details);
                    fromAutoComplete = data.fromAutoComplete || false;
                }


            }
        });
    }

    function reloadFetchAll(result) {
        if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE CHOOSEN');
            return;
        }

        // Lấy dữ liệu
        sb.notify({
            type: 'get-ajax-data', // db listens
            data: {
                action: 'GetMasterDetailAfterChooseInventories',
                controller: 'POSF0039',
                queryString: '?apk={0}'.format(posViewModel.TempAPKMaster),
                callBack: function (result) {
                    grid.refetch(result.Data.Details);
                    form.refetch(result.Data.Master);
                }
            }
        });
    }

    // Kiểm tra trạng thái trước khi in chế biến
    function checkCurrentStateTable(data) {
        if (grid.getDataSource().data().length === 0) {
            utils.error('#POSF0040', 'POSM000040');

        }
        else if (currentMaster.StatusTableID === 3) {
            utils.error('#POSF0040', 'POSM000048');
        }
        else if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE');
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('NO TABLE'));
        } else {
            data.callBack();
        }
    }

    // Kiểm tra trạng  thái trước khi "in hóa đơn"
    function checkCurrentStateBill(data) {
        // Nếu không có dòng nào trên lưới, thì báo lỗi
        if (grid.getDataSource().data().length === 0) {
            LOG('NO ITEM ON GRID');
            utils.error('#POSF0040', 'POSM000053');

        }
            // Nếu không có bàn nào được chọn, thì báo lỗi
        else if (!posViewModel.TempAPKMaster) {
            LOG('NO TABLE');
            ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('NO TABLE'));
        } else {
            data.callBack();
        }
    }

    function saveSelectedInventories(newItems) {
        var i = 0,
                 l = newItems.length,
            inventoryIDList = [];

        for (; i < l; i++) {
            inventoryIDList.push(newItems[i].InventoryID);
        }

        sb.notify({
            type: 'post-ajax-data',
            data: {
                action: 'SaveSelectedInventories',
                controller: 'POSF0038',
                //queryString: '?areaID={0}&tableID={1}'.format(selectedTable.Area.AreaID, selectedTable.TableID),
                //parameters: {},
                typePostParameter: {
                    inventoryIDList: inventoryIDList,
                    areaID: ASOFTCORE.globalVariables.currentTable.AreaID,
                    apk: posViewModel.TempAPKMaster
                },
                callBack: ASOFT.asoftPopup.hideIframe
            }
        });
    }

    // Xử lý sau khi chọn hội viên
    function memberChoosen_Handler(data) {
        var member = data.memberEntity;
        posViewModel.set('TotalDiscountRate', member.DiscountRate || 0);

        // notify server
        // lưu thông tin hội viên vừa chọn
        sb.notify({
            type: 'post-ajax-data',
            data: {
                action: 'UpdateMemberInfo',
                controller: 'POSF0039',
                typePostParameter: function () {
                    var dataPost = {};
                    dataPost.Master = {
                        APK: posViewModel.TempAPKMaster
                    };
                    dataPost.Master['MemberID'] = member.MemberID;
                    dataPost.Master['MemberName'] = member.MemberName;
                    dataPost.Master['TotalDiscountRate'] = member.DiscountRate || 0;
                    return dataPost;
                }(),
                callBack: function (result) {
                    refetchMasterAndDetails(result.Data.Master, result.Data.Details);
                }
            }
        });
    }

    // refresh màn hình
    function refetchMasterAndDetails(master, details) {
        if (!master || !details || !Array.isArray(details)) {
            return;
        }
        form.refetch(master);
        grid.refetch(details);
        currentMaster = master;
        currentDetails = details;
    }

    // refresh màn hình ở trạng thái edit
    function refetchMasterAndDetailsOnEdit(master, details) {
        if (!master || !details || !Array.isArray(details)) {
            return;
        }
        var include = [
            'VoucherNo',
            'Change',
            'PaymentObjectAmount01',
            'PaymentObjectAmount02',
            'MemberName',
            'CurrencyID'
        ];
        form.refetchOnEdit(master, [], include);
        grid.refetchOnEdit(details, true);
        currentMaster = master;
        currentDetails = details;
    }

    // refresh màn hình
    function refetchAll(data) {
        if (!data || !data.master || !data.details) {
            return;
        }
        refetchMasterAndDetails(data.master, data.details);
    }

    // Lấy dữ liệu từ server theo apk truyền vào
    // load lại form
    function refetchMasterDetailsByAPKMaster(data) {
        if (!data || !data.apk) {
            return;
        }
        if (!utils.isGuid(data.apk)) {
            LOG('invalid guid');
            return;
        }
        sb.notify({
            type: 'get-ajax-data', // db listens
            data: {
                action: 'GetMasterDetailAfterChooseInventories',
                controller: 'POSF0039',
                queryString: '?apk={0}'.format(data.apk),
                callBack: function (result) {
                    if (!result
                    || !result.Data
                    || !result.Data.Master
                    || !result.Data.Details) {
                        return
                    }
                    result.Data.Master.AreaName = data.AreaName;
                    refetchMasterAndDetails(result.Data.Master, result.Data.Details);
                    posViewModel.TempAPKMaster = data.apk;
                }
            }
        });
    }

    // trả về đối tượng chứ thông tin form
    function getFromJson(data) {
        var json = form.JSON();
        if (data && utils.isFunc(data.callBack)) {
            data.callBack(json);
        }
    }

    // Xử lý sự kiện click nút khuyến mãi theo phần trăm
    function btnUpdatePromotionByDiscountPercent_Click(data) {
        LOG('btnPromotion_Click');
        var data = {
            APK: posViewModel.TempAPKMaster,
            TotalAmount: form.findWidgetByID('TotalAmount').getValue()
        };
        sb.notify({
            type: 'post-ajax-data', // db listens
            data: {
                action: 'UpdatePromotionByDiscountPercent',
                controller: 'POSF0039',
                typePostParameter: data,
                //queryString: '?apk={0}'.format(ASOFTCORE.globalVariables.apkMaster),
                callBack: function (result) {
                    if (!result
                    || !result.Data
                    || !result.Data.Master
                    || !result.Data.Details) {
                        return LOG('result from server is not valid');
                    }
                    refetchMasterAndDetails(result.Data.Master, result.Data.Details);

                }
            }
        });
        $('#floating-buttons-container').toggleClass('asf-disabled-visibility');
        $(document).on('click', function (e) {
            $('#floating-buttons-container').addClass('asf-disabled-visibility');
        });
    }

    // Xử lý sự kiện click nút khuyến mãi theo số tiền
    function btnUpdatePromotionByDiscountAmount_Click(data) {
        LOG('btnPromotion_Click');
        var data = {
            APK: posViewModel.TempAPKMaster,
            TotalAmount: form.findWidgetByID('TotalAmount').getValue()
        };


        sb.notify({
            type: 'post-ajax-data', // db listens
            data: {
                action: 'UpdatePromotionByDiscountAmount',
                controller: 'POSF0039',
                typePostParameter: data,
                //queryString: '?apk={0}'.format(ASOFTCORE.globalVariables.apkMaster),
                callBack: function (result) {
                    if (!result
                    || !result.Data
                    || !result.Data.Master
                    || !result.Data.Details) {
                        return LOG('result from server is not valid');
                    }
                    refetchMasterAndDetails(result.Data.Master, result.Data.Details);
                }
            }
        });
        $('#floating-buttons-container').toggleClass('asf-disabled-visibility');
        $(document).on('click', function (e) {
            $('#floating-buttons-container').addClass('asf-disabled-visibility');
        });
    }

    // Ẩn các nút khuyến mãi
    function hideFloatButtons(e) {
        floatingButtons.addClass(CSS_HIDDEN);
    }

    // Xử lý sự kiện click vào nút khuyến mãi
    // Hiển thị 2 nút khuyến mãi: "theo tiền" và theo "phần trăm"
    function btnPromotion_Click(data) {
        floatingButtons.toggleClass(CSS_HIDDEN);
        $(document).off('click', hideFloatButtons).on('click', hideFloatButtons);
    }

    return {
        // Hàm sẽ chạy lúc khởi tạo module
        init: function () {
            // Override chuỗi dùng để format số 
            initFormWidget();
            sb.listen({
                'refetch-master-details-by-apk-master': refetchMasterDetailsByAPKMaster,
                'refetch-master-details': refetchAll,
                'refetch-master-details-on-edit': refetchMasterAndDetailsOnEdit,
                'fill-all-fields': populateMasterAndDetails,
                'add-items-to-grid': addItemsToGrid,// reloadGrid,
                //'add-more-items-to-grid': addMoreItems,
                'refresh-main-grid': reloadFetchAll,
                'add-items-to-grid-refresh-master': addItemsToGrid,

                //'refresh-main-grid-only': reloadGridOnly,
                // Disable các control trên màn hình bán hàng
                'disable-form': form.disableForm,
                // Xử lý sự kiện khi chọn hội viên từ autocomplete
                'member-id-choosen': memberChoosen_Handler,
                // Xử lý sự kiện gridSave
                'grid-save-event': grid.gridSave,
                // Xóa dữ liệu trên lưới, được gọi khi reset màn hình bán hàng
                'clear-grid-data-source': grid.clearDataSource,
                // Xử lý sự kiện click nút gộp tách bàn
                'try-open-merge-split-table': checkCurrentStateTable,
                // Xử lý sự kiện click nút gộp tách bill
                'try-open-merge-split-bill': checkCurrentStateBill,
                // Xử lý khi có mudule muốn lấy dữ liệu master dạng JSON
                'get-form-json': getFromJson,
                // Xử lý sự kiện ấn nút "CT Khuyến mãi"
                'btnPromotion_Click': btnPromotion_Click,
                // Xử lý sự kiện click nút "khuyến mãi theo số tiền giảm giá"
                'btnUpdatePromotionByDiscountAmount_Click': btnUpdatePromotionByDiscountAmount_Click,
                // Xử lý sự kiện click nút "khuyến mãi theo phần trăm giảm giá"
                'btnUpdatePromotionByDiscountPercent_Click': btnUpdatePromotionByDiscountPercent_Click
            });

            // Nếu màn hình đang ở trạng thái edit (view only)
            // thì lấy dữ liệu cho màn hình từ bảng POST0016 & POST00161
            // và không tự động mở màn hình chọn bàn
            if (ASOFTCORE.globalVariables.isEditMode) {
                // notify sever-communicator
                sb.notify({
                    type: 'get-ajax-data',
                    data: {
                        action: 'LoadDataOnEdit',
                        controller: 'POSF0039',
                        queryString: '?apk={0}'.format(ASOFTCORE.globalVariables.apkMaster),
                        callBack: function (result) {
                            if (!result
                            || !result.Data
                            || !result.Data.Master
                            || !result.Data.Details) {
                                return LOG('result from server is not valid');
                            }
                            result.Data.Details.forEach(function (item) {
                                // TODO: hardcode
                                item.StatusRecordID = 0;

                            });
                            refetchMasterAndDetailsOnEdit(result.Data.Master, result.Data.Details);
                        }
                    }
                });

                // Hiển thị nội dung của màn hình
                $('#Header').removeClass(CSS_HIDDEN);
                $('#contentMaster').removeClass(CSS_HIDDEN);

                resizeGrid();

                // Gán sự kiện cho nút "chọn bàn"
                $('#btnChooseTable').attr('data-asf-event-handler', 'btnChooseTableOnEdit_Click');

                // Override sự kiện của nút đóng màn hình
                $("#closeWindow").unbind('click')
                .attr('data-asf-event-handler', 'btnChooseTableOnEdit_Click')
                .on('click', function () {
                    sb.notify({
                        type: 'btnChooseTableOnEdit_Click'
                    });
                });

                posViewModel.TempAPKMaster = $('input[name="_APKMaster"]').val();


            }
                // Nếu màn hình ở trạng thái bình thường (add new), 
                // thì mở màn hình chọn bàn
            else {
                ASOFT.asoftPopup.showIframe('/POS/POSF0036/Default', {});
            }

            // Xử lý nút "CT khuyến mãi"
            // Sử dụng kendo tooltip
            $("#btnPromotion").kendoTooltip({
                //filter: "a",
                content: kendo.template($("#template").html()),
                width: 200,
                //height: 70,
                position: "top",
                autoHide: false,
                showOn: "click",
                showAfter: 200,
                show: function () {
                    $('.k-tooltip-button').remove();
                    $('.k-tooltip-content').removeClass('k-tooltip-content');
                    $("#btnUpdatePromotionByDiscountAmount").unbind('click').kendoButton({ "click": ASOFTCORE.events.button_Clicked });
                    $("#btnUpdatePromotionByDiscountPercent").unbind('click').kendoButton({ "click": ASOFTCORE.events.button_Clicked });
                }
            });


        },

        // Hàm sẽ chạy lúc tắt module
        destroy: function () {
            //sb.removeEvent(button, "click", this.handleSearch);
            sb.ignore([
            'refetch-master-details-by-apk-master',
            'refetch-master-details',
            'refetch-master-details-on-edit',
            'fill-all-fields',
            'add-items-to-grid',
            'add-more-items-to-grid',
            'refresh-main-grid',
            'add-items-to-grid-refresh-master',
            'refresh-main-grid-only',
            'disable-form',
            'member-id-choosen',
            'grid-save-event',
            'clear-grid-data-source',
            'try-open-merge-split-table',
            'try-open-merge-split-bill',
            'get-form-json'
            ]);
        },
    };
}, false);

// Hàm để các phần code khác gọi để refresh toàn bộ màn hình, dựa trên apk Master
//ASOFTCORE.triggerEvent({
//    type: 'refetch-master-details-by-apk-master',
//    data: {
//        apk: '24EEEFD7-0C17-4D82-8742-051BD00F358F',
//        AreaName: 'No where to be found'
//    }
//});