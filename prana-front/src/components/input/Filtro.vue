<template>
    <transition name="slide-y-transition">
        <v-container  v-if="showFiltro" grid-list-md ma-0 px-0 style="max-width: 100%">
            <v-layout row wrap>
                <v-flex v-for="filtro in filtros" :key="filtro.campo" mb-2
                    :class="{'md4': filtro.type == 'date', 'xs6': filtro.type == 'date',
                            'md2': filtro.type != 'date', 'xs3': filtro.type != 'date',}">
                    <v-select 
                        v-if="filtro.type == 'select' || typeof filtro.type == 'undefined'"
                        :label="filtro.text"
                        clearable
                        hide-details
                        :items="opts[filtro.campo]"
                        :item-text="filtro.campoText"
                        :item-value="filtro.campoText"
                        :value="filtro.value"
                        @input="inputFilter(filtro.campo, $event)">
                    </v-select>

                    <v-autocomplete
                        v-if="filtro.type == 'autocomplete'"
                        :label="filtro.text"
                        clearable
                        hide-details
                        :value="filtro.value"
                        :item-text="filtro.campoText"
                        :item-value="filtro.campoText"
                        :items="opts[filtro.campo]"
                        @input="inputFilter(filtro.campo, $event)">
                    </v-autocomplete>

                    <v-layout ma-0 pa-0>
                        <v-flex xs6>
                            <het-date-picker
                                v-if="filtro.type == 'date'"
                                clear
                                clearable
                                hide-details
                                :label="filtro.text + ' depois de'"
                                :value="filtro.dataDepois"
                                @input="inputFilter(filtro.campo, $event, 'depois')">
                            </het-date-picker>
                        </v-flex>

                        <v-flex xs6>
                            <het-date-picker
                                v-if="filtro.type == 'date'"
                                clear
                                clearable
                                hide-details
                                :label="filtro.text + ' antes de'"
                                :value="filtro.dataAntes"
                                @input="inputFilter(filtro.campo, $event, 'antes')">
                            </het-date-picker>
                        </v-flex>
                    </v-layout>
                        
                </v-flex>
            </v-layout>
        
        </v-container>
     </transition>
</template>

<script>
export default {
    props: {
        itens: {
            type: Array,
            required: true,
        },

        value: {
            type: Array,
            required: true
        },

        forceUpdate: Number,
        
        showFiltro: {
            type: Boolean,
            default: true,
        }
    },

    data() {
        return {
            opts: {},
            filtros: [],
        }
    },

    watch: {
        'forceUpdate': function() {
            this.update();
        },

        'itens': function() {
            this.update();            
        },

        'showFiltro': function() {
            this.$emit('itensFiltrados', this.filtrar()); 
        },

        'value': function() {
            this.filtros = this.value;  
        }
    },

    mounted() {
        this.filtros = this.value;
    },

    methods: {
        filtrar: function() {
            if (!this.showFiltro) {
                return this.itens;
            }
            
            return this.itens.filter((item) => {

                var status = true;

                this.filtros.forEach(filtro => {
                    
                    if (typeof filtro.type !== 'undefined' && filtro.type == 'date') {
                        let [diaI, mesI, anoI] = item[filtro.campo].split("/");
                        var dataItem = new Date(anoI, mesI-1, diaI)

                        if (typeof filtro.dataAntes != "undefined" && filtro.dataAntes != null && filtro.dataAntes != "") {
                            // tem data antes
                            let [diaA, mesA, anoA] = filtro.dataAntes.split("/");   
                            var dataAntes = new Date(anoA, mesA-1, diaA)

                            status = status && dataAntes.getTime() >= dataItem.getTime();
                        }

                        if (typeof filtro.dataDepois != "undefined" && filtro.dataDepois != null && filtro.dataDepois != "") {
                            // tem data antes
                            let [diaD, mesD, anoD] = filtro.dataDepois.split("/");   
                            var dataDepois = new Date(anoD, mesD-1, diaD)
                            
                            status = status && dataDepois.getTime() <= dataItem.getTime();
                        }


                    } else {
                        if (typeof filtro.value == 'undefined' || filtro.value == null || filtro.value == "") return;

                        if (typeof filtro.campoText != "undefined" && filtro.campoText != "" && filtro.campoText != null) {
                            status = status && item[filtro.campo][filtro.campoText] == filtro.value;

                        } else {
                            status = status && item[filtro.campo] == filtro.value;
                        }
                    }
                });


                return status;
            })

        },

        inputFilter: function(campo, valor, dateType) {
            let filtroAtual = this.filtros.find(el => el.campo == campo);
           

            if (typeof filtroAtual.type != "undefined" && filtroAtual.type == 'date') {
                if (dateType == 'antes') {
                    filtroAtual.dataAntes = valor;

                } else {
                    filtroAtual.dataDepois = valor;
                }

            } else {
                 filtroAtual.value = valor;
            }

            this.$emit('itensFiltrados', this.filtrar());
            this.$emit('inputFiltro', { campo, valor })
            
        },

        atualizaOpts: function() {

            this.opts = {};

            this.itens.forEach(item => {
                this.filtros.forEach(filtro => {
                    if (typeof filtro.type == 'undefined' || filtro.type !== 'date') {
                        if (typeof this.opts[filtro.campo] == "undefined") this.opts[filtro.campo] = [];
                        this.opts[filtro.campo].push(item[filtro.campo])
                    }
                });
            });
        },

        update: function() {
            this.atualizaOpts()
            this.$emit('itensFiltrados', this.filtrar());
        }
    }
}
</script>



