
$(document).ready(function () {
    if (ASOFTEnvironment.CustomerIndex.OKIA == "True") {
        var str = ASOFT.helper.getLanguageString("POSF00761.TitleOKIA", "POSF00761", "POS");
        $("#popupInnerIframe_wnd_title").text(str + " - POSF00761");
    }
})