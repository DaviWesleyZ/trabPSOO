<template>
    <v-container fluid grid-list-md>
        <v-layout row wrap display-1 pa-2>
            <v-flex md12 sm12 xs12>
                Usuários
            </v-flex>
        </v-layout>
        
        <v-flex row pa-2>
           <v-card md12 pa-2>
               <v-card-title>
                    <v-btn 
                        color="primary"
                        @click="novoUsuarioDlg = true">
                        Novo Usuário
                    </v-btn>
                    <v-spacer></v-spacer>
                    <v-text-field
                        v-model="pesquisa"
                        append-icon="search"
                        label="Pesquisar"
                        single-line
                        hide-details
                    ></v-text-field>

                    <botao-filtro
                        v-model="showFiltro"
                        class="ml-4"
                    ></botao-filtro>

                    <filtro
                        v-model="filtros"
                        :itens="usuarios"
                        @itensFiltrados="usuariosFiltrados = $event"
                        :forceUpdate="updateFiltro"
                        :showFiltro="showFiltro">
                    </filtro>
    
                </v-card-title>

                <v-data-table
                    :headers="headers"
                    :items="usuariosFiltrados"
                    :search="pesquisa"
                    :loading="carregandoTabela"
                    class="compact"
                    item-key="id">
                    <template slot="items" slot-scope="{ item }">
                        <tr>
                            <td>{{ item.nome }}</td> 
                            <td>{{ item.eMail }}</td>
                            <td>{{ item.contato }}</td> 
                            <td>{{ item.perfil.nome }}</td>
                            <td>{{ item.cidade }}</td>
                            <td> 
                                <v-switch 
                                    :input-value="item.bloqueado"
                                    @click.prevent="inputBloqueado(item.id, item.bloqueado)"
                                    hide-details
                                    single-line
                                    style="max-width: 40px">
                                </v-switch>    
                            </td>
                            <td class="justify-center">
                                <v-tooltip bottom>
                                    <v-icon slot="activator" class="mr-2" @click="onResetSenhaDlg(item.id)">
                                        lock
                                    </v-icon>
                                    Resetar Senha
                                </v-tooltip>

                                <v-tooltip bottom>
                                    <v-icon slot="activator" @click="onEditaUsuarioDlg(item.id)">
                                        edit
                                    </v-icon>
                                    Editar
                                </v-tooltip>
                                
                            </td>
                        </tr>
                    </template>
                </v-data-table>
            </v-card>
        </v-flex>

         <v-dialog
            v-model="novoUsuarioDlg"
            max-width="800px">
            <v-card class="pa-4">
                <v-form ref="novoUsuarioForm">
                    <v-container class="max-container" grid-list-md >
                        <v-layout row wrap mb-2>
                            <v-flex>
                                <h3>Novo Usuário</h3>
                            </v-flex>
                        </v-layout>

                        <v-layout row wrap>
                            <v-flex xs4>
                                <v-text-field
                                    label="Username*"
                                    v-model="novoUsuario.username"
                                    prepend-icon="person"                                     
                                    :rules="[v => !!v || 'Preencha o username!']"
                                ></v-text-field>
                            </v-flex>

                            <v-flex xs4>
                                <v-text-field
                                    label="Senha*"
                                    v-model="novoUsuario.senha"
                                    :rules="[	v => !!v || 'Preencha a senha!',
                                                v => v && v.length >= 5 || 'Mínimo de 5 caracteres!']"
                                    validate-on-blur
                                    counter
                                    maxlength="20"
                                    hint="Mínimo de 5 caracteres"
                                    type="password"
                                ></v-text-field>
                            </v-flex>

                            <v-flex xs4>
                                 <v-text-field
                                    label="Senha de novo"
                                    lazy
                                    type="password"
                                    counter
                                    maxlength="20"
                                    validate-on-blur
                                    :rules="[	v => !!v || 'Preencha a senha!', 
                                                v => v == novoUsuario.senha || 'As senhas nao coincidem!']"
                                ></v-text-field>
                            </v-flex>

                        </v-layout>

                        <v-layout row wrap>
                            <v-flex xs4>
                                <v-text-field
                                    label="Contato (Cel)"
                                    v-model="novoUsuario.contato"
                                    mask="(##) #####-####"
                                    prepend-icon="smartphone" 
                                ></v-text-field>
                            </v-flex>
                            
                             <v-flex xs4>
                                 <v-autocomplete
                                    label="Perfil*"
                                    v-model="novoUsuario.perfil"
                                    item-value="id"
                                    item-text="nome"
                                    :items="perfilsOpt"
                                    :rules="[v => !!v || 'Preencha o perfil!']">

                                 </v-autocomplete>
                            </v-flex>

                            <v-flex xs4>
                                <v-text-field
                                    label="Nome*"
                                    v-model="novoUsuario.nome"
                                    :rules="[v => !!v || 'Preencha o nome!']"
                                ></v-text-field>
                            </v-flex>

                        </v-layout>

                        <v-layout row wrap>
                             <v-flex xs4>
                                <v-text-field
                                    label="Email"
                                    v-model="novoUsuario.eMail"
                                    type="email"
                                    prepend-icon="email" 
                                ></v-text-field>
                            </v-flex>

                            <v-flex xs4>
                                <v-text-field
                                    label="Cidade"
                                    v-model="novoUsuario.cidade"
                                ></v-text-field>
                            </v-flex>
                        </v-layout>

                        <v-layout row wrap>
                            <v-spacer></v-spacer>
                            <v-flex xs12 class="text-xs-right"> 
                                <v-btn @click="novoUsuarioDlg = false">cancelar</v-btn>

                                <v-btn 
                                    color="primary"
                                    @click="criarUsuario"
                                >Criar</v-btn>
                            </v-flex>
                        </v-layout>  
                    </v-container>
                </v-form>
            </v-card>
            
        </v-dialog>

        <v-dialog
            v-model="editaUsuarioDlg"
            max-width="800px">
            <v-card class="pa-4">
                <v-container grid-list-md class="max-container">
                    <v-layout row wrap mb-2>
                        <v-flex>
                            <h3>Editar Usuario: {{ (editaUsuarioSemMudanca) ? editaUsuarioSemMudanca.nome : "" }}</h3>
                        </v-flex>
                    </v-layout>

                    <v-layout row wrap>
                        <v-flex xs4>
                            <v-text-field
                                label="Nome"
                                v-model="editaUsuario.nome"
                                @input="editaUsuarioMudancas.nome = $event"
                            ></v-text-field>
                        </v-flex>

                        <v-flex xs4>
                            <v-text-field
                                label="Contato"
                                mask="(##) #####-####"
                                prepend-icon="smartphone" 
                                v-model="editaUsuario.contato"
                                @input="editaUsuarioMudancas.contato = $event"
                            ></v-text-field>
                        </v-flex>

                        
                         <v-flex xs4>
                            <v-text-field
                                label="Cidade"
                                v-model="editaUsuario.cidade"
                                @input="editaUsuarioMudancas.cidade = $event">
                            </v-text-field>
                        </v-flex>
                    </v-layout>

                    <v-layout row wrap>
                         <v-flex xs4>
                            <v-autocomplete
                                label="Perfil"
                                :items="perfilsOpt"
                                item-value="id"
                                item-text="nome"
                                v-model="editaUsuario.perfil"
                                @input="editaUsuarioMudancas.perfil = $event">
                            </v-autocomplete>
                        </v-flex>

                        <v-flex xs8>
                            <v-text-field
                                label="Email"
                                type="id"
                                prepend-icon="email" 
                                v-model="editaUsuario.eMail"
                                @input="editaUsuarioMudancas.eMail = $event"
                            ></v-text-field>
                        </v-flex>
                       
                    </v-layout>

                     <v-layout row wrap>
                            <v-spacer></v-spacer>
                            <v-flex xs12 class="text-xs-right"> 
                                <v-btn @click="editaUsuarioDlg = false">cancelar</v-btn>

                                <v-btn 
                                    color="primary"
                                    @click="onEditarUsuario"
                                    :disabled="!editaUsuarioTeveMudanca"
                                >Salvar</v-btn>
                            </v-flex>
                        </v-layout>  
                </v-container>
            </v-card>
        </v-dialog>

        <v-dialog
            v-model="resetaSenhaDlg"
            max-width="500px"
            persistent>
            <v-card class="pa-2">
                <v-form ref="resetSenhaForm">
                    <v-container grid-list-md class="max-container">
                        <v-layout row wrap>
                            <v-flex>
                                <h2>Troca de Senha</h2>
                            </v-flex>
                        </v-layout>

                        <v-layout row wrap px-4>
                            <v-flex xs12>
                                <v-text-field
                                    label="Senha"
                                    v-model="resetaSenha.senhaN"
                                    :rules="[	v => !!v || 'Preencha a senha!',
                                                v => v && v.length >= 5 || 'Mínimo de 5 caracteres!']"
                                    validate-on-blur
                                    counter
                                    maxlength="20"
                                    hint="Mínimo de 5 caracteres"
                                    type="password"
                                ></v-text-field>

                                <v-text-field
                                    label="De novo"
                                    lazy
                                    type="password"
                                    counter
                                    maxlength="20"
                                    validate-on-blur
                                    :rules="[	v => !!v || 'Preencha a senha!', 
                                                v => v == resetaSenha.senhaN || 'As senhas nao coincidem!']"
                                ></v-text-field>
                            </v-flex>
                        </v-layout>

                        <v-layout row wrap mt-2>
                            <v-flex text-xs-right>
                                <v-btn @click="resetaSenhaDlg = false">cancelar</v-btn>
                                <v-btn 
                                    color="primary"
                                    @click="onResetSenha"
                                >trocar</v-btn>
                            </v-flex>
                        </v-layout>

                    </v-container>
                </v-form>
            </v-card>
        </v-dialog>

        <v-dialog
            :value="aviso || avisoError" 
            @input="aviso = $event; avisoError = $event"  
            max-width="390">
            <v-alert :value="true" :type="(avisoError) ? 'error' : 'success'" class="ma-0">
                {{avisoMsg}}
            </v-alert>    
        </v-dialog>


        <v-snackbar 
            :value="avisoSnack || avisoSnackError" 
            @input="avisoSnack = $event; avisoSnackError = $event" 
            :color="(avisoSnackError) ? 'error' : ''">
            {{ avisoSnackMsg }}
            <v-btn flat @click="avisoSnack = false">
                Fechar
            </v-btn>
        </v-snackbar>

    </v-container>

</template>

<script>

export default {

    data() {
        return {
            pesquisa: "",
            carregandoTabela: true,

            novoUsuarioDlg: false,
            editaUsuarioDlg: false,
            resetaSenhaDlg: false,

            resetaSenha: {
                usuario: "",
                senhaN: ""
            },

            novoUsuario: {
                username: "",
                senha: "",
                perfil: "",
                nome: "",
                contato: "",
                eMail: "",
                cidade: ""
            },

            editaUsuario: {},

            //para somente enviar no json os campos q mudaram
            editaUsuarioMudancas: {
                id: "",
                nome: "",
                contato: "",
                eMail: "",
                cidade: "",
                perfil: ""
            },
            editaUsuarioSemMudanca: {},
            editaUsuarioTeveMudanca: false,

            filtros: [
                { text: 'Perfil',         campo: 'perfil', campoValue: 'id', campoText: 'nome'},
                { text: 'Cidade',         campo: 'cidade'},
            ],

            headers: [
                { text: 'Nome',     value: 'nome' },
                { text: 'eMail',    value: 'eMail' },
                { text: 'Contato',  value: 'contato' },
                { text: 'Perfil',   value: 'perfil.nome' },
                { text: 'Cidade',   value: 'cidade' },
                { text: 'Bloqueado',   value: 'bloqueado' },
                { text: 'Ações',   value: 'acoes' },
            ],

            usuarios: [],

            perfilsOpt: [],

            //avisos intrusivos
            aviso: false,
            avisoError: false,
            avisoMsg: "",

            //avisos de baixo
            avisoSnack: false,
            avisoSnackError: false,
            avisoSnackMsg: "",

            //msgs
            errorMsg: null,
            sucessoMsg: null,
            avisoMsg: null,

            usuariosFiltrados: [],
            updateFiltro: 0,
            showFiltro: false,
        }
    },

    mounted() {
        if (this.$cookies.get("het_perfil") == "Analista") {
            this.$router.push("Painel")
        }

        this.getUsuarios(usuarios => {
            this.usuarios = usuarios;
            this.carregandoTabela = false;
        });

        this.getPerfis((perfil) => {
            this.perfilsOpt = perfil;
        })
    },
    
    watch: {
        'editaUsuarioMudancas': {
            handler: function(old, val) {         
                    if (this.editaUsuarioDlg) {
                        if (!isEqual(this.editaUsuarioSemMudanca, this.editaUsuario)) {
                            console.log("mudansa true");
                            
                            this.editaUsuarioTeveMudanca = true;
                        } else {
                            this.editaUsuarioTeveMudanca = false;
                        }

                    } 
            },
            deep: true
        },

        "editaUsuarioDlg": function() {
            if (!this.editaUsuarioDlg) {
                 this.editaUsuarioMudancas = {
                    id: "",
                    nome: "",
                    contato: "",
                    eMail: "",
                    cidade: "",
                    perfil: ""
                };

                this.editaUsuarioTeveMudanca = false;
            }
        }
    },

    methods: {
        criarUsuario: function() {
            if (!this.$refs.novoUsuarioForm.validate()) return;

            this.ciarUsuario(this.novoUsuario, 
                (usuario) => {
                    this.usuarios.push(usuario);

                    this.avisoMsg = "Usuário criado com sucesso!"
                    this.aviso = true;
                    this.novoUsuarioDlg = false;
                }, 
                (error) => {
                    this.avisoError = true;
                    this.avisoMsg = error;
                })
            
        },

        inputBloqueado(id, val) {
            if (this.carregandoTabela) return;
            this.carregandoTabela = true;


            this.bloquearUsuario(id, !val,
                (usuario) => {
                    
                    //this.usuarios[this.usuarios.findIndex(el => el.id == id)].bloqueado = usuario.bloqueado;
                    this.avisoSnack = true;
                    this.avisoSnackMsg = (!val) ? usuario.nome+" bloqueado com sucesso!" : usuario.nome+" desbloqueado com sucesso!";
                    this.usuarios.find(el => el.id == usuario.id).bloqueado = usuario.bloqueado;
                    this.usuarios = this.usuarios.slice(0)

                    this.carregandoTabela = false;
                },
                (error) => {
                    this.avisoSnackError = true;
                    this.avisoSnackMsg = error;
                    this.carregandoTabela = false;
                })
           
        },

        onEditaUsuarioDlg: function(id)  {
            let usuaio = this.usuarios.find(el => el.id == id)
            
            this.editaUsuario.nome = usuaio.nome;
            this.editaUsuario.perfil = usuaio.perfil.id;
            this.editaUsuario.contato = usuaio.contato;
            this.editaUsuario.cidade = usuaio.cidade;
            this.editaUsuario.eMail = usuaio.eMail;
            this.editaUsuario.id = usuaio.id;

            this.editaUsuarioSemMudanca = clone(this.editaUsuario)

            this.editaUsuarioMudancas.usuario = id;

            this.editaUsuarioDlg = true    
        },

        onEditarUsuario: function() {
            this.editarUsuario(this.editaUsuarioMudancas, 
                (usuario) => {
                    this.usuarios[this.usuarios.findIndex(el => el.id == usuario.id)] = usuario;
                    this.usuarios = this.usuarios.slice(0);

                    this.editaUsuarioDlg = false;

                    this.aviso = true;
                    this.avisoMsg = usuario.nome+" foi editado com sucesso!";
                },
                (error) => {
                    this.avisoError = true;
                    this.avisoMsg = error;
                })
               
        },

        onResetSenhaDlg: function(id) {
            this.resetaSenhaDlg = true;
            this.resetaSenha.usuario = id;
        },

        onResetSenha: function() {
            if (!this.$refs.resetSenhaForm.validate()) return;

            this.resetarSenhaUsuario(this.resetaSenha.usuario, this.resetaSenha.senhaN,
                (usuario) => {
                    this.aviso = true;
                    this.avisoMsg = "Senha alterada com sucesso!"
                    this.resetaSenhaDlg = false
                },
                (error) => {
                    this.avisoError = true;
                    this.avisoMsg = error
                })
        }
    }

}
</script>