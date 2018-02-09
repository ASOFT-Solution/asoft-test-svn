//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/05/2014      Chánh Thi       Tạo mới
//#     03/06/2014      Minh Lâm        Cập nhật - Phân quyền
//####################################################################

var posGrid = null;
var posViewModel = null;
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var rowNumber = 0;
var gridChange = false;
var firstLoad = true;

$(document).ready(function () {
    posGrid = $("#POSF0022Grid").data("kendoGrid");

    posGrid.dataSource.bind("change", function () {
        if (firstLoad) {
            gridChanged = false;
            firstLoad = false;
        } else {
            gridChanged = true;
        }
    });

    //posGrid.dataSource.bind("requestEnd", function () {
    //        vars.gridChanged = false;
    //        vars.firstLoad = false;
    //});

    createViewModel();

    //Lưu sau khi nhập cột 
    posGrid.bind("dataBound", function (e) {
        rowNumber = 0;
    });
});

$(document).ready(function () {
    GRID_AUTOCOMPLETE.config({
        gridName: 'POSF0022Grid',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        actionName: 'POSF0021',
        controllerName: "GetInventories",
        grid: $('#POSF0022Grid').data('kendoGrid'),
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            selectedRowItem.model.set("InventoryTypeID", dataItem.InventoryTypeID);
            selectedRowItem.model.set("UnitName", dataItem.UnitName);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("UnitName", dataItem.UnitName);
            selectedRowItem.model.set("WareHouseID", dataItem.WareHouseID);
            selectedRowItem.model.set("WareHouseName", dataItem.WareHouseName);
            selectedRowItem.model.set("UnitName", dataItem.UnitName);
            selectedRowItem.model.set("ShipQuantity", dataItem.ShipQuantity);
            selectedRowItem.model.set("UnitPrice", dataItem.UnitPrice);

        }
    });

});

/**
* Send data to with grid
*/
function SendDataMaster() {
    if ($('#APK').val() != '') {
        return { APK: $('#APK').val() };
    }
    return null;
}

/*
* rendernumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

/**
* create viewmodel
*/
function createViewModel() {
    posViewModel = kendo.observable({
        defaultViewModel: ASOFT.helper.dataFormToJSON("POSF0022"),
        gridDataSource: posGrid.dataSource,
        RecipientName: $("#RecipientName").val(),
        Description: $("#Description").val(),
        isDataChanged: function () {
            var dataPost = ASOFT.helper.dataFormToJSON("POSF0022");
            var check = (dataPost.VoucherDate == this.defaultViewModel.VoucherDate)
                && (dataPost.VoucherNo == this.defaultViewModel.VoucherNo)
                && (dataPost.EmployeeID == this.defaultViewModel.EmployeeID)
                && (dataPost.EmployeeName == this.defaultViewModel.EmployeeName)
                && (dataPost.RecipientName == this.defaultViewModel.RecipientName)
                && (dataPost.Description == this.defaultViewModel.Description)
                && (dataPost.IsRefund == this.defaultViewModel.IsRefund)
                && (dataPost.RecepientShopID == this.defaultViewModel.RecepientShopID);

            return !check || gridChanged;
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON("POSF0022");
            dataPost.DetailList = this.gridDataSource.data();
            dataPost['RecepientShopName'] = dataPost['RecepientShopID_input'];
            dataPost.IsDataChanged = this.gridDataSource.hasChanges();
            dataPost.EmployeeID = $('#EmployeeID').data('kendoComboBox').value();
            return dataPost;
        },
        checkQuantity: function () {
            //Check inventoryIds
            var data = posGrid.dataSource.data();
            if (data.length >= 0) {
                var arrInventoryIds = [];
                $.each(data, function (index, item) {
                    if (item.ShipQuantity > item.InventoryQuantity) {
                        arrInventoryIds.push(item.InventoryID);
                    }
                });
                if (arrInventoryIds.length > 0) {
                    //border red
                    ASOFT.asoftGrid.borderGridValidate(
                    posGrid,
                    null,
                    function (row, fieldName, element, rowIndex, cellIndex, value) {
                        if (fieldName == "ShipQuantity") {
                            var isCheck = $.inArray(row.InventoryID, arrInventoryIds);
                            if (isCheck >= 0) {
                                element.addClass('asf-focus-input-error');
                            }
                        }
                    });
                    return true;
                }
            }
            return false;
        },
        isInvalid: function () {
            //checkgrid
            $('#POSF0022Grid').removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);

            var check = ASOFT.form.checkRequiredAndInList('POSF0022', ['EmployeeID']);
            if (!check) {
                if (this.gridDataSource.data().length <= 0) {
                    $('#POSF0022Grid').addClass('asf-focus-input-error');
                    //display message
                    var msg = ASOFT.helper.getMessage("00ML000061");
                    ASOFT.form.displayError("#POSF0022", msg);
                } else {
                    var cols = [
                       '',
                       'Description'];
                    if (ASOFT.asoftGrid.editGridValidate(posGrid, cols)) {
                        var msg = ASOFT.helper.getMessage("00ML000060");
                        ASOFT.form.displayError("#POSF0022", msg);
                        check = true;
                    }
                }
            }

            return (check || this.gridDataSource.data().length <= 0);
        },
        reset: function () {
            $("#APK").val('');
            $("#VoucherNo").val(this.defaultViewModel.VoucherNo);
            this.set("VoucherDate", this.defaultViewModel.VoucherDate);
            //this.set("EmployeeID", '');
            //this.set("EmployeeName", '');
            this.set("DelivererName", '');
            this.set("Description", '');
            //var row = this.gridDataSource.get(0);
            //var rebindData = [ASOFT.asoftGrid.resetRow(row)];
            this.gridDataSource.data([]);
            posGrid.addRow();
        },
        close: function () {
            //Close form
            if (parent.popupClose
                && typeof (parent.popupClose) === "function") {
                parent.popupClose();
            }
        },
        deleteItems: function (tagA) {
            //remove gridEdit
            ASOFT.asoftGrid.removeEditRow(tagA, posGrid);
            return false;
        },
        /**
        * save 
        * action = 1 : saveAndContinue
        * action = 2 : saveAndCopy
        * action = 3 : update
        */
        save: function (e, actionFlg) {
            if (this.isInvalid()) {
                return false;
            }
            var that = this;
            var dataPost = this.getInfo();
            var isUpdate = ($("#APK").val() != null
                && $("#APK").val() != ''
                && $("#APK").val() != EMPTY_GUID);
            var action = "/POS/POSF0021/Insert";
            if (isUpdate) {
                action = "/POS/POSF0021/Update";
                dataPost.APK = $("#APK").val();
            }

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Sent Json
                    ASOFT.helper.showErrorSeverOption(0, data, "POSF0022", function () {
                        //refresh grid master
                        if (parent.refreshGrid
                            && typeof (parent.refreshGrid) === "function") {
                            parent.refreshGrid();
                        }
                        gridChanged = false;
                        switch (actionFlg) {
                            case 0:
                                //close form
                                that.close();
                                break;
                            case 1:
                                ASOFT.form.displayInfo('#POSF0022', ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel.VoucherNo = data.Data;
                                that.reset();
                                break;
                            case 2:
                                ASOFT.form.displayInfo('#POSF0022', ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel.VoucherNo = data.Data;
                                $("#VoucherNo").val(that.defaultViewModel.VoucherNo);
                                break;
                            case 3:
                                ASOFT.form.displayInfo('#POSF0022', ASOFT.helper.getMessage(data.Message));
                                that.defaultViewModel = ASOFT.helper.dataFormToJSON("POSF0022");
                                if (data.Data != null) {
                                    $('#LastModifyDateValue').val(data.Data.LastModifyDateValue);
                                }
                                that.gridDataSource.saveChanges();
                                break;
                        }
                    }, function () {
                        if (data.Message == "POSM000016") {
                            var inventoryIds = [];
                            inventoryIds = data.Data;
                            ASOFT.asoftGrid.editGridValidate(
                     posGrid,
                     ['Description'],
                     function (row, fieldName, element, rowIndex, cellIndex, value) {
                         if (fieldName == "ShipQuantity") {
                             var isCheck = $.inArray(row.InventoryID, inventoryIds);
                             if (isCheck >= 0) {
                                 element.addClass('asf-focus-input-error');
                             }
                         }
                     });
                        }
                    }, true);
                }
            );
        }//end save (function)
    });
    kendo.bind($("#POSF0022"), posViewModel);

    var item = $('#EmployeeID').data('kendoComboBox').dataItem()
    if (item && item.Name) {
        $('#EmployeeName').val(item.Name);
    }
}

/**
* delete voucher
*/
function deleteVoucher_Click(e) {
    return posViewModel.deleteItems(e);
}

/**
* Close popup
*/
function btnClose_Click(event) {
    if (posViewModel.isDataChanged()) {
        ASOFT.dialog.confirmDialog(
            ASOFT.helper.getMessage('00ML000016'),
            //yes
            function () {
                posViewModel.save(null, 0);
            },
            //no
            function () {
                posViewModel.close();
            });
    } else {
        //Close popup
        posViewModel.close();
    }
}

/**
* Close popup without confirm
*/
function btnCloseOnly_Click(event) {
    posViewModel.close();
}


/**
* Change combox
*/
function cboEmployeeID_Cascade(e) {
    var dataItem = this.dataItem(this.selectedIndex);
    if (!posViewModel) {
        return;
    }
    if (dataItem == null) {
        return null;
    };

    // get tranmonth, tranyear value
    posViewModel.set("EmployeeName", dataItem.Name);
}

/**
* Save
*/
function btnSaveNew_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(null, 1);
        },
        null
    );
}

/**
* Save and copy
*/
function btnSaveCopy_Click(e) {
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            if (posViewModel.isDataChanged()) {
                posViewModel.save(null, 2);
            }
        }, null);
}


/**
* Save and copy
*/
function btnUpdate_Click(e) {
    if (posViewModel.isDataChanged()) {
        ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000016'),
        //yes
        function () {
            posViewModel.save(null, 3);
        });
    }
}



/**
* Gen delete button
*/
function genDeleteBtn(data) {
    return "<a href='\\#' onclick='return deleteVoucher_Click(this)' class='asf-i-delete-24 asf-icon-24'><span>Del</span></a>";
}

/**
* Format ShipQuantity
*/
function genShipQuantity(data) {
    if (data && data.ShipQuantity != null) {
        return data.ShipQuantity;
    }
    return "";
}


/**
* Grid Save
*/
function Grid_Edit(e) {
    var combo = $(e.container.find("#CboInventoryName")[0]).data('kendoComboBox'),
        log = console.log,
        numb = '0123456789',
        lwr = 'abcdefghijklmnopqrstuvwxyz',
        upr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    function isValid(parm, val) {
        if (parm == "") return true;
        for (i = 0; i < parm.length; i++) {
            if (val.indexOf(parm.charAt(i), 0) == -1) return false;
        }
        return true;
    }

    function isNumber(parm) { return isValid(parm, numb); }
    function isLower(parm) { return isValid(parm, lwr); }
    function isUpper(parm) { return isValid(parm, upr); }
    function isAlpha(parm) { return isValid(parm, lwr + upr); }
    function isAlphanum(parm) { return isValid(parm, lwr + upr + numb); }

    if (combo) {
        var input = $('input[name="CboInventoryName_input"]');
        staticDataSource = combo.dataSource;
        combo.setDataSource(activeDataSource);

        input.on('keyup', function (e) {

            var i = 0, item, value = input.val(), char = String.fromCharCode(e.keyCode), limit = 11,count = 0;
            if (!isAlphanum(char)) {
                return;
            }           

            activeDataSource = new kendo.data.DataSource({ data: [] });
            activeDataSource.add(staticDataSource.at(0));
            for (; item = staticDataSource.at(i++) ;) {
                if (item.InventoryID.toLowerCase().indexOf(value.toLowerCase()) > 0) {
                    activeDataSource.add(item);
                    count += 1;
                    if (count > limit) {
                        break;
                    }
                }
            }
            
            combo.setDataSource(activeDataSource);
            //log(activeDataSource);
            combo.open();
        });
    }
    //
    //
    
}
//var staticDataSource, activeDataSource;
function Grid_Edit(e) {
    GRID_AUTOCOMPLETE.start(e);
    //AUTOCOMPLETE.start();
}

function Grid_Save(e) {
    //var log = console.log;
    ////console.log(e);
    //if (e.values == null) {
    //    return true;
    //}
    //
    //var cboInventoryIDModel = e.model;
    ////Business
    //if (e.values) {
    //    var combo = $(e.container.find("#CboInventoryName")[0]).data('kendoComboBox')
    //    var currentlySelectedValue = combo.value();
    //    var data = combo.dataSource.data();
    //    cboInventoryIDModel = combo.dataItem();
    //    log(cboInventoryIDModel);
    //    if (cboInventoryIDModel) {
    //        var i = 0, item, inList = false;
    //        for (; item = data[i++];) {
    //            //console.log(item);
    //            if (currentlySelectedValue === item.InventoryID) {
    //                inList = true;
    //            }
    //        }
    //        //log(inList);
    //        if (inList) {
    //            e.model.set("InventoryID", currentlySelectedValue);
    //            e.model.set("InventoryName", cboInventoryIDModel.InventoryName);
    //            e.model.set("InventoryTypeID", cboInventoryIDModel.InventoryTypeID);
    //            e.model.set("UnitName", cboInventoryIDModel.UnitName);
    //            e.model.set("UnitID", cboInventoryIDModel.UnitID);
    //            e.model.set("UnitName", cboInventoryIDModel.UnitName);
    //            e.model.set("WareHouseID", cboInventoryIDModel.WareHouseID);
    //            e.model.set("WareHouseName", cboInventoryIDModel.WareHouseName);
    //            e.model.set("UnitName", cboInventoryIDModel.UnitName);
    //            e.model.set("ShipQuantity", cboInventoryIDModel.ShipQuantity);
    //        } else {
    //            e.model.set("InventoryID", '');
    //        }
    //    } else {
    //        e.model.set("InventoryID", '');
    //        combo.value('');
    //        currentlySelectedValue = '';
    //    }
    //}
}

var ComboboxValue = '';

function cb_Change(e) {
    //console.log(this);
    //var value = this.value();
    //var data = this.dataSource.data();
    //
    //
    //
    //this.value('');
    //ComboboxValue = '';
}


function inherit_Click() {
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/POS/POSF00221", {});
}

function receiveResultCustom(dtMas, dtDet) {
    if (dtDet.length > 0) {
        if (posGrid.dataSource._data.length == 1) {
            if (posGrid.dataSource._data[0].InventoryID == "" || posGrid.dataSource._data[0].InventoryID == null) {
                posGrid.dataSource.data([]);
            }
        }

        for (var k = 0; k < dtDet.length; k++) {
            var itemKT = dtDet[k];
            var itemDT = {};
            itemDT.InheritVoucherID = itemKT.VoucherID;
            itemDT.InheritTransactionID = itemKT.TransactionID;
            itemDT.InventoryID = itemKT.InventoryID;
            itemDT.InventoryName = itemKT.InventoryName;
            itemDT.UnitID = itemKT.UnitID;
            itemDT.UnitName = itemKT.UnitName;
            itemDT.UnitPrice = itemKT.UnitPrice;
            itemDT.ShipQuantity = itemKT.ActualQuantity;
            itemDT.InventoryTypeID = itemKT.InventoryTypeID;
            posGrid.dataSource.add(itemDT);
        }
        posGrid.dataSource.hasChanges(true);
    }
}

function posIsDisplay_Change(e) {
    var cbbIsDisplay = e.sender;
    var tr = e.sender.wrapper.closest('tr');
    var rows = posGrid.dataItem(tr);
    rows.set("StatusInventory", e.sender.value());
    rows.set("StatusInventoryName", e.sender.text());
}