var getGridImport = null;
var getGridExport = null;

function GetBarcode() {
    return { Data: $("#SOF2033_Barcode").val() };
}
$(document).ready(function () {
    getGridImport = $("#GridImport").data("kendoGrid");
    getGridExport = $("#GridExport").data("kendoGrid");

    GRID_AUTOCOMPLETE1.config({
        gridName: 'GridImport',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("DivisionID", dataItem.DivisionID);
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("SalePrice", dataItem.SalePrice);
            selectedRowItem.model.set("OriginalAmount", dataItem.OriginalAmount);
            selectedRowItem.model.set("OrderQuantity", dataItem.OrderQuantity);
            getGridImport.refresh();
        }
    });
});

function SOF2033_btnClose_Click() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage("00ML000016"), function () {
        SOF2033_Save();
    }, function () {
        ASOFT.asoftPopup.closeOnly();
    })
};

function SOF2033_btnSave_Click() {
    SOF2033_Save();
};

function SOF2033_Save() {
    $("form#SOF2033 .asf-message").remove();
    ASOFT.helper.postTypeJson("/SO/SOF2033/ConfirmInComplete", SOF2033_GetData(), function (result) {
        if (result.Status == 0) {
            parent.ReloadSuccess();
            ASOFT.asoftPopup.closeOnly();
        }
        else {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data[0], result.Data[1]);
            }
            ASOFT.form.displayWarning('#SOF2033', msg);
        }
    });
};

function SOF2033_GetData() {
    data = new Array();
    var GridExport = $("#GridExport").data("kendoGrid");
    var dataGridExport = GridExport.dataSource.data();
    var totalNumberExport = dataGridExport.length;
    for (var i = 0; i < totalNumberExport; i++) {
        data.push(GetItemOut(dataGridExport[i]));
    }

    var GridImport = $("#GridImport").data("kendoGrid");
    var dataGridImport = GridImport.dataSource.data();
    var totalNumberImport = dataGridImport.length;
    for (var j = 0; j < totalNumberImport; j++) {
        if (dataGridImport[j].InventoryID != "" && dataGridImport[j].InventoryID != undefined) {
            data.push(GetItemIn(dataGridImport[j]));
        }
    }

    return data;
};

function GetItemOut(currentDataItem) {
    var data = new Array();

    var item = new Object();
    item.key = "VoucherID";
    item.value = currentDataItem.VoucherID;
    data.push(item);

    item = new Object();
    item.key = "Type";
    item.value = $("#SOF2033_Type").val();
    data.push(item);

    item = new Object();
    item.key = "TransactionID";
    item.value = currentDataItem.TransactionID;
    data.push(item);

    item = new Object();
    item.key = "ActualQuantityOut";
    item.value = currentDataItem.MarkQuantity;
    data.push(item);

    item = new Object();
    item.key = "InventoryIDIn";
    item.value = null;
    data.push(item);

    item = new Object();
    item.key = "UnitIDIn";
    item.value = null
    data.push(item);

    item = new Object();
    item.key = "ActualQuantityIn";
    item.value = null;
    data.push(item);

    item = new Object();
    item.key = "VoucherDate";
    item.value = $("#VoucherDate").val();
    data.push(item);

    item = new Object();
    item.key = "ImVoucherDate";
    item.value = $("#ImVoucherDate").val();
    data.push(item);

    item = new Object();
    item.key = "IsBorrow";
    item.value = currentDataItem.IsBorrow;
    data.push(item);
    

    return data;
};

function GetItemIn(currentDataItem) {
    var data = new Array();

    var item = new Object();
    item.key = "VoucherID";
    item.value = currentDataItem.VoucherID;
    data.push(item);

    var item = new Object();
    item.key = "Type";
    item.value = $("#SOF2033_Type").val();
    data.push(item);

    item = new Object();
    item.key = "ActualQuantityOut";
    item.value = null
    data.push(item);

    item = new Object();
    item.key = "InventoryIDIn";
    item.value = currentDataItem.InventoryID;
    data.push(item);

    item = new Object();
    item.key = "UnitIDIn";
    item.value = currentDataItem.UnitID;
    data.push(item);

    item = new Object();
    item.key = "ActualQuantityIn";
    item.value = currentDataItem.ActualQuantity;
    data.push(item);

    item = new Object();
    item.key = "VoucherDate";
    item.value = $("#VoucherDate").val();
    data.push(item);

    item = new Object();
    item.key = "ImVoucherDate";
    item.value = $("#ImVoucherDate").val();
    data.push(item);

    return data;
};


var GRID_AUTOCOMPLETE1 = function (e) {
    var that = {},
        wrapper,
        kWidget,
        searchButton,
        autoComplete,
        dataSource,
        pseudoInput,
        conf,
        posGrid, log = console.log, selectedRowItem;

    function btnSearch_Click(e) {
        var text;
        e.preventDefault();
        text = pseudoInput.val();
        if (text) {
            autoComplete.search(pseudoInput.val());
        }
        pseudoInput.focus();
    }

    function autoComplete_Select(e) {
        var i = 0,
            text = $($(e.item).find('div div')[0]).text(),
            dataItem;
        for (; dataItem = dataSource.at(i++) ;) {
            if (dataItem.InventoryID === text) {
                ////log(dataItem);
                pseudoInput.val(text)
                if (selectedRowItem) {
                    conf.setDataItem(selectedRowItem, dataItem);
                    index = 0;
                    //$('#CboInventoryName-list').remove();
                    autoComplete.setDataSource(backupDataSource);
                    //conf.grid.refresh();
                    ASOFT.asoftGrid.nextCell($(autoComplete.element).closest('td'), conf.gridName, false);
                    //posGrid.addRow();
                    //var index1 = posGrid.dataSource.data().length;
                    //var dataLast = posGrid.dataSource.data()[index1 - 1];
                    //var selectedItem = posGrid.dataItem(posGrid.select());
                    //selectedItem.set("ActualQuantity", 0)
                }
                break;
            }
        }

    }
    var index = 0;
    var isOpen = false;
    var tempreturn = 0;

    function input_keyUp(e) {
        var li, distance, dataItem, i = 0;

        ////log(e.keyCode);
        if (e.keyCode === 13) {
            var li = $('#CboInventoryName-list .k-state-focused').find('div div')[0];
            var text = $(li).text();
            //log(text);
            if (text) {
                //log(2);
                //log(autoComplete.dataSource);
                for (; dataItem = autoComplete.dataSource.data()[i++];) {
                    //log(dataItem.InventoryID);
                    if (dataItem.InventoryID === text) {
                        pseudoInput.val(text)
                        if (selectedRowItem) {
                            index = 0;
                            conf.setDataItem(selectedRowItem, dataItem);
                            autoComplete.setDataSource(backupDataSource);
                            //$('#CboInventoryName-list').remove();
                            //
                            ASOFT.asoftGrid.nextCell($(autoComplete.element).closest('td'), conf.gridName, false);
                            //posGrid.addRow();
                            //var index1 = posGrid.dataSource.data().length;
                            //var dataLast = posGrid.dataSource.data()[index1 - 2];
                            //var selectedItem = posGrid.dataItem(posGrid.select());
                            //selectedItem.set("ActualQuantity", 0)
                            //
                            //autoComplete.close();
                            //isOpen = false;
                            //conf.grid.refresh();;
                            return false;
                        }
                    }
                }
            }
            else {
                searchButton.trigger('click');
            }
            return false;
        }

        if (e.keyCode === 40) {
            $('.k-state-focused').removeClass('k-state-focused');
            index += 1;

            li = autoComplete.ul.children().eq(index);
            li.addClass('k-state-focused');

            distance = li.height() * index;
            //log(distance);
            if (distance > li.height() * 4) {
                //log('bigger' + (index - 4) * li.height());
                //log($('#CboInventoryName_listbox'));
                $('#CboInventoryName_listbox').animate({
                    scrollTop: (index - 4) * li.height()
                }, 5);
            }

            return false;
        }

        if (e.keyCode === 38) {
            $('.k-state-focused').removeClass('k-state-focused');
            index -= 1;

            li = autoComplete.ul.children().eq(index);
            distance = li.height() * index;
            //log(li.position());
            var pos = li.position();
            if (li && li.position && pos.top < 0) {
                $('#CboInventoryName_listbox').animate({
                    scrollTop: (index) * li.height()
                }, 5);
            }
            li.addClass('k-state-focused');
            return false;
        }
    }

    // Override hàm search
    function search(word) {
        var that = this,
        options = that.options,
        ignoreCase = options.ignoreCase,
        separator = options.separator,
        length;

        word = word || that.value();

        that._current = null;

        clearTimeout(that._typing);

        if (separator) {
            word = wordAtCaret(caretPosition(that.element[0]), word, separator);
        }

        length = word.length;

        if (!length && !length == 0) {
            that.popup.close();
        } else if (length >= that.options.minLength) {
            that._open = true;

            that.dataSource.filter({
                value: ignoreCase ? word.toLowerCase() : word,
                operator: options.filter,
                field: options.dataTextField,
                ignoreCase: ignoreCase
            });
        }
    }

    that.config = function (obj) {
        conf = obj;
        posGrid = conf.grid || $('#' + conf.gridName).data('kendoGrid');

        posGrid.bind('edit', function (e) {
            that.start(e);
            selectedRowItem = e;
        });
    }

    var backupDataSource = new kendo.data.DataSource({ data: [] });
    var count = 0;

    that.start = function (rowItem) {
        if ($('body #CboInventoryName-list').length > 1) {
            $('body #CboInventoryName-list')[0].remove();
        }

        var dataItem,
            i = 0,
            backupDataSource = new kendo.data.DataSource({ data: [] });

        autoComplete = $('#CboInventoryName').data('kendoAutoComplete');
        selectedRowItem = rowItem;
        if (autoComplete) {
            for (; dataItem = autoComplete.dataSource.data()[i++];) {
                backupDataSource.add(dataItem);
            }
            autoComplete.refresh();
            wrapper = $('#' + conf.inputID);
            kWidget = $(wrapper.find('#kendo-native-widget')[0]);
            searchButton = $(wrapper.find('#control-button')[0]);

            dataSource = autoComplete.dataSource;
            pseudoInput = $('#pseudo-input input');
            pseudoInput.val(rowItem.model.InventoryID);
            pseudoInput.focus();

            searchButton.on('click', btnSearch_Click);
            autoComplete.bind('select', autoComplete_Select);

            pseudoInput.on('keydown', input_keyUp);
        }
    }

    return that;
}();


function genActualQuantity(data) {
    if (data && data.ActualQuantity != null)
    {
        return data.ActualQuantity;
    }
    return 0;
}

function GridImportbtnMinus_Click() {
    var Item = getGridImport.dataItem(getGridImport.select());
    if (Item != null) {
        var quality = Item.ActualQuantity;
        if (quality > 1) {
            Item.set('ActualQuantity', quality - 1);
        }
        //getGridImport.refresh();
    }
};

function GridImportbtnPlus_Click() {
    var Item = getGridImport.dataItem(getGridImport.select());
    if (Item != null) {
        var quality = Item.ActualQuantity;
        Item.set('ActualQuantity', quality + 1);
        //getGridImport.refresh();  
    }
};

function GridImportbtnDel_Click() {
    var grid = $("#GridImport").data("kendoGrid");
    var count = grid.dataSource.total() - 1;
    var index = grid.select().index();

    var Item = grid.dataItem(grid.select());

    if (grid.dataSource.total() == 1 || count == index) {
        Item.set("InventoryID", "");
        Item.set("InventoryName", "");
        Item.set("UnitID", "");
        Item.set("ActualQuantity", 0);
        return;
    }
    grid.dataSource.remove(Item);
    grid.refresh();
};

function GridExportbtnMinus_Click() {
    var Item = getGridExport.dataItem(getGridExport.select());
    if (Item != null) {
        var quality = Item.MarkQuantity;
        if (quality > 1) {
            Item.set('MarkQuantity', quality - 1);
        }
        getGridExport.refresh();
        getGridImport.refresh();
    }
};

function GridExportbtnPlus_Click() {
    var Item = getGridExport.dataItem(getGridExport.select());
    if (Item != null) {
        var quality = Item.MarkQuantity;
        Item.set('MarkQuantity', quality + 1);
        getGridExport.refresh();
        getGridImport.refresh();
    }
};

function GridExportbtnDel_Click() {
    if (getGridExport.dataSource.total() == 1) {
        ASOFT.asoftPopup.closeOnly();
    }
    var selectedItem = getGridExport.dataItem(getGridExport.select());
    getGridExport.dataSource.remove(selectedItem);
    getGridExport.refresh();
};


function genMarkQuantity(data) {
    if (data && data.MarkQuantity != null) {
        return data.MarkQuantity;
    }
    return 0;
}