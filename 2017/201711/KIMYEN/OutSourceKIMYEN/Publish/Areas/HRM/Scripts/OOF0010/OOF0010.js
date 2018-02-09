// Document ready
$(document).ready(function () {
    if ($('#DXP').val() < 10) {
        $('#BtnPrevDXP').attr("style", "display:none")
        $('#BtnNextDXP').attr("style", "display:none")
    } else {
        $('#BtnPrevDXP').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextDXP').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    if ($('#DXLTG').val() < 10) {
        $('#BtnPrevDXLTG').attr("style", "display:none")
        $('#BtnNextDXLTG').attr("style", "display:none")
    } else {
        $('#BtnPrevDXLTG').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextDXLTG').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    if ($('#DXRN').val() < 10) {
        $('#BtnPrevDXRN').attr("style", "display:none")
        $('#BtnNextDXRN').attr("style", "display:none")
    } else {
        $('#BtnPrevDXRN').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextDXRN').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    if ($('#DXBSQT').val() < 10) {
        $('#BtnPrevDXBSQT').attr("style", "display:none")
        $('#BtnNextDXBSQT').attr("style", "display:none")
    } else {
        $('#BtnPrevDXBSQT').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextDXBSQT').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    if ($('#BPC').val() < 10) {
        $('#BtnPrevBPC').attr("style", "display:none")
        $('#BtnNextBPC').attr("style", "display:none")
    } else {
        $('#BtnPrevBPC').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextBPC').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    if ($('#DXDC').val() < 10) {
        $('#BtnPrevDXDC').attr("style", "display:none")
        $('#BtnNextDXDC').attr("style", "display:none")
    } else {
        $('#BtnPrevDXDC').attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
        $('#BtnNextDXDC').attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
    }

    var data =
    [
        {
            level: $('#DXP').val(),
            absentType: $('#DXP').attr('id')
        },
        {
            level: $('#DXLTG').val(),
            absentType: $('#DXLTG').attr('id')
        },
        {
            level: $('#DXBSQT').val(),
            absentType: $('#DXBSQT').attr('id')
        },
        {
            level: $('#DXRN').val(),
            absentType: $('#DXRN').attr('id')
        },
        {
            level: $('#BPC').val(),
            absentType: $('#BPC').attr('id')
        },
        {
            level: $('#DXDC').val(),
            absentType: $('#DXDC').attr('id')
        }
    ]
    OOF0010.getDataLoad(data);
    OOF0010.checkLevelDataChange(data);
});

OOF0010 = new function () {
    this.rowNum = 0;
    this.Level = 0;
    this.AbsentType = null;
    this.OOF0010GridDXP = 0;
    this.OOF0010GridDXLTG = 0;
    this.OOF0010GridDXRN = 0;
    this.OOF0010GridDXBSQT = 0;
    this.OOF0010GridBPC = 0;
    this.OOF0010GridDXDC = 0;
    this.isSaved = false;

    //Checkbox cho từng dòng trên grid
    this.checkBox_Changed = function (tag) {
        var gridactive = tag.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id;        
        var grid = $('#' + gridactive).data('kendoGrid');

        var index = $(tag.parentElement.parentElement.firstChild).text();
        var checked = $(tag).prop('checked') ? true : false;
        grid.dataSource._data[index - 1].IsPermision = checked;
    }

    //Checkbox chọn tất cả trong 1 grid
    this.checkBox_ChangedAll = function (tag) {
        
        //Lấy tên của grid 
        var gridactive = tag.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.id;        

        var grid = $('#' + gridactive).data('kendoGrid');
        var checked = $(tag).prop('checked') ? true : false;
        var num = grid.dataSource._data.length;
        for (i = 0; i < num; i++) {
            if (grid.dataSource._data[i].IsLock == 0) {
                grid.dataSource._data[i].IsPermision = checked;
            }
        }
        if (checked) {
            $('div#' + gridactive + ' input#IsPermision:not(:disabled)').prop('checked', true);
        } else {
            $('div#' + gridactive + ' input#IsPermision:not(:disabled)').prop('checked', false);
        }
    }

    this.combo_Changed = function () {
        ASOFT.form.checkItemInListFor(this, 'OOF0010');
    }

    //Load data cho từng grid
    this.GetDataGrid = function (i, APKMaster) {
        var data = [];
        data.rollLevel = i;
        data.absentType = OOF0010.AbsentType;
        data.APKMaster = APKMaster;
        return data;
    }
    
    //Lấy giá trị trước khi load cấp duyệt
    this.getDataLoad = function (data) {
        for (var i = 0; i < data.length; i++) {
            OOF0010.levelNumber_Load(data[i]);
        }
    }

    //Kiểm tra cấp duyệt 
    this.checkLevelDataChange = function (data) {
        for (var i = 0; i < data.length; i++) {
            OOF0010.checkLevelChange(data[i].absentType);
        }
    }

    //Kiểm tra cấp duyệt được phép sửa hay không
    this.checkLevelChange = function (data) {
        var islock = $('#IsLock' + data).val();
        if (islock == 1) {
            var numerictextbox = $("#" + data).data("kendoNumericTextBox");
            numerictextbox.readonly();
        }
    }

    this.closeBtnNextPrev = function (num, type) {
        var btnPrev = null;
        var btnNext = null;
        if (type == 1) {
            btnPrev = "#BtnPrevDXP";
            btnNext = "#BtnNextDXP";
        } else if (type == 2) {
            btnPrev = "#BtnPrevDXLTG";
            btnNext = "#BtnNextDXLTG";
        } else if (type == 3) {
            btnPrev = "#BtnPrevDXRN";
            btnNext = "#BtnNextDXRN";
        } else if (type == 4) {
            btnPrev = "#BtnPrevDXBSQT";
            btnNext = "#BtnNextDXBSQT";
        } else if (type == 5) {
            btnPrev = "#BtnPrevBPC";
            btnNext = "#BtnNextBPC";
        } else if (type == 6) {
            btnPrev = "#BtnPrevDXDC";
            btnNext = "#BtnNextDXDC";
        }

        if (num < 10) {
            $(btnPrev).attr("style", "display:none")
            $(btnNext).attr("style", "display:none")
        } else {
            $(btnPrev).attr("style", "display:none;height: 30px;width: 35px; position: absolute;  z-index: 1;")
            $(btnNext).attr("style", "height: 30px;width: 35px; position: absolute; left: 969px; z-index: 1;")
        }
    }

    //event load Cấp duyệt 
    this.levelNumber_Load = function (data) {
        var tabstrip = null;
        var contentTabStrip = null;
        var arrayList = [];

        if (data.absentType == 'DXP') {
            tabstrip = '#tabstrip1';
            OOF0010.OOF0010GridDXP = data.level;
            OOF0010.closeBtnNextPrev(data.level, 1);
        }
        else if (data.absentType == 'DXLTG') {
            tabstrip = '#tabstrip2';
            OOF0010.OOF0010GridDXLTG = data.level;
            OOF0010.closeBtnNextPrev(data.level, 2);
        }
        else if (data.absentType == 'DXRN') {
            tabstrip = '#tabstrip3';
            OOF0010.OOF0010GridDXRN = data.level;
            OOF0010.closeBtnNextPrev(data.level, 3);
        }
        else if (data.absentType == 'DXBSQT') {
            tabstrip = '#tabstrip4';
            OOF0010.OOF0010GridDXBSQT = data.level;
            OOF0010.closeBtnNextPrev(data.level, 4);
        }
        else if (data.absentType == 'BPC') {
            tabstrip = '#tabstrip5';
            OOF0010.OOF0010GridBPC = data.level
            OOF0010.closeBtnNextPrev(data.level, 5);
        }
        else if (data.absentType == 'DXDC') {
            tabstrip = '#tabstrip6';
            OOF0010.OOF0010GridDXDC = data.level
            OOF0010.closeBtnNextPrev(data.level, 6);
        }
        OOF0010.AbsentType = data.absentType;
        OOF0010.Level = data.level;


        $(tabstrip).html('');
        var sublevel = $("#SubLevel").val() + ' ';
        var tabstrip = $(tabstrip).kendoTabStrip().data("kendoTabStrip");
        var url = $('#UrlGetGridData').val();
        var contentTabStrip = '';
        for (var i = 1; i <= OOF0010.Level; i++) {
            contentTabStrip = '';
            var data = {
                rollLevel: i,
                absentType: data.absentType,
                APKMaster: $("#APK"+data.absentType).val(),
            }
            ASOFT.helper.post($('#UrlGetGridData').val(),
                      data, function (data1) {
                          contentTabStrip = data1;
                      });
            arrayList.push({ text: (sublevel + i.toString()), encoded: false, content: contentTabStrip });  // text là title, content là nội dung em làm tương tự trên kendo append 
        }
        $(tabstrip.wrapper).attr({ 'class': 'k-widget k-tabstrip k-header asf-tab', 'style': ' padding-bottom: 40px; overflow-x: hidden; overflow-y: hidden; white-space: nowrap;' })
        tabstrip.append(arrayList);
       $($($(tabstrip.wrapper.children())[0]).children()[0]).addClass('k-tab-on-top k-state-active')
        $($(tabstrip.wrapper.children().not("ul"))[0]).addClass('asf-tab-content k-state-active').css({'display': 'block', 'height': 'auto',' overflow': 'visible', 'opacity': '1'})
        $(tabstrip.wrapper.children().not("ul")).addClass('asf-tab-content')
        
       
    }

    //event Cấp duyệt thay đổi
    this.levelNumber_Change = function (data) {
        var absentType = data.sender.wrapper.children().children()[1].name;
        var level = data.sender.wrapper.children().children()[1].value;
        var tabstrip = null;
        var contentTabStrip = null;
        var arrayList = [];
        
        if (absentType == 'DXP') {
            tabstrip = '#tabstrip1';
            OOF0010.OOF0010GridDXP = level;
            OOF0010.closeBtnNextPrev(level, 1);
        }
        else if (absentType == 'DXLTG') {
            tabstrip = '#tabstrip2';
            OOF0010.OOF0010GridDXLTG = level;
            OOF0010.closeBtnNextPrev(level, 2);
        }
        else if (absentType == 'DXRN') {
            tabstrip = '#tabstrip3';
            OOF0010.OOF0010GridDXRN = level;
            OOF0010.closeBtnNextPrev(level, 3);
        }
        else if (absentType == 'DXBSQT') {
            tabstrip = '#tabstrip4';
            OOF0010.OOF0010GridDXBSQT = level;
            OOF0010.closeBtnNextPrev(level, 4);
        }
        else if (absentType == 'BPC') {
            tabstrip = '#tabstrip5';
            OOF0010.OOF0010GridBPC = level
            OOF0010.closeBtnNextPrev(level, 5);
        }
        else if (absentType == 'DXDC') {
            tabstrip = '#tabstrip6';
            OOF0010.OOF0010GridDXDC = level
            OOF0010.closeBtnNextPrev(level, 6);
        }
        OOF0010.AbsentType = absentType;
        OOF0010.Level = level;

        $(tabstrip).html('');
        var sublevel = $("#SubLevel").val() + ' '
        var tabstrip = $(tabstrip).kendoTabStrip().data("kendoTabStrip");
        var url = $('#UrlGetGridData').val();
        var contentTabStrip = '';
        for (var i = 1; i <= level; i++) {
            contentTabStrip = '';
            var data =
                {
                    rollLevel: i,
                    absentType: absentType,
                    APKMaster: $("#APK" + absentType).val(),
                }
                ASOFT.helper.post($('#UrlGetGridData').val(),
                          data, function (data1) {
                              contentTabStrip = data1;
                          });
                arrayList.push({ text: (sublevel + i.toString()), encoded: false, content: contentTabStrip });  // text là title, content là nội dung em làm tương tự trên kendo append 
        }
        $(tabstrip.wrapper).attr({ 'class': 'k-widget k-tabstrip k-header asf-tab', 'style': ' padding-bottom: 40px; overflow-x: hidden; overflow-y: hidden; white-space: nowrap;' })
        tabstrip.append(arrayList);
        $($($(tabstrip.wrapper.children())[0]).children()[0]).addClass('k-tab-on-top k-state-active')
        $($(tabstrip.wrapper.children().not("ul"))[0]).addClass('asf-tab-content k-state-active').css({ 'display': 'block', 'height': 'auto', ' overflow': 'visible', 'opacity': '1' })
        $(tabstrip.wrapper.children().not("ul")).addClass('asf-tab-content')
        
    }

    // show popup
    this.showPopup = function (url, data) {
        // [1] Format url with object data
        var postUrl = ASOFT.helper.renderUrl(url, data);

        // [2] Render iframe
        ASOFT.asoftPopup.showIframe(postUrl, {});
    };

    // Close button events
    this.btnClose_Click = function () {
        // Hide Iframe
        OOF0010.closePopup();
    };

    // Hide Iframes
    this.closePopup = function () {
        if (!ASOFT.form.formClosing('OOF0010') && !OOF0010.isSaved) {
            ASOFT.dialog.confirmDialog(ASOFT.helper.getMessage('00ML000016'),
                OOF0010.btnSave_Click, function () {
                    ASOFT.asoftPopup.hideIframe(true);
                });
        }
        else {
            ASOFT.asoftPopup.hideIframe(true);
        }
    };

    //Lấy giá trị của từng lưới trong mỗi subtab
    this.getDataSubTabGrid = function (subtab, data) {
        var grid = null;
        if (subtab == 1) {
            grid = '#OOF0010GridDXP_';
        }
        else if (subtab == 2) {
            grid = '#OOF0010GridDXLTG_';
        }
        else if (subtab == 3) {
            grid = '#OOF0010GridDXRN_';
        }
        else if (subtab == 4) {
            grid = '#OOF0010GridDXBSQT_';
        }
        else if (subtab == 5) {
            grid = '#OOF0010GridBPC_';
        }
        else if (subtab == 6) {
            grid = '#OOF0010GridDXDC_';
        }
        
        var array = [];
        for (var i = 1; i <= data; i++) {
            gridSub = $(grid + i).data('kendoGrid');
            array.push(gridSub.dataSource.data());
        }

        return array;
    }

   //Check IsPermission cho mỗi grid
    this.checkIsPermisionGrid = function (subtab, data) {
        var grid = null;
        if (subtab == 1) {
            grid = '#OOF0010GridDXP_';
        }
        else if (subtab == 2) {
            grid = '#OOF0010GridDXLTG_';
        }
        else if (subtab == 3) {
            grid = '#OOF0010GridDXRN_';
        }
        else if (subtab == 4) {
            grid = '#OOF0010GridDXBSQT_';
        }
        else if (subtab == 5) {
            grid = '#OOF0010GridBPC_';
        }
        else if (subtab == 6) {
            grid = '#OOF0010GridDXDC_';
        }

        var array = [];
        for (var i = 1; i <= data; i++) {
            gridSub = $(grid + i).data('kendoGrid');
            var array = gridSub.dataSource.data();
            //for (var j = 0; j < array.length; j++) {
            //    if (array[j].IsPermision===true) {
            //        return true;                    
            //    }
            //}
            if (OOF0010.checkIsPermision(array)) {
                continue;
            }
            else {
                return false;
            }
        }
        return true;
    }

    //check grid
    this.checkIsPermision = function (array) {
        for (var j = 0; j < array.length; j++) {
            if (array[j].IsPermision === true) {
                return true;
            }
        }
        return false;
    }
    //btn save
    this.btnSave_Click = function () {
        if (ASOFT.form.checkRequired("OOF0010")) {
            return;
        }
        var data = {};
        data = ASOFT.helper.dataFormToJSON('OOF0010');
        data.APKDXP = $("#APKDXP").val();
        data.APKDXLTG = $("#APKDXLTG").val();
        data.APKDXRN = $("#APKDXRN").val();
        data.APKDXBSQT = $("#APKDXBSQT").val();
        data.APKDXP = $("#APKDXP").val();
        data.APKBPC = $("#APKBPC").val();
        data.APKDXDC = $("#APKDXDC").val();

        if (!OOF0010.checkIsPermisionGrid(1, OOF0010.OOF0010GridDXP)
            && !OOF0010.checkIsPermisionGrid(2, OOF0010.OOF0010GridDXLTG)
            && !OOF0010.checkIsPermisionGrid(3, OOF0010.OOF0010GridDXRN)
            && !OOF0010.checkIsPermisionGrid(4, OOF0010.OOF0010GridDXBSQT)
            && !OOF0010.checkIsPermisionGrid(5, OOF0010.OOF0010GridBPC)
            && !OOF0010.checkIsPermisionGrid(6, OOF0010.OOF0010GridDXDC)) {
            ASOFT.form.displayMessageBox("#" + 'OOF0010', [ASOFT.helper.getMessage('OOFML000016')], null);
            return;
        }
        data.OOF0010GridDXP = OOF0010.getDataSubTabGrid(1, OOF0010.OOF0010GridDXP);
        data.OOF0010GridDXLTG = OOF0010.getDataSubTabGrid(2, OOF0010.OOF0010GridDXLTG);
        data.OOF0010GridDXRN = OOF0010.getDataSubTabGrid(3, OOF0010.OOF0010GridDXRN);
        data.OOF0010GridDXBSQT = OOF0010.getDataSubTabGrid(4, OOF0010.OOF0010GridDXBSQT);
        data.OOF0010GridBPC = OOF0010.getDataSubTabGrid(5, OOF0010.OOF0010GridBPC);
        data.OOF0010GridDXDC = OOF0010.getDataSubTabGrid(6, OOF0010.OOF0010GridDXDC);

        data.LastModifyDate = $('#LastModifyDate').val();
        
        var url = $('#UrlUpdate').val();
        ASOFT.helper.postTypeJson(url, data, OOF0010.saveSuccess);
      
    }
   
    this.saveSuccess = function (result) {
        ASOFT.helper.showErrorSeverOption(0, result, 'OOF0010', function () {
            OOF0010.isSaved = true;
            OOF0010.btnClose_Click();
        }, null, null, true);
    }   

    //------ Button next prev Đơn xin phép
    var numDXP = 1;//dung cho nut next, prev
    this.BtnPrevDXP_Click = function () {
        var tabStrip = $('#tabstrip1').data("kendoTabStrip");
        var ul = $('#tabstrip1').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip1-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));
        
        var total = 0;
        var numDXP = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numDXP - 1;
        
        if (i == 1 ) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevDXP').attr("style", "display:none")
            $('#BtnNextDXP').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
            
        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextDXP').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")           
        }
        numDXP = numDXP - 1;
    }


    this.BtnNextDXP_Click = function () {
        var tabStrip = $('#tabstrip1').data("kendoTabStrip");
        var ul = $('#tabstrip1').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip1-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numDXP; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numDXP_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numDXP_width;
            if (ul.width() < total) {
                break;
            }

        }
        
        if (i == (count-1)) {
            $(tabStrip.items()[numDXP - 1]).attr("style", "display:none");
            $('#BtnPrevDXP').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextDXP').attr("style", "display:none");
        } else {

            $(tabStrip.items()[numDXP - 1]).attr("style", "display:none");
            $(tabStrip.items()[numDXP]).attr("style", "margin-left:35px");
            $('#BtnPrevDXP').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            
        }
        numDXP = numDXP + 1;
    }

    //------ Button next prev Đơn xin làm thêm giờ
    var numDXLTG = 1;//dung cho nut next, prev
    this.BtnPrevDXLTG_Click = function () {
        var tabStrip = $('#tabstrip2').data("kendoTabStrip");
        var ul = $('#tabstrip2').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip2-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));

        var total = 0;
        var numDXLTG = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numDXLTG - 1;
        
        if (i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevDXLTG').attr("style", "display:none")
            $('#BtnNextDXLTG').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")

        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextDXLTG').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        }
        numDXLTG = numDXLTG - 1;
    }


    this.BtnNextDXLTG_Click = function () {
        var tabStrip = $('#tabstrip2').data("kendoTabStrip");
        var ul = $('#tabstrip2').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip2-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numDXLTG; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numDXLTG_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numDXLTG_width;
            if (ul.width() < total) {
                break;
            }

        }
        
        if (i == (count - 1)) {
            $(tabStrip.items()[numDXLTG - 1]).attr("style", "display:none");
            $('#BtnPrevDXLTG').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextDXLTG').attr("style", "display:none");
        } else {

            $(tabStrip.items()[numDXLTG - 1]).attr("style", "display:none");
            $(tabStrip.items()[numDXLTG]).attr("style", "margin-left:35px");
            $('#BtnPrevDXLTG').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
        }

        numDXLTG = numDXLTG + 1;
    }

    //------ Button next prev Đơn xin Ra ngoài
    var numDXRN = 1;//dung cho nut next, prev
    this.BtnPrevDXRN_Click = function () {
        var tabStrip = $('#tabstrip3').data("kendoTabStrip");
        var ul = $('#tabstrip3').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip3-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));

        var total = 0;
        var numDXRN = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numDXRN - 1;
        
        if (i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevDXRN').attr("style", "display:none")
            $('#BtnNextDXRN').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")

        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextDXRN').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        }
        numDXRN = numDXRN - 1;
    }


    this.BtnNextDXRN_Click = function () {
        var tabStrip = $('#tabstrip3').data("kendoTabStrip");
        var ul = $('#tabstrip3').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip3-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numDXRN; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numDXRN_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numDXRN_width;
            if (ul.width() < total) {
                break;
            }

        }

        if (i == (count - 1)) {
            $(tabStrip.items()[numDXRN - 1]).attr("style", "display:none");
            $('#BtnPrevDXRN').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextDXRN').attr("style", "display:none");
        } else {

            $(tabStrip.items()[numDXRN - 1]).attr("style", "display:none");
            $(tabStrip.items()[numDXRN]).attr("style", "margin-left:35px");
            $('#BtnPrevDXRN').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");            
        }

        numDXRN = numDXRN + 1;
    }

    //------ Button next prev Đơn xin bổ sung quẹt thẻ
    var numDXBSQT = 1;//dung cho nut next, prev
    this.BtnPrevDXBSQT_Click = function () {
        var tabStrip = $('#tabstrip4').data("kendoTabStrip");
        var ul = $('#tabstrip4').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip4-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));

        var total = 0;
        var numDXBSQT = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numDXBSQT - 1;
        
        if (i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevDXBSQT').attr("style", "display:none")
            $('#BtnNextDXBSQT').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")

        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextDXBSQT').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        }
        numDXBSQT = numDXBSQT - 1;
    }


    this.BtnNextDXBSQT_Click = function () {
        var tabStrip = $('#tabstrip4').data("kendoTabStrip");
        var ul = $('#tabstrip4').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip4-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numDXBSQT; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numDXBSQT_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numDXBSQT_width;
            if (ul.width() < total) {
                break;
            }

        }
        
        if (i == (count - 1)) {
            $(tabStrip.items()[numDXBSQT - 1]).attr("style", "display:none");
            $('#BtnPrevDXBSQT').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextDXBSQT').attr("style", "display:none");
        } else {

            $(tabStrip.items()[numDXBSQT - 1]).attr("style", "display:none");
            $(tabStrip.items()[numDXBSQT]).attr("style", "margin-left:35px");
            $('#BtnPrevDXBSQT').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
        }
        numDXBSQT = numDXBSQT + 1;
    }

    //------ Button next prev Bảng phân ca
    var numBPC = 1;//dung cho nut next, prev
    this.BtnPrevBPC_Click = function () {
        var tabStrip = $('#tabstrip5').data("kendoTabStrip");
        var ul = $('#tabstrip5').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip5-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));

        var total = 0;
        var numBPC = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numBPC - 1;
        
        if (i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevBPC').attr("style", "display:none")
            $('#BtnNextBPC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")

        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextBPC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        }

        numBPC = numBPC - 1;
    }


    this.BtnNextBPC_Click = function () {
        var tabStrip = $('#tabstrip5').data("kendoTabStrip");
        var ul = $('#tabstrip5').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip5-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numBPC; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numBPC_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numBPC_width;
            if (ul.width() < total) {
                break;
            }

        }
       
        if (i == (count - 1)) {
            $(tabStrip.items()[numBPC - 1]).attr("style", "display:none");
            $('#BtnPrevBPC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextBPC').attr("style", "display:none");
        } else {

            $(tabStrip.items()[numBPC - 1]).attr("style", "display:none");
            $(tabStrip.items()[numBPC]).attr("style", "margin-left:35px");
            $('#BtnPrevBPC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");            
        }

        numBPC = numBPC + 1;
    }

    //------ Button next prev Đơn xin đổi ca
    var numDXDC = 1;//dung cho nut next, prev
    this.BtnPrevDXDC_Click = function () {
        var tabStrip = $('#tabstrip6').data("kendoTabStrip");
        var ul = $('#tabstrip6').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");
        var DRF2001Tab = "tabstrip6-";
        var count = ul.children().length + 1;;


        var li_list = ul.find($("li[style!='display:none']"));

        var total = 0;
        //var numDXDC = $(li_list[0]).attr("aria-controls").substr(-1, 1);
        var i = numDXDC - 1;
        
        if (i == 1) {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "")
            $('#BtnPrevDXDC').attr("style", "display:none")
            $('#BtnNextDXDC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        } else {
            $(tabStrip.items()[i]).attr("style", "")
            $(tabStrip.items()[i - 1]).attr("style", "margin-left:35px")
            $('#BtnNextDXDC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;left: 969px;")
        }
        numDXDC = numDXDC - 1;
    }


    this.BtnNextDXDC_Click = function () {
        var tabStrip = $('#tabstrip6').data("kendoTabStrip");
        var ul = $('#tabstrip6').data("kendoTabStrip").wrapper.children(".k-tabstrip-items");

        var count = ul.children().length + 1;

        var total = 0;
        var DRF2001Tab = "tabstrip6-";
        var li_list = ul.find($("li[style!='display:none']"));

        var i = 0;
        for (i = numDXDC; i <= count; i++) {
            var tab = DRF2001Tab + i.toString();
            var numDXDC_width = li_list.filter("[aria-controls='" + tab + "']").width();
            total += numDXDC_width;
            if (ul.width() < total) {
                break;
            }

        }

        if (i == (count - 1)) {
            $(tabStrip.items()[numDXDC - 1]).attr("style", "display:none");
            $('#BtnPrevDXDC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
            $('#BtnNextDXDC').attr("style", "display:none");
        } else {
            $(tabStrip.items()[numDXDC - 1]).attr("style", "display:none");
            $(tabStrip.items()[numDXDC]).attr("style", "margin-left:35px");
            $('#BtnPrevDXDC').attr("style", "height: 30px;width: 35px; position: absolute; z-index: 1;");
        }

        numDXDC = numDXDC + 1;
    }
}