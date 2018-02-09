$(document).ready(function () {
    SOF0000.SOF0000Grid = ASOFT.asoftGrid.castName('SOF0000Grid');
    SOF0000.SOF0000Grid.bind('dataBound', function () {
        SOF0000.rowNum = 0;
    });
    SOF0000.isSaved = false;
    SOF0000.DataSourceInventory = [];
    SOF0000.DataSourceUserForVoucherTypeID = [];

    GRID_AUTOCOMPLETE1.config({
        gridName: 'SOF0000Grid',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("VoucherTypeID", dataItem.VoucherTypeID);
            selectedRowItem.model.set("VoucherTypeName", dataItem.VoucherTypeName);
        }
    });
});

SOF0000 = new function () {
    this.rowNum = 0;
    this.VoucherTypeDB = [];
    this.DataSourceInventory = [];
    this.DataSourceUserForVoucherTypeID = [];
    this.isSaved = false;
    this.btnInventoryTypeID_Click = function () {
        var url = $('#UrlSOF0006').val();
        var data = [];
        if (SOF0000.DataSourceInventory) {
            data = { InventoryTypeList: SOF0000.DataSourceInventory };
        }
        SOF0000.showPopup(url, data);

        ASOFT.helper.registerFunction('window.parent.SOF0000.setDataInventory');
    }

    this.setDataInventory = function () {
        var dataItem = ASOFT.helper.getObjectData();
        SOF0000.DataSourceInventory = dataItem;
    }

    this.btnClose_Click = function () {
        SOF0000.closePopup();
    }
    this.btnSave_Click = function () {
        var dataCheckVoucherTypeID = [];
        if (SOF0000.SOF0000Grid && SOF0000.SOF0000Grid.dataSource._data.length > 0) {
            $.each(SOF0000.SOF0000Grid.dataSource._data, function (key, value) {
                if (value.VoucherTypeID != null && value.VoucherTypeID != '') {
                    dataCheckVoucherTypeID.push(value.VoucherTypeID);
                }
            });
        }

        var data = ASOFT.helper.dataFormToJSON("SOF0000");
        data.InventoryTypeList = SOF0000.DataSourceInventory.join("','");
        data.VoucherTypeList = SOF0000.DataSourceUserForVoucherTypeID;
        data.VoucherTypeDB = SOF0000.VoucherTypeDB.join("','");
        data.CheckVoucherTypeID = dataCheckVoucherTypeID;
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, SOF0000.SaveSuccess);
    }

    this.SaveSuccess = function (result) {
        ASOFT.form.updateSaveStatus('SOF0000', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'SOF0000', function () {
            SOF0000.isSaved = true;
            SOF0000.btnClose_Click();
        }, null, null, true);
    }

    this.Settings_Click = function (tag) {
        ASOFT.form.clearMessageBox();
        var dataVoucherTypeID = $(tag).parent().parent().children()[1].textContent;
        if (dataVoucherTypeID) {
            var dataUserID = [];
            if (SOF0000.DataSourceUserForVoucherTypeID) {
                $.each(SOF0000.DataSourceUserForVoucherTypeID, function (key, value) {
                    if (dataVoucherTypeID == value.VoucherTypeID) {
                        dataUserID.push(value.UserID);
                    }
                });
            }
            var url = $('#UrlSOF0005').val();

            var data = {
                VoucherTypeID: dataVoucherTypeID,
                UserList: dataUserID
            };
            SOF0000.showPopup(url, data);

            ASOFT.helper.registerFunction('window.parent.SOF0000.setDataUserForVoucherType');
        } else {
            ASOFT.form.displayMessageBox('#SOF0000', [ASOFT.helper.getMessage('SOFML000008')], null);
            return;
        }
    }
    
    this.setDataUserForVoucherType = function () {
        var dataItem = ASOFT.helper.getObjectData();
        var begin = SOF0000.DataSourceUserForVoucherTypeID.length;
        SOF0000.DataSourceUserForVoucherTypeID = $.grep(SOF0000.DataSourceUserForVoucherTypeID, function (e) {
            return e.VoucherTypeID != dataItem[dataItem.length-1];
        });
        var fin = SOF0000.DataSourceUserForVoucherTypeID.length;
        dataItem.pop();
        $.each(dataItem, function (key, value) {
            SOF0000.DataSourceUserForVoucherTypeID.push(value);
        });
        
    }


    this.rowNumber = function () {
        return ++SOF0000.rowNum;
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('SOF0000') && !SOF0000.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                SOF0000.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
        SOF0000.rowNum = 0;
    };

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        if (SOF0000.SOF0000Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = SOF0000.SOF0000Grid.dataSource.data();
            var row = SOF0000.SOF0000Grid.dataSource.data()[0];
            row.set('VoucherTypeID', null);
            row.set('VoucherTypeName', null);
            return;
        }

        var voucherType = $(tag).parent().parent().children()[1].textContent;
        var data = {
            voucherTypeID: voucherType
        };
        
        ASOFT.helper.postTypeJson("/SO/SOF0000/CheckVoucherTypeID", data, function (result) {
            if (result.check) {
                SOF0000.VoucherTypeDB.push(result.VoucherTypeID);
            } else {
                SOF0000.DataSourceUserForVoucherTypeID = $.grep(SOF0000.DataSourceUserForVoucherTypeID, function (e) {
                    return e.VoucherTypeID != voucherType;
                });
            }
        });
       

        ASOFT.asoftGrid.removeEditRow(row, SOF0000.SOF0000Grid, null);
    }
}

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
            dataItem,
            maxlengthgrid = SOF0000.SOF0000Grid.dataSource._data.length,
            indexofgrid = e.sender.wrapper.parent().parent().parent().parent().parent().children()[0].textContent;
        for (; dataItem = dataSource.at(i++) ;) {
            if (dataItem.VoucherTypeID === text) {
                ////log(dataItem);
                pseudoInput.val(text)
                if (selectedRowItem) {
                    conf.setDataItem(selectedRowItem, dataItem);
                    index = 0;
                    autoComplete.setDataSource(backupDataSource);
                    if ((maxlengthgrid) == indexofgrid) {
                        SOF0000.SOF0000Grid.addRow();
                    }
                }
                break;
            }
        }

    }
    var index = 0;
    var isOpen = false;
    var tempreturn = 0;

    function input_keyUp(e) {
        var li, distance, dataItem, i = 0,
            maxlengthgrid = SOF0000.SOF0000Grid.dataSource._data.length,
            indexofgrid = e.currentTarget.parentElement.parentElement.parentElement.parentElement.parentElement.children[0].textContent;

        ////log(e.keyCode);
        if (e.keyCode === 13) {
            var li = $('#CboVoucherTypeName-list .k-state-focused').find('div div')[0];
            var text = $(li).text();
            //log(text);
            if (text) {
                //log(2);
                //log(autoComplete.dataSource);
                for (; dataItem = autoComplete.dataSource.data()[i++];) {
                    //log(dataItem.VoucherTypeID);
                    if (dataItem.VoucherTypeID === text) {
                        pseudoInput.val(text)
                        if (selectedRowItem) {
                            index = 0;
                            conf.setDataItem(selectedRowItem, dataItem);
                            autoComplete.setDataSource(backupDataSource);
                            //$('#CboVoucherTypeName-list').remove();
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
                //log($('#CboVoucherTypeName_listbox'));
                $('#CboVoucherTypeName_listbox').animate({
                    scrollTop: (index - 4) * li.height()
                }, 5);
            }
            if ((maxlengthgrid) == indexofgrid) {
                SOF0000.SOF0000Grid.addRow();
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
                $('#CboVoucherTypeName_listbox').animate({
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
        if ($('body #CboVoucherTypeName-list').length > 1) {
            $('body #CboVoucherTypeName-list')[0].remove();
        }

        var dataItem,
            i = 0,
            backupDataSource = new kendo.data.DataSource({ data: [] });

        autoComplete = $('#CboVoucherTypeName').data('kendoAutoComplete');
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
            pseudoInput.val(rowItem.model.VoucherTypeID);
            pseudoInput.focus();

            searchButton.on('click', btnSearch_Click);
            autoComplete.bind('select', autoComplete_Select);

            pseudoInput.on('keydown', input_keyUp);

        }
    }

    return that;
}();