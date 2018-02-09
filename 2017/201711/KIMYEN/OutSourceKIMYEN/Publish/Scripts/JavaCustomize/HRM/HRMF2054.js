// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    24/10/2017  Văn Tài         Create New
// ##################################################################

$(document)
    .ready(function () {


    });

// HRMF2054
SCREEN2054 = new function () {

};

// #region --- Global Callback ---

/**
 * Duyệt tất cả
 * @returns {} 
 * @since   [Văn Tài] Created [24/10/2017]
 */
function CustomConfirmAll() {
    ASOFT.form.clearMessageBox();
    GridKendo = $('#GridHRMFT2054').data('kendoGrid');
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;

    ASOFT.asoftPopup.showIframe("/PopupLayout/Index/HRM/OOF2056?Table=HRMFT2054", {});
}


// #endregion --- Global Callback ---

function RecruitApproved_Click(pk) {
    url = '/PopupLayout/Index/HRM/HRMF2055?PK=' + pk + '&Table=HRMFT2054&key=CandidateID';
    ASOFT.asoftPopup.showIframe(url, {});
}

function CustomizeApproved(approvedStatus) {
    ASOFT.asoftLoadingPanel.show();
    // Xu li duyet hang loat    
    var dataGrid = getDataGrid();
    var data = {
        RecDecisionNo: $("#RecDecisionNo_HRMF2054").val(),
        CandidateID: $("#CandidateID_HRMF2054").val(),
        RecruitPeriodID: $("#RecruitPeriodID_HRMF2054").val(),
        DepartmentID: $("#DepartmentID_HRMF2054").val(),
        DutyID: $("#DutyID_HRMF2054").val(),
        RecruitStatus: approvedStatus,
        IsCheckAll: $("#chkAll").prop('checked') ? 1 : 0,
        RecruitList: dataGrid
    };
    var url = "/HRM/HRMF2054/RecruitApproved";
    //$.ajax({
    //    type: "POST",
    //    url: url,
    //    data: data,
    //    async: false,
    //    success: function (result) {            
    //        return true;
    //    },
    //    error: function (xhr, status, exception) {
    //        return false;
    //    }
    //});

    ASOFT.helper.postTypeJson(url, data, function (result) {
        return true;
    });

    ASOFT.asoftLoadingPanel.hide();
}

function getDataGrid() {
    var args = [];
    GridKendo = $('#GridHRMFT2054').data('kendoGrid');
    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
    if (records.length == 0) return;
    for (var i = 0; i < records.length; i++) {        
        var key = {};
        key.CandidateID = records[i]["CandidateID"];
        key.DivisionID = records[i]["DivisionID"] == "" ? "@@@" : records[i]["DivisionID"];
        key.RecruitPeriodID = records[i]["RecruitPeriodID"];
        args.push(key);
    }
    return args;
}