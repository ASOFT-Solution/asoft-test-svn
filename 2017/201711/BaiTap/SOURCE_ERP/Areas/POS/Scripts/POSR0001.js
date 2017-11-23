//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     10/02/2014      Minh Lâm         Tạo mới
//####################################################################
var posGrid = null;
var posViewModel = null;
var rowNumber = 0;

$(document).ready(function () {
    posGrid = $("#POSF00161Print").data("kendoGrid");
    
    //Lưu sau khi nhập cột 
    posGrid.bind("dataBound", function (e) {
        rowNumber = 0;
    });
});


/*
* rendernumber
*/
function renderNumber(data) {
    return ++rowNumber;
}


