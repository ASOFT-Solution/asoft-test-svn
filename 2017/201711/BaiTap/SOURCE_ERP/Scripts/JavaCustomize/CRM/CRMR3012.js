var action = null;

$(document).ready(function () {
    var btnFromAccountID = '<a id="btnFromAccountID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromCampaign_Click(1)">...</a>';

    var btnDeleteFromAccountID = '<a id="btnDeleteFromAccountID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromCampaign_Click(1)"></a>';

    var btnToAccountID = '<a id="btnToAccountID" style="z-index:10001; position: absolute; right: 47px; height: 25px ; min-width: 27px;" data-role="button" class="k-button k-button-icontext asf-button" role="button" aria-disabled="false" tabindex="0" onclick="btnFromCampaign_Click(2)">...</a>';

    var btnDeleteToAccountID = '<a id="btnDeleteToAccountID" style="z-index:10001; position: absolute; right: 19px; height: 25px; min-width: 27px; border: 1px solid #dddddd;" data-role="button" class="k-button k-button-icontext  asf-i-delete-32" role="button" aria-disabled="false" tabindex="0" onclick="btnDeleteFromCampaign_Click(2)"></a>';

    $("#FromCampaignName").attr('disabled', 'disabled');
    $("#ToCampaignName").attr('disabled', 'disabled');
    $("#FromCampaignName").after(btnFromAccountID);
    $("#FromCampaignName").after(btnDeleteFromAccountID);
    $("#ToCampaignName").after(btnToAccountID);
    $("#ToCampaignName").after(btnDeleteToAccountID);

    $("#CheckListPeriodControl").attr("data-val-required", "The field is required.");
    $("#FromDatePeriodControl").attr("data-val-required", "The field is required.");
    $("#ToDatePeriodControl").attr("data-val-required", "The field is required.");

})

function CustomerCheck() {
    return ASOFT.form.checkRequired("FormReportFilter");
}

function btnFromCampaign_Click(type) {
    var urlChoose = "/PopupSelectData/Index/CRM/CRMF9008?DivisionID=" + $("#EnvironmentDivisionID").val();
    ASOFT.form.clearMessageBox();
    action = type;
    ASOFT.asoftPopup.showIframe(urlChoose, {});
}


function btnDeleteFromCampaign_Click(type) {
    if (type == 1) {
        $("#FromCampaignName").val('');
        $("#FromCampaignID").val('');
    }

    if (type == 2) {
        $("#ToCampaignName").val('');
        $("#ToCampaignID").val('');
    }
}

function receiveResult(result) {
    if (action == 1) {
        $("#FromCampaignName").val(result["CampaignName"]);
        $("#FromCampaignID").val(result["CampaignID"]);
    }
    if (action == 2) {
        $("#ToCampaignName").val(result["CampaignName"]);
        $("#ToCampaignID").val(result["CampaignID"]);
    }
}



