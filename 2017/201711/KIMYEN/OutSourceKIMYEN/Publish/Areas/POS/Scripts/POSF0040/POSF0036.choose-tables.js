//####################################################################
//# Copyright (C) 2010-2011, ASOFT JSC.  All Rights Reserved. 
//#
//# History:
//#     Date Time       Updater         Comment
//#     25/06/2014      Thai Son        Tạo mới
//####################################################################

ASOFTCORE.create_module("choose-tables", function (sb) {
    var areaLabel = 'Khu vực',
        tables,
        btnChoose,
        btnClose,
        log = ASOFTCORE.log,
        // Tag <ul> chứa danh sách bàn Phòng lạnh
        tableUListP,
        // Tag <ul> chứa danh sách bàn sân Vườn
        tableUListV,
        that = this,
        selectedTable = null,
        selectedArea = null,
        areas = [],
        tables = [],
        // Danh sách đối tượng ajax Khu vực trả về từ server
        ajaxAreas = [],
        // Danh sách đối tượng ajax Bàn trả về từ server
        ajaxTables = [],
        areasDiv = null
    ;

    // Khởi tạo đối tượng Khu vực (từ entity POSF0031)
    function Area(ajaxArea) {
        var area = Object.create(ajaxArea),
            // Chuỗi html
            htmlString = '';

        // Danh sách các bàn của khu vực hiện tại
        area.numOfTable = 0;
        area.tables = [];
        htmlString = '<div class="grid_6 categories" id="{0}">'
                    + '<h3>{1}: {2}</h3>'
                    + '<div class="clear"></div>'
                    + '<ul id="{0}-list">'
                    + '</ul>'
                    + '</div>';

        // tạo chuỗi html để tạo đối tượng jQuery
        htmlString = htmlString.format(area.AreaID, areaLabel, area.AreaName);
        area.jElement = $(htmlString);

        // thêm một bàn vào khu vực
        area.addTable = function (table) {

            // Nếu bàn thuộc khu vực hiện tại, 
            // thì thêm vào danh sách bàn của khu vực
            if (table.AreaID === this.AreaID) {
                // Thểm jElement của bàn vào jElement của khu vực
                this.jElement.find('ul').append(table.jElement);
                this.tables.push(table);
                area.numOfTable++;
            }

        }

        return area;
    }

    // Khởi tạo đối tượng bàn  (từ entity POSF00361)
    function Table(ajaxTable) {
        var table = Object.create(ajaxTable),
            htmlString = '',
            jElement = null,
            cssClass = '';

        // Thêm class hiển thị màu tương ứng với trạng thái (HARD CODE)
        switch (table.StatusTableID) {
            case 0:
                cssClass = "white";
                break;
            case 1:
                cssClass = "orange";
                break;
            case 2:
                cssClass = "red";
                break;
            case 3:
                cssClass = "green";
                break;
            default:
                cssClass = "white";
                break;
        }

        // Tạo đối tượng jQuery của bàn
        jElement = $('<li>');
        jElement.attr('data-table-id', table.TableID);
        jElement.addClass('{0} asf-disabled-selection'.format(cssClass));
        jElement.text(table.TableID);

        // Gán sự kiện xử lý onclick
        // Khi người dùng click vào bàn, thì đánh dấu bàn được click (selected)
        jElement.on('click', function (e) {
            var i = 0;

            for (i = 0, l = tables.length; i < l; i += 1) {
                tables[i].jElement.removeClass('selected');
            }
            $(this).addClass('selected');
            selectedArea = table.Area;
            selectedTable = table;
        });

        // Gán sự kiện xửa lý double click
        // thực hiện chọn bàn được double click
        jElement.dblclick(function (e) {
            // Notify module content-master
            sb.notify({
                type: 'choose-table',
                data: {
                    table: table,
                    callBack: tableChoosen_Handler
                }
            });

            ASOFTCORE.globalVariables.currentTable = table;
        });

        table['jElement'] = jElement;

        // Phương thức thêm bàn hiện tại vào khu vực
        table.addToArea = function (areas) {
            var i = 0;
            // Duyện qua từng khu vực, nếu gặp đúng khu vực, thì thêm bàn vào
            for (i = 0, l = areas.length; i < l; i += 1) {
                if (areas[i].AreaID === this.AreaID) {
                    areas[i].addTable(this);
                    this.Area = areas[i];
                    break;
                }
            }
        };


        return table;
    }

    function compare(a, b) {
        return a.numOfTable - b.numOfTable;
    }

    // Sắp xếp danh sách @a, theo thuộc tính @prop
    // @asc = true nếu muốn sắp xếp tăng dần
    function bubbleSort(a, prop, asc) {
        var swapped;
        if (asc) {
            do {
                swapped = false;
                for (var i = 0; i < a.length - 1; i++) {
                    if (a[i][prop] > a[i + 1][prop]) {
                        var temp = a[i];
                        a[i] = a[i + 1];
                        a[i + 1] = temp;
                        swapped = true;
                    }
                }
            } while (swapped);
        } else {
            do {
                swapped = false;
                for (var i = 0; i < a.length - 1; i++) {
                    if (a[i][prop] < a[i + 1][prop]) {
                        var temp = a[i];
                        a[i] = a[i + 1];
                        a[i + 1] = temp;
                        swapped = true;
                    }
                }
            } while (swapped);
        }
    }
    // Thêm các khu vực vào DOM
    function addAreaToDom(areas) {
        var i = 0;
        
        areasDiv = $(sb.find('#areas-div', true)[0]);

        for (i = 0, l = areas.length; i < l; i += 1) {
            areasDiv.append(areas[i].jElement);
        }
    }

    // Tạo màn hình chọn bàn từ dữ liệu ajax trả về
    // @result chính là ErrorModel trả về từ server
    function createTablePanel(result) {
        var t = null,
            s = null,
            i = 0,
            l = 0,
            data = result.Data,
            areaObject = null,
            tableObject = null;

        // Gán 2 danh sách Khu vực, và Bàn vào biến của module
        ajaxAreas = data.AreaData;
        ajaxTables = data.TableData;

        // Tạo đối tượng Khu vực và thêm vào areas
        for (i = 0, l = ajaxAreas.length; i < l; i += 1) {
            areaObject = Area(ajaxAreas[i]);
            areas.push(areaObject);
        }

        // Duyệt danh sách bàn và thêm vào các khu vực tương ứng
        for (i = 0, l = ajaxTables.length; i < l; i += 1) {
            tableObject = Table(ajaxTables[i]);
            tableObject.addToArea(areas)
            tables.push(tableObject);
        }
        if (selectedTable) {
            for (i = 0, l = tables.length; i < l; i += 1) {
                if (tables[i].TableID === selectedTable.TableID) {
                    tables[i].jElement.addClass('selected');
                    break;
                }
            }
        }

        // Sắp xếp lại danh sách khu vực
        bubbleSort(areas, 'AreaName', true);
        bubbleSort(areas, 'numOfTable', false);

        // Thêm các khu vực vào DOM
        addAreaToDom(areas);
    }

    // Xử lý sự kiện sau khi chọn một bàn thành công
    function tableChoosen_Handler(data) {
        ASOFT.asoftPopup.hideIframe();
    }

    // Xử lý sau khi gửi yêu cầu kiểm tra một bàn có đang trống hay không
    function tryChooseTable_Handler(result) {
        // Nếu bàn trống, thì gửi yêu cầu chọn bàn

        sb.notify({
            type: 'choose-table', // content-master listens
            data: {
                Table: selectedTable,
                Area: selectedArea,
                TableInUse: result.Data.TableInUse,
                CallBack: tableChoosen_Handler
            }
        });

        closePopup();
    }

    // Xử lý sự kiện click vào nút 'chọn'
    function btnChoose_Click(e) {
        // Notify module content-master
        sb.notify({
            type: 'choose-table',
            data: {
                table: selectedTable,
                area: selectedArea,
                callBack: tableChoosen_Handler
            }
        });
        ASOFTCORE.globalVariables.currentTable = selectedTable;

    }

    // Đóng cửa sổ chọn bàn
    function btnClose_Click(e) {
        if (ASOFTCORE.globalVariables.fromButtonChoose) {
            ASOFT.asoftPopup.hideIframe();
        } else {
            if (window.parent !== window
                && window.parent.existFullScreen) {
                window.parent.existFullScreen();
                window.parent.ASOFT.asoftPopup.hideIframe();
            }
        }

    }

    return {

        destroy: function () {
            sb.ignore(['table-data-ready']);
            //input = button = reset = null;
        },

        init: function () {
            btnChoose = sb.find("#btnChoose", true)[0],
            btnClose = sb.find("#btnClose", true)[0];

            sb.addEvent(btnChoose, "click", btnChoose_Click);
            sb.addEvent(btnClose, "click", btnClose_Click);

            // Notify content-master
            sb.notify({
                type: 'get-current-table',
                data: {
                    callBack: function (table) {
                        selectedTable = table;
                        $('.asf-message').remove();
                    }
                }
            });

            // nofify server
            sb.notify({
                type: 'get-table-data',
                data: {
                    action: 'GetTableData',
                    controller: 'POSF0036',
                    queryString: '',
                    parameters: {},
                    callBack: createTablePanel
                }
            });

        },

    };
}, true);
