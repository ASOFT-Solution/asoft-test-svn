//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created         Comment
//#     10/10/2014      Hoàng Tú        Tạo mới
//####################################################################
var SF1002Param = new function () {
    this.formStatus = null;//Loại form
    var SF1000Grid = null;
    //Sự kiện:Edit
    this.btnEdit_Click = function () {
        formStatus = 2;
        var data = {};
        var args = [];
        var employeeID = $("input[name='SF1002EmployeeID']").val();
        data['args'] = { 'EmployeeID': employeeID };      
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe('/S/SF1000/SF1001?FormStatus={0}&EmployeeID={1}'
       .format(formStatus, employeeID), data);
        return false;
    };
    //Sự kiện: Xóa
    this.btnDelete_Click = function () {                  
        var args = new Array();
        var data = {};
        var employeeID = $("input[name='SF1002EmployeeID']").val();
        args.push(employeeID);
        data['args'] = args;    
        ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000024'), function () {
            ASOFT.helper.postTypeJson('/S/SF1000/DeleteMany', data, SF1002Param.deleteSuccess);
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
                var redirectUrl = $('#UrlSF1000').val();
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
            parent.SF1000Grid.dataSource.page(1);
        };
    }
    this.btnChangePass_Click = function ()
    {
        var employeeID = $("input[name='SF1002EmployeeID']").val();
        ASOFT.asoftPopup.showIframe('/S/SF1010/SF1014?UserID={0}'
                   .format(employeeID));
    }
    this.btnLockUser_Click = function () {
        var employeeID = $("input[name='SF1002EmployeeID']").val();
        
        var url = $('#LockUser').val();
        var data = { args: [employeeID] };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                //SF1002Param.reloadPartial(employeeID);
                window.location.reload();
            }
        });
    }
    this.btnUnLockUser_Click = function () {
        var employeeID = $("input[name='SF1002EmployeeID']").val();
        var url = $('#UnLockUser').val();
        var data = { args: [employeeID] };
        ASOFT.helper.postTypeJson(url, data, function (result) {
            if (result.Status == 0) {
                //SF1002Param.reloadPartial(employeeID);
                window.location.reload();
            }
        });
    }

    this.reloadPartial = function (employeeID) {
        var url = $('#SF1002M').val();
        ASOFT.helper.post(url, { EmployeeID: employeeID }, function (result) {
            $('#viewPartial').html(result);
        })
    };

}
//Hàm: Đóng
function popupClose() {
    ASOFT.asoftPopup.hideIframe();
}