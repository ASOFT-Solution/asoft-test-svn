var subgroup02="<div class='asf-content-block-sys left' style='width: 46.5966%;'><table class='asf-table-view' id='subgroup02Left'><tbody></tbody></table> </div> <div class='asf-content-block-sys right' style='width: 46.5966%;'> <table class='asf-table-view' id='subgroup02Right'><tbody></tbody></table> </div>";

$(document).ready(function () {
    $('.ToDate').parent().css('display', 'none')
    $('.FromDate').append(' - ' + $('.ToDate').text())


    $('#LMF2022_SubTitle2-1 div.asf-master-content').append(subgroup02);
    $('#subgroup02Left tbody').prepend($('.AfterRatePercent').parent());
    $('#subgroup02Left tbody').prepend($('.BeforeRatePercent').parent());
    $('#subgroup02Left tbody').prepend($('.OriginalCostTypeName').parent());
    $('#subgroup02Left tbody').prepend($('.OriginalAccountID').parent());
    $('#subgroup02Left tbody').prepend($('.OriginalMethodName').parent());

    $('#subgroup02Right tbody').prepend($('.RateByName').parent());
    $('#subgroup02Right tbody').prepend($('.RatePercent').parent());
    $('#subgroup02Right tbody').prepend($('.RateCostTypeName').parent());
    $('#subgroup02Right tbody').prepend($('.RateAccountID').parent());
    $('#subgroup02Right tbody').prepend($('.RateMethodName').parent());


    $(".RateByName").parent().css('display', 'none')
    $('.RatePercent').append(' - ' + $('.RateByName').text())
    $("#LMF2022_SubTitle2-1 div.asf-master-content").children().remove("div.asf-content-block.first");
    $("#LMF2022_SubTitle2-1 div.asf-master-content").children().remove("div.asf-content-block.middle");
    $("#LMF2022_SubTitle2-1 div.asf-master-content").children().remove("div.asf-content-block.last");

    // Xu li unbind button Edit
    $("#BtnEdit").unbind('click');
    $("#BtnEdit").bind('click', function (e) {
        var url = "/LM/LMF2020/CheckEdit?voucherID=" + getUrlParameter('PK');
        ASOFT.helper.postTypeJson(url, {}, function (result) {
            if (result) {
                ASOFT.dialog.showMessage('LMFML000028');
            } else {
                BtnEdit_Click();
            }
        });
    });
})

function getUrlParameter (param) {
    var url = new URL(window.location.href);
    var result = url.searchParams.get(param);
    return result;
}