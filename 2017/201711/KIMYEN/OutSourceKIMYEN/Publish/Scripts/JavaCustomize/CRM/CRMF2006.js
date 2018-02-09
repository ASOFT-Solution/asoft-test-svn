//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/12/2015     Quang Hoàng       Tạo mới
//####################################################################

var action;
var GridOT2001 = null;
var tagE = null;
var slIndex = null;
var readIndex = 0;
var devisionCB = 0;
var msgDebts = null;
var vatgroupID = null;
var dataVarchar = null;

$(document).keyup(function (e) {
    if (e.keyCode == 113) {
        var itemF2 = GridOT2001.dataItem(GridOT2001.select());
        if (itemF2 != undefined && itemF2 != null) {
            if (itemF2.InventoryID != null && itemF2.InventoryID != undefined && itemF2.InventoryID != "") {
                var urlF2 = "/SO/SOF2000/SOF2004?InventoryID=" + itemF2.InventoryID + "&DivisionID=" + $("#DivisionID").val() + "&InventoryName=" + itemF2.InventoryName;
                ASOFT.form.clearMessageBox();
                ASOFT.asoftPopup.showIframe(urlF2, {});
            }
        }
    }
});

function btnChooseVarchar_Click() {
    urlChooseVarchar = "/SO/SOF2000/SOF2003?DivisionID=" + $("#DivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseVarchar, {});
}

function btnViewDebit_Click() {
    if ($("#ObjectID").val() == "") {
        var msg = ASOFT.helper.getMessage("AFML000036");
        ASOFT.dialog.messageDialog(msg);
        return;
    }

    var splitL = $("#OrderDate").val();
    var res = splitL.split("/");

    var oderdate = res[1] + "/" + res[0] + "/" + res[2];

    urlChooseViewDebit = "/CRM/CRMF2008?DivisionID=" + $("#DivisionID").val() + "&VoucherDate=" + oderdate + "&ObjectID=" + $("#ObjectID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseViewDebit, {});
}


$(document).ready(function () {

    $("#Close").unbind();
    $("#Close").kendoButton({
        "click": popupClose_ClickCusTom
    });


    //if ($('meta[name=customerIndex]').attr('content') == 51) {
        $("#Varchar").remove();
        $("#ViewDebit").remove();
        $(".Varchar .asf-td-field").append('<a id="btnChooseVarchar" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChooseVarchar_Click()"><span class="asf-button-text">...</span></a>');
        $(".ViewDebit .asf-td-field").append('<a id="btnViewDebit" style="width : 26px; height: 26px" data-role="button" class="k-button" role="button" aria-disabled="false" tabindex="0" onclick="btnViewDebit_Click()"><span class="asf-button-text">...</span></a>');
    //}

    GetTime();
    GridOT2001 = $("#GridEditOT2002").data("kendoGrid");
    $("#ObjectID").attr("data-val-required", "The field is required.");
    //$(".float_left .asf-table-view").append($(".VoucherNo"));
    //$(".float_left .asf-table-view").append($(".OrderDate"));
    //$(".float_left .asf-table-view").append($(".OrderTime"));
    //$(".float_left .asf-table-view").append($(".ShipDate"));

    //$(".float_left .asf-table-view").append($(".Notes"));
    //$(".line_left_with_grid .asf-table-view").append($(".IsInvoice"));
    //var htmlShipDate = $(".ShipDate").html();
    //$(".ShipDate").remove();
    // $(".OrderDate").after(htmlShipDate);
    //var urlAccountID = "/Partial/AccountID/CRM/CRMF2006";
    //ASOFT.partialView.Load(urlAccountID, ".line_left_with_grid .asf-table-view", 2);

    //var urlRouteID = "/Partial/RouteID/CRM/CRMF2006";
    //ASOFT.partialView.Load(urlRouteID, ".line_left_with_grid .asf-table-view", 2);

    //var urlVATAccountID = "/Partial/VATAccountID/CRM/CRMF2006";
    //ASOFT.partialView.Load(urlVATAccountID, ".line_left_with_grid .asf-table-view", 2);
    LoadAccountID();
    if ($("#isUpdate").val() == "False") {
        GetvoucherNo();
    }

    //$("#btnChooseVATAccount").data("kendoButton").enable(true);
    //$("#btnDeleteVATAccount").data("kendoButton").enable(true);
    //$("#btnAddAccount").data("kendoButton").enable(true);
    //$("#btnDeleteAccount").data("kendoButton").enable(true);
    //$("#btnChooseAccount").data("kendoButton").enable(true);
    $("#GridEditOT2002").css("height", "520px");

    $(GridOT2001.tbody).on("focusin", "td", function (e) {
        var column = e.target.id;
        if (column == "SalePrice" || column == "OrderQuantity" || column == "Parameter01" || column == "Parameter02" || column == "Parameter03" || column == "VATPercent" || column == "VATOriginalAmount" || column == "VATConvertedAmount") {
            setTimeout(function () {
                var vcNo = document.getElementById(column)
                vcNo.selectionEnd = 0;
                vcNo.focus();
            }, 100)
        }
    })


    $("#Disabled").val(0);
    $("#OrderStatus").val(0);
    $("#ExchangeRate").val(1);
    $("#IsConfirm").val(0);
    $("#ImpactLevel").val(1);
    $("#OrderType").val(0);
    $("#InventoryTypeID").val("%");
    $("#RouteNameDB").attr("Disabled", true);
    $(".DivisionID").hide();
    //$("#DivisionID").data("kendoComboBox").readonly(true);
    if (typeof parent.returnContactID() === "function")
        $("#Contact").val(parent.returnContactID());

    //$("#DivisionID").change(function () {
    //    changeDivisionIDCRMF2006();
    //    $("#Disabled").val(0);
    //    $("#OrderStatus").val(0);
    //    $("#ExchangeRate").val(1);
    //    $("#IsConfirm").val(0);
    //    $("#ImpactLevel").val(0);
    //    $("#OrderType").val(0);
    //    $("#InventoryTypeID").val("%");
    //    $("#RouteNameDB").attr("Disabled", true);

    //});

    $(GridOT2001.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        if (column == 'cbbVATGroupID' && e.target.value != "") {
            var data = [];
            data.push(e.target.value);
            ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetVATPercent", data, function (result) {
                var selectitem = GridOT2001.dataItem(GridOT2001.select());
                selectitem.set("VATPercent", result.VATRate);
                selectitem.set("VATConvertedAmount", selectitem.ConvertedAmount * (result.VATRate / 100));
                selectitem.set("VATOriginalAmount", selectitem.OriginalAmount * (result.VATRate / 100));
            });
        }

        if (column == 'cbbVATGroupID' && e.target.value == "") {
            var selectitem = GridOT2001.dataItem(GridOT2001.select());
            selectitem.set("VATGroupID", vatgroupID);
        }
    })

    $("#PriceListID").bind("change", function () { PriceListIDChange() })

    $(GridOT2001.tbody).on("keyup", "td", "td", function (e) {
        if (e.keyCode != 13)
            $("#TxtInventoryID").val(e.target.value);
    })

    GRID_AUTOCOMPLETE.config({
        gridName: 'GridEditOT2002',
        inputID: 'autocomplete-box',
        autoSuggest: false,
        serverFilter: true,
        NameColumn: "InventoryID",
        setDataItem: function (selectedRowItem, dataItem) {
            selectedRowItem.model.set("DivisionID", dataItem.DivisionID);
            selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
            selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
            selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);
            selectedRowItem.model.set("UnitID", dataItem.UnitID);
            selectedRowItem.model.set("SalePrice", dataItem.SalePrice);

            if (typeof parent.ChangeGridOT2002 === "function") {
                parent.ChangeGridOT2002(true);
            }
        }
    });

    if ($('meta[name=customerIndex]').attr('content') == 51) {
        $("#OrderDate").on("change", function () {
            var dataShip = $("#ShipDate").val();

            $("#ShipDate").val($("#OrderDate").val() + " " + dataShip.split(' ')[1]);
        })
    }
})

function PriceListIDChange() {
    for (var i = 0; i < GridOT2001.dataSource.data().length ; i++) {
        var item = GridOT2001.dataSource.at(i);
        if (item.InventoryID != null && item.InventoryID != "") {
            var data = [];
            data.push(item.InventoryID);
            data.push($("#DivisionID").val());
            data.push($("#ObjectID").val());
            data.push($("#OrderDate").val());
            data.push($("#PriceListID").val());
            data.push($("#CurrencyID").val());

            ASOFT.helper.postTypeJson("/CRM/CRMF2006/LoadSalePriceInventoryID", data, function (result) {
                //if (!isLoad) {
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


function GetTime(actionTime) {
    ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetTime", {}, function (result) {
        //$("#OrderTime").val(result.OrderTime);
        $("#ShipDate").val(result.ShipDate);
    });
}


function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values != null) {
        var OriginalAmount = 0;
        var Parameter03 = 0;
        //if (e.values.OrderQuantity != undefined) {
        //    var strSL = "";
        //    for (i = 0; i < GridOT2001.dataSource.data().length ; i++) {
        //        var item = GridOT2001.dataSource.at(i);
        //        if (item.uid == e.model.uid)
        //            strSL = strSL + item.InventoryID + " : " + e.values.OrderQuantity + " ; ";
        //        else
        //            strSL = strSL + item.InventoryID + " : " + parseInt(item.OrderQuantity) + " ; ";
        //    }
        //    $("#NotesQuantity").val(strSL);
        //}

        if (e.values.SalePrice != undefined && e.model.OrderQuantity != undefined) {
            OriginalAmount = e.values.SalePrice * e.model.OrderQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount);
            e.model.set("VATConvertedAmount", e.model.ConvertedAmount * (e.model.VATPercent / 100));
        }
        if (e.model.SalePrice != undefined && e.values.OrderQuantity != undefined) {
            OriginalAmount = e.model.SalePrice * e.values.OrderQuantity;
            e.model.set("OriginalAmount", OriginalAmount);
            e.model.set("VATOriginalAmount", e.model.OriginalAmount * (e.model.VATPercent / 100));
            e.model.set("ConvertedAmount", e.model.OriginalAmount);
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

        if (e.values.VATGroupID == "") {
            vatgroupID = e.model.VATGroupID;
        }

        //if (e.values.InventoryID != null) {
        //    var dataGetPrice = [];
        //    dataGetPrice.push(e.values.InventoryID);
        //    dataGetPrice.push($("#DivisionID").val());
        //    dataGetPrice.push($("#ObjectID").val());
        //    dataGetPrice.push($("#OrderDate").val());
        //    dataGetPrice.push($("#PriceListID").val());
        //    if ($("#CurrencyID ").val() == "") {
        //        dataGetPrice.push("VND");
        //    }
        //    else
        //        dataGetPrice.push($("#CurrencyID ").val());


        //    ASOFT.helper.postTypeJson("/CRM/CRMF2006/LoadSalePrice", dataGetPrice, function (result) {
        //        for (i = 0; i < GridOT2001.dataSource.data().length ; i++) {
        //            var selectitem = GridOT2001.dataSource.at(i);
        //            if (selectitem.uid == e.model.uid) {
        //                selectitem.set("DivisionID", $("#DivisionID").val());
        //                //selectitem.model.set("InventoryID", dataItem.InventoryID);
        //                //selectitem.model.set("InventoryName", dataItem.InventoryName);
        //                selectitem.set("UnitID", result.UnitID);
        //                selectitem.set("SalePrice", result.SalePrice);
        //                selectitem.set("VATPercent", result.VATPercent);
        //                selectitem.set("VATGroupID", result.VATGroupID);
        //                selectitem.set("StandardPrice", result.SalePrice);
        //            }
        //        }
        //    });
        //}
    }
}

function btnChooseAccount_Click() {
    urlChooseAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlChooseAccount, {});
    action = 1;
}

function btnDeleteAccount_Click() {
    $("#AccountID").val("");
    $("#AccountName").val("");
}

//function btnChooseRoute_Click() {
//    urlChooseRoute = "/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val();
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe(urlChooseRoute, {});
//    action = 2;
//}

//function btnDeleteRoute_Click() {
//    $("#RouteID").val("");
//    $("#RouteID").attr("Disabled", true);
//    $("#RouteName").val("");
//}

//function btnChooseVATAccount_Click() {
//    urlChooseVATAccount = "/PopupSelectData/Index/CRM/CRMF9001?DivisionID=" + $("#DivisionID").val();
//    ASOFT.form.clearMessageBox();
//    ASOFT.asoftPopup.showIframe(urlChooseVATAccount, {});
//    action = 3;
//}


//function btnDeleteVATAccount_Click() {
//    $("#VATAccounID").val("");
//    $("#VATAccountID").attr("Disabled", true);
//    $("#VATAccountName").val("");
//}

function CustomRead() {
    var ct = [];
    ct.push($("#SOrderID").val());
    ct.push($("#DivisionID").val());
    return ct;
}

function receiveResult(result) {
    if (action == 1) {
        $("#ObjectID").val(result["AccountID"]);
        $("#ObjectName").val(result["AccountName"]);
        $("#AccountName").val(result["AccountName"]);
        $("#VATObjectID").val(result["VATAccountID"]);
        $("#Notes").val(result["Description"]);
        $("#VATNo").val(result["VATNo"]);
        $("#DeliveryAddress").val(result["DeliveryAddress"]);
        $("#Address").val(result["Address"]);
        //if (parent.returnAccountID() == result["AccountID"]) {
        //    $("Contact").val(parent.returnContactID());
        //}
        //else {
        //    $("Contact").val("");
        //}

        var data = [];
        data.push(result["AccountID"]);
        ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetDataSOrderID", data, function (result1) {
            $("#SOrderID").val(result1);
            $('#GridEditOT2002').data('kendoGrid').dataSource.read();

            //ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetDataGrid", CustomRead(), function (dtRead) {
            //    //if (dtRead.Data.length > 0) {
            //    $('#GridEditOT2002').data('kendoGrid').dataSource.data([]);
            //    $('#GridEditOT2002').data('kendoGrid').dataSource.data(dtRead.Data);
            //    //}
            //    //else {

            //    //}
            //})
        })
    }
    if (action == 3) {
        $("#VATObjectID").val(result["AccountID"]);
        $("#VATObjectName").val(result["AccountName"]);
        $("#VATAccountName").val(result["AccountName"]);
    }
    if (action == 4) {
        var selectedItem = GridOT2001.dataItem(GridOT2001.select());
        selectedItem.set("DivisionID", result["DivisionID"])
        selectedItem.set("InventoryID", result["InventoryID"])
        selectedItem.set("InventoryName", result["InventoryName"])
        selectedItem.set("UnitID", result["UnitID"])
        //selectedItem.set("SalePrice", 0)
        //selectedItem.set("OrderQuantity", 0)
        //selectedItem.set("OriginalAmount", 0)
        selectedItem.set("Notes", "")
        selectedItem.set("Notes01", "")
        selectedItem.set("Notes02", "")
    }
}

//function getRouteName(RouteID) {
//    var data = [];
//    data.push(RouteID);
//    data.push($("#DivisionID").val());
//    ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetRouteName", data, function (result) {
//        $("#RouteName").val(result.RouteName);
//    });
//}


//function getVATAccountID(VATAccountID) {
//    var data = [];
//    data.push(VATAccountID);
//    ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetVATAccountID", data, function (result) {
//        $("#VATAccountName").val(result.VATAccountName);
//        $("#VATObjectName").val(result["VATAccountName"]);
//    });
//}



function getDetail(tb) {
    var dataPost = ASOFT.helper.dataFormToJSON("CRMF2006");
    Grid = $('#GridEdit' + tb).data('kendoGrid');
    dataPost.Detail = Grid.dataSource._data;
    dataPost.IsDataChanged = Grid.dataSource.hasChanges()
    return dataPost;
}

function getListDetail(tb) {
    var dataPost1 = ASOFT.helper.dataFormToJSON(id);
    var data = [];
    var dt = getDetail(tb).Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["ConvertedAmount"] = "";
        dt[i]["ConvertedQuantity"] = "";
        dt[i]["ConvertedSalePrice"] = "";
        dt[i]["Finish"] = "0";
        dt[i]["IsPicking"] = "1";
        dt[i]["Orders"] = "1";
        dt[i]["WareHouseID"] = "";
        dt[i]["ShipDate"] = $("#ShipDate").val();
        dt[i]["Description"] = $("#Description").val();
        data.push(dt[i]);
    }
    return data;
}

function CustomInsertPopupDetail(datagrid) {
    tableName = []
    tableName.push("OT2002");
    $.each(tableName, function (key, value) {
        datagrid.push(getListDetail(value));
    })
    return datagrid;
}

//function changeDivisionIDCRMF2006() {
//    var data = [];
//    data.push($("#ObjectID").val())
//    data.push($("#DivisionID").val());
//    ASOFT.helper.postTypeJson("/CRM/CRMF2006/ChangeDivisionID", data, checkSuccessCRMF2006);
//}

//function checkSuccessCRMF2006(result) {
//    if (result.check) {
//        var datacheck = [];
//        $("#VATObjectID").val(result.Ac.VATAccountID);
//        $("#RouteID").removeAttr("disabled");
//        $("#RouteID").val(result.Ac.RouteID);
//        $("#RouteName").val(result.Ac.RouteName);
//        $("#VATAccountName").val(result.VATAccountName);
//        $("#VATObjectName").val(result.VATAccountName);

//        $("#Address").val(result.Ac.Address);
//        $("#Tel").val(result.Ac.Tel);
//        $("#VATNo").val(result.Ac.VATNo);
//        $("#DeliveryAddress").val(result.Ac.DeliveryAddress);
//        $("#Description").val(result.Ac.Description);
//        if (result.Ac.IsInvoice == 1) {
//            $("#IsInvoice").attr("checked", "checked");
//        }
//        else {
//            $("#IsInvoice").attr("checked", false);
//        }

//        datacheck.push($("#DivisionID").val());
//        datacheck.push($("#VATObjectID").val());
//        datacheck.push($("#RouteID").val());
//        ASOFT.helper.postTypeJson("/CRM/CRMF2006/CheckAllDivision", datacheck, function (result2) {
//            if (!result2.checkVATAccountID) {
//                $("#VATObjectID").val("");
//                $("#VATAccounID").val("");
//                $("#VATAccountID").attr("Disabled", true);
//                $("#VATAccountName").val("");
//            }
//            if (!result2.checkRouteID) {
//                $("#RouteID").val("");
//                $("#RouteID").attr("Disabled", true);
//                $("#RouteName").val("");
//            }
//        })
//    }
//    else {
//        ASOFT.form.clearMessageBox();
//        ClearMasterCRMF2006();
//        $(".k-grid-edit-row").appendTo("#grid tbody");
//    }

//    var listGrid = [];

//    for (i = 0; i < GridOT2001.dataSource.data().length ; i++) {
//        var item = GridOT2001.dataSource.at(i);
//        var dataCheckInventory = [];
//        dataCheckInventory.push(item.InventoryID, $("#DivisionID").val());
//        ASOFT.helper.postTypeJson("/CRM/CRMF2006/CheckInventory", dataCheckInventory, function (result3) {
//            if (result3.check) {
//                item.DivisionID = $("#DivisionID").val();
//                listGrid.push(item);
//            }
//        })
//    }

//    GridOT2001.dataSource.data([]);
//    if (listGrid.length > 0) {
//        for (i = 0; i < listGrid.length; i++) {
//            GridOT2001.dataSource.add(listGrid[i]);
//        }
//    }
//    else {
//        GridOT2001.dataSource.add({ InventoryID: "" });
//    }
//    GetvoucherNo();
//}

function ClearMasterCRMF2006() {
    var args = $('#CRMF2006 input');
    for (i = 0; i < args.length; i++) {
        if (args[i].id.indexOf("_input") == -1) {
            if (args[i].id != "item.TypeCheckBox" && args[i].id.indexOf("_Content_DataType") == -1 && args[i].id.indexOf("_Type_Fields") == -1 && args[i].id != "DivisionID" && args[i].id.indexOf("listRequired") == -1 && args[i].id != "tableNameEdit" && args[i].id != "CheckInList" && args[i].id != "OrderDate" && args[i].id != "ShipDate") {
                $("#" + args[i].id).val('');
            }
        }
    }
}

function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "OrderDate" && key != "ShipDate" && key != "VoucherNo" && key != "DivisionID") {
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
}


function genInventoryID(data) {
    if (data && data.InventoryID != null) {
        return data.InventoryID;
    }
    return "";
}

function CustomerConfirm() {
    var data = [];
    var dt = getDetail("OT2002").Detail;
    var OriginalAmount = 0;
    for (i = 0; i < dt.length; i++) {
        OriginalAmount = parseFloat(OriginalAmount) + parseFloat(dt[i]["OriginalAmount"]);
    }
    data.push($("#DivisionID").val(), $("#ObjectID").val(), $("#OrderDate").val(), OriginalAmount);
    ASOFT.helper.postTypeJson("/CRM/CRMF2006/CheckDebts", data, CheckDebtsCRMF2006);
    return msgDebts;
}

function CheckDebtsCRMF2006(result) {
    msgDebts = result;
}

function GetvoucherNo() {
    var data = [];
    data.push($("#EnvironmentDivisionID").val());
    ASOFT.helper.postTypeJson("/CRM/CRMF2006/GetVoucherNo", data, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
    });
}

function onAfterInsertSuccess(result, action1) {
    if (result.Status == 0 && action1 == 1) {
        $("#VATAccountName").val('');
        $("#RouteName").val('');
        $("#AccountName").val('');
        $("#Disabled").val(0);
        $("#OrderStatus").val(0);
        $("#ExchangeRate").val(1);
        $("#IsConfirm").val(0);
        $("#ImpactLevel").val(1);
        $("#OrderType").val(0);
        $("#InventoryTypeID").val("%");
        //$("#DivisionID").data("kendoComboBox").value('');
        $("#IsInvoice").attr("checked", false);
        GridOT2001.dataSource.data([]);
        GridOT2001.dataSource.add({ InventoryID: "" });
        GetvoucherNo();
        GetTime();
        dataVarchar = null;

        if (typeof parent.ChangeGridOT2002 === "function") {
            parent.ChangeGridOT2002(false);
        }
    }
    if (result.Status == 0 && action1 == 2) {
        GetvoucherNo();
        GetTime();
    }

    if (result.Message == "00ML000053") {
        GetvoucherNo();
    }
}

function returnAccountName() {
    if (action == 1)
        return $("#AccountName").val();
    if (action == 3)
        return $("#VATAccountName").val();
}

//function returnVATAccountName() {
//    return $("#RouteID").val();
//}

function genVATGroupID(data) {
    var selectitem = $("#GridEditOT2002").data("kendoGrid").dataItem($("#GridEditOT2002").data("kendoGrid").select());
    if (data && data.VATGroupID != null) {
        if (data.VATGroupID.VATGroupName !== undefined) {
            if (selectitem != undefined)
                selectitem.set("VATGroupID", data.VATGroupID.VATGroupID);
            return data.VATGroupID.VATGroupID;
        }
        if (selectitem != undefined)
            selectitem.set("VATGroupID", data.VATGroupID);
        return data.VATGroupID;
    }
    return "";
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
        url: '/Partial/AccountID/CRM/CRMF2006',
        success: function (result) {
            $(".Varchar").before(result);
            //LoadVATAccountID();
        }
    });
}

//function LoadVATAccountID() {
//    $.ajax({
//        url: '/Partial/VATAccountID/CRM/CRMF2006',
//        success: function (result) {
//            $(".Varchar").before(result);
//            LoadRouteID();
//        }
//    });
//}

//function LoadRouteID() {
//    $.ajax({
//        url: '/Partial/RouteID/CRM/CRMF2006',
//        success: function (result) {
//            $(".Varchar").before(result);
//        }
//    });
//}

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


function popupClose_ClickCusTom(event) {
    var url;
    var isupdate = $("#isUpdate").val();
    if (isupdate == "True") {
        url = "/GridCommon/UpdatePopupMasterDetail/" + module + "/" + id;
    }
    else {
        url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    }

    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
            function () {
                if (isupdate == "True") {
                    action = 4;
                    checkunique = 1;
                }
                else {
                    action = 3;
                }
                save(url);
            },
            function () {
                if (typeof parent.ChangeGridOT2002 === "function") {
                    parent.ChangeGridOT2002(false);
                }
                parent.popupClose();
            });
    }
    else {
        parent.popupClose();
    }
}

//function afterDataBound(idGrid, tbGrid) {
//    var strSL = "";
//    for (i = 0; i < GridOT2001.dataSource.data().length ; i++) {
//        var item = GridOT2001.dataSource.at(i);
//        strSL = strSL + item.InventoryID + " : " + parseInt(item.OrderQuantity) + " ; ";
//    }
//    $("#NotesQuantity").val(strSL);
//}


function CustomerCheck() { //Check số lương nhập phải lớn hơn 0
    var isCheck = false;
    var listError = [];
    var IndexColumn = null;
    var dataCheck = GridOT2001.dataSource.data();
    for (i = 0; i < dataCheck.length ; i++) {
        if (dataCheck[i]["OrderQuantity"] <= 0) {
            isCheck = true;
            listError.push(i);
        }
    }

    $(GridOT2001.columns).each(function (index, element) {
        if (element.field == "OrderQuantity") {
            IndexColumn = index;
        }
    })

    if (IndexColumn != null && isCheck) {
        $(GridOT2001.tbody).find('td').removeClass('asf-focus-input-error');
        $(GridOT2001.tbody).find("tr").each(function (index, element) {
            if (jQuery.inArray(index, listError) != -1) {
                $($(element).find("td")[IndexColumn]).addClass('asf-focus-input-error');
            }
        })

        var msg = ASOFT.helper.getMessage("SOFML000021");
        ASOFT.form.displayError("#CRMF2006", msg);
    }

    return isCheck;
}