//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     30/07/2014      Hoàng Tú        Tạo mới
//####################################################################
var POSF0058Param = new function ()
{
    this.formStatus  =  null;//Loại form
    var POSF0034Grid =  null;
    //Sự kiện:Edit
    this.btnEdit_Click = function ()
    {
        formStatus = 2;
        var data = {};
        var args = [];
        var areaID = $("input[name='POSF0058AreaID']").val();  
        data['args'] = { 'AreaID': areaID };
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/POS/POSF0034/POSF0035?FormStatus={0}&AreaID={1}'
       .format(formStatus, areaID), data);
        return false;
    };
    //Sự kiện: Xóa
    this.btnDelete_Click = function ()
    {
        var args = [];
        var data = {};
        var areaID = $("input[name='POSF0058AreaID']").val();       
        var shopID = $("input[name='POSF0058ShopID']").val();
        var divisonID = $("input[name='POSF0058DivisionID']").val();
        data['args'] = { 'AreaID': areaID,'ShopID':shopID,'DivisionID':divisonID };
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function ()
        {
            ASOFT.helper.postTypeJson('/POS/POSF0034/Delete', data, POSF0058Param.deleteSuccess);
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
            } else if (document.getElementById("ViewMaster"))
            {
                formId = "ViewMaster";
                displayOnRedirecting = true;
            }
            ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
                var redirectUrl = $('#UrlPOSF0034').val();
                if (redirectUrl != null)
                {
                    window.location.href = redirectUrl;
                }
                else
                {
                    refreshGrid();
                }
            }/*Success*/, null /*Error*/, null /*Warning*/, true /*Show succeeded message*/, displayOnRedirecting, "FormFilter");

        };
        //Hàm: Load lại lưới
        this.refreshGrid = function ()
        {
            parent.POSF0034Grid.dataSource.page(1);
        };
    }
}
//Hàm: Đóng
function popupClose()
{

    ASOFT.asoftPopup.hideIframe();

}