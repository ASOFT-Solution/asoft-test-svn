//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     21/07/2014      Hoàng Tú        Tạo mới
//####################################################################
var POSF0059Param = new function ()
{
    this.formStatus = null;
    var POSF0052Grid = null;
    //Sự kiện: Edit
    this.btnEdit_Click = function ()
    {
        formStatus = 2;
        var tableID = $("input[name='POSF0059TableID']").val();
        var data = {};
        data['args'] = { 'TableID': tableID, 'FormStatus': formStatus };
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/POS/POSF0052/POSF0053?FormStatus={0}&TableID={1}'
        .format(formStatus, tableID), data);
        return false;
    };
    //Sự kiện: Xóa
    this.btnDelete_Click = function ()
    {
        var args = [];
        var data = {};
        var tableID = $("input[name='POSF0059TableID']").val();
        data['args'] = { 'TableID': tableID };
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function ()
        {
           ASOFT.helper.postTypeJson('/POS/POSF0052/Delete', data, POSF0059Param.deleteSuccess);
        });
    };
    //Hàm: Xóa thành công
    this.deleteSuccess = function (result)
    {
        if (result)
        {
            var formId = null;
            var displayOnRedirecting = null;
            if (document.getElementById("FormFilter"))
            {
                formId = "FormFilter";
                displayOnRedirecting = false;
            }
            else if (document.getElementById("ViewMaster"))
            {
                formId = "ViewMaster";
                displayOnRedirecting = true;
            }
            ASOFT.helper.showErrorSeverOption(1, result, formId, function ()
            {
                var redirectUrl = $('#UrlPOSF0052').val();
                if (redirectUrl != null)
                {
                    window.location.href = redirectUrl;
                }
                else
                {
                    refreshGrid();
                }
                }/*Success*/, null /*Error*/, null /*Warning*/, true /*Show succeeded message*/, displayOnRedirecting, "FormFilter");
        }
    };
    //Hàm: load lại lưới
    this.refreshGrid = function ()
    {
        parent.POSF0052Grid.dataSource.page(1);
    };
}
//Hàm: Đóng
function popupClose() {

    ASOFT.asoftPopup.hideIframe();

}
