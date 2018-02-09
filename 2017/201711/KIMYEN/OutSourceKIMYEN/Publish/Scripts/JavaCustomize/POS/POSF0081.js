"use strict";

var VoucherTypeID;
var cachedDataSource = {
    inheritSaleVoucher: new kendo.data.DataSource({
        data: [{}]
    }),
    inheritDepositVoucher: new kendo.data.DataSource({
        data: [{}]
    }),
};

(async function (window, $, _as, require) {
    require(["/Scripts/lib/button.asoft.js"], function (result) {
        var screenID = parent.$("#sysScreenID").val() || parent.$("#currentController").val();
        if(!(screenID === "POSF0016"))
        {
            onCreate(result);
        }
    });

    $(document).ready(function () {

        var Grid = $("#GridEditPOST00802").data("kendoGrid");

        $("#IsDeposit").removeAttr("data-val-required").insertBefore($("label[for=InheritDepositButton]")).bind("change", function () {

            if ($(this).is(":checked")) {
                $("#btnInheritDeposit").removeProp("disabled").css({
                    cursor: "pointer",
                    opacity: "1"
                });

                $("#btnInherit").prop("disabled", true).css({
                    cursor: "not-allowed",
                    opacity: "0.5"
                });

                Grid.setDataSource(cachedDataSource.inheritDepositVoucher);
                Grid.dataSource.sync();
                return false;
            }

            $("#btnInheritDeposit").prop("disabled", true).css({
                cursor: "not-allowed",
                opacity: "0.5"
            });

            $("#btnInherit").removeProp("disabled").css({
                cursor: "pointer",
                opacity: "1"
            });

            Grid.setDataSource(cachedDataSource.inheritSaleVoucher);
            Grid.dataSource.sync();

            return false;
        });

        var cbPaymentId = $("#PaymentID").data("kendoComboBox");

        var isUpdate = $("#isUpdate").val();

        if (!cbPaymentId.value()) {

            var defaultValue = "";

            if (cbPaymentId.dataSource.data() && cbPaymentId.dataSource.data().length > 0) {
                defaultValue = cbPaymentId.dataSource.data()[0].PaymentID;
                cbPaymentId.value(defaultValue);
            }
        }

        cbPaymentId.bind("open", function (e) {
            ASOFT.helper.postTypeJson("/POS/POSF2010/GetDataPayment", {}, function (result) {
                if (result) {
                    cbPaymentId.setDataSource(result);
                }
            });
        }).bind("change", function (e) {
            var dataRow = e.sender.dataItem();
            if (dataRow) {
                $("#APKPaymentID").val(dataRow.APK);
            }
        }).trigger("open");

        $(".IsDeposit").remove();

        $(".CashierID").insertBefore(".InheritButton");

        $(".EmployeeName").insertBefore(".CashierID");

        gridOnCreate();

        VoucherTypeID = $("#VoucherTypeID").val();
        if (isUpdate == "False") {
            autoFilter();
        }

        var Grid = $("#GridEditPOST00802").data("kendoGrid");

        Grid.bind("edit", function (e) {

            e.preventDefault();

            if (e.container.context.firstElementChild && e.container.context.firstElementChild.getAttribute("onclick") === "deleteDetail_Click(this,'POST00802')") {
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
        });

        $(Grid.tbody).on("focusin keyup", function (e) {
            const target = e.target;
            if (target && target.id && target.id === "MemberID") {
                $("#MemberID").val(target.value);
            }
        }).on("change", "td", function (e) {
            var selectitem = Grid.dataItem(Grid.select());
            var column = e.target.id;
            if (column === "Amount" && !selectitem.VoucherNoInherited || !selectitem.PayAmount) {
                selectitem.set("PayAmount", e.target.value);
            }
        });

        $("#DivisionID").val(ASOFTEnvironment.DivisionID);

        $("#EmployeeName")
            .attr("readonly", true)
            .on("focusin hover", function () { $(this).blur().css("cursor", "not-allowed"); });

        if (parent.document.getElementById("currentController").value == "POSF0016" && (document.getElementById("apkValuePOSF16") && document.getElementById("apkValuePOSF16").value))
        {
            autoFilter();

            $("#BtnSave").unbind();
            $("#BtnSave").kendoButton({
                "click": SaveCustom_Click
            });
            $("#Close").unbind();
            $("#Close").kendoButton({
                "click": popupClose_Click,
            });

            $("#isUpdate").val("False");
        }

    });

    function gridOnCreate() {

        /* const Grid = $("#GridEditPOST00802").data("kendoGrid");
        $(Grid.tbody).on("change", "td", gridOnChange); */
        if (GRID_AUTOCOMPLETE) {
            GRID_AUTOCOMPLETE.config({
                gridName: 'GridEditPOST00802',
                inputID: 'autocomplete-box',
                NameColumn: "MemberID",
                autoSuggest: false,
                serverFilter: true,
                setDataItem: function (selectedRowItem, dataItem) {

                    selectedRowItem.model.set("MemberID", dataItem.MemberID);
                    selectedRowItem.model.set("MemberName", dataItem.MemberName);
                    selectedRowItem.model.set("Amount", dataItem.Amount);
                    selectedRowItem.model.set("VoucherNoInherited", dataItem.VoucherNoInherited);
                    selectedRowItem.model.set("PayAmount", dataItem.PayAmount);
                }
            });
        }
    }

    function gridOnChange(e) {
    }

    function openPopupInherit() {

        const urlPopupInherit = ["/PopupSelectData/Index/POS/POSF0083", "?", "DivisionID=", divisionID].join("");

        ASOFT.form.clearMessageBox();

        ASOFT.asoftPopup.showIframe(urlPopupInherit, {});
    }

    function openPopupInheritDeposit() {

        const urlPopupInherit = ["/PopupSelectData/Index/POS/POSF2013", "?", "DivisionID=", divisionID].join("");

        ASOFT.form.clearMessageBox();

        ASOFT.asoftPopup.showIframe(urlPopupInherit, {});
    }

    async function onCreate(result) {

        const { Button } = result;
        const btnInherit = new Button("btnInherit", "btnInherit", "k-button k-button-icontext", openPopupInherit).createButton();
        const btnInheritDeposit = new Button("btnInheritDeposit", "btnInheritDeposit", "k-button k-button-icontext", openPopupInheritDeposit).createButton();
        const btnOpenPopup = new Button("btnEmployeeOpen", "btnEmployeeOpen", "k-button k-button-icontext", openPopup).createButton();
        const btnDelete = Button.asoftButton("btnEmployeeDelete", "btnEmployeeDelete", "", deleteEmployee).createDeleteButton();
    
        appendToTable(btnInherit, "InheritButton");
        appendToTable(btnInheritDeposit, "InheritDepositButton");
        appendToTd(btnDelete, btnOpenPopup);
        if ($("#isUpdate").val() == "True") {
            var grid = $("#GridEditPOST00802").data("kendoGrid");
            if ($("#IsDeposit").is(":checked")) {
                cachedDataSource.inheritDepositVoucher.data(grid.dataSource.data());

                cachedDataSource.inheritDepositVoucher.sync();
            }
            else {
                cachedDataSource.inheritSaleVoucher.data(grid.dataSource.data());

                cachedDataSource.inheritSaleVoucher.sync();
            }
        }
        $("#IsDeposit").trigger("change");
}

function deleteEmployee() {
    const inputEmployeeID = document.getElementById("EmployeeID");
    const inputEmployeeName = document.getElementById("EmployeeName");
    inputEmployeeID.value = "";
    inputEmployeeName.value = "";
}

async function openPopup() {

    const divisionID = $("#EnvironmentDivisionID").val(),

        urlPopup = ["/PopupSelectData/Index/POS/CMNF9003", "?", "DivisionID=", divisionID].join("");

    ASOFT.form.clearMessageBox();

    ASOFT.asoftPopup.showIframe(urlPopup, {});
}

async function appendToTd(btnDelete, btnPopup) {

    const employeeInput = document.getElementById("EmployeeName");
    const td = employeeInput.parentNode;
    const htmlBtnDelete = btnDelete.getHtmlButton();
    const htmlBtnPopup = btnPopup.getHtmlButton();

    // Set style 
    employeeInput.style.width = "70%";
    htmlBtnDelete.style.position = "relative";
    htmlBtnPopup.style.position = "relative";

    // Append
    td.appendChild(htmlBtnPopup);
    td.appendChild(htmlBtnDelete);

}

async function appendToTable(button, fieldId) {

    const inheritField = document.getElementById(fieldId);
    inheritField.style.display = "none";

    const parent = inheritField.parentNode;


    parent.appendChild(button.getHtmlButton());
}

}(window, $, ASOFT, require))

function dataBinddingToGrid(data) {
    const Grid = $("#GridEditPOST00802").data("kendoGrid");

    const item = Object.assign({
        PayAmount: data.SumAmount,
        VoucherNoInherited: data.VoucherNo
    }, data);

    var newDataSource = new kendo.data.DataSource({
        data: []
    });

    newDataSource.add(item);
    newDataSource.sync();

    cachedDataSource.inheritSaleVoucher = newDataSource;

    Grid.setDataSource(cachedDataSource.inheritSaleVoucher);
    Grid.dataSource.sync();

}

function receiveResult(result) {

    if (result.Inherit && result.data) {
        dataBinddingToGrid(result.data);
        return false;
    }
    else {
        const inputEmployeeID = document.getElementById("EmployeeID");
        const inputEmployeeName = document.getElementById("EmployeeName");
        inputEmployeeID.value = result.EmployeeID;
        inputEmployeeName.value = result.EmployeeName;
    }


}


function receiveResultInheritedDeposit(result) {
    if (result.Inherit && result.data) {

        const Grid = $("#GridEditPOST00802").data("kendoGrid");

        result.data.PayAmount = 0;
        result.data.DepositVoucherNo = result.data.VoucherNo;

        var newDataSource = new kendo.data.DataSource({
            data: []
        });

        newDataSource.add(result.data);

        newDataSource.sync();

        cachedDataSource.inheritDepositVoucher = newDataSource;

        Grid.setDataSource(cachedDataSource.inheritDepositVoucher);
        Grid.dataSource.sync();

    }
}


function getVoucherNo(isUnique) {

    var data = [];
    data.push($("#VoucherTypeID").val() || VoucherTypeID);
    data.push($("#VoucherNo").val());

    if(isUnique)
    {
        $("#VoucherTypeID").val(VoucherTypeID);
    }

    ASOFT.helper.postTypeJson("/POS/POSF0080/GetVoucherNo", { args: data, isUnique: isUnique }, function (result) {
        $("#VoucherNo").val(result.VoucherNo);
    });

}

function CustomRead() {
    var ct = [];
    if($("#apkValuePOSF16").val() != undefined)
    {
        ct.push($("#apkValuePOSF16").val());
        return ct;
    }
    return null;
}

function SaveCustom_Click() {
    $("#isUpdate").val("False");
    var url = "/GridCommon/InsertPopupMasterDetail/POS/POSF0081";
    action = 4;
    save(url);
}

function autoFilter(isDeleteGridDetail) {
    
    document.getElementById("EmployeeName").value = ASOFTEnvironment.UserName;
    document.getElementById("EmployeeID").value = ASOFTEnvironment.UserID;
    
    $("#VoucherDate").data("kendoDatePicker").value(new Date());

    getVoucherNo(true);

    if(isDeleteGridDetail)
    {
        $("#DivisionID").val(ASOFTEnvironment.DivisionID);
        var $GridEditPOST00802 = $("#GridEditPOST00802").data("kendoGrid");

        cachedDataSource.inheritDepositVoucher.data([{}]);
        cachedDataSource.inheritSaleVoucher.data([{}]);
        $GridEditPOST00802.dataSource.data([{}]);
        $GridEditPOST00802.dataSource.sync();
    }
}

function CustomerCheck(){
    var check = false;
    var message = [];
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
    var grid = $("#GridEditPOST00802").data("kendoGrid");
    for(i = 0 ; i < grid.dataSource.data().length; i++){
        var itemGrid = grid.dataSource.at(i);
        var amountValue = parseFloat(itemGrid.Amount);
        var payAmountValue = parseFloat(itemGrid.PayAmount);
        if (amountValue > payAmountValue && !itemGrid.DepositVoucherNo) {
            var tr = grid.tbody.find('tr')[i];
            $($(tr).find('td')[4]).addClass('asf-focus-input-error');
            $($(tr).find('td')[5]).addClass('asf-focus-input-error');
            check = true;
            message.push(ASOFT.helper.getMessage('POSFML000085').f($($(grid.thead).find('th')[4]).attr("data-title")));
        }
    }
    if (message.length > 0) {
        ASOFT.form.displayMessageBox("form#" + id, message.slice(0, 1));
    }
    return check;
}

function onAfterInsertSuccess(result, action){
    if(result.Status == 0){
        action = 1 ? autoFilter(true): false; 
    }
}

