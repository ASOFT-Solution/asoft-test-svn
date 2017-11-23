//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/06/2016     Quang Chiến       Tạo mới
//####################################################################


$(document).ready(function () {
    var date = $('.Date').text().split('-');
    var date1 = new Date(date[2], date[1] - 1, date[0]);

    var curDate = new Date();
    var curDate1 = new Date();

    var check = true;
    var daynow = curDate.getDay();
    var min = 1;
    var max = 5;
    if (0 < daynow < 6) {
        var dayStart = new Date(curDate.setDate(curDate.getDate() - daynow + min));
        var dayfinish = new Date(curDate1.setDate(curDate1.getDate() - daynow + max));

        if (changeCompareDate(dayStart) <= changeCompareDate(date1) && changeCompareDate(date1)<= changeCompareDate(dayfinish))
        {
            check = false;
        }

        if (check && $('#CheckConfirmUser').val() == 1) {
            check = false;
        }
    }


    var checkIsConfirm = $('#IsConfirm').val() == 1 ? true : false;

    if (check || checkIsConfirm) {
        $('#ViewMaster .asf-panel-master-header').attr('id', 'disabledbutton')
    }
})


function changeCompareDate(curDate) {
    return kendo.toString(curDate, "yyyy/MM/dd").split('/').join('');
}
