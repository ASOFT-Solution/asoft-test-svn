
$(document).ready(function () {
    var data = parent.GetVarchar();
    if (data != null && data !== "undefined") {
        $("#Varchar01").val(data.Varchar01);
        $("#Varchar02").val(data.Varchar02);
        $("#Varchar03").val(data.Varchar03);
        $("#Varchar04").val(data.Varchar04);
        $("#Varchar05").val(data.Varchar05);
        $("#Varchar06").val(data.Varchar06);
        $("#Varchar07").val(data.Varchar07);
        $("#Varchar08").val(data.Varchar08);
        $("#Varchar09").val(data.Varchar09);
        $("#Varchar10").val(data.Varchar10);
        $("#Varchar11").val(data.Varchar11);
        $("#Varchar12").val(data.Varchar12);
        $("#Varchar13").val(data.Varchar13);
        $("#Varchar14").val(data.Varchar14);
        $("#Varchar15").val(data.Varchar15);
        $("#Varchar16").val(data.Varchar16);
        $("#Varchar17").val(data.Varchar17);
        $("#Varchar18").val(data.Varchar18);
        $("#Varchar19").val(data.Varchar19);
        $("#Varchar20").val(data.Varchar20);
    }
})

function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}

function btnSaveVarchar_Click() {
    var data = ASOFT.helper.dataFormToJSON("CRMF1013");
    parent.SetVarchar(data);
    btnCancle_Click();
}
