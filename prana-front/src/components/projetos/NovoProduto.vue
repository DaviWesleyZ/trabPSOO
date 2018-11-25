<template>
    <div>
        <v-dialog :value="novoProdutoDialog" @input="$emit('input')">
            <v-card class="pa-4">
                <v-form ref="formNovoProduto">      
                    <v-container grid-list-lg class="max-container">
                        <v-layout row wrap>
                            <v-flex xs12>
                                <h2>Novo Produto</h2>
                            </v-flex>

                            <v-flex xs3>
                                <v-text-field
                                    label="Codigo*"
                                    v-model="npCodigo"
                                    :rules="[v => !!v || 'Preencha esse campo!']"
                                ></v-text-field>
                            </v-flex>

                            <v-flex xs3>
                                <v-select
                                    label="Descrição*"
                                    v-model="npDesc"
                                    v-:rules="[v => !!v || 'Preencha esse campo!']"
                                ></v-select>
                            </v-flex>

                            <v-flex xs3>
                            <v-autocomplete
                                    label="Quantidade*"
                                    v-model="npQuantidade"
                                    :rules="[v => !!v || 'Preencha esse campo!']"
                                    
                                ></v-autocomplete>
                            </v-flex>

                            <v-flex xs3>
                                <v-text-field
                                    label="Valor*"
                                    v-model="npValor"
                                    :rules="[v => !!v || 'Preencha esse campo!']"
                                ></v-text-field>
                            </v-flex>
                        </v-layout>  
                    </v-container>
               
                    
                    <v-layout row wrap>
                        <v-flex md12 sm12 xs12  class="text-xs-right">
                            <v-btn 
                                color="primary" 
                                @click="criarProduto()"
                                :loading="criandoProduto"
                                >Criar
                            </v-btn>

                            <v-btn 
                                :disabled="criandoProduto" 
                                @click="$emit('input', false)"
                                >Cancelar
                            </v-btn>
                        </v-flex>
                    </v-layout>  
                    
                </v-form>
            </v-card>
        </v-dialog>    

         <v-dialog v-model="error" max-width="390">
            <v-alert :value="true" type="error" class="ma-0">
                {{errorMsg}}
            </v-alert>    
        </v-dialog>

        <v-dialog v-model="sucesso" max-width="390">
            <v-alert :value="true" type="success" class="ma-0">
                {{sucessoMsg}}
            </v-alert>    
        </v-dialog>

    </div>
</template>

<script>
export default {
    props: {
        value: Boolean,
        codigo: String,
        desc: String,
        quantidade: Number,
        valor: Number,
        },

    data() {
        return {

            npCodigo: this.codigo,
            npDesc: this.desc,
            npQuantidade: this.quantidade,
            npValor: this.valor,
            
            //dialogs
            sucesso: false,
            error: false,

            //loading
            criandoProduto: false,

            //msgs
            errorMsg: null,
            sucessoMsg: null,

            statusOpt: []

        }
    }, 

    watch: {
        'codigo': function() { this.npCodigo = this.codigo },
        'desc': function()  { this.npDesc = this.desc },
        'quantidade': function()  { this.npQuantidade = this.quantidade },
        'valor': function()  { this.npValor = this.valor },
         },

    computed: {
        novoProdutoDialog() {
            return this.value
        },
    },

    mounted() {
        if (this.usuariosOpts == null) {
            this.getUsuarios((usuarios) => {
                this.usuariosOpts = usuarios;
            })

        } 
        
        this.getProdutoStatusOpt((status)=> {
            this.statusOpt = status;
        });
        
    },

    methods: {
         criarProduto: function() {
            if (!this.$refs.formNovoProduto.validate()) return;

            this.criandoProduto = true;

            var json = {
                codigo:         this.npCodigo, 
                descricao:      this.npDesc, 
                quantidade:     this.npQuantidade, 
                valor:          this.npValor, 
                };

            this.novoProduto( json,
                (produto) => {
                    this.sucesso = true;
                    this.sucessoMsg = "Produto criado com sucesso!"
                    this.criandoProduto = false;
                    this.$emit('input', false);
                    this.$emit('produtoCriado', produto);

                    this.$refs.formNovoProduto.reset()
                    //resetando campos das tarefas quando o projeto for salvo
                }, 
                
                (error) => {
                    this.error = true;
                    this.errorMsg = error;
                    this.criandoProduto = false;
                });
        },

    }
}
</script>