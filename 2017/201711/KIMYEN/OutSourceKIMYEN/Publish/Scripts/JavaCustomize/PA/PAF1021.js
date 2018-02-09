var GridPAT10202 = null;
var TargetsID = null;

$(document).ready(function () {
    GridPAT10202 = $("#GridEditPAT10202").data("kendoGrid");
    if ($("#isUpdate").val() == "True") {
        CheckUsingCommon();
    }

    GridPAT10202.hideColumn("AppraisalGroupID");
    $("#IsCommon").click(function () {
        if ($("#IsCommon").is(":checked")) {
            $("#DivisionID").data("kendoComboBox").value($("#EnvironmentDivisionID").val());
            $(".DivisionID").hide();
        }
        else {
            $("#DivisionID").data("kendoComboBox").value("");
            $(".DivisionID").show();
        }
        $("#DepartmentID").data("kendoComboBox").value("");
        $("#DutyID").data("kendoComboBox").value("");
        $("#TitleID").data("kendoComboBox").value("");
        $("#EvaluationPhaseID").data("kendoComboBox").value("");
        GridPAT10202.dataSource.data([]);
        GridPAT10202.addRow([]);
    });

    setTimeout(function () {
        $("#GridEditPAT10202 .k-grid-content").css("height", "350px");
        $("#GridEditPAT10202").css("max-height", "400px");
    }, 200)

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
        var dataGrid = GridPAT10202.dataSource._data;
        for (var i = 0; i < dataGrid.length; i++) {
            dataGrid[i].DivisionID = $("#DivisionID").val();
        }
    });

    GridPAT10202.bind('dataBound', function (e) {
        var lengthGrid = GridPAT10202.dataSource._data.length;
        for (var i = 0; i < lengthGrid; i++)
        {
            var item = GridPAT10202.dataSource.at(i);
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
        }
    });

    $(".DutyID").before($(".EvaluationPhaseID"));

    $(GridPAT10202.tbody).on("change", "td", function (e) {
        var data = null;
        var column = e.target.id;
        var selectitem = GridPAT10202.dataItem(e.currentTarget.parentElement);
        var cbb = $("#" + column).data("kendoComboBox");
        if (cbb) {
            data = cbb.dataItem(cbb.select());
        }
        if (column == "cbbAppraisalID") {          
            if (data) {
                if (selectitem.APK == null || selectitem.APK == "") {
                    selectitem.set("APKMaster", "");
                    selectitem.set("CreateUserID", "");
                    selectitem.set("CreateDate", "");
                    selectitem.set("LastModifyUserID", "");
                    selectitem.set("LastModifyDate", "");
                    selectitem.set("OrderNo", "");
                }

                if (data.AppraisalID != "" && data.AppraisalID != null) {
                    selectitem.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : $("#DivisionID").val());
                    selectitem.set("AppraisalID", data.AppraisalID);
                    selectitem.set("AppraisalName", data.AppraisalName);;
                    selectitem.set("Note", data.Note);
                    //selectitem.set("AppraisalGroupGoal", data.AppraisalGroupGoal);
                    //selectitem.set("AppraisalGroupID", data.AppraisalGroupID);
                    //selectitem.set("AppraisalGroupName", data.AppraisalGroupName);
                    selectitem.set("LevelCritical", data.LevelCritical);
                    selectitem.set("LevelStandardID", data.LevelStandardID);
                    //selectitem.set("LevelStandardName", data.LevelStandardName);
                }
            }
        }
        //if (column == "cbbLevelStandardID") {
        //    if (data) {
        //        selectitem.set("LevelStandardID", data.LevelStandardID);
        //        selectitem.set("LevelStandardName", data.LevelStandardName);
        //    }
        //    else {
        //        selectitem.set("LevelStandardID", null);
        //        selectitem.set("LevelStandardName", null);
        //    }
        //}

        if (column == "cbbAppraisalGroupName") {
            if (data) {
                selectitem.set("AppraisalGroupID", data.TargetsGroupID);
                selectitem.set("AppraisalGroupName", data.TargetsGroupName);
                selectitem.set("AppraisalGroupGoal", data.Percentage);
                selectitem.set("AppraisalID", null);
                selectitem.set("AppraisalName", null);
            }
            else {
                selectitem.set("AppraisalGroupID", null);
                selectitem.set("AppraisalGroupName", null);
                selectitem.set("AppraisalGroupGoal", null);
            }
        }
    })
});

function CheckUsingCommon() {
    ASOFT.helper.postTypeJson("/PA/PAF0000/CheckUsingCommon", { KeyValues: $("#EvaluationKitID").val(), TableID: "PAT10201" }, function (result) {
        if (result == 1) {  
            $("#IsCommon").attr("disabled", "disabled");
        }
        else {
            $("#EvaluationKitID").removeAttr("readonly");
        }
    });
}


function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
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

    if ('AppraisalID' in e.values) {
        if (e.values.AppraisalID == "") {
            e.preventDefault();
        }
    }
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
}

function CustomerCheck() {
    var groupTarget = {};
    var sumGroupTarget = 0;
    var isCheck = false;
    var lengthGrid = GridPAT10202.dataSource._data.length;
    var languageGroup = GridPAT10202.thead.find('th[data-field="AppraisalGroupGoal"]').attr('data-title');
    for (var i = 0; i < lengthGrid; i++) {
        var item = GridPAT10202.dataSource.at(i);
        if (!(item.AppraisalGroupID in groupTarget)) {
            groupTarget[item.AppraisalGroupID] = item.AppraisalGroupGoal;
            sumGroupTarget += parseFloat(item.AppraisalGroupGoal);
        }
        else {
            if (groupTarget[item.AppraisalGroupID] != item.AppraisalGroupGoal) //tỷ trọng nhóm khác nhau
            {
                var msg = kendo.format(ASOFT.helper.getMessage('00ML000120'), '"' + item.AppraisalGroupName + '"', languageGroup);
                ASOFT.form.displayMessageBox("form#" + id, [msg]);
                return true;
            }
        }
    }

    if (sumGroupTarget != 100) //Kiểm tra % tất cả các group phải bằng 100%
    {
        var msg = kendo.format(ASOFT.helper.getMessage('00ML000118'), languageGroup);
        ASOFT.form.displayMessageBox("form#" + id, [msg]);
        return true;
    }

    return isCheck;
}
