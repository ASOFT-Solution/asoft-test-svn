// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    11/10/2017  Văn Tài         Create New
// ##################################################################
$(document)
    .ready(function () {

        // #region --- Kiểm tra quyền ---

        SCREEN2132.CheckPermission();

        // #endregion --- Kiểm tra quyền ---

    });


// SCREEN2132: HRMF2132
SCREEN2132 = new function () {

    // #region --- Constants ---

    // #endregion --- Constants ---

    // #region --- Methods ---

    /**
     * Kiểm tra phân quyền
     * @returns {} 
     * @since [Văn Tài] Created [04/12/2017]
     */
    this.CheckPermission = function () {
        var url = new URL(window.location.href);
        var pk = url.searchParams.get("PK");
        $.ajax({
            url: '/HRM/HRMF2132/CheckUpdateData?pTrainingCostID=' + pk,
            success: function (result) {
                if (result.CanEdit == 0) {
                    $("#BtnEdit").parent().addClass('asf-disabled-li');
                }
                if (result.CanDelete == 0) {
                    $("#BtnDelete").parent().addClass('asf-disabled-li');
                }
            }
        });
    }

    /**
     * Xử lý hiển thị tên
     * @returns {} 
     * @since [Văn Tài] Created [12/10/2017]
     */
    this.NameProcessing = function () {
        $("." + SCREEN2132.FIELD_FIRSTNAME)[0].innerHTML = "{0} {1} {2}".format(
            $("." + SCREEN2132.FIELD_FIRSTNAME)[0].innerHTML,
            $("." + SCREEN2132.FIELD_MIDDLENAME)[0].innerHTML,
            $("." + SCREEN2132.FIELD_LASTNAME)[0].innerHTML
        );

        $("." + SCREEN2132.FIELD_MIDDLENAME).parent().remove();
        $("." + SCREEN2132.FIELD_LASTNAME).parent().remove();
    }

    // #endregion --- Methods ---
}