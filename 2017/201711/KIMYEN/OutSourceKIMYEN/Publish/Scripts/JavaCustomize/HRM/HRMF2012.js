var DivTagAgeOrSalary = "<div id='{0}'>" +
        "<div class='block-left 1' style = 'width: 30%'>" +
            "<div class='asf-filter-label' style ='width:100%;'>{1}</div>" +            
        "</div>" +
        "<div class='block-left 2' style = 'width: 35%'>" +
            "<div class='asf-filter-label 1' style ='width:30%;'></div>" +
            "<div class='asf-filter-label 2' style ='width:70%;'></div>" +
        "</div>" +
        "<div class='block-right' style = 'width: 35%'>" +
            "<div class='asf-filter-label 1' style ='width:30%;'></div>" +
            "<div class='asf-filter-label 2' style ='width:70%;'></div>" +
        "</div>" +
    "</div>";

$(document).ready(function () {

    $.ajax({
        url: '/HRM/HRMF2010/TemplateViewHRMF2012',
        type: "GET",
        async: false,
        success: function (result) {
            $("#HRMF2012_TabInfo-1 .asf-master-content").append(result);
            LayoutControl();
        }
    });
    CheckCanEdit();

    if (ASOFTEnvironment.CustomerIndex.MinhTri == 'True') {
        $("#BtnPrint").unbind();
        $("#BtnPrint").kendoButton({
            "click": PrintClick_MinhTri,
        });
    }
    else {
        $("#BtnPrint").removeClass('asfbtn-item-32').css('display', 'none');
    }
});

// Layout control
function LayoutControl() {

    // Table 1
    $("#Require1 table tbody").append($(".Gender").parent());    
    $("#Require1 table tbody").append($(".FromAge").parent());    
    $("#Require1 table tbody").append($(".ToAge").parent());
    $(".FromAge").parent().css('display', 'none');
    $(".ToAge").parent().css('display', 'none');

    $("#Require1").append(kendo.format(DivTagAgeOrSalary, "divAge", $("#lblAge").html()));
    var divAge = $($(".FromAge").parent()).find('td');
    $("#divAge .block-left.2 .asf-filter-label.1").append(divAge[0].innerText + ' :');
    $("#divAge .block-left.2 .asf-filter-label.2").append(divAge[2].innerText);

    divAge = $($(".ToAge").parent()).find('td');
    $("#divAge .block-right .asf-filter-label.1").append(divAge[0].innerText + ' :');
    $("#divAge .block-right .asf-filter-label.2").append(divAge[2].innerText);

    $("#divAge .block-left.1").css('border-bottom', '1px dotted gainsboro');
    $("#divAge .block-left.2").css('border-bottom', '1px dotted gainsboro');
    $("#divAge .block-right").css('border-bottom', '1px dotted gainsboro');
    
    // Table 2
    $("#Require2 table tbody").append($(".Appearance").parent());
    $("#Require2 table tbody").append($(".EducationLevelID").parent());

    // Table 3
    $("#Require3 table tbody").append($(".Experience").parent());
    $("#Require3 table tbody").append($(".FromSalary").parent());
    $("#Require3 table tbody").append($(".ToSalary").parent());
    $(".FromSalary").parent().css('display', 'none');
    $(".ToSalary").parent().css('display', 'none');

    $("#Require3").append(kendo.format(DivTagAgeOrSalary, "divSalary", $("#lblSalary").html()));
    var divSalary = $($(".FromSalary").parent()).find('td');
    $("#divSalary .block-left.2 .asf-filter-label.1").append(divSalary[0].innerText + ' :');
    $("#divSalary .block-left.2 .asf-filter-label.2").append(divSalary[2].innerText);

    divSalary = $($(".ToSalary").parent()).find('td');
    $("#divSalary .block-right .asf-filter-label.1").append(divSalary[0].innerText + ' :');
    $("#divSalary .block-right .asf-filter-label.2").append(divSalary[2].innerText);

    $("#divSalary .block-left.1").css('border-bottom', '1px dotted gainsboro');
    $("#divSalary .block-left.2").css('border-bottom', '1px dotted gainsboro');
    $("#divSalary .block-right").css('border-bottom', '1px dotted gainsboro');

    $("#WorkDescription table tbody").append($(".WorkDescription").parent());
    $("#WorkDescription .content-label").css('width', '10%');
    $("#WorkDescription .dot").css('width', '2%');
    $("#WorkDescription .content-text").css('width', '87%');

    // Yeu cau cong viec
    // Lang 1
    $("#fieldRequireLang1 table tbody").append($(".Language1ID").parent());
    $("#fieldRequireLang1 table tbody").append($(".LanguageLevel1ID").parent());

    // Lang 2
    $("#fieldRequireLang2 table tbody").append($(".Language2ID").parent());
    $("#fieldRequireLang2 table tbody").append($(".LanguageLevel2ID").parent());

    // Lang 3
    $("#fieldRequireLang3 table tbody").append($(".Language3ID").parent());
    $("#fieldRequireLang3 table tbody").append($(".LanguageLevel3ID").parent());

    $("#fieldRequireWork1 table tbody").append($(".IsInformatics").parent());
    $("#fieldRequireWork1 table tbody").append($(".InformaticsLevel").parent());
    $("#fieldRequireWork1 table tbody").append($(".IsCreativeness").parent());
    $("#fieldRequireWork1 table tbody").append($(".Creativeness").parent());
    $("#fieldRequireWork1 table tbody").append($(".IsProblemSolving").parent());
    $("#fieldRequireWork1 table tbody").append($(".ProblemSolving").parent());
    $("#fieldRequireWork1 table tbody").append($(".IsPrsentation").parent());
    $("#fieldRequireWork1 table tbody").append($(".Prsentation").parent());
    $("#fieldRequireWork1 table tbody").append($(".IsCommunication").parent());
    $("#fieldRequireWork1 table tbody").append($(".Communication").parent());
    $("#fieldRequireWork1 .content-label").css('white-space', 'pre-line');
    $("#fieldRequireWork1 .dot").css('width', '2%');
    $("#fieldRequireWork1 .content-text").css('white-space', 'pre-line');

    // Yeu cau suc khoe
    // Lang 1
    $("#fieldRequireHealth1 table tbody").append($(".Height").parent());

    // Lang 2
    $("#fieldRequireHealth2 table tbody").append($(".Weight").parent());

    // Lang 3
    $("#fieldRequireHealth3 table tbody").append($(".HealthStatus").parent());

    $("#fieldNotes table tbody").append($(".Notes").parent());
    $("#fieldNotes .content-label").css('width', '10%');
    $("#fieldNotes .dot").css('width', '2%');
    $("#fieldNotes .content-text").css('width', '87%');

    $($(".DutyName").parent().parent()).prepend($(".RecruitRequireName").parent());
}

function CheckCanEdit() {
    var url = new URL(window.location.href);
    var pk = url.searchParams.get("PK");
    $.ajax({
        url: '/HRM/HRMF2010/CheckUpdateData?RecruitRequireID=' + pk + "&DivisionID=" + $(".DivisionID.content-text").html() + "&Mode=0",
        success: function (result) {
            if (result.CanEdit == 0) {
                $("#BtnEdit").parent().addClass('asf-disabled-li');
            }
        }
    });
}

/**  
* Print custom data
*
* [Kiều Nga] Create New [03/01/2018]
**/
function PrintClick_MinhTri(e) {

    var dataFilter = CustomDataPrint();
    var url = '/HRM/HRMF2010/DoPrintOrExport';
    isPrint = true;
    ASOFT.helper.postTypeJson(url, dataFilter, ExportSuccess_MinhTri);
}

function ExportSuccess_MinhTri(result) {
    if (result) {
        var urlPrint = '/HRM/HRMF2010/ReportViewer';
        var urlExcel = '/HRM/HRMF2010/ExportReport';
        //var urlPost = isPrint ? urlPrint : urlExcel;
        //var options = isPrint ? '&viewer=pdf' : '';
        var urlPost;
        var options = '';

        if (isPrint) {
            urlPost = !isMobile ? urlPrint : urlExcel;
            options = !isMobile ? '&viewer=pdf' : '&viewer=pdf&mobile=mobile';
        }
        else
            urlPost = urlExcel;

        var RM = '&Module=HRM&ScreenID=HRMF2012&project=MinhTri';
        // Tạo path full
        var fullPath = urlPost + "?id=" + result.apk + options + RM;

        if (isPrint)
            if (!isMobile)
                window.open(fullPath, "_blank");
            else
                window.location = fullPath;
        else {
            window.location = fullPath;
        }
    }
}

/**  
* Custom DataPrint
*
* [Kiều Nga] Create New [03/01/2018]
**/
function CustomDataPrint() {
    var dataFilter = {};

    var url_string = window.location.href;
    var url = new URL(url_string);
    var RecruitRequireID = url.searchParams.get("PK");
    var DivisionID = url.searchParams.get("DivisionID");
    dataFilter.DivisionList = DivisionID;

    dataFilter.RecruitRequireID = RecruitRequireID;
    dataFilter.DutyID = $(".DutyID").text();
    dataFilter.Disabled = $(".Disabled").text();
    dataFilter.dataRecruitRequireID = RecruitRequireID;
    dataFilter.dataDivisionID = dataFilter.DivisionList;
    if (dataFilter.Disabled == undefined || dataFilter.Disabled == "" || dataFilter.Disabled == "Không")
        dataFilter.Disabled = "0";
    dataFilter.IsCheckAll = 0;
    return dataFilter;
}