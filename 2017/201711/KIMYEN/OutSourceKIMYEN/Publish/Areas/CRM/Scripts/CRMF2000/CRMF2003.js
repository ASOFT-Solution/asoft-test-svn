//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     14/12/2015     Quang Hoàng       Tạo mới
//####################################################################

var CRMF2003CallHistory = null;

$(document).ready(function () {
   
});

function GridData() {
    var data = {};
    data = ASOFT.helper.dataFormToJSON("CRMF2003");
    return data;
}

function BtnFilterCRMF2003_Click() {
    CRMF2003CallHistory = $('#CRMF2003CallHistory').data('kendoGrid');
    CRMF2003CallHistory.dataSource.page(1);
}

function BtnClearFilterCRMF2003_Click() {
    $("#Phone").val("");
    $("#FromDate").val($("#SetFromDate").val());
    $("#ToDate").val($("#SetToDate").val());
    $("#Source").val("");
    $("#AccountID").val("");
    $("#Destination").val("");
    $("#Status").data("kendoComboBox").value("");
    CRMF2003CallHistory = $('#CRMF2003CallHistory').data('kendoGrid');
    CRMF2003CallHistory.dataSource.page(1);
}

function genLink(data) {
    if (data.Download == "" || data.Download == undefined)
        return "";
    else
        return "DownLoad File";
}