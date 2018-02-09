//####################################################################
//# Copyright (C) 2010-2015, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     02/10/2015      Toàn Thiện      Tạo mới
//#     09/10/2015      Toàn Thiện      Thêm các hàm hỗ trợ
//####################################################################


//Thông tin server SIP được lấy từ controller
var SIPSERVER = "";
ASOFT.helper.postTypeJson("/CRM/CRMREST/GetSipServer", null, function (e) {
    SIPSERVER = e;
});

ASOFTSIP = new function () {
    //Hàm đăng kí, trả về một ASPhone
    this.CreatePhone = function (displayName, uri, pass) {
        //var socket = new JsSIP.WebSocketInterface(SIPSERVER);
        configuration = {
            //sockets  : [ socket ],
            log: { level: 'debug' },
            uri: uri,
            password: pass,
            ws_servers: window.JSON.parse('"' + SIPSERVER + '"'),
            display_name: displayName,
            isComposing: false,

            //authorization_user: "",
            //register: true,
            //register_expires: 600,
            //registrar_server: "",
            //no_answer_timeout: 60,
            //use_preloaded_route: false,
            //connection_recovery_min_interval: 2,
            //connection_recovery_max_interval: 30,
            //hack_via_tcp: false,
            //hack_via_ws: true,
            //hack_ip_in_contact: false,
            session_timers: false
        };
        ASPhone = new JsSIP.UA(configuration);
        ASPhone.start();
        ASPhone.register();
        return ASPhone;
    }
    //Sự kiện khi ASPhone đã đăng kí
    this.onRegistered = function (ASPhone, func) {
        ASPhone.on("registered", func);
    };
    //Sự kiện khi ASPhone đã hủy đăng kí
    this.onUnRegistered = function (ASPhone, func) {
        ASPhone.on("unregistered", func);
    };
    //Sự kiện khi ASPhone đã kết nối( chưa đăng kí)
    this.onConnected = function (ASPhone, func) {
        ASPhone.on("connected", func);
    };
    //Sự kiện khi ASPhone đã ngắt kết nối
    this.onDisConnected = function (ASPhone, func) {
        ASPhone.on("disconnected", func);
    };
    //Hàm thực hiện cuộc gọi
    this.Call = function (ASPhone, uri, option) {
        ASPhone.call(uri, option);
    };
    //Hàm thực hiện đăng kí
    this.Register = function (ASPhone) {
        ASPhone.register();
    };
    //Hàm thực hiện hủy đăng kí
    this.UnRegister = function (ASPhone) {
        ASPhone.unregister();
    };
    //Hàm ngắt kết nối
    this.Stop = function (ASPhone) {
        ASPhone.stop();
    };
    //Sự kiện khi có cuộc gọi diễn ra( cả gọi đến và gọi đi)
    this.onCall = function (ASPhone, func) {
        ASPhone.on("newRTCSession", function (data) {
            func(data);
        });
    };
    //Sự kiện khi có cuộc gọi đến diễn ra
    this.onIncomingCall = function (ASPhone, func) {
        ASPhone.on("newRTCSession", function (data) {
            if (data.originator === 'remote') {
                func(data);
            }
        });
    };
    //Sự kiện khi có cuộc gọi đi diễn ra
    this.onOutcomingCall = function (ASPhone, func) {
        ASPhone.on("newRTCSession", function (data) {
            if (data.originator === 'local') {
                func(data);
            }
        });
    };
    //Hàm trả lời cuộc gọi
    this.Answer = function (data, option) {
        data.session.answer(option);
    };
    //Hàm kết thúc cuộc gọi
    this.Terminate = function (data) {
        data.session.terminate();
    };
    //Hàm giữ cuộc gọi
    this.Hold = function (data) {
        data.session.hold();
    };
    //Hàm kết nối lại sau khi giữ cuộc gọi
    this.UnHold = function (data) {
        data.session.unhold();
    };
    //Hàm chuyển tiếp cuộc gọi
    this.Refer = function (data, ToUri, option) {
        data.session.refer(ToUri, option);
    };
    //Sự kiện khi cuộc gọi bắt đầu
    this.onProgress = function (data, func) {
        data.session.on("progress", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc có tín hiệu từ remote
    this.onAddStream = function (data, func) {
        data.session.on("addstream", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc gọi đã được chấp nhận
    this.onConfirmed = function (data, func) {
        data.session.on("confirmed", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc gọi kết thúc
    this.onEnded = function (data, func) {
        data.session.on("ended", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc gọi thất bại
    this.onFailed = function (data, func) {
        data.session.on("failed", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc gọi được giữ
    this.onHold = function (data, func) {
        data.session.on("hold", function (e) {
            func(e);
        });
    };
    //Sự kiện khi cuộc gọi kết nối lại sau khi giữ
    this.onUnHold = function (data, func) {
        data.session.on("unhold", function (e) {
            func(e);
        });
    };
    //Sự kiện khi có yêu cầu transfer từ remote
    this.onRefer = function (data, func) {
        data.session.on("refer", function (e) {
            func(e);
        });
    };
    //Hàm lấy tín hiệu âm thanh của local
    this.GetLocalStream = function (data) {
        return data.session.connection.getLocalStreams()[0]
    };
    //Hàm lấy SIPUri của người gọi
    this.GetSource = function (data) {
        return data.request.headers.From[0].raw;
    };
    //Hàm lấy SIPUri của người nhận cuộc gọi
    this.GetDestination = function (data) {
        return data.request.to.uri;
    };
};


