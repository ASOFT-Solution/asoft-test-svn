var DeliveryEmployeeID;
var RouteID;
var urlChooseDeliveryEmplyeeID = "/PopupSelectData/Index/CRM/CMNF9003";
var urlChooseRouteID = "/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val();
var IsChooseRoute;
var StatusAfterInsert;//0:Close, 1:Print and Close, 2:Print and LoadNew
var GridProduct = null;
var check = "true";
var lisCheckOrderQuantity = [];

$(document).ready(function () {
    if ($("#ModelStatus").val() == 0) {
        ASOFT.asoftPopup.closeOnly();
    }
    $("#RouteName").focus(function () { $(this).blur() });
    $("#DeliveryEmployeeName").focus(function () { $(this).blur() });
    $("#AccountName").focus(function () { $(this).blur() });
    GridProduct = $("#GridProduct").data("kendoGrid");

    $("#IsDeposit").click(function () {
        if ($(this).is(':checked')) {
            for (i = 0; i < GridProduct.dataSource.data().length ; i++) {
                GridProduct.dataSource.at(i).fields["Parameter01"].editable = true;
                GridProduct.dataSource.at(i).fields["Parameter02"].editable = true;
                GridProduct.dataSource.at(i).fields["Parameter03"].editable = true;
            }
            check = "true"
        }
        else {
            for (j = 0; j < GridProduct.dataSource.data().length ; j++) {
                var Item = GridProduct.dataSource.data()[j];
                Item.set("Parameter01", "");
                Item.set("Parameter02", "");
                Item.set("Parameter03", "");
            }
            for (i = 0; i < GridProduct.dataSource.data().length ; i++) {
                var Item = GridProduct.dataSource.data()[i];
                GridProduct.dataSource.at(i).fields["Parameter01"].editable = false;
                GridProduct.dataSource.at(i).fields["Parameter02"].editable = false;
                GridProduct.dataSource.at(i).fields["Parameter03"].editable = false;
            }
            check = "false"
        }
    })

    //if ($("#Unbind").val() == "1")
    //{
    //    $("#btnSaveCopy").kendoButton({
    //        enable: false
    //    });
    //    $("#btnSaveNew").kendoButton({
    //        enable: false
    //    });
    //    $("#btnSaveCopy").unbind();
    //    $("#btnSaveNew").unbind();
    //    $("#btnClose").unbind();
    //    $("#btnClose").on("click", function () {
    //        parent.popupClose();
    //    })
    //}
});

function Grid2011_Save(e)
{
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values != null) {
        var Parameter03 = 0;
        if (e.values.Parameter01 != undefined && e.model.Parameter02 != undefined) {
            Parameter03 = e.values.Parameter01 * e.model.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
        if (e.values.Parameter02 != undefined && e.model.Parameter01 != undefined) {
            Parameter03 = e.model.Parameter01 * e.values.Parameter02;
            e.model.set("Parameter03", Parameter03);
        }
    }
}

function btnChooseDeliveryEmployeeID_Click() {
    IsChooseRoute = false;
    ASOFT.asoftPopup.showIframe(urlChooseDeliveryEmplyeeID + "?A=GTA&B=GTB&DivisionID=" + $("#DivisionID").val());
};

function btnChooseRouteName_Click() {
    IsChooseRoute = true;
    ASOFT.asoftPopup.showIframe(urlChooseRouteID, {});
};

function btnDeleteRoute_Click() {
    $("#RouteName").val("");
    $("#RouteID").val("");
};

function btnDeleteDelivery_Click() {
    $("#DeliveryEmployeeName").val("");
    $("#DeliveryEmployeeID").val("");
};

function receiveResult(result) {
    if (IsChooseRoute) {
        $("#RouteName").val(result["RouteName"]);
        $("#RouteID").val(result["RouteID"]);

    }
    else {
        $("#DeliveryEmployeeName").val(result["EmployeeName"]);
        $("#DeliveryEmployeeID").val(result["EmployeeID"]);
    }
};

function btnClose_Click() {
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage("00ML000016"), function () {
        StatusAfterInsert = 0;
        Save()
    }, function () {
        ASOFT.asoftPopup.closeOnly();
    });
};
function ReadAPK() {
    var data = { APK: $("#APK").val() };
    return data;
};

function btnPrintClose_Click() {
    StatusAfterInsert = 1;
    Save()
};
function btnPrintNew_Click() {
    StatusAfterInsert = 2;
    Save()
};

function GetCheckOrderQuantity() {
    GridProduct = $("#GridProduct").data("kendoGrid");
    for (i = 0; i < GridProduct.dataSource.data().length ; i++) {
        var OrderQuantity = {};
        var Item = GridProduct.dataSource.data()[i];
        OrderQuantity[Item.APK] = Item.OrderQuantity
        lisCheckOrderQuantity.push(OrderQuantity);
    }
}

function checkOrderQuantity() {
    for (i = 0; i < GridProduct.dataSource.data().length ; i++)
    {
        var Item = GridProduct.dataSource.data()[i];
        if (Item.OrderQuantity > lisCheckOrderQuantity[i][Item.APK] && lisCheckOrderQuantity[i][Item.APK] > 0)
        {
            return true;
        }
    }
    return false;
}

function Save() {
    if (ASOFT.form.checkRequired("CRMF2011")) {
        return;
    }
    if (checkOrderQuantity())
    {
        ASOFT.form.displayWarning('#CRMF2011', ASOFT.helper.getMessage("CRMFML000004"));
        return;
    }
    ASOFT.helper.postTypeJson("/CRM/CRMF2011/CheckInsert", GetData(), function (resultCheckInsert) {
        if (resultCheckInsert.Status == 1) {
            ASOFT.helper.postTypeJson("/CRM/CRMF2011/CheckEmployeeDebit", GetData(), function (resultCheckDebit) {
                if (resultCheckDebit.Status == 1) {
                    return insert();
                }
                else {//CheckDebit False
                    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage(resultCheckDebit.Message), function () {
                        return insert();
                    }, function () {//Không save

                    })
                }
            });
        }
        else { //CheckInsert False
            if (resultCheckInsert.Data != null) {
                ASOFT.form.displayError("#CRMF2011", kendo.format(ASOFT.helper.getMessage(resultCheckInsert.Message), resultCheckInsert.Data[0], resultCheckInsert.Data[1]));
            }
            else {
                ASOFT.form.displayError("#CRMF2011", kendo.format(ASOFT.helper.getMessage(resultCheckInsert.Message), resultCheckInsert.Data));
            }

            return false;
        }
    });
}
function insert() {
    ASOFT.helper.postTypeJson("/CRM/CRMF2011/Insert", GetData(), function (resultInsert) {
        if (resultInsert.Status == 1) {
            ASOFT.form.displayInfo("#CRMF2011", ASOFT.helper.getMessage("00ML000015"));
            onInsertSuccess(resultInsert.Data);
            parent.refreshGrid();
            return true;
        }
        else {//Insert false
            ASOFT.form.displayError("#CRMF2011", kendo.format(ASOFT.helper.getMessage(resultInsert.Message), resultInsert.Data));
            return false;
        }
    });
};

function onInsertSuccess(APK) {
    if (StatusAfterInsert == 0)//Close
    {
        Print(APK);
        parent.refreshGrid();
        ASOFT.asoftPopup.closeOnly();
    }
    else if (StatusAfterInsert == 1)//Close and Print
    {
        //Mở màn hình In
        Print(APK);
        parent.refreshGrid();
        ASOFT.asoftPopup.closeOnly();
    }
    else if (StatusAfterInsert == 2)//Print and LoadNew
    {
        //Tiến hành In
        Print(APK);
        location.reload();//Load lại 2011
    }
}

function GetData() {
    data = new Array();
    var Grid = $("#GridProduct").data("kendoGrid");
    var dataGrid = Grid.dataSource.data();
    var totalNumber = dataGrid.length;
    for (var i = 0; i < totalNumber; i++) {
        data.push(GetItem(dataGrid[i]));
    }
    return data;
};

function GetItem(currentDataItem) {
    var data = new Array();

    var itemn = new Object();
    itemn.key = "NotesQuantity";
    itemn.value = $("#NotesQuantity").val();
    data.push(itemn);

    var item1 = new Object();
    item1.key = "APKMaster";
    item1.value = $("#APK").val();
    data.push(item1);

    var item2 = new Object();
    item2.key = "RouteID";
    item2.value = $("#RouteID").val();
    data.push(item2);

    var item3 = new Object();
    item3.key = "DeliveryEmployeeID";
    item3.value = $("#DeliveryEmployeeID").val();
    data.push(item3);

    var item4 = new Object();
    item4.key = "VoucherNo";
    item4.value = $("#VoucherNo").val();
    data.push(item4);

    var item0 = new Object();
    item0.key = "IsDeposit";
    item0.value = check;
    data.push(item0);

    var item5 = new Object();
    item5.key = "APKDetails";
    item5.value = currentDataItem.TransactionID;
    data.push(item5);

    var item6 = new Object();
    item6.key = "OrderQuantity";
    item6.value = currentDataItem.OrderQuantity;
    data.push(item6);

    var item7 = new Object();
    item7.key = "Parameter01";
    item7.value = currentDataItem.Parameter01;
    data.push(item7);

    var item8 = new Object();
    item8.key = "Parameter02";
    item8.value = currentDataItem.Parameter02;
    data.push(item8);

    var item9 = new Object();
    item9.key = "Parameter03";
    item9.value = currentDataItem.Parameter03;
    data.push(item9);

    var item10 = new Object();
    item10.key = "Description";
    item10.value = currentDataItem.Description;
    data.push(item10);

    return data;
};

function Print(APK) {

    var URLDoPrintorExport = "/CRMF2020/DoPrintOrExport";

    var dataRP = {};
    dataRP["VoucherID"] = APK;
    ASOFT.helper.postTypeJson(URLDoPrintorExport, dataRP, ExportSuccess);
}

function ExportSuccess(result) {
    if (result) {
        var urlPrint = '/CRM/CRMF2020/ReportViewer';
        var options = '&viewer=pdf';
        // Tạo path full
        var fullPath = urlPrint + "?id=" + result.apk + options;

        // Getfile hay in báo cáo
        window.open(fullPath, "_blank");
    }
}

function btnDelete_Click() {
    var grid = $("#GridProduct").data("kendoGrid");
    if (grid.dataSource.total() == 1) {
        ASOFT.asoftPopup.closeOnly();
    }
    var selectedItem = grid.dataItem(grid.select());
    lisCheckOrderQuantity = $.grep(lisCheckOrderQuantity, function (n, i) {
        return n[selectedItem.APK] == undefined;
    });
    grid.dataSource.remove(selectedItem);
    grid.refresh(); //grid.dataSource.sync();
    var count = grid.dataSource.total();
}

function btnMinus_Click() {
    var grid = $("#GridProduct").data("kendoGrid");
    var selectedItem = grid.dataItem(grid.select());
    var quality = selectedItem.OrderQuantity;
    if (quality > 1) {
        selectedItem.set('OrderQuantity', quality - 1);
    }
    grid.refresh();
}
function btnPlus_Click() {
    var grid = $("#GridProduct").data("kendoGrid");
    var selectedItem = grid.dataItem(grid.select());
    var quality = selectedItem.OrderQuantity;
    selectedItem.set('OrderQuantity', quality + 1);
    grid.refresh();
}