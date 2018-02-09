$(document).ready(function () {
    CSMF1071.disabledcontrol();
});
var CSMF1071 = new function () {
    this.disabledcontrol = function () {
        if ($("#isUpdate").val() == "True") {
            $("#IsCommon").attr("disabled", "disabled");
            $("#CheckListType").kendoComboBox({ enable: false });
        }
    }
    this.checkunique = function () {
        var checklisttype = $("#CheckListType").val();
        var grid = $("#GridEditCSMT1071").data("kendoGrid");
        var dataSource = grid.dataSource._data;
        var lenght = dataSource.length;
        var result1 = false;
        var url = "/CSM/CSMF1070/CheckUnique";
        for (var i = 0; i < lenght; i++) {
            JobID = dataSource[i]["JobID"];
            var data = {
                CheckListType: checklisttype,
                JobID: JobID
            };
            ASOFT.helper.postTypeJson(url, data, function (result) {
                if (result == "True") {
                    result1 = true;
                }
            });
            break;
        }
        return result1;
    }
}
function CustomerCheck() {
    if ($("#isUpdate").val() == "False") {
        if (CSMF1071.checkunique()) {
            //var grid = $("#GridEditCSMT1071").data("kendoGrid");
            //var columnname = grid.columns[1]["title"];
            var message_array = [];
            message_array.push(ASOFT.helper.getLabelText("JobID", "00ML000053"));
            ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array);
            return true;
        }
        else {
            return false;
        }
    } else {
        return false;
    }
}

