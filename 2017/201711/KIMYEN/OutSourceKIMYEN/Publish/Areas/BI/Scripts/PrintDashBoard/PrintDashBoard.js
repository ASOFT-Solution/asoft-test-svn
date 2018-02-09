//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     04/09/2014      Đức Quý         Tạo mới
//####################################################################

PrintDashBoard = new function () {
    this.sortable = null;
    this.currentZoomer = null;
    this.zoomDialog = null;

    this.initChart = function (name, url) {
        ASOFT.helper.post(url,
                         { id: $('#ID').val() },
                         function (data) {
                             $('#' + name).html(data);
                         });
    }    
}

$(document).ready(function () {
    PrintDashBoard.initChart("Block01", $("#UrlBlock01").val());
    PrintDashBoard.initChart("Block04", $("#UrlBlock04").val());
    
    ASOFT.helper.setAutoHeight($('.drmDashboard'));

});