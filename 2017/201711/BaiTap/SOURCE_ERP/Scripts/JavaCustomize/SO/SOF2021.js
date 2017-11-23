var GridOT2102 = null;
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
var dataVarchar = null;
var SID = {};
var SOLD = {};
var listPriceInventory = null;
var isConfirm = false;


function GetVarCharFirst() {
    ASOFT.helper.postTypeJson("/SO/SOF2020/GetVarchar?DivisionID=" + $("#DivisionID").val() + "&QuotationID=" + $("#QuotationID").val(), {}, function (result) {
        if (result != null) {
            dataVarchar = result;
            for (var k = 1; k <= 20; k++) {
                var stringV = k < 10 ? "Varchar0" : "Varchar";
                $("#" + stringV + k).val(result[stringV + k]);
            }
        }
    });
}

$(document).ready(function () {
    $(".Address").parent().prepend($(".ObjectName"));
    GridOT2102 = $("#GridEditOT2102").data("kendoGrid");

    var btnFromEmployee = '<a id="btSearchFromEmployee" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseEmployee_Click()">...</a>';

    var btnDelete = '<a id="btDeleteFrom" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteEmployee_Click(1)"></a>';

    var btnFromSaleManID = '<a id="btSearchFromSaleManID" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseSaleManID_Click()">...</a>';

    var btnDeleteSaleManID = '<a id="btDeleteFromSaleManID" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteSaleManID_Click(1)"></a>';

    var btnFromObjectID = '<a id="btSearchCampaign" style="z-index:10001; position: absolute; right: 28px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseObjectID_Click()">...</a>';

    var btnDeleteObjectID = '<a id="btDeleteFromCampaign" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteObjectID_Click(1)"></a>';

    $("#EmployeeName").after(btnFromEmployee);
    $("#EmployeeName").after(btnDelete);
    $("#EmployeeName").attr('disabled', 'disabled');

    $("#ObjectName").after(btnFromObjectID);
    $("#ObjectName").after(btnDeleteObjectID);
    $("#ObjectName").attr('readonly', 'readonly');

    $("#SalesManName").after(btnFromSaleManID);
    $("#SalesManName").after(btnDeleteSaleManID);
    $("#SalesManName").attr('disabled', 'disabled');

    $("#Tel").attr('disabled', 'disabled');
    $("#Address").attr('readonly', 'readonly');

    $(GridOT2102.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = GridOT2102.dataItem($(e.target).parent().parent().parent().parent().parent());
        if (selectitem == null) {
            selectitem = GridOT2102.dataItem($(e.target).parent().parent().parent());
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
            GetCombobox(e.target.value, "Ana01ID", ana01ID);
        }
        if (column == "cbbAna02ID") {
            GetCombobox(e.target.value, "Ana02ID", ana02ID);
        }
        if (column == "cbbAna03ID") {
            GetCombobox(e.target.value, "Ana03ID", ana03ID);
        }
        if (column == "cbbAna04ID") {
            GetCombobox(e.target.value, "Ana04ID", ana04ID);
        }
        if (column == "cbbAna05ID") {
            GetCombobox(e.target.value, "Ana05ID", ana05ID);
        }
        if (column == "cbbAna06ID") {
            GetCombobox(e.target.value, "Ana06ID", ana06ID);
        }
        if (column == "cbbAna07ID") {
            GetCombobox(e.target.value, "Ana07ID", ana07ID);
        }
        if (column == "cbbAna08ID") {
            GetCombobox(e.target.value, "Ana08ID", ana08ID);
        }
        if (column == "cbbAna09ID") {
            GetCombobox(e.target.value, "Ana09ID", ana09ID);
        }
        if (column == "cbbAna10ID") {
            GetCombobox(e.target.value, "Ana10ID", ana10ID);
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

        if (column.indexOf("SType") != -1) {
            var clS = "SUnitPrice" + column.replace("cbbSTypeS", "");
            var txtS = $("#" + column).data('kendoComboBox').value();
            GetCombobox(txtS, column.replace("cbb", ""), SID[column.replace("cbb", "")], selectitem);
            if (txtS != "") {
                var vlS = $("#" + column).data('kendoComboBox').dataItem($("#" + column).data('kendoComboBox').select()).UnitPrice;
                GetCombobox(vlS, clS, "", selectitem);
            }

            var dtRowS = SOLD[selectitem["uid"]] != undefined ? SOLD[selectitem["uid"]] : {};

            selectitem.set("UnitPrice", parseFloat(selectitem.UnitPrice) + (parseFloat(selectitem[clS]) || 0) - (parseFloat(dtRowS[clS]) || 0));
            dtRowS[clS] = parseFloat(selectitem[clS]) || 0;

            SOLD[selectitem["uid"]] = dtRowS;
        }

        if ((e.target.name || "").indexOf("STypeS") != -1 && e.target.value == "") {
            selectitem = GridOT2102.dataItem($(e.target).parent().parent().parent().parent());
            var clS = "SUnitPrice" + e.target.name.split("_")[0].replace("STypeS", "");

            var dtRowS = SOLD[selectitem["uid"]] != undefined ? SOLD[selectitem["uid"]] : {};

            selectitem.set("UnitPrice", parseFloat(selectitem.UnitPrice) - (parseFloat(dtRowS[clS]) || 0));
            dtRowS[clS] = 0;

            selectitem.set(clS, "");
            SOLD[selectitem["uid"]] = dtRowS;
        }
    })

    $(GridOT2102.tbody).on("keyup", "td", "td", function (e) {
        if (e.keyCode != 13)
            $("#TxtInventoryID").val(e.target.value);
    })

    $(GridOT2102.tbody).on("focusout", "td", function (e) {
        var selectitem = GridOT2102.dataItem($(e.target).parent().parent().parent().parent());
        var column = e.target.name;
        if (column.indexOf("_input") != -1) {
            selectitem.set(column.split('_')[0], e.target.value);
        }
    })

    $("#ExchangeRate").focusout(function () {
        for (i = 0; i < GridOT2102.dataSource.data().length ; i++) {
            var item = GridOT2102.dataSource.at(i);
            item.set("ConvertedAmount", $("#ExchangeRate").val() * item.OriginalAmount);
            item.set("VATConvertedAmount", item.ConvertedAmount * (item.VATPercent / 100));
        }
    })

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditOT2102',
        inputID: 'autocomplete-box',
        NameColumn: "InventoryID",
        autoSuggest: false,
        serverFilter: true,
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("TransactionID", null);
            selectedRowItem.model.set("DivisionID", $("#DivisionID").val());
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("UnitPrice", dataItem.SalePrice);
            //for (var i = 0; i < listPriceInventory.length; i++) {
            //    if (listPriceInventory[i].InventoryID == dataItem.InventoryID) {
            //        selectedRowItem.model.set("UnitPrice", listPriceInventory[i].SalePrice);
            //        break;
            //    }
            //}
        }
    });

    //if (typeof parent.GetCheckConfirm === "function") {
    //    if (parent.GetCheckConfirm() == 1) {
    //        noChange(true);
    //    }
    //}

    if ($("#isUpdate").val() == "True" && $("#RelColumn").length == 0) {
        CheckConfirm();
        GetVarCharFirst();
        getSOLDUpdate();
    }
    else {
        $("#DivisionID").val($("#EnvironmentDivisionID").val());
        $("#QuotationDate").data("kendoDatePicker").value(new Date());
        OpenComboDynamic($("#VoucherTypeID").data("kendoComboBox"));
        $("#EndDate").data("kendoDatePicker").value(new Date());
        $("#Disabled").val(0);
        $("#IsConfirm").val(0);
        $("#Status").val(0);
        $("#IsSO").val(0);
        $("#QuotationStatus").val(0);
        $("#OrderStatus").data("kendoComboBox").value(0);
        $("#VoucherTypeID").data("kendoComboBox").select(0);
        $("#CurrencyID").data("kendoComboBox").value("VND");
        $("#ExchangeRate").val("1");
        GetvoucherNo();
        $("#RelatedToTypeID").val(5);
        $("#VoucherTypeID").change(function () {
            GetvoucherNo();
        });
        GetTime(1);
        if ($("#isUpdate").val() == "True") {
            $("#isUpdate").val("False")
            $("#BtnSave").unbind();
            $("#BtnSave").kendoButton({
                "click": SaveCustom_Click,
            });
        }
    }

    $("#ExchangeRate").val(formatDecimal(kendo.parseFloat($("#ExchangeRate").val())));
    defaultValue = getDataInsert(ASOFT.helper.dataFormToJSON(id));

    $("#ExchangeRate").keydown(function (e) {
        if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105 && (e.keyCode != 190 || ($(this).val()).indexOf('.') != -1)) {
            if (e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8)
                e.preventDefault()
        }
    });

    $("#ExchangeRate").focusout(function (e) {
        var value = $(this).val();
        value = formatDecimal(kendo.parseFloat(value));
        $(this).val(value);
    });

    $("#Varchar").remove();
    $(".Varchar .asf-td-field").append('<a id="btnChooseVarchar" style="min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseVarchar_Click()">...</a>');

    var Group = "<fieldset id='right'><legend><label>" + $("label[for='ConditionPayment']").text() + "</label></legend><table class='asf-table-view'></table></fieldset>";
    $(".line_left_with_grid").append(Group);
    $("#right .asf-table-view").append($(".Dear"));
    $("#right .asf-table-view").append($(".Attention1"));
    $("#right .asf-table-view").append($(".Attention2"));

    $(".ConditionPayment").remove();

    setTimeout(function () {
        $("#GridEditOT2102 .k-grid-content").css("height", "250px");
        $("#GridEditOT2102").css("max-height", "350px");
    }, 200)

    $("#PriceListID").bind("change", function () { PriceListIDChange() })

    //PriceListIDChange(true);

    setTimeout(function () {
        $("#GridEditOT2102 .k-grid-content").css("height", "200px");
        $("#GridEditOT2102").css("max-height", "250px");
    }, 200)
})

function PriceListIDChange() {
    for (var i = 0; i < GridOT2102.dataSource.data().length ; i++) {
        var item = GridOT2102.dataSource.at(i);
        if (item.InventoryID != null && item.InventoryID != "") {
            var data = [];
            data.push(item.InventoryID);
            data.push($("#DivisionID").val());
            data.push($("#ObjectID").val());
            data.push($("#QuotationDate").val());
            data.push($("#PriceListID").val());
            data.push($("#CurrencyID").val());

            ASOFT.helper.postTypeJson("/SO/SOF2000/LoadSalePriceInventoryID", data, function (result) {
                //if (!isLoad) {
                $.each(item, function (key, value) {
                    if (key.indexOf("SType") != -1 || key.indexOf("SUnitPrice") != -1) {
                        item.set(key, "");
                    }
                })

                item.set("UnitPrice", result[0].SalePrice);

                var OriginalAmount = item.UnitPrice * item.QuoQuantity;
                item.set("OriginalAmount", OriginalAmount);
                item.set("VATOriginalAmount", item.OriginalAmount * (item.VATPercent / 100));
                item.set("ConvertedAmount", item.OriginalAmount * $("#ExchangeRate").val());
                item.set("VATConvertedAmount", item.ConvertedAmount * (item.VATPercent / 100));
                //}
            });
        }
    }
}

function LoadSalePriceInventoryID(selectedItem, inventoryID) {
    var data = [];
    data.push(inventoryID);
    data.push($("#DivisionID").val());
    data.push($("#ObjectID").val());
    data.push($("#QuotationDate").val());
    data.push($("#PriceListID").val());
    data.push($("#CurrencyID").val());

    ASOFT.helper.postTypeJson("/SO/SOF2000/LoadSalePriceInventoryID", data, function (result) {
        selectedItem.set("UnitPrice", result[0].SalePrice);
        var OriginalAmount = selectedItem.UnitPrice * selectedItem.QuoQuantity;
        selectedItem.set("OriginalAmount", OriginalAmount);
        selectedItem.set("VATOriginalAmount", selectedItem.OriginalAmount * (selectedItem.VATPercent / 100));
        selectedItem.set("ConvertedAmount", selectedItem.OriginalAmount * $("#ExchangeRate").val());
        selectedItem.set("VATConvertedAmount", selectedItem.ConvertedAmount * (selectedItem.VATPercent / 100));
    });
}

function getSOLDUpdate() {
    GridOT2102.bind('dataBound', function (e) {
        for (var i = 0; i < GridOT2102.dataSource.data().length ; i++) {
            var item = GridOT2102.dataSource.at(i);
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

function SaveCustom_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    action = 3;
    save(url);
}

function formatDecimal(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
    return kendo.toString(value, format);
}


function noChange(isChangeMaster) {
    if (isChangeMaster) {
        EnableFields();
    }
    $("#IsInvoice").attr("disabled", "disabled");
    GridOT2102.bind('dataBound', function (e) {
        $("#GridEditOT2102").find('td').on("focusin", function (e) {
            var index = e.delegateTarget.cellIndex;
            var th = $($("#GridEditOT2102").find('th')[index]).attr("data-field");
            if (th != 'Description' && th != 'Ana01ID' && th != 'Ana02ID' && th != 'Ana03ID' && th != 'Ana04ID' && th != 'Ana05ID' && th != 'Notes01' && th != 'Notes02' && th != 'Notes') {
                GridOT2102.closeCell();
            }
            if (!isChangeMaster) {
                GridOT2102.closeCell();
            }
        })
    })

    GridOT2102.hideColumn("TransactionID");
    $("#GridEditOT2102").attr("AddNewRowDisabled", "false");
}


function btnChooseVarchar_Click() {
    var urlChooseVarchar = "/SO/SOF2000/SOF2003?DivisionID=" + $("#DivisionID").val() + "&T=Q__";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVarchar, {});
}


function EnableFields() {
    var data = ASOFT.helper.dataFormToJSON(id);

    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "Description") {
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


function GetCombobox(data, column, ana) {
    var selectitem = GridOT2102.dataItem(GridOT2102.select());
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

    if (e.values != null) {
        var OriginalAmount = 0;

        if (e.values.UnitPrice != undefined && e.model.QuoQuantity != undefined) {
            OriginalAmount = e.values.UnitPrice * e.model.QuoQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
        }
        if (e.model.UnitPrice != undefined && e.values.QuoQuantity != undefined) {
            OriginalAmount = e.model.UnitPrice * e.values.QuoQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount * $("#ExchangeRate").val());
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
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

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "QuotationDate" && key != "VoucherTypeID" && key != "DivisionID" && key != "InventoryTypeID" && key != "EndDate") {
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

function GetTime(actionTime) {
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetTime", {}, function (result) {
        if (actionTime == 1) {
            $("#EmployeeName").val(result.EmployeeName);
            $("#EmployeeID").val(result.EmployeeID);
            $("#SalesManName").val(result.EmployeeName);
            $("#SalesManID").val(result.EmployeeID);
        }
    });
}

function genInventoryID(data) {
    if (data && data.InventoryID != null) {
        return data.InventoryID;
    }
    return "";
}

function btnChooseObjectID_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
    action = 1;
}

function btnDeleteObjectID_Click() {
    $("#ObjectID").val("");
    $("#ObjectName").val("");
}

function btnChooseEmployee_Click() {
    urlChooseEmployee = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    action = 2;
}


function btnChooseSaleManID_Click() {
    urlChooseEmployee = "/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseEmployee, {});
    action = 4;
}


function btnDeleteEmployee_Click() {
    $("#EmployeeID").val("");
    $("#EmployeeName").val("");
}

function btnDeleteSaleManID_Click() {
    $("#SalesManID").val("");
    $("#SalesManName").val("");
}

function receiveResult(result) {
    if (action == 1) {
        $("#ObjectID").val(result["AccountID"]);
        $("#ObjectName").val(result["AccountName"]);
        $("#Tel").val(result["Tel"]);
        $("#Address").val(result["Address"]);
        $("#Description").val(result["Description"]);
        $("#DeliveryAddress").val(result["DeliveryAddress"]);
    }
    if (action == 2) {
        $("#EmployeeID").val(result["EmployeeID"]);
        $("#EmployeeName").val(result["EmployeeName"]);
    }

    if (action == 4) {
        $("#SalesManID").val(result["EmployeeID"]);
        $("#SalesManName").val(result["EmployeeName"]);
    }
    
    if (action == 3) {
        var selectedItem = GridOT2102.dataItem(GridOT2102.select());
        selectedItem.set("TransactionID", null);
        selectedItem.set("DivisionID", result["DivisionID"])
        selectedItem.set("InventoryID", result["InventoryID"])
        selectedItem.set("InventoryName", result["InventoryName"])
        selectedItem.set("DivisionID", result["DivisionID"] == "@@@" ? $("#EnvironmentDivisionID").val() : result["DivisionID"]);
        selectedItem.set("VATGroupID", result["VATGroupID"]);
        selectedItem.set("UnitID", result["UnitID"]);
        //selectedItem.set("UnitPrice", result["SalePrice"]);

        //for (var i = 0; i < listPriceInventory.length; i++) {
        //    if (listPriceInventory[i].InventoryID == result.InventoryID) {
        //        selectedItem.set("UnitPrice", listPriceInventory[i].SalePrice);
        //        break;
        //    }
        //}

        //var OriginalAmount = selectedItem.UnitPrice * selectedItem.QuoQuantity;
        //selectedItem.set("OriginalAmount", OriginalAmount);
        //selectedItem.set("VATOriginalAmount", selectedItem.OriginalAmount * (selectedItem.VATPercent / 100));
        //selectedItem.set("ConvertedAmount", selectedItem.OriginalAmount * $("#ExchangeRate").val());
        //selectedItem.set("VATConvertedAmount", selectedItem.ConvertedAmount * (selectedItem.VATPercent / 100));.
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
        $("#DivisionID").val($("#EnvironmentDivisionID").val());
        $("#ObjectName").val('');
        $("#ObjectID").val('');
        $("#PaymentTermID").data("kendoComboBox").value('');
        $("#PaymentID").data("kendoComboBox").value('');
        $("#Disabled").val(0);
        $("#IsConfirm").val(0);
        $("#Status").val(0);
        $("#Tel").val('');
        $("#IsSO").val(0);
        $("#QuotationStatus").val(0);
        $("#OrderStatus").val(0);
        $("#RelatedToTypeID").val(5);
        GridOT2102.dataSource.data([]);
        GridOT2102.dataSource.add({ InventoryID: "" });
        GetvoucherNo();
        GetTime(1);
        dataVarchar = null;
    }
    if (result.Status == 0 && action1 == 2) {
        GetvoucherNo();
        GetTime(2);
    }

    if (result.Message == "00ML000053") {
        GetvoucherNo();
    }
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

function GetvoucherNo() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#VoucherTypeID").val());
    ASOFT.helper.postTypeJson("/SO/SOF2000/GetVoucherNo", data, function (result) {
        $("#QuotationNo").val(result.VoucherNo);
    });
}

function CustomRead() {
    var ct = [];
    ct.push($("#QuotationID").val());
    ct.push($("#DivisionID").val());
    return ct;
}

function ChooseInventory_Click(e) {
    $(e.parentElement.parentElement).addClass("k-state-selected");
    urlChooseInventoryID = "/PopupSelectData/Index/00/CMNF9001?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseInventoryID, {});
    action = 3;
}


function CheckConfirm() {
    var data = [];
    data.push($("#DivisionID").val());
    data.push($("#TranMonth").val());
    data.push($("#TranYear").val());
    data.push($("#QuotationID").val());

    ASOFT.helper.postTypeJson("/SO/SOF2000/CheckConfirm?tableID=OT2101", data, function (result) {
        if (result.Message != null && result.Message != "") {
            var msg = ASOFT.helper.getMessage(result.Message);
            ASOFT.form.displayWarning('#' + id, msg);
            isConfirm = true;
            noChange(true);
        }
    });
}
