var GridKPIT10102 = null;

$(document).ready(function () {
    GridKPIT10102 = $("#GridEditKPIT10102").data("kendoGrid");
    $(".grid_6_1").append($(".grid_6 .asf-table-view"));
    //$(".grid_6").remove();
    $(".grid_6_1").attr("class", "alpha");
    GridKPIT10102.hideColumn("DivisionID");

    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }
    else {
        $("#TargetsTypeID[value='1']").prop("checked", true);
    }

    $("#IsCommon").click(function () {
        var isCheckCM = $("#IsCommon").is(":checked");
        nochange(isCheckCM);
        var dataGrid = GridKPIT10102.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            var item = GridKPIT10102.dataSource.at(i);
            item.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : "");
            item.set("DivisionName", isCheckCM ? " " : "");
            item.set("DepartmentID", "");
            item.set("DepartmentName", "");
            item.set("EvaluationPhaseID", "");
            item.set("EvaluationPhaseName", "");
        }
        GridKPIT10102.refresh();
    });

    if ($("#IsCommon").is(":checked")) {
        nochange(true);
    }
    else {
        nochange(false);
    }

    $(GridKPIT10102.tbody).on("change", "td", function (e) {
        var data = null;
        var column = e.target.id;
        var selectitem = GridKPIT10102.dataItem(e.currentTarget.parentElement);
        var cbb = $("#" + column).data("kendoComboBox");
        if (cbb) {
            data = cbb.dataItem(cbb.select());
        }
        if (column == "cbbDivisionName") {
            if (data) {
                selectitem.set("DivisionID", data.DivisionID);
                selectitem.set("DivisionName", data.DivisionName);
                selectitem.set("DepartmentID", null);
                selectitem.set("DepartmentName", null);
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
            }
            else {
                selectitem.set("DivisionID", null);
                selectitem.set("DivisionName", null);
                selectitem.set("DepartmentID", null);
                selectitem.set("DepartmentName", null);
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
            }
            if (selectitem.Goal == null || selectitem.Goal == "") {
                selectitem.set("Goal", 0);
            }
            if (selectitem.Percentage == null || selectitem.Percentage == "") {
                selectitem.set("Percentage", 0);
            }
        }
        if (column == "cbbDepartmentName") {
            if (data) {
                selectitem.set("DepartmentID", data.DepartmentID);
                selectitem.set("DepartmentName", data.DepartmentName);
            }
            else {
                selectitem.set("DepartmentID", null);
                selectitem.set("DepartmentName", null);
            }
        }
        if (column == "cbbEvaluationPhaseName") {
            if (data) {
                selectitem.set("EvaluationPhaseID", data.EvaluationPhaseID);
                selectitem.set("EvaluationPhaseName", data.EvaluationPhaseName);
            }
            else {
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
            }
        }
    })

    GridKPIT10102.bind('dataBound', function (e) {
        var lengthGrid = GridKPIT10102.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var item = GridKPIT10102.dataSource.at(i);
            if (item.LastModifyDate != "" && item.LastModifyDate != null) {
                if (item.LastModifyDate.indexOf("Date") != -1) {
                    var str = kendo.toString(kendo.parseDate(item.LastModifyDate), "dd/MM/yyyy HH:mm:ss");
                    item.set("LastModifyDate", str);
                }
            }
            if (item.CreateDate != "" && item.CreateDate != null) {
                if (item.CreateDate.indexOf("Date") != -1) {
                    var str = kendo.toString(kendo.parseDate(item.CreateDate), "dd/MM/yyyy HH:mm:ss");
                    item.set("CreateDate", str);
                }
            }
            if ($("#IsCommon").is(":checked")) {
                item.set("DivisionName", " ");
                item.set("DivisionID", "@@@");
                if (item.Goal == null || item.Goal == "") {
                    item.set("Goal", 0);
                }
                if (item.Percentage == null || item.Percentage == "") {
                    item.set("Percentage", 0);
                }
            }
            if (item.APK == null || item.APK == "") {
                item.set("APKMaster", "");
                item.set("CreateUserID", "");
                item.set("CreateDate", "");
                item.set("LastModifyUserID", "");
                item.set("LastModifyDate", "");
            }
        }

        //$(GridKPIT10102.tbody).find('td').on("focusin", function (e) {
        //    var index = e.delegateTarget.cellIndex;
        //    var th = $($("#GridEditKPIT10102").find('th')[index]).attr("data-field");
        //    if (th == 'DivisionName' && $("#IsCommon").is(":checked")) {
        //        GridKPIT10102.closeCell();
        //        var prevrow = GridKPIT10102.tbody.find('tr').eq(e.delegateTarget.parentElement.rowIndex);
        //        var cell = $(prevrow).find('td').eq(index + 1);
        //        GridKPIT10102.editCell(cell);
        //    }
        //})
    });

    setTimeout(function () {
        $("#GridEditKPIT10102 .k-grid-content").css("height", "250px");
        $("#GridEditKPIT10102").css("max-height", "300px");
    }, 200)


    if ($("#TargetsTypeID[value='1']").is(":checked")) {
        GridKPIT10102.hideColumn("Goal");
        GridKPIT10102.refresh();
    }
    if ($("#TargetsTypeID[value='2']").is(":checked")) {
        GridKPIT10102.hideColumn("Percentage");
        GridKPIT10102.refresh();
    }

    $("input[type='radio']").change(function () {
        var typeTarget = $(this).val();
        if(typeTarget == 1)
        {
            GridKPIT10102.hideColumn("Goal");
            GridKPIT10102.showColumn("Percentage");
            GridKPIT10102.refresh();
        }
        if (typeTarget == 2) {
            GridKPIT10102.hideColumn("Percentage");
            GridKPIT10102.showColumn("Goal");
            GridKPIT10102.refresh();
        }
    })

    $("#TargetsTypeID[value='1']").parent().after($("#TargetsTypeID[value='2']").parent());
    $("#TargetsTypeID[value='1']").parent().attr("colspan", "1")
    $("#TargetsTypeID[value='2']").parent().attr("colspan", "2")
});

function nochange(isChange) {
    var columns = GridKPIT10102.columns;
    for (var i = 0; i < columns.length; i++) {
        var column = columns[i];
        if (column.field == "DivisionName") {
            var attr = column.attributes;
            attr.editable = isChange ? null : "true";
        }
    }
}

function clearfields() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit"  && key != "TargetsTypeID") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                if ($("#" + key).data('kendoNumericTextBox') != null) {
                    $("#" + key).data('kendoNumericTextBox').value('');
                }
                $("#" + key).val('');
            }
        }
    })
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    if ('Goal' in e.values) {
        if (e.values.Goal == null) {
            e.preventDefault();
        }
    }
    if ('Percentage' in e.values) {
        if (e.values.Percentage == null) {
            e.preventDefault();
        }
    }
    if ('DepartmentName' in e.values) {
        if (e.values.DepartmentName == "") {
            e.preventDefault();
        }
    }
    if ('DepartmentID' in e.values) {
        if (e.values.DepartmentID == "") {
            e.preventDefault();
        }
    }
    if ('EvaluationPhaseID' in e.values) {
        if (e.values.EvaluationPhaseID == "") {
            e.preventDefault();
        }
    }
    if ('EvaluationPhaseName' in e.values) {
        if (e.values.EvaluationPhaseName == "") {
            e.preventDefault();
        }
    }
}

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#TargetsGroupID").val(), TableID: "KPIT10101" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#TargetsGroupID").removeAttr("readonly");
        }
    });
}


function onAfterInsertSuccess(result, action) {
    if (action == 1 && result.Status == 0) {
        $("#TargetsTypeID[value='1']").trigger("click");
    }
    //if (action == 3 && result.Status == 0) {
    //    var url = parent.GetUrlContentMaster();
    //    var listSp = url.split('&');
    //    var division = listSp[listSp.length - 1];
    //    if ($("#IsCommon").is(':checked')) {
    //        url = url.replace(division, "DivisionID=" + "@@@");
    //    }
    //    else {
    //        url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
    //    }
    //    window.parent.parent.location = url;
    //    parent.setReload();
    //}
}

function genDivisionID(data) {
    if (data && data.DivisionID)
    {
        if (data.DivisionID == '@@@') {
            data.DivisionName = " ";
            return " ";
        }
        else
            return data.DivisionName;
    }
    return "";
}