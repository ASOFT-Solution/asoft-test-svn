
$(document).ready(function () {
    var time = 150;
 

    $('.minimize_box').click(function () {
        $(".callcenter").hide();
        $(".callcenter-small").css("display", "block");
    });
    $('.minimize_box_show').click(function () {
        $(".callcenter").show();
        $(".callcenter-small").css("display", "none");
    });

    $('.close_box').click(function () {
        $("#callcenter-all").empty();
    });
    $('.close_box1').click(function () {
        $(".callcenter-small").empty();
    });

    $('.title-small').click(function () {
        $(".callcenter").show();
        $(".callcenter-small").css("display", "none");
    });

    $(".kb").click(function () {
        $("#CallNumber").val($("#CallNumber").val() + $(this).text());
    })
});

var temp1 = 1;
function BtnLS_Click() {
    if (temp1 == 1) {
        var url = $('#GridHistory').val();
        ASOFT.helper.post(url, {}, function (result) {
            $('.grid-history').html(result);
        })
        temp1 = 0;
        return;
    }
    else {
        $('.grid-history').empty();
        temp1 = 1;
        return;
    }
}



