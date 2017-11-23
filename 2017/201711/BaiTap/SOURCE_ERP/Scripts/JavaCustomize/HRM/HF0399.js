

var tablecontent = null;
var screen = null;
$(document).ready(function () {
    HF0399.grid = $('#GridHT2803').data('kendoGrid');
    $('#BtnInherit').unbind();
    $("#BtnInherit").kendoButton({
        "click": CustomBtnInherit_Click,
    });

    $('#BtnInheritHS').unbind();
    $("#BtnInheritHS").kendoButton({
        "click": CustomBtnInheritHS_Click,
    });

    $('#BtnCalVacation').unbind();
    $('#BtnCalVacation').kendoButton({
        "click": CustomBtnCalVacation_Click,
    });

    screen = $("#sysScreenID").val();
    tablecontent = $("#sysTable" + screen).val();
    
    var periodMonth = null;
    if (ASOFTEnvironment.Period.length > 0) {
        periodMonth = ASOFTEnvironment.Period.split("/")[0];
    }

    var lblDaysSpentToMonth = $('#GridHT2803').find("th[data-field='DaysSpentToMonth']")
    if (periodMonth != null) {
        if (periodMonth > 1)
            lblDaysSpentToMonth.text(kendo.format(lblDaysSpentToMonth.text(), ASOFTEnvironment.TranMonth - 1, ASOFTEnvironment.TranYear));
        else
            lblDaysSpentToMonth.text(kendo.format(lblDaysSpentToMonth.text(), 12, ASOFTEnvironment.TranYear - 1));
    }

    var lblDaysSpent = $('#GridHT2803').find("th[data-field='DaysSpent']")
    lblDaysSpent.text(kendo.format(lblDaysSpent.text(), ASOFTEnvironment.TranMonth, ASOFTEnvironment.TranYear));
})
function BtnExport_Click() {
}

function CustomBtnInherit_Click() {
    url = '/HRM/HF0407/Index';
    ASOFT.asoftPopup.showIframe(url, {});
}

function CustomBtnInheritHS_Click() {
    url = '/HRM/HF0404/Index';
    ASOFT.asoftPopup.showIframe(url, {});
}

function CustomBtnCalVacation_Click(){
    url = '/HRM/HF0405/Index';
    ASOFT.asoftPopup.showIframe(url, {});
}

HF0399 = new function () {
    this.grid = null;
    this.IsSearch = false;
};