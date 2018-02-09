$(document).ready(function () {
    EventClick();
    $("#IsUseTaxAgent").click(function(){
        EventClick();
    })
});

function EventClick() {
    if ($("#IsUseTaxAgent").is(':checked')) {
        EnableTax(0);
    }
    else {
        EnableTax(1);
    }
}

function EnableTax(type) {
    var disabletxt = false;
    var enable = true;
    if (type == 1)
    {
        enable = false;
        disabletxt = "disabled";
    }
    $("#TaxAgentNo").attr("disabled", disabletxt);
    $("#TaxAgentName").attr("disabled", disabletxt);
    $("#TaxAgentAddress").attr("disabled", disabletxt);
    $("#TaxAgentFax").attr("disabled", disabletxt);
    $("#TaxAgentDistrict").attr("disabled", disabletxt);
    $("#TaxAgentCity").attr("disabled", disabletxt);
    $("#TaxAgentTel").attr("disabled", disabletxt);
    $("#TaxAgentEmail").attr("disabled", disabletxt);
    $("#TaxAgentContractNo").attr("disabled", disabletxt);
    $("#TaxAgentContractDate").data("kendoDatePicker").enable(enable);
    $("#TaxAgentPerson").attr("disabled", disabletxt);
    $("#TaxAgentCertificate").attr("disabled", disabletxt);
}