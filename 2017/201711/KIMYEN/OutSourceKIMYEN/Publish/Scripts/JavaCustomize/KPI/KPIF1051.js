var actionChoose = null;
var isCheck = true;
var mode = null;
var GridKPIT10502 = null;

$(document).ready(function () {
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    GridKPIT10502 = $("#GridEditKPIT10502").data("kendoGrid");
    GridKPIT10502.hideColumn("DivisionID");
    GridKPIT10502.hideColumn("DepartmentID");
    GridKPIT10502.hideColumn("EvaluationPhaseID");

    $("#IsCommon").click(function () {
        var isCheckCM = $("#IsCommon").is(":checked");
        nochange(isCheckCM);
        var dataGrid = GridKPIT10502.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            var item = GridKPIT10502.dataSource.at(i);
            item.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : "");
            item.set("DivisionName", isCheckCM ? " " : "");
            item.set("DepartmentID", "");
            item.set("DepartmentName", "");
            item.set("EvaluationPhaseID", "");
            item.set("EvaluationPhaseName", "");
            item.set("TargetsGroupID", "");
            item.set("TargetsGroupName", "");
        }
    });

    $(GridKPIT10502.tbody).on("change", "td", function (e) {
        var data = null;
        var column = e.target.id;
        var selectitem = GridKPIT10502.dataItem(e.currentTarget.parentElement);
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
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
            }
            else {
                selectitem.set("DivisionID", null);
                selectitem.set("DivisionName", null);
                selectitem.set("DepartmentID", null);
                selectitem.set("DepartmentName", null);
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
            }
        }
        if (column == "cbbDepartmentName") {
            if (data) {
                selectitem.set("DepartmentID", data.DepartmentID);
                selectitem.set("DepartmentName", data.DepartmentName);
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
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
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
            }
            else {
                selectitem.set("EvaluationPhaseID", null);
                selectitem.set("EvaluationPhaseName", null);
            }
        }
        if (column == "cbbTargetsGroupName") {
            if (data) {
                selectitem.set("TargetsGroupID", data.TargetsGroupID);
                selectitem.set("TargetsGroupName", data.TargetsGroupName);
                selectitem.set("TargetsGroupPercentage", data.Percentage);
            }
            else {
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
                selectitem.set("TargetsGroupPercentage", null);
            }
        }
    })

    
    GridKPIT10502.bind('dataBound', function (e) {
        var lengthGrid = GridKPIT10502.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++) {
            var item = GridKPIT10502.dataSource.at(i);
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
    });

    setTimeout(function () {
        $("#GridEditKPIT10102 .k-grid-content").css("height", "250px");
        $("#GridEditKPIT10102").css("max-height", "300px");
    }, 200)


    //if ($("#ClassificationID").data("kendoComboBox").value() == 3) {
    //    mode = 2;
    //}
    //if ($("#ClassificationID").data("kendoComboBox").value() == 2) {
    //    mode = 1;
    //}
    //if ($("#ClassificationID").data("kendoComboBox").value() == 1) {
    //    $("#MainTargetName").val("");
    //    $("#MainTargetID").val("");
    //    $(".MainTargetName").hide();
    //}

    //$("#ClassificationID").change(function (e) {
    //    var dataEval = $("#ClassificationID").data("kendoComboBox").dataItem($("#ClassificationID").data("kendoComboBox").select());
    //    if (dataEval && dataEval.ID == 1) {
    //        $("#MainTargetName").val("");
    //        $("#MainTargetID").val("");
    //        $(".MainTargetName").hide();
    //    }
    //    else {
    //        $(".MainTargetName").show();
    //        mode = dataEval.ID == 2 ? 1 : 2;
    //    }
    //})

    //$(".Note").parent().prepend($(".SourceID"))
    //$(".Note").parent().prepend($(".FrequencyID"))

    //if (isCheck) {
    //    var btnChoostarget = '<a id="btnChoostarget" style="z-index:10001; position: absolute; right: 0px; height: 25px ; min-width: 70px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnChoostarget_Click()">' + $("label[for='Choostarget']").text() + '</a>';
    //    $("#TargetsID").after(btnChoostarget);
    //}

    //$(".Choostarget").remove();
    //$("#Benchmark").attr("readonly", "readonly");
    //$("#PercentageGroup").attr("disabled", "disabled");

    //$("#TargetsGroupID").change(function () {
    //    var dataTargetsGroupID = $("#TargetsGroupID").data("kendoComboBox").dataSource.at($("#TargetsGroupID").data("kendoComboBox").select());
    //    if (dataTargetsGroupID) {
    //        $("#PercentageGroup").val(dataTargetsGroupID.Percentage);
    //    }
    //    else {
    //        $("#PercentageGroup").val(0);
    //    }

    //    var x = kendo.parseFloat($("#PercentageGroup").val()/100) * kendo.parseFloat($("#Percentage").val()/100) * 100;

    //    $("#Benchmark").val(formatConvertCommon(kendo.parseFloat(x)));
    //})

    //$("#Percentage").focusout(function () {
    //    var x = kendo.parseFloat($("#PercentageGroup").val()/100) * kendo.parseFloat($("#Percentage").val()/100) * 100;
    //    $("#Benchmark").val(formatConvertCommon(kendo.parseFloat(x)));

    //    var value = $(this).val();
    //    value = formatPercent(kendo.parseFloat(value));
    //    $(this).val(value);
    //})

    //$("#Percentage").val(formatPercent(kendo.parseFloat($("#Percentage").val())));

    //$("#Revenue").keydown(function (e) { keydowCustom(e, this) });

    //$("#btnMainTargetName").bind("click", btnMainTargetName_Click);
    //$("#btnDeleteMainTargetName").bind("click", btnDeleteMainTargetName_Click);
    //$("#MainTargetName").removeAttr("disabled");
    //$("#MainTargetName").attr("readonly", "readonly");
});

function nochange(isChange) {
    var columns = GridKPIT10502.columns;
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
    if ('TargetsGroupID' in e.values) {
        if (e.values.TargetsGroupID == "") {
            e.preventDefault();
        }
    }
    if ('TargetsGroupName' in e.values) {
        if (e.values.TargetsGroupName == "") {
            e.preventDefault();
        }
    }
    if (e.values.TargetsGroupPercentage != "" && e.values.TargetsGroupPercentage != null) {
        var Benchmark = (parseFloat(e.values.TargetsGroupPercentage) / 100) * (parseFloat(e.model.Percentage) / 100) * 100;
        e.model.set("Benchmark", Benchmark);
    }
    if (e.values.Percentage != "" && e.values.Percentage != null) {
        var Benchmark = (parseFloat(e.model.TargetsGroupPercentage) / 100) * (parseFloat(e.values.Percentage) / 100) * 100;
        e.model.set("Benchmark", Benchmark);
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

//function keydowCustom(e, element) {
//    if (e.keyCode < 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105) {
//        if (e.keyCode != 9 && e.keyCode != 13 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 8 && ((e.keyCode != 190 && e.keyCode != 110) || ($(element).val()).indexOf('.') != -1)) {
//            e.preventDefault()
//        }
//    }
//}

//function formatPercent(value) {
//    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
//    return kendo.toString(value, format);
//}


//function btnDeleteMainTargetName_Click() {
//    $("#MainTargetName").val("");
//    $("#MainTargetID").val("");
//}

//function btnMainTargetName_Click() {
//    var urlChoose = "/PopupSelectData/Index/KPI/KPIF9002?DivisionID=" + $("#DivisionID").val() + "&Mode=" + mode;
//    ASOFT.form.clearMessageBox();
//    actionChoose = 2;
//    ASOFT.asoftPopup.showIframe(urlChoose, {});
//}

//function btnChoostarget_Click() {
//    var urlChoose = "/PopupSelectData/Index/KPI/KPIF9001?DivisionID=" + $("#DivisionID").val();
//    ASOFT.form.clearMessageBox();
//    actionChoose = 1;
//    ASOFT.asoftPopup.showIframe(urlChoose, {});
//}

//function receiveResult(result) {
//    if (actionChoose == 1)
//    {
//        $("#ClassificationID").data("kendoComboBox").value(result.ClassificationID);
//        $("#TargetsGroupID").data("kendoComboBox").value(result.TargetsGroupID);
//        $("#UnitKpiID").data("kendoComboBox").value(result.UnitKpiID);
//        $("#FrequencyID").data("kendoComboBox").value(result.FrequencyID);
//        $("#SourceID").data("kendoComboBox").value(result.SourceID);
//        $("#Categorize").data("kendoComboBox").value(result.Categorize);
//        $("#FormulaName").val(result.FormulaName);
//        $("#Note").val(result.Note);
//        $("#Percentage").val(formatConvertCommon(kendo.parseFloat(result.Percentage)));
//        $("#Revenue").val(formatConvertCommon(kendo.parseFloat(result.Revenue)));
//        $("#GoalLimit").val(formatConvertCommon(kendo.parseFloat(result.GoalLimit)));
//        $("#TargetsID").val(result.TargetsDictionaryID);
//        $("#TargetsName").val(result.TargetsDictionaryName);
//        $("#IsCommon").prop("checked", result.IsCommon == 1);
//        $("#Disabled").prop("checked", result.Disabled == 1);

//        var dataTargetsGroupID = $("#TargetsGroupID").data("kendoComboBox").dataSource.at($("#TargetsGroupID").data("kendoComboBox").select());
//        if (dataTargetsGroupID) {
//            $("#PercentageGroup").val(dataTargetsGroupID.Percentage);
//        }
//        else {
//            $("#PercentageGroup").val(0);
//        }

//        var x = kendo.parseFloat($("#PercentageGroup").val()) * kendo.parseFloat($("#Percentage").val()) * 100;

//        $("#Benchmark").val(formatConvertCommon(kendo.parseFloat(x)));
//    }

//    if (actionChoose == 2)
//    {
//        $("#MainTargetName").val(result.TargetsName);
//        $("#MainTargetID").val(result.TargetsID);
//    }
//}

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#TargetsID").val(), TableID: "KPIT10501" }, function (result) {
        if (result == 1) {
            isCheck = false;
            $("#IsCommon").attr("disabled","disabled");
        }
        else {
            $("#TargetsID").removeAttr("readonly");
        }
    });
}


//function onAfterInsertSuccess(result, action) {
//    if (action == 3 && result.Status == 0) {
//        var url = parent.GetUrlContentMaster();
//        var listSp = url.split('&');
//        var division = listSp[listSp.length - 1];
//        if ($("#IsCommon").is(':checked')) {
//            url = url.replace(division, "DivisionID=" + "@@@");
//        }
//        else {
//            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
//        }
//        window.parent.parent.location = url;
//        parent.setReload();
//    }
//}

//function CustomerCheck() {
//    var length2 = GridKPIT10502.dataSource._data.length;

//    for (var i = 0; i < length2; i++) {
//        var item = GridKPIT10502.dataSource.at(i);
//        for (var j = 0; j < length2; j++) {
//            var item1 = GridKPIT10502.dataSource.at(j);
//            if (i != j && item.DivisionID == item1.DivisionID && item.DepartmentID == item1.DepartmentID && item.EvaluationPhaseID == item1.EvaluationPhaseID && item.TargetsGroupID == item1.TargetsGroupID) {
//                var msg = ASOFT.helper.getMessage('PAML000004');
//                ASOFT.form.displayMessageBox("form#" + id, [msg]);
//                var tr = GridKPIT10502.tbody.find('tr')[i];
//                $(tr).addClass("asf-focus-input-error");
//                $(tr).removeClass("k-state-selected")
//                var tr1 = GridKPIT10502.tbody.find('tr')[j];
//                $(tr1).removeClass('k-state-selected');
//                $(tr1).addClass("asf-focus-input-error");
//                return true;
//            }
//        }
//    }

//    return false;
//}

