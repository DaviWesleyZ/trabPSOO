<template>
     <v-menu
        transition="scale-transition"
        offset-y
        full-width
        min-width="0px"
        id="teste"
        :close-on-content-click="false"
        v-model="menu"
        >
         <v-text-field
            slot="activator"
            readonly
            :value="dataModel"
            @input="formatDate"

            :label="label"
            :hide-details="hideDetails"
            :single-line="singleLine"
            :rules="rules"
            :clearable="clearable"
        ></v-text-field>

        <v-date-picker 
            :value="date"
            no-title 
            scrollable
            :allowed-dates="allowedDates"
            locale="pt-br"
            @input="formatDate($event)"
            
            >
        </v-date-picker>
    </v-menu>

</template>

<script>
export default {
    props: {
        value: String,
        label: String,
        hideDetails: Boolean,
        singleLine: Boolean,
        rules: Array,
        clear: Boolean,
        clearable: Boolean,
        allowedDates: Function,
        
    },

    data() {
        return {
            date: "",
            dataModel: "",
            menu: false
        }
    },

    mounted() {
        if (!this.clear)
            this.setDayToday()

        if (typeof this.value != "undefined" && this.value != null && this.value != "") {
            this.dataModel = this.value;
            const [dia, mes, ano] = this.value.split('/');
            this.date = ano+"-"+mes+"-"+dia;
        }
    },

    watch: {
        'value': function() {
            if (typeof this.value == "undefined" || this.value == null || this.value == "" || this.value.indexOf("/") < 0) {
                //data invalida
                this.dataModel = "";
                this.date = "";
                return;

            } else {
                const [dia, mes, ano] = this.value.split('/');
                this.date = ano+"-"+mes+"-"+dia;
                this.dataModel = this.value;
            } 
        }
    },

    methods: {
        formatDate: function(date) {
            this.menu = false;

            if (date == null) {
                 this.$emit('input', "");
                 return;
            } 

            const [ano, mes, dia] = date.split('-');
            this.dataModel = dia+"/"+mes+"/"+ano;
            this.$emit('input', this.dataModel);
            
        },

        setDayToday: function (){
            let hoje = new Date();

            let dia = hoje.getDate();
            if (dia < 10) dia = "0" + dia;

            let mes = hoje.getMonth();
            mes++;
            if (mes < 10) mes = "0" + mes;

            this.dataModel = dia + "/" + mes + "/" + hoje.getFullYear();

            this.$emit('input', this.dataModel);
        }

    }
}
</script>

