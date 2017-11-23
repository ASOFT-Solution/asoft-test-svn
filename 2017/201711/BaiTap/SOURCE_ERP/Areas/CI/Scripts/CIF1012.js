//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     10/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var CIF1012Param = new function () {
    this.formStatus = null;//Loại form
    var CIF1010Grid = null;
    //Sự kiện:Edit
    this.btnEdit_Click = function () {
        formStatus = 2;
        var data = {};
        var args = [];
        var teamID = $("input[name='CIF1012TeamID']").val();
        var departmentID = $("input[name='CIF1012DepartmentID']").val();
        data['args'] = { 'TeamID': teamID, 'DepartmentID': departmentID };
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/CI/CIF1010/CIF1011?FormStatus={0}&TeamID={1}&DepartmentID={2}'.format(formStatus, teamID, departmentID), data);
        return false;
    };
    //Sự kiện: Xóa
    this.btnDelete_Click = function () {
        var args = [];
        var data = {};
        var teamID = $("input[name='CIF1012TeamID']").val();
        args.push(teamID);
        data['args'] = args;
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            ASOFT.helper.postTypeJson('/CI/CIF1010/DeleteMany', data, CIF1012Param.deleteSuccess);
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
                var redirectUrl = $('#UrlCIF1010').val();
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
            parent.CIF1010Grid.dataSource.page(1);
        };
    }
}
//Hàm: Đóng
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}