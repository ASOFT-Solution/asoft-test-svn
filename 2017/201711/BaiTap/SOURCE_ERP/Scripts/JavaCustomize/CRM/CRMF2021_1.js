
var isRoute;
var CustomCheckStatus;
$(document).ready(function () {
    $(".grid_6").removeClass();
    $(".grid_6").addClass("form-content");

    $("#RouteName").css("width", "88%");
    $("#DeliveryEmployeeName").css("width", "88%");

    //$("#RouteName").after("<input type='button' value='...' onclick='CRMF2021_Route_Click()' />");
    ASOFT.partialView.Load("/CRM/CRMF2021/CRMF2021_Route", "#RouteName", 0);
    //$("#DeliveryEmployeeName").after("<input type='button' value='...' onclick='CRMF2021_DeliveryEmployee_Click()' />");
    ASOFT.partialView.Load("/CRM/CRMF2021/CRMF2021_DeliveryEmployee", "#DeliveryEmployeeName", 0);

    ReventFocus("VATObjectName,RouteName,DeliveryEmployeeName");
});

function CRMF2021_Route_Click() {
    isRoute = true;
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/CRM/CMNF9002?DivisionID=" + $("#DivisionID").val(), {});
}
function CRMF2021_DeliveryEmployee_Click() {
    isRoute = false;
    ASOFT.asoftPopup.showIframe("/PopupSelectData/Index/00/CMNF9003?DivisionID=" + $("#DivisionID").val(), {});
}
function receiveResult(result)
{
    if (isRoute) {
        $("#RouteID").val(result["RouteID"]);
        $("#RouteName").val(result["RouteName"]);
    }
    else {
        $("#DeliveryEmployeeID").val(result["EmployeeID"]);
        $("#DeliveryEmployeeName").val(result["EmployeeName"]);
    }
}

function ReventFocus(ListID) {
    var Ar = ListID.split(',');
    for (i = 0; i < Ar.length; i++)
    {
        $("#" + Ar[i]).css("background-color", "#d0c9c9")
        $("#" + Ar[i]).focus(function () { $(this).blur() });
    }
};

function CustomerConfirm() {
    var data = {DeliveryEmployeeID:$("#DeliveryEmployeeID").val()};
    ASOFT.helper.postTypeJson("/CRM/CRMF2021/CheckDeliveryStatus", data, CRMF2021_CheckStatus);
    return CustomCheckStatus;
};

function CRMF2021_CheckStatus(result) {
    result.Message = kendo.format(ASOFT.helper.getMessage(result.MessageID), result.Data);
    CustomCheckStatus = result;
};