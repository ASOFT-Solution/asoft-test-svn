//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/11/2014      Đức Quý         Tạo mới
//####################################################################

SF0010 = new function () {

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Hide Iframes
    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    };

    this.btnConfig_Click = function (e) {
        if (ASOFT.form.checkRequired("SF0010")) {
            return;
        }

        var url = $('#UrlUpdate').val();
        var data = ASOFT.helper.getFormData(null, "SF0010");
        ASOFT.helper.post(url, data, SF0010.sf0010SaveSuccess);

        ////TODO: Demo thông báo toàn hệ thống
        //$.connection.hub.start().done(function () {
        //    //userHub.server.addUser($('#UserID').val());
        //    var message = 'Hệ thống chuẩn bị bảo trì anh/chị/em nghỉ tay uống nước !!!!!';
        //    userHub.server.alert(message, true);
        //}).fail(function (error) {
        //    console.error(error);
        //});
    }

    this.sf0010SaveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'SF0010', function () {
            window.parent.window.location.reload(true);
            SF0010.btnClose_Click();
        }, null, null, true);
    }
}

$(document).ready(function () {
    ////TODO: Demo thông báo toàn hệ thống
    //userHub = $.connection.userHub;
    //// Create a function that the hub can call back to display messages.
    //userHub.client.sendMessageAlert = function (result) {
    //    // Add the message to the page. 
    //    alert(result);
    //};

    //$.connection.hub.start().done(function () {
    //    userHub.server.broadCastServer();
    //}).fail(function (error) {
    //    console.error(error);
    //});

    //$.connection.hub.disconnected(function (result) {
    //    console.log(result);
    //});
});