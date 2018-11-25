<template>
    <v-container fluid grid-list-md>
        <v-layout row wrap display-1 pa-2>
            <v-flex md12 sm12 xs12>
                Bem-vindo!
            </v-flex>
			
        </v-layout>

        <v-flex row pa-2 mb-5>
			
           <tabela-produtos></tabela-produtos>
        </v-flex>

    </v-container>

    
</template>


<script>
import TabelaProdutos from '../components/painelAdmin/TabelaProdutos.vue';

export default {
    components: {
        "tabela-produtos": TabelaProdutos
    },

    data() {
        return {

			clipped: false,
			fixed: false,
			miniVariant: false,
			right: true,
			rightDrawer: false,
			title: "Prana",
			

        }
    },
    
    created() {
        if (this.$cookies.get("het_perfil") == "Administrador") {
            this.$router.push("PainelAdmin")
        }
    },

}
</script>