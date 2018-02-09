
//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm        Tạo mới
//####################################################################

function ViewLogin() {
    var thisParent = this;
    var URL_LOGIN = "/Login/DoLogin";
    var FORM_NAME = 'login';
    var MESSAGEID_LOGINFAILED = 'A00ML000007';

    var userIDField = $('#UserID');
    var passwordField = $('#Password');
    var captchaField = $('#Captcha');
    var btnLogin = $('#btnLogin');
    this.loginCount = 1;

    userIDField.on('keypress', function (e) {
        if (e.keyCode == 13 && $(this).val()) {
            passwordField.focus();
        }
    });

    var initEvents = function () {
        $('form').submit(false);

        var btnLogin_Click = function () {
            ASOFT.form.clearMessageBox();
            var data = ASOFT.helper.getFormData('', FORM_NAME);
            data[0].value = data[0].value.toString().toUpperCase();
            ASOFT.helper.post(URL_LOGIN, data, login_Success);
        }

        var login_Success = function (result) {
            thisParent.loginCount = result.Data.loginCount;
            if (result.Status == 0) {
                if (result.Data.CusNum == 50) {
                    $.cookie('UserID', result.Data.UserID, { expires: 365 });
                   
                    var data1 = ASOFT.helper.getFormData('', FORM_NAME);
                    ASOFT.helper.post("/Login/DoCheckLoginExist", data1, function (result1) {
                        if (result1) {
                            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000108'),
                                function () {
                                    ASOFT.helper.post("/Login/LockOutUserOnline", data1, function () {
                                        //goToDaskboard();
                                        data = { LogonDivisionID: result.Data.DivisionID, LogonDivisionName: result.Data.DivisionName, UserID : $("#UserID").val() }
                                        ASOFT.helper.post("/Login/DoLoginDivision", data, login_SuccessCusNum);
                                    })
                                },
                            function () {
                                return false;
                            });
                        }
                        else {
                            data = { LogonDivisionID: result.Data.DivisionID, LogonDivisionName: result.Data.DivisionName }
                            ASOFT.helper.post("/Login/DoLoginDivision", data, login_SuccessCusNum);
                        }
                    })
                } else {
                    var data1 = ASOFT.helper.getFormData('', FORM_NAME);
                    ASOFT.helper.post("/Login/DoCheckLoginExist", data1, function (result1) {
                        if (result1) {
                            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000108'),
                                function () {
                                    ASOFT.helper.post("/Login/LockOutUserOnline", data1, function () {
                                        //goToDaskboard();
                                        var url = '/Login/LoginDivision';
                                        //window.location.href = url;
                                        ASOFT.asoftPopup.showIframe(url, {});
                                    })
                                },
                            function () {
                                return false;
                            });
                        }
                        else {
                            var url = '/Login/LoginDivision';
                            //window.location.href = url;
                            ASOFT.asoftPopup.showIframe(url, {});
                        }
                    })
                }
                $('.asf-login-error-msg').addClass('hidden');
                $('.asoftcaptcha').addClass('hidden');
                $('#fake_margin').removeClass('hidden');
            }
            else {
                // Thay đổi captcha khi đăng nhập không thành công
                thisParent.xcaptchaChangeCaptchaImage();
                if (result.Data.loginCount >= 3) {
                    $("#asoftcaptcha").removeClass("hidden");
                }
                $('.asf-login-error-msg').removeClass('hidden');
                $('.asf-login-error-msg p').text(ASOFT.helper.getMessage(MESSAGEID_LOGINFAILED));
                $('#fake_margin').addClass('hidden');
                //ASOFT.helper.showErrorSever();
            }
        }

        var login_SuccessCusNum = function (result) {
            loginCount = result.Data.loginCount;
            if (result && result.Status == 0 && window.parent.view) {
                //goToDaskboard();
                window.parent.view.goToDaskboard(result.Data.urlRedirect);
            }
        }
        //var userIDField_KeyUp = function (e) {
        //    //console.log('userIDField_KeyUp');
        //    if (e.keyCode == 13) {
        //        //btnLogin.trigger('click');
        //    }
        //    return false;
        //}

        var passwordField_KeyUp = function (e) {
            //console.log('passwordField_KeyUp');
            if (e.keyCode == 13) {
                btnLogin.trigger('click');
            }
        }

        btnLogin.on('click', btnLogin_Click);
        //userIDField.on('keyup', userIDField_KeyUp);
        passwordField.on('keypress', passwordField_KeyUp);
    }

    //Gửi yêu cầu tạo images
    this.xcaptchaChangeCaptchaImage = function () {
        xcaptchaSetCaptchaImage(solutionUrl, imageUrl);
    };

    this.goToDaskboard = function (urlRedirect) {
        //var s = unescape(document.URL)
        //if (s.indexOf('Url=') < 0) {
        //    return window.location.href = "/RD/DashBoard";
        //}
        if (LoginViewUtilities.isNullEmptyWhiteSpace(urlRedirect)) {
            var url = $('#urlLoginSuccess').val();//s.substring(s.indexOf('Url=') + 4, s.length - 1)
            if (LoginViewUtilities.isNullEmptyWhiteSpace(url)) {
                return window.location.href = "/RD/DashBoard";
            }
            else {
                window.location.href = url;
            }
        }
        else {
            window.location.href = urlRedirect;
        }
        
    }

    this.popupClose = function (e) {
        ASOFT.asoftPopup.hideIframe();
    }

    initEvents()
}

function multiDivisionID_Change (e) {
    //var dataItem = this.dataItem(this.selectedIndex);
    
    if (this.value().length != this.dataSource.data().length) {
        if (this.dataSource.data()[0].DivisionID != '%') {
            this.dataSource.data().unShift({DivisionID: '%', DivisionName: 'Tất cả'});
        }
    }

    if (this.value()[0] == '%') {
        var value = [];
        for (var i = 0; i < this.dataSource.data().length ; i++) {
            if (this.dataSource.data()[i].DivisionID == '%') {
                //this.dataSource.data().remove(i);
                continue;
            }
            value.push(this.dataSource.data()[i].DivisionID);
        }
        this.value(value);
        this.dataSource.data().remove(0);
    }
}

var loginCount = 0;
var view;

$(document).ready(function () {
    view = new ViewLogin();

    //Xử tạo trạng thái active cho button 
    $('.asf-button').mousedown(function () {
        $(this).addClass('asf-button-active');
    }).mouseup(function () {
        $(this).removeClass('asf-button-active');
    })

    view.xcaptchaChangeCaptchaImage();
    if (view.loginCount > 3) {
        $("#asoftcaptcha").removeClass("hidden");
    }
    //if ($("#logOutBack").val() == "True") {
    //    ClearHistory();
    //}

    if (localStorage.getItem("EndSession") != null) {
        var mgs = ASOFT.helper.getMessage("00ML000109");

        $('.asf-login-error-msg').removeClass('hidden');
        $('.asf-login-error-msg p').text(mgs);
        $('#fake_margin').addClass('hidden');

        localStorage.removeItem("EndSession");
    }

});

//function ClearHistory() {
//    var backlen = history.length;
//    history.go(-backlen);
//    window.location.href = $("#urlLoginSuccess").val();
//}


var LoginViewUtilities = {
    isNullEmptyWhiteSpace: function (val) {
        return (val === undefined || val == null || val.length <= 0 || val.match(/^ *$/) !== null) ? true : false;
    }
}
