
$(document).ready(function () {

    if(typeof parent.returnAccountName === "function"){
        $("#TxtSearch").val(parent.returnAccountName());
        var GridKendo = $('#GridCRMT10101').data('kendoGrid');
        GridKendo.dataSource.page(1);
    }

    $("#TxtSearch").css("width", "86%");
    $("#btnSearchObject").css("position", "inherit");
    var addCampaign = '&nbsp<a id="btnAddObject" class="k-button-icontext asf-button" style="" data-role="button" role="button" aria-disabled="false" tabindex="0" onclick="addCampaing_click()"><span class="k-sprite asf-i-add-search-24"></span></a>';
    $("#btnSearchObject").after(addCampaign);
    $("#btnAddObject").css("position", "inherit");
})

function addCampaing_click() {
    var Url = '/PopupLayout/Index/CRM/CRMF1011?isAdd=1'
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(Url, {});
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};
