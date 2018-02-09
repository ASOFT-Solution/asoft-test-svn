
$(document).ready(function () {
    if ($(".BonusRate").text() != "") {
        $(".BonusRate").text(formatPercent(kendo.parseFloat($(".BonusRate").text())));
    }
    if ($(".FromScore").text() != "") {
        $(".FromScore").text(formatConvert(kendo.parseFloat($(".FromScore").text())));
    }
    if ($(".ToScore").text() != "") {
        $(".ToScore").text(formatConvert(kendo.parseFloat($(".ToScore").text())));
    }
});

function formatPercent(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoPercentDecimalsFormatString;
    return kendo.toString(value, format);
}

function formatConvert(value) {
    var format = ASOFTEnvironment.NumberFormat.KendoConvertedDecimalsFormatString;
    return kendo.toString(value, format);
}


