var isCheckDataChange = true;
var rowList = null;
var columnIndexEmployeeID;
var columnIndexFirstLoaDays;
var columns = [];
// Document ready
$(document).ready(function () {
    HF0403.HF0403Grid = ASOFT.asoftGrid.castName('HF0403Grid');
    HF0403.HF0403Grid.bind('dataBound', function () {
        HF0403.rowNum = 0;
    });

    if ($('#FormStatus').val() == 2) {
        HF0403.HF0403Grid.hideColumn("APK");
        HF0403.HF0403Grid.unbind("dataBound");
        $(HF0403.HF0403Grid.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {
            ASOFT.asoftGrid.currentRow = $(this).parent().index();
            ASOFT.asoftGrid.currentCell = $(this).index();
            var columns = $('#HF0403Grid').data('kendoGrid').columns;
            var editor = columns[ASOFT.asoftGrid.currentCell].editor;
            var isDefaultLR = $(HF0403.HF0403Grid.element).attr('isDefaultLR');
            if (editor != undefined) {
                var elm = $(this);
                if (e.shiftKey) {
                    switch (e.keyCode) {
                        case 13:
                            ASOFT.asoftGrid.previousCell(this, name, false);
                            e.preventDefault();
                            break;
                        case 9:
                            ASOFT.asoftGrid.previousCell(this, name, false);
                            e.preventDefault();
                            break;
                        default:
                            break;
                    }
                } else {
                    switch (e.keyCode) {
                        case 13:
                            ASOFT.asoftGrid.nextCell(this, name, false);
                            e.preventDefault();
                            break;
                        case 9:
                            ASOFT.asoftGrid.nextCell(this, name, false);
                            e.preventDefault();
                            break;
                        case 37: //left
                            if (!isDefaultLR) {
                                ASOFT.asoftGrid.leftCell(this, name);
                                e.preventDefault();
                            }
                            break;
                        case 39://right
                            if (!isDefaultLR) {
                                ASOFT.asoftGrid.rightCell(this, name);
                                e.preventDefault();
                            }
                            break;
                            //TODO : up & down
                            /*case 38:
                                ASOFT.asoftGrid.upCell(this, name);
                                e.preventDefault();
                            return false;
                            case 40:
                                ASOFT.asoftGrid.downCell(this, name);
                                e.preventDefault();
                            return false;*/
                        default:
                            break;
                    }
                }
            }// end if

        });
    }

    GRID_AUTOCOMPLETE.config({
        gridName: 'HF0403Grid',
        inputID: 'autocomplete-box',
        NameColumn: "EmployeeID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("DepartmentID", dataItem.DepartmentID);
            selectedRowItem.model.set("TeamID", dataItem.TeamID);
            selectedRowItem.model.set("DepartmentName", dataItem.DepartmentName);
            selectedRowItem.model.set("TeamName", dataItem.TeamName);
            selectedRowItem.model.set("EmployeeID", dataItem.EmployeeID);
            selectedRowItem.model.set("FullName", dataItem.FullName);
        }
    });
});

function ChooseEmployeeID_Click() {
    var grid = $('#HF0403Grid').data('kendoGrid');
    var selectedItem = grid.dataItem(grid.select());

    var url1 = '/PopupSelectData/Index/HRM/OOF2004?DepartmentID=' + selectedItem.DepartmentID + '&TeamID=' + selectedItem.TeamID + '&ScreenID=HF0403';
    ASOFT.asoftPopup.showIframe(url1, {});
}

function receiveResult(result) {
    ASOFT.form.clearMessageBox();
    var grid = $('#HF0403Grid').data('kendoGrid');
    var selectedItem = grid.dataItem(grid.select());
    selectedItem.set('EmployeeID', result["EmployeeID"]);
    selectedItem.set('FullName', result["FullName"]);
    selectedItem.set('DepartmentID', result["DepartmentID"]);
    selectedItem.set('DepartmentName', result["DepartmentName"]);
    selectedItem.set('TeamID', result["TeamID"]);
    selectedItem.set('TeamName', result["TeamName"]);
    grid.refresh();
}

HF0403 = new function () {
    this.HF0403Grid = null;
    this.rowNum = 0;

    this.rowNumber = function () {
        return ++HF0403.rowNum;
    }

    this.HF0403Grid_EventPost = function () {
        var data = {};
        data.FormStatus = $('#FormStatus').val();
        data.LstEmployeeID = $('#LstEmployeeID').val();
        return data;
    }

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
        HF0403.rowNum = 0;
    };

    this.deleteAddress = function (tag) {
        row = $(tag).parent();
        if (HF0403.HF0403Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = HF0403.HF0403Grid.dataSource.data();
            var row = HF0403.HF0403Grid.dataSource.data()[0];
            row.set('DepartmentID', null);
            return;
        }
        ASOFT.asoftGrid.removeEditRow(row, HF0403.HF0403Grid, null);
    }

    this.btnSave_Click = function () {
        if (HF0403.HF0403Grid.dataSource.data().length <= 0) { //Lưới không có dòng nào ko có cho lưu
            ASOFT.form.displayMessageBox('#HF0403', [ASOFT.helper.getMessage('00ML000067')]);
            return;
        }

        //if (isInvalid()) {
        //    return;
        //}

        //Check required
        $('#HF0403').removeClass('asf-focus-input-error');

        rowList = HF0403.HF0403Grid.tbody.children();
        columnIndexEmployeeID = HF0403.HF0403Grid.wrapper.find(".k-grid-header [data-field=" + "EmployeeID" + "]").index();
        columnIndexFirstLoaDays = HF0403.HF0403Grid.wrapper.find(".k-grid-header [data-field=" + "FirstLoaDays" + "]").index();

        var isCheck = false;
        var lstEmp = [];
        var message = [];
        var num = 0;
        for (var i = 0; i < rowList.length; i++) {
            var row = $(rowList[i]);
            var pEmployeeID = row.children()[columnIndexEmployeeID].textContent;
            var pFirstLoaDays = parseInt(row.children()[columnIndexFirstLoaDays].textContent);
            //Kiểm tra cột FirstLoaDays > 0
            if (pFirstLoaDays <= 0) {
                $(row.children()[columnIndexFirstLoaDays]).addClass('asf-focus-input-error');
                isCheck = true;

                message.push(ASOFT.helper.getMessage("HFML000537"));
            }

            //kiểm tra trùng employee trên lưới
            if (lstEmp.length > 0) {
                if ($.inArray(pEmployeeID, lstEmp) != -1) {
                    $(row.children()[columnIndexEmployeeID]).addClass('asf-focus-input-error');
                    if (num
== 0) {
                        message.push(ASOFT.helper.getMessage("HFML000538").f(pEmployeeID));
                        num = num + 1;
                    }
                    isCheck = true;
                } else {
                    lstEmp.push(pEmployeeID);
                }
            }
            else {
                lstEmp.push(pEmployeeID);
            }
        }

        if (isCheck) {
            ASOFT.form.displayMessageBox('#HF0403', message);
            return;
        }

        if ($('#FormStatus').val() == 1) {
            var url = $('#UrlCheckDataChanged').val();
            var data = lstEmp;
            ASOFT.helper.postTypeJson(url, data, HF0403.HF0403CheckDataChangedSuccess);
            isCheck = isCheckDataChange;
        } else {
            isCheck = true;
        }

        if (isCheck) {
            var data = ASOFT.helper.dataFormToJSON('HF0403', 'List', HF0403.HF0403Grid);
            var url = $('#UrlInsertOrUpdate').val();
            ASOFT.helper.postTypeJson(url, data, HF0403.HF0403SaveSuccess);
        }
    }

    this.HF0403CheckDataChangedSuccess = function (result) {
        isCheckDataChange = result.isChecked;
        if (!result.isChecked) {
            var message = [];

            for (var i = 0; i < rowList.length; i++) {
                var row = rowList[i];
                var pEmployeeID = row.children[columnIndexEmployeeID].textContent;

                if ($.inArray(pEmployeeID, result.lst) != -1) {
                    $(row.children[columnIndexEmployeeID]).addClass('asf-focus-input-error');

                    message.push(ASOFT.helper.getMessage(result.message).f(pEmployeeID));
                }
            }

            ASOFT.form.displayMessageBox('#HF0403', message);
        }
    }

    this.HF0403SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'HF0403', function () {
            window.parent.refreshGrid();
            HF0403.btnClose_Click();
        }, null, null, true);
    }

    this.Auto_Change = function () {
        var autoComplete = $("#EmployeeID").data("kendoAutoComplete");

        var url = $("#UrlLoadDataEmployeeID").val();
        var data = {
            departmentID: $('#DepartmentID').val().split(',').join("','"),
            teamID: $('#TeamID').val().split(',').join("','")
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            autoComplete.dataSource.data(result);
            autoComplete.search($("#EmployeeID").val());
        });
    }
}

function CboEmployeeID_Auto_Change() {
    alert("text is changed!");
}

function DepartmentID_Changed(e) {
    var selectitem = HF0403.HF0403Grid.dataItem(HF0403.HF0403Grid.select())
    selectitem.DepartmentID = e.sender._data()[e.sender.selectedIndex].DepartmentID;
    selectitem.DepartmentName = e.sender._data()[e.sender.selectedIndex].DepartmentName;
}

function cboTeamID_EventPostData(e) {
    var selectitem = HF0403.HF0403Grid.dataItem(HF0403.HF0403Grid.select())
    var data = {};
    data.departmentID = selectitem.DepartmentID;
    return data;
}

function TeamID_Changed(e) {
    var selectitem = HF0403.HF0403Grid.dataItem(HF0403.HF0403Grid.select())
    selectitem.TeamID = e.sender._data()[e.sender.selectedIndex].TeamID;
    selectitem.TeamName = e.sender._data()[e.sender.selectedIndex].TeamName;
}

function cboEmployeeID_EventPostData(e) {
    var selectitem = HF0403.HF0403Grid.dataItem(HF0403.HF0403Grid.select())
    var data = {};
    data.departmentID = selectitem.DepartmentID;
    data.teamID = selectitem.TeamID;
    return data;
}

function Employee_Changed(e) {
    var selectitem = HF0403.HF0403Grid.dataItem(HF0403.HF0403Grid.select())
    selectitem.EmployeeID = e.sender._data()[e.sender.selectedIndex].EmployeeID;
    selectitem.FullName = e.sender._data()[e.sender.selectedIndex].FullName;

    $(HF0403.HF0403Grid.select().children()[4]).text(selectitem.FullName);


}

function isInvalid() {
    var data = ASOFT.helper.dataFormToJSON($("#sysScreenID").val());
    var listtable = [];
    var isError = false;
    listtable.push(data["tableNameEdit"]);

    $.each(listtable, function (index, value) {
        var grid = $('#HF0403Grid').data('kendoGrid');
        $("#HF0403").removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(grid);
        var listRequired = ['APK', 'FirstLoaDays'];
        if (ASOFT.asoftGrid.editGridValidateNoEdit(grid, listRequired)) {
            var msg = ASOFT.helper.getMessage("00ML000060");
            ASOFT.form.displayError("#HF0403", msg);
            isError = true;
        }
    })
    return isError;
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
        text = pseudoInput.val();
        if (text == "")
            return;
        AutoCompelete(autoComplete, text);
        if (autoComplete.dataSource.data().length == 0)
            return;
        if (text) {
            autoComplete.search(pseudoInput.val());
        }
        pseudoInput.focus();
    }

    function AutoCompelete(combo,text) {
        var autoComplete = $("#CboEmployeeID").data("kendoAutoComplete");

        var grid = $('#HF0403Grid').data('kendoGrid');
        var selectedItem = grid.dataItem(grid.select());

        var url = $("#UrlLoadDataEmployeeID").val();
        var data = {
            departmentID: selectedItem.DepartmentID ? selectedItem.DepartmentID : '',
            teamID: selectedItem.TeamID ? selectedItem.TeamID : '',
            employeeID: text
        };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            autoComplete.dataSource.data(result);
            autoComplete.search($("#EmployeeID").val());
        });

    }

    function autoComplete_Select(e) {
        var i = 0,
            text = $($(e.item).find('div div')[0]).text(),
            dataItem;
        for (; dataItem = dataSource.at(i++) ;) {
            if (dataItem.EmployeeID === text) {
                ////log(dataItem);
                pseudoInput.val(text)
                if (selectedRowItem) {
                    conf.setDataItem(selectedRowItem, dataItem);
                    index = 0;
                    $('#CboEmployeeID-list').remove();
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
            var li = $('#CboEmployeeID-list .k-state-focused').find('div div')[0];
            var text = $(li).text();
            //log(text);
            if (text) {
                //log(2);
                //log(autoComplete.dataSource);
                for (; dataItem = autoComplete.dataSource.data()[i++];) {
                    //log(dataItem.InventoryID);
                    if (dataItem.EmployeeID === text) {
                        pseudoInput.val(text)
                        if (selectedRowItem) {
                            index = 0;
                            conf.setDataItem(selectedRowItem, dataItem);
                            autoComplete.setDataSource(backupDataSource);
                            //$('#CboEmployeeID-list').remove();
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
                //log($('#CboEmployeeID_listbox'));
                $('#CboEmployeeID_listbox').animate({
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
                $('#CboEmployeeID_listbox').animate({
                    scrollTop: (index) * li.height()
                }, 5);
            }
            li.addClass('k-state-focused');
            return false;
        }
        //var gridContentClassName = '#CboEmployeeID_listbox';

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
        //log($('body #CboEmployeeID-list').length);
        if ($('body #CboEmployeeID-list').length > 1) {
            $('body #CboEmployeeID-list')[0].remove();
        }

        var dataItem,
            i = 0,
            backupDataSource = new kendo.data.DataSource({ data: [] });

        autoComplete = $('#CboEmployeeID').data('kendoAutoComplete');
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
            pseudoInput.val(rowItem.model.EmployeeID);
            pseudoInput.focus();

            searchButton.on('click', btnSearch_Click);
            autoComplete.bind('select', autoComplete_Select);

            pseudoInput.on('keydown', input_keyUp);
        }
        // log(count);
        // if (count == 0) {
        //     count = 1;
        // } else {
        //     $('#CboEmployeeID-list').remove();
        // }

    }

    return that;
}();