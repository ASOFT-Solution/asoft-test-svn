var GridPAT20002 = null;
var APK = null;
var EvaluationPhaseID = null;
var isFirst = true;
var isChangeUnit = false;
var isChangeGrid = false;

$(document).ready(function () {

    GridPAT20002 = $("#GridEditPAT20002").data("kendoGrid");

    $("#IsView").attr("disabled", "disabled");

    if ($("#isUpdate").val() == "False") {
        $("#DeleteFlg").val(0);
    }

    GridPAT20002.bind('dataBound', function (e) {
        $(".k-grid-footer").remove();
        var lengthGrid = GridPAT20002.dataSource._data.length;
        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;

        for (var i = 0; i < lengthGrid; i++) {
            var items = GridPAT20002.dataSource._data[i].items;
            GridPAT20002.dataSource._data[i].aggregates.Benchmark.set("sum", items[0].AppraisalGroupGoal);
            var sumLevelCritical = GridPAT20002.dataSource._data[i].aggregates.LevelCritical.sum;
            var sumPerformPoint = GridPAT20002.dataSource._data[i].aggregates.PerformPoint.sum;
            if (sumPerformPoint == 0) {
                GridPAT20002.dataSource._data[i].aggregates.Note.set("count", 0);
            }
            else {
                var AppraisalGroupNote = sumPerformPoint / items[0].AppraisalGroupGoal;
                GridPAT20002.dataSource._data[i].aggregates.Note.set("count", AppraisalGroupNote);
            }
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

                if (item.LevelCritical == 0 || item.LevelCritical == null) {
                    item.set("Benchmark", 0);
                }
                else {
                    var benchmark = (item.LevelCritical / sumLevelCritical) * item.AppraisalGroupGoal;
                    item.set("Benchmark", benchmark);
                }

                if ($("#IsView").val() == 1 && !isChangeGrid && ($("#TotalReevaluatedPoint").val() == "" || $("#TotalReevaluatedPoint").val() == 0)) {
                    item.set("Reevaluated", item.Perform);
                    item.set("ReevaluatedPoint", item.PerformPoint);
                    item.set("UnifiedPoint", item.PerformPoint);
                    GridPAT20002.dataSource._data[i].aggregates.ReevaluatedPoint.set("sum", GridPAT20002.dataSource._data[i].aggregates.PerformPoint.sum);
                    GridPAT20002.dataSource._data[i].aggregates.UnifiedPoint.set("sum", GridPAT20002.dataSource._data[i].aggregates.PerformPoint.sum);
                }
            }
        }

        if ($("#IsView").val() == 1 && !isChangeGrid && ($("#TotalReevaluatedPoint").val() == "" || $("#TotalReevaluatedPoint").val() == 0)) {
            $("#TotalReevaluatedPoint").val($("#TotalPerformPoint").val());
            $("#TotalUnifiedPoint").val($("#TotalPerformPoint").val());
        }
    });
    $("#GridEditPAT20002").attr("AddNewRowDisabled", "false");

    if ($("#isUpdate").val() == "False") {
        $("#ToDate").data("kendoDatePicker").value(new Date());
        $("#FromDate").data("kendoDatePicker").value(new Date());
    }
    else {
        $("#EmployeeID").data("kendoComboBox").readonly(true)
    }

    //$("#EmployeeName").attr("disabled", "disabled");
    //$("#DepartmentID").data("kendoComboBox").readonly(true);
    //$("#DutyID").data("kendoComboBox").readonly(true);
    //$("#TitleID").data("kendoComboBox").readonly(true);
    GridPAT20002.hideColumn("AppraisalGroupName");
    $("#ToDate").data("kendoDatePicker").readonly(true);
    $("#FromDate").data("kendoDatePicker").readonly(true);

    if ($("#IsView").val() == 0) {
        $(".ConfirmComments").hide();
        $("#TotalReevaluatedPoint").parent().hide();
        $("#TotalUnifiedPoint").parent().hide();
        GridPAT20002.hideColumn("UnifiedPoint");
        GridPAT20002.hideColumn("Reevaluated");
        GridPAT20002.hideColumn("ReevaluatedPoint");
        $(".ConfirmUserID").before($(".DepartmentID"));
        if ($("#isUpdate").val() == "True") {
            $("#EvaluationKitID").data("kendoComboBox").readonly(true);
            //$("#EvaluationPhaseID").data("kendoComboBox").readonly(true);
        }
    }
    else {
        $("#EvaluationKitID").data("kendoComboBox").readonly(true);
        //$("#EvaluationPhaseID").data("kendoComboBox").readonly(true);
        //$("#ConfirmUserID").data("kendoComboBox").readonly(true);
    }

    $("#TotalPerformPoint").attr("readonly", "readonly");
    $("#TotalReevaluatedPoint").attr("readonly", "readonly");
    $("#TotalUnifiedPoint").attr("readonly", "readonly");


    $(".EvaluationPhaseID").before($(".EmployeeName"));


    $(".EmployeeID").after($(".EvaluationSetID"));
    $(".EmployeeID").after($(".TitleID"));
    $(".EmployeeID").after($(".DutyID"));
    $(".EmployeeID").after($(".DepartmentID"));
    $(".ConfirmUserID").before($(".EvaluationPhaseID"));
    $(".ConfirmUserID").before($(".FromDate"));
    $(".ConfirmUserID").before($(".ToDate"));
    $(".ConfirmUserID").after($(".ConfirmComments"));

    $("#GridEditPAT20002").append("<table style='float: right; width:auto; border-color: #FFF' class='asf-table-view' id='totalAll'></table>");
    $("#totalAll").prepend("<tr id='Total'><td>" + $("#LanguageTD").val() + "</td></tr>");
    $("#Total").append($("#TotalPerformPoint").parent());
    $("#Total").append($("#TotalReevaluatedPoint").parent());
    $("#Total").append($("#TotalUnifiedPoint").parent());
    $(".TotalPerformPoint").remove();
    $(".TotalReevaluatedPoint").remove();
    $(".TotalUnifiedPoint").remove();
    $("#LanguageTD").remove();

    setTimeout(function () {
        $("#GridEditPAT20002 .k-grid-content").css("height", "350px");
        $("#GridEditPAT20002").css("max-height", "400px");
    }, 200)

    $("#EvaluationKitID").bind("change", function (e) {
        if ($("#EvaluationKitID").val() == "" && $("#EvaluationKitID").data("kendoComboBox").dataSource.data().length == 2) {
            $("#EvaluationKitID").data("kendoComboBox").select(0);
            return false;
        }

        var dataEval = $("#EvaluationKitID").data("kendoComboBox").dataItem($("#EvaluationKitID").data("kendoComboBox").select());
        if (dataEval) {
            $("#EvaluationKitName").val(dataEval.EvaluationKitName);
            $("#EvaluationPhaseID").data("kendoComboBox").value(dataEval.EvaluationPhaseID);
            $("#ToDate").data("kendoDatePicker").value(dataEval.ToDate);
            $("#FromDate").data("kendoDatePicker").value(dataEval.FromDate);
            //$("#DutyID").data("kendoComboBox").value(dataEval.DutyID);
            //$("#TitleID").data("kendoComboBox").value(dataEval.TitleID);
        }

        APK = dataEval ? dataEval.APK : null;

        if (APK != null && EvaluationPhaseID != null) {
            $("#TotalPerformPoint").val(formatConvertCommon(0));
            $("#TotalReevaluatedPoint").val(formatConvertCommon(0));
            $("#TotalUnifiedPoint").val(formatConvertCommon(0));
        }
        else {
            clearTotal();
        }

        GridPAT20002.dataSource.read();
    })

    $("#EmployeeID").change(function () {
        if ($("#EmployeeID").val() == "" && $("#EmployeeID").data("kendoComboBox").dataSource.data().length == 1) {
            $("#EmployeeID").data("kendoComboBox").select(0);
            return false;
        }
        var dataEval = $("#EmployeeID").data("kendoComboBox").dataItem($("#EmployeeID").data("kendoComboBox").select());
        if (dataEval) {
            $("#DepartmentID").val(dataEval.DepartmentID);
            $("#DutyID").data("kendoComboBox").value(dataEval.DutyID);
            $("#TitleID").data("kendoComboBox").value(dataEval.TitleID);
            $("#EvaluationKitID").data("kendoComboBox").value("");
            APK = null;
            GridPAT20002.dataSource.data([]);
            LoadConfirm();
        }

    })

    //$("#EvaluationPhaseID").bind("change", function (e) {
    //    if ($("#EvaluationPhaseID").val() == "" && $("#EvaluationPhaseID").data("kendoComboBox").dataSource.data().length == 1) {
    //        $("#EvaluationPhaseID").data("kendoComboBox").select(0);
    //        return false;
    //    }

    //    var dataEval = $("#EvaluationPhaseID").data("kendoComboBox").dataItem($("#EvaluationPhaseID").data("kendoComboBox").select());
    //    if (dataEval) {
    //        $("#ToDate").data("kendoDatePicker").value(dataEval.ToDate);
    //        $("#FromDate").data("kendoDatePicker").value(dataEval.FromDate);
    //    }

    //    var dataSet = $("#EvaluationKitID").data("kendoComboBox").dataItem($("#EvaluationKitID").data("kendoComboBox").select());

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
    //    }
    //    else {
    //        clearTotal();
    //    }

    //    GridPAT20002.dataSource.read();
    //})

});

function CustomRead() {
    var ct = [];
    ct.push(APK);
    if ($("#isUpdate").val() == "False") {
        ct.push($("#EmployeeID").val());
    }
    return ct;
}

function clearTotal() {
    $("#TotalPerformPoint").val("");
    $("#TotalReevaluatedPoint").val("");
    $("#TotalUnifiedPoint").val("");
    $("#ClassificationPerformPoint").val("");
    $("#ClassificationReevaluatedPoint").val("");
    $("#ClassificationUnifiedPoint").val("");
}

function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    if ('Perform' in e.values) {
        isChangeGrid = true;
        var oldPerformPoint = e.model.PerformPoint;
        var PerformPoint = 0;
        var LevelCritical = e.model.LevelCritical ? e.model.LevelCritical : 0;
        if (LevelCritical == 0 || e.values.Perform == null) {
            PerformPoint = 0;
        }
        else {
            if (e.values.Perform > e.model.LevelStandardID && e.model.LevelStandardID) {
                PerformPoint = e.model.Benchmark;
            }
            else {
                PerformPoint = e.model.LevelStandardID == null ? 0 : (e.values.Perform / e.model.LevelStandardID) * e.model.Benchmark;
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.model.Reevaluated == null || e.values.Perform == null) ? 0 : (parseFloat(PerformPoint) + parseFloat(e.model.ReevaluatedPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.AppraisalGroupName) {
                var sumPerformPoint = parseFloat(dtGrid[i].aggregates.PerformPoint.sum) - parseFloat(oldPerformPoint) + parseFloat(PerformPoint);
                var sumUnifiedPoint = parseFloat(dtGrid[i].aggregates.UnifiedPoint.sum) - parseFloat(e.model.UnifiedPoint) + parseFloat(vlUnifiedPoint);
                dtGrid[i].aggregates.PerformPoint.set("sum", sumPerformPoint);
                dtGrid[i].aggregates.UnifiedPoint.set("sum", sumUnifiedPoint);

                if (sumPerformPoint == 0) {
                    dtGrid[i].aggregates.Note.set("count", 0);
                }
                else {
                    var AppraisalGroupNote = sumPerformPoint / dtGrid[i].items[0].AppraisalGroupGoal;
                    GridPAT20002.dataSource._data[i].aggregates.Note.set("count", AppraisalGroupNote);
                }

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
        GridPAT20002.refresh();
    }

    if ('Reevaluated' in e.values) {
        isChangeGrid = true;

        var oldReevaluatedPoint = e.model.ReevaluatedPoint;
        var ReevaluatedPoint = 0;
        var LevelCritical = e.model.LevelCritical ? e.model.LevelCritical : 0;
        if (LevelCritical == 0 || e.values.Reevaluated == null) {
            ReevaluatedPoint = 0;
        }
        else {
            if (e.values.Reevaluated > e.model.LevelStandardID && e.model.LevelStandardID) {
                ReevaluatedPoint = e.model.Benchmark;
            }
            else {
                ReevaluatedPoint = e.model.LevelStandardID == null ? 0 : (e.values.Reevaluated / e.model.LevelStandardID) * e.model.Benchmark;
            }
        }

        var TotalPerformPoint = 0;
        var TotalReevaluatedPoint = 0;
        var TotalUnifiedPoint = 0;
        var dtGrid = e.sender.dataSource._data;
        var vlUnifiedPoint = (e.model.Perform == null || e.values.Reevaluated == null) ? 0 : (parseFloat(ReevaluatedPoint) + parseFloat(e.model.PerformPoint)) / 2;
        for (var i = 0; i < dtGrid.length; i++) {
            if (dtGrid[i].value == e.model.AppraisalGroupName) {
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
        GridPAT20002.refresh();
    }

    if ('UnifiedPoint' in e.values) {
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
                    if (dtGrid[i].value == e.model.AppraisalGroupName) {
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
                GridPAT20002.refresh();
            }
        }
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
    GridPAT20002.dataSource.read();
}

function CustomerCheck() {
    var lengthGrid = GridPAT20002.dataSource._data.length;
    if (lengthGrid <= 0) {
        GridPAT20002.element.addClass('asf-focus-input-error');
        var msg = ASOFT.helper.getMessage('00ML000061');
        ASOFT.form.displayMessageBox("form#" + id, [msg]);
        return true;
    }

    var isCheck = false;
    var listGroup = GridPAT20002.dataSource._data;
    var rowIndex = 1;
    for (var i = 0; i < listGroup.length; i++) {
        var rows = listGroup[i].items;
        for (var j = 0; j < rows.length; j++) {
            var tr = GridPAT20002.tbody.find('tr')[rowIndex];
            if ($("#IsView").val() == 0) {
                if (rows[j].Perform > rows[j].LevelStandardID) {
                    $(tr).addClass("asf-focus-input-error");
                    isCheck = true;
                }
            }
            else {
                if (rows[j].Perform > rows[j].LevelStandardID || rows[j].Reevaluated > rows[j].LevelStandardID) {
                    $(tr).addClass("asf-focus-input-error");
                    isCheck = true;
                }
            }
            rowIndex++;
        }
        rowIndex += 2;
    }

    if (isCheck) {
        var msg = ASOFT.helper.getMessage('PAML000005');
        ASOFT.form.displayMessageBox("form#" + id, [msg]);
    }
    return isCheck;
}

function onAfterInsertSuccess(result, action) {
    if (result.Status == 0 && (action == 1 || action == 2)) {
        clearTotal();
        $("#EmployeeID").data("kendoComboBox").value(ASOFTEnvironment.UserID);
        LoadConfirm();
    }
    if (result.Status == 0 && action == 2) {
        clearTotal();
        GridPAT20002.dataSource.read();
    }
}


function LoadConfirm() {
    var data = {};
    data.userID = $("#EmployeeID").data("kendoComboBox").value();

    ASOFT.helper.postTypeJson("/PA/PAF2000/LoadConfirm", data, function (result) {
        $("#ConfirmUserID").data("kendoComboBox").value(result.EmployeeID);
    })
}
