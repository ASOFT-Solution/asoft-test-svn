$(document).ready(function () {
    HF0404.HF0404Grid1 = ASOFT.asoftGrid.castName('HF0404Grid1');
    HF0404.HF0404Grid2 = ASOFT.asoftGrid.castName('HF0404Grid2');

    HF0404.searchbtnFilter = false;

    $("#popupInnerIframe").kendoWindow({
        activate: function () {
            HF0404.TeamIDopen();

            HF0404.HF0404Grid1.dataSource.read();
            HF0404.HF0404Grid2.dataSource.read();
        }
    });

});

var action = 0;      // 1:SaveNext     2:SaveCopy   3:Update     0: SaveClose
var MethodVacation_FirstLoad = true;

HF0404 = new function () {
    this.HF0404Grid1 = null;
    this.HF0404Grid2 = null;

    //Load lại grid
    this.sendDataFilter = function () {
        var dataMaster = [];
        dataMaster.MethodVacationID = $('#MethodVacationID').val();
        dataMaster.DepartmentID = $('#DepartmentID').val().split(" ").join("','");
        dataMaster.TeamID = $('#TeamID').val().split(" ").join("','");
        return dataMaster;
    };

    this.btn_ChangeSingle = function () {
        //removeRowIsempty(HF0404.HF0404Grid2);
        var record = ASOFT.asoftGrid.selectedRecord(HF0404.HF0404Grid1);
        rowNumber = 0;
        if (!record || record.EmployeeID == null) return;
        HF0404.HF0404Grid2.dataSource.add(record);
        HF0404.HF0404Grid1.dataSource.remove(record);
        HF0404.HF0404Grid1.focus(0);
    }

    this.btn_UnChangeSingle = function () {
        //removeRowIsempty(HF0404.HF0404Grid1);
        var record = ASOFT.asoftGrid.selectedRecord(HF0404.HF0404Grid2);
        rowNumber = 0;
        if (!record || record.EmpLoaMonthID == null) return;
        HF0404.HF0404Grid1.dataSource.add(record);
        HF0404.HF0404Grid2.dataSource.remove(record);
        HF0404.HF0404Grid2.focus(0);
    }

    this.btn_ChangeAll = function () {
        var dataSource1 = HF0404.HF0404Grid1.dataSource._data;
        var dataSource2 = HF0404.HF0404Grid2.dataSource._data;
        $.merge(dataSource2, dataSource1);

        HF0404.HF0404Grid1.dataSource.data([]);
        HF0404.HF0404Grid1.refresh();
        HF0404.HF0404Grid2.refresh();
    }

    this.btn_ReturnAll = function () {
        var dataSource1 = HF0404.HF0404Grid1.dataSource._data;
        var dataSource2 = HF0404.HF0404Grid2.dataSource._data;
        $.merge(dataSource1, dataSource2);

        HF0404.HF0404Grid2.dataSource.data([]);
        HF0404.HF0404Grid1.refresh();
        HF0404.HF0404Grid2.refresh();
    }



    this.TeamIDopen = function (e) {
        var url = $('#UrlLoadDataTeamID').val();
        var data = {};
        data.departmentID = $('#DepartmentID').val().split(',').join("','");
        ASOFT.helper.postTypeJson(url, data, function (result) {
            $('#TeamID').data("kendoDropDownList").dataSource.data(result);
        });
    }

    this.MethodVacationID_Change = function (e) {
        $('#MethodVacationName').val(e.sender.dataSource._data[e.sender.selectedIndex].MethodVacationName);
        HF0404.HF0404Grid1.dataSource.read();
        HF0404.HF0404Grid2.dataSource.read();
    }

    this.MethodVacationID_Databound = function (e) {
        if (MethodVacation_FirstLoad) {
            HF0404.HF0404Grid1.dataSource.read();
            HF0404.HF0404Grid2.dataSource.read();
            MethodVacation_FirstLoad = false;
        }
    }

    this.DepartmentID_Changed = function (e) {
        HF0404.HF0404Grid1.dataSource.read();

        $('#TeamID').data("kendoDropDownList").value(null);
        $('#TeamID').data("kendoDropDownList").text('');
        HF0404.TeamIDopen();
    }

    this.TeamID_Changed = function (e) {
        HF0404.HF0404Grid1.dataSource.read();
        //HF0404.HF0404Grid2.dataSource.read();
    }

    this.btnClose_Click = function () {
        ASOFT.asoftPopup.hideIframe(true);
    }

    this.btnSaveCopy_Click = function () {
        action = 2;
        HF0404.btnSave_Click();
    }

    this.btnSaveNext_Click = function () {
        action = 1;
        HF0404.btnSave_Click();
    }

    //Hàm: Kiểm tra lưu
    this.btnSave_Click = function () {
        
        ASOFT.form.clearMessageBox();

        var url = $("#UrlSave").val();
        var data = {};

        data = ASOFT.helper.dataFormToJSON("HF0404");
        data.lstGrid = HF0404.HF0404Grid2.dataSource._data;
        ASOFT.helper.postTypeJson(url, data, HF0404.saveSuccess);
    }

    this.saveSuccess = function (result) {
        if (result.isChecked) {
            ASOFT.form.displayInfo('#HF0404', [ASOFT.helper.getMessage('00ML000015')], null);
            if (action == 1) {
                HF0404.clearFormHF0404();
            }
            window.parent.refreshGrid();
        }
        else {
            ASOFT.form.displayMessageBox('#HF0404', [ASOFT.helper.getMessage('AFML000048')], null);
        }
    }

    // Hàm: dọn trắng các textbox khi lưu và thêm mới
    this.clearFormHF0404 = function () {
        if (action == 1) {
            var methodVacationID = $("#MethodVacationID").data("kendoComboBox");
            methodVacationID.select(0);
            var departmentID = $("#DepartmentID").data("kendoDropDownList");
            //departmentID.dataSource.read();
            departmentID.select(0);
            var teamID = $("#TeamID").data("kendoDropDownList");
            teamID.select(0);

            HF0404.HF0404Grid1.dataSource.read();
            HF0404.HF0404Grid2.dataSource.read();

        }
    }

    this.cboMethodVacationID_EventRequestEnd = function (e) {
        $('#MethodVacationName').val(e.response[0].MethodVacationName)
    }
}