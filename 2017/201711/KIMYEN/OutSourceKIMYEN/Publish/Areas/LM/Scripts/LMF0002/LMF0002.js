$(document).ready(function () {
    LMF0002.AddEventControl();
});

/**  
* Class LMF0002
*
* [Kim Vu] Create New [06/12/2017]
**/
var LMF0002 = new function () {

    this.isSaved = false;

    // #region --- Private Function ---

    /**  
    * Add event for controls
    *
    * [Kim Vu] Create New [06/12/2017]
    **/
    this.AddEventControl = function () {

        $("input[type ='checkbox']").bind('click', LMF0002.chkIsUsed_CheckedChange);
        $("#BtnClose").bind('click', LMF0002.btnClose_Click);
        $("#BtnSaveClose").bind('click', LMF0002.btnSave_Click);
    }

    /**  
    * Process checked change of checkbox
    *
    * [Kim Vũ] Create New [06/12/2017]
    **/
    this.chkIsUsed_CheckedChange = function (e) {
        if (e.target.checked) {
            $("input[type='text'][id='" + e.target.id + "']").removeClass('asf-disabled-li')
            $("input[type='text'][id='" + e.target.id + "E']").removeClass('asf-disabled-li')
        } else {
            $("input[type='text'][id='" + e.target.id + "']").addClass('asf-disabled-li')
            $("input[type='text'][id='" + e.target.id + "E']").addClass('asf-disabled-li')
        }
    }

    /**  
    * Get data Form
    *
    * [Kim Vu] Create new [06/12/2017]
    **/
    this.GetDataForm = function () {
        var data = [];
        for (var i = 1; i <= 20; i++) {
            var record = {};
            record.IsUsed = $("input[type='checkbox'][id='" + kendo.format("L{0:00}", i) + "']").prop('checked') ? 1 : 0;
            record.UserName = $("input[type='text'][id='" + kendo.format("L{0:00}", i) + "']").val();
            record.UserNameE = $("input[type='text'][id='" + kendo.format("L{0:00}", i) + "E']").val();
            record.TypeID = kendo.format("L{0:00}", i);
            data.push(record);
        }
        return data;
    }

    // #endregion --- Private Function ---

    // #region --- Event Handle ---

    /**  
    * Event Click of button Close
    *
    * [Kim Vu] Create New [06/12/2017]
    **/
    this.btnClose_Click = function (e) {
        if (!ASOFT.form.formClosing('LMF0002') && !LMF0002.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                LMF0002.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    }

    /**  
    * Event Click of button Save
    *
    * [Kim Vu] Create New [06/12/2017]
    **/
    this.btnSave_Click = function (e) {
        var url = $("#UrlConfirm").val();
        var data = LMF0002.GetDataForm();
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.success) {
                LMF0002.isSaved = true;
                LMF0002.btnClose_Click();
            } else {
                ASOFT.form.displayMessageBox('#LMF0002', [result.message], null);
                LMF0002.isSaved = false;
            }
        });
    }

    // #endregion --- Event Handle ---
}