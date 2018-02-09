//####################################################################
//# Copyright (C) 2010-2015, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/10/2015      Toàn Thiện      Tạo mới
//#     08/10/2015      Quang Hoàng     Cập Nhật
//####################################################################


//Thông tin server SIP được lấy từ controller

var displayName = "Hoang";
var uri = "hv1@com.vn";
var pass = "123";
var hori = "right";
var verti = "up";
var temp = 1;
var t = 1;

$(document).ready(function Main() {
    //$("#BtnCall").attr("disabled", "disabled");
    //("#BtnAnswer").attr("disabled", "disabled");
    //$("#BtnTransfer").attr("disabled", "disabled");

    //Tạo mới một người dùng (ASPhone)

    var ASPhone = ASOFTSIP.CreatePhone(displayName, uri, pass);

    //Xử lý khi ASPhone đã registered

    ASOFTSIP.onRegistered(ASPhone, function () {
        console.log("registered");
    });

    //Đăng kí lắng nghe cuộc gọi cho ASPhone   
    CallListen(ASPhone);



    //Thực hiện cuộc gọi từ ASPhone
    $("#BtnCall").click(function () {
        var ToUri = $("#CallNumber").val();
        ASOFTSIP.Call(ASPhone, ToUri);
    })

    $("#BtnCall1").click(function () {
        var user = "UserIC";
        $("#BtnAnswer").bind(".k-state-disabled").css("opacity", "0.7");
        $("#BtnAnswer").attr("disabled", "disabled");
        TransferCall(user, 1);
        $(".tranfer-call1").hide();
        $(".tranfer-close1").show();
    })

    $("#BtnCall2").click(function () {
        var user = "User";
        TransferCall(user, 2);
        $(".tranfer-call2").hide();
        $(".tranfer-close2").show();
    })
});

function GetTextCB(user) {
    var cboUserIC = ASOFT.asoftComboBox.castName(user);
    var ToUri = cboUserIC.text();
    return ToUri;
}

function TransferCall(user, id) {
    var ASPhone1 = ASOFTSIP.CreatePhone(displayName, uri, pass);
    CallListen1(ASPhone1, id);
    var ToUri = GetTextCB(user);
    ASOFTSIP.Call(ASPhone1, ToUri);
}

//Hàm xử lý khi có cuộc gọi diễn ra( thực khi khi có cuộc gọi đến hoặc cuộc gọi đi)
function CallListen1(ASPhone1, id) {
    ASOFTSIP.onCall(ASPhone1, function (data) {
        $("#BtnTerminate" + id).click(function () {
            ASOFTSIP.Terminate(data);
        });

        ASOFTSIP.onFailed(data, function (e) {
            if (id == 1) {
                $("#BtnAnswer").bind(".k-state-disabled").css("opacity", "1");
                $("#BtnAnswer").removeAttr("disabled");
            }
            $("#BtnTerminate" + id).unbind("click");
            $(".tranfer-call" + id).show();
            $(".tranfer-close" + id).hide();
        });
        ASOFTSIP.onEnded(data, function (e) {
            if (id == 1) {
                $("#BtnAnswer").bind(".k-state-disabled").css("opacity", "1");
                $("#BtnAnswer").removeAttr("disabled");
            }
            $("#BtnTerminate" + id).unbind("click");
            $(".tranfer-close" + id).hide();
        });
        ASOFTSIP.onConfirmed(data, function (e) {
            $(".tranfer-user" + id).show();
        })

        ASOFTSIP.onAddStream(data, function (e) {
            remoteStream = e.stream;
            //Dua am thanh remote len giao dien(Can thiet)
            var remoteAudio = document.getElementById("audio");
            remoteAudio = JsSIP.rtcninja.attachMediaStream(remoteAudio, remoteStream);
        });
    })
}

function ListenComing(data) {
    $(".callcenter").show();
    $(".callcenter-small").css("display", "none");
    $(".incomingcall").show("slide", { direction: hori }, 1000);
    // Click để trả lời cuộc gọi
    $("#BtnAnswer").click(function () {
        if ($(this).attr("disabled") == "disabled")
            return;
        ASOFTSIP.Answer(data);
        $(".incomingcall").hide("slide", { direction: hori }, 1000);
        $(".tb-callcenter").show("slide", { direction: verti }, 1000);
        $(".anchor").show("slide", { direction: hori }, 1000);
        $(".bttb-callcenter1").show("slide", { direction: verti }, 1000);
    });
};

function ListenAll(data) {
    $('#stopwatch1').stopwatch().stopwatch('start');

    //Xử lý chung cho tất cả cuộc gọi
    var calldisplay;
    // Click để kết thúc cuộc gọi
    $("#BtnTerminate").click(function () {
        ASOFTSIP.Terminate(data);
    });

    $("#BtnTerminateIC").click(function () {
        ASOFTSIP.Terminate(data);
    });


    //Click để giữ cuộc gọi( hold)

    $("#BtnHold").click(function () {
        if (temp == 1) {
            ASOFTSIP.Hold(data);
            $("#BtnHold").css("background-image", "url(/Areas/CRM/Content/images/play.png)");
            temp = 0;
        }
        else {
            ASOFTSIP.UnHold(data);
            $("#BtnHold").css("background-image", "url(/Areas/CRM/Content/images/hold.png)");
            temp = 1;
        }
    });

    //Click để nghe lại sau khi giữ( unhold)

    // Click để transfer     

    $("#BtnTransferICUser").click(function () {
        TranferURI = GetTextCB("UserIC");
        ASOFTSIP.onConfirmed(data, function (e) {
            ASOFTSIP.Refer(data, TranferURI);
            ASOFTSIP.Terminate(data);
            $(".tranfer-call").show();
            $(".tranfer-user").hide();
            $(".transfer-tab").hide();
        });
        ASOFTSIP.Answer(data);
    });

    $("#BtnTransferUser").click(function () {
        TranferURI = GetTextCB("User");
        ASOFTSIP.Refer(data, TranferURI);
        ASOFTSIP.Terminate(data);
        $(".tranfer-call1").show();
        $(".tranfer-user1").hide();
        $(".transfer-tab1").hide();
    });

    // Xử lý khi cuộc gọi đang chờ kết nối
    ASOFTSIP.onProgress(data, function (e) {
        console.log("progress");
    });
    // Xử lý khi cuộc gọi thất bại
    ASOFTSIP.onFailed(data, function (e) {
        t = 1;

        $("#BtnAnswer").unbind("click");
        $("#BtnTerminate").unbind("click");
        $("#BtnTransferICUser").unbind("click");
        $("#BtnTerminateIC").unbind("click");
        $("#BtnTransferUser").unbind("click");


        $(".anchor").hide("slide", { direction: hori }, 1000);
        $(".incomingcall").hide("slide", { direction: hori }, 1000);
        $(".bttb-callcenter1").hide("slide", { direction: verti }, 1000);

    });
    // Xử lý khi cuộc gọi đã được trả lời
    ASOFTSIP.onConfirmed(data, function (e) {
        $(".tb-callcenter").show("slide", { direction: verti }, 1000);
        $(".anchor1").show("slide", { direction: hori }, 1000);
        $(".bttb-callcenter1").show("slide", { direction: verti }, 1000);
        $(".anchorzoom").show();
        $(".anchorzoom1").hide();

        $('#stopwatch1').stopwatch('toggle');
        $('#stopwatch1').stopwatch('reset');
        $('#stopwatch').stopwatch().stopwatch('start');

        //Dua am thanh local len giao dien(Khong can thiet)
        //localStream = data.session.connection.getLocalStreams()[0]
        //localAudio.src = window.URL.createObjectURL(localStream);
    });
    // Xử lý khi cuộc gọi kết thúc
    ASOFTSIP.onEnded(data, function (e) {
        t = 1;

        $('#stopwatch').stopwatch('toggle');
        $('#stopwatch').stopwatch('reset');


        $("#BtnAnswer").unbind("click");
        $("#BtnTerminate").unbind("click");
        $("#BtnHold").unbind("click");
        $("#BtnTerminateIC").unbind("click");
        $("#BtnTransferICUser").unbind("click");
        $("#BtnTransferUser").unbind("click");


        $("#BtnHold").css("background-image", "url(/Areas/CRM/Content/images/hold.png)");
        $(".grid-history").empty();
        $(".incomingcall").hide("slide", { direction: hori }, 1000);
        $(".bttb-callcenter1").hide("slide", { direction: verti }, 1000);
        $(".transfer-tab1").hide("slide", { direction: verti }, 1000);
        $(".transfer-tab2").hide();
    });
    // Xử lý tín hiệu âm thanh từ remote
    ASOFTSIP.onAddStream(data, function (e) {
        remoteStream = e.stream;
        //Dua am thanh remote len giao dien(Can thiet)
        var remoteAudio = document.getElementById("audio");
        remoteAudio = JsSIP.rtcninja.attachMediaStream(remoteAudio, remoteStream);
    });
    // Xử lý khi cuộc gọi được remote transfer
    ASOFTSIP.onRefer(data, function (e) {
        e.accept();//Chấp nhận cuộc gọi transfer
    });
}

function CallListen(ASPhone) {
    //Xử lý cuộc gọi đến
    ASOFTSIP.onIncomingCall(ASPhone, function (data) {
        if (t == 1) {
            // Hiển thị người được gọi: data.request.from.uri  
            $("input[name = 'Source']").val(ASOFTSIP.GetSource(data));
            ListenComing(data);
            ListenAll(data);
            t = 0;
        }
        else {
            ASOFTSIP.Terminate(data);
        }
    });
    ASOFTSIP.onOutcomingCall(ASPhone, function (data) {
        if (t == 1) {
            $("input[name = 'Source']").val(ASOFTSIP.GetDestination(data));
            ListenAll(data);
            t = 0;
        }
        else {
            ASOFTSIP.Terminate(data);
        }
    });
}