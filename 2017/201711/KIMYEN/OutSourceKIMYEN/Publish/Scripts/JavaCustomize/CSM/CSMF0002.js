// #################################################################
// # Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved.                       
// #
// # History：                                                                        
// #	Date Time	Updated		    Content                
// #    17/01/2018  Văn Tài         Create New
// ##################################################################

$(document)
    .ready(function () {

        // #region --- First Processing ---

        $("#" + CSMF0002.FIELD_DIVISIONID).val($("#EnvironmentDivisionID").val());

        CSMF0002.LayoutSettings();

        // #endregion --- First Processing ---

        // Xử lý chọn combo đầu tiên
        $("#FirmID").data("kendoComboBox").select(0);

        //        setTimeout(CSMF0002.LoadDataGrid, 500);
        //                CSMF0002.LoadDataGrid();

        // #region --- Last Processing ---

        CSMF0002.CatchEvents();

        document.onreadystatechange = function () {
            if (document.readyState === 'complete') {
                //CSMF0002.LoadDataGrid();
                setTimeout(CSMF0002.LoadDataGrid, 500);
            }
        }

        // #region --- Last Processing ---

    });



/**
 * CSMF0002: Thiết lập tài khoản API cho User theo Hãng
 */
var CSMF0002 = new function () {

    // #region --- Constants ---

    this.FIELD_DIVISIONID = "DivisionID";
    this.FIELD_FIRMID = "FirmID";

    this.SCREENID = "CSMF0002";

    this.GRID = "GridEditCSMT0002_1";

    // Flags
    this.USER_CHOOSING = "USER_CHOOSING";

    // #endregion --- Constants ---

    // #region --- Variables ---

    this.CurrentChoose = "";

    // #endregion --- Variables ---

    // #region --- Methods ---

    /**
     * Thiết lập lại layout
     * @returns {} 
     * @since [Văn Tài] Created [17/01/2018]
     */
    this.LayoutSettings = function () {

        var chooseUser = ASOFT.helper.getLanguageStringA00("A00.ChooseUser");
        var save = ASOFT.helper.getLanguageStringA00("A00.btnSave");

        var buttonUI = "<div>"
                          + "<a class='k-button k-button-icontext asf-button' id='btnChooseUser' onclick='CSMF0002.ChooseUserOnclick()' style='' data-role='button' role='button' aria-disabled='false' tabindex='0'><span class='asf-button-text'>" + chooseUser + "</span></a>" +
                        "</div>";

        $($(".FirmID").parent().parent()).after(buttonUI);

        // Không cho thêm dòng mới
        $("#" + CSMF0002.GRID).attr("AddNewRowDisabled", "true");


        $("#SaveClose").attr("style", "display: block !important;");
        $("#BtnSave").attr("style", "display: none !important;");
        $("#SaveCopy .asf-button-text")[0].outerText = save;
        $("#SaveNew").attr("style", "display: none !important;");
    };
    
    /**
     * Bắt các sự kiện
     * @returns {} 
     * @since [Văn Tài] Created [17/01/2018]
     */
    this.CatchEvents = function () {

        // Hãng
        $("#FirmID").data("kendoComboBox").bind("change", CSMF0002.FirmChanging);
        $("#Close").on("click", CSMF0002.CloseOnclick);

        $("#Save").unbind("click");
        $("#Save").on("click", CSMF0002.SaveOnClick);

        $("#SaveCopy").unbind("click");
        $("#SaveCopy").on("click", CSMF0002.SaveOnClick);

    };

    /**
     * Load dữ liệu Grid
     * @returns {} 
     * @since [Văn Tài] Created [17/01/2018]
     */
    this.LoadDataGrid = function () {
        var firmId = "";

        var firmItem = CSMF0002.GetComboBoxValueItem("FirmID");

        if (CSMF0002.IsNotNullOrUndefined(firmItem)) {
            firmId = firmItem.FirmID;
        }

        data = {
            firmID: firmId
        };

        $.ajax({
            url: '/CSM/CSMF0002/GetUserListBySearch',
            data: data,
            async: false,
            success: function (result) {
                if (result.data != "undefined") {
                    var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
                    var datasource = grid.dataSource;

                    //Xóa lưới
                    grid.dataSource.data([]);

                    //insert dữ liệu cho lưới
                    for (var i = 0; i < result.data.length; i++) {
                        datasource.insert({
                            Orders: i + 1,
                            UserID: result.data[i]["UserID"],
                            UserName: result.data[i]["UserName"],
                            // IsCommon: result.data[i]["IsCommon"],
                            Account: result.data[i]["Account"],
                            Password: result.data[i]["Password"],
                            TechnicalID: result.data[i]["TechnicalID"]
                        });
                    };
                }
            }
        });
    };

    /**
     * Kiểm tra và xóa dòng nếu
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.ClearRows = function () {
        var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
        var dataSource = grid.dataSource._data;

        // Nếu dòng đầu không tồn tại UserID
        if (dataSource.length > 0 && (typeof (dataSource[0].UserID) == "undefined" || dataSource[0].UserID === ""))
            //Xóa lưới
            grid.dataSource.data([]);
    };

    /**
     * Kiểm tra không hợp lệ dữ liệu
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.IsInValid = function () {
        CSMF0002.ClearMessageBox();

        // #region --- Flag Checkers ---

        // Master flag
        var InvalidData = false;

        // Null flag
        var NullValue = false;
        var NoRow = false;

        var invalidComboBox = [];

        // #endregion --- Flag Checkers ---

        // #region --- Messages ---

        var message_array = [];

        // Yêu cầu nhập
        var MSG_REQUIREDINPUT = "00ML000039";
        //        var MSG_ISEXIST = "00ML000053";

        // #endregion --- Messages ---

        // #region --- CHECK: Required Input ---

        // Hãng
        if (!CSMF0002.IsNotNullOrUndefined(CSMF0002.GetComboBoxValueItem(CSMF0002.FIELD_FIRMID))) {
            NullValue = true;
            invalidComboBox.push(CSMF0002.FIELD_FIRMID);
            message_array.push(ASOFT.helper.getLabelText(CSMF0002.FIELD_FIRMID, MSG_REQUIREDINPUT));
        }

        // #endregion --- CHECK: Required Input ---

        var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
        var dataSource = grid.dataSource._data;
        if (dataSource.length == 0)
            NoRow = true;

        // #region --- Show Errors ---

        InvalidData = NullValue || NoRow;

        if (InvalidData) {

            // Danh sách combo lỗi
            for (var i = 0; i < invalidComboBox.length; i++) {
                CSMF0002.ShowComboError(invalidComboBox[i]);
            }

            if (message_array.length > 0)
                // Nội dung lỗi
                CSMF0002.ShowMessageErrors(message_array);
        }

        // #endregion --- Show Errors ---

        return InvalidData;
    };

    /**
     * Lấy toàn bộ dữ liệu
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.GetAllData = function () {
        var data = {};
        data.FirmID = "";
        data.GridCSMT0002 = {};

        var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
        data.GridCSMT0002 = grid.dataSource._data;

        // Lấy mã hãng
        var firmItem = CSMF0002.GetComboBoxValueItem(CSMF0002.FIELD_FIRMID);
        if (CSMF0002.IsNotNullOrUndefined(firmItem))
            data.FirmID = firmItem.FirmID;

        return data;
    };

    /**
     * Lưu dữ liệu
     * @param {} data 
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2017]
     */
    this.SaveData = function (data) {
        var url = "/CSM/CSMF0002/UpdateData";
        var sendData = {
            firmID: data.FirmID,
            ListCSMT0002: data.GridCSMT0002
        };
        ASOFT.helper.postTypeJson(url, sendData, function (result) {
            if (result.IsSusscess == 0) { // Lỗi
                ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000062"));
            } else {
                ASOFT.form.displayInfo('#' + $('#sysScreenID').val(), ASOFT.helper.getMessage("00ML000015"));
            }
        });
    }

    // #region  --- Utilities ---

    /**
     * Lấy toàn bộ dữ liệu ComboBox được chọn
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetComboBoxValueItem = function (elementID) {
        try {
            var combo = $("#" + elementID).data("kendoComboBox");
            return combo.dataItem(combo.select());
        } catch (e) {
            console.log(e);
        }
    };

    /**
     * Set giá trị control ComboBox
     * @param {} elementID 
     * @param {} value: true | false
     * @returns {} 
     * @since [Văn Tài] Created [09/10/2017]
     */
    this.SetComboBoxValue = function (elementID, value) {
        $("#" + elementID).data("kendoComboBox").value(value);
    };

    // Kiểm tra không phải null hay undefined
    this.IsNotNullOrUndefined = function (checker) {
        return (typeof (checker) != 'undefined' && checker != null);
    };


    /**
     * Hiển thị lỗi combo 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowComboError = function (comboID) {
        $("#" + comboID).parent().addClass("asf-focus-input-error");
    }

    /**
     * Xóa các báo lỗi
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.RemoveElementError = function () {
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Ẩn lỗi
     * @param {} elementID 
     * @returns {} 
     * @since [Văn Tài] Created [04/10/2017]
     */
    this.HideElementError = function (elementID) {
        $("#" + elementID).removeClass('asf-focus-input-error');
    }

    /**
     * Lấy vị trí Column
     * @param {} grid 
     * @param {} columnName 
     * @returns {}
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.GetColumnIndex = function (grid, columnName) {
        var columns = grid.columns;
        for (var i = 0; i < columns.length; i++) {
            if (columns[i].field == columnName) return i;
        }
        return -1;
    }

    /**
     * Thực hiện xóa Message thông báo
     * @returns {} 
     * @since [Văn Tài] Created [05/10/2017]
     */
    this.ClearMessageBox = function () {
        ASOFT.form.clearMessageBox();
        $(".asf-focus-input-error").removeClass("asf-focus-input-error");
    }

    /**
     * Hiển thị nội dung lỗi
     * @param {} message_array 
     * @returns {} 
     * @since [Văn Tài] Created [06/10/2017]
     */
    this.ShowMessageErrors = function (message_array) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), message_array, null);
    }

    // #endregion --- Utilities ---

    // #endregion --- Methods ---

    // #region --- Events ---

    /**
     * Sự kiện thay đổi Hãng
     * @param {} e 
     * @returns {} 
     * @since [Văn Tài] Created [17/01/2018]
     */
    this.FirmChanging = function (e) {
        CSMF0002.LoadDataGrid();
    };

    /**
     * Xử lý sự kiện nhấn chọn Người dùng
     * @param {} e 
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.ChooseUserOnclick = function (e) {
        CSMF0002.ClearMessageBox();

        CSMF0002.ClearRows();
        CSMF0002.CurrentChoose = CSMF0002.USER_CHOOSING;

        var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
        var dataSource = grid.dataSource._data;


        var userList = "";
        for (var i = 0; i < dataSource.length; i++) {
            if (i > 0)
                userList += ",";
            if (typeof (dataSource[i].UserID) != "undefined")
                userList += dataSource[i].UserID + ",";
        }

        var urlChoose = "/PopupSelectData/Index/CSM/CSMF0003?ScreenID=CSMF0002&UserList=" + userList + "&type=1";
        ASOFT.form.clearMessageBox();
        ASOFT.asoftPopup.showIframe(urlChoose, {});
    }

    /**
     * Sự kiện nhấn nút Đóng
     * @param {} e 
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.CloseOnclick = function (e) {
        window.parent.popupClose();
    }

    /**
     * Sự kiện nhấn nút Lưu
     * @param {} e 
     * @returns {} 
     * @since [Văn Tài] Created [18/01/2018]
     */
    this.SaveOnClick = function (e) {
        CSMF0002.ClearRows();

        if (CSMF0002.IsInValid()) return;

        var data = CSMF0002.GetAllData();

        CSMF0002.SaveData(data);
    }

    // #endregion --- Events ---
}

// #region --- Global Callback ---

function receiveResult(result) {
    // Dữ liệu file đính kèm
    if (CSMF0002.CurrentChoose == CSMF0002.USER_CHOOSING) {
        var grid = $("#" + CSMF0002.GRID).data("kendoGrid");
        var dataSource = grid.dataSource;

        for (var i = 0; i < result.length; i++) {
            dataSource.insert({
                Orders: i + 1,
                UserID: result[i]["UserID"],
                UserName: result[i]["UserName"],
                Account: "",
                Password: "",
                TechnicalID: ""
            });
        };
    }
};

// #endregion --- Global Callback ---