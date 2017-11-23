//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     07/04/2014      Chánh Thi        Tạo mới
//####################################################################

var ID = 'POSF00101';
var defaultViewModel = null;
var isCAFE = null;
var idAdd = null;

var imageLogo = null; // imageLogo
var shopID = null;
var shopName = null;
var rowNumber = 0;
var posGrid = null;
var example = null;
var warehouseName = null;
var helper = null;
var comboBoxIDs = [
      'VoucherType01',
   'VoucherType02',
   'VoucherType03',
   //'VoucherType04',
   'VoucherType05',
   'VoucherType06',
   'VoucherType07',
   'VoucherType08',
   'VoucherType09',
   'VoucherType10',
   'VoucherType11',
   'VoucherType12',
   'VoucherType13'
];


var comboboxPriceTable = null;
$(document).ready(function () {
    imageLogo = $("#ImageLogo").val();

    $("#ObjectID").val($('#ShopID').val());
    $("#ObjectName").val($('#ShopName').val());


    $("#BusinessArea").data("kendoComboBox").readonly(true);
    if ($("#IsUpdate").val() == "1") {
        isCAFE = parent.getIsCAFE();
    }
    else
        isCAFE = $("#IsCAFE").val() == "True";

    helper = ASOFTVIEW.helpers;

    $("#upload").change(function () {
        readURL(this);
    });

    // Thay đổi trạng thái của các textbox bằng checkbox
    refreshDefaultViewModel();
    shopID = $("#ShopID").val();
    shopName = $("#ShopName").val();
    warehouseName = $("#WareHouseID").val();
    posGrid = $("#POSF00101Grid").data("kendoGrid");

    posGrid.bind("dataBound", function (e) {
        rowNumber = 0;
    });

    var cb = $('#PromoteID').data('kendoComboBox');
    $('#IsPromote').bind('change', function (e) {
        cb.enable($(this).prop('checked'));
    }).trigger('change');

    var cb2 = $('#PriceValue').data('kendoComboBox');
    $('#IsTable').bind('change', function (e) {
        cb2.enable($(this).prop('checked'));
    });

    var cbPromoteIDCA = $('#PromoteIDCA').data('kendoComboBox');
    $('#IsUsedCA').bind('change', function (e) {
        cbPromoteIDCA.enable($(this).prop('checked'));
    }).trigger("change");

    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) 
    if (isCAFE) {
        var cb3 = $('#PromoteID1').data('kendoComboBox');
        $('#IsPromote1').bind('change', function (e) {
            cb3.enable($(this).prop('checked'));
        });
    }
    //var nz1Dropdown = $("#InventoryTypeID").data("kendoDropDownList");
    //updateDropDown(nz1Dropdown, true);

    var firstBound = true;

    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) 
    if (isCAFE) {
        var nz1 = $('#InventoryTypeID').data('kendoDropDownList');
        var nz2 = $('#InventoryTypeID1').data('kendoComboBox');
        var nz3 = $('#InventoryTypeID2').data('kendoComboBox');

        var nt = $('#PromoteID').data('kendoComboBox');
        if (nt) {
            nt.dataSource.read();
            nt.bind('dataBound', function (e) {
                if (!firstBound) {
                    return;
                }
                firstBound = false;
                var i = 0, item, backup = [];

                while (item = (nt.dataSource.at(i++))) {
                    backup.push(item);
                }
                nz1.bind('change', comboboxChangeInventory);
                nz2.bind('change', comboboxChangeInventory);
                nz3.bind('change', comboboxChangeInventory);

                function comboboxChangeInventory(e) {
                    while (nt.dataSource.data().length > 0) {
                        nt.dataSource.remove(nt.dataSource.at(0));
                    }
                    i = 0;
                    var ids = nz1.value();
                    var arryIds = ids.split(',');
                    while (item = backup[i++]) {
                        if ($.inArray(item.InventoryTypeID, arryIds) ||
                            item.InventoryTypeID === nz2.dataItem().InventoryTypeID1 ||
                            item.InventoryTypeID === nz3.dataItem().InventoryTypeID2 ||
                            item.InventoryTypeID === '%') {
                            nt.dataSource.add(item);
                        }
                    }
                }

                nz1.trigger('change');
                nz2.trigger('change');
                nz3.trigger('change');

            });
        }
    } else {
        var nz1 = $('#InventoryTypeID').data('kendoDropDownList');

        var nt = $('#PromoteID').data('kendoComboBox');
        if(nt){
            nt.dataSource.read();
        nt.bind('dataBound', function (e) {

            if (!firstBound) {
                return;
            }
            firstBound = false;
            var i = 0, item, backup = [];

            while (item = (nt.dataSource.at(i++))) {
                backup.push(item);
            }
            if (nz1) {
                function comboboxChangeInventory(e) {
                    while (nt.dataSource.data().length > 0) {
                        nt.dataSource.remove(nt.dataSource.at(0));
                    }
                    i = 0;
                    var ids = nz1.value();
                    var arryIds = ids.split(',');
                    while (item = backup[i++]) {
                        if ($.inArray(item.InventoryTypeID, arryIds) ||
                            item.InventoryTypeID === '%') {
                            nt.dataSource.add(item);
                        }
                    }
                }
                nz1.bind('change', comboboxChangeInventory);

                nz1.trigger('change');
            }
        });
        }
    }
    var upload = $("#upload").data("kendoUpload");
    //var combobox = $("#PromoteID").data("kendoComboBox");
    //combobox.enable(false);

    // Thay doi trang thai khi nhap shop ID ben danh muc chung
    $('#ShopID').focusout(function () {
        var result = $(this).val();
        shopID = result;
        $("#ObjectID").val(result);
    });
    $('#ShopName').focusout(function () {
        var result = $(this).val();
        $("#ObjectName").val(result);
        shopName = result;
    });



    //$('#IsDiscount').change(function () {
    //    combobox.enable(true);
    //});
    //$('#IsAutomatic').change(function () {
    //    // Thay đổi trạng thái khi check
    //    if ($(this).is(':checked')) {
    //        $('#Separator').removeAttr('disabled');
    //        $('#Length').removeAttr('disabled');
    //        $('#NNNS').removeAttr('disabled');
    //        $('#AutoIndex').removeAttr('disabled');
    //    }
    //    else {
    //        $('#Separator').attr('disabled', 'disabled');
    //        $('#Length').attr('disabled', 'disabled');
    //        $('#NNNS').attr('disabled', 'disabled');
    //        $('#AutoIndex').attr('disabled', 'disabled');
    //    }
    //});

    //$('#AutoIndex').change(function () {
    //    // Thay đổi trạng thái khi check
    //    if ($(this).is(':checked')) {
    //        $('#AutoIndexValue').removeAttr('disabled');
    //    }
    //    else {
    //        $('#AutoIndexValue').attr('disabled', 'disabled');
    //    }
    //});
    //// Thay đổi S2
    //$('#IsS2').change(function () {
    //    // Thay đổi trạng thái khi check
    //    if ($(this).is(':checked')) {
    //        $('#S2').removeAttr('disabled');
    //    }
    //    else {
    //        $('#S2').attr('disabled', 'disabled');
    //    }
    //});

    //// Thay đổi S3
    //$('#IsS3').change(function () {
    //    // Thay đổi trạng thái khi check
    //    if ($(this).is(':checked')) {
    //        $('#S3').removeAttr('disabled');
    //    }
    //    else {
    //        $('#S3').attr('disabled', 'disabled');
    //    }
    //});


    //// Thay doi trang thai khi nhap shop ID ben danh muc chung
    //$('#ShopID').focusout(function () {
    //    var result = $(this).val();
    //    $('#S1').val(result);
    //});

    //var chuoiS1 = null;
    //var chuoiS2 = null;
    //$('#S2').focusout(function () {
    //    chuoiS1 = $('#S1').val();
    //    chuoiS2 = $(this).val();
    //});

    //var chuoiS3 = null;
    //$('#S3').focusout(function () {
    //    //$('#Example').html(''+chuoiS1 + '-' + chuoiS2 + '-' + $(this).val());

    //    chuoiS3 = $(this).val();
    //});

    //var NNNS = null;
    //$('#NNNS').focusout(function () {
    //    var comboboxValue = $(this).val();      

    //    if (comboboxValue === 'NSSS') {
    //        NNNS = 0;
    //    }
    //    if (comboboxValue === 'SNSS') {
    //        NNNS = 1;
    //    }
    //    if (comboboxValue === 'SSNS') {
    //        NNNS = 2;
    //    }
    //    if (comboboxValue === 'SSSN') {
    //        NNNS = 3;
    //    }

    //});

    //var separator = null;
    //$('#Separator').focusout(function () {
    //    separator = $(this).val();
    //});

    //var length = null;
    //$('#Length').focusout(function () {
    //    length = $(this).val();
    //});

    //var num = null;
    //var stt = null;
    //var length1 = null;
    //var length2 = null;
    //var length3 = null;
    //var lengthseparator = null;
    //$('#AutoIndexValue').focusout(function () {
    //    num = $(this).val();
    //    length = parseInt(length);
    //    length1 = chuoiS1.length;
    //    length2 = chuoiS2.length;
    //    length3 = chuoiS3.length;
    //    lengthseparator = separator.length;
    //    stt = length - (length1 + lengthseparator * 3 + length2 + length3);
    //    var s = "000000000" + num;
    //    var sothutu = s.substr(s.length - stt);
    //    // Neu Output order bang NSSS
    //    if (NNNS === 0) {

    //        $('#Example').html(sothutu + separator + chuoiS1 + separator + chuoiS2 + separator + chuoiS3);

    //    }

    //    if (NNNS === 1) {

    //        $('#Example').html(chuoiS1 + separator + sothutu + separator + chuoiS2 + separator + chuoiS3);

    //    }

    //    if (NNNS === 2) {

    //        $('#Example').html(chuoiS1 + separator + chuoiS2 + separator + sothutu + separator + chuoiS3);

    //    }

    //    if (NNNS === 3) {

    //        $('#Example').html(chuoiS1 + separator + chuoiS2 + separator + chuoiS3 + separator + sothutu);

    //    }
    //});

    var combobox = $("#DivisionID").data("kendoComboBox");
    combobox.select(0);

    $('#POSF00101Grid').on('click', '.chkbx', function () {
        var checked = $(this).is(':checked');
        var grid = $('#POSF00101Grid').data().kendoGrid;
        var dataItem = grid.dataItem($(this).closest('tr'));
        if (checked) {
            dataItem.set('Selected', 1);
        } else {
            dataItem.set('Selected', 0);
        }

    });

    //var comboboxPromoteID = $("#PromoteID").data("kendoComboBox");

    //$("#IsDiscount").click(function () {
    //    comboboxPromoteID.enable();
    //});
    //this.divisionID_Change(e);
});

function POSF0002Save(event) {
    //parent.popupClose();
    ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('AFML000006'), popupClose, popupClose);
}

// Đóng popup
function popupClose1(event) {
    var btnCloseNew = $('#BtnCloseNew');
    var btnCloseUpdate = $('#BtnCloseUpdate');
    var elementClicked = event.sender.element;
    var url = '';

    if (elementClicked.attr('id') == 'BtnCloseUpdate') {
        url = "/POS/POSF0010/Update";
    } else {
        url = "/POS/POSF0010/Insert";
    }

    if (isDataChanged()) {
        ASOFT.dialog.confirmDialog(
            AsoftMessage['00ML000016'],
            function () {
                if (formIsInvalid()) {
                    return;
                }
                ASOFT.helper.postTypeJson(
                    url,
                    getFormData(),
                    function (result) {
                        console.log(result);
                        // Nếu không có lỗi
                        if (result.Status === 0) {
                            // Thông báo msg: 'Bạn đã lưu thành công !'
                            ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message).format(result.Data).format(result.Data));
                            window.parent.refreshGrid();
                            refreshDefaultViewModel();
                            parent.popupClose1();
                            // Nếu có lỗi 
                        } else {
                            // Thông báo msg: 'Không được phép sửa vì dữ liệu đã bị thay đổi'
                            // Hoặc           'Không cho phép sửa vì dữ liệu đã bị xóa'
                            if (result.Message == "00ML000105") {
                                var msg = ASOFT.helper.getMessage(result.Message);
                                if (result.Data.sysPackageName == null) {
                                    result.Data.sysPackageName = "";
                                }
                                msg = kendo.format(msg, result.Data.sysPackageName, result.Data.ShopNo);
                                ASOFT.form.displayWarning('#POSF00101', msg);
                            }
                            else {
                                ASOFT.form.displayWarning('#' + ID, ASOFT.helper.getMessage(result.Message).format(result.Data).format(result.Data));
                            }
                        }
                    }
              );
            },
            function () {
                parent.popupClose1();
            });
    }
    else {
        if (parent.popupClose1
               && typeof (parent.popupClose1) === "function") {
            parent.popupClose1();
        }
    }
}


/**
* Send data to with grid
*/
function SendDataMaster() {
    var data = {};
    data.ShopID = $("#ShopID").val();
    return data;
}

/*
* rendernumber
*/
function renderNumber(data) {
    return ++rowNumber;
}

function popupCloseClick(e) {
    parent.popupClose1(e);
}

// Lưu mới 
function popupSaveNew(e) {
    saveActionType = 1;
    saveData();
}

function SaveClose() {
    saveActionType = 3;
    saveData();
}

// Lưu copy
function popupSaveCopy(e) {
    saveActionType = 2;
    saveData();
}

// Hiển Thị ObjectName theo ObjectID
function objectID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.ObjectName;
    $('#ObjectName').val(typeid);
}

function warehouseID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.WareHouseName;
    warehouseName = typeid;
    $('#WareHouseName').val(typeid);
}

function comWarehouseID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.WareHouseName;
    warehouseName = typeid;
    $('#ComWarehouseName').val(typeid);
}


// Hiển Thị ShopName theo ShopID
function shopID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.AnaName;
    shopName = typeid;
    $('#ShopName').val(typeid);
}

// Hiển Thị DivisionName theo DivisionID
function divisionID_Change(e) {
    ASOFT.asoftComboBox.dataBound(e);
    var item = this.dataItem(this.selectedIndex);
    if (item == null) {
        return;
    }
    var typeid = item.DivisionName;
    $('#DivisionName').val(typeid);
}

// Lưu dữ liệu
function saveData() {
    if (ASOFT.form.checkRequired('POSF00101')) {
        return;
    }
    if (formIsInvalid()) {
        return;
    }
    // Lấy dữ liệu trên form
    var data = getFormData();
    var isSelected = false;
    for (var i = 0; i < data.DetailList.length; i++) {
        if (data.DetailList[i].Selected == 1) {
            isSelected = true;
            break;
        }
    }

    if (!isSelected) {
        $("#POSF00101Grid").addClass('asf-focus-input-error');
        var message = ASOFT.helper.getMessage('POSFML000067');
        ASOFT.form.displayError("#POSF00101", message);
        return;
    }

    urlUpdate = $('#UrlInsert').val();
    // Post data
    ASOFT.helper.postTypeJson(urlUpdate, data, SaveSuccess);
}

// Read form data
function getFormData() {
    //Lấy dữ liệu từ form post lên
    var data = ASOFT.helper.dataFormToJSON("POSF00101");
    data.Disabled = ($("#Disabled").is(":checked"));
    data.IsColumn = ($("#IsColumn").is(":checked"));
    data.IsUsedCA = ($("#IsUsedCA").is(":checked"));
    data.IsTable = ($("#IsTable").is(":checked"));
    data.IsDiscount = ($("#IsDiscount").is(":checked"));
    data.IsChooseTableType = ($("#IsChooseTableType").is(":checked"));
    data.ShopID = data.ShopID_input; // trường hợp ban đầu lưu insert.
    //data.Selected = ($("#Selected").attr("checked") == 'checked');
    //data.IsS1 = ($("#IsS1").attr("checked") == 'checked');
    //data.IsS2 = ($("#IsS2").attr("checked") == 'checked');
    //data.IsS3 = ($("#IsS3").attr("checked") == 'checked');
    //data.IsAutomatic = ($("#IsAutomatic").attr("checked") == 'checked');
    //data.AutoIndex = ($("#AutoIndex").attr("checked") == 'checked');
    //if (data.ImageLogo == null) {
    data.ImageLogo = imageLogo;
    //}
    data.DetailList = posGrid.dataSource.data();
    data['ShopName'] = shopName;
    data['WareHouseName'] = data['WareHouseID_input'];
    data['ComWarehouseName'] = data['ComWarehouseID_input'];
    data['ShopID'] = $('#ShopID').val();
    data['IsChooseTableType'] = $('input[name=IsChooseTableType]:checked').val();
    data.IsPromote = ($("#IsPromote").attr("checked") == 'checked');
    data.IsPromote1 = ($("#IsPromote1").attr("checked") == 'checked');
    return data;
}

function onSuccess(e) {

    var data = {

        'ImageLogo': e.response.ImageLogo

    }

    imageLogo = data['ImageLogo'];


    return imageLogo;
}

function onSelect(e) {

    var data = {

        'ImageLogo': e.response.ImageLogo

    }

    imageLogo = data['ImageLogo'];


    return imageLogo;
}

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#image').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }

    //$("#upload").change(function () {
    //    readURL(this);
    //});
}




//Kết quả trả về
function SaveSuccess(result) {

    if (result.Status == 0) {
        // Chuyển hướng xử lý nghiệp vụ
        switch (saveActionType) {
            case 1: // Trường hợp lưu & nhập tiếp
                formStatus = 1;
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message).format(result.Data))
                parent.refreshGrid();
                clearFormPOSF00101();
                //posGrid.dataSource.read();
                //posGrid.refreshGrid();
                posGrid.dataSource.fetch();
                if (result.Data == 1) {
                    //parent.reloadWindow();
                    if (window != window.parent) {
                        window.parent.location.reload();
                    } else {
                        window.location.reload();
                    }
                }
                break;
            case 2: // Trường hợp lưu & sao chép
                formStatus = 1;
                var data = {
                    'ShopID': result.Params,
                    'FormStatus': formStatus
                };
                //ASOFT.asoftPopup.hideIframe();
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message).format(result.Params));
                parent.refreshGrid();
                posGrid.dataSource.read();
                if (result.Data == 1) {
                    //parent.reloadWindow();
                    if (window != window.parent) {
                        window.parent.location.reload();
                    } else {
                        window.location.reload();
                    }
                }
                //ASOFT.asoftPopup.showIframe('/POS/POSF0010/POSF00101?FormStatus={0}&ShopID={1}'.format(formStatus, result.Data), data);
                break;
            case 3: // Trường hợp lưu và đóng
                formStatus = 1;
                ASOFT.form.displayInfo('#' + ID, ASOFT.helper.getMessage(result.Message).format(result.Data.TypesSelected));
                afterSaveHandler(result);
                parent.refreshGrid();
                posGrid.dataSource.read();
                if (result.Data.flag == 1) {
                    //parent.reloadWindow();
                    if (window != window.parent) {
                        window.parent.location.reload();
                    } else {
                        window.location.reload();
                    }
                }
                break;
            default:
                break;
        }

    } else {
        //ASOFT.helper.showErrorSever(result.Data.TypesSelected, "POSF00101");
        afterSaveHandler(result);
    }
}

//Resert form MTF1010
function clearFormPOSF00101() {
    //$('#POSF00101 input[type="text"], textarea').val('');
    var comboboxShopID = $("#ShopID");
    comboboxShopID.val('');
    //var comboboxObjectID = $("#ObjectID").data("kendoComboBox");
    //comboboxObjectID.value('');
    var comboboxTaxDebitAccountID = $("#TaxDebitAccountID").data("kendoComboBox");
    comboboxTaxDebitAccountID.value('');
    var comboboxTaxCreditAccountID = $("#TaxCreditAccountID").data("kendoComboBox");
    comboboxTaxCreditAccountID.value('');
    var comboboxDebitAccountID = $("#DebitAccountID").data("kendoComboBox");
    comboboxDebitAccountID.value('');
    var comboboxCreditAccountID = $("#CreditAccountID").data("kendoComboBox");
    comboboxCreditAccountID.value('');
    $('#ShopName').val('');
    $('#ObjectName').val('');
    $('#ObjectID').val('');
    $('#ShortName').val('');
    $('#Address').val('');
    $('#Tel').val('');
    $('#Fax').val('');
    $('#Email').val('');
    $('#Website').val('');
    $('#Disabled').val(false);

    //var comboboxInventoryTypeID = $("#InventoryTypeID").data("kendoComboBox");
    // comboboxInventoryTypeID.value('');
    var comboboxPriceColumn = $("#PriceColumn").data("kendoComboBox");
    comboboxPriceColumn.value('');
    var comboboxPriceValue = $("#PriceValue").data("kendoComboBox");
    comboboxPriceValue.value('');
    var comboboxPromoteID = $("#PromoteID").data("kendoComboBox");
    comboboxPromoteID.value('');
    var comboboxWareHouseID = $("#WareHouseID").data("kendoComboBox");
    comboboxWareHouseID.value('');


    var comboboxVoucherType01 = $("#VoucherType01").data("kendoComboBox");
    comboboxVoucherType01.value('');
    var comboboxVoucherType02 = $("#VoucherType02").data("kendoComboBox");
    comboboxVoucherType02.value('');
    var comboboxVoucherType03 = $("#VoucherType03").data("kendoComboBox");
    comboboxVoucherType03.value('');
    //var comboboxVoucherType04 = $("#VoucherType04").data("kendoComboBox");
    //comboboxVoucherType04.value('');
    var comboboxVoucherType05 = $("#VoucherType05").data("kendoComboBox");
    comboboxVoucherType05.value('');
    var comboboxVoucherType06 = $("#VoucherType06").data("kendoComboBox");
    comboboxVoucherType06.value('');
    var comboboxVoucherType07 = $("#VoucherType07").data("kendoComboBox");
    comboboxVoucherType07.value('');
    var comboboxVoucherType08 = $("#VoucherType08").data("kendoComboBox");
    comboboxVoucherType08.value('');
    var comboboxVoucherType09 = $("#VoucherType09").data("kendoComboBox");
    comboboxVoucherType09.value('');
    var comboboxVoucherType10 = $("#VoucherType10").data("kendoComboBox");
    comboboxVoucherType10.value('');
    var comboboxVoucherType11 = $("#VoucherType11").data("kendoComboBox");
    comboboxVoucherType11.value('');
    var comboboxVoucherType12 = $("#VoucherType12").data("kendoComboBox");
    comboboxVoucherType12.value('');
    var comboboxVoucherType12 = $("#VoucherType13").data("kendoComboBox");
    comboboxVoucherType12.value('');



    $("#IsTable").val(false);
    $("#IsDiscount").val(false);
    //$("#IsS2").val(false);
    //$("#IsS3").val(false);
    //$("#IsAutomatic").val(false);
    //$("#AutoIndex").val(false);
}

function popupSaveUpdate() {
    saveActionType = 3;
    saveDataUpdate();
}

function saveDataUpdate(e) {
    if (ASOFT.form.checkRequired('POSF00101')) {
        return;
    }
    if (formIsInvalid()) {
        return;
    }
    // Lấy dữ liệu trên form
    var data = getFormData();

    var isSelected = false;
    for (var i = 0; i < data.DetailList.length; i++) {
        if (data.DetailList[i].Selected == 1) {
            isSelected = true;
            break;
        }
    }

    if (!isSelected) {
        $("#POSF00101Grid").addClass('asf-focus-input-error');
        var message = ASOFT.helper.getMessage('POSFML000067');
        ASOFT.form.displayError("#POSF00101", message);
        return;
    }

    //var data = ASOFT.helper.getFormData(null, "POSF00101")
    urlUpdate = $('#UrlUpdate').val();
    // Post data
    ASOFT.helper.postTypeJson(urlUpdate, data, SaveSuccess);
}

// Kiểm tra tính hợp lệ của combobox
function formIsInvalid() {

    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) 
    if (isCAFE) {
        var comboInvalid = ASOFT.form.checkRequiredAndInList(ID, ['DivisionID',
                                                 //'ShopID',
                                                 //'InventoryTypeID',
                                                 'PriceValue',
                                                 'PriceColumn',
                                                 'PromoteID',
                                                 //'WareHouseID',
                                                 //'ComWarehouseID',
                                                 //'TaxDebitAccountID',
                                                 //'TaxCreditAccountID',
                                                 //'PayDebitAccountID',
                                                 //'PayCreditAccountID',
                                                 //'CostDebitAccountID',
                                                 //'CostCreditAccountID',
                                                 //'DebitAccountID',
                                                 //'CreditAccountID',
                                                 //'VoucherType01',
                                                 //'VoucherType02',
                                                 //'VoucherType03',
                                                 //'VoucherType05',
                                                 //'VoucherType06',
                                                 //'VoucherType07',
                                                 //'VoucherType08',
                                                 //'VoucherType09',
                                                 //'VoucherType10',
                                                 //'VoucherType11',
                                                 //'VoucherType12',
                                                 //'VoucherType13'
        ]); // Promote ID, InventoryTypeID
    }
    else {
        var comboInvalid = ASOFT.form.checkRequiredAndInList(ID, ['DivisionID',
                                                //'ShopID',
                                                //'InventoryTypeID',
                                                'PriceValue',
                                                "PromoteIDCA"
                                                //'PromotePriceTable',
                                                //'PromoteID',
                                                //'WareHouseID',
                                                //'ComWarehouseID',
                                                //'TaxDebitAccountID',
                                                //'TaxCreditAccountID',
                                                //'PayDebitAccountID',
                                                //'PayCreditAccountID',
                                                //'CostDebitAccountID',
                                                //'CostCreditAccountID',
                                                //'DebitAccountID',
                                                //'CreditAccountID',
                                                //'VoucherType01',
                                                //'VoucherType02',
                                                //'VoucherType03',
                                                //'VoucherType05',
                                                //'VoucherType06',
                                                //'VoucherType07',
                                                //'VoucherType08',
                                                //'VoucherType09',
                                                //'VoucherType10',
                                                //'VoucherType11',
                                                //'VoucherType12',
                                                //'VoucherType13'
        ]); // Promote ID, InventoryTypeID
    }


    //var hasDuplicated = hasDuplicate();

    //return comboInvalid || hasDuplicated;

    return comboInvalid;
}

function refreshDefaultViewModel() {
    defaultViewModel = ASOFT.helper.dataFormToJSON(ID);
    defaultViewModel.Disabled = ($("#Disabled").attr("checked") == 'checked');
    defaultViewModel.IsTable = ($("#IsTable").attr("checked") == 'checked');
    defaultViewModel.IsDiscount = ($("#IsDiscount").attr("checked") == 'checked');

}

function isDataChanged() {
    var dataPost = getFormData();
    //if (ASOFTEnvironment.CustomerIndex.isPhucLong()) 
    if (isCAFE) {
        var check = (dataPost.ObjectID.valueOf() == this.defaultViewModel.ObjectID.valueOf())
    //&& (dataPost.DivisionName.valueOf() == this.defaultViewModel.DivisionName.valueOf())
    //&& (dataPost.ShopID.valueOf() == this.defaultViewModel.ShopID.valueOf())
    //&& (dataPost.ShopName.valueOf() == this.defaultViewModel.ShopName.valueOf())
    //&& (dataPost.ObjectID.valueOf() == this.defaultViewModel.ObjectID.valueOf())
    && (dataPost.ObjectName.valueOf() == this.defaultViewModel.ObjectName.valueOf())
    && (dataPost.ShortName.valueOf() == this.defaultViewModel.ShortName.valueOf())
    && (dataPost.Address.valueOf() == this.defaultViewModel.Address.valueOf())
    && (dataPost.Tel.valueOf() == this.defaultViewModel.Tel.valueOf())
    && (dataPost.Fax.valueOf() == this.defaultViewModel.Fax.valueOf())
    && (dataPost.Email.valueOf() == this.defaultViewModel.Email.valueOf())
    && (dataPost.Website.valueOf() == this.defaultViewModel.Website.valueOf())
    //&& (dataPost.ImageLogo.valueOf() == this.defaultViewModel.ImageLogo.valueOf())
    && (dataPost.Disabled.valueOf() == this.defaultViewModel.Disabled.valueOf())
    //&& (dataPost.InventoryTypeID.valueOf() == this.defaultViewModel.InventoryTypeID.valueOf())
    //&& (dataPost.InventoryTypeName.valueOf() == this.defaultViewModel.InventoryTypeName.valueOf())
    && (dataPost.PriceColumn.valueOf() == this.defaultViewModel.PriceColumn.valueOf())
    //&& (dataPost.PriceValue.valueOf() == this.defaultViewModel.PriceValue.valueOf())
    && (dataPost.IsDiscount.valueOf() == this.defaultViewModel.IsDiscount.valueOf())
        //&& (dataPost.PromoteID.valueOf() == this.defaultViewModel.PromoteID.valueOf());
        //&& (dataPost.IsS2.valueOf() == this.defaultViewModel.IsS2.valueOf())
        //&& (dataPost.S2.valueOf() == this.defaultViewModel.S2.valueOf())
        //&& (dataPost.IsS3.valueOf() == this.defaultViewModel.IsS3.valueOf())
        //&& (dataPost.S3.valueOf() == this.defaultViewModel.S3.valueOf())
        //&& (dataPost.IsAutomatic.valueOf() == this.defaultViewModel.IsAutomatic.valueOf())
        //&& (dataPost.NNNS.valueOf() == this.defaultViewModel.NNNS.valueOf())
        //&& (dataPost.Length.valueOf() == this.defaultViewModel.Separator.valueOf())
        //&& (dataPost.AutoIndex.valueOf() == this.defaultViewModel.S3.valueOf())
        //&& (dataPost.AutoIndexValue.valueOf() == this.defaultViewModel.AutoIndexValue.valueOf());

    }
    else {
        var check = (dataPost.ObjectID.valueOf() == this.defaultViewModel.ObjectID.valueOf())
    //&& (dataPost.DivisionName.valueOf() == this.defaultViewModel.DivisionName.valueOf())
    //&& (dataPost.ShopID.valueOf() == this.defaultViewModel.ShopID.valueOf())
    //&& (dataPost.ShopName.valueOf() == this.defaultViewModel.ShopName.valueOf())
    //&& (dataPost.ObjectID.valueOf() == this.defaultViewModel.ObjectID.valueOf())
    && (dataPost.ObjectName.valueOf() == this.defaultViewModel.ObjectName.valueOf())
    && (dataPost.ShortName.valueOf() == this.defaultViewModel.ShortName.valueOf())
    && (dataPost.Address.valueOf() == this.defaultViewModel.Address.valueOf())
    && (dataPost.Tel.valueOf() == this.defaultViewModel.Tel.valueOf())
    && (dataPost.Fax.valueOf() == this.defaultViewModel.Fax.valueOf())
    && (dataPost.Email.valueOf() == this.defaultViewModel.Email.valueOf())
    && (dataPost.Website.valueOf() == this.defaultViewModel.Website.valueOf())
    //&& (dataPost.ImageLogo.valueOf() == this.defaultViewModel.ImageLogo.valueOf())
    && (dataPost.Disabled.valueOf() == this.defaultViewModel.Disabled.valueOf())
    //&& (dataPost.InventoryTypeID.valueOf() == this.defaultViewModel.InventoryTypeID.valueOf())
    //&& (dataPost.InventoryTypeName.valueOf() == this.defaultViewModel.InventoryTypeName.valueOf())
    //&& (dataPost.PromotePriceTable.valueOf() == this.defaultViewModel.PromotePriceTable.valueOf())
    //&& (dataPost.PriceValue.valueOf() == this.defaultViewModel.PriceValue.valueOf())
    && (dataPost.IsDiscount.valueOf() == this.defaultViewModel.IsDiscount.valueOf())
        //&& (dataPost.PromoteID.valueOf() == this.defaultViewModel.PromoteID.valueOf());
        //&& (dataPost.IsS2.valueOf() == this.defaultViewModel.IsS2.valueOf())
        //&& (dataPost.S2.valueOf() == this.defaultViewModel.S2.valueOf())
        //&& (dataPost.IsS3.valueOf() == this.defaultViewModel.IsS3.valueOf())
        //&& (dataPost.S3.valueOf() == this.defaultViewModel.S3.valueOf())
        //&& (dataPost.IsAutomatic.valueOf() == this.defaultViewModel.IsAutomatic.valueOf())
        //&& (dataPost.NNNS.valueOf() == this.defaultViewModel.NNNS.valueOf())
        //&& (dataPost.Length.valueOf() == this.defaultViewModel.Separator.valueOf())
        //&& (dataPost.AutoIndex.valueOf() == this.defaultViewModel.S3.valueOf())
        //&& (dataPost.AutoIndexValue.valueOf() == this.defaultViewModel.AutoIndexValue.valueOf());

    }

    return !check;
}

/**
* Change payment
*/
function filterPromoteID1() {
    //TODO:
    /*var item = $("#InventoryTypeID").data("kendoComboBox").dataItem();
    var inventoryTypeID = -1;
    if (item != null) {
        inventoryTypeID = item.InventoryTypeID;
    }*/
    return {
        inventoryTypeID: $("#InventoryTypeID").val()
    };
}

//Change
function Combobox_Change(e) {
    var check = ASOFT.form.checkItemInListFor(this, 'POSF00101');
    if (check) {
        e.sender.focus();
    }
}

function POSF00101TabActivate() {
    ASOFT.asoftGrid.calculateGridContentHeight(posGrid);
}

// Dánh dấu các combobox bị lỗi (do trùng hoặc không sửa được)
function highlightElement(id) {
    var element = $(id);
    if (!element) return;
    var fromWidget = element.closest(".k-widget");
    var widgetElement = element.closest("[data-" + kendo.ns + "role]");
    var widgetObject = kendo.widgetInstance(widgetElement);

    if (widgetObject != undefined && widgetObject.options.name != "TabStrip") {
        fromWidget.addClass('asf-focus-input-error');
        var input = fromWidget.find(">:first-child").find(">:first-child");
        $(input).addClass('asf-focus-combobox-input-error');
    } else {
        element.addClass('asf-focus-input-error');
    }
}

function hasDuplicate() {
    //debugger

    var result = false;

    for (var i = 0, l = comboBoxIDs.length; i < l - 1; i++) {
        for (var j = i + 1; j < l; j++) {
            var combo1 = $('#' + comboBoxIDs[i]).data('kendoComboBox');
            var combo2 = $('#' + comboBoxIDs[j]).data('kendoComboBox');

            if (combo1 && combo1
                && combo1.value() == combo2.value()) {
                highlightElement('#' + comboBoxIDs[i]);
                highlightElement('#' + comboBoxIDs[j]);
                result = true
            }
        }
    }
    if (result) {
        ASOFT.form.displayWarning('#POSF00101', ASOFT.helper.getMessage('POSM000035'));
        return true;
    }

}

function afterSaveHandler(result) {
    if (result && result.Status != 0) {
        // Xóa các thông báo hiện có
        ASOFT.form.clearMessageBox();
        // Tạo mản chức các giá trị "distinct"
        //  của danh sách mã phiếu nhận được từ server
        var a = [];
        if (result.Data && result.Data.TypesSelected) {
            a = result.Data.TypesSelected.concat();
        }
        for (var i = 0; i < a.length; ++i) {
            for (var j = i + 1; j < a.length; ++j) {
                if (a[i] === a[j])
                    a.splice(j--, 1);
            }
        }
        var resultData = a;

        // Kết chuỗi các mã phiếu vừa lấy ra, để hiện thông báo lỗi
        var joined = resultData.filter(function (val) { return val !== null; }).join(", ");
        ASOFT.form.displayWarning('#POSF00101',
            ASOFT.helper.getMessage(result.Message).format(joined));

        if (result.Data) {
            if (result.Message == "00ML000105") {
                ASOFT.form.clearMessageBox();
                var msg = ASOFT.helper.getMessage(result.Message);
                if (result.Data.sysPackageName == null) {
                    result.Data.sysPackageName = "";
                }
                msg = kendo.format(msg, result.Data.sysPackageName, result.Data.ShopNo);
                ASOFT.form.displayWarning('#POSF00101', msg);
            }
        }

        // So sánh từng giá trị trên form và từng giá trị nhận được từ server
        // Để đánh dấu các combox không sửa được
        if (result.Data && result.Data.TypesSelected) {
            var typesSelected = result.Data.TypesSelected;
            var data = ASOFT.helper.dataFormToJSON('POSF00101');
            for (var i = 1; i < typesSelected.length; i++) {
                var itemName = 'VoucherType' + helper.prefixInteger(i, 2);
                if (typesSelected[i]
                    && data[itemName] != result.Data[i]) {
                    var combo = ASOFT.asoftComboBox.castName(itemName);
                    combo.value(typesSelected[i]);
                    highlightElement("#" + itemName);
                }
            }
        }
    }
}
//function getInfo() {
//    var dataPost = ASOFT.helper.dataFormToJSON("POSF00101");
//    dataPost.DetailList = this.gridDataSource.data();
//    dataPost.IsDataChanged = this.gridDataSource.hasChanges();
//    return dataPost;
//}



$(document).ready(function () {

    function makeTextBoxWithSearch(selector) {
        var
            targetElement = $(selector),

            parent = targetElement.parent(),

            wrapper = $('<span class="textbox-search-wrapper"></span>'),

            asfButtonString = '<span class="asf-button-special"><a id="{0}" class="k-button k-button-icontext asf-button asf-icon-24 asf-i-search-24 {0}" style="" data-role="button" role="button" aria-disabled="false" tabindex="0">&nbsp;</a></span>'.format('btnOpenSearch'),

            buttonElement = $(asfButtonString)
        ;

        wrapper.append(targetElement.clone().css('width', ''));
        wrapper.append(buttonElement);
        targetElement.remove();
        parent.append(wrapper);

        buttonElement.on('click', function () {
            ASOFT.asoftPopup.showIframe('/POS/POSF0010/POSF00102', {});
        });
    }


    makeTextBoxWithSearch('#ObjectID');

});

function recieveResult(result) {
    if (result) {
        $('#ObjectID').val(result.ObjectID);
        $('#ObjectName').val(result.ObjectName);
    }
}

function OpenAdd(e, Src) {
    var urlAdd = "/PopupLayout/Index/CI/" + Src;

    var idElm = $(e.parentElement.parentElement.parentElement.parentElement.parentElement).attr("id");

    idAdd = idElm.split('-');

    localStorage.setItem("IDCommbox", "InventoryTypeID");

    ASOFT.asoftPopup.showIframe(urlAdd, {});
}

function AddValueCombobox() {
    if (localStorage.getItem("IDCommbox") != null) {
        $("#" + idAdd).data("kendoComboBox").dataSource.read();
        $("#" + idAdd).data("kendoComboBox").value(localStorage.getItem("ValueCombobox"));
    }
}

function popupClose() {
    localStorage.removeItem("ValueCombobox");
    localStorage.removeItem("IDCommbox");
    ASOFT.asoftPopup.hideIframe();
};