$(document).ready(function () {
    $('.ToDate').parent().css('display', 'none')
    $('.FromDate').append(' - ' + $('.ToDate').text())
});