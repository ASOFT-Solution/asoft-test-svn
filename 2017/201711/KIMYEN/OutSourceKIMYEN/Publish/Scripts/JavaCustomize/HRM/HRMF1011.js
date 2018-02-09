
//Hàm: khởi tạo các đối tượng trong javascript
$(document)
    .ready(function () {

        // #region --- Events ---

        var grid = $('#GridEditHRMT1011').data('kendoGrid');
        $(grid.tbody)
            .on("change",
                "td",
                function (e) {
                    var selectitem = grid.dataItem(grid.select());

                    var column = e.target.id;
                    if (column == 'cbbResultFormatName') {
                        var id = e.target.value;
                        var combobox = $("#cbbResultFormatName").data("kendoComboBox");
                        if (combobox) {
                            var data = combobox.dataItem();
                            selectitem.ResultFormat = combobox.dataItem().ID;
                            selectitem.ResultFormatName = combobox.dataItem().Description;
                        }
                        grid.refresh();
                    }
                });

        $(grid.tbody)
            .on("keypress",
                "td",
                function (e) {
                    var column = e.target.id;
                    if (column == 'DetailTypeID') {
                        if (e.keyCode == 32)
                            return false;
                    }
                    return true;
                });

        $("#IsCommon")
            .click(function () {
                var isCheckCM = $("#IsCommon").is(":checked");
                var dataGrid = grid.dataSource._data;
                for (var i = 0; i < dataGrid.length; i++) {
                    var item = grid.dataSource.at(i);
                    item.set("DivisionID", $("#IsCommon").is(":checked") ? "@@@" : "EnvironmentDivisionID");
                }
            });

        // #endregion --- Events ---

        // Layout control
        $(".Note").after($(".IsCommon"));
        $(".IsCommon").after($(".Disabled"));
        $("#HRMF1011 .grid_6_1.alpha").addClass("grid_12");
        $("#HRMF1011 .grid_6_1.alpha").removeClass("grid_6_1");

        // check form update
        if ($("#isUpdate").val() == "True") {
            $("#IsCommon").attr("disabled", "disabled");
        }

        // Xử lý bổ sung dòng Tất cả - combo Vị trí tuyển dụng
        settingDutyCombo();
    });

function CustomerCheck() {
    var isCheckCM = $("#IsCommon").is(":checked");
    var grid = $('#GridEditHRMT1011').data('kendoGrid');
    var grid_tr = $('#GridEditHRMT1011 .k-grid-content tr');
    var dataGrid = grid.dataSource._data;
    // Kiem tra nhap lieu
    var NoValue = false;
    var duplicate = false;
    for (var i = 0; i < dataGrid.length; i++) {
        var item = grid.dataSource._data[i];

        // Set gia tri default
        item.DivisionID = isCheckCM ? "@@@" : $("#EnvironmentDivisionID").val();
        item.DutyID = $("#DutyID").val();
        item.InterviewTypeID = $("#InterviewTypeID").val();

        if (item.ResultFormat == 0) {
            if (item.FromValue == null || item.FromValue == "") {
                $($(grid_tr[i]).children()[GetColIndex(grid, "FromValue")]).addClass('asf-focus-input-error');
                NoValue = true;
            }
            if (item.FromValue == null || item.FromValue == "") {
                $($(grid_tr[i]).children()[GetColIndex(grid, "ToValue")]).addClass('asf-focus-input-error');
                NoValue = true;
            }
        }
        for (var j = i + 1; j < dataGrid.length; j++) {
            var itemNew = grid.dataSource._data[i];
            if (itemNew.DetailTypeID == item.DetailTypeID) {
                $($(grid_tr[j]).children()[GetColIndex(grid, "DetailTypeID")]).addClass('asf-focus-input-error');
                duplicate = true;
            }
        }

    }

    if (NoValue) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage("HRMFML000015")], null);
        return true;
    }

    if (duplicate) {
        ASOFT.form.displayMessageBox('#' + $('#sysScreenID').val(), [ASOFT.helper.getMessage("HRMFML000030")], null);
        return true;
    }

    return false;
}

function GetColIndex(grid, columnName) {
    var columns = grid.columns;
    for (var i = 0; i < columns.length; i++) {
        if (columns[i].field == columnName)
            return i;
    }
    return 0;
}

/**
 * Xử lý cho combo Vị trí tuyển dụng
 * @returns {} 
 * @since [Văn Tài] Created [16/11/2017]
 */
function settingDutyCombo() {
    var dutyCombo = $("#DutyID").data("kendoComboBox");

    if (dutyCombo) {
        // Combo có dòng chọn tất cả
        var strAll = ASOFT.helper.getLanguageString("A00.All", "A00", "00");

        var data = dutyCombo.dataSource._data;
        data.unshift({ DutyID: "%", DutyName: strAll });
        dutyCombo.setDataSource(data);
    }
}