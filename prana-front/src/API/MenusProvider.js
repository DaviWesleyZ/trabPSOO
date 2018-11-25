import Vue from "vue";

Vue.mixin({
    methods: {
        getMenu: function(callbackSuccess) {
            this.post(this.API.MENUS, 
                 {username: this.$cookies.get("het_username")},
                (response) => {
                    callbackSuccess(response.data.menus);
                })
                
        }
    }
})