//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     06/10/2015     Quang Hoàng       Tạo mới
//####################################################################


var temp = 1;
var temp1 = 1;

$(document).ready(function () {
 
    $(".anchor1").hide();
    $(".tb-callcenter").hide();
    $("#UserIC").css("width", "90%");
    $("#User").css("width", "95%");
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


    $(".title").mouseover(function () {
        $("#callcenter-all").draggable({ disabled: false });
    }).mouseout(function () {
        $("#callcenter-all").draggable({ disabled: true });
    });


    //$(".incomingcall").draggable();
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

function getregister_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var cboUser = ASOFT.asoftComboBox.castName('User');
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    ASOFT.asoftComboBox.callBack(cboUser);
    var typeid = item.User;
    $('#User').val();
}

function getregisterIC_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var cboUser = ASOFT.asoftComboBox.castName('UserIC');
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    ASOFT.asoftComboBox.callBack(cboUser);
    var typeid = item.User;
    $('#UserIC').val();
}

function BtnTransferIC_Click() {
    if (temp == 1) {
        
        $(".transfer-tab1").show("slide", { direction: "up" }, 1000);
        temp = 0;
        return;
    }
    if (temp == 0) {
        $(".transfer-tab1").hide("slide", { direction: "up" }, 1000);
        temp = 1;
        return;
    }
}

function BtnTransfer_Click() {
    if (temp1 == 1) {

        $(".transfer-tab2").show();
        temp1 = 0;
        return;
    }
    if (temp1 == 0) {
        $(".transfer-tab2").hide();
        temp1 = 1;
        return;
    }
}

function BtnZoom_Click() {
    $(".anchor1").hide("slide", { direction: "right" }, 1000);
    $(".anchorzoom").hide();
    $(".anchorzoom1").show();
}

function BtnShow_Click() {
    $(".anchor1").show("slide", { direction: "right" }, 1000);
    $(".anchorzoom").show();
    $(".anchorzoom1").hide();
}



