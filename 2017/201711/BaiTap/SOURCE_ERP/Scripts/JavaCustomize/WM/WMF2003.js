//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/01/2017      Văn Tài          Tạo mới
//####################################################################

var warehouse_cbo;
var inventory_cbo;
var employee_cbo;
var vouchertype_cbo;
var credit_cbo;

var txtWarehouseName = "txtWarehouseName";
var txtInventoryTypeName = "txtInventoryTypeName";
var txtEmployeeID = "txtEmployeeID";
var txtRefNo1 = "RefNo01";
var txtRefNo2 = "RefNo02";
var txtDescription = "Description";
var txtContract = "ContractID";
var txtContractNo = "ContractNo";

var txtVoucherNo = "VoucherNo";
var txtVoucherID = "VoucherID";

var MasterTableName = "WT0095";
var DetailTableName = "WT0096";

var btnContact = "btnContact";

//var tempCheckAllDataChange = [];
var isCheckAllDataChange = false;
var isStatus = null;

var today = new Date();

$(document).ready(function () {    
    var grid = $('#GridEditWT0096').data('kendoGrid');

    // Thêm các text box nằm phía sau các combobox
    AppendSubTextBox();
    // Đem <tr 'Hợp đồng' sang table phải
    MoveContactToRight();
    // Readonly cho textbox
    // số chứng từ
    $("#" + txtVoucherNo).attr("readonly", "true");
    // hợp đồng
    $("#" + txtContract).attr("readonly", "true");
    // Số hợp đồng
    $("#" + txtContractNo).attr("readonly", "true");

    // Xử lý khi popup hoàn thành hiển thị
    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            var main = $("#WMF2003");
            var WMF3000Tab = $("#WMF3000Tab");
            main.prepend(WMF3000Tab);

            var mainReportTab = $("#MainReportTab");
            var mainMaster = $("div.asf-form-container.container_12.pagging_bottom");
            mainReportTab.prepend(mainMaster);


            if ($('#WMF3000Tab-2').outerHeight() > mainMaster.outerHeight()) {
                $("#Parameter").css("overflow-y", "scroll").css("height", mainMaster.outerHeight())
            } else {
                $("#Parameter").css("height", mainMaster.outerHeight())
            }
            warehouse_cbo = $("#ImWareHouseID").data("kendoComboBox");
            inventory_cbo = $("#InventoryTypeID").data("kendoComboBox");
            //employee_cbo = $("#EmployeeID").data("kendoComboBox");
            vouchertype_cbo = $("#VoucherTypeID").data("kendoComboBox");
            //credit_cbo = $("#cbbCreditAccountID").data("kendoComboBox");
            credit_cbo = $("#cbbCreditAccountID").data("kendoDropDownList");


            $("#ImWareHouseID").on('change', warehouse_cbo_onchange);
            $("#InventoryTypeID").on('change', inventorytype_cbo_onchange);
            //$("#EmployeeID").on('change', employee_cbo_onchange);
            $("#VoucherTypeID").on('change', vouchertype_onchange);

            WMF2003.inventory_org_data = [];
            WMF2003.LastRowCount = grid.dataSource._data.length;

            // Lấy danh sách tài khoản
            WMF2003.GetAccountList();

            if ($('#isUpdate').val() == "True") {
                isStatus = "Update";

                // Lấy VoucherID
                var txt_voucherid = $("#" + WMF2003.VOUCHERID);
                if (txt_voucherid) {
                    WMF2003.VoucherID = txt_voucherid.val();
                }

                vouchertype_cbo.readonly();
                //warehouse_cbo.readonly();
                //inventory_cbo.readonly();

            } else if ($('#isInherit').val() == "True") {
                isStatus = "Inherit";
            } else {
                isStatus = "AddNew";

                // Thêm button chọn 'Hợp đồng'
                AddContactButton();

                // Xử lý combo loại mặt hàng
                var inventory_data = inventory_cbo.dataSource._data;
                if (inventory_data.length > 0) {
                    inventory_cbo.select(0);
                    var selected_item = inventory_cbo.dataItem(inventory_cbo.select());
                    if (selected_item) {
                        $("#" + txtInventoryTypeName).val(selected_item.InventoryTypeName);
                    }
                }

                $("#VoucherDate").data("kendoDatePicker").value(today);
                WMF2003.VoucherDate = $("#VoucherDate").data("kendoDatePicker").value();
            }

            // Nếu popup thực hiển sửa dữ liệu
            if (isStatus == "Update") {
                var grid_update_data = grid.dataSource.data();
                for (var i = 0; i < grid_update_data.length; i++) {
                    var inventory = [];
                    inventory.InventoryID = grid_update_data[i].InventoryID;
                    inventory.ActualQuantity = grid_update_data[i].ActualQuantity;
                    WMF2003.UpdateInventoryList(inventory);
                }

                // Lấy dữ liệu ban đầu
                WMF2003.GetAllInventoryCheck(grid_update_data);

                // Lấy thông tin CreditAccountID
                WMF2003.CollectAccountID();

                // Cần lưu giữ giá trị ContractNo và ID
                WMF2003.selected_contract.ContractNo = $("#" + txtContractNo).val();
                WMF2003.selected_contract.ContractID = $("#" + txtContract).val();

                // Xử lý hiển thị tên : Tên kho nhập và Tên loại hàng
                var warehouse_item = warehouse_cbo.dataItem(warehouse_cbo.select());
                if (warehouse_item != null || !(typeof (warehouse_item) == "undefined"))
                    $("[name=" + txtWarehouseName + "]").val(warehouse_item.WareHouseName);

                var inventorytype_item = inventory_cbo.dataItem(inventory_cbo.select());
                if (inventorytype_item != null || !(typeof (inventorytype_item) == "undefined"))
                    $("[name=" + txtInventoryTypeName + "]").val(inventorytype_item.InventoryTypeName);

                $('#SParameter01').val($('#SP01').val());
                $('#SParameter02').val($('#SP02').val());
                $('#SParameter03').val($('#SP03').val());
                $('#SParameter04').val($('#SP04').val());
                $('#SParameter05').val($('#SP05').val());
                $('#SParameter06').val($('#SP06').val());
                $('#SParameter07').val($('#SP07').val());
                $('#SParameter08').val($('#SP08').val());
                $('#SParameter09').val($('#SP09').val());
                $('#SParameter10').val($('#SP10').val());
                $('#SParameter11').val($('#SP11').val());
                $('#SParameter12').val($('#SP12').val());
                $('#SParameter13').val($('#SP13').val());
                $('#SParameter14').val($('#SP14').val());
                $('#SParameter15').val($('#SP15').val());
                $('#SParameter16').val($('#SP16').val());
                $('#SParameter17').val($('#SP17').val());
                $('#SParameter18').val($('#SP18').val());
                $('#SParameter19').val($('#SP19').val());
                $('#SParameter20').val($('#SP20').val());
            }

            if(parseInt($('#CheckTab').val()) == 0)
            {
                var tabStrip = $("#WMF3000Tab").kendoTabStrip().data("kendoTabStrip");
                tabStrip.enable(tabStrip.tabGroup.children().eq(1), false);
            }else{
                var tabStrip = $("#WMF3000Tab").kendoTabStrip().data("kendoTabStrip");
                tabStrip.enable(tabStrip.tabGroup.children().eq(1), true);
            }

            // Việc load dữ liệu trên popup đã hoàn thành
            WMF2003.DataLoading = false;
        }
    });

    $(grid.tbody).on("click", "td", function (e) {
        $(e.target.parentNode.parentNode).find('tr').removeClass('k-state-selected')
        $(e.target.parentNode).addClass('k-state-selected');
    });

    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;
        if (typeof (e.target.value) == "undefined") {
            return;
        }
        if (e.target.value.length <= 0) {
            return;
        }

        if (selectitem == null || typeof (selectitem) == "undefined")
            return;

        if (column == "LimitDate") {
            //truyền giá trị chọn vào model grid
            if (isNormalDate(e.target.value))
                selectitem.LimitDate = e.target.value;
        }

        if (column == 'cbbDebitAccountID') {
            var id = e.target.value;
            selectitem.DebitAccountID = id;
        }

        if (column == 'cbbCreditAccountID' || e.target.name.split('_')[0] == 'CreditAccountID') {
            var id = e.target.value;
            selectitem.CreditAccountID = id;
        }

        if (column == 'ActualQuantity') {
            var id = e.target.value;
            selectitem.ActualQuantity = id;
        }
    });

    $(grid.tbody).on("focusout", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;

        // Lỗi 'blur' khi dùng grid.refresh() tại onchange
        if (selectitem == null || typeof (selectitem) == "undefined")
            return;

        if (column == "ActualQuantity") {
            if (selectitem.ActualQuantity != null && selectitem.UnitPrice != null) {
                selectitem.OriginalAmount = parseFloat(selectitem.ActualQuantity) * parseFloat(selectitem.UnitPrice);
                grid.refresh();
            } else {
                selectitem.OriginalAmount = "";
                grid.refresh();
            }
            return;
        }

        if (column == "InventoryID") {

            if (selectitem.InventoryID == "") {
                // Xóa trắng các trường dữ liệu
                selectitem.InventoryID = "...";
                selectitem.InventoryName = "";
                selectitem.UnitID = "";
                selectitem.ActualQuantity = "";
                selectitem.UnitPrice = "";
                selectitem.OriginalAmount = "";
                selectitem.SourceNo = "";
                selectitem.DebitAccoutID = "";
                //selectitem.CreditAccountID = "";
                // selectitem.LimitDate = "";
                selectitem.Notes = "";

                grid.refresh();
                return;
            }
            if (e.target.value.length <= 0) {
                return;
            }
            var canSearch = true;
            var message_array = [];
            ASOFT.form.clearMessageBox();

            if ($("#" + txtContractNo).val().length <= 0) {
                // Chọn hợp đồng trước khi chọn mặt hàng
                message_array.push(ASOFT.helper.getMessage("WFML000205"));
                //WMF2003.AddContractIDError();
                WMF2003.AddContractNoError();
                canSearch = false;
            } else {
                //WMF2003.ClearContractIDError();
                WMF2003.ClearContractNoError();
            }

            var selected_inventorytype = inventory_cbo.dataItem(inventory_cbo.select());
            if (typeof (selected_inventorytype) == "undefined") {
                // Chọn loại hàng trước khi chọn mặt hàng
                message_array.push(ASOFT.helper.getMessage("WFML000206"));
                WMF2003.AddInventoryTypeIDError();
                canSearch = false;
            } else {
                WMF2003.ClearContractIDError();
            }

            if (typeof (selectitem.InventoryID) == "undefined") {
                canSearch = false;
                if (message_array.length <= 0)
                    return;
            }
            else {
                if (selectitem.InventoryID.length <= 0) {
                    canSearch = false;
                }
            }

            selectitem.InventoryID = e.target.value;
            var InventoryID = selectitem.InventoryID;

            if (!canSearch) {
                WMF2003.ShowMessageErrors(message_array);
            } else {
                var Inventory = WMF2003.GetInventoryDetails(InventoryID);

                if (!WMF2003.Collecting) {
                    if (typeof (Inventory.InventoryID) == "undefined") {
                        // Xóa trắng các trường dữ liệu
                        //selectitem.InventoryID = "...";
                        selectitem.InventoryName = "";
                        selectitem.UnitID = "";
                        selectitem.ActualQuantity = "";
                        selectitem.UnitPrice = " ";
                        selectitem.OriginalAmount = "";
                        selectitem.SourceNo = "";
                        selectitem.Notes = "";
                        selectitem.DebitAccountID = "";
                        //selectitem.CreditAccountID = "";

                        grid.refresh();
                    }
                    else {
                        selectitem.InventoryName = Inventory.InventoryName;
                        selectitem.UnitID = Inventory.UnitID;

                        // Trường hợp focus-out không thay đổi số lượng nhập và thành tiền
                        //selectitem.ActualQuantity = Inventory.ActualQuantity;
                        //selectitem.OriginalAmount

                        selectitem.DebitAccountID = Inventory.AccountID;
                        selectitem.UnitPrice = Inventory.UnitPrice;

                        var inventory_check = [];
                        inventory_check.InventoryID = Inventory.InventoryID;
                        inventory_check.IsSource = Inventory.IsSource;
                        inventory_check.IsLimitDate = Inventory.IsLimitDate;
                        inventory_check.AccountID = Inventory.AccountID;
                        WMF2003.UpdateInventoryCheck(inventory_check);

                        grid.refresh();
                    }
                }
            }
        }

        if (column == "" && !WMF2003.Collecting) {
            if (selectitem.InventoryID == "") {
                // Xóa trắng các trường dữ liệu
                selectitem.InventoryID = "...";
                selectitem.InventoryName = "";
                selectitem.UnitID = "";
                selectitem.ActualQuantity = "";
                selectitem.UnitPrice = "";
                selectitem.OriginalAmount = "";
                selectitem.SourceNo = "";
                selectitem.Notes = "";
                //selectitem.CreditAccountID = "";

                grid.refresh();
            }
        }

        if (column = "LimitDate") {
            //truyền giá trị chọn vào model grid
            if (isNormalDate(e.target.value))
                selectitem.LimitDate = e.target.value;
        }

        if (column == 'cbbDebitAccountID') {
            var id = e.target.value;
            selectitem.DebitAccountID = id;
        }

        if (column == 'cbbCreditAccountID' || e.target.name.split('_')[0] == 'CreditAccountID') {
            var id = e.target.value;
            selectitem.CreditAccountID = id;
        }
    });

    $(grid.tbody).off("keydown mouseleave", "td").on("keydown mouseleave", "td", function (e) {
        ASOFT.asoftGrid.currentRow = $(this).parent().index();
        ASOFT.asoftGrid.currentCell = $(this).index();

        var editor = columns[ASOFT.asoftGrid.currentCell].editor;
        var isDefaultLR = $(grid.element).attr('isDefaultLR');
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

    grid.bind("dataBound", function () {
        var data = grid.dataSource._data;
        if (!WMF2003.DataLoading) {
            if (WMF2003.LastRowCount < data.length) {
                WMF2003.LastRowCount = data.length;
                data[data.length - 1].CreditAccountID = WMF2003.CurrentCreditAccountID;
                this.refresh();
            }
        }
        WMF2003.LastRowCount = data.length;

        //$(dataSource).each(function () {
        //    // Setting tài khoản
        //    //this.CreditAccountID = WMF2003.CurrentCreditAccountID;                
        //    //this.DebitAccountID = WMF2003.GetAccountCheck(this.InventoryID);
        //});
    });

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditWT0096',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "InventoryID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.container.parent().css('background', '');
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);

            var Inventory = WMF2003.GetInventoryDetails(dataItem.InventoryID);

            var inventory_check = [];
            inventory_check.InventoryID = dataItem.InventoryID;
            inventory_check.IsSource = dataItem.IsSource;
            inventory_check.IsLimitDate = dataItem.IsLimitDate;
            inventory_check.AccountID = dataItem.AccountID;
            WMF2003.UpdateInventoryCheck(inventory_check);

            selectedRowItem.model.set("InventoryName", Inventory.InventoryName);
            selectedRowItem.model.set("UnitID", Inventory.UnitID);
            selectedRowItem.model.set("ActualQuantity", Inventory.ActualQuantity);
            selectedRowItem.model.set("UnitPrice", Inventory.UnitPrice);
            selectedRowItem.model.set("OriginalAmount", Inventory.OriginalAmount);
            selectedRowItem.model.set("DebitAccountID", Inventory.AccountID);

            if (Inventory) {
                //WMF2003.ClearContractIDError();
                WMF2003.ClearContractNoError();
                WMF2003.ClearInventoryTypeIDError();
            }
        }
    });

});

function AppendSubTextBox() {
    var warehouse_parent = $("#ImWareHouseID").parent();
    var inventory_parent = $("#InventoryTypeID").parent();
    //var employee_parent = $("#EmployeeID").parent();

    var textbox_width = "62%";
    var combo_width = "35%";
    // warehouse
    if (warehouse_parent) {
        warehouse_parent.css("width", combo_width);
        var warehouse_textbox = $('<input id="' + txtWarehouseName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtWarehouseName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        warehouse_textbox.insertAfter(warehouse_parent);
    }
    // inventory_type
    if (inventory_parent) {
        inventory_parent.css("width", combo_width);
        var inventory_textbox = $('<input id="' + txtInventoryTypeName + '" class="asf-textbox" readonly initvalue="" maxlength="" message="" name="' + txtInventoryTypeName + '" regular="" style=" width: ' + textbox_width + '; height:22px; margin-left: 3%" type="text" value="" data-val-regex-pattern="" data-val-regex="">');
        inventory_textbox.insertAfter(inventory_parent);
    }
}

function MoveContactToRight() {
    //var tr_ContractID = $('tr.ContractID');
    //var tr_ImWareHouseID = $('tr.ImWareHouseID');

    //if (tr_ContractID && tr_ImWareHouseID) {
    //    $('tr.ContractID').remove();
    //    tr_ImWareHouseID.before(tr_ContractID);
    //}

    var tr_ContractNo = $('tr.ContractNo');
    var tr_ImWareHouseID = $('tr.ImWareHouseID');

    if (tr_ContractNo && tr_ImWareHouseID) {
        $('tr.ContractNo').remove();
        tr_ImWareHouseID.before(tr_ContractNo);
    }
}

function AddContactButton() {
    var textbox_width = "62%";
    var button_width = "35%";
    var textbox_margin_left = "3%";

    //var txt_ContractID = $('#ContractID');
    //if (txt_ContractID) {
    //    txt_ContractID.css('width', textbox_width);
    //    txt_ContractID.css('margin-left', textbox_margin_left);

    //    var contact_button = $('<a class="k-button k-button-icontext asf-button" id="' + btnContact + '" style=" width: ' + button_width + '; min-width: 1%; margin: 0px; " data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text" style="text-decoration: underline;">...</span></a>');
    //    contact_button.insertBefore(txt_ContractID);

    //    $('#' + btnContact).on('click', btnContact_onClick);
    //}

    var txt_ContractNo = $('#' + txtContractNo);
    if (txt_ContractNo) {
        txt_ContractNo.css('width', textbox_width);
        txt_ContractNo.css('margin-left', textbox_margin_left);

        var contact_button = $('<a class="k-button k-button-icontext asf-button" id="' + btnContact + '" style=" width: ' + button_width + '; min-width: 1%; margin: 0px; " data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text" style="text-decoration: underline;">...</span></a>');
        contact_button.insertBefore(txt_ContractNo);

        $('#' + btnContact).on('click', btnContact_onClick);
    }
}

function warehouse_cbo_onchange() {
    var selected_item = warehouse_cbo.dataItem(warehouse_cbo.select());
    if (selected_item) {
        var WareHouseName = selected_item.WareHouseName;
        $("[name=" + txtWarehouseName + "]").val(WareHouseName);
    }
    else {
        $("[name=" + txtWarehouseName + "]").val("");
    }
}

function inventorytype_cbo_onchange() {
    var selected_item = inventory_cbo.dataItem(inventory_cbo.select());
    if (selected_item) {
        var InventoryTypeName = selected_item.InventoryTypeName;
        $("[name=" + txtInventoryTypeName + "]").val(InventoryTypeName);
        WMF2003.ClearInventoryTypeIDError();
    }
    else {
        $("[name=" + txtInventoryTypeName + "]").val("");
    }

    //WMF2003.inventory_org_data = [];

    //var grid = $('#GridEditWT0096').data('kendoGrid');
    //grid.dataSource.data([]);
    //grid.addRow();
}

function employee_cbo_onchange() {
    var selected_item = employee_cbo.dataItem(employee_cbo.select());
    if (selected_item) {
        var EmployeeName = selected_item.EmployeeName;
        $("[name=" + txtEmployeeID + "]").val(EmployeeName);
    }
    else {
        $("[name=" + txtEmployeeID + "]").val("");
    }
}

function vouchertype_onchange() {
    var selected_item = vouchertype_cbo.dataItem(vouchertype_cbo.select());
    if (selected_item) {
        var VoucherTypeID = selected_item.VoucherTypeID;

        // Lưu lại 2 mã AccountID
        var account_check = [];
        account_check.DebitAccountID = selected_item.DebitAccountID;
        account_check.CreditAccountID = selected_item.CreditAccountID;
        WMF2003.UpdateAccountCheck(account_check);

        WMF2003.UpdateColCreditAccount();

        var url = "/WM/WMF2003/GetVoucherNoText";
        var data = {
            VoucherTypeID: VoucherTypeID,
            TableID: "WT0095"
        };
        ASOFT.helper.postTypeJson(url, data, function (data) {
            if (data.NewKey) {
                $("#" + txtVoucherNo).val(data.NewKey);
            } else {
                $("#" + txtVoucherNo).val("");
            }
        });
    }
    else {
        $("#" + txtVoucherNo).val("");
    }
}

function format_date(date) {
    var year = date.getFullYear();
    var month = (1 + date.getMonth()).toString();
    month = month.length > 1 ? month : '0' + month;
    var day = date.getDate().toString();
    day = day.length > 1 ? day : '0' + day;
    return day + '/' + month + '/' + year;
}

function isDate(strDate) {
    var date = Date.parse(strDate);
    if (date)
        return true
    else
        return false;
}

// Kiểm tra chuỗi đầu vào có phải theo định dạng dd/MM/yyyy
function isNormalDate(strDate) {

    var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;

    var valid_date = pattern.test(strDate);

    return valid_date;

    //if (Object.prototype.toString.call(strDate) === "[object Date]") {
    //    // it is a date
    //    if (isNaN(d.getTime())) {  // d.valueOf() could also work
    //        // date is not valid
    //        return false;
    //    }
    //    else {
    //        // date is valid
    //        return true;
    //    }
    //}
    //else {
    //    // not a date
    //    return false;
    //}
}

function btnContact_onClick() {
    WMF2003.CurrentChoose = WMF2003.CHOOSECONTRACT;

    WMF2003.VoucherDate = $("#VoucherDate").data("kendoDatePicker").value();
    var strDate = $("#VoucherDate").val();
    if (strDate.length > 0)
        if (!isDate(WMF2003.VoucherDate)) {
            ASOFT.form.clearMessageBox();
            $("#VoucherDate").addClass('asf-focus-input-error');
            WMF2003.ShowMessageError("00ML000058");
            return;
        }

    if (WMF2003.VoucherDate == null) {
        ASOFT.form.clearMessageBox();
        $("#VoucherDate").addClass('asf-focus-input-error');
        WMF2003.ShowMessageError("WFML000204");
        return;
    }

    ASOFT.form.clearMessageBox();
    $("#VoucherDate").removeClass('asf-focus-input-error');

    var formated_date = format_date(WMF2003.VoucherDate);

    url = '/PopupSelectData/Index/WM/WMF2002?VoucherDate=' + formated_date + '&ScreenID=' + $('#sysScreenID').val();

    ASOFT.asoftPopup.showIframe(url, {});
}

function ChooseInventoryID_Click() {
    WMF2003.Collecting = true;
    WMF2003.CurrentChoose = WMF2003.CHOOSEINVENTORY;

    var canSearch = true;
    var message_array = [];
    ASOFT.form.clearMessageBox();

    if ($("#" + txtContractNo).val().length <= 0) {
        // Chọn hợp đồng trước khi chọn mặt hàng
        message_array.push(ASOFT.helper.getMessage("WFML000205"));
        //WMF2003.AddContractIDError();
        WMF2003.AddContractNoError();
        canSearch = false;
    } else {
        //WMF2003.ClearContractIDError();
        WMF2003.ClearContractNoError();
    }

    var selected_inventorytype = inventory_cbo.dataItem(inventory_cbo.select());
    if (typeof (selected_inventorytype) == "undefined") {
        // Chọn loại hàng trước khi chọn mặt hàng
        message_array.push(ASOFT.helper.getMessage("WFML000206"));
        WMF2003.AddInventoryTypeIDError();
        canSearch = false;
    } else {
        WMF2003.ClearContractIDError();
    }

    if (!canSearch) {
        WMF2003.ShowMessageErrors(message_array);
        return;
    }
    else {
        var ContractID = WMF2003.GetContractID();
        var InventoryTypeID = WMF2003.GetInventoryTypeID();
        var InventoryIDList = WMF2003.GetInventoryIDList();
        var Mode = 1;
        var voucherID = WMF2003.VoucherID;

        url = '/PopupSelectData/Index/WM/WMF2008?ContractID=' + ContractID
            + '&InventoryTypeID=' + InventoryTypeID
            + '&InventoryIDList=' + InventoryIDList
            + '&Mode=' + Mode
            + '&VoucherID=' + voucherID
            + '&ScreenID=' + $('#sysScreenID').val();

        ASOFT.asoftPopup.showIframe(url, {});
    }
}

WMF2003 = new function () {
    this.VoucherDate = null;

    this.COL_INVENTORYID = "InventoryID";
    this.COL_INVENTORYNAME = "InventoryName";
    this.COL_ACTUALQUANTITY = "ActualQuantity";
    this.COL_ORIGINALAMOUNT = "OriginalAmount";
    this.COL_UNITID = "UnitID";
    this.COL_UNITPRICE = "UnitPrice";
    this.COL_SOURCENO = "SourceNo";
    this.COL_LIMITDATE = "LimitDate";
    this.COL_ISLIMITDATE = "IsLimitDate";
    this.COL_ISSOURCE = "IsSource";
    this.COL_ACCOUNTID = "AccountID";

    this.CREDITACCOUNTID = "CreditAccountID";
    this.DEBITACCOUNTID = "DebitAccountID";

    this.VOUCHERID = "VoucherID";

    // Data Properties
    this.VoucherID = "";
    // Lưu thông tin số lượng của từng mặt hàng - trường hợp thêm mới
    this.inventory_org_data = [];

    this.inventory_check = [];
    this.account_list = [];

    this.selected_contract = { ContractID: "", ContractNo: "" };

    this.CurrentDebitAccountID = "";
    this.CurrentCreditAccountID = "";

    this.LastRowCount = 1;
    this.DataLoading = true;
    // Data Properties - END

    // Trường hợp load popup chọn
    this.CHOOSEINVENTORY = "Inventory";
    this.CHOOSEACCOUCT = "Account";
    this.CHOOSECONTRACT = "Contract";

    this.CurrentChoose = "";
    this.Collecting = false;

    // Loại lỗi
    this.CONVERT_PROBLEM = "Convert";
    this.QUANTITY_PROBLEM = "Quantity";

    // Kiểm tra mã mặt hàng - inventory id có tồn tại trong inventory_org_data chưa
    this.IsExistInventData = function (inventoryid) {
        for (var i = 0; i < this.inventory_org_data.length; i++) {
            if (inventoryid == this.inventory_org_data[i].InventoryID)
                return true;
        }
        return false;
    };

    // Kiểm tra tài khoản có tồn tại
    this.IsExistAccountID = function (accountid) {
        for (var i = 0; i < this.account_list.length; i++) {
            if (accountid == this.account_list[i].AccountID) {
                return true;
            }
        }
        return false;
    }

    // Kiểm tra số lượng nhập lớn hơn số lượng tồn
    this.WrongActualQuantity = function (inventoryid, newquantity) {
        for (var i = 0; i < this.inventory_org_data.length; i++) {
            if (inventoryid == this.inventory_org_data[i].InventoryID) {
                if (parseFloat(newquantity) > parseFloat(this.inventory_org_data[i].ActualQuantity)) {
                    return this.QUANTITY_PROBLEM;
                }
            }
        }
        return "";
    };

    this.GetColIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName)
                return i;
        }
        return 0;
    }

    this.GetContractID = function () {
        var contractID = $("#" + txtContract).val();
        return (contractID) ? contractID : "";
    }

    this.GetContractNo = function () {
        var contractNo = $("#" + txtContractNo).val();
        return (contractNo) ? contractNo : "";
    }

    this.GetVoucherNo = function () {
        var VoucherNo = $("#" + txtVoucherNo).val();
        return (VoucherNo) ? VoucherNo : "";
    }

    this.GetVoucherID = function () {
        var VoucherID = $("#" + txtVoucherID).val();
        return (VoucherID) ? VoucherID : "";
    }

    this.GetInventoryTypeID = function () {
        var selected_item = inventory_cbo.dataItem(inventory_cbo.select());
        if (selected_item)
            return (selected_item.InventoryTypeID) ? selected_item.InventoryTypeID : "";
        else
            return "";
    }

    this.GetWareHouseID = function () {
        var selected_item = warehouse_cbo.dataItem(warehouse_cbo.select());
        if (selected_item)
            return (selected_item.WareHouseID) ? selected_item.WareHouseID : "";
        else
            return "";
    }

    this.GetEmployeeID = function () {
        var selected_item = employee_cbo.dataItem(employee_cbo.select());
        if (selected_item)
            return (selected_item.EmployeeID) ? selected_item.EmployeeID : "";
        else
            return "";
    }

    this.ShowMessageError = function (message_id) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage(message_id)], null);
    }

    this.ShowMessageErrors = function (message_array) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }

    this.SelectFirstWarehouse = function () {
        var data = {
            ContractID: this.selected_contract.ContractID
        };
        ASOFT.helper.post("/WM/WMF2003/GetImWarehouseID", data, function (result) {
            if (result.length > 0) {
                warehouse_cbo.setDataSource(result);
                warehouse_cbo.select(0);
                $("#" + txtWarehouseName).val(result[0].WareHouseName);
            }
        });
    }

    // Xử lý cập nhật danh sách Inventory : thông tin về số lượng nhập
    this.UpdateInventoryList = function (data) {
        if (data) {
            var existed_data = false;
            for (var i = 0; i < this.inventory_org_data.length && !existed_data; i++) {
                var item = this.inventory_org_data[i];
                if (data.InventoryID == item.InventoryID) {
                    existed_data = true;
                    this.inventory_org_data[i].ActualQuantity = data.ActualQuantity;
                }
            }
            if (!existed_data) {
                this.inventory_org_data.push(data);
            }
        }
    }

    // Xử lý cập nhật danh sách Inventory : thông tin về Account - IsSource - IsLimitDAte
    this.UpdateInventoryCheck = function (data) {
        if (data) {
            var existed_data = false;
            for (var i = 0; i < this.inventory_check.length && !existed_data; i++) {
                var item = this.inventory_check[i];
                if (data.InventoryID == item.InventoryID) {
                    existed_data = true;
                    this.inventory_check[i].IsSource = data.IsSource;
                    this.inventory_check[i].IsLimitDate = data.IsLimitDate;
                    this.inventory_check[i].AccountID = data.AccountID;
                }
            }
            if (!existed_data) {
                this.inventory_check.push(data);
            }
        }
    }

    // Xử lý cập nhật thông tin Loại chứng từ
    this.UpdateAccountCheck = function (data) {
        if (data) {
            WMF2003.CurrentCreditAccountID = data.CreditAccountID;
            WMF2003.CurrentDebitAccountID = data.DebitAccountID;
        }
    }

    // Xử lý tài khoản có theo loại chứng từ
    this.UpdateColCreditAccount = function () {
        if (this.CurrentCreditAccountID.length > 0) {
            var grid = $('#GridEditWT0096').data('kendoGrid');
            var data = grid.dataSource._data;
            for (var i = 0; i < data.length; i++) {
                data[i].CreditAccountID = this.CurrentCreditAccountID;
            }
            grid.refresh();
        }
    }

    // Load lại danh sách loại hàng hiện có trong hợp đông
    this.RenewInventoryList = function () {
        var new_inventorylist = [];
        var ContractID = this.GetContractID();
        var InventoryTypeID = this.GetInventoryTypeID();
        var InventoryIDList = "";
        var Mode = 1; // NK
        for (var i = 0; i < this.inventory_org_data.length; i++) {
            var InventoryID = this.inventory_org_data[i].InventoryID;
            if (InventoryID.length > 0) {
                var url = "/WM/WMF2003/LoadInventoryDetails";
                var data = {
                    ContractID: ContractID,
                    InventoryTypeID: InventoryTypeID,
                    InventoryID: InventoryID,
                    InventoryIDList: InventoryIDList,
                    Mode: Mode,
                    VoucherID: this.VoucherID
                };
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    if (result.length > 0) {
                        for (var i = 0; i < result.length; i++) {
                            if (InventoryID == result[i].InventoryID) {
                                var inventory = [];
                                inventory.InventoryID = result[i].InventoryID;
                                inventory.ActualQuantity = result[i].ActualQuantity;
                                new_inventorylist.push(inventory);
                            }
                        }
                    }
                });
            }
        }
        this.inventory_org_data = [];
        this.inventory_org_data = new_inventorylist;
    }

    this.GetAllInventoryCheck = function (grid_data) {

        var ContractID = this.GetContractID();
        var InventoryTypeID = this.GetInventoryTypeID();
        var InventoryIDList = "";
        var Mode = 1;

        for (var i = 0; i < grid_data.length; i++) {
            var inventoryid = grid_data[i].InventoryID;
            if (inventoryid.length > 0) {
                var url = "/WM/WMF2003/LoadInventoryDetails";
                var data = {
                    ContractID: ContractID,
                    InventoryTypeID: InventoryTypeID,
                    InventoryID: inventoryid,
                    InventoryIDList: InventoryIDList,
                    Mode: Mode,
                    VoucherID: this.VoucherID
                };
                ASOFT.helper.postTypeJson(url, data, function (result) {
                    if (result.length > 0) {
                        for (var i = 0; i < result.length; i++) {
                            if (inventoryid == result[i].InventoryID) {
                                var Inventory_Result = [];
                                Inventory_Result.InventoryID = result[i].InventoryID;
                                Inventory_Result.IsSource = result[i].IsSource;
                                Inventory_Result.IsLimitDate = result[i].IsLimitDate;
                                Inventory_Result.AccountID = result[i].AccountID;
                                WMF2003.inventory_check.push(Inventory_Result);
                                break;
                            }
                        }
                    }
                });
            }
        }
    }

    this.GetAccountList = function () {
        WMF2003.account_list = [];

        var url = "/WM/WMF2003/GetAccountList";
        var data = [];
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    var account = [];
                    account.AccountID = result[i].AccountID;
                    account.AccountName = result[i].AccountName;
                    WMF2003.account_list.push(account);
                }
            }
        });
    }

    this.CollectAccountID = function () {
        var selected_item = vouchertype_cbo.dataItem(vouchertype_cbo.select());
        if (selected_item) {
            // Lưu lại 2 mã AccountID
            var account_check = [];
            account_check.DebitAccountID = selected_item.DebitAccountID;
            account_check.CreditAccountID = selected_item.CreditAccountID;
            WMF2003.UpdateAccountCheck(account_check);
        }
    }

    this.GetIsSourceNo = function (inventoryID) {
        for (var i = 0; i < this.inventory_check.length; i++) {
            var item = this.inventory_check[i];
            if (inventoryID == item.InventoryID) {
                return this.inventory_check[i].IsSource;
            }
        }
        return 0;
    }

    this.GetIsLimitDate = function (inventoryID) {
        for (var i = 0; i < this.inventory_check.length; i++) {
            var item = this.inventory_check[i];
            if (inventoryID == item.InventoryID) {
                return this.inventory_check[i].IsLimitDate;
            }
        }
        return 0;
    }

    this.LoadWareHouse = function () {
        var url = "/WM/WMF2003/GetWareHouse";
        var data = {
            ContractID: this.GetContractID(),
        };

        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.length > 0) {
                warehouse_cbo.dataSource.data(result);
                warehouse_cbo.refresh();
            }
        })
    }

    this.GetInventoryDetails = function (InventoryID) {

        var ContractID = this.GetContractID();
        var InventoryTypeID = this.GetInventoryTypeID();
        var InventoryIDList = "";

        var Mode = 1;

        var Inventory_Result = [];

        if (InventoryID.length > 0) {
            var url = "/WM/WMF2003/LoadInventoryDetails";
            var data = {
                ContractID: ContractID,
                InventoryTypeID: InventoryTypeID,
                InventoryID: InventoryID,
                InventoryIDList: InventoryIDList,
                Mode: Mode,
                VoucherID: this.VoucherID
            };
            ASOFT.helper.postTypeJson(url, data, function (result) {
                if (result.length > 0) {
                    for (var i = 0; i < result.length; i++) {
                        if (InventoryID == result[i].InventoryID) {
                            Inventory_Result.InventoryID = result[i].InventoryID;
                            Inventory_Result.InventoryName = result[i].InventoryName;
                            Inventory_Result.UnitID = result[i].UnitID;
                            Inventory_Result.ActualQuantity = result[i].ActualQuantity;
                            Inventory_Result.UnitPrice = result[i].UnitPrice;
                            Inventory_Result.IsSource = result[i].IsSource;
                            Inventory_Result.IsLimitDate = result[i].IsLimitDate;
                            Inventory_Result.AccountID = result[i].AccountID;

                            if (Inventory_Result.ActualQuantity != null && Inventory_Result.UnitPrice != null) {
                                Inventory_Result.OriginalAmount = parseFloat(Inventory_Result.ActualQuantity) * parseFloat(Inventory_Result.UnitPrice);
                            }

                            // Kiểm tra inventory và gửi số lượng nhập ( trong csdl ) - lưu lại để
                            // kiếm tra người dùng cập nhật số lượng nhập mới - khác biệt so với dữ liệu cũ
                            if (result[i]) {
                                var inventory = [];
                                inventory.InventoryID = InventoryID;
                                inventory.ActualQuantity = result[i].ActualQuantity;

                                WMF2003.UpdateInventoryList(inventory);
                            }
                        }
                    }
                }
            });
        }

        return Inventory_Result;
    }

    this.GetInventoryIDList = function () {
        var grid = $('#GridEditWT0096').data('kendoGrid');
        var data = grid.dataSource.data();
        var InventoryIDList = "";

        var selectedItem = grid.dataItem(grid.select());
        var selected_inventoryID = "";

        if (selectedItem) {
            if (selectedItem.InventoryID) {
                selected_inventoryID = selectedItem.InventoryID;
            }
        }                
        for (var i = 0; i < data.length; i++) {
            if (data[i]) {
                if (typeof (data[i].InventoryID) != 'undefined') {
                    if (data[i].InventoryID != selected_inventoryID) {
                        InventoryIDList += "," + data[i].InventoryID;
                    }
                }
            }
        }
        return InventoryIDList;
    }

    this.ClearContractIDError = function () {
        var Contract = $("#" + txtContract);
        if (Contract) {
            if (Contract.hasClass('asf-focus-input-error')) {
                Contract.removeClass('asf-focus-input-error');
            }
        }
    }

    this.AddContractIDError = function () {
        var Contract = $("#" + txtContract);
        if (Contract) {
            if (!Contract.hasClass('asf-focus-input-error')) {
                Contract.addClass('asf-focus-input-error');
            }
        }
    }

    this.AddContractNoError = function () {
        var Contract = $("#" + txtContractNo);
        if (Contract) {
            if (!Contract.hasClass('asf-focus-input-error')) {
                Contract.addClass('asf-focus-input-error');
            }
        }
    }

    this.ClearContractNoError = function () {
        var Contract = $("#" + txtContractNo);
        if (Contract) {
            if (Contract.hasClass('asf-focus-input-error')) {
                Contract.removeClass('asf-focus-input-error');
            }
        }
    }

    this.ClearInventoryTypeIDError = function () {
        var InventoryType = $("#" + txtInventoryTypeName);
        if (InventoryType) {
            if (InventoryType.hasClass('asf-focus-input-error')) {
                InventoryType.removeClass('asf-focus-input-error');
            }
        }
    }

    this.AddInventoryTypeIDError = function () {
        var InventoryType = $("#" + txtInventoryTypeName);
        if (InventoryType) {
            if (!InventoryType.hasClass('asf-focus-input-error')) {
                InventoryType.addClass('asf-focus-input-error');
            }
        }
    }
}

function CustomRead() {
    var ct = [];
    ct.push($("#" + txtVoucherID).val());
    return ct;
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var grid = $('#GridEditWT0096').data('kendoGrid');

    var rowList = grid.tbody.children();
    var columns = grid.columns;
    var data = grid.dataSource.data();

    var grid_tr = $('#GridEditWT0096 .k-grid-content tr');

    $(grid.tbody).find('td').removeClass('asf-focus-input-error');

    var Invalid_Data = false;

    if (data) {
        var duplicate_row = false;
        var null_inventory = false;
        var null_contract = false;
        var wrong_quantity = false;
        var cannot_convert = false;
        var notexist_invent = false;
        var negative_value = false;
        var null_sourceno = false;
        var null_limitdate = false;
        var null_account = false;

        var inventory_colindex = WMF2003.GetColIndex(grid, WMF2003.COL_INVENTORYID);
        var quantity_colindex = WMF2003.GetColIndex(grid, WMF2003.COL_ACTUALQUANTITY);
        var sourceno_colindex = WMF2003.GetColIndex(grid, WMF2003.COL_SOURCENO);
        var limitdate_colindex = WMF2003.GetColIndex(grid, WMF2003.COL_LIMITDATE);
        var creditaccount_colindex = WMF2003.GetColIndex(grid, WMF2003.CREDITACCOUNTID);

        // Kiểm tra null Contract
        if (WMF2003.GetContractID() == "" || WMF2003.GetContractNo() == "") {
            null_contract = true;
        }

        // For : xử lý kiểm tra  null dữ liệu - Inventory
        for (var i = 0; i < data.length; i++) {
            var InventoryID = data[i].InventoryID;
            if (InventoryID) {
                for (var j = i + 1; j < data.length; j++) {
                    if (InventoryID == data[j].InventoryID) {
                        $($(grid_tr[j]).children()[inventory_colindex]).addClass('asf-focus-input-error');
                        duplicate_row = true;
                    }
                }
                if (duplicate_row) {
                    $($(grid_tr[i]).children()[inventory_colindex]).addClass('asf-focus-input-error');
                }
            }
            else {
                $($(grid_tr[i]).children()[inventory_colindex]).addClass('asf-focus-input-error');
                null_inventory = true;
            }
        }

        // For : xử lý kiểm ra bất thường số lượng nhập
        if (!null_inventory) {
            for (var i = 0; i < data.length; i++) {
                // Số lượng nhập không được mang giá trị âm
                if (data[i].ActualQuantity < 0) {
                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                    negative_value = true;
                }
                else {
                    if (isStatus == "AddNew") {
                        var problem_message = WMF2003.WrongActualQuantity(data[i].InventoryID, data[i].ActualQuantity);

                        if (problem_message == WMF2003.QUANTITY_PROBLEM) {
                            wrong_quantity = true;
                            $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                        }
                    }
                    else {
                        var url = "/WM/WMF2003/CheckQuantityProblem";
                        var dataPost = {
                            ContractID: WMF2003.GetContractID(),
                            InventoryID: data[i].InventoryID,
                            VoucherID: WMF2003.GetVoucherID(),
                            ActualQuantity: data[i].ActualQuantity,
                            Mode: 0 // Yều cầu nhập kho
                        };
                        ASOFT.helper.postTypeJson(url, dataPost, function (result) {
                            if (typeof (result.Status) != "undefined") {
                                if (result.MessageID == WMF2003.QUANTITY_PROBLEM) {
                                    wrong_quantity = true;
                                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                                }
                                if (result.MessageID == WMF2003.CONVERT_PROBLEM) {
                                    cannot_convert = true;
                                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                                }
                            }
                        });
                    }

                    var current_invent = data[i].InventoryID;
                    if (!WMF2003.IsExistInventData(current_invent)) {
                        $($(grid_tr[i]).children()[inventory_colindex]).addClass('asf-focus-input-error');
                        if (data[i].InventoryID == "...") {
                            null_inventory = true;
                        }
                        else {
                            notexist_invent = true;
                        }
                    }
                }
            }
        }

        if (!null_inventory) {
            for (var i = 0; i < data.length; i++) {
                var isSource = WMF2003.GetIsSourceNo(data[i].InventoryID);
                var isLimitDate = WMF2003.GetIsLimitDate(data[i].InventoryID);
                if (isSource == "1" && (typeof (data[i].SourceNo) == "undefined" || data[i].SourceNo == "")) {
                    null_sourceno = true;
                    $($(grid_tr[i]).children()[sourceno_colindex]).addClass('asf-focus-input-error');
                }
                if (isLimitDate == "1" && (typeof (data[i].LimitDate) == "undefined" || data[i].LimitDate == "")) {
                    null_limitdate = true;
                    $($(grid_tr[i]).children()[limitdate_colindex]).addClass('asf-focus-input-error');
                }
            }
        }

        //if (!null_inventory) {
        //    for (var i = 0; i < data.length; i++) {
        //        var creditaccountid = data[i].CreditAccountID;
        //        if (!WMF2003.IsExistAccountID(creditaccountid)) {
        //            null_account = true;
        //            $($(grid_tr[i]).children()[creditaccount_colindex]).addClass('asf-focus-input-error');
        //        }
        //    }
        //}

        var message_array = [];
        if (wrong_quantity) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000200"));
        }
        if (cannot_convert) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000215"));
        }
        if (duplicate_row) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000202"));
        }
        if (null_contract) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000216"));
        }
        if (null_inventory) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000203"));
        }
        if (null_sourceno) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000050"));
        }
        if (null_limitdate) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000106"));
        }
        if (null_account) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000220"));
        }
        if (negative_value) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000208"));
        }
        // Không tồn tại mã mặt hàng trong hợp đồng
        if (notexist_invent) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000207"));
        }

        // Show message
        if (Invalid_Data) {
            WMF2003.ShowMessageErrors(message_array);
        }
    }
    return Invalid_Data;
}

// Phương thức nhận dữ liệu từ:
// popup chọn hợp đồng
function receiveResult(result) {
    WMF2003.Collecting = false;
    // Chọn hợp đồng
    if (WMF2003.CurrentChoose == WMF2003.CHOOSECONTRACT) {
        if (result.ContractID) {
            WMF2003.selected_contract.ContractID = result.ContractID;
            WMF2003.selected_contract.ContractNo = result.ContractNo;

            $("#" + txtContract).val(result.ContractID);
            //$("#" + txtContract).removeClass('asf-focus-input-error');

            $("#" + txtContractNo).val(result.ContractNo);
            WMF2003.ClearContractNoError();
            WMF2003.SelectFirstWarehouse();

            WMF2003.inventory_org_data = [];

            var grid = $('#GridEditWT0096').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            //warehouse_cbo.value("");
            //$("[name='" + txtWarehouseName + "']").val("");
        }
    }

    // Chọn mặt hàng
    if (WMF2003.CurrentChoose == WMF2003.CHOOSEINVENTORY) {
        var grid = $('#GridEditWT0096').data('kendoGrid');
        $(grid.select()).css('background', '');
        var selectedItem = grid.dataItem(grid.select());
        if (grid.select()) {
            if (selectedItem) {
                selectedItem.set(WMF2003.COL_INVENTORYID, result[WMF2003.COL_INVENTORYID]);
                selectedItem.set(WMF2003.COL_INVENTORYNAME, result[WMF2003.COL_INVENTORYNAME]);
                selectedItem.set(WMF2003.COL_UNITID, result[WMF2003.COL_UNITID]);
                selectedItem.set(WMF2003.COL_ACTUALQUANTITY, result[WMF2003.COL_ACTUALQUANTITY]);
                selectedItem.set(WMF2003.COL_UNITPRICE, result[WMF2003.COL_UNITPRICE]);
                // Trường hợp nhập kho : AccountID  => DebitAccountID
                selectedItem.set(WMF2003.DEBITACCOUNTID, result[WMF2003.COL_ACCOUNTID]);

                if (result[WMF2003.COL_ACTUALQUANTITY] != null && result[WMF2003.COL_UNITPRICE] != null) {
                    var OriginalAmount = result[WMF2003.COL_ACTUALQUANTITY] * result[WMF2003.COL_UNITPRICE];
                    selectedItem.set(WMF2003.COL_ORIGINALAMOUNT, OriginalAmount);
                }

                var inventory = [];
                inventory.InventoryID = result[WMF2003.COL_INVENTORYID];
                inventory.ActualQuantity = result[WMF2003.COL_ACTUALQUANTITY];
                WMF2003.UpdateInventoryList(inventory);

                var inventory_check = [];
                inventory_check.InventoryID = result[WMF2003.COL_INVENTORYID];
                inventory_check.IsSource = result[WMF2003.COL_ISSOURCE];
                inventory_check.IsLimitDate = result[WMF2003.COL_ISLIMITDATE];
                inventory_check.AccountID = result[WMF2003.COL_ACCOUNTID];
                WMF2003.UpdateInventoryCheck(inventory_check);

                grid.refresh();
            }
        }
    }
}

function receiveCancle() {
    WMF2003.Collecting = false;
}

// Phương thức để thêm dữ liệu Details trên grid
function CustomInsertPopupDetail(datagrid) {
    tableName = []
    tableName.push("WT0096");

    var warehouse_id = WMF2003.GetWareHouseID();
    //var employee_id = WMF2003.GetEmployeeID();
    var contract_no = WMF2003.selected_contract.ContractNo;

    var grid = $('#GridEditWT0096').data('kendoGrid');
    var grid_data = grid.dataSource.data();

    if (datagrid.length > 0) {
        datagrid[0][0].TableName = "," + MasterTableName;
        datagrid[0][0].ContractNo = "," + contract_no;
    }

    $.each(tableName, function (key, value) {
        datagrid.push(getListDetail(value, grid_data, warehouse_id));
    })
    return datagrid;
}

function getListDetail(tb, grid_data, warehouse_id) {
    var dataPost1 = ASOFT.helper.dataFormToJSON(id);
    var data = [];
    var dt = getDetail(tb).Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i].UnitID = (grid_data[i].UnitID) ? grid_data[i].UnitID : "";
        dt[i].TableName = "," + DetailTableName;
        dt[i].ImWareHouseID = "," + warehouse_id;
        dt[i].Orders = "," + (i + 1);

        //dt[i].EmployeeID = "," + employee_id;

        data.push(dt[i]);
    }
    return data;
}

function clearfieldsCustomer() {
    $("#" + txtVoucherNo).val("");
    $("#" + txtRefNo1).val("");
    $("#" + txtRefNo2).val("");
    $("#" + txtDescription).val("");
    $("#" + txtContract).val("");
    $("#" + txtContractNo).val("");

    //$("[name='" + txtInventoryTypeName + "']").val("");
    $("[name='" + txtWarehouseName + "']").val("");
    $("[name='" + txtEmployeeID + "']").val("");

    vouchertype_cbo.value("");
    warehouse_cbo.value("");
    //inventory_cbo.value("");
    //employee_cbo.value("");

    WMF2003.inventory_org_data = [];
    WMF2003.selected_contract = [];
    WMF2003.inventory_check = [];
    WMF2003.LastRowCount = 1;
    WMF2003.CurrentCreditAccountID = "";
    WMF2003.CurrentDebitAccountID = "";
    WMF2003.Collecting = false;

    // Set lại ngày hôm nay
    $("#VoucherDate").data("kendoDatePicker").value(today);

    $('#GridEditWT0096').data("kendoGrid").dataSource.data([]);
    $('#GridEditWT0096').data("kendoGrid").dataSource.add({});
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        if (action == 2) {
            vouchertype_cbo.value("");
            $("#" + txtVoucherNo).val("");
            WMF2003.CurrentCreditAccountID = "";
            WMF2003.CurrentDebitAccountID = "";
            WMF2003.RenewInventoryList();
        }

        if (action == 1) {
            $('#SParameter01').val('');
            $('#SParameter02').val('');
            $('#SParameter03').val('');
            $('#SParameter04').val('');
            $('#SParameter05').val('');
            $('#SParameter06').val('');
            $('#SParameter07').val('');
            $('#SParameter08').val('');
            $('#SParameter09').val('');
            $('#SParameter10').val('');
            $('#SParameter11').val('');
            $('#SParameter12').val('');
            $('#SParameter13').val('');
            $('#SParameter14').val('');
            $('#SParameter15').val('');
            $('#SParameter16').val('');
            $('#SParameter17').val('');
            $('#SParameter18').val('');
            $('#SParameter19').val('');
            $('#SParameter20').val('');
        }
    }
}