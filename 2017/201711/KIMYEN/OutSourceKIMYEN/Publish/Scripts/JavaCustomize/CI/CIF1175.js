var GridAT1314 = null;
var NormID = null;
var WareHouseID = null;
var actionCustom = null;
$(document).ready(function () {
    $("#BtnSave").unbind();
    $("#BtnSave").kendoButton({
        "click": CustomSave_Click
    });

    GridAT1314 = $("#GridEditAT1314").data("kendoGrid");
    //GridAT1312.hideColumn("APK");

    $(GridAT1314.tbody).on("change", "td", function (e) {
        var column = e.target.id;
        var selectitem = GridAT1314.dataItem(GridAT1314.select());

        if (column == "cbbNormID") {
            GetCombobox(e.target.value, "NormID", NormID, selectitem);
        }
        if (column == "cbbWareHouseID") {
            GetCombobox(e.target.value, "WareHouseID", WareHouseID, selectitem);
        }
    })

    var rdo1 = $(":input[type='radio'][name='NormMethod']");
    if ($("#IsNorm").is(':checked')) {
        $(rdo1).each(function () {
            $(this).attr("disabled", false);
        })
    }

    $("#IsNorm").click(function () {
        if (GridAT1314.dataSource.data().length > 0 && GridAT1314.dataSource.data()[0].WareHouseID != null)
        {
            $(this).attr("checked", "checked");
            return false;
        }
        if ($(this).is(':checked')) {
            $(rdo1).each(function () {
                $(this).attr("disabled", false);
                $("#NormMethod").attr("checked", true);
                $("#listRequiredAT1314").append('<input id="listRequiredAT1314" name="listRequiredAT1314" type="hidden" value="WareHouseID">');
            })
        }
        else {
            $(rdo1).each(function () {
                $(this).attr("disabled", true);
            })
        }
    })

    $("input[type='radio']").change(function () {
        $("input[type='radio'][checked='checked']").removeAttr("checked");
        $(this).attr("checked", "checked");
        for (i = 0; i < GridAT1314.dataSource.data().length ; i++) {
            var item = GridAT1314.dataSource.at(i);
            item.set("WareHouseID", null);
        }

        if ($(this).val() == 0) {
            $("#listRequiredAT1314").append('<input id="listRequiredAT1314" name="listRequiredAT1314" type="hidden" value="WareHouseID">');
        }
        else {
            $("input[name='listRequiredAT1314'][value='WareHouseID']").remove();
        }
    })

    if ($($("input[type='radio'][name='NormMethod'][checked='checked']")[0]).val() == 0) {
        $("#listRequiredAT1314").append('<input id="listRequiredAT1314" name="listRequiredAT1314" type="hidden" value="WareHouseID">');
    }
    else {
        $("input[name='listRequiredAT1314'][value='WareHouseID']").remove();
    }
        
    GridAT1314.bind('dataBound', function (e) {
        $("#GridEditAT1314").find('td').on("focusin", function (e) {
            if (!$("#IsNorm").is(':checked')) {
                GridAT1314.closeCell();
            }
            else {
                if ($($("input[type='radio'][name='NormMethod'][checked='checked']")[0]).val() == 0)
                {
                    var index = e.delegateTarget.cellIndex;
                    var th = $($("#GridEditAT1314").find('th')[index]).attr("data-field");
                    if (th == 'WareHouseID')
                    {
                        GridAT1314.closeCell();
                    }
                }
            }
        })
    })

    //$(GridAT1314.tbody).on("focusin", "td", function (e) {
    //    var column = e.target.name;
    //    if (column.indexOf("AccountID") != -1) {
    //        var selectitem = GridAT1314.dataItem(GridAT1314.select());
    //        if (selectitem.AccountID == "") {
    //            //$("#cbbAccountID").data("kendoComboBox").value('');
    //            $("#cbbAccountID").data("kendoComboBox").selectedIndex = -1;
    //        }
    //    }
    //})
})

function CustomdeleteDetail_Click() {
    if (GridAT1314.dataSource.data().length == 1 && GridAT1314.dataSource.data()[0].WareHouseID == null)
    {
        $("#IsNorm").attr("checked", false);
        var rdo1 = $(":input[type='radio'][name='NormMethod']");
        $(rdo1).each(function () {
            $(this).attr("disabled", "disabled");
        })
        $("input[name='listRequiredAT1314'][value='WareHouseID']").remove();
    }
}


function GetCombobox(data, column, ana, selectitem) {
    if (data != "" && data != undefined) {
        selectitem.set(column, data);
        if (column == "NormID") {
            var dataNormID = $("#cbb" + column).data("kendoComboBox").dataItem();
            selectitem.set("MinQuantity", dataNormID.MinQuantity);
            selectitem.set("MaxQuantity", dataNormID.MaxQuantity);
            selectitem.set("ReOrderQuantity", dataNormID.ReOrderQuantity);
        }
    }
    else {
        selectitem.set(column, ana);
    }
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values.NormID == "") {
        NormID = e.model.NormID;
    }
    if (e.values.NormID == undefined && e.values.NormID != "" && e.values.NormID == null) {

    }
    if (e.values.WareHouseID == "") {
        WareHouseID = e.model.WareHouseID;
    }
}


function CustomSave_Click() {
    actionCustom = 3;
    var data = ASOFT.helper.dataFormToJSON("CIF1175");
    var datagrid;
    var key = [];
    var value = [];



    if ($("#IsNorm").is(':checked')) {
        if (isInvalid(data)) {
            return false;
        }

        if (isInlistGrid(data)) {
            return false;
        }
    }


    datagrid = getListDetailCustom();

    ASOFT.helper.postTypeJson("/CI/CIF1170/UpdateCIF1175", datagrid, onInsertSuccessCustom);
}

function onInsertSuccessCustom(result) {

    if (result.Status == 0) {
        switch (actionCustom) {
            case 1://save new                
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                //
                refreshModel();
                clearfields();
                break;
            case 2://save copy
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                //refreshModel();
                break;
            case 3:
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                refreshModel();
                window.parent.location.reload();

                //refreshModel();
            case 4:
                updateSuccess = 1;
                ASOFT.form.displayInfo('#' + id, ASOFT.helper.getMessage(result.Message));
                break;
        }
    }
    else {
        updateSuccess = 0;
        if (result.Message != 'Validation') {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + id, msg);
        }
        else {
            var msgData = new Array();
            $.each(result.Data, function (index, value) {
                var child = value.split(',');
                var msg = ASOFT.helper.getMessage(child[0]);
                msg = kendo.format(msg, child[1], child[2], child[3], child[4]);
                msgData.push(msg);
            });
            ASOFT.form.displayMultiMessageBox(id, 1, msgData);
        }
    }
}

function getDetailCustom() {
    var dataPost = ASOFT.helper.dataFormToJSON("CIF1175");
    dataPost.Detail = GridAT1314.dataSource._data;
    dataPost.IsDataChanged = GridAT1314.dataSource.hasChanges()
    return dataPost;
}

function getListDetailCustom() {
    var data = [];
    var dt = getDetailCustom().Detail;
    for (i = 0; i < dt.length; i++) {
        dt[i]["InventoryID"] = $("#InventoryID").val();
        dt[i]["LastModifyDate"] = $("#LastModifyDate").val();
        if ($("#IsNorm").is(':checked')) {
            dt[i]["IsNorm"] = 1;
            dt[i]["NormMethod"] = $($("input[type='radio'][name='NormMethod'][checked='checked']")[0]).val();
            if ($($("input[type='radio'][name='NormMethod'][checked='checked']")[0]).val() == 0)
            {
                dt[i]["WareHouseID"] = "%";
            }
        }
        else {
            dt[i]["IsNorm"] = 0;
        }
        dt[i]["DivisionID"] = parent.getDivisionID();
        data.push(dt[i]);
    }
    return data;
}
