var GridKPIT20002 = null;
var TargetsID = null;
var APK = null;
var isFirst = true;
var isChangeUnit = false;
var isChangeGrid = false;
var isFirstDataBound = true;

$(document).ready(function () {

    GridKPIT20002 = $("#GridEditKPIT20002").data("kendoGrid");

    $("#IsView").attr("disabled", "disabled");

    if ($("#isUpdate").val() == "False") {
        $("#DeleteFlg").val(0);
    }

    GridKPIT20002.bind('dataBound', function (e) {
        isFirstDataBound = false;
        $(".k-grid-footer").remove();
        var lengthGrid = GridKPIT20002.dataSource._data.length;
        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;

        for (var i = 0; i < lengthGrid; i++) {
            var items = GridKPIT20002.dataSource._data[i].items;
            GridKPIT20002.dataSource._data[i].aggregates.TargetsPercentage.set("sum", items[0].TargetsGroupPercentage);
            for (var j = 0; j < items.length; j++) {
                var item = items[j];

                if ($("#isUpdate").val() == "False") {
                    item.set("LastModifyDate", "");
                    item.set("CreateDate", "");
                    item.set("LastModifyUserID", "");
                    item.set("CreateUserID", "");
                }

                if (item.APK == null) {
                    item.set("APK", "");
                }

                //if (item.LastModifyDate != "" && item.LastModifyDate != null) {
                //    if (item.LastModifyDate.indexOf("Date") != -1) {
                //        var str = kendo.toString(kendo.parseDate(item.LastModifyDate), "dd/MM/yyyy HH:mm:ss");
                //        item.set("LastModifyDate", str);
                //    }
                //}
                //if (item.CreateDate != "" && item.CreateDate != null) {
                //    if (item.CreateDate.indexOf("Date") != -1) {
                //        var str = kendo.toString(kendo.parseDate(item.CreateDate), "dd/MM/yyyy HH:mm:ss");
                //        item.set("CreateDate", str);
                //    }
                //}

                if ($("#IsView").val() == 1 && !isChangeGrid && ($("#TotalReevaluatedPoint").val() == "" || $("#TotalReevaluatedPoint").val() == 0)) {
                    item.set("Reevaluated", item.Perform);
                    item.set("ReevaluatedPoint", item.PerformPoint);
                    item.set("UnifiedPoint", item.PerformPoint);
                    GridKPIT20002.dataSource._data[i].aggregates.ReevaluatedPoint.set("sum", GridKPIT20002.dataSource._data[i].aggregates.PerformPoint.sum);
                    GridKPIT20002.dataSource._data[i].aggregates.UnifiedPoint.set("sum", GridKPIT20002.dataSource._data[i].aggregates.PerformPoint.sum);
                }
            }

            //if (isChange) {
            //    TotalPerformPoint += GridKPIT20002.dataSource._data[i].aggregates.PerformPoint.sum;
            //    TotalReevaluatedPoint += GridKPIT20002.dataSource._data[i].aggregates.ReevaluatedPoint.sum;
            //    TotalUnifiedPoint += GridKPIT20002.dataSource._data[i].aggregates.UnifiedPoint.sum;

            //    $("#TotalPerformPoint").val(formatConvertCommon(TotalPerformPoint));
            //    $("#TotalReevaluatedPoint").val(formatConvertCommon(TotalReevaluatedPoint));
            //    $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));
            //}
        }

        if ($("#IsView").val() == 1 && !isChangeGrid && ($("#TotalReevaluatedPoint").val() == "" || $("#TotalReevaluatedPoint").val() == 0)) {
            $("#TotalReevaluatedPoint").val($("#TotalPerformPoint").val());
            $("#TotalUnifiedPoint").val($("#TotalPerformPoint").val());

            $("#ClassificationReevaluatedPoint").val($("#ClassificationPerformPoint").val());
            $("#ClassificationUnifiedPoint").val($("#ClassificationPerformPoint").val());
        }
    });


    $("#GridEditKPIT20002").attr("AddNewRowDisabled", "false");

    if ($("#isUpdate").val() == "False") {
        $("#ToDate").data("kendoDatePicker").value(new Date());
        $("#FromDate").data("kendoDatePicker").value(new Date());
    }

    $("#EmployeeName").attr("readonly", "readonly");
    //$("#TitleID").data("kendoComboBox").readonly(true);
    //$("#DutyID").data("kendoComboBox").readonly(true);
    //$("#DepartmentID").data("kendoComboBox").readonly(true);
    //$("#EvaluationPhaseID").data("kendoComboBox").readonly(true);
    GridKPIT20002.hideColumn("TargetsGroupName");
    $("#ToDate").data("kendoDatePicker").readonly(true);
    $("#FromDate").data("kendoDatePicker").readonly(true);

    if ($("#IsView").val() == 0) {
        $(".ConfirmComments").hide();
        $("#ClassificationReevaluatedPoint").parent().hide();
        $("#ClassificationUnifiedPoint").parent().hide();
        $("#TotalReevaluatedPoint").parent().hide();
        $("#TotalUnifiedPoint").parent().hide();
        $(".EmployeeProposes").hide();
        GridKPIT20002.hideColumn("UnifiedPoint");
        GridKPIT20002.hideColumn("Reevaluated");
        GridKPIT20002.hideColumn("ReevaluatedPoint");
        if ($("#isUpdate").val() == "True") {
            $("#EvaluationSetID").data("kendoComboBox").readonly(true);
        }
    }
    else {
        //$("#EmployeeProposes").attr("readonly", "readonly");
        $("#EmployeeComments").attr("readonly", "readonly");
        $("#WeakPoint").attr("readonly", "readonly");
        $("#StrengthPoint").attr("readonly", "readonly");
        $("#EvaluationSetID").data("kendoComboBox").readonly(true);
        $("#ConfirmUserID").data("kendoComboBox").readonly(true);
    }

    $("#TotalPerformPoint").attr("readonly", "readonly");
    $("#TotalReevaluatedPoint").attr("readonly", "readonly");
    $("#TotalUnifiedPoint").attr("readonly", "readonly");
    $("#ClassificationPerformPoint").attr("readonly", "readonly");
    $("#ClassificationReevaluatedPoint").attr("readonly", "readonly");
    $("#ClassificationUnifiedPoint").attr("readonly", "readonly");

    $(".EmployeeName").after($(".EvaluationSetID"));
    $(".EmployeeName").after($(".TitleID"));
    $(".EmployeeName").after($(".DutyID"));
    $(".EmployeeName").after($(".DepartmentID"));
    $(".ToDate").after($(".ConfirmUserID"))
    $(".EmployeeProposes").before($(".StrengthPoint"));
    $(".EmployeeProposes").before($(".WeakPoint"));
    $(".EmployeeProposes").before($(".EmployeeComments"));
    $(".ConfirmUserID").after($(".ConfirmComments"));



    $("#GridEditKPIT20002").append("<table style='float: right; width:auto; border-color: #FFF' class='asf-table-view' id='totalAll'></table>");
    $("#totalAll").prepend("<tr id='Classification'><td>" + $("#LanguageXL").val() + "</td></tr>");
    $("#totalAll").prepend("<tr id='Total'><td>" + $("#LanguageTD").val() + "</td></tr>");
    $("#Total").append($("#TotalPerformPoint").parent());
    $("#Total").append($("#TotalReevaluatedPoint").parent());
    $("#Total").append($("#TotalUnifiedPoint").parent());
    $("#Classification").append($("#ClassificationPerformPoint").parent());
    $("#Classification").append($("#ClassificationReevaluatedPoint").parent());
    $("#Classification").append($("#ClassificationUnifiedPoint").parent());
    $(".TotalPerformPoint").remove();
    $(".TotalReevaluatedPoint").remove();
    $(".TotalUnifiedPoint").remove();
    $(".ClassificationPerformPoint").remove();
    $(".ClassificationReevaluatedPoint").remove();
    $(".ClassificationUnifiedPoint").remove();
    $("#LanguageXL").remove();
    $("#LanguageTD").remove();



    setTimeout(function () {
        $("#GridEditKPIT20002 .k-grid-content").css("height", "350px");
        $("#GridEditKPIT20002").css("max-height", "400px");
    }, 200)

    $("#EvaluationSetID").bind("change", function (e) {
        if ($("#EvaluationSetID").val() == "" && $("#EvaluationSetID").data("kendoComboBox").dataSource.data().length == 1) {
            $("#EvaluationSetID").data("kendoComboBox").select(0);
            return false;
        }

        var dataEval = $("#EvaluationSetID").data("kendoComboBox").dataItem($("#EvaluationSetID").data("kendoComboBox").select());
        if (dataEval) {
            $("#EvaluationSetName").val(dataEval.EvaluationSetName);
            $("#EvaluationPhaseID").data("kendoComboBox").value(dataEval.EvaluationPhaseID);
            $("#ToDate").data("kendoDatePicker").value(dataEval.ToDate);
            $("#FromDate").data("kendoDatePicker").value(dataEval.FromDate);
            //$("#DutyID").data("kendoComboBox").value(dataEval.DutyID);
            //$("#TitleID").data("kendoComboBox").value(dataEval.TitleID);
        }

        APK = dataEval ? dataEval.APK : null;

        if (APK != null) {
            $("#TotalPerformPoint").val(formatConvertCommon(0));
            $("#TotalReevaluatedPoint").val(formatConvertCommon(0));
            $("#TotalUnifiedPoint").val(formatConvertCommon(0));

            var dataClass = {};
            dataClass.PerformPoint = 0;
            dataClass.ReevaluatedPoint = 0;
            dataClass.UnifiedPoint = 0;
            getClassification(dataClass);
        }
        else {
            clearTotal();
        }

        GridKPIT20002.dataSource.read();
    })

    //$("#EvaluationPhaseID").bind("change", function (e) {
    //    if ($("#EvaluationPhaseID").val() == "" && $("#EvaluationPhaseID").data("kendoComboBox").dataSource.data().length == 1) {
    //        $("#EvaluationPhaseID").data("kendoComboBox").select(0);
    //        return false;
    //    }

    //    var dataEval = $("#EvaluationPhaseID").data("kendoComboBox").dataItem($("#EvaluationPhaseID").data("kendoComboBox").select());
    //    var dataSet = $("#EvaluationSetID").data("kendoComboBox").dataItem($("#EvaluationSetID").data("kendoComboBox").select());

    //    if (dataEval) {
    //        $("#ToDate").data("kendoDatePicker").value(dataEval.ToDate);
    //        $("#FromDate").data("kendoDatePicker").value(dataEval.FromDate);
    //    }
    //    EvaluationPhaseID = dataEval ? dataEval.EvaluationPhaseID : null;
    //    APK = dataSet ? dataSet.APK : null;

    //    if (APK != null && EvaluationPhaseID != null) {
    //        $("#TotalPerformPoint").val(formatConvertCommon(0));
    //        $("#TotalReevaluatedPoint").val(formatConvertCommon(0));
    //        $("#TotalUnifiedPoint").val(formatConvertCommon(0));

    //        var dataClass = {};
    //        dataClass.PerformPoint = 0;
    //        dataClass.ReevaluatedPoint = 0;
    //        dataClass.UnifiedPoint = 0;

    //        getClassification(dataClass);
    //    }
    //    else {
    //        clearTotal();
    //    }

    //    GridKPIT20002.dataSource.read();
    //})

    $("#ConfirmUserID").bind("change", function (e) {
        if ($("#ConfirmUserID").val() == "" && $("#ConfirmUserID").data("kendoComboBox").dataSource.data().length == 1) {
            $("#ConfirmUserID").data("kendoComboBox").select(0);
            return false;
        }
        var dataEval = $("#ConfirmUserID").data("kendoComboBox").dataItem($("#ConfirmUserID").data("kendoComboBox").select());

        if (dataEval) {
            $("#ConfirmDutyID").val(dataEval.DutyID);
            $("#ConfirmDepartmentID").val(dataEval.DepartmentID);
        }
    })
});

function getClassification(dataClass) {
    ASOFT.helper.postTypeJson("/KPI/KPIF2000/LoadClassification", dataClass, function (result) {
        $("#ClassificationPerformPoint").val(result.ClassificationPerformPoint);
        $("#ClassificationReevaluatedPoint").val(result.ClassificationReevaluatedPoint);
        $("#ClassificationUnifiedPoint").val(result.ClassificationUnifiedPoint);
    })
}

function clearTotal() {
    $("#TotalPerformPoint").val("");
    $("#TotalReevaluatedPoint").val("");
    $("#TotalUnifiedPoint").val("");
    $("#ClassificationPerformPoint").val("");
    $("#ClassificationReevaluatedPoint").val("");
    $("#ClassificationUnifiedPoint").val("");
}

function CustomRead() {
    var ct = [];
    ct.push(APK);
    if ($("#isUpdate").val() == "False") {
        ct.push($("#EmployeeID").val());
    }
    return ct;
}


function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    if ('Perform' in e.values) {
        isChangeGrid = false;
        var oldPerformPoint = e.model.PerformPoint;
        var PerformPoint = 0;
        var cateGorize = e.model.Categorize ? e.model.Categorize : 0;
        if (e.values.Perform == null || cateGorize == 0 || (cateGorize == 1 && e.model.GoalLimit != null && e.values.Perform > e.model.GoalLimit) || (cateGorize == 2 && e.model.GoalLimit != null && e.values.Perform < e.model.GoalLimit)) {
            PerformPoint = 0;
        }
        else {
            if (cateGorize == 1) {
                if (e.values.Perform <= 0) {
                    PerformPoint = e.model.Benchmark;
                }
                else {
                    if (e.values.Perform >= e.model.Revenue) {
                        PerformPoint = (e.model.Revenue / e.values.Perform) * e.model.Benchmark;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
            }
            else {
                if (cateGorize == 2) {
                    if (e.values.Perform <= e.model.Revenue) {
                        PerformPoint = (e.model.Benchmark / e.model.Revenue) * e.values.Perform;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
                else {
                    if (e.values.Perform == e.model.Revenue) {
                        PerformPoint = e.model.Benchmark;
                    }
                    else {
                        PerformPoint = 0;
                    }
                }
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.model.Reevaluated == null || e.values.Perform == null) ? 0 : (parseFloat(PerformPoint) + parseFloat(e.model.ReevaluatedPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.TargetsGroupName) {
                var sumPerformPoint = parseFloat(dtGrid[i].aggregates.PerformPoint.sum) - parseFloat(oldPerformPoint) + parseFloat(PerformPoint);
                var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(vlUnifiedPoint);
                dtGrid[i].aggregates.PerformPoint.set("sum", sumPerformPoint);
                dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);
                break;
            }
        }

        for (var i = 0; i < dtGrid.length; i++) {
            TotalPerformPoint += parseFloat(dtGrid[i].aggregates.PerformPoint.sum);
            TotalReevaluatedPoint += parseFloat(dtGrid[i].aggregates.ReevaluatedPoint.sum);
            TotalUnifiedPoint += parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum);
        }

        $("#TotalPerformPoint").val(formatConvertCommon(TotalPerformPoint));
        $("#TotalReevaluatedPoint").val(formatConvertCommon(TotalReevaluatedPoint));
        $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));

        e.model.set("PerformPoint", PerformPoint);
        e.model.set("UnifiedPoint", vlUnifiedPoint);
        GridKPIT20002.refresh();

        var dataClass = {};
        dataClass.PerformPoint = formatConvertCommon(TotalPerformPoint);
        dataClass.ReevaluatedPoint = formatConvertCommon(TotalReevaluatedPoint);
        dataClass.UnifiedPoint = formatConvertCommon(TotalUnifiedPoint);

        getClassification(dataClass);
    }

    if ('Reevaluated' in e.values) {
        isChangeGrid = false;
        var oldReevaluatedPoint = e.model.ReevaluatedPoint;
        var ReevaluatedPoint = 0;
        var cateGorize = e.model.Categorize ? e.model.Categorize : 0;
        if (e.values.Reevaluated == null || cateGorize == 0 || (cateGorize == 1 && e.model.GoalLimit != null && e.values.Reevaluated > e.model.GoalLimit) || (cateGorize == 2 && e.model.GoalLimit != null && e.values.Reevaluated < e.model.GoalLimit)) {
            ReevaluatedPoint = 0;
        }
        else {
            if (cateGorize == 1) {
                if (e.values.Reevaluated <= 0) {
                    ReevaluatedPoint = e.model.Benchmark;
                }
                else {
                    if (e.values.Reevaluated >= e.model.Revenue) {
                        ReevaluatedPoint = (e.model.Revenue / e.values.Reevaluated) * e.model.Benchmark;
                    }
                    else {
                        ReevaluatedPoint = e.model.Benchmark;
                    }
                }
            }
            else {
                if (cateGorize == 2) {
                    if (e.values.Reevaluated <= e.model.Revenue) {
                        ReevaluatedPoint = (e.model.Benchmark / e.model.Revenue) * e.values.Reevaluated;
                    }
                    else {
                        ReevaluatedPoint = e.model.Benchmark;
                    }
                }
                else {
                    if (e.values.Reevaluated == e.model.Revenue) {
                        ReevaluatedPoint = e.model.Benchmark;
                    }
                    else {
                        ReevaluatedPoint = 0;
                    }
                }
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.values.Reevaluated == null || e.model.Perform == null) ? 0 : (parseFloat(e.model.PerformPoint) + parseFloat(ReevaluatedPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.TargetsGroupName) {
                var sumReevaluatedPoint = parseFloat(dtGrid[i].aggregates.ReevaluatedPoint.sum) - parseFloat(oldReevaluatedPoint) + parseFloat(ReevaluatedPoint);
                var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(vlUnifiedPoint);
                dtGrid[i].aggregates.ReevaluatedPoint.set("sum", sumReevaluatedPoint);
                dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);
                break;
            }
        }

        for (var i = 0; i < dtGrid.length; i++) {
            TotalPerformPoint += parseFloat(dtGrid[i].aggregates.PerformPoint.sum);
            TotalReevaluatedPoint += parseFloat(dtGrid[i].aggregates.ReevaluatedPoint.sum);
            TotalUnifiedPoint += parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum);
        }

        $("#TotalPerformPoint").val(formatConvertCommon(TotalPerformPoint));
        $("#TotalReevaluatedPoint").val(formatConvertCommon(TotalReevaluatedPoint));
        $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));

        if (isFirst) {
            e.model.set("UnifiedPoint", vlUnifiedPoint);
            isFirst = false;
        }

        if (e.model.UnifiedPoint != vlUnifiedPoint) {
            isChangeUnit = true;
        }

        e.model.set("ReevaluatedPoint", ReevaluatedPoint);
        e.model.set("UnifiedPoint", vlUnifiedPoint);
        GridKPIT20002.refresh();

        var dataClass = {};
        dataClass.PerformPoint = formatConvertCommon(TotalPerformPoint);
        dataClass.ReevaluatedPoint = formatConvertCommon(TotalReevaluatedPoint);
        dataClass.UnifiedPoint = formatConvertCommon(TotalUnifiedPoint);

        getClassification(dataClass);
    }

    if ('UnifiedPoint' in e.values) {
        isChangeGrid = false;
        if (isChangeUnit) {
            isChangeUnit = false;
        }
        else {
            if (e.values.UnifiedPoint == null) {
                e.preventDefault();
            }
            else {
                var dtGrid = e.sender.dataSource._data;
                for (var i = 0; i < dtGrid.length; i++) {
                    if (dtGrid[i].value == e.model.TargetsGroupName) {
                        var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(e.values.UnifiedPoint);
                        dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);
                        break;
                    }
                }

                var TotalUnifiedPoint = 0;
                for (var i = 0; i < dtGrid.length; i++) {
                    TotalUnifiedPoint += parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum);
                }

                $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));

                var dataClass = {};
                dataClass.PerformPoint = $("#TotalPerformPoint").val();
                dataClass.ReevaluatedPoint = $("#TotalReevaluatedPoint").val();
                dataClass.UnifiedPoint = $("#TotalUnifiedPoint").val();

                getClassification(dataClass);
                GridKPIT20002.refresh();
            }
        }
    }

    if ('Revenue' in e.values) {
        isChangeGrid = false;
        var oldPerformPoint = e.model.PerformPoint;
        var PerformPoint = 0;
        var cateGorize = e.model.Categorize ? e.model.Categorize : 0;
        if (e.model.Perform == null || cateGorize == 0 || (cateGorize == 1 && e.model.GoalLimit != null && e.model.Perform > e.model.GoalLimit) || (cateGorize == 2 && e.model.GoalLimit != null && e.model.Perform < e.model.GoalLimit)) {
            PerformPoint = 0;
        }
        else {
            if (cateGorize == 1) {
                if (e.model.Perform <= 0) {
                    PerformPoint = e.model.Benchmark;
                }
                else {
                    if (e.model.Perform >= e.values.Revenue) {
                        PerformPoint = (e.values.Revenue / e.model.Perform) * e.model.Benchmark;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
            }
            else {
                if (cateGorize == 2) {
                    if (e.model.Perform <= e.values.Revenue) {
                        PerformPoint = (e.model.Benchmark / e.values.Revenue) * e.model.Perform;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
                else {
                    if (e.model.Perform == e.values.Revenue) {
                        PerformPoint = e.model.Benchmark;
                    }
                    else {
                        PerformPoint = 0;
                    }
                }
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.model.Reevaluated == null || e.model.Perform == null) ? 0 : (parseFloat(PerformPoint) + parseFloat(e.model.ReevaluatedPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.TargetsGroupName) {
                var sumPerformPoint = parseFloat(dtGrid[i].aggregates.PerformPoint.sum) - parseFloat(oldPerformPoint) + parseFloat(PerformPoint);
                var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(vlUnifiedPoint);
                dtGrid[i].aggregates.PerformPoint.set("sum", sumPerformPoint);
                dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);
                break;
            }
        }

        for (var i = 0; i < dtGrid.length; i++) {
            TotalPerformPoint += parseFloat(dtGrid[i].aggregates.PerformPoint.sum);
            TotalReevaluatedPoint += parseFloat(dtGrid[i].aggregates.ReevaluatedPoint.sum);
            TotalUnifiedPoint += parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum);
        }

        $("#TotalPerformPoint").val(formatConvertCommon(TotalPerformPoint));
        $("#TotalReevaluatedPoint").val(formatConvertCommon(TotalReevaluatedPoint));
        $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));

        e.model.set("PerformPoint", PerformPoint);
        e.model.set("UnifiedPoint", vlUnifiedPoint);
        GridKPIT20002.refresh();

        var dataClass = {};
        dataClass.PerformPoint = formatConvertCommon(TotalPerformPoint);
        dataClass.ReevaluatedPoint = formatConvertCommon(TotalReevaluatedPoint);
        dataClass.UnifiedPoint = formatConvertCommon(TotalUnifiedPoint);

        getClassification(dataClass);
    }

    if ('GoalLimit' in e.values) {
        isChangeGrid = false;
        var oldPerformPoint = e.model.PerformPoint;
        var PerformPoint = 0;
        var cateGorize = e.model.Categorize ? e.model.Categorize : 0;
        if (e.model.Perform == null || cateGorize == 0 || (cateGorize == 1 && e.values.GoalLimit != null && e.model.Perform > e.values.GoalLimit) || (cateGorize == 2 && e.values.GoalLimit != null && e.model.Perform < e.values.GoalLimit)) {
            PerformPoint = 0;
        }
        else {
            if (cateGorize == 1) {
                if (e.model.Perform <= 0) {
                    PerformPoint = e.model.Benchmark;
                }
                else {
                    if (e.model.Perform >= e.model.Revenue) {
                        PerformPoint = (e.model.Revenue / e.model.Perform) * e.model.Benchmark;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
            }
            else {
                if (cateGorize == 2) {
                    if (e.model.Perform <= e.model.Revenue) {
                        PerformPoint = (e.model.Benchmark / e.model.Revenue) * e.model.Perform;
                    }
                    else {
                        PerformPoint = e.model.Benchmark;
                    }
                }
                else {
                    if (e.model.Perform == e.model.Revenue) {
                        PerformPoint = e.model.Benchmark;
                    }
                    else {
                        PerformPoint = 0;
                    }
                }
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.model.Reevaluated == null || e.model.Perform == null) ? 0 : (parseFloat(PerformPoint) + parseFloat(e.model.ReevaluatedPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.TargetsGroupName) {
                var sumPerformPoint = parseFloat(dtGrid[i].aggregates.PerformPoint.sum) - parseFloat(oldPerformPoint) + parseFloat(PerformPoint);
                var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(vlUnifiedPoint);
                dtGrid[i].aggregates.PerformPoint.set("sum", sumPerformPoint);
                dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);
                break;
            }
        }

        for (var i = 0; i < dtGrid.length; i++) {
            TotalPerformPoint += parseFloat(dtGrid[i].aggregates.PerformPoint.sum);
            TotalReevaluatedPoint += parseFloat(dtGrid[i].aggregates.ReevaluatedPoint.sum);
            TotalUnifiedPoint += parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum);
        }

        $("#TotalPerformPoint").val(formatConvertCommon(TotalPerformPoint));
        $("#TotalReevaluatedPoint").val(formatConvertCommon(TotalReevaluatedPoint));
        $("#TotalUnifiedPoint").val(formatConvertCommon(TotalUnifiedPoint));

        e.model.set("PerformPoint", PerformPoint);
        e.model.set("UnifiedPoint", vlUnifiedPoint);
        GridKPIT20002.refresh();

        var dataClass = {};
        dataClass.PerformPoint = formatConvertCommon(TotalPerformPoint);
        dataClass.ReevaluatedPoint = formatConvertCommon(TotalReevaluatedPoint);
        dataClass.UnifiedPoint = formatConvertCommon(TotalUnifiedPoint);

        getClassification(dataClass);
    }
}


function clearfieldsCustomer() {
    var data = ASOFT.helper.dataFormToJSON(id);
    $.each(data, function (key, value) {
        if (key != "item.TypeCheckBox") {
            if (key != "item.TypeCheckBox" && key.indexOf("_Content_DataType") == -1 && key.indexOf("_Type_Fields") == -1 && key.indexOf("listRequired") == -1 && key != "CheckInList" && key != "tableNameEdit" && key != "EmployeeName" && key != "EmployeeID" && key != "DepartmentID" && key != "DutyID" && key != "TitleID") {
                if ($("#" + key).data("kendoComboBox") != null) {
                    $("#" + key).data("kendoComboBox").value("");
                }
                if ($("#" + key).data("kendoDropDownList") != null) {
                    $("#" + key).data("kendoDropDownList").value("");
                    $("#" + key).data("kendoDropDownList").text("");
                }
                $("#" + key).val('');
            }
        }
    })
    $("#ToDate").data("kendoDatePicker").value(new Date());
    $("#FromDate").data("kendoDatePicker").value(new Date());
    APK = null;
    $("#DeleteFlg").val(0);
    GridKPIT20002.dataSource.read();
}

function CustomerCheck() {
    var lengthGrid = GridKPIT20002.dataSource._data.length;
    if (lengthGrid <= 0) {
        GridKPIT20002.element.addClass('asf-focus-input-error');
        var msg = ASOFT.helper.getMessage('00ML000061');
        ASOFT.form.displayMessageBox("form#" + id, [msg]);
        return true;
    }
    return false;
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && (action == 1 || action == 2)) {
        clearTotal();
        LoadConfirm();
    }
    if (result.Status == 0 && action == 2) {
        clearTotal();
        GridKPIT20002.dataSource.read();
    }
}


function LoadConfirm() {
    var data = {};
    data.userID = $("#EmployeeID").val();

    ASOFT.helper.postTypeJson("/KPI/KPIF2000/LoadConfirm", data, function (result) {
        $("#ConfirmUserID").data("kendoComboBox").value(result.EmployeeID);
        $("#ConfirmDutyID").val(result.DutyID);
        $("#ConfirmDepartmentID").val(result.DepartmentID);
    })
}
