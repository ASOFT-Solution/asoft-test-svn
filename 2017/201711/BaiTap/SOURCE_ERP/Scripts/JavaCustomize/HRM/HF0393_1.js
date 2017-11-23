//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/01/2016     Quang Chiến       Tạo mới
//####################################################################

var rowList = null;

$(document).ready(function () {
    if ($("#isUpdate").val() == "True") {
        $("#SeniorityID").prop("readonly", true);
    }

})
function getListDetail(tb) {
    var dataPost1 = ASOFT.helper.dataFormToJSON(id);
    var data = [];
    var dt = getDetail(tb).Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["Orders"] = (i + 1).toString();
        data.push(dt[i]);
    }
    return data;
}

function CustomInsertPopupDetail(datagrid) {
    tableName = []
    tableName.push("HT1028");
    $.each(tableName, function (key, value) {
        datagrid.push(getListDetail(value));
    })
    return datagrid;
}

function CustomRead() {
    var ct = [];
    ct.push($("#SeniorityID").val());
    return ct;
}

function clearfieldsCustomer() {
    $('#SeniorityID').val("");
    $('#DescriptionID').val("");
    $('#Disabled').prop('checked', false);
    $('#GridEditHT1028').data("kendoGrid").dataSource.data([]);
    $('#GridEditHT1028').data("kendoGrid").dataSource.add({});
}

function CustomerCheck() {
    ASOFT.form.clearMessageBox();
    var grid = $('#GridEditHT1028').data('kendoGrid');
    $(grid.tbody).find('td').removeClass('asf-focus-input-error');


    //Check required
    $('#HF0393').removeClass('asf-focus-input-error');

    rowList = grid.tbody.children();
    columnIndexFromValues = grid.wrapper.find(".k-grid-header [data-field=" + "FromValues" + "]").index();
    columnIndexToValues = grid.wrapper.find(".k-grid-header [data-field=" + "ToValues" + "]").index();

    var isCheck = false;
    var lstEmp = [];
    var message = [];
    var num = 0;

    var fromValueInvalid = false;
    var toValueInvalid = false;
    var compareInvalid = false;

    for (var i = 0; i < rowList.length; i++) {
        var row = $(rowList[i]);
        var pFromValue = parseInt(row.children()[columnIndexFromValues].textContent);
        var pToValue = parseInt(row.children()[columnIndexToValues].textContent);
        //Kiểm tra cột pFromValue > 0
        if (pFromValue < 0) {
            $(row.children()[columnIndexFromValues]).addClass('asf-focus-input-error');
            isCheck = true;
            if (!fromValueInvalid) {
                fromValueInvalid = true;
                message.push(ASOFT.helper.getMessage("HFML000548"));
            }
        }
        //Kiểm tra cột pToValue > 0
        if (pToValue < 0) {
            $(row.children()[columnIndexToValues]).addClass('asf-focus-input-error');
            isCheck = true;
            if (!toValueInvalid) {
                toValueInvalid = true;
                message.push(ASOFT.helper.getMessage("HFML000549"));
            }
        }

        //kiểm tra pFromValue <= pToValue
        if (pFromValue > pToValue) {
            $(row.children()[columnIndexFromValues]).addClass('asf-focus-input-error');
            $(row.children()[columnIndexToValues]).addClass('asf-focus-input-error');
            isCheck = true;
            if (!compareInvalid) {
                compareInvalid = true;
                message.push(ASOFT.helper.getMessage("HFML000550"));
            }
        }
    }

    if (isCheck) {
        ASOFT.form.displayMessageBox('#HF0393', message);
    }
    return isCheck;
}