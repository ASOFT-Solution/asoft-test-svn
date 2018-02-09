function createCustomButton(type, id, onClickFunc) {
    let template = document.createElement('a');
    switch (type) {
        case 1: {
            template.id = id + "-attachFile";
            template.onclick = onClickFunc;
            template.className = "k-button k-button-icontext asf-button";
            template.style = {
                "min-width": "35px",
                "margin-left": "5px"
            }
            template.setAttribute("role", "button");
            template.setAttribute("data-role", "button");
            template.setAttribute("aria-disabled", false);
            template.setAttribute("tabindex", 0);
            const span = document.createElement('span');
            span.className = "asf-button-text";
            template.appendChild(span);
            // template = `<a id="${id + "-attachFile"}" class="k-button k-button-icontext asf-button" 
            // data-role="button" role="button" style="min-width:35px; margin-left:5px;" aria-disabled="false" tabindex="0">
            // <span class="asf-button-text" onclick="${onClickFuncName}">...</span></a>`;
            break;
        }
        case 2: {
            template.id = id + "-deleteFile";
            template.onclick = onClickFunc;
            template.style = {
                "height": "16px"
            }
            template.setAttribute("role", "button");
            template.setAttribute("data-role", "button");
            template.setAttribute("aria-disabled", false);
            template.setAttribute("tabindex", 0);
            const span = document.createElement('span');
            span.className = "k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton";
            span.style = {
                "height": "16px"
            };
            template.appendChild(span);

            // template = `<a id='${id + "-deleteFile"}' onclick='${onClickFuncName}' aria-disabled='false' tabindex='0' data-role='button' role='button' style='height: 16px;'><span style='height: 16px' class='k-sprite asf-icon asf-icon-32 asf-i-delete-32 disabledButton'></span></a>`;
            break;
        }
    }
    return template;
}

function attachClick(urlAttachFilePopup) {
    return function () {
        ASOFT.asoftPopup.showIframe(urlAttachFilePopup, {});
    }
}


function deleteClick(id) {
    return function () {

        $(".templeteAll").remove();

        $(id).val("").trigger("change");
    }
}

class ASOFTAttachFile {

    constructor(data = {
        id: String,
        urlAttachFilePopup: String
    }) {
        if (typeof data.id === 'undefined') {
            throw new Error(`data.id is cannot undefined`)
        }

    }

    Execute() {
        const attachButton = createCustomButton(1, data.id, attachClick(data.urlAttachFilePopup));
        const deleteButton = createCustomButton(2, data.id, deleteClick(data.id));
        $("#" + data.id).parent()
            .append(attachButton)
            .append(deleteButton);
    }
}


define(function () {
    return {
        ASOFTAttachFile
        };
});