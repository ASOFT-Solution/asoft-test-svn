var GridKPIT20102 = null;
var DepartmentID = null;
var EvaluationPhaseID = null;
var isDelete = false;

$(document).ready(function () {

    GridKPIT20102 = $("#GridEditKPIT20102").data("kendoGrid");

    if ($("#isUpdate").val() == "False") {
        $("#DeleteFlg").val(0);
    }

    GridKPIT20102.bind('dataBound', function (e) {
        var amount = 0;
        var lengthGrid = GridKPIT20102.dataSource._data.length;
        if (lengthGrid > 0) {
            for (var i = 0; i < lengthGrid; i++) {
                var item = GridKPIT20102.dataSource.at(i);

                if ($("#isUpdate").val() == "False") {
                    item.set("LastModifyDate", "");
                    item.set("CreateDate", "");
                    item.set("LastModifyUserID", "");
                    item.set("CreateUserID", "");
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
                if (item.BonusAmount != "" && item.BonusAmount != null)
                {
                    amount += item.BonusAmount;
                }
            }
            $("#TotalBonusAmount").val(amount);
        }
    });

    
    $("#GridEditKPIT20102").attr("AddNewRowDisabled", "false");

    $("#EvaluationPhaseID").bind("change", function (e) {
        if ($("#EvaluationPhaseID").val() == "" && $("#EvaluationPhaseID").data("kendoComboBox").dataSource.data().length == 1) {
            $("#EvaluationPhaseID").data("kendoComboBox").select(0);
            return false;
        }

        EvaluationPhaseID = $("#EvaluationPhaseID").data("kendoComboBox").value();
        DepartmentID = $("#DepartmentID").data("kendoComboBox").value();

        GridKPIT20102.dataSource.read();
    })

    $("#DepartmentID").bind("change", function (e) {
        if ($("#DepartmentID").val() == "" && $("#DepartmentID").data("kendoComboBox").dataSource.data().length == 1) {
            $("#DepartmentID").data("kendoComboBox").select(0);
            return false;
        }

        EvaluationPhaseID = $("#EvaluationPhaseID").data("kendoComboBox").value();
        DepartmentID = $("#DepartmentID").data("kendoComboBox").value();

        GridKPIT20102.dataSource.read();
    })
});

function CustomRead() {
    var ct = [];

    if (DepartmentID != null && EvaluationPhaseID != null) {
        ct.push(DepartmentID);
        ct.push(EvaluationPhaseID);
    }
    return ct;
}


function Grid_SaveCustom(e) {
    if (e.values == undefined || e.values == null) {
        return true;
    }

    if ('Revenue' in e.values)
    {
        if (e.values.Revenue) {
            var BonusAmount = (e.values.Revenue * e.model.BonusRate) / 100;
            e.model.set("BonusAmount", BonusAmount);
        }
        else {
            e.model.set("BonusAmount", 0);
        }
        GridKPIT20102.refresh();
    }
}


function onAfterInsertSuccess(result, action) {
    if (action == 1 && result.Status == 0) {
        EvaluationPhaseID = null;
        DepartmentID = null;
        $("#DeleteFlg").val(0);
    }
}