//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     11/08/2014      Minh Lâm         Tạo mới
//####################################################################

/**
* Mở rộng
*/
var hide = 0;

function btnExtension_Click() {
    var element = $('div:has(> #pos_info)');
    element.toggleClass('floating-element')
        .offset({
            top: ($(window).height() - element.height()) / 2,
            left: ($(window).width() - element.width()) / 2
        });

    $(window).off('resize', window_Resize).on('resize', window_Resize);

    function window_Resize(e) {
        element.offset({
            top: ($(window).height() - element.height()) / 2,
            left: ($(window).width() - element.width()) / 2
        });
    }
    $('#btnCloseExtension').off('click').on('click', function () {
        element.removeClass('floating-element');
    });
}

/**
* Override clear
*/
function overrideReset(viewmode) {
    if (viewmode.Status == "2") {
        parent.refreshGrid();
        parent.existFullScreen();
        ASOFT.asoftPopup.closeOnly();
    }
}

$(document).ready(function () {
    $("#btnChooseMobile").on("click", function () {
        btnChooseMobile_Clicked(this);
    })

    $("#arrow-1").click(function () {
        $($("#payment_container").find(".pos_inner")).css("display", "block")
        $("#arrow-3").css("display", "block")
        $("#arrow-1").css("display", "none")
    })

    $("#arrow-3").click(function () {
        $($("#payment_container").find(".pos_inner")).css("display", "none")
        $("#arrow-3").css("display", "none")
        $("#arrow-1").css("display", "block")
    })
})

function buttonTast_Click(btn, e) {
    $("#" + btn).trigger("click");
    setTimeout(function () {
        if (btn == "btnPromotion") {
            $($("#btnPromotion_tt_active").parent()).css("top", $("#btnChooseMobile").position().top + e.offsetTop + 75);
            $($("#btnPromotion_tt_active").parent()).css("z-index", "100101");
        }
    }, 50)
}


function btnChooseMobile_Clicked(e) {
    if (hide == 0) {
        var top = e.offsetTop + 40;
        var left = e.offsetLeft;
        var id = this.id;
        //if (CheckItemMenu(id)) return;
        var dialog = $("#TaskButtonsMB").data("kendoWindow");
        if (typeof (dialog) === 'undefined') return;
        $("#TastButton_div").show();
        //Kiểm tra xem dialog có dữ liệu không. Nếu không thì không cần hiển thị
        dialog.wrapper.css({ top: top, left: left, position: "fixed" });

        dialog.open();
        hide = 1;

        $("#btnChooseMobile img").attr("src", "/Content/Images/navigate.previous.png");
    }
    else {
        $("#TaskButtonsMB").data("kendoWindow").close();
        hide = 0;
        $("#btnChooseMobile img").attr("src", "/Content/Images/navigate.next.png");
    }
}

/**
* Override clear
*/
function overrideClose() {
    parent.existFullScreen();
    ASOFT.asoftPopup.closeOnly();
}

function btnFinishShift_Click() {
    ASOFT.asoftPopup.showIframe('/POS/POSF0033', {});
}

/**
* Refresh grid
*/
function refreshGrid(event) {
    posViewModel.search();
}

