//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     06/10/2015     Quang Hoàng       Tạo mới
//####################################################################


var temp = 1;
var temp1 = 1;
var action = 0;
var urlct = null;
var urlojb = null;
var isYellow = 1;
var isChangeGrid = false;


function ChangeGridOT2002(x) {
    isChangeGrid = x;
}

$(document).ready(function () {
 
    $("#screencall").hide();
    $("#ScreenExtend").hide();
    $('.minimize_box').click(function () {
        $(".callcenter").hide();
        $(".callcenter-small").css("display", "block");
    });
    $('.minimize_box_show').click(function () {
        $(".callcenter").show();
        $(".callcenter-small").css("display", "none");
    });

    $('#callcenter-all .close_box').click(function () {
        $("#callcenter-all").empty();
    });
    $('.close_box1').click(function () {
        $(".callcenter-small").empty();
    });

    $('.transfer-call .close_box').click(function () {
        $(".transfer-call").hide("slide", { direction: "right" }, 1000);
    });


    $('.title-small').click(function () {
        $(".callcenter").show();
        $(".callcenter-small").css("display", "none");
    });

    $(".kb").click(function () {
        $("#Call").val($("#Call").val() + $(this).text());
    })


    //$(".title").mouseover(function () {
    //    $("#callcenter-all").draggable({ disabled: false });
    //}).mouseout(function () {
    //    $("#callcenter-all").draggable({ disabled: true });
    //});

    $(".incomingcall-bar").mouseover(function () {
        $(".incomingcall").draggable({ disabled: false });
    }).mouseout(function () {
        $(".incomingcall").draggable({ disabled: true });
    });

    $(".transfer-bar").mouseover(function () {
        $(".transfer-call").draggable({ disabled: false });
    }).mouseout(function () {
        $(".transfer-call").draggable({ disabled: true });
    });

    $("#Call").on('keypress', function (e) {
        if (e.keyCode == 13) {
            $("#btnCall").trigger('click');
        }
    })

    $("#btnCall").on('keypress', function (e) {
        if (e.keyCode == 13) {
            $("#btnCall").trigger('click');
        }
    })

    setInterval(ChangeColorImcommingCall, 300);
});

function ChangeColorImcommingCall() {
    if (isYellow == 1) {
        $(".incomingcall-bar").css("background", "#006EB4");
        $(".callcenter-small-call").css("background", "#006EB4");
        isYellow = 0;
    }
    else {
        $(".incomingcall-bar").css("background", "#ff6a00");
        $(".callcenter-small-call").css("background", "#ff6a00");
        isYellow = 1;
    }
}

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

function btnTransfer_Click() {
    ASOFT.helper.postTypeJson("/CRM/CRMF2000/CRMF2001", "1");
}

function btnViewDebts_Click() {
    action = 1;
    var data = {};
    data = ASOFT.helper.dataFormToJSON("ScreenCall");
    ASOFT.helper.postTypeJson("/CRM/CRMF2000/CRMF2004", data, Onreload);
}

function BtnViewHistory_Click() {
    var data = {};
    data = ASOFT.helper.dataFormToJSON("ScreenCall");
    if (data.TempCall == 1) {
        data["Source"] = data.Tel;
    }
    else {
        data["Destination"] = data.Tel;
    }
    action = 2;
    ASOFT.helper.postTypeJson("/CRM/CRMF2000/CRMF2003", data, Onreload);
}

function Onreload(result) {
    if (action == 1)
    {
        $("#CRMF2004").replaceWith(result);
        $(".title-debts").mouseover(function () {
            $("#debts").draggable({ disabled: false });
        }).mouseout(function () {
            $("#debts").draggable({ disabled: true });
        });
        $('#debts .close_box').click(function () {
            $("#CRMF2004").empty();
        });
    }
    if (action == 2)
    {
        $("#CRMF2003").replaceWith(result);
        $(".title-history").mouseover(function () {
            $("#History").draggable({ disabled: false });
        }).mouseout(function () {
            $("#History").draggable({ disabled: true });
        });
        $('#History .close_box').click(function () {
            $("#CRMF2003").empty();
        });
    }
}


function btnContact_Click() {
    $("#IsTemp").val("True");
    urlct = "/PopupLayout/Index/CRM/CRMF2007";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlct, {});
}

function btnObject_Click() {
    $("#IsTemp").val("True");
    urlojb = "/PopupLayout/Index/CRM/CRMF2005";
    ASOFT.form.clearMessageBox();
    ASOFT.asoftPopup.showIframe(urlojb, {});
}

function popupClose() {
    ASOFT.asoftPopup.hideIframe();
};

function getdataScreenCall() {
    var data1 = {};
    data1 = ASOFT.helper.dataFormToJSON("ScreenCall");
    return data1;
};


function btnSaleOrder_Click() {
    if (isChangeGrid) {
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('CRMFML000007'),
            function () {
                urlsod = "/PopupMasterDetail/Index/CRM/CRMF2006?tel=" + $("#Tel").val() + "&accountID=" + $("#AccountID").val() + "&Contact=" + $("#ContactID").val();
                ASOFT.form.clearMessageBox();
                ASOFT.asoftPopup.showIframe(urlsod, {});
                isChangeGrid = false;
            },
            function () {
                return;
            });
    }
    else {
        urlsod = "/PopupMasterDetail/Index/CRM/CRMF2006?tel=" + $("#Tel").val() + "&accountID=" + $("#AccountID").val() + "&Contact=" + $("#ContactID").val();
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlsod, {});
    }
}

function BtnViewOrder_Click() {
    window.open('/Contentmaster/Index/SO/SOF2000?AccountID=' + $("#AccountID").val(), '_blank');
}

function IsTemp() {
    return $("#IsTemp").val();
}

function UpdateIsTemp(istemp) {
    $("#IsTemp").val(istemp);
}


function returnContactID() {
    return $("#ContactID").val();
}
function returnAccountID() {
    return $("#AccountID").val();
}

function AccountID_Change(e) {
    var dataItem = e.sender.dataItem();
    $("#Address").val(dataItem.Address);
    $("#Notes").val(dataItem.Notes);
    $("#ContactNameSC").val(dataItem.ContactName);
    $("#ContactID").val(dataItem.ContactID);

    $(".Address").text(dataItem.Address == null ? "" : dataItem.Address);
    $(".Notes").text(dataItem.Notes == null ? "" : dataItem.Notes);
    $(".ContactName").text(dataItem.ContactName == null ? "" : dataItem.ContactName);
}
