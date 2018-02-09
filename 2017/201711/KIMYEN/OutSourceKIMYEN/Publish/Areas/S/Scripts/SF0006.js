//####################################################################
//# Copyright (C) 2010-2011, ASoft JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Created           Comment
//#     21/01/2015      Mai Trí Thiện     Tạo mới
//####################################################################


//Hàm: Khởi tạo các đối tượng
$(document).ready(function () {
    //Khởi tạo lưới bên trái và lưới bên phải
    SF0006.SF0006Grid1 = $("#SF0006GridDefault").data("kendoGrid");
    SF0006.SF0006Grid2 = $("#SF0006GridAccepted").data("kendoGrid");
    //Khởi tạo defaultViewModel: Lấy data mặc định của form
    SF0006.setCurrentFormCollection();
});

var SF0006 = new function () {
    this.SF0006Grid1 = null;
    this.SF0006Grid2 = null;
    this.action = 0;
    this.ID = 'SF0006';
    this.defaultViewModel = null;
    this.KENDO_INPUT_SUFFIX = '_input';
    this.moduleID = null;
    this.isChanged = false;

    // Get form data
    this.setCurrentFormCollection = function () {
        SF0006.defaultViewModel = ASOFT.helper.dataFormToJSON(SF0006.ID);
    };

    //Hàm: Post dữ liệu từ lưới bên trái lên server
    this.sendDataPost = function () {
        var data = ASOFT.helper.dataFormToJSON(SF0006.ID);
        return data;
    };
    
    //Hàm: Bind dữ liệu từ UserID sang UserName
    this.onGroupID_Changed = function (e) {
        //Kiểm tra mã người dùng có trong danh sách hay không
        var checkIs = ASOFT.form.checkItemInListFor(this, SF0006.ID);
        if (checkIs) {
            e.sender.focus();
            //Dữ liệu đã thay đổi => thông báo lưu
            if (SF0006.isChanged) {
                ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                    SF0006.action = 1;
                    SF0006.save(true);
                    SF0006.SF0006Grid2.dataSource.read();
                    SF0006.SF0006Grid1.dataSource.read();

                }, function () {
                    //Kiểm tra mã người dùng có trong danh sách hay không
                    SF0006.SF0006Grid2.dataSource.read();
                    SF0006.SF0006Grid1.dataSource.read();
                    // Lưu lại giá trị form nếu không lưu
                    SF0006.setCurrentFormCollection();
                });

                SF0006.isChanged = false;
                return;
            }
            else {
                SF0006.SF0006Grid2.dataSource.read();
                SF0006.SF0006Grid1.dataSource.read();
            }

            SF0006.setCurrentFormCollection();
        }
    };

    this.onGroupID_Bound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
    };

    //Hàm: Thêm một phần tử sang lưới khác
    this.addItemToDataSource = function (newItem, ds) {
        ds.add($.extend({}, newItem));
    }

    //Sự kiện: Chuyển sang 1 dòng
    this.changeSingle = function () {
        var ds = SF0006.SF0006Grid1.dataSource;
        var ds2 = SF0006.SF0006Grid2.dataSource;
        SF0006.SF0006Grid1.select().each(function () {
            var _item = SF0006.SF0006Grid1.dataItem($(this));
            SF0006.addItemToDataSource(_item, ds2);
            ds.remove(_item);
            SF0006.isChanged = true;
            return;
        });
    }

    //Sự kiện: Chuyển về 1 dòng
    this.returnSingle = function () {
        var ds = SF0006.SF0006Grid1.dataSource;
        var ds2 = SF0006.SF0006Grid2.dataSource;
        SF0006.SF0006Grid2.select().each(function () {
            var _item = SF0006.SF0006Grid2.dataItem($(this));
            ds2.remove(_item);
            SF0006.addItemToDataSource(_item, ds);
            SF0006.isChanged = true;
            return;
        });
    };

    //Chuyển tất cả các dòng sang
    this.changeAll = function () {
        var data = SF0006.SF0006Grid1.dataSource.data();
        var data2 = SF0006.SF0006Grid2.dataSource.data();
        var totalNumber = data.length;
        var totalNumber2 = data2.length;
        for (var i = 0; i < totalNumber ;) {
            var currentDataItem = data[i];
            SF0006.SF0006Grid2.dataSource.add(currentDataItem);
            SF0006.SF0006Grid1.dataSource.remove(currentDataItem);
            --totalNumber;
        }
        SF0006.isChanged = true;
    };

    //Chuyển về tất cả:
    this.returnAll = function () {
        var data = SF0006.SF0006Grid1.dataSource.data();
        var data2 = SF0006.SF0006Grid2.dataSource.data();
        var totalNumber = data.length;
        var totalNumber2 = data2.length;
        for (var i = 0; i < totalNumber2 ;) {
            var currentDataItem = data2[i];
            SF0006.SF0006Grid1.dataSource.add(currentDataItem);
            SF0006.SF0006Grid2.dataSource.remove(currentDataItem);
            --totalNumber2;
        }
        SF0006.isChanged = true;
    }

    //Hàm: Lưu thành công
    this.saveSuccess = function (result) {
        if (result.Status == 0) //Insert: true
        {
            SF0006.setCurrentFormCollection();
            //SF0006.defaultViewModel = ASOFT.helper.dataFormToJSON(SF0006.ID);
            switch (SF0006.action) {
                case 1://save new
                    ASOFT.form.displayInfo('#' + SF0006.ID, ASOFT.helper.getMessage(result.Message));
                    // Lưu lại giá tri form sau khi lưu thành công
                    SF0006.setCurrentFormCollection();
                    SF0006.isChanged = false;
                //default:
                    //ASOFT.asoftPopup.closeOnly();
            }
        }
        else {
            var msg = ASOFT.helper.getMessage(result.Message);
            if (result.Data) {
                msg = kendo.format(msg, result.Data);
            }
            ASOFT.form.displayWarning('#' + SF0006.ID, msg);
        }
    };

    //Hàm: checkDataSave
    this.checkDataSave = function () {
        if (SF0006.formIsInvalid()) {
            return;
        }
        return SF0006.save();
    };

    //Hàm: formIsInvalid
    this.formIsInvalid = function () {
        return ASOFT.form.checkRequiredAndInList(SF0006.ID, ['ModuleID', 'GroupID']);
    };

    //Sự kiện; Lưu
    this.save_Click = function () {
        SF0006.action = 1;
        SF0006.checkDataSave();
    };

    //Hàm: Insert
    this.save = function (isPass) {
        var data = isPass ? SF0006.defaultViewModel : ASOFT.helper.dataFormToJSON(SF0006.ID);

        var url = $('#UrlSave').val();
        data.List2 = SF0006.SF0006Grid2.dataSource.data();
        ASOFT.helper.postTypeJson(url, data, SF0006.saveSuccess);
    }

    //Sự kiện: Đóng popup
    this.close_Click = function (event) {
        if (/*SF0006.isDataChanged()*/ SF0006.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                function () {
                    SF0006.SF0006Save_Click();
                },
                function () {
                    ASOFT.asoftPopup.closeOnly();
                });
        }
        else {
            ASOFT.asoftPopup.closeOnly();
        }
    };

    // Kiểm tra dữ liệu trên form có bị thay đổi hay không: Kiểm tra dữ liệu tại form hiện tại vs dữ liệu form khởi tạo
    this.isDataChanged = function () {
        var dataPost = ASOFT.helper.dataFormToJSON(SF0006.ID);
        var equal = SF0006.isRelativeEqual(dataPost, SF0006.defaultViewModel);
        return !equal;
    };

    // Kiểm tra bằng nhau giữa hai trạng thái của form
    this.isRelativeEqual = function (data1, data2) {
        if (data1 && data2
            && typeof data1 === "object"
            && typeof data2 === "object") {
            for (var prop in data1) {
                // So sánh thuộc tính của 2 data
                if (!data2.hasOwnProperty(prop)) {
                    return false;
                }
                else {
                    if (prop.indexOf(SF0006.KENDO_INPUT_SUFFIX) != -1) {
                        continue;
                    }
                    // Nếu giá trị hai thuộc tính không bằng nhau, thì data có khác biệt
                    if (data1[prop].valueOf() != data2[prop].valueOf()) {
                        return false;
                    }
                }
            }
            return true;
        }
        return undefined;
    };

    //ComboBox module data bound 
    this.onModuleID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;

        //Khởi tạo các giá trị mặc định
        SF0006.moduleID = dataItem.ModuleID;
        $(this.element).attr('initValue', SF0006.moduleID);
    }

    //ComboBox module id changed
    this.onModuleID_Changed = function (e) {
        ASOFT.form.checkItemInListFor(this, 'SF0006');
        var combo = this;
        var dataItem = combo.dataItem(combo.selectedIndex);

        if (!dataItem || dataItem == null) return;
        
        //Dữ liệu đã thay đổi => thông báo lưu
        if (SF0006.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                SF0006.action = 1;
                SF0006.save(true);
                SF0006.SF0006Grid2.dataSource.read();
                SF0006.SF0006Grid1.dataSource.read();

            }, function () {
                //Kiểm tra mã người dùng có trong danh sách hay không
                SF0006.SF0006Grid2.dataSource.read();
                SF0006.SF0006Grid1.dataSource.read();
                // Lưu lại giá trị form nếu không lưu
                SF0006.setCurrentFormCollection();
            });

            SF0006.isChanged = false;
            return;
        }
        else {
            SF0006.SF0006Grid2.dataSource.read();
            SF0006.SF0006Grid1.dataSource.read();
        }
    }
};

