// Document ready
$(document).ready(function() {
    MTF0090.MTF0090Popup = ASOFT.asoftPopup.castName("MTF0090Popup");

    if (MTF0090.MTF0090Popup) {
        MTF0090.MTF0090Popup.bind('refresh', function () {//Event popup loaded
            MTF0090.MTF0090Grid = ASOFT.asoftGrid.castName("MTF0090Grid");
            MTF0090.GridCurrentClass = ASOFT.asoftGrid.castName("MTF0090GridCurClass");
            MTF0090.GridSelectedClass = ASOFT.asoftGrid.castName("MTF0090GridSelectedClass");

            //Set title for popup
            var title = '';
            title = $("#mtf0090Title").val();
            MTF0090.MTF0090Popup.title(title);

            //Lưới phân quyền chức năng bind dữ liệu
            if (MTF0090.MTF0090Grid) {
                MTF0090.MTF0090Grid.bind('dataBound', function () {
                    MTF0090.rowNumber = 0;
                });
            }

            //Lưới danh sách lớp hiện tại bind dữ liệu   
            if (MTF0090.GridCurrentClass) {
                MTF0090.GridCurrentClass.bind('dataBound', function () {
                    MTF0090.rowNumber = 0;
                });
            }

            //Lưới danh sách lớp theo user bind dữ liệu
            if (MTF0090.GridSelectedClass) {
                MTF0090.GridSelectedClass.bind('dataBound', function () {
                    MTF0090.rowNumber = 0;
                });
            }
        });
    }
});

var MTF0090 = new function () {
    this.MTF0090Popup = null;
    this.MTF0090Grid = null;
    this.GridCurrentClass = null;
    this.GridSelectedClass = null;
    this.dataMTF0090Grid = null;
    this.comboBoxTeacherID = null;
    this.teacherID = null;
    this.rowNumber = 0;
    this.isBindData = false;
    this.invalidUserID = false;
    this.isChanged = false;
    this.preUserID = null;

    this.renderNumber = function () {
        return ++this.rowNumber;
    };
    
    //Xóa dòng trên lưới
    this.deleteDetail = function (e) {
        row = $(e).parent();
        if (MTF0090.MTF0090Grid.dataSource.data().length == 1) {//Xét rỗng dòng hiện tại nếu lưới còn 1 dòng
            var data = MTF0090.MTF0090Grid.dataSource.data();
            var row = MTF0090.MTF0090Grid.dataSource.data()[0];
            row.set('GroupID', null);
            row.set('IsStudentInfo', false);
            row.set('IsStudentResult', false);
            row.set('IsStudyInfo', false);
            row.set('IsExamResult', false);
            return;
        }

        ASOFT.asoftGrid.removeEditRow(row, MTF0090.MTF0090Grid, null);
    }

    //Bắt từ ngày < đến ngày
    this.DateEdit_Changed = function (e) {
        var data = MTF0090.MTF0090Grid.dataSource.data();
        var columns = MTF0090.MTF0090Grid.columns;
        var row = data[ASOFT.asoftGrid.currentRow];
        if (row.FromDate > row.ToDate) {
            if (row.FromDate != null && row.ToDate != null) {
                msg = ASOFT.helper.getMessage('HFML000290');
                ASOFT.form.displayError('#MTF0090', msg);
                $(this.element).focus();
                $(this.element).addClass('asf-focus-input-error');
                return;
            }
        }
        else {
            ASOFT.form.clearMessageBox();
        }
    }

    this.btnSave_Click = function (e) {
        //if (ASOFT.form.checkRequired("MTF0090")) {//Check required
        //    return;
        //}

        //Get data
        var data = ASOFT.helper.dataFormToJSON(null, 'List', MTF0090.MTF0090Grid);
        var url = $('#URLInsert').val();

        $('#MTF0090Grid').removeClass('asf-focus-input-error');
        ASOFT.asoftGrid.editGridRemmoveValidate(MTF0090.MTF0090Grid);
        if (MTF0090.MTF0090Grid.dataSource.data().length == 1) {
            var ds = MTF0090.MTF0090Grid.dataSource.data()[0];
            if (ds.GroupID != null) {//validate khi tất cả các dòng != null
                if (ASOFT.asoftGrid.editGridValidate(MTF0090.MTF0090Grid)) {
                    msg = ASOFT.helper.getMessage('MTFML000012');
                    ASOFT.form.displayError('#MTF0090', msg);
                    return;
                }
            }
            else {
                data.List = null;
            }
        }
        else if (MTF0090.MTF0090Grid.dataSource.data().length > 1) {
            if (ASOFT.asoftGrid.editGridValidate(MTF0090.MTF0090Grid)) {
                msg = ASOFT.helper.getMessage('MTFML000012');
                ASOFT.form.displayError('#MTF0090', msg);
                return;
            }
            
            //Kiểm tra trùng groupID
            if (MTF0090.invalidUserID) {
                var ds = MTF0090.MTF0090Grid.dataSource.data();
                var groupIDList = MTF0090.groupBy_DataSource(ds, 'GroupID');
                var result = true;

                //Check ClassID
                $.each(groupIDList, function () {
                    if (this.length > 1) {
                        msg = ASOFT.helper.getMessage('MTFML000014');
                        ASOFT.form.displayError('#MTF0090', msg);
                        MTF0090.invalidGroup = true;
                        result = false;
                        return result;
                    }
                })

                if (!result) return;//Không cho lưu
            }
        }

        ASOFT.helper.postTypeJson(url, data, MTF0090.mtf0090SaveSuccess);
    }

    this.mtf0090SaveSuccess = function (result) {
        // Update status
        ASOFT.form.updateSaveStatus('MTF0090', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'MTF0090', function () {
            msg = ASOFT.helper.getMessage('MTFML000013');
            MTF0090.rowNumber = 0;
            buttonConfig = $('#btnSave').data('kendoButton');
            //buttonConfig.enable(false);
            //MTF0090.MTF0010Popup.close();
        }, null, null, true);
    }

    //Đóng popup
    this.btnClose_Click = function () {
        MTF0090.rowNumber = 0;
        MTF0090.MTF0090Popup.close();
    }

    //Check 
    this.check_GroupID = function (data, obj) {
        MTF0090.invalidUserID = false;
        var classIDList = MTF0090.groupBy_DataSource(data, 'GroupID');

        if (classIDList[obj.value()].length > 1) {
            msg = ASOFT.helper.getMessage('MTFML000014');
            ASOFT.form.displayError('#MTF0090', msg);
            $(obj.element).parent().addClass('asf-focus-input-error');
            $(obj.element).focus();
            MTF0090.invalidUserID = true;
            return;
        }
        else {
            ASOFT.form.clearMessageBox();
        }
    }

    //Group data source => GroupID
    this.groupBy_DataSource = function (data, field) {
        var groupIDList = {};
        var temp = null;
        for (var i = 0; i < data.length; i++) {
            temp = data[i][field];
            if (typeof groupIDList[temp] === 'undefined') {
                groupIDList[temp] = [];
            }
            groupIDList[temp].push(i);
        }
        return groupIDList;
    }

    //Get Value from checkbox
    this.checkBox_Changed = function (tag) {
        var row = $(tag).parent().closest('tr');
        var currentRecord = ASOFT.asoftGrid.selectedRecord(MTF0090.MTF0090Grid);
        currentRecord[tag.id] = $(tag).prop('checked') ? true : false;
    }

    //Phân quyền giáo viên theo lớp 
    //[Đức Quý] Tạo mới [02/03/2015]
    this.addClass = function () {
        ASOFT.form.clearMessageBox();
        record = ASOFT.asoftGrid.selectedRecord(MTF0090.GridCurrentClass, 'MTF0100');

        //Trả về cảnh báo khi chưa chọn dòng
        if (!record || record == null) return;

        MTF0090.addOneRow(record, MTF0090.GridCurrentClass, MTF0090.GridSelectedClass);

        //Chọn dòng đầu tiên
        MTF0090.GridCurrentClass.focus(0);
        MTF0090.GridSelectedClass.focus(0);

        //Bật cờ hỏi lưu khi thay đổi User
        MTF0090.isChanged = true;
    }

    //Bỏ 1 lớp của user được xem
    this.removeClass = function () {
        ASOFT.form.clearMessageBox();
        record = ASOFT.asoftGrid.selectedRecord(MTF0090.GridSelectedClass, 'MTF0100');

        //Trả về cảnh báo khi chưa chọn dòng
        if (!record || record == null) return;

        MTF0090.addOneRow(record, MTF0090.GridSelectedClass, MTF0090.GridCurrentClass);

        //Chọn dòng đầu tiên
        MTF0090.GridCurrentClass.focus(0);
        MTF0090.GridSelectedClass.focus(0);

        //Bật cờ hỏi lưu khi thay đổi User
        MTF0090.isChanged = true;
    }

    //Thêm tất cả lớp từ lưới lớp hiện tại => lưới lớp theo user
    this.addAllClass = function () {
        var dataSource = MTF0090.GridCurrentClass.dataSource.data();
        for (var i = dataSource.length - 1; i >= 0; i--) {
            MTF0090.GridSelectedClass.dataSource.add(dataSource[i]);
            MTF0090.GridCurrentClass.dataSource.remove(dataSource[i]);
        }

        //Chọn dòng đầu tiên
        MTF0090.GridSelectedClass.focus(0);

        //Bật cờ hỏi lưu khi thay đổi User
        MTF0090.isChanged = true;
    }

    //Bỏ tất cả lớp từ lưới lớp theo user => lưới lớp hiện tại
    this.removeAllClass = function () {
        var dataSource = MTF0090.GridSelectedClass.dataSource.data();
        for (var i = dataSource.length - 1; i >= 0; i--) {
            MTF0090.GridCurrentClass.dataSource.add(dataSource[i]);
            MTF0090.GridSelectedClass.dataSource.remove(dataSource[i]);
        }

        //Chọn dòng đầu tiên
        MTF0090.GridCurrentClass.focus(0);

        //Bật cờ hỏi lưu khi thay đổi User
        MTF0090.isChanged = true;
    }

    this.addOneRow = function (record, destGrid, srcGrid) {
        srcGrid.dataSource.add(record);
        destGrid.dataSource.remove(record);
    }

    this.userID_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'MTF0100');
        var userID = this.value();

        //Hỏi lưu dữ liệu khi người dùng đã thay đổi dữ liệu
        if (MTF0090.isChanged) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'), function () {
                MTF0090.btnSaveMTT0100_Click(MTF0090.preUserID);

                //Load lại dữ liệu cho 2 lưới
                MTF0090.GridCurrentClass.dataSource.read({ userID: userID });
                MTF0090.GridSelectedClass.dataSource.read({ userID: userID });
            }, function () {

                //Load lại dữ liệu cho 2 lưới
                MTF0090.GridCurrentClass.dataSource.read({ userID: userID });
                MTF0090.GridSelectedClass.dataSource.read({ userID: userID });
            });
            MTF0090.isChanged = false;
            return;
        }

        //Load lại dữ liệu cho 2 lưới
        MTF0090.GridCurrentClass.dataSource.read({ userID: this.value() });
        MTF0090.GridSelectedClass.dataSource.read({ userID: this.value() });

        //Lưu giá trị trước khi thay đổi
        MTF0090.preUserID = userID;
    }

    this.userID_DataBound = function (e) {
        ASOFT.asoftComboBox.dataBound(e);
        var dataItem = this.dataItem(this.selectedIndex);

        if (!dataItem || dataItem == null) return;

        MTF0090.GridCurrentClass.dataSource.read({ userID: dataItem.UserID });
        MTF0090.GridSelectedClass.dataSource.read({ userID: dataItem.UserID });
    }

    //Save config class for user
    this.btnSaveMTT0100_Click = function (userID) {
        if (ASOFT.form.checkRequiredAndInList('MTF0090', ['UserID'])) {
            return;
        }

        var url = $('#URLSaveMTT0100').val();
        var data = ASOFT.helper.dataFormToJSON('MTF0090', 'ClassList', MTF0090.GridSelectedClass);

        if (typeof userID === 'string') {
            data.UserID = userID;
        }

        ASOFT.helper.postTypeJson(url, data, MTF0090.saveMTT0100Success);
        return 1;
    }

    this.saveMTT0100Success = function (result) {
        // Update status
        ASOFT.form.updateSaveStatus('MTF0090', result.Status, result.Data);
        ASOFT.helper.showErrorSeverOption(0, result, 'MTF0090', function () {
        }, null, null, true);
    }
}

//Event change combobox GroupID
function groupID_Changed()
{
    var value = this.value();
    MTF0090.invalidUserID = false;
    ASOFT.asoftGrid.setValueTextbox(//fix trường hợp  [object object]
        "MTF0090Grid",
        MTF0090.MTF0090Grid,
        ASOFT.asoftGrid.currentCell,
        ASOFT.asoftGrid.currentRow
    );

    var data = MTF0090.MTF0090Grid.dataSource.data();
    MTF0090.check_GroupID(data, this);
}
