import Vue from "vue";

Vue.mixin({
    methods: {
        
        getTodosProdutos: function(callbackSuccess) {
            this.get(this.API.PRODUTOS.TODOS,
                (response) => {
                    callbackSuccess(response.data.produtos);
                })
        },

        novoProduto: function(json, callbackSuccess, callbackError) {    
            
            json.username = this.$cookies.get("het_username");

             this.post(this.API.PRODUTOS.NOVO, json, 
                 (response) => {
                     callbackSuccess(response.data.projeto)
 
                 }, callbackError)
         }
    },
    
    getProdutoStatusOpt: function(callbackSuccess) {
        this.get(this.API.PRODUTOS.STATUS, 
        (response) => {
            callbackSuccess(response.data.status);
        })
    },

});