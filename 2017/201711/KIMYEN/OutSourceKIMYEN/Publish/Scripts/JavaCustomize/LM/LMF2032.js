$(document).ready(function () {
    LoadPartialFilter();

})
var rowNumber = 0;
function LoadPartialFilter() {
    $.ajax({
        url: '/Partial/GridPartialLMP2031?screenID=LMF2032',
        type: "GET",
        async: false,
        success: function (result) {
            $("#LMF2032_SubTitle2-1 div.asf-master-content").html(result);
            var ip = $(":input[type='text']");
            $(ip).each(function () {
                $(this).attr("name", this.id);
            });
        }
    });
}

function renderNumber(data) {
    return ++rowNumber;
}
function sendDataLMP2031() {
    var dataLoad = {
        VoucherID: getUrlParameter("PK"),
        IsViewDetail: 0
    };
    return dataLoad;
}

var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function PaymentDate_ClientTemplate(PaymentDate) {
    var date = PaymentDate ? kendo.toString(PaymentDate, 'dd/MM/yyyy') : '';
        return "<span>" + date + "</span>";
}