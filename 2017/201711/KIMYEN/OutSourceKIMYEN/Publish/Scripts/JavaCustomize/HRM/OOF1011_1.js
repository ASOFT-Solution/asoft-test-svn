﻿//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     26/01/2016     Quang Chiến       Tạo mới
//####################################################################

$(document).ready(function () {
    if ($('#isUpdate').val() == "True") {
        $('#UnusualTypeID').prop("readonly", true);
    }
    var ClassType = $(".Note");
    $(".Note").remove();
    $(".HandleMethodID").after(ClassType);
})

