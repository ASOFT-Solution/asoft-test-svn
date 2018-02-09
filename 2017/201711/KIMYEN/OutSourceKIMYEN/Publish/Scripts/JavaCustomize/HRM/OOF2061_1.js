//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     05/01/2016     Quang Chiến       Tạo mới
//####################################################################
var urlParent = null;
var key1 = Array();
var value1 = Array();
$(document).ready(function () {
    $('#EmployeeID').prop("readonly", true);
    $('#FullName').prop("readonly", true);

})

OOF2061 = new function () {
    
}

function CustomSavePopupLayout() {
    var custom = [];
    window.parent.IsCheckExecute = true;
    if ($('#ChangeFact').val() == 1) {
        var GridKendo = parent.GetDataGridParent("OOT2060");
        var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
        if (records.length == 0)
            return;
        var custom = [];
        var data = null;        
        var dataFormFilter = sessionStorage.getItem('dataFormFilter');
        var dataFormFilters = JSON.parse(dataFormFilter);
        if (dataFormFilters) {
            data = dataFormFilters;
        } else {
            data = parent.GetDataFormFilter();
        }

        $.each(data, function (key, value) {
            if (key != "item.TypeCheckBox" && key != "Unique") {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                    key1.push(key);
                    var vl = Array();
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    vl.push(data[key + "_Content_DataType"], value);
                    value1.push(vl);
                }
            }
        })

        var datapopup = ASOFT.helper.dataFormToJSON(id);
        datapopup.ChangeFact = $('#ChangeFact').val();

        $.each(datapopup, function (key, value) {
            if (key != "item.TypeCheckBox" && key != "Unique") {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                    key1.push(key);
                    var vl = Array();
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    vl.push(data[key + "_Content_DataType"], value);
                    value1.push(vl);
                }
            }
        })
       
        var numcheck = parent.GetCheckAll();
        value1.push(numcheck);
        key1.push("IsCheckALL");


        var valuepk = [];
        if (numcheck == 0) {
            for (var i = 0; i < records.length; i++) {
                valuepk.push(records[i]["APK"]);
            }
        }


        valuepk = valuepk.join(",");
        value1.push(valuepk);
        key1.push("APKList");

        custom.push(key1, value1);
    }
    else {
        var data = ASOFT.helper.dataFormToJSON(id);
        data.ChangeFact = $('#ChangeFact').val();
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
            if (key != "item.TypeCheckBox" && key != "Unique") {
                if (key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key != "CheckInList") {
                    key1.push(key);
                    var vl = Array();
                    if (value == "false")
                        value = "0";
                    if (value == "true")
                        value = "1";
                    vl.push(data[key + "_Content_DataType"], value);
                    value1.push(vl);
                }
            }
        })

        custom.push(key1, value1);

    }

    return custom;
}

function onAfterSave() {
    parent.refreshGrid();
    parent.popupClose();
}