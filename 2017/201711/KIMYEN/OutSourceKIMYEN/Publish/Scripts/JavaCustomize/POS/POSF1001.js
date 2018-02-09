
$(document).ready(function () {



    var data = [
        { checkboxId: "IsColumn", targetId: "PriceColumn" },
        { checkboxId: "IsTable", targetId: "PriceTable" },
        { checkboxId: "IsPackage", targetId: "PackagePriceID" },
        { checkboxId: "IsPromote", targetId: "PromoteID" }
    ];

    changeHtml(data);

    var isCol = $("#IsColumn");
    isCol.trigger("click");
    isCol.attr("disabled", true);

    var cbPriceColumn = $("#PriceColumn").data("kendoComboBox");
    if (!cbPriceColumn.value()) {
        cbPriceColumn.select(0);
    }


});

function createFieldSet(text, tableId) {
    const fieldSet = document.createElement("fieldset");
    const legend = document.createElement("legend");
    const label = document.createElement("label");
    const table = document.createElement("table");
    label.textContent = text;
    table.createTBody();
    table.id = tableId;
    table.style.width = "100%";
    fieldSet.appendChild(legend);
    legend.appendChild(label);
    fieldSet.appendChild(table);
    return fieldSet;
}


function changeHtml(data) {

    triggerValuesForInventoryTypeID();

    data.forEach(function (item, index) {
        $("#" + item.checkboxId)
            .bind("change", function (e) {

                e.preventDefault();

                var combo = $("#" + item.targetId).data("kendoComboBox");

                if (e.currentTarget.checked) {
                    combo.enable(true);
                }
                else {
                    combo.enable(false);
                }

            })
            .trigger("change")
            .parent()
            .addClass("container_quarter")
            .removeAttr("colspan")
            .css({
                "vertical-align": "middle"
            })
            .insertBefore($("#" + item.targetId).parent().parent());

    });

    ["InventoryTypeID", "PromotePriceTable", "ComWarehouseID"].forEach(function (value, index) {
        $("#" + value).parent().parent().attr("colspan", 2);
    });


    $(".TaxDebitAccountID")
        .parent()
        .parent()
        .parent()
        .append(
        createFieldSet(ASOFT.helper.getLanguageString("POSF1001.DebitInfor", "POSF1001", "POS"), "tbDebitInfo"),
        createFieldSet(ASOFT.helper.getLanguageString("POSF1001.PayBillInfo", "POSF1001", "POS"), "tbPayBillInfo")
        );

    $(".CreditAccountID")
        .parent()
        .parent()
        .parent()
        .append(
        createFieldSet(ASOFT.helper.getLanguageString("POSF1001.DebitInfor2", "POSF1001", "POS"), "tbDebitInfo2"),
        createFieldSet(ASOFT.helper.getLanguageString("POSF1001.CostBillInfo", "POSF1001", "POS"), "tbCostBillInfo")
        );


    $(".TaxDebitAccountID").appendTo("#tbDebitInfo");
    $(".TaxCreditAccountID").appendTo("#tbDebitInfo");

    $(".PayDebitAccountID").appendTo("#tbPayBillInfo");
    $(".PayCreditAccountID").appendTo("#tbPayBillInfo");

    $(".DebitAccountID").appendTo("#tbDebitInfo2");
    $(".CreditAccountID").appendTo("#tbDebitInfo2");

    $(".CostDebitAccountID").appendTo("#tbCostBillInfo");
    $(".CostCreditAccountID").appendTo("#tbCostBillInfo");

}


function CustomerCheck() {
    return checkGridAnyCheck();
    return isDuplicateVoucherTypeInfo();
}

function checkGridAnyCheck() {

    var isInvalid = true;

    var grid = $("#GridEditPOST0026").data("kendoGrid");

    var data = grid.dataSource.data();

    for (var i = 0; i < data.length; i++) {
        if (data[i] && data[i].Selected) {
            isInvalid = false;
            break;
        }
    }

    if (isInvalid) ASOFT.form.displayMessageBox("form#" + "POSF1001", [ASOFT.helper.getMessage("POSFML000067")]);

    return isInvalid;

}



// Check duplicate voucher type info
function isDuplicateVoucherTypeInfo() {

    var isInValid = false;
    var comboBoxIDs = [
        'VoucherType01',
        'VoucherType02',
        'VoucherType03',
        'VoucherType04',
        'VoucherType05',
        'VoucherType06',
        'VoucherType07',
        'VoucherType08',
        'VoucherType09',
        'VoucherType10',
        'VoucherType11',
        'VoucherType12',
        'VoucherType13',
        'VoucherType14',
        'VoucherType15',
        'VoucherType16',
        'VoucherType17',
        'VoucherType18',
        'VoucherType19',
        'VoucherType20'
    ];
    var duplicateVoucherTypeValues = [];

    resetMessageBox("#POSF1001");

    var uniqueVoucherTypes = [];
    comboBoxIDs.forEach(function (comboBoxId) {
        var comboBox = $("#" + comboBoxId + "_POST0004").data("kendoComboBox");
        if (comboBox) {
            var value = comboBox.value();
            if (value && uniqueVoucherTypes.indexOf(value) > -1) {
                addError(comboBoxId + "_POST0004");
                duplicateVoucherTypeValues.push(value);
                isInValid = true;
            }
            else {
                uniqueVoucherTypes.push(value);
            }

        }
    });

    if (isInValid) ASOFT.form.displayMessageBox("form#" + "POSF1001", [ASOFT.helper.getMessage("POSFML000095")]);

    return isInValid;

}

function resetMessageBox(formSector) {

    $(formSector + ' div.asf-text-message-error').empty();
    $(formSector + ' div.asf-panel-warning').remove();
    $(formSector + ' div.asf-panel-info').remove();

    //$(formSector + ' .k-widget.input-validation-error').removeClass('asf-focus-input-error');
    $(formSector + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $(formSector + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
}

function addError(id) {

    var element = $("#" + id);
    var fromWidget = element.closest(".k-widget");
    var widgetElement = element.closest("[data-" + kendo.ns + "role]");
    var widgetObject = kendo.widgetInstance(widgetElement);

    if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
        fromWidget.addClass('asf-focus-input-error');
        var input = fromWidget.find(">:first-child").find(">:first-child");
        if (input) {
            $(input).addClass('asf-focus-combobox-input-error');
        }
    } else {
        element.addClass('asf-focus-input-error');
    }

}


function triggerValuesForInventoryTypeID() {
    var strValues = $("#InventoryTypeID").attr("value");
    if (strValues) {
        var values = strValues.split(",");
        values.forEach(function (val) {
            $("#InventoryTypeID_listbox").find("input[value=" + val + "]").trigger("click");
        });
    }
}


function onAfterInsertSuccess(result, action) {
    if (action == 4 && result.Status == 0) {
        window.parent.parent.location = ["/ViewMasterDetail2/Index/POS/POSF1002?PK=", $("#ShopID").val(), "&Table=POST0010&key=ShopID&DivisionID=HCM"].join("");
        parent.setReload();
    }
}