//####################################################################
//# Copyright (C) 2010-2015, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/10/2015      Toàn Thiện      Tạo mới
//#     08/10/2015      Quang Hoàng     Cập Nhật
//####################################################################


//Thông tin server SIP được lấy từ controller
var displayName;// = "Hoang";
var uri;// = "sip:102@ccall.asoft.test";
var pass;// = "qwerty123456";
var hori = "right";
var verti = "up";
var temp = 1;
var t = 1;
var action1 = 0;
var call = 1;
var urlim = "/CRM/CRMF2000/CRMF2001";
var urlsrc = "/CRM/CRMF2000/ScreenCall";
var audioInComing = new Audio('/Content/Audio/IncomingCall.mp3');
var isShowCommingCall = 1;
audioInComing.loop = true;
var closeMs = false;
var n = null;
var isTranfer = false;
var isProgress = false;
var isMessage = true;
var ASPhone = null;
var options = null;
var optionAS = null;
var isRegister = false;
var isLock = false;
var apk = null;

$("#BtnTransfer").click(function () {
    $("#SipID").css("width", "70%");
    $(".transfer-call").show("slide", { direction: hori }, 1000);

    //TranferURI = GetTextCB("User");
    //ASOFTSIP.Refer(data, TranferURI);
    //ASOFTSIP.Terminate(data);
});

$(document).ready(function Main() {

    if (localStorage.getItem("LockCall" + ASOFTEnvironment.UserID) == null)
    {
        localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 1);
    }

    if ($("#CurrentSipID").val() != "") {
        ASOFT.helper.postTypeJson("/CRM/CRMF2000/GetSIPUser", { User: ASOFTEnvironment.UserID }, function (result) {
            apk = result.APK;
            isRegister = result.IsRegister;
        })
    }

    $("#Register").click(function () {
        ASOFT.helper.postTypeJson("/CRM/CRMF2000/UpdateAPKIndex", { Check: $(this).is(':checked'), User: ASOFTEnvironment.UserID, APK: apk }, function () {
            if ($("#Register").is(':checked')) {
                    registerJSSIP();
                }
                else
                {
                    ASOFTSIP.Stop(ASPhone);
                    ASOFTSIP.UnRegister(ASPhone);
                }
            })
        })

    //n = new Notification("ASOFT-CRM", {
    //    body: "Đang có cuộc gọi đến ...",
    //    icon: "/Content/Images/add.png",
    //});

    //$("#BtnCall").attr("disabled", "disabled");
    //("#BtnAnswer").attr("disabled", "disabled");
    //$("#BtnTransfer").attr("disabled", "disabled");
    if ($("#CurrentSipID").val() !== "" && !isRegister && !isLock) {
        registerJSSIP(); 
    }
});

function registerJSSIP() {
    uri = $("#CurrentSipID").val();
    pass = $("#CurrentSipPass").val();

    displayName = $().val("#CurrentSipName");
    //Tạo mới một người dùng (ASPhone)


    ASPhone = ASOFTSIP.CreatePhone(displayName, uri, pass);
    options = { 'mediaConstraints': { 'audio': true, 'video': false } };
    //Xử lý khi bị disconnec
    ASOFTSIP.onDisConnected(ASPhone, function () {
        console.log("Disconnected");
        var div = "<div></div>";
        $(div).load("https://sbcwrtchcm.ccall.vn");
        ASOFTSIP.Register(ASPhone);
    });
    //Xử lý khi ASPhone đã registered
    ASOFTSIP.onRegistered(ASPhone, function () {
        $("#Register").prop("checked", true);
        ASOFT.helper.postTypeJson("/CRM/CRMF2000/SaveSIPUser", { Check: true, User: ASOFTEnvironment.UserID, APK: apk }, function () {
            isLock = true;
        });
        console.log("registered");
    });

    ASOFTSIP.onUnRegistered(ASPhone, function () {
        console.log("unregistered");
    })

    //Đăng kí lắng nghe cuộc gọi cho ASPhone   
    CallListen(ASPhone);


    //Thực hiện cuộc gọi từ ASPhone
    $("#btnCall").click(myCall = function () {
        action1 = 2;
        var ToUri = $("#Call").val();
        GetUser(null, urlsrc, 0);
        ASOFTSIP.Call(ASPhone, ToUri
            , options);
        $("#screencall").show("slide", { direction: verti }, 1000);
        $("#ScreenExtend").show();
        $(".btn-ScreenCall").show("slide", { direction: verti }, 1000);
        $("#BtnTransfer").hide();
        $("#btnCall").addClass("k-state-disabled");
        $("#btnCall").off("click");
    });

    $("#BtnCallLine").click(myCallline = function () {
        var ASPhone1 = ASOFTSIP.CreatePhone(displayName, uri, pass);
        var ToUri = $("#SipID").val();
        CallListen1(ASPhone1);

        ASOFTSIP.Call(ASPhone1, ToUri
            , options);

        $("#BtnCallLine").addClass("k-state-disabled");
        $("#BtnCallLine").off("click");

        $("#BtnHangUpLine").removeClass("k-state-disabled");
    });
}

function CallListen1(ASPhone1) {
    ASOFTSIP.onCall(ASPhone1, function (data) {

        $("#BtnHangUpLine").click(function () {
            isMessage = false;
            ASOFTSIP.Terminate(data);
        });

        ASOFTSIP.onProgress(data, function (e) {
            $("#BtnCallLine").addClass("k-state-disabled");
            $("#BtnCallLine").off("click");

            $("#BtnHangUpLine").removeClass("k-state-disabled");
            if (isProgress)
            {
                isTranfer = true;
                $("#BtnHangUpLine").trigger('click');
                $("#BtnTransferCRMF2002").trigger('click');
            }
        })

        ASOFTSIP.onConfirmed(data, function (e) {
            $("#BtnHangUpLine").unbind('click');
            $("#BtnHangUpLine").click(function () {
                ASOFTSIP.Terminate(data);
            });
            $("#BtnCallLine").addClass("k-state-disabled");
            $("#BtnCallLine").off("click");

            $("#BtnHangUpLine").removeClass("k-state-disabled");
        })

        ASOFTSIP.onFailed(data, function (e) {
            if ($("#BtnHangUpLine").attr("k-state-disabled") == undefined) {
                $("#BtnHangUpLine").unbind("click");
                $("#BtnHangUpLine").addClass("k-state-disabled");

                $("#BtnCallLine").removeClass("k-state-disabled");
                $("#BtnCallLine").click(myCallline);
            }
            if (isMessage) {
                ASOFT.dialog.messageDialog("Máy bận");
            }

            isProgress = false;
            isMessage = true;
            ASPhone1.unregister();
            ASPhone1.stop();
            ASPhone1 = null;
        });

        ASOFTSIP.onEnded(data, function (e) {
            $("#BtnHangUpLine").unbind("click");
            $("#BtnHangUpLine").addClass("k-state-disabled");

            $("#BtnCallLine").removeClass("k-state-disabled");
            $("#BtnCallLine").click(myCallline);

            isProgress = false;
            isMessage = true;
            ASPhone1.unregister();
            ASPhone1.stop();
            ASPhone1 = null;
        });

        ASOFTSIP.onAddStream(data, function (e) {
            var remoteStream = e.stream;
            //Dua am thanh remote len giao dien(Can thiet)
            var remoteAudio = document.getElementById("audio");
            remoteAudio = JsSIP.rtcninja.attachMediaStream(remoteAudio, remoteStream);
        });
    })
}

function GetTextCB(user) {
    var cboUserIC = ASOFT.asoftComboBox.castName(user);
    var ToUri = cboUserIC.text();
    return ToUri;
}


//Hàm xử lý khi có cuộc gọi diễn ra( thực khi khi có cuộc gọi đến hoặc cuộc gọi đi)


function ListenComing(data) {

    var data1 = {};
    data1["Tel"] = ASOFTSIP.GetSource(data);
    var x = data1["Tel"].indexOf("sip");
    var y = data1["Tel"].indexOf("@");
    data1["Tel"] = data1["Tel"].substring(x, y);
    data1["Tel"] = data1["Tel"].split(':')[1];

    if (Notification.permission !== 'granted') {
        Notification.requestPermission();
    }

    n = new Notification("ASOFT-CRM", {
        body: "Đang có cuộc gọi đến ...",
    });

    $(".callcenter").show();
    $(".callcenter-small").css("display", "none");
    if (isShowCommingCall == 1)
        $(".incomingcall").show("slide", { direction: "left" }, 1000);
    else
        $(".callcenter-small-call").show();
    // Click để trả lời cuộc gọi
    $("#BtnAnswer").click(function () {
        $("#btnCall").addClass("k-state-disabled");
        $("#btnCall").off("click");
        action1 = 2;
        GetUser(data, urlsrc, 1);

        if ($(this).attr("disabled") == "disabled")
            return;
        ASOFTSIP.Answer(data, options);
        $(".incomingcall").hide("slide", { direction: "left" }, 1000);
        $(".callcenter-small-call").hide();
        $("#BtnTransfer").show();
        $("#screencall").show("slide", { direction: verti }, 1000);
        $(".tb-extend").show();
    });
};

function ListenAll(data) {
    //Xử lý chung cho tất cả cuộc gọi
    var calldisplay;
    // Click để kết thúc cuộc gọi
    $("#BtnHangUpIC").click(function () {
        ASOFTSIP.Terminate(data);
    });

    $("#BtnHangUp").click(function () {
        ASOFTSIP.Terminate(data);
    });

    $('.minimize_box_hide_call').click(function () {
        $(".incomingcall").hide();
        $(".callcenter-small-call").show();
        isShowCommingCall = 0;
    });

    $('.minimize_box_show_call').click(function () {
        $(".incomingcall").show();
        $(".callcenter-small-call").hide();
        isShowCommingCall = 1;
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


    $("#BtnTransfer").click(function Call() {
        $("#BtnHold").trigger("click");
        $("#SipID").css("width", "70%");
        $(".transfer-call").show("slide", { direction: hori }, 1000);

        //TranferURI = GetTextCB("User");
        //ASOFTSIP.Refer(data, TranferURI);
        //ASOFTSIP.Terminate(data);
    });

    $("#BtnTransferCRMF2002").click(function () {
        if (isTranfer) {
            $("#BtnTransferCRMF2002").unbind("click");
            isTranfer = false;
            $("#BtnHangUpLine").trigger("click");
            var TranferURI = $("#SipID").val();
            setTimeout(function () {
                ASOFTSIP.Refer(data, TranferURI);
            }, 200)
            setTimeout(function () {
                $("#BtnHangUp").show();
                $("#BtnHangUp").trigger("click");
                $(".transfer-call").hide("slide", { direction: hori }, 1000);
            }, 400)
        }
        else {
            isProgress = true;
            $("#BtnCallLine").trigger("click");
        }
    });

    // Xử lý khi cuộc gọi đang chờ kết nối
    ASOFTSIP.onProgress(data, function (e) {
        console.log("progress");
    });
    // Xử lý khi cuộc gọi thất bại
    ASOFTSIP.onFailed(data, function (e) {
        if (n != null)
            n.close();
        t = 1;
        localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 1);
        temp = 1;

        $("#BtnHangUp").show();
        $("#BtnAnswer").unbind("click");
        $("#BtnHold").unbind("click");
        $("#BtnHangUpIC").unbind("click");
        $("#BtnHangUp").unbind("click");
        $("#btnCall").on("click", myCall);
        $("#btnCall").removeClass("k-state-disabled");

        $(".callcenter-small-call").hide();
        $(".incomingcall").hide("slide", { direction: "left" }, 1000);
        $(".btn-ScreenCall").hide("slide", { direction: verti }, 1000);
        $("#BtnHold").css("background-image", "url(/Areas/CRM/Content/images/hold.png)");
        temp = 1;

        //Xu ly ngat nhac
        audioInComing.pause();
        audioInComing.currentTime = 0.0;
    });
    // Xử lý khi cuộc gọi đã được trả lời
    ASOFTSIP.onConfirmed(data, function (e) {
        console.log("onConfirmed");

        if (n != null)
            n.close();

        $(".tb-callcenter").show("slide", { direction: verti }, 1000);
        $(".btn-ScreenCall").show("slide", { direction: verti }, 1000);


        //Dua am thanh local len giao dien(Khong can thiet)
        //localStream = data.session.connection.getLocalStreams()[0]
        //localAudio.src = window.URL.createObjectURL(localStream);
        audioInComing.pause();
        audioInComing.currentTime = 0.0;
    });
    // Xử lý khi cuộc gọi kết thúc
    ASOFTSIP.onEnded(data, function (e) {
        if (n != null)
            n.close();
        t = 1;
        localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 1);
        temp = 1;
        $("#BtnHangUp").show();
        $("#BtnAnswer").unbind("click");
        $("#BtnHangUpIC").unbind("click");
        $("#BtnHangUp").unbind("click");
        $("#BtnTransfer").unbind("click");
        $("#BtnHold").unbind("click");
        $("#btnCall").removeClass("k-state-disabled");
        $("#btnCall").on("click", myCall);

        $(".callcenter-small-call").hide();
        $(".incomingcall").hide("slide", { direction: "left" }, 1000);
        $(".btn-ScreenCall").hide("slide", { direction: verti }, 1000);
        $("#BtnHold").css("background-image", "url(/Areas/CRM/Content/images/hold.png)");
        audioInComing.pause();
        audioInComing.currentTime = 0.0;
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
        if (localStorage.getItem("LockCall" + ASOFTEnvironment.UserID) == 1) {
            t = 0;
            localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 0);
            var tCall = false;
            cbSipID = $("#SipID").data("kendoComboBox").dataSource._data;
            var data1 = {};
            data1["Tel"] = ASOFTSIP.GetSource(data);
            var x = data1["Tel"].indexOf("sip");
            var y = data1["Tel"].indexOf("@");
            var tel = data1["Tel"].substring(x, y);
            for (var s = 0; s < cbSipID.length; s++)
            {
                if (cbSipID[s].SipID.split('@')[0] == tel.split(':')[1])
                {
                    tCall = true;
                    break;
                }
            }
            if (!tCall)
            {
                $("#BtnHangUp").hide();
            }

            //Hiển thị người được gọi: data.request.from.uri  
            action1 = 1;
            audioInComing.play();
            GetUser(data, urlim, 1);
            ListenComing(data);
            ListenAll(data);
        }
        else {
            ASOFTSIP.Terminate(data);
        }
    });
    ASOFTSIP.onOutcomingCall(ASPhone, function (data) {
        if (localStorage.getItem("LockCall" + ASOFTEnvironment.UserID) == 1) {
            $("input[name = 'Source']").val(ASOFTSIP.GetDestination(data));
            ListenAll(data);
            t = 0;
            localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 0);
        }
        else {
            ASOFTSIP.Terminate(data);
        }
    });
}

$( window ).unload(function() {
    if (t == 0) {
        localStorage.setItem("LockCall" + ASOFTEnvironment.UserID, 1);
    }
    if (isLock) {
        ASOFTSIP.Stop(ASPhone);
        ASOFTSIP.UnRegister(ASPhone);
        ASOFT.helper.postTypeJson("/CRM/CRMF2000/SaveSIPUser", { Check: false, User: ASOFTEnvironment.UserID, APK: apk }, function () { });
    }
});

function GetUser(data, url, temp) {
    var data1 = {};   
    if (temp == 1) {
        data1["Tel"] = ASOFTSIP.GetSource(data);
        var x = data1["Tel"].indexOf("sip");
        var y = data1["Tel"].indexOf("@");
        data1["Tel"] = data1["Tel"].substring(x, y);
        data1["Tel"] = data1["Tel"].split(':')[1];
        data1["TempCall"] = 1;       
    }
    else {
        data1["TempCall"] = 0;
        data1["Tel"] = $("#Call").val();
    }
    ASOFT.helper.postTypeJson(url, data1, Onload);
}

function Onload(result) {
    if (action1 == 1) {
        $(".incomingcall").replaceWith(result);
    }
    if (action1 == 2) {
        $(".callToGo").empty();
        $(".tb-callcenter").replaceWith(result);
        ASOFT.helper.postTypeJson("/CRM/CRMF2000/Extend", {}, function (result1) {
            $("#ScreenExtend").replaceWith(result1);
        });
    }
}