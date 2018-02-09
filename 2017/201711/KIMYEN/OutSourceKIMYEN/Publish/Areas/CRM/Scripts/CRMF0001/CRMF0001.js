var STT = null;
$(document).ready(function () {
    var ip = $(":input[type='text']");
    $(ip).each(function () {
        $(this).attr("name", this.id);
    })
    var cb = $(":input[type='checkbox']");
    $(cb).each(function () {
        $(this).attr("name", this.id);
        $(this).attr("style", "margin-left: 43px;");
    })


    STT = parseInt($("#STT").val());

    for (var i = 0; i < STT; i++)
    {
        $("#IsUsed" + i).click(function () {
            var id = $(this).attr("id").split('IsUsed')[1];
            if ($(this).is(':checked')) {
                $("#UserName" + id).removeAttr("disabled");
                $("#UserNameE" + id).removeAttr("disabled");
            }
            else {
                $("#UserName" + id).attr("disabled", "disabled");
                $("#UserNameE" + id).attr("disabled", "disabled");
            }
        })
    }
})


function btnCancle_Click() {
    ASOFT.asoftPopup.closeOnly();
}

function btnSaveVarchar_Click() {
    var lData = [];

    for (var i = 0; i < STT; i++)
    {
        var itemDT = {};
        itemDT.IsUsed = $("#IsUsed" + i).is(':checked');
        itemDT.TypeID = $("#TypeID" + i).val();
        itemDT.UserName = $("#UserName" + i).val();
        itemDT.UserNameE = $("#UserNameE" + i).val();
        lData.push(itemDT);
    }

    ASOFT.helper.postTypeJson('/CRM/CRMF0001/Update', lData, updateSuccess);
}


function updateSuccess(result) {
    var msaData = ASOFT.helper.getMessage(result.Message);
    if(result.Status == 0)
        ASOFT.form.displayInfo('#CRMF0001', msaData);
    else
        ASOFT.form.displayMultiMessageBox('#CRMF0001', 1, msgData);
}