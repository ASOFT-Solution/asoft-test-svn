//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################
var posGrid = null;
var posViewModel = null;
var EMPTY_GUID = '00000000-0000-0000-0000-000000000000';
var rowNumber = 0;
var SCREEN_ID = 'POSF00151';
var isCreate = null;

$(document).ready(function () {
    posGrid = $('#POSF00151Grid').data('kendoGrid');
    createViewModel();

    //Lưu sau khi nhập cột 
    posGrid.bind('dataBound', function (e) {
        rowNumber = 0;
        if (posGrid.dataSource._data.length == 1 && posGrid.dataSource._data[0]["InventoryID"] == null)
        {
            posGrid.dataSource.data([]);
        }
    });
    posGrid.bind('edit', Grid_Edit);

    $('#POSF00151Grid').on('click', '.chkbx', function () {
        var checked = $(this).is(':checked');
        var grid = $('#POSF00151Grid').data().kendoGrid;
        var dataItem = grid.dataItem($(this).closest('tr'));
        if (checked) {
            dataItem.set('Status', 1);
        } else {
            dataItem.set('Status', 0);
        }

    });

    var item = $('#EmployeeID').data('kendoComboBox').dataItem()
    if (item && item.Name) {
        $('#EmployeeName').val(item.Name);
    }
});

/******************************************************************************
                            ViewModel
*******************************************************************************/
/**
* create viewmodel
*/
function createViewModel() {
    posViewModel = kendo.observable({
        defaultViewModel: ASOFT.helper.dataFormToJSON('POSF00151'),
        gridDataSource: posGrid.dataSource,
        DelivererName: $('#DelivererName').val(),
        Description: $('#Description').val(),
        isDataChanged: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF00151');
            var check = (dataPost.VoucherDate == this.defaultViewModel.VoucherDate)
                && (dataPost.VoucherNo == this.defaultViewModel.VoucherNo)
                && (dataPost.EmployeeID == this.defaultViewModel.EmployeeID)
                && (dataPost.EmployeeName == this.defaultViewModel.EmployeeName)
                && (dataPost.DelivererName == this.defaultViewModel.DelivererName)
                && (dataPost.Description == this.defaultViewModel.Description);

            check = (check && !this.gridDataSource.hasChanges());

            return !check;
        },
        getInfo: function () {
            var dataPost = ASOFT.helper.dataFormToJSON('POSF00151');
            dataPost.DetailList = this.gridDataSource.data();
            dataPost.EmployeeID = $('#EmployeeID').data('kendoComboBox').value();
            dataPost.IsDataChanged = this.gridDataSource.hasChanges();
            return dataPost;
        },
        checkQuantity: function () {
            //Check inventoryIds
            var data = posGrid.dataSource.data();
            if (data.length >= 0) {
                var arrInventoryIds = [];
                $.each(data, function (index, item) {
                    if (item.ActualQuantity > item.MarkQuantity && item.APKDInherited != null) {
                        arrInventoryIds.push(item.InventoryID);
                    }
                });
                if (arrInventoryIds.length > 0) {
                    //border red
                    ASOFT.asoftGrid.borderGridValidate(
                    posGrid,
                    null,
                    function (row, fieldName, element, rowIndex, cellIndex, value) {
                        if (fieldName == "ActualQuantity") {
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
            $('#POSF00151Grid').removeClass('asf-focus-input-error');
            ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);
            var msg = '';
            var check = ASOFT.form.checkRequiredAndInList('POSF00151', ['EmployeeID']);
            if (!check) {
                if (this.gridDataSource.data().length <= 0) {
                    $('#POSF00151Grid').addClass('asf-focus-input-error');
                    //display message
                    msg = ASOFT.helper.getMessage('00ML000061');
                    ASOFT.form.displayError('#POSF00151', msg);
                } else {
                    //show quantity
                    if (ASOFT.asoftGrid.editGridValidate(posGrid)) {
                        msg = ASOFT.helper.getMessage('00ML000060');
                        ASOFT.form.displayError('#POSF00151', msg);
                        check = true;
                    }
                    //[MinhLam - 06/06/2014] : Không kiểm tra chêch lệch số lượng
                    /*else if (this.checkQuantity()) {
                        msg = ASOFT.helper.getMessage('00ML000072');
                        ASOFT.form.displayWarning('#POSF00151', msg);
                        check = true;
                    }*/
                }
            }

            return (check || this.gridDataSource.data().length <= 0);
        },
        inherit: function (items) {
            // clear dataSource hiện tại
            while (this.gridDataSource.data().length > 0) {
                var item = this.gridDataSource.at(0);                
                this.gridDataSource.remove(item);
            }

            var firstRow = {}; // this.gridDataSource.data()[0].defaults;
            //var data = [];
            for (var i = 0; i < items.length; i++) {
                var item = items[i];
                item.MarkQuantity = 0;
                item.Status = 0;
                item.ActualQuantity = 0;

                item.Ana01ID = 0;
                item.Ana02ID = 0;
                item.Ana03ID = 0;
                item.Ana04ID = 0;
                item.Ana05ID = 0;
                item.Ana06ID = 0;
                item.Ana07ID = 0;
                item.Ana08ID = 0;
                item.Ana09ID = 0;
                item.Ana10ID = 0;

                item.APKMInherited = item.APKMaster;
                item.APKDInherited = item.APK;
                item.InventoryID = item.InventoryID;
                item.InventoryName = item.InventoryName;
                item.UnitID = item.UnitID;
                item.UnitName = item.UnitName;
                item.UnitPrice = item.UnitPrice | 0;
                item.MarkQuantity = item.Remain;
                item.EVoucherNo = item.VoucherNo;

                this.gridDataSource.add(item);

            }

            $("#POSF00151Grid").attr("AddNewRowDisabled", "true");
            //rebin data
            //this.gridDataSource.data(data);
            posGrid.refresh();
        },

        reset: function () {
            $('#APK').val('');
            $('#VoucherNo').val(this.defaultViewModel.VoucherNo);
            this.set('VoucherDate', this.defaultViewModel.VoucherDate);
            //this.set('EmployeeID', '');
            //this.set('EmployeeName', '');
            this.set('DelivererName', '');
            this.set('Description', '');
            //var row = this.gridDataSource.get(0);
            //var rebindData = [ASOFT.asoftGrid.resetRow(row)];
            this.gridDataSource.data([]);
            posGrid.addRow();
        },
        close: function () {
            //Close form
            //if (parent.popup_Close
            //    && typeof (parent.popup_Close) === 'function') {
            //    parent.popup_Close();
            //}

            ASOFT.asoftPopup.closeOnly();
        },
        deleteItems: function (tagTd) {
            //remove gridEdit
            ASOFT.asoftGrid.removeEditRow(tagTd, $('#POSF00151Grid').data('kendoGrid'), null);
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
            var isUpdate = ($('#APK').val() != null
                && $('#APK').val() != ''
                && $('#APK').val() != EMPTY_GUID);
            var action = getAbsoluteUrl('POSF0015/Insert');
            if (isUpdate) {
                action = getAbsoluteUrl('POSF0015/Update');
                dataPost.APK = $('#APK').val();
            }

            ASOFT.helper.postTypeJson(
                action,
                dataPost,
                function (data) {
                    //Sent Json
                    ASOFT.helper.showErrorSeverOption(0, data, 'POSF00151', function () {
                        //refresh grid master
                        if (parent.refreshGrid
                            && typeof (parent.refreshGrid) === 'function') {
                            parent.refreshGrid();
                        }
                        switch (actionFlg) {
                            case 0:
                                //close form
                                that.close();
                                break;
                            case 1:
                                that.defaultViewModel.VoucherNo = data.Data;
                                that.reset();
                                break;
                            case 2:
                                that.defaultViewModel.VoucherNo = data.Data;
                                $('#VoucherNo').val(that.defaultViewModel.VoucherNo);
                                break;
                            case 3:
                                if (data.Data != null) {
                                    $('#LastModifyDateValue').val(data.Data.LastModifyDateValue);
                                }
                                that.defaultViewModel = ASOFT.helper.dataFormToJSON('POSF00151');
                                that.gridDataSource.saveChanges();

                                break;
                        }
                    }, null, null, true);
                }
            );

            return false;
        }//end save (function)
    });
    kendo.bind($('#POSF00151'), posViewModel);
}

/******************************************************************************
                            Function
*******************************************************************************/

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

/*
* gen checkbox
*/
function genCheckBox(data) {
    if (data.Status == 0) {
        return '<input type="checkbox"/>';
    }
    return '<input type="checkbox"/>';
}


/**
* Gen delete button
*/
function genDeleteBtn(data) {
    return '<a href="\\#" onclick="return deleteVoucher_Click(this);" class="asf-i-delete-24 asf-icon-24"><span>Del</span></a>';
}

/**
* Gen delete button
*/
function genCheckbox(data) {
    console.debug(data.Status);
    if (data.Status == 1) {

        return '<div class="asf-i-check-24 asf-icon-24">&nbsp;</div>';
    }
    return '<div  class="asf-i-uncheck-24 asf-icon-24">&nbsp;</div>';
}

/**
* Format MarkQuantity
*/
function genMarkQuantity(data) {
    if (data
        && data.APKMInherited != null
        && data.MarkQuantity != null) {
        return data.MarkQuantity;
    }
    return '';
}

/******************************************************************************
                            EVENTS
*******************************************************************************/
/**
* delete voucher
*/
function deleteVoucher_Click(e) {
    if (posGrid.dataSource.data().length == 1)
    {
        posGrid.dataSource.data([]);
        posGrid.addRow();
        $("#POSF00151Grid").removeAttr("AddNewRowDisabled");
        $("#btnInherit").data("kendoButton").enable(true);
        return false;
    }
    var tagA = $(e).parent();
    ASOFT.dialog.confirmDialog(
        ASOFT.helper.getMessage('00ML000024'),
        //yes
        function () {
            posViewModel.deleteItems(tagA);
        },
        function () {

        }
    );
    return false;

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
* Close popup
*/
function btnCloseOnly_Click(event) {
    //Close popup
    posViewModel.close();
}

/**
* Close popup
*/
function inherit_Close(event) {
    //Close popup
    ASOFT.asoftPopup.hideIframe();
}

/*
* Inherit click
*/
function inherit_Click(e) {
    var data = {};
    var url = getAbsoluteUrl('POSF00152');
    ASOFT.asoftPopup.showIframe(url, data);
    return false;
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
        posViewModel.set('EmployeeName', '');
        return null;
    };

    // get tranmonth, tranyear value
    posViewModel.set('EmployeeName', dataItem.Name);
}

/**
* Change combox
*/
function cboEmployeeID_Change(e) {
    var check = ASOFT.form.checkItemInListFor(this, 'POSF00151');
    if (!check) {
        posViewModel.set('EmployeeName', '');
        e.sender.focus();
    }
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


function Grid_DataBind() {
    var gridPost = $('#POSF00151Grid').data('kendoGrid');
    if (gridPost.dataSource.at(0) != undefined) {
        if (gridPost.dataSource.at(0).APKMInherited == EMPTY_GUID) {
            if ($("#IsUpdate").val() == "True") {
                $("#btnSaveNew").data("kendoButton").enable(true);
            }
        }
    }
}
/**
* Close inherit Popup
*/
function InheritPopup_Choose(event, ids) {
    posViewModel.inherit(ids);
    for (i = 0; i < posGrid.dataSource.data().length ; i++) {
        posGrid.dataSource.at(i).fields["InventoryID"].editable = false;
    }
    ASOFT.asoftPopup.hideIframe();
}

$(document).ready(function () {
    var log = console.log;
    GRID_AUTOCOMPLETE.config({
        gridName: 'POSF00151Grid',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        actionName: 'POSF0015',
        controllerName: "GetInventories",
        grid: $('#POSF00151Grid').data('kendoGrid'),
        setDataItem: function (selectedRowItem, dataItem) {
            //log(dataItem);
            selectedRowItem.model.set('InventoryID', dataItem.InventoryID);
            selectedRowItem.model.set('InventoryName', dataItem.InventoryName);
            selectedRowItem.model.set('UnitName', dataItem.UnitName);
            selectedRowItem.model.set('UnitID', dataItem.UnitID);
            selectedRowItem.model.set('UnitName', dataItem.UnitName);
            selectedRowItem.model.set('WareHouseID', dataItem.WareHouseID);
            selectedRowItem.model.set('WareHouseName', dataItem.WareHouseName);
            selectedRowItem.model.set('UnitName', dataItem.UnitName);
            selectedRowItem.model.set('MarkQuantity', dataItem.MarkQuantity);
            selectedRowItem.model.set('UnitPrice', dataItem.UnitPrice | 0);
            //selectedRowItem.model.set('ActualQuantity', dataItem.ActualQuantity);
            $("#btnInherit").data("kendoButton").enable(false);
        }
    });

});

/**
* Grid Save
*/
function Grid_Save(e) {
    if (e.values == null) {
        return true;
    }
    var cboInventoryIDModel = e.values.CboInventoryName;
    //Business
    if (cboInventoryIDModel) {


    } else if (e.values.ActualQuantity != null
				&& e.model.MarkQuantity != null
				&& e.model.APKMInherited != null) {
        e.model.ActualQuantity = e.values.ActualQuantity;
        if (e.values.ActualQuantity >= e.model.MarkQuantity) {
            e.model.set('Status', 1);
        } else {
            e.model.set('Status', 0);
        }
    }
    //posGrid.refresh();
}

//var staticDataSource, activeDataSource;
function Grid_Edit(e) {
    var target = posGrid.element.find('input[type="text"]')
    target.select().putCursorAtEnd();
    //setTimeout(function () {
    //    target.select();
    //}, 40);
}


// put Cursor At End of input textbox
(function ($) {
    jQuery.fn.putCursorAtEnd = jQuery.fn.putCursorAtEnd || function () {
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

//function Grid_Edit_(e) {
//    var combo = $(e.container.find("#CboInventoryName")[0]).data('kendoComboBox'),
//        log = console.log,
//        numb = '0123456789',
//        lwr = 'abcdefghijklmnopqrstuvwxyz',
//        upr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

//    function isValid(parm, val) {
//        if (parm == "") return true;
//        for (i = 0; i < parm.length; i++) {
//            if (val.indexOf(parm.charAt(i), 0) == -1) return false;
//        }
//        return true;
//    }

//    function isNumber(parm) { return isValid(parm, numb); }
//    function isLower(parm) { return isValid(parm, lwr); }
//    function isUpper(parm) { return isValid(parm, upr); }
//    function isAlpha(parm) { return isValid(parm, lwr + upr); }
//    function isAlphanum(parm) { return isValid(parm, lwr + upr + numb); }

//    if (combo) {
//        var input = $('input[name="CboInventoryName_input"]');
//        staticDataSource = combo.dataSource;
//        combo.setDataSource(activeDataSource);

//        input.on('keyup', function (e) {

//            var i = 0, item, value = input.val(), char = String.fromCharCode(e.keyCode), limit = 11, count = 0;
//            if (!isAlphanum(char) || e.keyCode == 8 || e.keyCode == 46) {
//                return;
//            }

//            activeDataSource = new kendo.data.DataSource({ data: [] });
//            activeDataSource.add(staticDataSource.at(0));
//            for (; item = staticDataSource.at(i++) ;) {
//                if (item.InventoryID.toLowerCase().indexOf(value.toLowerCase()) > 0) {
//                    activeDataSource.add(item);
//                    count += 1;
//                    if (count > limit) {
//                        break;
//                    }
//                }
//            }

//            combo.setDataSource(activeDataSource);
//            log(activeDataSource);
//            combo.open();
//        });
//    }
//    //
//    //

//}