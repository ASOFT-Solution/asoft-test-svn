/// <reference path="http://localhost:3227/Scripts/jquery.inputmask.date.extensions.js" />
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/04/2014      Thai Son        Tạo mới
//####################################################################


var autoCompleteData;

function makeAutoComplete(e, config) {
    //var log = console.log,
        selectedRowItem = e;

    //log('makeAutoComplete');
    if (!$('#CboInventoryName').data('kendoAutoComplete')) {
        //log('not edit autocomplete');
        return false;
    }
    var config = config || {
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        actionName: 'POSF0015',
        controllerName: "GetInventories",
        grid: $('#POSF00151Grid').data('kendoGrid')
    }
    ;

    var wrapper = $('#' + config.inputID);
    var kInput = $(wrapper.find('#kendo-native-widget')[0]);
    var button = $(wrapper.find('#control-button')[0]);
    var autoComplete = $('#CboInventoryName').data('kendoAutoComplete');
    var dataSource = autoComplete.dataSource;
    var input = $('#pseudo-input input');
    //log('InventoryID ' + e.model.InventoryID);
    input.val(e.model.InventoryID);

    function createURL() {
        return '/POS/{0}/{1}'.format(config.actionName, config.controllerName);
    }
    function getData() {
        if (autoCompleteData) {
            return autoCompleteData;
        }
        var url = createURL(), resultData;

        //log(url);
        ASOFT.helper.postTypeJson(
                url,
                {},
                function (result) {
                    ////log(result.Data)
                    autoCompleteData = result.Data;
                }
            );
        return autoCompleteData;
    }



    button.on('click', btnSearch_Click);
    autoComplete.bind('select', autoComplete_Select)

    function btnSearch_Click(e) {
        e.preventDefault();
        //log(input.val());
        autoComplete.search(input.val());
        input.focus();
    }

    function autoComplete_Select(e) {
        var i = 0,
            text = $($(e.item).find('div div')[0]).text(),
            dataItem;
        for (; dataItem = dataSource.at(i++) ;) {
            if (dataItem.InventoryID === text) {
                //log(dataItem);
                input.val(text)
                if (selectedRowItem) {
                    conf.setDataItem(selectedRowItem, dataItem);
                    //config.grid.refresh();
                }
                break;
            }
        }

    }
}

var GRID_AUTOCOMPLETE = function (e) {
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
                    $('#CboInventoryName-list').remove();
                    autoComplete.setDataSource(backupDataSource);
                    //conf.grid.refresh();
                    ASOFT.asoftGrid.nextCell($(autoComplete.element).closest('td'), conf.gridName, false);
                }
                break;
            }
        }

    }
    var index = 0;
    var isOpen = false;

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

                            //
                            //autoComplete.close();
                            //isOpen = false;
                            //conf.grid.refresh();
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
        //var gridContentClassName = '#CboInventoryName_listbox';

        //if ($(gridContentClassName).height() == $(gridContentClassName)[0].scrollHeight) {
        //    return false;
        //}

        //if (!rowIndex) {
        //    $(gridContentClassName).animate({
        //        scrollTop: $(gridContentClassName).offset().top
        //    }, 500);
        //} else { 
        //    if (li.position().top < 0
        //        || li.position().top > ($(gridContentClassName).height() - li.height())) {
        //        var scrollDistance = 0;
        //        for (var i = 1; i < rowIndex; i++) {
        //            scrollDistance += rowElement.height()
        //        }
        //        $(gridContentClassName).animate({
        //            scrollTop: scrollDistance
        //        }, 500);
        //    }
        //}
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
        //posGrid.bind('save', function () {
        //
        //});
    }

    var backupDataSource = new kendo.data.DataSource({ data: [] });
    var count = 0;

    that.start = function (rowItem) {
        //log($('body #CboInventoryName-list').length);
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
       // log(count);
       // if (count == 0) {
       //     count = 1;
       // } else {
       //     $('#CboInventoryName-list').remove();
       // }

    }

    return that;
}();



