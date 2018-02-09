//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

var POSF0039 = function (asf) {
    var urlInstall = "/Download/AsoftPrinter/AsoftPrinter.exe";
    asf.isFullScreenMode = function () {
        return document.fullscreenElement
        || document.mozFullScreenElement
        || document.webkitFullscreenElement
        || document.msFullscreenElement;
    };
    asf.printerAvailable = false;
    asf.clientAvailable = false;
    asf.init = function () {
        var WEB_CLIENT_NAME = 'Web Client POSF0039',
            WIN_CLIENT_NAME = 'Win Client',
            log = console.log,
            printerHub = $.connection.printerHub;

        printerHub.client.winClientAvailable = function (isAvailable) {
            console.log(isAvailable);
            if (isAvailable) {
                asf.clientAvailable = true;
                console.log('Win Client is online');
            } else {
                asf.clientAvailable = false;
                console.log('Win Client NOT found');

            }
        }

        printerHub.client.printerAvailable = function (isAvailable) {
            console.log(isAvailable);
            asf.printerAvailable = isAvailable;
        }

        printerHub.client.onRecieveClientStatus = function (status, message) {
            console.log(status, message);
            asf.printerAvailable = false;
        }
        $.connection.hub.start().done(function () {
            printerHub.server.webNotify(WEB_CLIENT_NAME);
            printerHub.server.checkWinClientAvailable(WEB_CLIENT_NAME, WIN_CLIENT_NAME);
            //printerHub.server.checkPrinterAvailable(WEB_CLIENT_NAME);
        });
    };

    asf.toggleFullScreen = toggleFullScreen;
    asf.existFullScreen = existFullScreen;
    asf.enterFullScreen = enterFullScreen;

    return asf;

}(POSF0039 || {});


$(document).ready(function () {

});

function btnAdd_Click(e) {
    enterFullScreen();
    ASOFT.asoftPopup.showIframe('/POS/POSF0039/POSF0040', {});

}

document.addEventListener("keydown", function (e) {
    if (e.keyCode === 123) {
        toggleFullScreen();
    }
}, false);

function toggleFullScreen() {
    if (!document.fullscreenElement &&    // alternative standard method
        !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {  // current working methods
        if (document.documentElement.requestFullscreen) {
            document.documentElement.requestFullscreen();
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullscreen) {
            document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        }
    }
}

function existFullScreen() {
    if (document.exitFullscreen) {
        document.exitFullscreen();
    } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
    } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
    } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
    }
}

function enterFullScreen() {
    if (!document.fullscreenElement &&    // alternative standard method
            !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement) {  // current working methods
        if (document.documentElement.requestFullscreen) {
            document.documentElement.requestFullscreen();
        } else if (document.documentElement.msRequestFullscreen) {
            document.documentElement.msRequestFullscreen();
        } else if (document.documentElement.mozRequestFullScreen) {
            document.documentElement.mozRequestFullScreen();
        } else if (document.documentElement.webkitRequestFullscreen) {
            document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
        }
    }
}