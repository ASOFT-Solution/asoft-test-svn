"use strict";

(async function (window, $, _as, require) {
    require(["/Scripts/lib/button.asoft.js"], function (result) {
        var screenID = parent.$("#sysScreenID").val() || parent.$("#currentController").val();
        if(!(screenID == "POSF0016"))
        {
            onCreate(result);
        }
    });

    $(document).ready(function () {
        gridOnCreate();

        const Grid = $("#GridEditPOST00802").data("kendoGrid");
        $(Grid.tbody).on("focusin keyup", function (e) {
            const target = e.target;
            if (target && target.id && target.id === "MemberID") {
                $("#MemberID").val(target.value);
            }
        });

        $("#DivisionID").val(ASOFTEnvironment.DivisionID);

        $("#EmployeeName")
            .attr("readonly", true)
            .on("focusin hover", function () { $(this).blur().css("cursor", "not-allowed"); });

        document.getElementById("isUpdate").value == "False" ? autoFilter() : false;

        if(parent.document.getElementById("currentController").value == "POSF0016" || document.getElementById("apkValuePOSF16") != null)
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

    async function onCreate(result) {

        const { Button } = result;
        const btnInherit = new Button("btnInherit", "btnInherit", "k-button k-button-icontext", openPopupInherit).createButton();
        const btnOpenPopup = new Button("btnEmployeeOpen", "btnEmployeeOpen", "k-button k-button-icontext", openPopup).createButton();
        const btnDelete = Button.asoftButton("btnEmployeeDelete", "btnEmployeeDelete", "", deleteEmployee).createDeleteButton();

        appendToTable(btnInherit);
        appendToTd(btnDelete, btnOpenPopup);

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

    async function appendToTable(button) {

        const inheritField = document.getElementById("InheritButton");
        inheritField.style.display = "none";

        const parent = inheritField.parentNode;


        parent.appendChild(button.getHtmlButton());

        /* const tr = document.createElement("tr");
        const td1 = document.createElement("td");
        const label = document.createElement("label");

        label.className = "asf-td-caption";
        label.innerText = "Add Language here";

        td1.appendChild(label);
        td1.className = "asf-td-caption";

        const td2 = document.createElement("td");
        td2.className = "asf-td-field";
        td2.appendChild(button.getHtmlButton());

        tr.appendChild(td1);
        tr.appendChild(td2);

        const parentTBody = document.getElementsByClassName("VoucherDate")[0].parentNode;

        parentTBody.appendChild(tr); */
    }

}(window, $, ASOFT, require))

function dataBinddingToGrid(data) {
    const Grid = $("#GridEditPOST00802").data("kendoGrid");

    const item = Object.assign({
        PayAmount: data.SumAmount,
        VoucherNoInherited: data.VoucherNo
    }, data);

    if (Grid.dataSource.data() && Grid.dataSource.data().length == 1) {
        if (!Grid.dataSource.data()[0].MemberID) {
            Grid.dataSource.remove(Grid.dataSource.data()[Grid.dataSource.data.length - 1]);
        }
    }

    Grid.dataSource.add(item);
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

function onAfterInsertSuccess(result, action1) {
    if (result.Message == "00ML000053") {
        getVoucherNo(true);
    }
}


function getVoucherNo(isUnique) {

    var data = [];
    data.push($("#VoucherTypeID").val());
    data.push($("#VoucherNo").val());


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
    $("#isUpdate").val("false");
    var url = "/GridCommon/InsertPopupMasterDetail/POS/POSF0081";
    action = 4;
    save(url);
}

function autoFilter() {
    
            document.getElementById("EmployeeName").value = ASOFTEnvironment.UserName;
            document.getElementById("EmployeeID").value = ASOFTEnvironment.UserID;
    
            $("#VoucherDate").data("kendoDatePicker").value(new Date());
    
            const $voucherTypeId = $("#VoucherTypeID");
    
            $voucherTypeId.on("change", function () {
    
                getVoucherNo(false);
    
            });
    
            //$voucherTypeId.data("kendoComboBox").select(0);
    
            $voucherTypeId.trigger("change");
    
    
    
        }

function CustomerCheck(){
    var check = false;
    var message = [];
    $('#' + id + ' .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#' + id + ' .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');
    var grid = $("#GridEditPOST00802").data("kendoGrid");
    for(i = 0 ; i < grid.dataSource.data().length; i++){
        var itemGrid = grid.dataSource.at(i);
        var amountValue = itemGrid.Amount;
        var payAmountValue = itemGrid.PayAmount;
        if(amountValue > payAmountValue){
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
        action = 1 ? autoFilter(): false; 
    }
}

