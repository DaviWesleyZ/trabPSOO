import Vue from "vue";


import "./UsuariosProvider.js"
import "./MenusProvider.js"
import "./ProdutosProvider.js"

const API_PATH = "http://localhost:57772/csp/prana";

const USUARIOS =     API_PATH + "/usuarios";
const MENUS =        API_PATH + "/menus";
const PRODUTOS = API_PATH + "/produtos"

const API = {

    PRODUTOS: {
        NOVO: PRODUTOS + "/novo",
        TODOS: PRODUTOS + "/",
        STATUS: PRODUTOS + "/status"
    },

    USUARIOS: {
        LOGAR: USUARIOS + "/logar",
        PERFIL: USUARIOS + "/perfil",
        CHECA_NOTIFICACAO: USUARIOS + "/usuarioAtrasado",
        TODOS: USUARIOS + "/",
        ATRASADOS: USUARIOS + "/atrasados",
        POR_PERFIL: USUARIOS + "/porPerfil",
        TROCAR_SENHA: USUARIOS + "/redefinirSenha",
        RESETAR_SENHA: USUARIOS + "/resetarSenha",
        PERFIS: USUARIOS + "/perfis/",
        CRIAR: USUARIOS + "/novo",
        BLOQUEAR: USUARIOS + "/bloquear",
        EDITAR: USUARIOS + "/editar"
    },
    
    MENUS: MENUS + "/",
}


Vue.mixin({
    data() {
        return {
            API: API
        }
    },

    methods: {

        get: function(url, callbackSuccess, callbackError = "", callbackException = "") {
            this.$http.get(url)
                .then(response => {
                    if (typeof response.body.status === "undefined") {
                        console.log("Erro no corpo!");
                        console.log("Url: " + url);
                        console.log(response.body);
                        return;
                    }

                    if (response.body.status == 1) {
                        callbackSuccess(response.body);

                    } else {
                        console.log("url: " + url);
                        console.log(response.body.error)
                        if (typeof callbackError == "function") callbackError(response.body.error); 
                    }
                })
                .catch(e => {
                    console.log("exceptio :(");
                    console.log(e);
                    if (typeof callbackException == "function") callbackException(e); 
                })
        },

        post: function(url, json, callbackSuccess, callbackError = "", callbackException = "", header = "") {
            this.$http.post(url, json, header)
                .then(response => {
                    if (typeof response.body.status === "undefined") {
                        console.log("Erro no corpo!");
                        console.log("Url: " + url);
                        console.log(response.body);
                        return;
                    }

                    if (response.body.status == 1) {
                        callbackSuccess(response.body)
                        
                    } else {
                        console.log("url: " + url);
                        console.log(response.body.error)
                        if (typeof callbackError == "function") callbackError(response.body.error); 
                    }
                })
                .catch(e => {
                    console.log("exceptio :(");
                    console.log(e);
                    console.log(json);
                    if (typeof callbackException == "function") callbackException(e); 
                })
        },

        
    }
})
