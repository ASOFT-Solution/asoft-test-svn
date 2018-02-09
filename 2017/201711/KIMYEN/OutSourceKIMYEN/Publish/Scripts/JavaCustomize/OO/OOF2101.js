var ChooseStatus = null;
$(document).ready(function () {
    LoadDepartment();
    $("#btnContractName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/OO/OOF2104", {});
        ChooseStatus = 1;
    })
    $("#btnDeleteContractName").bind('click', function () {
        $("#ContractName").val("");
    })
    //GridAT1020 = $("#GridAT1020").data("kendoGrid");
    //var contractname = $("#ContractName");
    $("#btnDepartmentName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/OO/OOF2103?Type=1", {});
        ChooseStatus = 2;
    });
    $("#btnDeleteDepartment").bind('click', function () {
        $("#DepartmentName").val("");
    });
    $("#btnAssignedToUserName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/OO/CMNF9003", {});
        ChooseStatus = 3;
    });

  
});

function LoadDepartment() {
    var btnLoadDepartment = '<a class="k-button-icontext asf-button k-button" id="btnDepartmentName" style="z-index:10001;position: absolute;right: 28px;height: 25px;min-width: 27px;border: 1px solid #dddddd;" data-role="button" role="button" aria-disabled="false" tabindex="0">…</a>';
    var btnDeleteDepartment = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteDepartment" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"></a>';
    var btnLoadAssignedToUser = '<a class="k-button-icontext asf-button k-button" id="btnAssignedToUserName" style="z-index:10001; position: absolute; right: 28px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0">…</a>';
    var btnDeleteAssignedToUser = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteAssignedToUser" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"></a>';
    var btnLoadLeader = '<a class="k-button-icontext asf-button k-button" id="btnLeaderName" style="z-index:10001; position: absolute; right: 28px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0">…</a>';
    var btnDeleteLeader = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteLeaderName" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0">…</a>';
    $("#DepartmentName").parent().parent().after(btnLoadDepartment);
    $("#DepartmentName").parent().parent().after(btnDeleteDepartment);
    $("#AssignedToUserName").parent().parent().after(btnLoadAssignedToUser);
    $("#AssignedToUserName").parent().parent().after(btnDeleteAssignedToUser);
}
function receiveResult(result) {
   
    if (ChooseStatus == 1) {
       
        $("#ContractName").val(result["ContractName"]);
        $("#ContractID").val(result["ContractName"]);       
    }
    else if (ChooseStatus == 2) {
        var selectItem = [];
        var listItem = [];
        var multiselect = $("#DepartmentName").data("kendoMultiSelect");

        for (var i = 0; i < result.length; i++) {
            var dt = {};
            dt.DepartmentID = result[i]["DepartmentID"];
            dt.DepartmentName = result[i]["DepartmentName"];
            listItem.push(dt)
            selectItem.push(result[i]["DepartmentID"]);
        }
        multiselect.setDataSource(listItem);
        multiselect.value(selectItem);
        //$("#DepartmentName").val(result["DepartmentName"]);
        //$("#DepartmentID").val(result["DepartmentID"]);
    } else if (ChooseStatus == 3) {
        $("#AssignedToUserName").val(result["AssignedToUserName"]);
        $("#AssignedToUserID").val(result["AssignedToUserID"]);
    } else if (ChooseStatus == 4) {
        $("#LeaderName").val(result["LeaderName"]);
        $("#LeaderID").val(result["LeaderID"]);
    }

};

