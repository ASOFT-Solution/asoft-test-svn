var GridKPIT10702 = null;
var TargetsID = null;

$(document).ready(function () {

    if (parent.isSaveCopy && $("#isUpdate").val() == "True") {
        $("#isUpdate").val("False")
        $("#BtnSave").unbind();
        $("#BtnSave").kendoButton({
            "click": SaveCustom_Click,
        });
        $(".Disabled").hide();
        $("#EvaluationSetID").removeAttr("readonly");
        $("#APK").val("");
    }
    else {
        parent.isSaveCopy = false;
    }

    GridKPIT10702 = $("#GridEditKPIT10702").data("kendoGrid");
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    GridKPIT10702.hideColumn("TargetsGroupID");
    setTimeout(function () {
        $("#GridEditKPIT10702 .k-grid-content").css("height", "350px");
        $("#GridEditKPIT10702").css("max-height", "400px");
    }, 200)

    $("#IsCommon").click(function () {
        if ($("#IsCommon").is(":checked")) {
            $("#DivisionID").data("kendoComboBox").value($("#EnvironmentDivisionID").val());
            $(".DivisionID").hide();
        }
        else {
            $("#DivisionID").data("kendoComboBox").value("");
            $(".DivisionID").show();
        }
        //var dataGrid = GridKPIT10702.dataSource._data;
        //for (var i = 0; i < dataGrid.length; i++)
        //{
        //    dataGrid[i].DivisionID = $("#IsCommon").is(":checked") ? "@@@" : $("#DivisionID").val();
        //}
        $("#DepartmentID").data("kendoComboBox").value("");
        $("#DutyID").data("kendoComboBox").value("");
        $("#TitleID").data("kendoComboBox").value("");
        $("#EvaluationPhaseID").data("kendoComboBox").value("");
        GridKPIT10702.dataSource.data([]);
        GridKPIT10702.addRow([]);
    });

    if ($("#IsCommon").is(":checked")) {
        $(".DivisionID").hide();
        $("#DivisionID").data("kendoComboBox").value($("#EnvironmentDivisionID").val());
        OpenComboDynamic($("#DepartmentID").data("kendoComboBox"));
        OpenComboDynamic($("#DutyID").data("kendoComboBox"));
        OpenComboDynamic($("#TitleID").data("kendoComboBox"));
        OpenComboDynamic($("#EvaluationPhaseID").data("kendoComboBox"));
    }
    else {
        $(".DivisionID").show();
    }

    $("#DivisionID").change(function () {
        var dataGrid = GridKPIT10702.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            dataGrid[i].DivisionID =  $("#DivisionID").val();
        }
    });

    GridKPIT10702.bind('dataBound', function (e) {
        var lengthGrid = GridKPIT10702.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++)
        {
            var item = GridKPIT10702.dataSource.at(i);
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
            if (parent.isSaveCopy)
            {
                item.set("APK", "");
            }
        }
    });

    $(".DutyID").before($(".EvaluationPhaseID"));

    $(GridKPIT10702.tbody).on("change", "td", function (e) {
        var data = null;
        var column = e.target.id;
        var selectitem = GridKPIT10702.dataItem(e.currentTarget.parentElement);
        var cbb = $("#" + column).data("kendoComboBox");
        if (cbb) {
            data = cbb.dataItem(cbb.select());
        }

        if (column == "cbbTargetsID") {          
            if (data) {
                if (selectitem.APK == null || selectitem.APK == "") {
                    selectitem.set("APKMaster", "");
                    selectitem.set("CreateUserID", "");
                    selectitem.set("CreateDate", "");
                    selectitem.set("LastModifyUserID", "");
                    selectitem.set("LastModifyDate", "");
                    selectitem.set("OrderNo", "");
                }

                if (data.TargetsID != "" && data.TargetsID != null) {
                    selectitem.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : $("#DivisionID").val());
                    selectitem.set("TargetsID", data.TargetsID);
                    selectitem.set("TargetsName", data.TargetsName);
                    selectitem.set("Benchmark", data.Benchmark);
                    selectitem.set("Categorize", data.Categorize);
                    selectitem.set("CategorizeName", data.CategorizeName);
                    selectitem.set("FormulaName", data.FormulaName);
                    selectitem.set("FrequencyID", data.FrequencyID);
                    selectitem.set("FrequencyName", data.FrequencyName);
                    selectitem.set("GoalLimit", data.GoalLimit);
                    selectitem.set("Note", data.Note);
                    selectitem.set("TargetsPercentage", data.TargetsPercentage);
                    selectitem.set("Revenue", data.Revenue);
                    selectitem.set("SourceID", data.SourceID);
                    selectitem.set("SourceName", data.SourceName);
                    selectitem.set("UnitKpiID", data.UnitKpiID);
                    selectitem.set("UnitKpiName", data.UnitKpiName);
                    //selectitem.set("TargetsGroupPercentage", data.TargetsGroupPercentage);
                }
            }
        }
        if (column == "cbbTargetsGroupName") {
            if (data) {
                if (data.TargetsGroupID != "" && data.TargetsGroupID != null) {
                    selectitem.set("TargetsGroupID", data.TargetsGroupID);
                    selectitem.set("TargetsGroupName", data.TargetsGroupName);
                    selectitem.set("TargetsGroupPercentage", data.Percentage);
                }
                selectitem.set("TargetsID", null);
                selectitem.set("TargetsName", null);
            }
            else {
                selectitem.set("TargetsGroupID", null);
                selectitem.set("TargetsGroupName", null);
                selectitem.set("TargetsGroupPercentage", null);
            }
        }
        if (column == "cbbUnitKpiName") {
            if (data) {
                selectitem.set("UnitKpiID", data.UnitKpiID);
                selectitem.set("UnitKpiName", data.UnitKpiName);
            }
            else {
                selectitem.set("UnitKpiID", null);
                selectitem.set("UnitKpiName", null);
            }
        }
        if (column == "cbbFrequencyName") {
            if (data) {
                selectitem.set("FrequencyID", data.ID);
                selectitem.set("FrequencyName", data.Description);
            }
            else {
                selectitem.set("FrequencyID", null);
                selectitem.set("FrequencyName", null);
            }
        }
        if (column == "cbbSourceName") {
            if (data) {
                selectitem.set("SourceID", data.SourceID);
                selectitem.set("SourceName", data.SourceName);
            }
            else {
                selectitem.set("SourceID", null);
                selectitem.set("SourceName", null);
            }
        }
        if (column == "cbbCategorizeName") {
            if (data) {
                selectitem.set("Categorize", data.ID);
                selectitem.set("CategorizeName", data.Description);
            }
            else {
                selectitem.set("Categorize", null);
                selectitem.set("CategorizeName", null);
            }
        }
    })
});

function SaveCustom_Click() {
    var url = "/GridCommon/InsertPopupMasterDetail/" + module + "/" + id;
    action = 2;
    save(url);
}


function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }
    if (e.values.TargetsGroupPercentage != undefined) {
        var x = kendo.parseFloat(e.values.TargetsGroupPercentage/100) * kendo.parseFloat(e.model.TargetsPercentage/100) * 100;
        e.model.set("Benchmark", x);
    }
    if (e.values.TargetsPercentage != undefined) {
        var x = kendo.parseFloat(e.model.TargetsGroupPercentage/100) * kendo.parseFloat(e.values.TargetsPercentage/100) * 100;
        e.model.set("Benchmark", x);
    }
    if ('TargetsGroupName' in e.values) {
        if (e.values.TargetsGroupName == "" && e.values.TargetsGroupName == null) {
            e.model.set("TargetsGroupPercentage", 0);
            var x = 0 * kendo.parseFloat(e.model.TargetsPercentage/100) * 100;
            e.model.set("Benchmark", x);
        }
    }

    if ('TargetsGroupName' in e.values) {
        if (e.values.TargetsGroupName == "") {
            e.preventDefault();
        }
    }
    
    if ('TargetsID' in e.values) {
        if (e.values.TargetsID == "") {
            e.preventDefault();
        }
    }
    //if ('TargetsGroupName' in e.values) {
    //    if (e.values.TargetsGroupName == "") {
    //        e.preventDefault();
    //    }
    //}
}

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/KPI/KPIF0000/CheckUsingCommon", { KeyValues: $("#EvaluationSetID").val(), TableID: "KPIT10701" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#EvaluationSetID").removeAttr("readonly");
        }
    });
}


function onAfterInsertSuccess(result, action) {
    if (action == 4 && result.Status == 0) {
        var url = parent.GetUrlContentMaster();
        var listSp = url.split('&');
        var division = listSp[listSp.length - 1];
        if ($("#IsCommon").is(':checked')) {
            url = url.replace(division, "DivisionID=" + "@@@");
        }
        else {
            url = url.replace(division, "DivisionID=" + $("#EnvironmentDivisionID").val());
        }
        window.parent.parent.location = url;
        parent.setReload();
    }
    if (action == 2 && result.Status == 0 && parent.isSaveCopy) {
        if (typeof parent.refreshGrid === "function") {
            parent.refreshGrid();
        }
        parent.isSaveCopy = false;
        parent.popupClose();
    }
}

function CustomerCheck() {
    var groupTarget = {};
    var groupTargetSum = {};
    var sumGroupTarget = 0;
    var nameGroup = {};
    var isCheck = false;
    var lengthGrid = GridKPIT10702.dataSource._data.length;
    var languageGroup = GridKPIT10702.thead.find('th[data-field="TargetsGroupPercentage"]').attr('data-title');
    for (var i = 0; i < lengthGrid; i++) {
        var item = GridKPIT10702.dataSource.at(i);
        if (!(item.TargetsGroupID in groupTarget)) {
            groupTarget[item.TargetsGroupID] = item.TargetsGroupPercentage;
            sumGroupTarget += parseFloat(item.TargetsGroupPercentage);
        }
        else {
            if (groupTarget[item.TargetsGroupID] != item.TargetsGroupPercentage) //tỷ trọng nhóm khác nhau
            {
                var msg = kendo.format(ASOFT.helper.getMessage('00ML000120'), '"' + item.TargetsGroupName + '"', languageGroup);
                ASOFT.form.displayMessageBox("form#" + id, [msg]);
                return true;
            }
        }

        groupTargetSum[item.TargetsGroupID] =  groupTargetSum[item.TargetsGroupID] ?  groupTargetSum[item.TargetsGroupID] : 0;
        groupTargetSum[item.TargetsGroupID] += parseFloat(item.TargetsPercentage);
        nameGroup[item.TargetsGroupID] = item.TargetsGroupName;
    }

    if (sumGroupTarget != 100) //Kiểm tra % tất cả các group phải bằng 100%
    {
        var msg = kendo.format(ASOFT.helper.getMessage('00ML000118'), languageGroup);
        ASOFT.form.displayMessageBox("form#" + id, [msg]);
        return true;
    }
    
    $.each(groupTargetSum, function (key, value) { // Kiểm tra % của từng group bằng 100%
        if (value != 100)
        {
            var msg = kendo.format(ASOFT.helper.getMessage('00ML000119'), '"' + nameGroup[key] + '"');
            ASOFT.form.displayMessageBox("form#" + id, [msg]);
            isCheck = true;
            return;
        }
    })

    return isCheck;
}