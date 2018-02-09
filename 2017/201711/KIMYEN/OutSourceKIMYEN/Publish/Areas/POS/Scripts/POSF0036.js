//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     17/04/2014      Minh Lâm         Tạo mới
//####################################################################

$(document).ready(function () {
    window.parent.ASOFTCORE.start('choose-tables', true);
    $('#popupInnerIframe').data('kendoWindow').maximize().setOptions({
        draggable: false
    });

    $("#RWDPopup400").attr("disabled", "disabled");
    $("#RWDPopup600").attr("disabled", "disabled");
});

$(window).unload(function () {
    window.parent.ASOFTCORE.stop('choose-tables');
});
