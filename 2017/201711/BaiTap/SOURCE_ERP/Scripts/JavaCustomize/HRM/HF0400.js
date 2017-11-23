$(document).ready(function () {
    $(".DaysPrevMonth").text(formatDecimal(kendo.parseFloat($(".DaysPrevMonth").text() ? $(".DaysPrevMonth").text() : 0), 1))
    $(".DaysInYear").text(formatDecimal(kendo.parseFloat($(".DaysInYear").text() ? $(".DaysInYear").text() : 0), 1))
    $(".VacSeniorDays").text(formatDecimal(kendo.parseFloat($(".VacSeniorDays").text() ? $(".VacSeniorDays").text() : 0), 1))
    $(".AddDays").text(formatDecimal(kendo.parseFloat($(".AddDays").text() ? $(".AddDays").text() : 0), 1))
    $(".DaysRemained").text(formatDecimal(kendo.parseFloat($(".DaysRemained").text() ? $(".DaysRemained").text() : 0), 1))
    $(".DaysSpentToMonth").text(formatDecimal(kendo.parseFloat($(".DaysSpentToMonth").text() ? $(".DaysSpentToMonth").text() : 0), 1))
    $(".DaysSpent").text(formatDecimal(kendo.parseFloat($(".DaysSpent").text() ? $(".DaysSpent").text() : 0), 1))

    $(".asf-table-view td").attr("style", "width: auto !important;");
    
    var periodMonth = null;
    if (ASOFTEnvironment.Period.length > 0) {
        periodMonth = ASOFTEnvironment.Period.split("/")[0];
    }

    var lblDaysSpentToMonth = $('.DaysSpentToMonth').parent().children().first()
    if (periodMonth != null) {
        if (periodMonth > 1)
    lblDaysSpentToMonth.text(kendo.format(lblDaysSpentToMonth.text(), ASOFTEnvironment.TranMonth - 1, ASOFTEnvironment.TranYear));
        else
            lblDaysSpentToMonth.text(kendo.format(lblDaysSpentToMonth.text(), 12, ASOFTEnvironment.TranYear - 1));
    }

    var lblDaysSpent = $('.DaysSpent').parent().children().first()
    lblDaysSpent.text(kendo.format(lblDaysSpent.text(), ASOFTEnvironment.TranMonth, ASOFTEnvironment.TranYear));
})

function formatDecimal(value, num) {
    var format = null;
    switch (num) {
        case 1:
            format = ASOFTEnvironment.NumberFormat.KendoHolidayDecimalsFormatString;
            break;
        case 2:
            format = ASOFTEnvironment.NumberFormat.KendoQuantityDecimalsFormatString;
            break;
    }
    return kendo.toString(value, format);

}