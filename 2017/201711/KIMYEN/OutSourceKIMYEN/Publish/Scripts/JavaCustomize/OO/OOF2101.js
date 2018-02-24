var ChooseStatus = null;
$(document).ready(function () {
    LoadDepartment();
    
    $("#btnContractName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/OO/OOF2104", {});
        ChooseStatus = 1;
    })
    $("#btnDeleteContractName").bind('click', function () {
        $("#ContractName").val("");
        $("#ContractID").val("");
        
    })
    //GridAT1020 = $("#GridAT1020").data("kendoGrid");
    //var contractname = $("#ContractName");
    $("#btnDepartmentName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/OO/OOF2103?Type=1", {});
        ChooseStatus = 2;
    });
    $("#btnDeleteDepartment").bind('click', function () {
        $("#DepartmentName").data("kendoMultiSelect").setDataSource([]);
        $("#DepartmentName").data("kendoMultiSelect").value('');
        //$("#DepartmentID").data("kendoMultiSelect").setDataSource([]);
        $("#DepartmentID").data("kendoMultiSelect").value('');
    });
    $("#btnAssignedToUserName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/00/CMNF9003?Type=1&DivisionID="+ $("#EnvironmentDivisionID").val(), {});
        ChooseStatus = 3;
    });
    $("#btnDeleteAssignedToUser").bind('click', function () {
        $("#AssignedToUserName").data("kendoMultiSelect").setDataSource([]);
        $("#AssignedToUserName").data("kendoMultiSelect").value('');
        //$("#AssignedToUserID").data("kendoMultiSelect").setDataSource([]);
        //$("#AssignedToUserID").data("kendoMultiSelect").value('');
    });
    $("#btnLeaderName").bind('click', function () {
        ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/00/CMNF9003?DivisionID="+ $("#EnvironmentDivisionID").val(), {});
        ChooseStatus = 4;
    });
    $("#btnDeleteLeaderName").bind('click', function () {
        $("#LeaderName").val("");
        $("#LeaderID").val("");
    });
});

function LoadDepartment() {
    var btnLoadDepartment = '<a class="k-button-icontext asf-button k-button" id="btnDepartmentName" style="z-index:10001;position: absolute;right: 28px;height: 25px;min-width: 27px;border: 1px solid #dddddd;" data-role="button" role="button" aria-disabled="false" tabindex="0">...</a>';
    var btnDeleteDepartment = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteDepartment" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"></a>';
    var btnLoadAssignedToUser = '<a class="k-button-icontext asf-button k-button" id="btnAssignedToUserName" style="z-index:10001; position: absolute; right: 28px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0">...</a>';
    var btnDeleteAssignedToUser = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteAssignedToUser" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"></a>';
    //var btnLoadLeader = '<a class="k-button-icontext asf-button k-button" id="btnLeaderName" style="z-index:10001; position: absolute; right: 28px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0">...</a>';
    //var btnDeleteLeader = '<a class="asf-i-delete-32 k-button-icontext k-button" id="btnDeleteLeaderName" style="z-index:10001; position: absolute; right: 0px; height: 25px; min-width: 27px; border: 1px solid #dddddd" data-role="button" role="button" aria-disabled="false" tabindex="0"></a>';


    $("#DepartmentName").parent().parent().after(btnLoadDepartment);
    $("#DepartmentName").parent().parent().after(btnDeleteDepartment);
    $("#AssignedToUserName").parent().parent().after(btnLoadAssignedToUser);
    $("#AssignedToUserName").parent().parent().after(btnDeleteAssignedToUser);
    //$("#LeaderName").parent().parent().after(btnLoadLeader);
    //$("#LeaderName").parent().parent().after(btnDeleteLeader);
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
        var selectItem = [];
        var listItem = [];
        var multiselect = $("#AssignedToUserName").data("kendoMultiSelect");
        for (var i = 0; i < result.length; i++) {
            var dt = {};
            dt.AssignedToUserID = result[i]["EmployeeID"];
            dt.AssignedToUserName = result[i]["EmployeeName"];
            listItem.push(dt);
            selectItem.push(result[i]["EmployeeID"]);
            //$("#AssignedToUserName").val(result["AssignedToUserName"]);
            //$("#AssignedToUserID").val(result["AssignedToUserID"]);
        }
        multiselect.setDataSource(listItem);
        multiselect.value(selectItem);
    } else if (ChooseStatus == 4) {
        //var selectItem = [];
        //var Item = [];
        //var multiselect = $("#LeaderName").data("kendoMultiSelect");
        //var dt = {};
        //dt.LeaderID = result["EmployeeID"];
        //dt.LeaderName = result["EmployeeName"];
        //Item.push(dt);
        //selectItem.push(result["EmployeeID"]);
        //multiselect.setDataSource(Item);
        //multiselect.value(selectItem);
        $("#LeaderName").val(result["EmployeeName"]);
        $("#LeaderID").val(result["EmployeeID"]);
    }

};

