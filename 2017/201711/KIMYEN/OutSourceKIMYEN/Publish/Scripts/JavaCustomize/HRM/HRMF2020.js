// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    18/12/2017  Văn Tài         Create New
// ##################################################################

$(document)
    .ready(function () {

        HRMF2020.AllEvents();

    });

// HRMF2021 : Đợt tuyển dụng
var HRMF2020 = new function () {

    // #region --- Constants ---

    // #endregion --- Constants ---

    // #region --- Member Variables ---

    // Kế thừa đợt
    this.isInherit = false;

    // #endregion --- Member Variables ---

    // #region --- Methods ---

    // #endregion --- Methods ---

    // #region --- Events ---

    /**
     * Xử lý sự kiện cho các Controls
     * @returns {} 
     * @since [Văn Tài] Created [18/12/2017]
     */
    this.AllEvents = function () {

        // Xử lý nút kết thừa
        $("#BtnInherit").unbind("click");
        $("#BtnInherit")
            .on("click",
                function (e) {
                    ASOFT.form.clearMessageBox();
                    GridKendo = $('#GridHRMT2020').data('kendoGrid');
                    var records = ASOFT.asoftGrid.selectedRecords(GridKendo);
                    if (records.length == 0) return;
                    var firstRecord = records[0];

                    HRMF2020.isInherit = true;

                    ASOFT.asoftPopup.showIframe("/PopupMasterDetail/Index/HRM/HRMF2021?PK="
                        + firstRecord.RecruitPeriodID + "&Table=HRMT2020&key=RecruitPeriodID&DivisionID=" + firstRecord.DivisionID
                        + "&IsInherit=1"
                        , {});
                });
    };

    // #endregion --- Events ---
};

// #region --- Global Callback ---

function receiveResult(result) {
};

// #endregion --- Global Callback ---
