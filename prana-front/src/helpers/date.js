import Vue from "vue";

Vue.mixin({
    methods: {
        formatData: function(date) {
            let dia = date.getDate();
             if (dia < 10) dia = "0" + dia;
            let mes = date.getMonth() + 1;
            if (mes < 10) mes = "0" + mes;
            let ano = date.getFullYear();
            return dia + "/" + mes + "/" + ano;
        }
    }
})