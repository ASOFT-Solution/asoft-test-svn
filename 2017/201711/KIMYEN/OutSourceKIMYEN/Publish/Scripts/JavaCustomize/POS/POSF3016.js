
$(document).ready(function () {
    $("#PeriodID").change(function (e) {
        var cbb = $("#PeriodID").data("kendoComboBox");
        var dataItem = cbb.dataItem(cbb.select());
        $("#Date01").data("kendoDatePicker").value(dataItem.DATE01);
        $("#Date02").data("kendoDatePicker").value(dataItem.DATE02);
        $("#Date03").data("kendoDatePicker").value(dataItem.DATE03);
        $("#Date04").data("kendoDatePicker").value(dataItem.DATE04);
        $("#TranMonth").val(dataItem.TranMonth);
        $("#TranYear").val(dataItem.TranYear);
    })

    $("#PeriodID").attr("data-val-required", "The field is required.");
    $(".PeriodID .asf-td-caption").append('<span class="asf-label-required">*</span>');
    $(".Date01").hide();
    $(".Date02").hide();
    $(".Date03").hide();
    $(".Date04").hide();
    $(".TranMonth").hide();
    $(".TranYear").hide();
})