//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     10/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var CIF1002Param = new function () {
    this.formStatus = null;//Loại form
    var CIF1000Grid = null;
    //Sự kiện:Edit
    this.btnEdit_Click = function () {
        formStatus = 2;
        var data = {};
        var args = [];
        var departmentID = $("input[name='CIF1002DepartmentID']").val();
        data['args'] = { 'DepartmentID': departmentID };
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/CI/CIF1000/CIF1001?FormStatus={0}&DepartmentID={1}'
       .format(formStatus, departmentID), data);
        return false;
    };
    //Sự kiện: Xóa
    this.btnDelete_Click = function () {
        var args = new Array();
        var data = {};
        var departmentID = $("input[name='CIF1002DepartmentID']").val();
        args.push(departmentID);
        data['args'] = args;
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            ASOFT.helper.postTypeJson('/CI/CIF1000/DeleteMany', data, CIF1002Param.deleteSuccess);
        });
    };
    //Hàm: Xóa thành công
    this.deleteSuccess = function (result) {
        if (result) {
            var formId = null;
            var displayOnRedirecting = null;
            if (document.getElementById("FormFilter")) {
                formId = "FormFilter";
                displayOnRedirecting = false;
            } else if (document.getElementById("ViewMaster")) {
                formId = "ViewMaster";
                displayOnRedirecting = true;
            }
            ASOFT.helper.showErrorSeverOption(1, result, formId, function () {
                var redirectUrl = $('#UrlCIF1000').val();
                if (redirectUrl != null) {
                    window.location.href = redirectUrl;
                }
                else {
                    refreshGrid();
                }
            }/*Success*/, null /*Error*/, null /*Warning*/, true /*Show succeeded message*/, displayOnRedirecting, "FormFilter");

        };
        //Hàm: Load lại lưới
        this.refreshGrid = function () {
            parent.CIF1000Grid.dataSource.page(1);
        };
    }
}
//Hàm: Đóng
function popupClose() {

    ASOFT.asoftPopup.hideIframe();

}