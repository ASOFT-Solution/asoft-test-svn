$(document).ready(function () {
    $('.ToDate').parent().css('display', 'none')
    $('.FromDate').append(' - ' + $('.ToDate').text())

    $($('.BankAccountID').parent().children()[0]).css('width', '50%')
});