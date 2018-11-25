import Vue from "vue";

Vue.mixin({
    methods: {
        getPerfil: function(callbackSuccess) {
			this.post(this.API.USUARIOS.PERFIL, 
                {username: this.$cookies.get("het_username")},
                (response) => {
                    callbackSuccess(response.data.perfil);
                })
			   
       },

       getPerfis: function(callbackSuccess) {
        this.get(this.API.USUARIOS.PERFIS, 
            (response) => {
                callbackSuccess(response.data.perfis);
            })
           
   },
       
       getUsuarios: function(callbackSuccess) {
         this.get(this.API.USUARIOS.TODOS, 
            (response) => {
                callbackSuccess(response.data.usuarios)
            })
        },

        getUsuariosPorPerfil: function(perfil, callbackSuccess) {
            this.post(this.API.USUARIOS.POR_PERFIL, {perfil},
                (response) => {
                    callbackSuccess(response.data.usuarios)
                })
            },

        getUsuariosAtrasados: function(callbackSuccess) {
            this.get(this.API.USUARIOS.ATRASADOS, 
                (response) => {
                    callbackSuccess(response.data.usuarioAtrasado);
                })
        },

        checarNotificacaoApontamentoAtrasado: function(callbackSuccess) {
            this.post(this.API.USUARIOS.CHECA_NOTIFICACAO, {username:  this.$cookies.get("het_username")}, 
                (response) => {
                    
                    callbackSuccess(response.data.atrasado)
                })
            },

        logar: function(username, password, callback, callbackError) {
            this.post(this.API.USUARIOS.LOGAR, {username: username, senha: password},
                (response) => {
                    callback();
                        
                    this.$cookies.set("het_username", username, 60 * 60 * 3);
                    this.$cookies.set("het_nome", response.data.usuario.nome, 60 * 60 * 3);
                    this.$cookies.set("het_token", response.data.token, 60 * 60 * 3);
                    this.$cookies.set("het_perfil", response.data.usuario.perfil.nome, 60 * 60 * 3);
                    this.$root.logado = true;

                    this.getMenu((menus) => {
                        this.$root.items = menus;
                        this.$router.push("/");
                    });

                }, callbackError)
                
        },

        deslogar: function() {
            this.$cookies.remove("het_username");
			this.$cookies.remove("het_token");
			this.$cookies.remove("het_perfil");
			this.$cookies.remove("het_nome");
			this.$router.push("/login");
        },

        trocarSenhaUsuario: function(senhaAtual, senhaNova, callbackSuccess, callbackError) {
            this.post(this.API.USUARIOS.TROCAR_SENHA, 
                {
                    username: this.$cookies.get("het_username"),
                    senhaA: senhaAtual,
                    senhaN: senhaNova
                },
                (response) => {
                    callbackSuccess(response.data.valida)
                }, callbackError)
        },

        resetarSenhaUsuario: function(usuario, senha, callbackSuccess, callbackError) {
            this.post(this.API.USUARIOS.RESETAR_SENHA, 
                {
                    username: this.$cookies.get("het_username"),
                    usuario,
                    senhaN: senha
                },
                (response) => {
                    callbackSuccess(response.data.usuario)
                }, callbackError)
        },

        ciarUsuario: function(json, callbackSuccess, callbackError) {
            this.post(this.API.USUARIOS.CRIAR, json,
                (response) => {
                    callbackSuccess(response.data.usuario)
                }, callbackError)
        },

        editarUsuario: function(json, callbackSuccess, callbackError) {
            this.post(this.API.USUARIOS.EDITAR, json,
                (response) => {
                    callbackSuccess(response.data.usuario)
                }, callbackError)
        },


        bloquearUsuario: function(usuario, bloquear, callbackSuccess, callbackError) {
            this.post(this.API.USUARIOS.BLOQUEAR,
                {
                    usuario,
                    bloquear
                },
                (response) => {
                    callbackSuccess(response.data.usuario)
                }, callbackError)
        }
    }
})