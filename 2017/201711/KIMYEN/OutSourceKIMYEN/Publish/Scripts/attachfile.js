//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created                Comment
//#     08/03/2017      Quang Hoàng           Tạo mới
//####################################################################

var GridKendo = null;


$(document).ready(function () { 
    GridKendo = $("#GrilSelected").data('kendoGrid');
})

function sendDataFilter() {
    var data = {};
    data.TxtSearch = $("#TxtSearch").val();
    return data;
}

function btnAttachFile_Click() {
    $("#AttachFile").trigger("click");
}

function search_Click() {
    GridKendo.dataSource.page(1);
}

function btnChoose_Click() {
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0)
        return;
    records[0].RelatedToID = $("#RelatedToID").val();
    records[0].RelatedToTypeID_REL = $("#RelatedToTypeID_REL").val();
   
    if ($("#Type").val() == 1) {
        ASOFT.helper.postTypeJson("/AttachFile/InsertFile", records, InsertSuccess);
    }
    else {
        window.parent.receiveResult(records);
        ASOFT.asoftPopup.closeOnly();
    }

    //ASOFT.asoftPopup.closeOnly();
}

function btnChooseDynamic_Click() {
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0)
        return;
    records[0].RelatedToID = $("#RelatedToID").val();
    records[0].RelatedToTypeID_REL = $("#RelatedToTypeID_REL").val();

    if (typeof parent.receiveResult_AttachFile === "function") {
        window.parent.receiveResult_AttachFile(records);
        ASOFT.asoftPopup.closeOnly();
    }
}

function InsertSuccess(result) {
    if (result)
    {
        if (typeof parent.refreshGrid === "function") {
            parent.refreshGrid('CRMT00002');
        }
        ASOFT.asoftPopup.closeOnly();
    }
}

function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}

function onImageSuccess(data) {
    GridKendo.dataSource.page(1);
}

function onImageUpload(data) {

}