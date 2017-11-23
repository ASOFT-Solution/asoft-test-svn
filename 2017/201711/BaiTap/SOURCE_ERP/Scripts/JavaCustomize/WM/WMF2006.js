$(document).ready(function () {
    var CanDelete = $("#CanDelete").val();
    var CanEdit = $("#CanEdit").val();


    if (CanDelete == 1) {
        $("#BtnEdit").parent().addClass("disabledbutton");
    }

    if (CanDelete == 1) {
        $("#BtnDelete").parent().addClass("disabledbutton");
    }

    if ($('.VoucherDate').text()) {
        $('.VoucherDate').text($('.VoucherDate').text().split(' ')[0])
    } else {
        $("ul.asf-toolbar").parent().addClass("disabledbutton");
    }
})