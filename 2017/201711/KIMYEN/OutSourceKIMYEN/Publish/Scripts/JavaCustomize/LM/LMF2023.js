$(document).ready(function () {
    $('.DisburseVoucherNo').after($('.Description'))
})

function FormatGridExchangeRateDecimails_LM(CurrencyID, ExchangeRate) {
    var url = "/LM/LMF4444/GetExchangeRateDecimal";
    var data = {
        CurrencyID: CurrencyID,
    };
    var format=null;
    ASOFT.helper.postTypeJson(url, data, function (data) {
        if (data.length > 0) {
            let pExchangeRateDecimal = "#,0.{0}";
            let pExchangeRateLength = data[0].ExchangeRateDecimal;
            format= kendo.format(pExchangeRateDecimal, ExchangeRateDecimalLength(pExchangeRateLength));
        }
    });
    return kendo.toString(parseFloat(ExchangeRate), format);
}

function ExchangeRateDecimalLength(targetLength) {
    var output = '';
    while (output.length < targetLength) {
        output = '0' + output;
    }
    if (targetLength != 0) {
        output = output;
    }
    return output;
}
