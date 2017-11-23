

$(document).ready(function () {
    $("#TxtSearch").css("width", "84%");
    $("#btnSearchObject").css("position", "inherit");
    var addCampaign = '&nbsp<a id="btnAddObject" class="k-button-icontext asf-button" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="addCampaing_click()"><span class="k-sprite asf-i-add-search-24"></span></a>';
    $("#btnSearchObject").after(addCampaign);
    $("#btnAddObject").css("position", "inherit");
})

function addCampaing_click() {
    var Url = '/PopupLayout/Index/CRM/CRMF2051?isAdd=1'
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(Url, {});
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};
