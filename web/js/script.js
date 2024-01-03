const app = new Vue({
    el: '#app',

    data: {
        nomeRisorsa : GetParentResourceName(),

        locales : {},

        textSettings : {
            text : "abcdefgh",
            color : "#ffffff",
        },

        notifySettings : {
            text : "",
            enable : false,
        }
    },

    methods: {
        postNUI(name, table) {
            $.post(`https://${this.nomeRisorsa}/${name}`, JSON.stringify(table));
        },

        notification(text) {
            if(this.notifySettings.enable) {
                return
            }

            this.notifySettings.text = text
            this.notifySettings.enable = true
            setTimeout(() => {
                this.notifySettings.enable = false
            }, 3000);
        },

        viewColorInput() {
            $("#inputColor").click()
        },

        saveText() {
            this.postNUI("saveText", this.textSettings)
            this.notification(this.locales.text_edited)
        },

        checkText(event) {
            var string = this.textSettings.text
            var length = string.length
            if(length > 7) {
                event.preventDefault()
                return false
            }
            event.key = event.key.toUpperCase()
            var allowedWorld = [" ", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "M", "L", "N", "O", "P", "Q", "R", "S", "T", "V", "Z", "X", "Y", "W", "U", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j" , "k", "m", "l", "n", "o", "p", "q", "r", "s", "t", "v", "z", "x", "y", "w", "u"]
            if(!allowedWorld.includes(event.key)) {
                event.preventDefault()
                return false
            }
        }
    }

});


window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {

        if(!data.color || data.color.length == 0 || !data.color.startsWith("#")) {
            data.color = "#ffffff"
        }

        app.textSettings.color = data.color
        app.textSettings.text = data.text 
        $("#app").fadeIn(500)
    } else if(data.type === "UPDATE") {

        if(!data.color || data.color.length == 0 || !data.color.startsWith("#")) {
            data.color = "#ffffff"
        }

        app.textSettings.color = data.color
        app.textSettings.text = data.text 
    } else if(data.type === "SET_LOCALES") {
        app.locales = data.locales
    }
})

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        $("#app").fadeOut(500)
        app.postNUI("close")
    } else if(data.key == 'Enter') {
        app.saveText()
    }
};
