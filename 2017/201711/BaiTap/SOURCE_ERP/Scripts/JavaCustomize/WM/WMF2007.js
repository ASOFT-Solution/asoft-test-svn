//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     18/01/2017      Văn Tài          Tạo mới
//####################################################################

var warehouse_cbo;
var inventory_cbo;
var employee_cbo;

var txtWarehouseName = "txtWarehouseName";
var txtInventoryTypeName = "txtInventoryTypeName";
var txtEmployeeID = "txtEmployeeID";
var txtRefNo1 = "RefNo01";
var txtRefNo2 = "RefNo02";
var txtDescription = "Description";
var txtContract = "ContractID";
var txtContractNo = "ContractNo";
var txtContractPerson = "ContactPerson";
var txtRDAddress = "RDAddress";

var txtVoucherID = "VoucherID";
var txtVoucherNo = "VoucherNo";

var MasterTableName = "WT0095";
var DetailTableName = "WT0096";

var btnContact = "btnContact";

var tempCheckAllDataChange = [];
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
            warehouse_cbo = $("#ExWareHouseID").data("kendoComboBox");
            inventory_cbo = $("#InventoryTypeID").data("kendoComboBox");
            //employee_cbo = $("#EmployeeID").data("kendoComboBox");
            vouchertype_cbo = $("#VoucherTypeID").data("kendoComboBox");

            $("#ExWareHouseID").on('change', warehouse_cbo_onchange);
            $("#InventoryTypeID").on('change', inventorytype_cbo_onchange);
            //$("#EmployeeID").on('change', employee_cbo_onchange);
            $("#VoucherTypeID").on('change', vouchertype_onchange);

            WMF2007.inventory_org_data = [];
            WMF2007.LastRowCount = grid.dataSource._data.length;

            // Lấy danh sách tài khoản
            WMF2007.GetAccountList();

            if ($('#isUpdate').val() == "True") {
                isStatus = "Update";

                // Lấy VoucherID
                var txt_voucherid = $("#" + WMF2007.VOUCHERID);
                if (txt_voucherid) {
                    WMF2007.VoucherID = txt_voucherid.val();
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
                WMF2007.VoucherDate = $("#VoucherDate").data("kendoDatePicker").value();
            }

            // Nếu popup thực hiển sửa dữ liệu
            if (isStatus == "Update") {
                var grid_update_data = grid.dataSource._data;
                for (var i = 0; i < grid_update_data.length; i++) {
                    //    var inventory = [];
                    //    inventory.InventoryID = grid_update_data[i].InventoryID,
                    //    inventory.ActualQuantity = grid_update_data[i].ActualQuantity,
                    //WMF2007.UpdateInventoryList(inventory);
                    //WMF2007.GetInventoryDetails(grid_update_data[i].InventoryID);
                    var inventory = [];
                    inventory.InventoryID = grid_update_data[i].InventoryID;
                    inventory.ActualQuantity = grid_update_data[i].ActualQuantity;
                    inventory.MethodID = grid_update_data[i].MethodID;
                    WMF2007.UpdateInventoryList(inventory);
                    if (grid_update_data[i].ReVoucherNo.length > 0) {
                        WMF2007.GetReVoucherNoDetails(grid_update_data[i].InventoryID, grid_update_data[i].ReVoucherNo);
                    }
                }

                // Lấy dữ liệu ban đầu
                WMF2007.GetAllInventoryCheck(grid_update_data);

                // Lấy thông tin CreditAccountID
                WMF2007.CollectAccountID();

                // Lưu lại thông tin ban đầu khi Update 
                WMF2007.inventory_old_data = WMF2007.inventory_org_data;
                WMF2007.revoucher_old_check = WMF2007.revoucher_check;

                // Cần lưu giữ giá trị ContractNo và ID
                WMF2007.selected_contract.ContractNo = $("#" + txtContractNo).val();
                WMF2007.selected_contract.ContractID = $("#" + txtContract).val();

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

            // Việc load dữ liệu trên popup đã hoàn thành
            WMF2007.DataLoading = false;

            var main = $("#WMF2007");
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

            if (parseInt($('#CheckTab').val()) == 0) {
                var tabStrip = $("#WMF3000Tab").kendoTabStrip().data("kendoTabStrip");
                tabStrip.enable(tabStrip.tabGroup.children().eq(1), false);
            } else {
                var tabStrip = $("#WMF3000Tab").kendoTabStrip().data("kendoTabStrip");
                tabStrip.enable(tabStrip.tabGroup.children().eq(1), true);
            }
        }
    });

    $(grid.tbody).on("click", "td", function (e) {
        $(e.target.parentNode.parentNode).find('tr').removeClass('k-state-selected')
        $(e.target.parentNode).addClass('k-state-selected');
    });

    $(grid.tbody).on("change", "td", function (e) {
        var selectitem = grid.dataItem(grid.select());
        var column = e.target.id;
        var null_value = false;

        if (typeof (e.target.value) == "undefined") {
            null_value = true;
        }

        if (e.target.value.length <= 0) {
            return;
        }
        if (selectitem == null || typeof (selectitem) == "undefined")
            return;

        if (column == "LimitDate") {
            //truyền giá trị chọn vào model grid
            if (isNormalDate(e.target.value) && !null_value)
                selectitem.LimitDate = e.target.value;
        }
        if (column == 'cbbDebitAccountID' || e.target.name.split('_')[0] == 'DebitAccountID' && !null_value) {

            var id = e.target.value;
            selectitem.DebitAccountID = id;
        }
        if (column == 'cbbCreditAccountID' && !null_value) {

            var id = e.target.value;
            selectitem.CreditAccountID = id;
        }
        if (column == 'ActualQuantity' && !null_value) {

            var id = e.target.value;
            selectitem.ActualQuantity = id;
        }
        if (column == 'cbbReVoucherNo' && !null_value) {
            var id = e.target.value;
            selectitem.ReVoucherNo = id;
            if (selectitem.ReVoucherNo.length > 0 || (selectitem.InventoryID && selectitem.InventoryID.length > 0)) {
                var revoucher = WMF2007.GetReVoucherNoDetails(selectitem.InventoryID, selectitem.ReVoucherNo);
                selectitem.SourceNo = revoucher.ReSourceNo;
                //selectitem.ActualQuantity = revoucher.DeQuantity;
                //if (selectitem.ActualQuantity.length > 0 && selectitem.UnitPrice)
                //    selectitem.OriginalAmount = parseFloat(selectitem.ActualQuantity) * parseFloat(selectitem.UnitPrice);
                //else
                //    selectitem.OriginalAmount = 0;
                if (revoucher.LimitDate.length > 0)
                    selectitem.LimitDate = format_limitdate(revoucher.LimitDate);
                else
                    selectitem.LimitDate = "";
                grid.refresh();
            }
            else {
                selectitem.SourceNo = "";
                selectitem.ActualQuantity = "";
                selectitem.LimitDate = "";
                grid.refresh();
            }
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
                //selectitem.DebitAccoutID = "";
                selectitem.CreditAccountID = "";
                // selectitem.LimitDate = "";
                selectitem.ReVoucherNo = "";
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
                //WMF2007.AddContractIDError();
                WMF2007.AddContractNoError();
                canSearch = false;
            } else {
                //WMF2007.ClearContractIDError();
                WMF2007.ClearContractNoError();
            }

            var selected_inventorytype = inventory_cbo.dataItem(inventory_cbo.select());
            if (typeof (selected_inventorytype) == "undefined") {
                // Chọn loại hàng trước khi chọn mặt hàng
                message_array.push(ASOFT.helper.getMessage("WFML000206"));
                WMF2007.AddInventoryTypeIDError();
                canSearch = false;
            } else {
                WMF2007.ClearContractIDError();
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
                WMF2007.ShowMessageErrors(message_array);
            } else {
                var Inventory = WMF2007.GetInventoryDetails(InventoryID);

                if (!WMF2007.Collecting) {
                    if (typeof (Inventory.InventoryID) == "undefined") {
                        // Xóa trắng các trường dữ liệu
                        //selectitem.InventoryID = "...";
                        selectitem.InventoryName = "";
                        selectitem.UnitID = "";
                        selectitem.ActualQuantity = "";
                        selectitem.UnitPrice = "";
                        selectitem.OriginalAmount = "";
                        //selectitem.SourceNo = "";
                        selectitem.Notes = "";
                        selectitem.CreditAccountID = "";
                        selectitem.ReVoucherNo = "";
                        //selectitem.DebitAccoutID = "";

                        grid.refresh();
                    }
                    else {
                        selectitem.InventoryName = Inventory.InventoryName;
                        selectitem.UnitID = Inventory.UnitID;

                        // Trường hợp focus-out không thay đổi số lượng nhập và thành tiền
                        //selectitem.ActualQuantity = Inventory.ActualQuantity;
                        //selectitem.OriginalAmount
                        //selectitem.AccountID

                        selectitem.UnitPrice = Inventory.UnitPrice;
                        var inventory_check = [];
                        inventory_check.InventoryID = Inventory.InventoryID;
                        inventory_check.IsSource = Inventory.IsSource;
                        inventory_check.IsLimitDate = Inventory.IsLimitDate;
                        inventory_check.AccountID = Inventory.AccountID;
                        WMF2007.UpdateInventoryCheck(inventory_check);

                        grid.refresh();
                    }
                }
            }
        }

        if (column == "") {
            if (selectitem.InventoryID == "" && !WMF2007.Collecting) {
                // Xóa trắng các trường dữ liệu
                selectitem.InventoryID = "...";
                selectitem.InventoryName = "";
                selectitem.UnitID = "";
                selectitem.ActualQuantity = "";
                selectitem.UnitPrice = "";
                selectitem.OriginalAmount = "";
                //selectitem.SourceNo = "";
                selectitem.Notes = "";
                selectitem.ReVoucherNo = "";
                //selectitem.DebitAccoutID = "";

                grid.refresh();
            }
        }

        if (column = "LimitDate") {
            //truyền giá trị chọn vào model grid
            if (isNormalDate(e.target.value))
                selectitem.LimitDate = e.target.value;
        }

        if (column == 'cbbDebitAccountID' || e.target.name.split('_')[0] == 'DebitAccountID') {
            var id = e.target.value;
            selectitem.DebitAccountID = id;
        }

        if (column == 'cbbCreditAccountID') {
            var id = e.target.value;
            selectitem.CreditAccountID = id;
        }

        if (column == 'cbbReVoucherNo' || e.target.name.split('_')[0] == 'ReVoucherNo') {

            var id = e.target.value;
            selectitem.ReVoucherNo = id;

            if (typeof (selectitem) == "undefined" || typeof (selectitem.InventoryID) == "undefined") {
                return;
            }

            if (selectitem.InventoryID == "" || selectitem.ReVoucherNo == "" || selectitem.ReVoucherNo.length <= 0) {
                if (selectitem.InventoryID.length > 0) {
                    WMF2007.ResetReVoucherCheck(selectitem.InventoryID);
                    selectitem.ActEndQty = "";
                }
                return;
            } else {
                var revoucher = WMF2007.GetReVoucherNoDetails(selectitem.InventoryID, selectitem.ReVoucherNo);
                selectitem.SourceNo = revoucher.ReSourceNo;
                if (revoucher.LimitDate.length > 0)
                    selectitem.LimitDate = format_limitdate(revoucher.LimitDate);
                else
                    selectitem.LimitDate = "";
                selectitem.ActEndQty = WMF2007.GetActEndQty(selectitem.InventoryID);
               grid.refresh();
                return;
            }
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

    grid.bind("dataBound", function (e) {
        var data = grid.dataSource._data;
        if (!WMF2007.DataLoading) {
            if (WMF2007.LastRowCount < data.length) {
                WMF2007.LastRowCount = data.length;
                data[data.length - 1].DebitAccountID = WMF2007.CurrentDebitAccountID;
                this.refresh();
            }
        }
        WMF2007.LastRowCount = data.length;

        //var dataSource = this.dataSource._data;
        //$(dataSource).each(function () {
        //    // Setting tài khoản có - cho màn hình nhập kho
        //    //this.CreditAccountID = 152;
        //});
    });

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditWT0096',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "InventoryID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.container.parent().css('background', '')
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);

            var Inventory = WMF2007.GetInventoryDetails(dataItem.InventoryID);

            var inventory_check = [];
            inventory_check.InventoryID = dataItem.InventoryID;
            inventory_check.IsSource = dataItem.IsSource;
            inventory_check.IsLimitDate = dataItem.IsLimitDate;
            inventory_check.AccountID = dataItem.AccountID;
            WMF2007.UpdateInventoryCheck(inventory_check);

            selectedRowItem.model.set("InventoryName", Inventory.InventoryName);
            selectedRowItem.model.set("UnitID", Inventory.UnitID);
            selectedRowItem.model.set("ActualQuantity", Inventory.ActualQuantity);
            selectedRowItem.model.set("UnitPrice", Inventory.UnitPrice);
            selectedRowItem.model.set("OriginalAmount", Inventory.OriginalAmount);
            selectedRowItem.model.set("InventoryName", Inventory.InventoryName);
            selectedRowItem.model.set("CreditAccountID", Inventory.AccountID);
            if (Inventory) {
                //WMF2007.ClearContractIDError();
                WMF2007.ClearContractNoError();
                WMF2007.ClearInventoryTypeIDError();
            }
        }
    });
})

function AppendSubTextBox() {
    var warehouse_parent = $("#ExWareHouseID").parent();
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
    //var tr_ExWareHouseID = $('tr.ExWareHouseID');

    //if (tr_ContractID && tr_ExWareHouseID) {
    //    $('tr.ContractID').remove();
    //    tr_ExWareHouseID.before(tr_ContractID);
    //}

    var tr_ContractNo = $('tr.ContractNo');
    var tr_InventoryTypeID = $('tr.InventoryTypeID');

    if (tr_ContractNo && tr_InventoryTypeID) {
        $('tr.ContractNo').remove();
        tr_InventoryTypeID.before(tr_ContractNo);
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
        WMF2007.ClearInventoryTypeIDError();
    }
    else {
        $("[name=" + txtInventoryTypeName + "]").val("");
    }

    WMF2007.inventory_org_data = [];

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
        WMF2007.UpdateAccountCheck(account_check);

        WMF2007.UpdateColDebitAccount();

        var url = "/WM/WMF2007/GetVoucherNoText";
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

function format_limitdate(date) {
    return kendo.toString(new Date(date), 'dd/MM/yyyy');
}

function isDate(strDate) {
    var date = Date.parse(strDate);
    if (date)
        return true
    else
        return false;
}

// Kiểm tra chuỗi đầu vào có phải theo định dạng DD/MM/yyyy
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
    WMF2007.CurrentChoose = WMF2007.CHOOSECONTRACT;

    WMF2007.VoucherDate = $("#VoucherDate").data("kendoDatePicker").value();
    var strDate = $("#VoucherDate").val();
    if (strDate.length > 0)
        if (!isDate(WMF2007.VoucherDate)) {
            ASOFT.form.clearMessageBox();
            $("#VoucherDate").addClass('asf-focus-input-error');
            WMF2007.ShowMessageError("00ML000058");
            return;
        }

    if (WMF2007.VoucherDate == null) {
        ASOFT.form.clearMessageBox();
        $("#VoucherDate").addClass('asf-focus-input-error');
        WMF2007.ShowMessageError("WFML000204");
        return;
    }

    ASOFT.form.clearMessageBox();
    $("#VoucherDate").removeClass('asf-focus-input-error');

    var formated_date = format_date(WMF2007.VoucherDate);

    url = '/PopupSelectData/Index/WM/WMF2002?VoucherDate=' + formated_date + '&ScreenID=' + $('#sysScreenID').val();

    ASOFT.asoftPopup.showIframe(url, {});
}

function ChooseInventoryID_Click() {
    WMF2007.Collecting = true;
    WMF2007.CurrentChoose = WMF2007.CHOOSEINVENTORY;

    var canSearch = true;
    var message_array = [];
    ASOFT.form.clearMessageBox();

    if ($("#" + txtContract).val().length <= 0) {
        // Chọn hợp đồng trước khi chọn mặt hàng
        message_array.push(ASOFT.helper.getMessage("WFML000205"));
        //WMF2007.AddContractIDError();
        WMF2007.AddContractNoError();
        canSearch = false;
    } else {
        //WMF2007.ClearContractIDError();
        WMF2007.ClearContractNoError();
    }

    var selected_inventorytype = inventory_cbo.dataItem(inventory_cbo.select());
    if (typeof (selected_inventorytype) == "undefined") {
        // Chọn loại hàng trước khi chọn mặt hàng
        message_array.push(ASOFT.helper.getMessage("WFML000206"));
        WMF2007.AddInventoryTypeIDError();
        canSearch = false;
    } else {
        WMF2007.ClearContractIDError();
    }

    if (!canSearch) {
        WMF2007.ShowMessageErrors(message_array);
        return;
    }
    else {
        var ContractID = WMF2007.GetContractID();
        var InventoryTypeID = WMF2007.GetInventoryTypeID();
        var InventoryIDList = WMF2007.GetInventoryIDList();
        var Mode = 2;
        var voucherID = WMF2007.VoucherID;

        url = '/PopupSelectData/Index/WM/WMF2008?ContractID=' + ContractID
            + '&InventoryTypeID=' + InventoryTypeID
            + '&InventoryIDList=' + InventoryIDList
            + '&Mode=' + Mode
            + '&VoucherID=' + voucherID
            + '&ScreenID=' + $('#sysScreenID').val();
        ASOFT.asoftPopup.showIframe(url, {});
    }
}

WMF2007 = new function () {

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
    this.COL_ISSOURCENO = "IsSource";
    this.COL_ACCOUNTID = "AccountID";
    this.COL_METHODID = "MethodID";

    this.CREDITACCOUNTID = "CreditAccountID";
    this.DEBITACCOUNTID = "DebitAccountID";

    this.VOUCHERID = "VoucherID";

    // Data Properties
    this.VoucherID = "";
    // Lưu thông tin số lượng của từng mặt hàng - trường hợp thêm mới
    this.inventory_org_data = [];
    this.inventory_old_data = [];

    this.inventory_check = [];
    this.account_list = [];
    this.revoucher_check = [];
    this.revoucher_old_check = [];

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

    // Kiểm tra tài khoản nợ tồn tại
    this.IsExistAccountID = function (accountid) {
        for (var i = 0; i < this.account_list.length; i++) {
            if (accountid == this.account_list[i].AccountID) {
                return true;
            }
        }
        return false;
    }

    // Kiểm tra số lượng xuất lớn hơn số lượng tồn
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
        var VoucherNo = $("#" + txtVoucherID).val();
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

    // Xử lý cập nhật danh sách Inventory : thông tin về số lượng xuất
    this.UpdateInventoryList = function (data) {
        if (data) {
            var existed_data = false;
            for (var i = 0; i < this.inventory_org_data.length && !existed_data; i++) {
                var item = this.inventory_org_data[i];
                if (data.InventoryID == item.InventoryID) {
                    existed_data = true;
                    this.inventory_org_data[i].ActualQuantity = data.ActualQuantity;
                    this.inventory_org_data[i].MethodID = data.MethodID;
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
            WMF2007.CurrentCreditAccountID = data.CreditAccountID;
            WMF2007.CurrentDebitAccountID = data.DebitAccountID;
        }
    }

    // Xử lý tài khoản nợ theo loại chứng từ
    this.UpdateColDebitAccount = function () {
        if (this.CurrentDebitAccountID.length > 0) {
            var grid = $('#GridEditWT0096').data('kendoGrid');
            var data = grid.dataSource._data;
            for (var i = 0; i < data.length; i++) {
                data[i].DebitAccountID = this.CurrentDebitAccountID;
            }
            grid.refresh();
        }
    }

    // Xử lý cập nhật danh sách ReVoucher
    this.UpdateReVoucherCheck = function (data) {
        if (data) {
            var existed_data = false;
            for (var i = 0; i < this.revoucher_check.length && !existed_data; i++) {
                var item = this.revoucher_check[i];
                if (data.InventoryID == item.InventoryID) {
                    existed_data = true;
                    this.revoucher_check[i].LimitDate = data.LimitDate;
                    this.revoucher_check[i].ReVoucherID = data.ReVoucherID;
                    this.revoucher_check[i].ReVoucherNo = data.ReVoucherNo;
                    this.revoucher_check[i].ReVoucherDate = data.ReVoucherDate;
                    this.revoucher_check[i].ReTransactionID = data.ReTransactionID;
                    this.revoucher_check[i].ReSourceNo = data.ReSourceNo;
                    this.revoucher_check[i].ReQuantity = data.ReQuantity;
                    this.revoucher_check[i].DeQuantity = data.DeQuantity;
                    this.revoucher_check[i].EndConvertedQuantity = data.EndConvertedQuantity;
                    this.revoucher_check[i].EndQuantity = data.EndQuantity;
                    this.revoucher_check[i].UnitPrice = data.UnitPrice;
                    this.revoucher_check[i].ConvertedUnitID = data.ConvertedUnitID;
                    break;
                }
            }
            if (!existed_data) {
                this.revoucher_check.push(data);
            }
        }
    }

    // Xử lý cập nhật reset ReVoucher của Inventory
    this.ResetReVoucherCheck = function (inventoryid) {
        if (inventoryid) {
            for (var i = 0; i < this.revoucher_check.length; i++) {
                var item = this.revoucher_check[i];
                if (inventoryid == item.InventoryID) {
                    this.revoucher_check[i].LimitDate = "";
                    this.revoucher_check[i].ReVoucherID = "";
                    this.revoucher_check[i].ReVoucherNo = "";
                    this.revoucher_check[i].ReVoucherDate = "";
                    this.revoucher_check[i].ReTransactionID = "";
                    this.revoucher_check[i].ReSourceNo = "";
                    this.revoucher_check[i].ReQuantity = 0;
                    this.revoucher_check[i].DeQuantity = 0;
                    this.revoucher_check[i].EndConvertedQuantity = 0;
                    this.revoucher_check[i].EndQuantity = 0;
                    this.revoucher_check[i].UnitPrice = 0;
                    this.revoucher_check[i].ConvertUnitID = "";
                    break;
                }
            }
        }
    }

    // Load lại danh sach loại hàng hiện có trong hợp đồng
    this.RenewInventoryList = function () {
        var new_inventorylist = [];
        var ContractID = this.GetContractID();
        var InventoryTypeID = this.GetInventoryTypeID();
        var InventoryIDList = "";
        var Mode = 2; // XK
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
                                inventory.MethodID = result[i].MethodID;
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
        var Mode = 2;

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
                                WMF2007.inventory_check.push(Inventory_Result);
                                break;
                            }
                        }
                    }
                });
            }
        }
    }

    this.GetAccountList = function () {
        WMF2007.account_list = [];

        var url = "/WM/WMF2003/GetAccountList";
        var data = [];
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.length > 0) {
                for (var i = 0; i < result.length; i++) {
                    var account = [];
                    account.AccountID = result[i].AccountID;
                    account.AccountName = result[i].AccountName;
                    WMF2007.account_list.push(account);
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
            WMF2007.UpdateAccountCheck(account_check);
        }
    }

    this.GetIsSourceNo = function (inventoryID) {
        for (var i = 0; i < WMF2007.inventory_check.length; i++) {
            var item = WMF2007.inventory_check[i];
            if (inventoryID == item.InventoryID) {
                return WMF2007.inventory_check[i].IsSource;
            }
        }
        return 0;
    }

    this.GetIsLimitDate = function (inventoryID) {
        for (var i = 0; i < WMF2007.inventory_check.length; i++) {
            var item = WMF2007.inventory_check[i];
            if (inventoryID == item.InventoryID) {
                return WMF2007.inventory_check[i].IsLimitDate;
            }
        }
        return 0;
    }

    this.GetOldQuantity = function (inventoryID) {
        for (var i = 0; i < this.inventory_old_data.length; i++) {
            var item = this.inventory_old_data[i];
            if (inventoryID == item.InventoryID) {
                return this.inventory_old_data[i].ActualQuantity;
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
        //var InventoryID = selectitem.InventoryID;
        var ContractID = this.GetContractID();
        var InventoryTypeID = this.GetInventoryTypeID();
        var InventoryIDList = "";

        var Mode = 2; // XK

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
                            Inventory_Result.AccountID = result[i].AccountID;
                            Inventory_Result.IsSource = result[i].IsSource;
                            Inventory_Result.IsLimitDate = result[i].IsLimitDate;

                            if (Inventory_Result.ActualQuantity != null && Inventory_Result.UnitPrice != null) {
                                Inventory_Result.OriginalAmount = parseFloat(Inventory_Result.ActualQuantity) * parseFloat(Inventory_Result.UnitPrice);
                            }

                            // Kiểm tra inventory và gửi số lượng nhập ( trong csdl ) - lưu lại để
                            // kiếm tra người dùng cập nhật số lượng nhập mới - khác biệt so với dữ liệu cũ
                            if (result[i]) {
                                var inventory = [];
                                inventory.InventoryID = InventoryID;
                                inventory.ActualQuantity = result[i].ActualQuantity;
                                inventory.MethodID = result[i].MethodID;
                                WMF2007.UpdateInventoryList(inventory);
                            }
                        }
                    }
                }
            });
        }
        return Inventory_Result;
    }

    this.GetReVoucherNoDetails = function (inventoryid, revoucherno) {
        var warehouseid = this.GetWareHouseID();
        var url = "/WM/WMF2007/GetReVoucherNoDetails";
        var revoucher_result = [];
        if (inventoryid.length > 0) {
            var data = {
                WareHouseID: warehouseid,
                InventoryID: inventoryid,
                ReVoucherNo: revoucherno,
            };
            ASOFT.helper.postTypeJson(url, data, function (result) {
                if (result) {
                    revoucher_result = JSON.parse(result);
                    WMF2007.UpdateReVoucherCheck(revoucher_result);
                    if (!revoucher_result.HasData) {
                        WMF2007.ResetReVoucherCheck(inventoryid);
                    }
                }
            });
        }
        return revoucher_result;
    }

    this.GetActEndQty = function (inventoryid) {
        var warehouseid = this.GetWareHouseID();
        var url = "/WM/WMF2007/GetAllReVoucherNoDetails";
        var revoucher_result = [];
        var actEndQty = 0;
        if (inventoryid.length > 0) {
            var data = {
                WareHouseID: warehouseid,
                InventoryID: inventoryid
            };
            ASOFT.helper.postTypeJson(url, data, function (result) {
                if (result) {
                    for (var i = 0; i < result.length; i++) {
                        actEndQty += parseFloat(result[i].EndQuantity);
                    }
                }
            });
        }
        return actEndQty;
    }

    this.GetReVoucherID = function (inventoryid) {
        for (var i = 0; i < this.revoucher_check.length; i++) {
            if (this.revoucher_check[i].InventoryID == inventoryid) {
                return this.revoucher_check[i].ReVoucherID;
            }
        }
        return "";
    }

    this.GetReOldVoucherID = function (inventoryid) {
        for (var i = 0; i < this.revoucher_old_check.length; i++) {
            if (this.revoucher_old_check[i].InventoryID == inventoryid) {
                return this.revoucher_old_check[i].ReVoucherID;
            }
        }
        return "";
    }

    this.GetReTransactionID = function (inventoryid) {
        for (var i = 0; i < this.revoucher_check.length; i++) {
            if (this.revoucher_check[i].InventoryID == inventoryid)
                return this.revoucher_check[i].ReTransactionID;
        }
        return "";
    }

    this.GetReOldTransactionID = function (inventoryid) {
        for (var i = 0; i < this.revoucher_old_check.length; i++) {
            if (this.revoucher_old_check[i].InventoryID == inventoryid)
                return this.revoucher_old_check[i].ReTransactionID;
        }
        return "";
    }

    this.GetMethodID = function (inventoryid) {
        for (var i = 0; i < this.inventory_org_data.length; i++) {
            if (this.inventory_org_data[i].InventoryID == inventoryid)
                return this.inventory_org_data[i].MethodID;
        }
        return "";
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

    this.AddContractIDError = function () {
        var Contract = $("#" + txtContract);
        if (Contract) {
            if (!Contract.hasClass('asf-focus-input-error')) {
                Contract.addClass('asf-focus-input-error');
            }
        }
    }

    this.ClearContractIDError = function () {
        var Contract = $("#" + txtContract);
        if (Contract) {
            if (Contract.hasClass('asf-focus-input-error')) {
                Contract.removeClass('asf-focus-input-error');
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
        var message_array = [];

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
        var quantity_output_problem = false;


        var inventory_colindex = WMF2007.GetColIndex(grid, WMF2007.COL_INVENTORYID);
        var quantity_colindex = WMF2007.GetColIndex(grid, WMF2007.COL_ACTUALQUANTITY);
        var sourceno_colindex = WMF2007.GetColIndex(grid, WMF2007.COL_SOURCENO);
        var limitdate_colindex = WMF2007.GetColIndex(grid, WMF2007.COL_LIMITDATE);
        var debitaccount_colindex = WMF2007.GetColIndex(grid, WMF2007.DEBITACCOUNTID);

        // Kiểm tra null Contract
        if (WMF2007.GetContractID() == "" || WMF2007.GetContractNo() == "") {
            null_contract = true;
        }

        // For : xử lý kiểm tra  null dữ liệu
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

        if (!null_inventory) {
            for (var i = 0; i < data.length; i++) {
                var isSource = WMF2007.GetIsSourceNo(data[i].InventoryID);
                var isLimitDate = WMF2007.GetIsLimitDate(data[i].InventoryID);
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
        //        var debitaccountid = data[i].DebitAccountID;
        //        if (!WMF2007.IsExistAccountID(debitaccountid)) {
        //            null_account = true;
        //            $($(grid_tr[i]).children()[debitaccount_colindex]).addClass('asf-focus-input-error');
        //        }
        //    }
        //}

        // For : xử lý kiểm ra bất thường số lượng nhập
        if (!null_inventory && !null_limitdate && !null_sourceno) {
            for (var i = 0; i < data.length; i++) {
                // Số lượng nhập không được mang giá trị âm
                if (data[i].ActualQuantity < 0) {
                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                    negative_value = true;
                }
                else {
                    if (isStatus == "AddNew") {
                        var url = "/WM/WMF2007/CheckQuantityProblem";
                        var dataPost = {
                            WareHouseID: WMF2007.GetWareHouseID(),
                            InventoryID: data[i].InventoryID,
                            UnitID: data[i].UnitID,
                            IsSource: WMF2007.GetIsSourceNo(data[i].InventoryID),
                            IsLimitDate: WMF2007.GetIsLimitDate(data[i].InventoryID),
                            CreditAccountID: data[i].CreditAccountID,
                            ReOldVoucherID: "",
                            ReOldTransactionID: "",
                            ReNewVoucherID: WMF2007.GetReVoucherID(data[i].InventoryID),
                            ReNewTransactionID: WMF2007.GetReTransactionID(data[i].InventoryID),
                            VoucherDate: data[i].LimitDate,
                            OldQuantity: 0,
                            NewQuantity: data[i].ActualQuantity,
                            MethodID: WMF2007.GetMethodID(data[i].InventoryID),
                        };
                        ASOFT.helper.postTypeJson(url, dataPost, function (result) {
                            if (typeof (result[0].Status) != "undefined") {
                                if (result[0].Status != 0) {
                                    quantity_output_problem = true;
                                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                                    if (result[0].MessageID) {
                                        if (result[0].MessageID == "WFML000138") {
                                            message_array.push(ASOFT.helper.getMessage(result[0].MessageID).f(result[0].Value1, result[0].Value2, result[0].Value3));
                                        } else {
                                            message_array.push(ASOFT.helper.getMessage(result[0].MessageID));
                                        }
                                    }
                                }
                            }
                        });
                    }
                    else {
                        var url = "/WM/WMF2007/CheckQuantityProblem";
                        var dataPost = {
                            WareHouseID: WMF2007.GetWareHouseID(),
                            InventoryID: data[i].InventoryID,
                            UnitID: data[i].UnitID,
                            IsSource: WMF2007.GetIsSourceNo(data[i].InventoryID),
                            IsLimitDate: WMF2007.GetIsLimitDate(data[i].InventoryID),
                            CreditAccountID: data[i].CreditAccountID,
                            ReOldVoucherID: WMF2007.GetReOldVoucherID(data[i].InventoryID),
                            ReOldTransactionID: WMF2007.GetReOldTransactionID(data[i].InventoryID),
                            ReNewVoucherID: WMF2007.GetReVoucherID(data[i].InventoryID),
                            ReNewTransactionID: WMF2007.GetReTransactionID(data[i].InventoryID),
                            VoucherDate: data[i].LimitDate,
                            OldQuantity: WMF2007.GetOldQuantity(data[i].InventoryID),
                            NewQuantity: data[i].ActualQuantity,
                            MethodID: WMF2007.GetMethodID(data[i].InventoryID),
                        };
                        ASOFT.helper.postTypeJson(url, dataPost, function (result) {
                            if (typeof (result[0].Status) != "undefined") {
                                if (result[0].Status != 0) {
                                    quantity_output_problem = true;
                                    $($(grid_tr[i]).children()[quantity_colindex]).addClass('asf-focus-input-error');
                                    if (result[0].MessageID) {
                                        if (result[0].MessageID == "WFML000138") {
                                            message_array.push(ASOFT.helper.getMessage(result[0].MessageID).f(result[0].Value1, result[0].Value2, result[0].Value3));
                                        } else {
                                            message_array.push(ASOFT.helper.getMessage(result[0].MessageID));
                                        }
                                    }
                                }
                            }
                        });
                    }

                    var current_invent = data[i].InventoryID;
                    if (!WMF2007.IsExistInventData(current_invent)) {
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


        if (wrong_quantity) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000201"));
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
            message_array.push(ASOFT.helper.getMessage("WFML000221"));
        }
        if (negative_value) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000209"));
        }
        // Không tồn tại mã mặt hàng trong hợp đồng
        if (notexist_invent) {
            Invalid_Data = true;
            message_array.push(ASOFT.helper.getMessage("WFML000207"));
        }
        if (quantity_output_problem) {
            Invalid_Data = true;
        }

        // Show message
        if (Invalid_Data) {
            WMF2007.ShowMessageErrors(message_array);
        }
    }
    return Invalid_Data;
}

// Phương thức nhận dữ liệu từ popup chọn hợp đồng
function receiveResult(result) {
    WMF2007.Collecting = false;
    // Chọn hợp đồng
    if (WMF2007.CurrentChoose == WMF2007.CHOOSECONTRACT) {
        if (result.ContractID) {
            WMF2007.selected_contract.ContractID = result.ContractID;
            WMF2007.selected_contract.ContractNo = result.ContractNo;

            $("#" + txtContract).val(result.ContractID);
            //$("#" + txtContract).removeClass('asf-focus-input-error');

            $("#" + txtContractNo).val(result.ContractNo);
            WMF2007.ClearContractNoError();
            WMF2007.SelectFirstWarehouse();

            WMF2007.inventory_org_data = [];
            WMF2007.account_list = [];
            WMF2007.inventory_old_data = [];
            WMF2007.revoucher_check = [];
            WMF2007.revoucher_old_check = [];
            

            var grid = $('#GridEditWT0096').data('kendoGrid');
            grid.dataSource.data([]);
            grid.addRow();

            //warehouse_cbo.value("");
            //$("[name='" + txtWarehouseName + "']").val("");
        }
    }

    // Chọn mặt hàng
    if (WMF2007.CurrentChoose == WMF2007.CHOOSEINVENTORY) {
        var grid = $('#GridEditWT0096').data('kendoGrid');
        $(grid.select()).css('background', '');
        var selectedItem = grid.dataItem(grid.select());
        if (selectedItem) {
            selectedItem.set(WMF2007.COL_INVENTORYID, result[WMF2007.COL_INVENTORYID]);
            selectedItem.set(WMF2007.COL_INVENTORYNAME, result[WMF2007.COL_INVENTORYNAME]);
            selectedItem.set(WMF2007.COL_UNITID, result[WMF2007.COL_UNITID]);
            selectedItem.set(WMF2007.COL_ACTUALQUANTITY, result[WMF2007.COL_ACTUALQUANTITY]);
            selectedItem.set(WMF2007.COL_UNITPRICE, result[WMF2007.COL_UNITPRICE]);
            // Trường hợp xuất kho : AccountID => CreditAccountID
            selectedItem.set(WMF2007.CREDITACCOUNTID, result[WMF2007.COL_ACCOUNTID]);

            if (result[WMF2007.COL_ACTUALQUANTITY] != null && result[WMF2007.COL_UNITPRICE] != null) {
                var OriginalAmount = result[WMF2007.COL_ACTUALQUANTITY] * result[WMF2007.COL_UNITPRICE];
                selectedItem.set(WMF2007.COL_ORIGINALAMOUNT, OriginalAmount);
            }
            WMF2007.GetInventoryDetails(result[WMF2007.COL_INVENTORYID]);
            var inventory_check = [];
            inventory_check.InventoryID = result[WMF2007.COL_INVENTORYID];
            inventory_check.IsSource = result[WMF2007.COL_ISSOURCENO];
            inventory_check.IsLimitDate = result[WMF2007.COL_ISLIMITDATE];
            inventory_check.AccountID = result[WMF2007.COL_ACCOUNTID];
            WMF2007.UpdateInventoryCheck(inventory_check);

            grid.refresh();
        }
    }
}

function receiveCancle() {
    WMF2007.Collecting = false;
}

// Phương thức để thêm dữ liệu Details trên grid
function CustomInsertPopupDetail(datagrid) {
    tableName = []
    tableName.push("WT0096");

    var warehouse_id = WMF2007.GetWareHouseID();
    //var employee_id = WMF2007.GetEmployeeID();
    var contract_no = WMF2007.selected_contract.ContractNo;

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
        dt[i].ExWareHouseID = "," + warehouse_id;
        dt[i].Orders = "," + (i + 1);
        dt[i].ReVoucherID = "," + WMF2007.GetReVoucherID(dt[i].InventoryID);
        dt[i].ReTransactionID = "," + WMF2007.GetReTransactionID(dt[i].InventoryID);

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
    $("[name='" + txtContractPerson + "']").val("");
    $("[name='" + txtRDAddress + "']").val("");

    vouchertype_cbo.value("");
    warehouse_cbo.value("");
    //inventory_cbo.value("");
    //employee_cbo.value("");

    WMF2007.inventory_org_data = [];
    WMF2007.selected_contract = [];
    WMF2007.inventory_check = [];
    WMF2007.revoucher_check = [];
    WMF2007.LastRowCount = 1;
    WMF2007.CurrentCreditAccountID = "";
    WMF2007.CurrentDebitAccountID = "";
    WMF2007.Collecting = false;

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
            WMF2007.CurrentCreditAccountID = "";
            WMF2007.CurrentDebitAccountID = "";
            WMF2007.RenewInventoryList();
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