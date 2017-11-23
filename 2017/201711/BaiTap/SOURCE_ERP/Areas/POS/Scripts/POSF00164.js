var rowChoose = null;
var FORM_ID = "POSF00164";
var posGrid = null;
var listRequired = [];
var inventoyID = null;

$(document).ready(function () {
    posGrid = $("#GridInventory").data("kendoGrid");
    inventoyID = window.parent.getInventoyID();
    $("#InventoryID").val(inventoyID.InventoryID);
    $("#InventoryName").val(inventoyID.InventoryName);

    posGrid.bind('dataBound', function () {
        $($('input[name=radio-check]')[0]).trigger('click');
    })
})


function btnSave_Click() {
    if (rowChoose == null) {
        ASOFT.dialog.messageDialog(ASOFT.helper.getMessage('00ML000066'/*'A00ML000003'*/));
        return;
    }
    $('#GridInventory .asf-focus-input-error').removeClass('asf-focus-input-error');
    $('#GridInventory .asf-focus-combobox-input-error').removeClass('asf-focus-combobox-input-error');

    $("#GridInventory").removeClass('asf-focus-input-error');
    ASOFT.asoftGrid.editGridRemmoveValidate(posGrid);

    var columns = posGrid.columns;
    var data = posGrid.dataSource.data();
    var isError = false;
    $(posGrid.tbody).find('td').removeClass('asf-focus-input-error');
    $(posGrid.tbody).find("td").each(function (index, element) {
        var rowIndex = $(element).parent().index();
        var cellIndex = $(element).index();
        var row = data[rowIndex];

        if (row.uid == rowChoose.uid) {
            var column = columns[cellIndex];
            if ($.inArray(column.field, listRequired) == -1 && column.field != "") {
                var value = row[column.field];
                if (value === null || value === '' || value === undefined) {
                    isError = true;
                    $(element).addClass('asf-focus-input-error');
                }
            }// end check edit
        }// end if
    });
    if (isError) {
        var msg = ASOFT.helper.getMessage("00ML000060");
        ASOFT.form.displayError('#POSF00164', msg);
        return;
    }
    var dataPostGet = window.parent.getMaster();
    dataPostGet.InventoryID = $("#InventoryID").val();
    dataPostGet.EmployeeID = inventoyID.EmployeeID;
    dataPostGet.EmployeeName = inventoyID.EmployeeName;
    rowChoose.InventoryID = $("#InventoryID").val();
    rowChoose.InventoryName = $("#InventoryName").val();
    rowChoose.CA = $("#CA").val();
    rowChoose.UnitPrice = inventoyID.UnitPrice;
    rowChoose.ActualQuantity = inventoyID.ActualQuantity;
    rowChoose.UnitID = inventoyID.UnitID;
    dataPostGet.APK = $("#APK").val();
    dataPostGet.SalesManName = inventoyID.SalesManName;
    dataPostGet.DetailPOST00901 = [rowChoose];

    ASOFT.helper.postTypeJson("/POS/POSF0016/SavePOST00901", dataPostGet, function (result) {
        if (result.Status == 0) {
            ASOFT.asoftPopup.closeOnly();
        }
        else {
            var msg = ASOFT.helper.getMessage(result.Message);
            ASOFT.form.displayError('#POSF00164', msg);
        }
    })
}

function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}


function radio_Click(tag) {
    var row = $(tag).parent().closest('tr');
    rowChoose = posGrid.dataItem(row);
}


function sendDataSearch() {
    var dataFilter = ASOFT.helper.dataFormToJSON(FORM_ID);
    dataFilter.CA = $("#CA").val();
    return dataFilter;
}

function inventory_SendData() {
    var dataFilter = ASOFT.helper.dataFormToJSON(FORM_ID);
    dataFilter.CA = $("#CA").val();
    return dataFilter;
}

function inventory_Changed(e) {
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
            "GridInventory",
            posGrid,
            ASOFT.asoftGrid.currentCell,
            ASOFT.asoftGrid.currentRow
        );
    var row = $(e.sender.wrapper.parent().parent());
    var dtRow = posGrid.dataItem(row);
    var dtCbNow = e.sender.dataSource._data[e.sender.selectedIndex];
    dtRow.set("SuggestInventoryID", dtCbNow.SuggestInventoryID);
    dtRow.set("SuggestInventoryName", dtCbNow.SuggestInventoryName);
    dtRow.set("SuggestUnitPrice", dtCbNow.SuggestUnitPrice);
    dtRow.set("SuggestCA", dtCbNow.SuggestCA);
}