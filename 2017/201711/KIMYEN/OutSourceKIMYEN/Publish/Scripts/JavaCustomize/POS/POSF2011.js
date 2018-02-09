var oldFunc = window.deleteDetail_Click;
window.deleteDetail_Click = function (para01, para02) {

    var grid = $("#GridEditPOST2011").data("kendoGrid");

    var row = $(para01).closest("tr");
    var item = grid.dataItem(row);

    if (item.IsPackage == 1 && item.PackageID) {
        var dataSource = grid.dataSource;
        var items = dataSource.data();

        var delItems = items.map(function (it) {
            if (it && it.IsPackage == 1 && it.PackageID == item.PackageID) {
                return it;
            }
        });

        delItems.forEach(function (dlItem) {
            if (dlItem) {
                dataSource.remove(dlItem);
            }
        });

        if (items.length == 0) {
            grid.dataSource.add({});
        }

        grid.dataSource.sync();
    }

    else {
        oldFunc(para01, para02);
    }
}

var oldCheckGridEdit = window.CheckGridEdit;
window.CheckGridEdit = function (ar01, ar02, ar03) {

    oldCheckGridEdit(ar01, ar02, ar03);
}


var
    templateAttachFile = function (textFileName, templeteClass, textFileID) {
        this.getTemplete = kendo.format("<div id='{2}' class='{0}'><label><img width='16px' height='16px' src='/../../Areas/CRM/Content/images/file_icon_256px.png' /></label><label title='{3}'>{1}</label><label class='x-close'>&#10006</label></div>", templeteClass, textFileName.length > 25 ? [textFileName.slice(0, 24), "..."].join("") : textFileName, textFileID, textFileName);
        return this;
    },

    templateAsoftButton = function () {
        this.getAsoftButton = function (buttonClass, buttonID, spanClass, buttonCaption, onclickFunction) {
            return kendo.format("<a onclick='{4}' class='k-button k-button-icontext asf-button {0}' id='{1}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='asf-button-text {2}'>{3}</span></a>",
                buttonClass,
                buttonID,
                spanClass,
                buttonCaption,
                onclickFunction);
        };

        this.getDeleteAsoftButton = function (buttonID, onclickFunction) {
            return kendo.format("<a id='{0}' onclick='{1}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>",
                buttonID,
                onclickFunction);
        };

        this.getAsoftAddNewButton = function (buttonID, onclickFunction) {
            return kendo.format("<a onclick='{1}' class='asfbtn-item-32 k-button k-button-icon' id='{0}' data-role='button' role='button' style='min-width:35px; margin-left:5px;' aria-disabled='false' tabindex='0'><span class='k-sprite asf-icon asf-icon-32 asf-i-add-32'>{3}</span></a>",
                buttonID,
                onclickFunction);
        };

        return this;
    }


var ListChoose = {

    "Member": function (result) {

        $("#MemberName").val(result["MemberName"]);

        $("#MemberID").val(result["MemberID"]);

        $("#Tel").val(result.Tel);
        $("#Address").val(result.Address);
    }
},

    currentChoose = null;

var gridBindFunc = {

    edit: function (e) {
        e.preventDefault();

        var col = e.sender.columns[e.container.context.cellIndex];

        var curColName = col ? col.field : "";

        // Kiểm tra cột InventoryID có cho phép edit chỉnh sửa hay không
        // Nếu tường IsPackage == 1 thì không cho phép chỉnh sửa vì đã chọn từ gói package bên cột PackageID
        if ((curColName == "PackageID" || curColName == "InventoryID") && e.model.IsPackage == 1) {
            e.sender.closeCell();
        }

        // Kiểm tra cột PackageID trên lưới nếu IsInventory == 1 thì không cho nhập cột PackageID
        else if (curColName == "PackageID" && e.model.IsInventory == 1) {
            e.sender.closeCell();
        }

        // Kiểm tra có phải là cột delete hay khônh
        else if (e.container.context.firstElementChild && e.container.context.firstElementChild.getAttribute("onclick") === "deleteDetail_Click(this,'POST2011')") {
            var sender = e.sender;

            // Kiểm tra trên lưới nếu số dòng == 1 thì xử lý sự kiện sau
            if (sender.dataSource.data().length == 1) {
                var dataItem = sender.dataItem(sender.select());

                // Xóa dòng đó đi
                sender.dataSource.remove(dataItem);

                // Và add lại dòng mới
                sender.dataSource.add({});

                // Đồng bộ source
                sender.dataSource.sync();
            }
        }

        return false;
    },
    onChange: function (e) {
        var selectitem = Grid.dataItem(Grid.select());
        var column = e.target.id;
        switch (column) {
            case "cbbPackageID": {
                var combobox = $("#cbbPackageID").data("kendoComboBox");

                if (combobox) {
                    var packageId = e.target.value;
                    var voucherDate = $("#VoucherDate").data("kendoDatePicker").value();
                    ASOFT.helper.postTypeJson("/POS/POSF2010/GetDataRowsOnGridPackage", { PackageID: packageId, VoucherDate: voucherDate }, function (result) {
                        if (result) {
                            var dataObject = JSON.parse(result);

                            selectitem.set("InventoryID", dataObject[0].InventoryID);
                            selectitem.set("InventoryName", dataObject[0].InventoryName);
                            selectitem.set("IsPackage", dataObject[0].IsPackage);
                            selectitem.set("PackageID", dataObject[0].PackageID);
                            selectitem.set("PackageName", dataObject[0].PackageName);
                            selectitem.set("PackagePriceID", dataObject[0].PackagePriceID);
                            selectitem.set("ShopID", dataObject[0].ShopID);
                            selectitem.set("UnitID", dataObject[0].UnitID);
                            selectitem.set("UnitName", dataObject[0].UnitName);
                            selectitem.set("UnitPrice", dataObject[0].UnitPrice);
                            selectitem.set("VATPercent", dataObject[0].VATPercent || 10);
                            selectitem.set("ActualQuantity", dataObject[0].ActualQuantity || 1);

                            selectitem.set("Amount", calculatedValuesOnGrids("*", selectitem.get("UnitPrice"), selectitem.get("ActualQuantity"), 0));
                            selectitem.set("DiscountAmount", calculatedValuesOnGrids("*", selectitem.get("Amount"), selectitem.get("DiscountRate"), 0) / 100);
                            selectitem.set("InventoryAmount", calculatedValuesOnGrids("-", selectitem.get("Amount"), selectitem.get("DiscountAmount"), selectitem.get("Amount")));
                            selectitem.set("TaxAmount", calculatedValuesOnGrids("*", selectitem.get("InventoryAmount"), selectitem.get("VATPercent"), 0) / 100);

                            for (var i = 1; i < dataObject.length; i++) {
                                if (dataObject[i]) {
                                    dataObject[i].VATPercent = 10;
                                    dataObject[i].ActualQuantity = dataObject[i].ActualQuantity || 1;
                                    dataObject[i].Amount = calculatedValuesOnGrids("*", dataObject[i].UnitPrice, dataObject[i].ActualQuantity);
                                    dataObject[i].DiscountAmount = calculatedValuesOnGrids("*", dataObject[i].Amount, dataObject[i].DiscountRate, 0) / 100;
                                    dataObject[i].InventoryAmount = calculatedValuesOnGrids("-", dataObject[i].Amount, dataObject[i].DiscountAmount, dataObject[i].Amount);
                                    dataObject[i].TaxAmount = calculatedValuesOnGrids("*", dataObject[i].InventoryAmount, dataObject[i].VATPercent, 0) / 100;
                                    Grid.dataSource.add(dataObject[i]);
                                    Grid.dataSource.sync();
                                }
                            }
                        }
                    });

                }
                break;
            }
            case "ActualQuantity": {
                selectitem.set("ActualQuantity", e.target.value);
                selectitem.set("Amount", calculatedValuesOnGrids("*", selectitem.get("UnitPrice"), selectitem.get("ActualQuantity"), 0));
                selectitem.set("DiscountAmount", calculatedValuesOnGrids("*", selectitem.get("Amount"), selectitem.get("DiscountRate"), 0) / 100);
                selectitem.set("InventoryAmount", calculatedValuesOnGrids("-", selectitem.get("Amount"), selectitem.get("DiscountAmount"), selectitem.get("Amount")));
                selectitem.set("TaxAmount", calculatedValuesOnGrids("*", selectitem.get("InventoryAmount"), selectitem.get("VATPercent"), 0) / 100);
                break;
            }
            case "DiscountRate": {
                selectitem.set("DiscountRate", e.target.value);
                selectitem.set("Amount", calculatedValuesOnGrids("*", selectitem.get("UnitPrice"), selectitem.get("ActualQuantity"), 0));
                selectitem.set("DiscountAmount", calculatedValuesOnGrids("*", selectitem.get("Amount"), selectitem.get("DiscountRate"), 0) / 100);
                selectitem.set("InventoryAmount", calculatedValuesOnGrids("-", selectitem.get("Amount"), selectitem.get("DiscountAmount"), selectitem.get("Amount")));
                selectitem.set("TaxAmount", calculatedValuesOnGrids("*", selectitem.get("InventoryAmount"), selectitem.get("VATPercent"), 0) / 100);
                break;
            }
            case "VATPercent": {
                selectitem.set("VATPercent", e.target.value);
                selectitem.set("Amount", calculatedValuesOnGrids("*", selectitem.get("UnitPrice"), selectitem.get("ActualQuantity"), 0));
                selectitem.set("DiscountAmount", calculatedValuesOnGrids("*", selectitem.get("Amount"), selectitem.get("DiscountRate"), 0) / 100);
                selectitem.set("InventoryAmount", calculatedValuesOnGrids("-", selectitem.get("Amount"), selectitem.get("DiscountAmount"), selectitem.get("Amount")));
                selectitem.set("TaxAmount", calculatedValuesOnGrids("*", selectitem.get("InventoryAmount"), selectitem.get("VATPercent"), 0) / 100);
                break;
            }
        }

    },
    onFocus: function (e) {
        e.preventDefault();
    }
}

function receiveResult(result) {
    this[ListChoose[currentChoose](result)];
}

$(document).ready(function () {

    var templateButton = new templateAsoftButton();

    var cbSaleManId = $("#SaleManID").data("kendoComboBox");
    cbSaleManId.value(ASOFTEnvironment.UserID);

    var cbPaymentId = $("#PaymentID").data("kendoComboBox");

    var isUpdate = $("#isUpdate").val();

    if (isUpdate === "False") {

        var defaultValue = "";

        if (cbPaymentId.dataSource.data() && cbPaymentId.dataSource.data().length > 0) {
            defaultValue = cbPaymentId.dataSource.data()[0].PaymentID;
        }
    }

    var ams = $("#PaymentObjectAmount01, #PaymentObjectAmount02");

    ams.bind("change", function (e) {

        var am01 = parseFloat($("#PaymentObjectAmount01").val().split(",").join("")) || 0;
        var am02 = parseFloat($("#PaymentObjectAmount02").val().split(",").join("")) || 0;

        var total = am01 + am02;

        if (total) {
            $("#BookingAmount").val(total).focusin().focusout();
        }
        else {
            $("#BookingAmount").val("").focusin().focusout();
        }
    }).css({
        "text-align": "right"
    });

    cbPaymentId
        .bind("change", function (e) {

            var dataRow = e.sender.dataItem();

            if (dataRow) {
                $("#APKPaymentID").val(dataRow.APK);

                if (!dataRow.PaymentName01) {
                    $("#PaymentObjectAmount01").attr("disabled", true);
                    $(".PaymentObjectAmount01").css({
                        display: "none"
                    })
                }
                else {
                    $("#PaymentObjectAmount01").removeAttr("disabled");
                    $(".PaymentObjectAmount01").removeAttr("style").find("label[for=PaymentObjectAmount01]").text(dataRow.PaymentName01);
                }

                if (!dataRow.PaymentName02) {
                    $("#PaymentObjectAmount02").attr("disabled", true);
                    $(".PaymentObjectAmount02").css({
                        display: "none"
                    });
                }
                else {
                    $("#PaymentObjectAmount02").removeAttr("disabled");
                    $(".PaymentObjectAmount02").removeAttr("style").find("label[for=PaymentObjectAmount02]").text(dataRow.PaymentName02);
                }
            }

            ams.val("").trigger("change");
        })
        .bind("open", function (e) {
            ASOFT.helper.postTypeJson("/POS/POSF2010/GetDataPayment", {}, function (result) {
                if (result) {
                    cbPaymentId.setDataSource(result);
                }
            });
        });

    if (isUpdate == "False") {
        cbPaymentId.value(defaultValue);
        cbPaymentId.trigger("change");
    }

    else {
        cbPaymentId.trigger("open");
        var dataRow = cbPaymentId.dataItem();

        if (dataRow) {
            $("#APKPaymentID").val(dataRow.APK);

            if (!dataRow.PaymentName01) {
                $("#PaymentObjectAmount01").attr("disabled", true);
                $(".PaymentObjectAmount01").css({
                    display: "none"
                });
            }
            else {
                $("#PaymentObjectAmount01").removeAttr("disabled");
                $(".PaymentObjectAmount01").removeAttr("style").find("label[for=PaymentObjectAmount01]").text(dataRow.PaymentName01);
            }

            if (!dataRow.PaymentName02) {
                $("#PaymentObjectAmount02").attr("disabled", true);
                $(".PaymentObjectAmount02").css({
                    display: "none"
                });
            }
            else {
                $("#PaymentObjectAmount02").removeAttr("disabled");
                $(".PaymentObjectAmount02").removeAttr("style").find("label[for=PaymentObjectAmount02]").text(dataRow.PaymentName02);
            }
        }

    }

    $("#MemberName")
        .focusin(function (e) { $(this).blur(); })
        .css({
            width: "70%"
        })
        .parent()
        .append(templateButton.getAsoftButton("", "btnMember", "", "...", "btnChooseMember_click()"))
        .append(templateButton.getAsoftAddNewButton("btnAddNewMember", "btnAddNewMember_click()"));

    $("#btnAddNewMember").children().css({
        "position": "relative"
    });

    $("#BookingAmount").attr("readonly", true)
        .css({
            cursor: "not-allowed",
            "text-align": "right"
        });

    whenDocumentReady();

    if (GRID_AUTOCOMPLETE) {
        GRID_AUTOCOMPLETE.config({
            gridName: 'GridEditPOST2011',
            inputID: 'autocomplete-box',
            NameColumn: "InventoryID",
            autoSuggest: false,
            serverFilter: true,
            setDataItem: function (selectedRowItem, dataItem) {

                selectedRowItem.model.set("ShopID", dataItem.ShopID);
                selectedRowItem.model.set("InventoryID", dataItem.InventoryID);
                selectedRowItem.model.set("InventoryName", dataItem.InventoryName);
                selectedRowItem.model.set("UnitID", dataItem.UnitID);
                selectedRowItem.model.set("UnitName", dataItem.UnitName);
                selectedRowItem.model.set("UnitPrice", dataItem.UnitPrice);
                selectedRowItem.model.set("ActualQuantity", dataItem.ActualQuantity || 1);
                selectedRowItem.model.set("DiscountAmount", dataItem.DiscountAmount);
                selectedRowItem.model.set("TaxAmount", dataItem.TaxAmount);
                selectedRowItem.model.set("VATGroupID", dataItem.VATGroupID);
                selectedRowItem.model.set("VATPercent", dataItem.DepositVATPercent || 10);
                selectedRowItem.model.set("DiscountRate", dataItem.DiscountRate);
                selectedRowItem.model.set("IsInventory", 1);

                selectedRowItem.model.set("Amount", calculatedValuesOnGrids("*", selectedRowItem.model.get("UnitPrice"), selectedRowItem.model.get("ActualQuantity"), 0));
                selectedRowItem.model.set("DiscountAmount", calculatedValuesOnGrids("*", selectedRowItem.model.get("Amount"), selectedRowItem.model.get("DiscountRate"), 0) / 100);
                selectedRowItem.model.set("InventoryAmount", calculatedValuesOnGrids("-", selectedRowItem.model.get("Amount"), selectedRowItem.model.get("DiscountAmount"), selectedRowItem.model.get("Amount")));
                selectedRowItem.model.set("TaxAmount", calculatedValuesOnGrids("*", selectedRowItem.model.get("InventoryAmount"), selectedRowItem.model.get("VATPercent"), 0) / 100);
            }
        });
    }

    var Grid = $("#GridEditPOST2011").data("kendoGrid");

    // Xử lý sự kiện edit trên lưới
    Grid.bind("edit", gridBindFunc.edit);
    Grid.bind("focus", gridBindFunc.onFocus);
    // Cho body
    $(Grid.tbody).on("change", "td", gridBindFunc.onChange);

});


function GetVoucherNo() {
    ASOFT.helper.postTypeJson("/POS/POSF2010/GetVoucherNo", {}, function (result) {
        if (result) {
            $("#VoucherNo").val(result);
        }
    });
}

function btnChooseMember_click() {

    var divisionID = $("#EnvironmentDivisionID").val(),

        urlPopup = ["/PopupSelectData/Index/POS/POSF00761", "?", "DivisionID=", divisionID].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});

    currentChoose = "Member";
}

function btnAddNewMember_click() {

    var divisionId = $("#EnvironmentDivisionID").val();

    var urlPopup = ["/POS/POSF0011/POSF00111?DivisionID=", divisionId].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});


}


function calculatedValuesOnGrids(type, value1, value2, defaultValue) {

    var p1 = parseFloat(value1),
        p2 = parseFloat(value2);

    if ($.isNumeric(p1) && $.isNumeric(p2)) {
        switch (type) {
            case "+": {
                return (p1 + p2)
                break;
            }
            case "-": {
                return (p1 - p2);
                break;
            }
            case "*": {
                return (p1 * p2);
                break;
            }
            case "%": {
                return (p1 % p2);
                break;
            }
        }
    }

    if (defaultValue || defaultValue === 0) return defaultValue;

    return NaN;
}



function onAfterInsertSuccess(result, action) {
    if (result.Status == 0) {
        if (action == 1 || action == 2) {
            GetVoucherNo();
            $("#VoucherDate").data("kendoDatePicker").value(new Date());
        }
    }
}


function whenDocumentReady() {



    var screenId = window.parent.document.getElementById("sysScreenID").value;
    switch (screenId) {
        case "POSF2010": {
            insertDefaultValues();
            break;
        }
        case "POSF2012": {
            $("#VoucherNo").removeAttr("readonly");
            break;
        }
    }

    return false;
}

function insertDefaultValues() {
    $("#VoucherDate").data("kendoDatePicker").value(new Date());
    GetVoucherNo();
}


function CustomerCheck() {

    var check = false;
    var message = [];

    var grid = $("#GridEditPOST2011").data("kendoGrid");

    for (i = 0; i < grid.dataSource.data().length; i++) {
        var itemGrid = grid.dataSource.at(i);
        if (!itemGrid.MemberToTake && !itemGrid.DeliveryToMemberID) {
            var tr = grid.tbody.find('tr')[i];
            $($(tr).find('td')[1]).addClass('asf-focus-input-error');
            $($(tr).find('td')[2]).addClass('asf-focus-input-error');
            check = true;
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[1]).attr("data-title")));
            message.push(ASOFT.helper.getMessage('00ML000039').f($($(grid.thead).find('th')[2]).attr("data-title")));
        }
    }

    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message.slice(0, 2));
    }
    return check;

}


function hideFieldOrShowField() {

}


