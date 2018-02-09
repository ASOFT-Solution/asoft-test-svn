var actionChoose = null;
var isCheck = true;
var mode = null;
var GridPAT10103 = null;
var GridPAT10102 = null;

$(document).ready(function () {
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }
    $(".grid_6_1").append($(".grid_6 .asf-table-view"));
    //$(".grid_6").remove();
    $(".grid_6_1").attr("class", "alpha");
    GridPAT10103 = $("#GridEditPAT10103").data("kendoGrid");
    GridPAT10102 = $("#GridEditPAT10102").data("kendoGrid");
    GridPAT10103.hideColumn("DivisionID");
    GridPAT10103.hideColumn("DepartmentID");
    GridPAT10103.hideColumn("EvaluationPhaseID");
    $(".k-tabstrip-items").remove();
    $("#Tabs-2").attr("style", "display: block");


    $("#IsCommon").click(function () {
        var isCheckCM = $("#IsCommon").is(":checked");
        nochange(isCheckCM);
        var dataGrid = GridPAT10103.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            var item = GridPAT10103.dataSource.at(i);
            item.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : "");
            item.set("DivisionName", isCheckCM ? " " : "");
            item.set("DepartmentID", "");
            item.set("DepartmentName", "");
            item.set("EvaluationPhaseID", "");
            item.set("EvaluationPhaseName", "");
            item.set("AppraisalGroupID", "");
            item.set("AppraisalGroupName", "");
        }
    });

    if ($("#IsCommon").is(":checked")) {
        nochange(true);
    }
    else {
        nochange(false);
    }

    $(GridPAT10103.tbody).on("change", "td", function (e) {
        var data = null;
        var column = e.target.id;
        var selectitem = GridPAT10103.dataItem(e.currentTarget.parentElement);
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
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
            }
            else {
                selectitem.set("DivisionID", null);
                selectitem.set("DivisionName", null);
                selectitem.set("DepartmentID", null);
                selectitem.set("DepartmentName", null);
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
            }
        }
        if (column == "cbbDepartmentName") {
            if (data) {
                selectitem.set("DepartmentID", data.DepartmentID);
                selectitem.set("DepartmentName", data.DepartmentName);
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
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
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
            }
            else {
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
            }
        }
        if (column == "cbbAppraisalGroupName") {
            if (data) {
                selectitem.set("AppraisalGroupID", data.TargetsGroupID);
                selectitem.set("AppraisalGroupName", data.TargetsGroupName);
            }
            else {
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
            }
        }

        //if (column == "LevelStandardID") {
        //    $("form#" + id + " .asf-message").remove();
        //    $($("#GridEditPAT10103").find('td')).removeClass('asf-focus-input-error');
        //    var lengthGrid = GridPAT10102.dataSource._data.length;
        //    var isStandard = false;
        //    for (var i = 0; i < lengthGrid; i++) {
        //        var item = GridPAT10102.dataSource.at(i);
        //        if (e.target.value == item.LevelStandardID) {
        //            isStandard = true;
        //            break;
        //        }
        //    }
        //    if (!isStandard) {
        //        var msg = ASOFT.helper.getMessage('PAML000003');
        //        ASOFT.form.displayMessageBox("form#" + id, [msg]);
        //        $(e.target.parentElement.parentElement.parentElement).addClass('asf-focus-input-error');
        //    }
        //}
    })

    GridPAT10103.bind('dataBound', function (e) {
        var lengthGrid = GridPAT10103.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var item = GridPAT10103.dataSource.at(i);
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
            }
            if (item.APK == null || item.APK == "") {
                item.set("APKMaster", "");
                item.set("CreateUserID", "");
                item.set("CreateDate", "");
                item.set("LastModifyUserID", "");
                item.set("LastModifyDate", "");
            }
        }
        $("#GridEditPAT10103 .k-grid-content").css("height", "150px");
        $("#GridEditPAT10103").css("max-height", "200px");
    });

    GridPAT10102.bind('dataBound', function (e) {
        var lengthGrid = GridPAT10102.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var item = GridPAT10102.dataSource.at(i);
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

            if (item.APK == null || item.APK == "") {
                item.set("APKMaster", "");
                item.set("CreateUserID", "");
                item.set("CreateDate", "");
                item.set("LastModifyUserID", "");
                item.set("LastModifyDate", "");
            }
        }

        $("#GridEditPAT10102 .k-grid-content").css("height", "100px");
        $("#GridEditPAT10102").css("max-height", "150px");
    });
 })

function nochange(isChange) {
    var columns = GridPAT10103.columns;
    for (var i = 0; i < columns.length; i++) {
        var column = columns[i];
        if (column.field == "DivisionName") {
            var attr = column.attributes;
            attr.editable = isChange ? null : "true";
        }
    }
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
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
    if ('AppraisalGroupID' in e.values) {
        if (e.values.AppraisalGroupID == "") {
            e.preventDefault();
        }
    }
    if ('AppraisalGroupName' in e.values) {
        if (e.values.AppraisalGroupName == "") {
            e.preventDefault();
        }
    }
}

function genDivisionID(data) {
    if (data && data.DivisionID) {
        if (data.DivisionID == '@@@') {
            data.DivisionName = " ";
            return " ";
        }
        else
            return data.DivisionName;
    }
    return "";
}



function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/PA/PAF0000/CheckUsingCommon", { KeyValues: $("#AppraisalID").val(), TableID: "PAT10101" }, function (result) {
        if (result == 1) {
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#AppraisalID").removeAttr("readonly");
        }
    });
}

function CustomerCheck() {
    var length1 = GridPAT10102.dataSource._data.length;
    var length2 = GridPAT10103.dataSource._data.length;

    for (var i = 0; i < length1; i++) {
        var item = GridPAT10102.dataSource.at(i);
        for (var j = 0; j < length1; j++) {
            var item1 = GridPAT10102.dataSource.at(j);
            if (i != j && item.LevelStandardID == item1.LevelStandardID) {
                var msg = ASOFT.helper.getMessage('PAML000002');
                ASOFT.form.displayMessageBox("form#" + id, [msg]);
                var tr = GridPAT10102.tbody.find('tr')[i];
                $(tr).addClass("asf-focus-input-error");
                $(tr).removeClass("k-state-selected")
                var tr1 = GridPAT10102.tbody.find('tr')[j];
                $(tr1).addClass("asf-focus-input-error");
                $(tr1).removeClass('k-state-selected');
                return true;
            }
        }
    }

    for (var i = 0; i < length2; i++) {
        var item = GridPAT10103.dataSource.at(i);
        for (var j = 0; j < length2; j++) {
            var item1 = GridPAT10103.dataSource.at(j);
            if (i != j && item.DivisionID == item1.DivisionID && item.DepartmentID == item1.DepartmentID && item.EvaluationPhaseID == item1.EvaluationPhaseID && item.AppraisalGroupID == item1.AppraisalGroupID)
            {
                var msg = ASOFT.helper.getMessage('PAML000004');
                ASOFT.form.displayMessageBox("form#" + id, [msg]);
                var tr = GridPAT10103.tbody.find('tr')[i];
                $(tr).addClass("asf-focus-input-error");
                $(tr).removeClass("k-state-selected")
                var tr1 = GridPAT10103.tbody.find('tr')[j];
                $(tr1).removeClass('k-state-selected');
                $(tr1).addClass("asf-focus-input-error");
                return true;
            }
        }
    }

    var isStandardAll = false;
    for (var i = 0; i < length2; i++) {
        isStandard = false;
        var item = GridPAT10103.dataSource.at(i);
        for (var j = 0; j < length1; j++) {
            var item1 = GridPAT10102.dataSource.at(j);
            if (item.LevelStandardID == item1.LevelStandardID) {
                isStandard = true;
                break;
            }
        }
        if (!isStandard)
        {
            var tr = GridPAT10103.tbody.find('tr')[i];
            var msg = ASOFT.helper.getMessage('PAML000003');
            ASOFT.form.displayMessageBox("form#" + id, [msg]);
            $(tr).addClass('asf-focus-input-error');
            $(tr).removeClass('k-state-selected');
            isStandardAll = true;
        }
    }

    if (isStandardAll) {
        return isStandardAll;
    }

    return false;
}

