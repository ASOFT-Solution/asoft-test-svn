
$(document)
    .ready(function () {
        SCREEN0010.SettingLayout();

        $("#DivisionID").val($("#EnvironmentDivisionID").val());
        $("#Save").unbind();
        $("#Save")
            .bind(
                "click",
                CustomBtnSave_Click);
    });


SCREEN0010 = new function () {

    /**
     * Thiết lập layout
     * @returns {} 
     * @since [Văn Tài] Created [05/01/2018]
     */
    this.SettingLayout = function () {
        var buttonUpdate = '<div><a class="k-button k-button-icontext asf-button" id="Save" style="" data-role="button" role="button" aria-disabled="false" tabindex="0"><span class="asf-button-text">Lưu</span></a></div>';

        $("#SaveCopy").before(buttonUpdate);

        $("#SaveNew").attr("display", "none");
        $("#SaveCopy").attr("display", "none");
    };
};

function CustomBtnSave_Click() {
    var data = ASOFT.helper.dataFormToJSON("HRMF0010");
    ASOFT.helper.postTypeJson("/HRMF0010/Insert", data, onInsertCustomSuccess);
};


function onInsertCustomSuccess(result) {
    ASOFT.form.displayInfo('#HRMF0010', ASOFT.helper.getMessage("00ML000015"));
    parent.popupClose();
}