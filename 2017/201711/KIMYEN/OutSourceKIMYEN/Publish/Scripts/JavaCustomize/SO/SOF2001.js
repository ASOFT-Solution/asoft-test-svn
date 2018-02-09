var GridOT2002 = null;
var readIndex = 0;
var vatgroupID = null;
var ana01ID = null;
var ana02ID = null;
var ana03ID = null;
var ana04ID = null;
var ana05ID = null;
var ana06ID = null;
var ana07ID = null;
var ana08ID = null;
var ana09ID = null;
var ana10ID = null;
var cacheAPK = null;
var dataVarchar = null;
var routeName = null;
var SID = {};
var SOLD = {};
var listPriceInventory = null;
var isConfirm = false;

$(document).keyup(function (e) {
    if (e.keyCode == 113) {
        var itemF2 = GridOT2002.dataItem(GridOT2002.select());
        if (itemF2 != undefined && itemF2 != null) {
            if (itemF2.InventoryID != null && itemF2.InventoryID != undefined && itemF2.InventoryID != "") {
                var urlF2 = "/SO/SOF2000/SOF2004?InventoryID=" + itemF2.InventoryID + "&DivisionID=" + $("#DivisionID").val() + "&InventoryName=" + itemF2.InventoryName;
                ASOFT.form.clearMessageBox();
                ASOFT.asoftPopup.showIframe(urlF2, {});
            }
        }
    }
});

function GetVarCharFirst() {
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetVarchar?DivisionID=" + $("#DivisionID").val() + "&SOrderID=" + $("#SOrderID").val(), {}, function (result) {
        dataVarchar = result;
        if (result != null) {
            for (var k = 1; k <= 20; k++) {
                var stringV = k < 10 ? "Varchar0" : "Varchar";
                $("#" + stringV + k).val(result[stringV + k]);
            }
        }
    });
}

function btnChooseVarchar_Click() {
    urlChooseVarchar = "/SO/SOF2000/SOF2003?DivisionID=" + $("#DivisionID").val() + "&T=S__";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVarchar, {});
}

//function btnViewDebit_Click() {
//    if ($("#ObjectID").val() == "") {
//        var msg = ASOFT.helper.getMessage("AFML000036");
//        ASOFT.dialog.messageDialog(msg);
//        return;
//    }

//    var splitL = $("#OrderDate").val();
//    var res = splitL.split("/");

//    var oderdate = res[1] + "/" + res[0] + "/" + res[2];

//    urlChooseViewDebit = "/CRM/CRMF2008?DivisionID=" + $("#DivisionID").val() + "&VoucherDate=" + oderdate + "&ObjectID=" + $("#ObjectID").val();
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe(urlChooseViewDebit, {});
//}

$(document).ready(function () {
    GridOT2002 = $("#GridEditOT2002").data("kendoGrid");
    var itemDivisionID = $("#DivisionID").data("kendoComboBox");
    if (itemDivisionID != undefined) {
        var divisionDf = $("#DivisionID").val();
        var itemDVRemove = null;
        for (var i = 0; i < $("#DivisionID").data("kendoComboBox").dataSource.data().length; i++) {
            var itemToRemove = $("#DivisionID").data("kendoComboBox").dataSource.at(i);
            if (itemToRemove.DivisionID == divisionDf) {
                itemDVRemove = itemToRemove;
            }
        }
        $("#DivisionID").data("kendoComboBox").dataSource.remove(itemDVRemove);
        $("#DivisionID").data("kendoComboBox").select(0);
    }

    //if ($('meta[name=customerIndex]').attr('content') == 51) {
       if ($("#isUpdate").val() == "True" && $("#QuotationID").length == 0) {
           GetVarCharFirst();
           getSOLDUpdate();

            if ($("#OrderStatus").val() != 1 && $("#OrderStatus").val() != 2 && $("#OrderStatus").val() != 3) {
                var listDelete = [];
                for (var i = 0; i < $("#OrderStatus").data("kendoComboBox").dataSource.data().length; i++) {
                    var itemToRemove = $("#OrderStatus").data("kendoComboBox").dataSource.at(i);
                    if (itemToRemove.ID == "1" || itemToRemove.ID == "2" || itemToRemove.ID == "3") {
                        listDelete.push(itemToRemove);
                    }
                }

                for (var i = 0; i < listDelete.length; i++) {
                    $("#OrderStatus").data("kendoComboBox").dataSource.remove(listDelete[i]);
                }
            }
        }
        $("#Varchar").remove();
        $("#ChooseQuotationID").remove();
        //$(".Varchar").parent().append($(".IsInvoice"));
    //    $("#ViewDebit").remove();
        $(".Varchar .asf-td-field").append('<a id="btnChooseVarchar" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseVarchar_Click()"><span class="asf-button-text">...</span></a>');
        $(".ChooseQuotationID .asf-td-field").append('<a id="btnChooseQuotationID" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseQuotationID_Click()"><span class="asf-button-text">...</span></a>');
    //    $(".ViewDebit .asf-td-field").append('<a id="btnViewDebit" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnViewDebit_Click()"><span class="asf-button-text">...</span></a>');
    //}

    GridOT2002.bind('dataBound', function (e) {
        $(GridOT2002.tbody).find('td').on("keyup", function (e) {
            if (e.keyCode == 119) {
                var tr = e.currentTarget.parentElement;
                var dataItem = GridOT2002.dataItem(tr);

                if (e.target.id === "OriginalAmount") {
                    if (e.target != null && dataItem.OrderQuantity != null) {
                        var unit = e.target.value / dataItem.OrderQuantity;
                        dataItem.set("SalePrice", unit);
                    }
                }
                else {
                    if (dataItem.OriginalAmount != null && dataItem.OrderQuantity != null) {
                        var unit = dataItem.OriginalAmount / dataItem.OrderQuantity;
                        dataItem.set("SalePrice", unit);
                    }
                }
            }
        })
    })

    $("#ObjectID").attr("data-val-required", "The field is required.");

    //ToanThien Sua loi chieu cao tren firefox
    setTimeout(function () {
        $("#GridEditOT2002 .k-grid-content").css("height", "180px");
        $("#GridEditOT2002").css("max-height", "230px");
    }, 200)

    $(".float_left .asf-table-view").append($(".InventoryTypeID"));
    $(".float_left .asf-table-view").append($(".Varchar"));

    //var urlRouteID = "/Partial/RouteID/SO/SOF2001";
    //ASOFT.partialView.Load(urlRouteID, ".Address", 1);

    //var urlVATAccountID = "/Partial/VATAccountID/SO/SOF2001";
    //ASOFT.partialView.Load(urlVATAccountID, ".Address", 1);

    //var urlAccountID = "/Partial/AccountID/SO/SOF2001";
    //ASOFT.partialView.Load(urlAccountID, ".Address", 1);

    LoadAccountID();
    LoadSalesMan();

    //var urlEmployee = "/Partial/Employee/SO/SOF2001";
    //ASOFT.partialView.Load(urlEmployee, ".InventoryTypeID", 0);

    //var urlSalesMan = "/Partial/SalesMan/SO/SOF2001";
    //ASOFT.partialView.Load(urlSalesMan, ".InventoryTypeID", 0);

    $($(".line_left_with_grid .asf-table-view").find("tbody")).prepend($(".Address"));

    $("#Tel").attr("readonly", true);
    $("#Address").attr("readonly", true);
    $("#VATNo").attr("readonly", true);


    if ($("#isUpdate").val() == "False" || $("#QuotationID").length > 0) {
        $("#Disabled").val(0);
        $("#IsConfirm").val(0);
        $("#OrderType").val(0);

        $("#ImpactLevel").data("kendoComboBox").value(1);
        $("#VoucherTypeID").data("kendoComboBox").select(0);
        $("#ContractDate").data("kendoDatePicker").value(new Date());
        //$("#DivisionID").change(function () {
        //    changeDivisionIDSOF2001();
        //    $("#Disabled").val(0);
        //    $("#IsConfirm").val(0);
        //    $("#OrderType").val(0);
        //});

        //if ($("#SOrderID").val() != undefined && $("#SOrderID").val() != "") {
        //    changeDivisionIDSOF2001();
        //    $("#SaveNew").hide();
        //    $("#SaveClose span").text($("#BtnSave span").text());
        //    noChange(false);
        //}
        //else { }

        GetvoucherNo();

        $("#VoucherTypeID").change(function () {
            GetvoucherNo();
        });

        //if ($('meta[name=customerIndex]').attr('content') == 51) {
            var listDelete = [];
            for (var i = 0; i < $("#OrderStatus").data("kendoComboBox").dataSource.data().length; i++) {
                var itemToRemove = $("#OrderStatus").data("kendoComboBox").dataSource.at(i);
                if (itemToRemove.ID != "0") {
                    listDelete.push(itemToRemove);
                }
            }

            for (var i = 0; i < listDelete.length; i++) {
                $("#OrderStatus").data("kendoComboBox").dataSource.remove(listDelete[i]);
            }

            $("#OrderStatus").data("kendoComboBox").select(0);
        //}

            if ($("#isUpdate").val() == "True")
            {
                $("#isUpdate").val("False")
                $("#BtnSave").unbind();
                $("#BtnSave").kendoButton({
                    "click": SaveCustom_Click,
                });
            }
    }
    else {
        CheckConfirm();
        $("#Disabled").attr("disabled", "disabled");
        $("#IsConfirm").attr("disabled", "disabled");
        $("#OrderType").attr("disabled", "disabled");
    }

    $("#PaymentTermID").change(function () {
        GetDueDate();
    })

    $(GridOT2002.tbody).on("keyup", "td", "td", function (e) {
        if(e.keyCode != 13)
            $("#TxtInventoryID").val(e.target.value);
    })


    $(GridOT2002.tbody).on("focusout", "td", function (e) {
        var selectitem = GridOT2002.dataItem($(e.target).parent().parent().parent().parent());
        var column = e.target.name;
        if (column.indexOf("_input") != -1) {
            selectitem.set(column.split('_')[0], e.target.value);
        }
    })

    $(GridOT2002.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = GridOT2002.dataItem($(e.target).parent().parent().parent().parent().parent());
        if (selectitem == null)
        {
            selectitem = GridOT2002.dataItem($(e.target).parent().parent().parent());
        }   

        if (column == "InventoryID") {
            SOLD[selectitem.uid] = {};
            $.each(selectitem, function (key, value) {
                if (key.indexOf("SType") != -1 || key.indexOf("SUnitPrice") != -1) {
                    selectitem.set(key, "");
                }
            })
        }
        if (column == "cbbAna01ID") {
            GetCombobox(e.target.value, "Ana01ID", ana01ID, selectitem);
        }
        if (column == "cbbAna02ID") {
            GetCombobox(e.target.value, "Ana02ID", ana02ID, selectitem);
        }
        if (column == "cbbAna03ID") {
            GetCombobox(e.target.value, "Ana03ID", ana03ID, selectitem);
        }
        if (column == "cbbAna04ID") {
            GetCombobox(e.target.value, "Ana04ID", ana04ID, selectitem);
        }
        if (column == "cbbAna05ID") {
            GetCombobox(e.target.value, "Ana05ID", ana05ID, selectitem);
        }
        if (column == "cbbAna06ID") {
            GetCombobox(e.target.value, "Ana06ID", ana06ID, selectitem);
        }
        if (column == "cbbAna07ID") {
            GetCombobox(e.target.value, "Ana07ID", ana07ID, selectitem);
        }
        if (column == "cbbAna08ID") {
            GetCombobox(e.target.value, "Ana08ID", ana08ID, selectitem);
        }
        if (column == "cbbAna09ID") {
            GetCombobox(e.target.value, "Ana09ID", ana09ID, selectitem);
        }
        if (column == "cbbAna10ID") {
            GetCombobox(e.target.value, "Ana10ID", ana10ID, selectitem);
        }
        if (column == 'cbbVATGroupID' && e.target.value != "") {
            var data = [];
            data.push(e.target.value);
            ASOFT.helper.postTypeJson("/SO/SOF2000/GetVATPercent", data, function (result) {
                selectitem.set("VATPercent", result.VATRate);
                selectitem.set("VATConvertedAmount", selectitem.ConvertedAmount * (result.VATRate / 100));
                selectitem.set("VATOriginalAmount", selectitem.OriginalAmount * (result.VATRate / 100));
            });
        }
        if (column == 'cbbVATGroupID' && e.target.value == "") {
            selectitem.set("VATGroupID", vatgroupID);
        }
        if (column.indexOf("SType") != -1)
        {
            var clS = "SUnitPrice" + column.replace("cbbSTypeS", "");
            var txtS = $("#" + column).data('kendoComboBox').value();
            GetCombobox(txtS, column.replace("cbb", ""), SID[column.replace("cbb", "")], selectitem);
            if (txtS != "") {
                var vlS = $("#" + column).data('kendoComboBox').dataItem($("#" + column).data('kendoComboBox').select()).UnitPrice;
                GetCombobox(vlS, clS, "", selectitem);
            }

            var dtRowS = SOLD[selectitem["uid"]] != undefined ? SOLD[selectitem["uid"]] : {};

            selectitem.set("SalePrice", parseFloat(selectitem.SalePrice) + (parseFloat(selectitem[clS]) || 0) - (parseFloat(dtRowS[clS]) || 0));
            dtRowS[clS] = parseFloat(selectitem[clS]) || 0;

            SOLD[selectitem["uid"]] = dtRowS;
        }

        if ((e.target.name || "").indexOf("STypeS") != -1 && e.target.value == "") {
            selectitem = GridOT2002.dataItem($(e.target).parent().parent().parent().parent());
            var clS = "SUnitPrice" + e.target.name.split("_")[0].replace("STypeS", "");

            var dtRowS = SOLD[selectitem["uid"]] != undefined ? SOLD[selectitem["uid"]] : {};

            selectitem.set("SalePrice", parseFloat(selectitem.SalePrice) - (parseFloat(dtRowS[clS]) || 0));
            dtRowS[clS] = 0;

            selectitem.set(clS, "");
            SOLD[selectitem["uid"]] = dtRowS;
        }

    })

    $("#ExchangeRate").focusout(function () {
        for (i = 0; i < GridOT2002.dataSource.data().length ; i++) {
            var item = GridOT2002.dataSource.at(i);
            item.set("ConvertedAmount", $("#ExchangeRate").val() * item.OriginalAmount);
            item.set("VATConvertedAmount", item.ConvertedAmount * (item.VATPercent / 100));
        }
    })

    if ($('meta[name=customerIndex]').attr('content') == 51) {
        $("#OrderDate").on("change", function () {
            var dataShip = $("#ShipDate").val();

            $("#ShipDate").val($("#OrderDate").val() + " " + dataShip.split(' ')[1]);
        })
    }

    $("#PriceListID").bind("change", function () { PriceListIDChange() })

    //PriceListIDChange(true);

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditOT2002',
        inputID: 'autocomplete-box',
        NameColumn: "InventoryID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("DivisionID", $("#DivisionID").val());
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            //selectedRowItem.model.set("UnitID", dataItem.UnitID);
            //selectedRowItem.model.set("SalePrice", dataItem.SalePrice);
            //selectedRowItem.model.set("OriginalAmount", dataItem.OriginalAmount);
            //selectedRowItem.model.set("OrderQuantity", dataItem.OrderQuantity);
            //selectedRowItem.model.set("VATOriginalAmount", dataItem.VATOriginalAmount);
            //selectedRowItem.model.set("VATConvertedAmount", dataItem.VATConvertedAmount * $("#ExchangeRate").val());
            //selectedRowItem.model.set("StandardPrice", dataItem.SalePrice);
            //selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);
            //selectedRowItem.model.set("VATPercent", dataItem.VATPercent);
            //selectedRowItem.model.set("ConvertedAmount", dataItem.ConvertedAmount * $("#ExchangeRate").val());
            selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("SalePrice", dataItem.SalePrice);

            //for (var i = 0; i < listPriceInventory.length; i++) {
            //    if (listPriceInventory[i].InventoryID == dataItem.InventoryID) {
            //        selectedRowItem.model.set("SalePrice", listPriceInventory[i].SalePrice);
            //        break;
            //    }
            //}
        }
    });

    if ($("#ExchangeRate").val() != "") {
        $("#ExchangeRate").val(formatDecimal(kendo.parseFloat($("#ExchangeRate").val())));
    }

    $("#ExchangeRate").keydown(function (e) {
        if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105 && ((e.keyCode != 190 && e.keyCode != 110) || ($(this).val()).indexOf('.') != -1)) {
            if (e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8)
                e.preventDefault()
        }
    });

    $("#ExchangeRate").focusout(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    //Check đơn hàng đã được duyệt
    //if (typeof parent.GetCheckConfirm === "function") {
    //    if (parent.GetCheckConfirm() == 1) {
    //        noChange(true);
    //    }
    //}
    //GridOT2002.hideColumn("IsBorrow");
})

function SaveCustom_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    action = 3;
    save(url);
}

function onCheckGridEdit(posGrid, key, tag) {
    var row = $(tag).parent().closest('tr');
    var data = posGrid.dataItem(row);
    data.set(key, $(tag).prop('checked') ? 1 : 0);
    data.set("SalePrice", 0);
    data.set("OriginalAmount", 0);
    data.set("ConvertedAmount", 0);
    data.set("VATOriginalAmount", 0);
    data.set("VATConvertedAmount", 0);
}


function noChange(isChangeMaster) {
    if (isChangeMaster) {
        EnableFields();
        $(".ChooseQuotationID").remove();
        $(".Varchar").remove();
    }
    $("#IsInvoice").attr("disabled", "disabled");
    GridOT2002.bind('dataBound', function (e) {
        $("#GridEditOT2002").find('td').on("focusin", function (e) {
            var index = e.delegateTarget.cellIndex;
            var th = $($("#GridEditOT2002").find('th')[index]).attr("data-field");
            if (th != 'Description' && th != 'Ana01ID' && th != 'Ana02ID' && th != 'Ana03ID' && th != 'Ana04ID' && th != 'Ana05ID' && th != 'Notes01' && th != 'Notes02' && th != 'Notes') {
                GridOT2002.closeCell();
            }
            if (!isChangeMaster) {
                GridOT2002.closeCell();
            }
        })
    })

    GridOT2002.hideColumn("TransactionID");
    $("#GridEditOT2002").attr("AddNewRowDisabled", "false");
}

function EnableFields() {
    var data = ASOFT.helper.dataFormToJSON(id);

    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "Notes") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").readonly(true);
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").readonly(true);
                }
                if ($("#" + key).data("kendoDatePicker") != null) {
                    $("#" + key).data("kendoDatePicker").readonly(true);
                }
                if ($("#" + key).data("kendoTimePicker") != null) {
                    $("#" + key).data("kendoTimePicker").readonly(true);
                }
                if ($("#" + key).data("kendoDateTimePicker") != null) {
                    $("#" + key).data("kendoDateTimePicker").readonly(true);
                }
                $("#" + key).attr("readonly", "readonly");
            }
        }
    })

}

// lấy giá trị của quy cách ban đầu trường hợp update
function getSOLDUpdate() {
    GridOT2002.bind('dataBound', function (e) {
        for (var i = 0; i < GridOT2002.dataSource.data().length ; i++) {
            var item = GridOT2002.dataSource.at(i);
            var S = {};
            $.each(item, function (key, value) {
                if (key.indexOf("SUnitPrice") != -1) {
                    S[key] = value;
                }
            })
            SOLD[item.uid] = S;
        }
    })
}

function PriceListIDChange() {
    for (var i = 0; i < GridOT2002.dataSource.data().length ; i++) {
        var item = GridOT2002.dataSource.at(i);
        if (item.InventoryID != null && item.InventoryID != "") {
            var data = [];
            data.push(item.InventoryID);
            data.push($("#DivisionID").val());
            data.push($("#ObjectID").val());
            data.push($("#OrderDate").val());
            data.push($("#PriceListID").val());
            data.push($("#CurrencyID").val());

            ASOFT.helper.postTypeJson("/SO/SOF2000/LoadSalePriceInventoryID", data, function (result) {
                //if (!isLoad) {
                    $.each(item, function (key, value) {
                        if (key.indexOf("SType") != -1 || key.indexOf("SUnitPrice") != -1) {
                            item.set(key, "");
                        }
                    })

                    item.set("SalePrice", result[0].SalePrice);

                    var OriginalAmount = item.SalePrice * item.OrderQuantity;
                    item.set("OriginalAmount", OriginalAmount);
                    item.set("VATOriginalAmount", item.OriginalAmount * (item.VATPercent / 100));
                    item.set("ConvertedAmount", item.OriginalAmount * $("#ExchangeRate").val());
                    item.set("VATConvertedAmount", item.ConvertedAmount * (item.VATPercent / 100));
                //}
            });
        }
    }
}

function LoadSalePriceInventoryID(selectedItem, inventoryID)
{
    var data = [];
    data.push(inventoryID);
    data.push($("#DivisionID").val());
    data.push($("#ObjectID").val());
    data.push($("#OrderDate").val());
    data.push($("#PriceListID").val());
    data.push($("#CurrencyID").val());

    ASOFT.helper.postTypeJson("/SO/SOF2000/LoadSalePriceInventoryID", data, function (result) {
        selectedItem.set("SalePrice", result[0].SalePrice);
        var OriginalAmount = selectedItem.SalePrice * selectedItem.OrderQuantity;
        selectedItem.set("OriginalAmount", OriginalAmount);
        selectedItem.set("VATOriginalAmount", selectedItem.OriginalAmount * (selectedItem.VATPercent / 100));
        selectedItem.set("ConvertedAmount", selectedItem.OriginalAmount * $("#ExchangeRate").val());
        selectedItem.set("VATConvertedAmount", selectedItem.ConvertedAmount * (selectedItem.VATPercent / 100));
    });
}

function GetCombobox(data, column, ana, selectitem) {
    if (data != "" && data != undefined) {
        selectitem.set(column, data);
    }
    else {
        selectitem.set(column, ana);
    }
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    //if (typeof parent.GetCheckConfirm === "function") {
    //    if (parent.GetCheckConfirm() == 1) {
    //        var th = Object.keys(e.values);
    //        if (th != 'Description' && th != 'Ana01ID' && th != 'Ana02ID' && th != 'Ana03ID' && th != 'Ana04ID' && th != 'Ana05ID' && th != 'Notes01' && th != 'Notes02' && th != 'Notes') {
    //            e.sender.editable = false;
    //            return;
    //        }
    //    }
    //}

    if (e.values != null) {
        var OriginalAmount = 0;
        var Parameter03 = 0;
        if (e.values.OrderQuantity != undefined) {
            var strSL = "";
            for (i = 0; i < GridOT2002.dataSource.data().length ; i++) {
                var item = GridOT2002.dataSource.at(i);
                if (item.uid == e.model.uid)
                    strSL = strSL + item.InventoryID + " : " + e.values.OrderQuantity + " ; ";
                else
                    strSL = strSL + item.InventoryID + " : " + parseInt(item.OrderQuantity) + " ; ";
            }
            $("#NotesQuantity").val(strSL);
        }

        if (e.values.SalePrice != undefined && e.model.OrderQuantity != undefined) {
            OriginalAmount = e.values.SalePrice * e.model.OrderQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
        }
        if (e.model.SalePrice != undefined && e.values.OrderQuantity != undefined) {
            OriginalAmount = e.model.SalePrice * e.values.OrderQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
        }
        if (e.values.Parameter01 != undefined && e.model.Parameter02 != undefined) {
            Parameter03 = e.values.Parameter01 * e.model.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
        if (e.values.Parameter02 != undefined && e.model.Parameter01 != undefined) {
            Parameter03 = e.model.Parameter01 * e.values.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
        if (e.values.OriginalAmount != undefined) {
            e.model.set("VATOriginalAmount", e.values.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.values.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
        }
        if (e.values.VATGroupID == "") {
            vatgroupID = e.model.VATGroupID;
        }
        if (e.values.Ana01ID == "") {
            ana01ID = e.model.Ana01ID;
        }
        if (e.values.Ana02ID == "") {
            ana02ID = e.model.Ana02ID;
        }
        if (e.values.Ana03ID == "") {
            ana03ID = e.model.Ana03ID;
        }
        if (e.values.Ana04ID == "") {
            ana04ID = e.model.Ana04ID;
        }
        if (e.values.Ana05ID == "") {
            ana05ID = e.model.Ana05ID;
        }
        if (e.values.Ana06ID == "") {
            ana06ID = e.model.Ana06ID;
        }
        if (e.values.Ana07ID == "") {
            ana07ID = e.model.Ana07ID;
        }
        if (e.values.Ana08ID == "") {
            ana08ID = e.model.Ana08ID;
        }
        if (e.values.Ana09ID == "") {
            ana09ID = e.model.Ana09ID;
        }
        if (e.values.Ana10ID == "") {
            ana10ID = e.model.Ana10ID;
        }

        $.each(e.values, function (key, value) {
            if (value == "" && key.indexOf("SType") != -1 && key.indexOf("_input") == -1)
                SID[key] = e.model[key];
        })
    }
}


function changeDivisionIDSOF2001() {
    var data = [];
    var cbo = $("#VoucherTypeID").data("kendoComboBox");
    OpenComboDynamic(cbo);
    var cbo1 = $("#CurrencyID").data("kendoComboBox");
    OpenComboDynamic(cbo1);
    var cbo2 = $("#InventoryTypeID").data("kendoComboBox");
    OpenComboDynamic(cbo2);
    var cbo3 = $("#PaymentTermID").data("kendoComboBox");
    OpenComboDynamic(cbo3);
    var cbo4 = $("#PaymentID").data("kendoComboBox");
    OpenComboDynamic(cbo4);

    data.push($("#ObjectID").val())
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/ChangeDivisionID", data, checkSuccessSOF2001);
}

function checkSuccessSOF2001(result) {
    var data = [];
    $("#ObjectID").val(result.ObjectID);
    $("#ObjectName").val(result.ObjectName);
    $("#AccountName").val(result.ObjectName);

    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckVoucherTypeID", data, function (result1) {
        if (result1.check) {
            $("#VoucherTypeID").data("kendoComboBox").value(result1.VoucherTypeID);
            GetvoucherNo();
        }
        else {
            $("#VoucherTypeID").data("kendoComboBox").value("");
            $("#VoucherNo").val("");
        }
    });
    if ($("#CurrencyID").data("kendoComboBox").value() == $("#CurrencyID").data("kendoComboBox").text()) {
        $("#CurrencyID").data("kendoComboBox").value("");
    }
    if ($("#InventoryTypeID").data("kendoComboBox").value() == $("#InventoryTypeID").data("kendoComboBox").text()) {
        $("#InventoryTypeID").data("kendoComboBox").value("");
    }
    if ($("#PaymentID").data("kendoComboBox").value() == $("#PaymentID").data("kendoComboBox").text()) {
        $("#PaymentID").data("kendoComboBox").value("");
    }
    if ($("#PaymentTermID").data("kendoComboBox").value() == $("#PaymentTermID").data("kendoComboBox").text()) {
        $("#PaymentTermID").data("kendoComboBox").value("");
    }
    if (result.check) {

        $("#VATObjectID").val(result.Ac.VATAccountID);
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result.Ac.RouteID);
        $("#RouteName").val(result.Ac.RouteName);
        $("#RouteNameDB").val(result.Ac.RouteName);
        $("#VATAccountName").val(result.VATAccountName);
        $("#VATObjectName").val(result.VATAccountName);
        routeName = result.Ac.RouteName; //gán routeName ban đầu

        $("#Address").val(result.Ac.Address);
        $("#Tel").val(result.Ac.Tel);
        $("#VATNo").val(result.Ac.VATNo);
        $("#DeliveryAddress").val(result.Ac.DeliveryAddress);
        $("#Description").val(result.Ac.Description);
        if (result.Ac.IsInvoice == 1) {
            $("#IsInvoice").prop("checked", true);
        }
        else {
            $("#IsInvoice").prop("checked", false);
        }

        var datacheck = [];
        datacheck.push($("#DivisionID").val());
        datacheck.push($("#VATObjectID").val());
        datacheck.push($("#RouteID").val());
        datacheck.push($("#EmployeeID").val());
        datacheck.push($("#SalesManID").val());
        ASOFT.helper.postTypeJson("/SO/SOF2000/CheckAllDivision", datacheck, function (result2) {
            if (!result2.checkVATAccountID) {
                $("#VATObjectID").val("");
                $("#VATAccounID").val("");
                $("#VATAccountID").attr("Disabled", true);
                $("#VATAccountName").val("");
            }
            if (!result2.checkRouteID) {
                $("#RouteID").val("");
                $("#RouteID").attr("Disabled", true);
                $("#RouteName").val("");
            }
            if (!result2.checkEmployeeID) {
                $("#EmployeeID").val("");
                $("#EmployeeID").attr("Disabled", true);
                $("#EmployeeName").val("");
            }
            if (!result2.checkSalesManID) {
                $("#SalesManID").val("");
                $("#SalesManID").attr("Disabled", true);
                $("#SalesManName").val("");
            }
        })
        //GridOT2002.dataSource.page(1);
    }
    else {
        var datacheck = [];
        datacheck.push($("#DivisionID").val());
        datacheck.push("");
        datacheck.push("");
        datacheck.push($("#EmployeeID").val());
        datacheck.push($("#SalesManID").val());
        ASOFT.helper.postTypeJson("/SO/SOF2000/CheckAllDivision", datacheck, function (result2) {
            if (!result2.checkEmployeeID) {
                $("#EmployeeID").val("");
                $("#EmployeeID").attr("Disabled", true);
                $("#EmployeeName").val("");
            }
            if (!result2.checkSalesManID) {
                $("#SalesManID").val("");
                $("#SalesManID").attr("Disabled", true);
                $("#SalesManName").val("");
            }
        })

        ASOFT.form.clearMessageBox();
        ClearMasterSOF2001();
        $(".k-grid-edit-row").appendTo("#grid tbody");
    }

    var listGrid = [];

    setTimeout(function () { 
        for (i = 0; i < GridOT2002.dataSource.data().length ; i++) {
            var item = GridOT2002.dataSource.at(i);
            var dataCheckInventory = [];
            dataCheckInventory.push(item.InventoryID, $("#DivisionID").val());
            ASOFT.helper.postTypeJson("/SO/SOF2000/CheckInventory", dataCheckInventory, function (result3) {
                if (result3.check) {
                    item.DivisionID = $("#DivisionID").val();
                    listGrid.push(item);
                }

                if (i == GridOT2002.dataSource.data().length - 1 && listGrid.length > 0)
                {
                    GridOT2002.dataSource.data([]);
                    for (i = 0; i < listGrid.length; i++) {
                        GridOT2002.dataSource.add(listGrid[i]);
                    }
                }
                if (i == GridOT2002.dataSource.data().length - 1 && listGrid.length == 0)
                {
                    GridOT2002.dataSource.data([]);
                    GridOT2002.dataSource.add({ InventoryID: "" });
                }
            })
        }
    }, 500)
}

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
    return kendo.toString(value, format);
}


function ClearMasterSOF2001() {
    var args = $('#SOF2001 input');
    for (i = 0; i < args.length; i++) {
        if (args[i].id.indexOf("_input") == -1) {
            if (args[i].id != "item.TypeCheckBox" && args[i].id.indexOf("_Content_DataType") == -1 && args[i].id.indexOf("_Type_Fields") == -1 && args[i].id != "DivisionID" && args[i].id.indexOf("listRequired") == -1 && args[i].id != "tableNameEdit" && args[i].id != "CheckInList" && args[i].id != "VoucherNo" && args[i].id != "OrderDate" && args[i].id != "ExchangeRate" && args[i].id != "ShipDate" && args[i].id != "VoucherTypeID" && args[i].id != "CurrencyID" && args[i].id != "OrderStatus" && args[i].id != "InventoryTypeID" && args[i].id != "PaymentTermID" && args[i].id != "PaymentID" && args[i].id != "SOrderID" && args[i].id != "IsConfirm" && args[i].id != "EmployeeID" && args[i].id != "SalesManID" && args[i].id != "SalesManNameDB" && args[i].id != "EmployeeNameDB" && args[i].id != "SalesManName" && args[i].id != "EmployeeName" && args[i].id != "OrderTime") {
                $("#" + args[i].id).val('');
            }
        }
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "OrderDate" && key != "ShipDate" && key != "VoucherTypeID" && key != "DivisionID" && key != "InventoryTypeID") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                $("#" + key).val('');
            }
        }
    })
    $("#ExchangeRate").val(1);

    $("#CurrencyID").data("kendoComboBox").value("VND");
    $("#OrderStatus").data("kendoComboBox").value(0);
}

function CustomRead() {
    var ct = [];
    ct.push($("#SOrderID").val());
    ct.push($("#DivisionID").val());
    return ct;
}

function GetvoucherNo() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#VoucherTypeID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetVoucherNo", data, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
    });
}

function GetTime(actionTime) {
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetTime", {}, function (result) {
        $("#OrderTime").val(result.OrderTime);
        $("#ShipDate").val(result.ShipDate);
        if (actionTime == 1) {
            $("#EmployeeName").val(result.EmployeeName);
            $("#EmployeeID").val(result.EmployeeID);
            $("#SalesManID").val(result.EmployeeID);
            $("#SalesManName").val(result.EmployeeName);
        }
    });
}




function genInventoryID(data) {
    if (data && data.InventoryID != null) {
        return data.InventoryID;
    }
    return "";
}

//function genVATGroupID(data) {
//    var selectitem = GridOT2002.dataItem(GridOT2002.select());
//    if (data != null && data.VATGroupID != null && selectitem != null) {
//        if (data.VATGroupID.VATGroupName !== undefined && data.VATGroupID.VATGroupID != "") {
//                selectitem.set("VATGroupID", data.VATGroupID.VATGroupID);
//            return data.VATGroupID.VATGroupID;
//        }
//        if (data.VATGroupID != "") {
//                selectitem.set("VATGroupID", data.VATGroupID);
//        return data.VATGroupID;
//    }
//    return "";
//}


function btnChooseQuotationID_Click() {
    urlChooseAccount = "/PopupSelectData/Index/SO/SOF2023?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
}


function btnChooseAccount_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
    action = 1;
}

function btnChooseRoute_Click() {
    urlChooseRoute = "/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseRoute, {});
    action = 2;
}

function btnDeleteRoute_Click() {
    $("#RouteID").val("");
    $("#RouteID").attr("Disabled", true);
    $("#RouteName").val("");
}

function btnChooseVATAccount_Click() {
    urlChooseVATAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVATAccount, {});
    action = 3;
}


function btnDeleteVATAccount_Click() {
    $("#VATObjectID").val("");
    $("#VATAccounID").val("");
    $("#VATAccountID").attr("Disabled", true);
    $("#VATAccountName").val("");
}

function btnChooseEmployee_Click() {
    urlChooseEmployee = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    action = 5;
}

function btnDeleteEmployee_Click() {
    $("#EmployeeID").val("");
    $("#EmployeeID").attr("Disabled", true);
    $("#EmployeeName").val("");
}

function btnChooseSalesMan_Click() {
    urlChooseSalesMan = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseSalesMan, {});
    action = 6;
}

function btnDeleteSalesMan_Click() {
    $("#SalesManID").val("");
    $("#SalesManID").attr("Disabled", true);
    $("#SalesManName").val("");
}

function ChooseInventory_Click(e) {
    $(e.parentElement.parentElement).addClass("k-state-selected");
    urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    action = 4;
}


function receiveResult(result) {
    if (action == 2) {
        $("#RouteID").removeAttr("disabled");
        $("#RouteID").val(result["RouteID"]);
        $("#RouteName").val(result["RouteName"]);
    }
    if (action == 1) {
        $("#ObjectID").val(result["AccountID"]);
        $("#ObjectName").val(result["AccountName"]);
        $("#AccountName").val(result["AccountName"]);
        $("#Tel").val(result["Tel"]);
        $("#Address").val(result["Address"]);
        $("#VATNo").val(result["VATNo"]);
        $("#VATObjectID").val(result["VATAccountID"]);
        //$("#RouteID").removeAttr("disabled");
        //$("#RouteID").val(result["RouteID"]);
        //$("#RouteName").val(result["RouteName"]);
        $("#Notes").val(result["Description"]);
        $("#PaymentTermID").data("kendoComboBox").value(result["RePaymentTermID"]);
        if (result["RePaymentTermID"] != "" && result["RePaymentTermID"] != undefined) {
            GetDueDate();
        }
        else {
            $("#DueDate").val($("#OrderDate").val());
        }

        if (result["IsInvoice"] == 1) {
            $("#IsInvoice").attr("checked", "checked");
        }
        else {
            $("#IsInvoice").attr("checked", false);
        }

        $("#DeliveryAddress").val(result["DeliveryAddress"]);
        getVATAccountID(result["VATAccountID"]);
        //getRouteName(result["RouteID"]);
    }
    if (action == 3) {
        $("#VATObjectID").val(result["AccountID"]);
        $("#VATObjectName").val(result["AccountName"]);
        $("#VATAccountName").val(result["AccountName"]);
    }
    if (action == 5) {
        $("#EmployeeID").removeAttr("disabled");
        $("#EmployeeID").val(result["EmployeeID"]);
        $("#EmployeeName").val(result["EmployeeName"]);
    }
    if (action == 6) {
        $("#SalesManID").removeAttr("disabled");
        $("#SalesManID").val(result["EmployeeID"]);
        $("#SalesManName").val(result["EmployeeName"]);
    }
    if (action == 4) {
        var selectedItem = GridOT2002.dataItem(GridOT2002.select());
        selectedItem.set("DivisionID", result["DivisionID"])
        selectedItem.set("InventoryID", result["InventoryID"])
        selectedItem.set("InventoryName", result["InventoryName"])
        selectedItem.set("DivisionID", result["DivisionID"] == "@@@" ? $("#EnvironmentDivisionID").val() : result["DivisionID"]);
        selectedItem.set("VATGroupID", result["VATGroupID"]);
        selectedItem.set("UnitID", result["UnitID"]);
        //selectedItem.set("SalePrice", result["SalePrice"]);
        //for (var i = 0; i < listPriceInventory.length; i++) {
        //    if (listPriceInventory[i].InventoryID == result.InventoryID) {
        //        selectedItem.set("SalePrice", listPriceInventory[i].SalePrice);
        //        break;
        //    }
        //}

        //var OriginalAmount = selectedItem.SalePrice * selectedItem.OrderQuantity;
        //selectedItem.set("OriginalAmount", OriginalAmount);
        //selectedItem.set("VATOriginalAmount", selectedItem.OriginalAmount * (selectedItem.VATPercent / 100));
        //selectedItem.set("ConvertedAmount", selectedItem.OriginalAmount * $("#ExchangeRate").val());
        //selectedItem.set("VATConvertedAmount", selectedItem.ConvertedAmount * (selectedItem.VATPercent / 100));

        LoadSalePriceInventoryID(selectedItem, result["InventoryID"]);

        SOLD[selectedItem.uid] = {};
        $.each(selectedItem, function (key, value) {
            if (key.indexOf("SType") != -1 || key.indexOf("SUnitPrice") != -1) {
                selectedItem.set(key, "");
            }
        })

    }
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#VATAccountName").val('');
        $("#RouteName").val('');
        $("#AccountName").val('');
        //$("#DivisionID").data("kendoComboBox").value('');
        //$("#VoucherTypeID").data("kendoComboBox").value('');
        $("#ClassifyID").data("kendoComboBox").value('');
        $("#ImpactLevel").data("kendoComboBox").value(1);
        $("#PaymentTermID").data("kendoComboBox").value('');
        $("#PaymentID").data("kendoComboBox").value('');
        $("#Disabled").val(0);
        $("#IsConfirm").val(0);
        $("#OrderType").val(0);
        //$("#SalesManName").val('');
        $("#DueDate").val($("#OrderDate").val());
        $("#RouteID").attr("Disabled", true);
        //$("#SalesManID").attr("Disabled", true);
        GridOT2002.dataSource.data([]);
        GridOT2002.dataSource.add({ InventoryID: "" });
        GetvoucherNo();
        GetTime(1);
        dataVarchar = null;
    }
    if (result.Status == 0 && action1 == 2) {
        if ($("#SOrderID").val() != undefined && $("#SOrderID").val() != "") {
            parent.popupClose();
        }
        GetvoucherNo();
        GetTime(2);
    }

    if (result.Message == "00ML000053") {
        GetvoucherNo();
    }
}

function getVATAccountID(VATAccountID) {
    var data = [];
    data.push(VATAccountID);
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetVATAccountID", data, function (result) {
        $("#VATAccountName").val(result.VATAccountName);
        $("#VATObjectName").val(result.VATAccountName);
    });
}

function getRouteName(RouteID) {
    var data = [];
    data.push(RouteID);
    data.push($("#DivisionID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetRouteName", data, function (result) {
        $("#RouteName").val(result.RouteName);
    });
}


function GetDueDate() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#ObjectID").val());
    if ($('meta[name=customerIndex]').attr('content') == 51) {
        data.push($("#ShipDate").val());
    }
    else
        data.push($("#OrderDate").val());
    data.push($("#PaymentTermID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetDueDate", data, function (result) {
        if (result.DueDate != null && result.DueDate != "")
            $("#DueDate").val(result.DueDate);
    });
}

function CustomInsertPopupMaster(data) {
    var datagrid = [];
    var value1 = {};
    var master = [];
    var cb = $("input[type='checkbox']");
    $(cb).each(function () {
        var temp = $(this).is(':checked');
        var id = $(this).attr("id");
        if (temp) {
            data[id] = "1";
        }
        else {
            data[id] = "0";
        }
    })


    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox" && key != "Unique" && data[key + "_Content_DataType"] != undefined) {
            if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("tableNameEdit") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key.indexOf("CbGridEdit_") == -1) {
                if (value == "false")
                    value = "0";
                if (value == "true")
                    value = "1";
                if (key == "OrderTime") {
                    value = $("#OrderDate").val() + " " + value;
                }
                value1[key] = data[key + "_Content_DataType"] + "," + value;
            }
        }
    })

    master.push(value1)
    datagrid.push(master);

    return datagrid;
}

function LoadAccountID() {
    $.ajax({
        url: '/Partial/AccountID/SO/SOF2001',
        success: function (result) {
            $(".Address").before(result);
            LoadVATAccountID();
        }
    });
}

function LoadVATAccountID() {
    $.ajax({
        url: '/Partial/VATAccountID/SO/SOF2001',
        success: function (result) {
            $(".Address").before(result);
            //LoadRouteID();
            if (isConfirm) {
                $("#btnChooseAccount").remove();
                $("#btnChooseVATAccount").remove();
                $("#btnDeleteVATAccount").remove();
            }

            if ($("#QuotationID").length > 0) {
                $(".ChooseQuotationID").remove();
                GetQuotationKT(); //Load kế thừa báo giá khi thêm đơn hàng từ chi tiết báo giá
            }
        }
    });
}

//function LoadRouteID() {
//    $.ajax({
//        url: '/Partial/RouteID/SO/SOF2001',
//        success: function (result) {
//            $(".Address").before(result);
//            if ($("#isUpdate").val() == "False" && $("#SOrderID").val() != undefined && $("#SOrderID").val() != "") {
//                $("#RouteName").val(routeName);
//            }
//        }
//    });
//}

function LoadEmployee() {
    $.ajax({
        url: '/Partial/Employee/SO/SOF2001',
        success: function (result) {
            $(".InventoryTypeID").after(result);
            if ($("#isUpdate").val() == "False" || $("#QuotationID").length > 0) {
                GetTime(1);
            }

            if (isConfirm) {
                $("#btnChooseEmployee").remove();
                $("#btnDeleteEmployee").remove();
                $("#btnChooseSalesMan").remove();
                $("#btnDeleteSalesMan").remove();
            }
        }
    });
}

function LoadSalesMan() {
    $.ajax({
        url: '/Partial/SalesMan/SO/SOF2001',
        success: function (result) {
            $(".InventoryTypeID").after(result);
            LoadEmployee();
        }
    });
}

function GetVarchar() {
    return dataVarchar;
}

function SetVarchar(dtVarchar) {
    dataVarchar = dtVarchar;
    if (dtVarchar != null) {
        for (var k = 1; k <= 20; k++) {
            var stringV = k < 10 ? "Varchar0" : "Varchar";
            $("#" + stringV + k).val(dtVarchar[stringV + k] != undefined ? dtVarchar[stringV + k] : "");
        }
    }
}

function GetQuotationKT() {
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetQuotationKT", { QuotationID: $("#QuotationID").val() }, function (result) {
        setTimeout(function () {
            receiveResultCustom(result.dtMas, result.dtDet)
        }, 500);
    });
}

function receiveResultCustom(dtMas, dtDet) {
    var daDelOT2002 = [];
    if (dtMas != null)
    {
        $("#ObjectID").val(dtMas["ObjectID"]);
        $("#AccountName").val(dtMas["ObjectName"]);
        $("#VATObjectID").val(dtMas["ObjectID"]);
        $("#VATAccountName").val(dtMas["ObjectName"]);
        $("#CurrencyID").val(dtMas["CurrencyID"]);
        $("#ExchangeRate").val(dtMas["ExchangeRate"]);
        $("#InventoryTypeID").val(dtMas["InventoryTypeID"]);
        $("#PriceListID").val(dtMas["PriceListID"]);
        $("#Address").val(dtMas["Address"]);
        $("#Tel").val(dtMas["Tel"]);
        $("#DeliveryAddress").val(dtMas["DeliveryAddress"]);
        $("#Transport").val(dtMas["Transport"]);
        $("#PaymentTermID").data('kendoComboBox').value(dtMas["PaymentTermID"]);
        $("#PaymentID").data('kendoComboBox').value(dtMas["PaymentID"]);
        $("#Notes").val(dtMas["Description"]);
        $("#EmployeeID").val(dtMas["EmployeeID"]);
        $("#EmployeeName").val(dtMas["EmployeeName"]);
        $("#EmployeeID").val(dtMas["EmployeeID"]);
        $("#SalesManName").val(dtMas["EmployeeName"]);
        $("#SalesManID").val(dtMas["EmployeeID"]);

        if ($("#KQuotationID").length > 0)
            $("#KQuotationID").val(dtMas["QuotationID"]);
        if ($("#QuotationID").length > 0)
            $("#QuotationID").val(dtMas["QuotationID"]);
    }
    if (dtDet.length > 0) {
        for (var k = 0; k < dtDet.length; k++)
        {
            var itemKT = dtDet[k];
            var itemDT = {};
            itemDT.DivisionID = itemKT.DivisionID;
            itemDT.InventoryID = itemKT.InventoryID;
            itemDT.InventoryName = itemKT.InventoryName;
            itemDT.UnitID = itemKT.UnitID;
            //item.UnitName = itemKT.UnitName;
            itemDT.SalePrice = itemKT.UnitPrice;
            itemDT.OrderQuantity = itemKT.QuoQuantity;
            itemDT.OriginalAmount = itemKT.OriginalAmount;
            itemDT.ConvertedAmount = itemKT.ConvertedAmount;
            itemDT.VATGroupID = itemKT.VATGroupID;
            itemDT.VATPercent = itemKT.VATPercent;
            itemDT.VATOriginalAmount = itemKT.VATOriginalAmount;
            itemDT.VATConvertedAmount = itemKT.VATConvertedAmount;
            itemDT.InheritVoucherID = itemKT.QuotationID;
            itemDT.InheritTransactionID = itemKT.TransactionID;
            itemDT.QuoTransactionID = itemKT.TransactionID;
            itemDT.QuotationID = itemKT.TransactionID;
            itemDT.TransactionID = "";
            daDelOT2002.push(itemDT);
        }

        GridOT2002.dataSource.data([]);
        GridOT2002.dataSource.data(daDelOT2002);
    }
}

function CheckConfirm() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#TranMonth").val());
    data.push($("#TranYear").val());
    data.push($("#SOrderID").val());

    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckConfirm?tableID=OT2001", data, function (result) {
        if (result.Message != null && result.Message != "") {
            var msg = ASOFT.helper.getMessage(result.Message);
            ASOFT.form.displayWarning('#' + id, msg);
            isConfirm = true;
            noChange(true);
        }
    });
}
