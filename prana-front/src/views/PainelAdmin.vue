<template>
    <v-container fluid grid-list-md>
        <v-layout row wrap display-1 pa-2>
            <v-flex md12 sm12 xs12>
                Bem-vindo!
            </v-flex>
			
        </v-layout>
		
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								:class="{primary: !cadastrando}"
                                 @click="novoProdutoDlg = true"						
								id="botao">
								CADASTRAR PRODUTO
							</v-btn>
						</v-card-actions>

        <v-flex row pa-2 mb-5>
			
           <tabela-produtos></tabela-produtos>
        </v-flex>
        <v-dialog
		v-model="novoProdutoDlg"
		max-width="500px"
		persistent>
		<v-card class="pa-2">
			<v-form ref="cadastrarProdutoForm">
				<v-container grid-list-md class="max-container">
					<v-layout row wrap>
						<v-flex>
							<h2>Cadastro de Produto</h2>
						</v-flex>
					</v-layout>

					<v-layout row wrap px-4>
						<v-flex xs12>
							<v-text-field
								label="Código"
								v-model="cadastraProd.codigo"
								:rules="[v => !!v || 'Preencha o código!']"
								style="font-size: 20px"
							></v-text-field>

							<v-text-field
								label="Descrição"
								v-model="cadastraProd.descricao"
								:rules="[	v => !!v || 'Preencha a descrição!']"
								validate-on-blur
								counter
								maxlength="25"
							></v-text-field>

							<v-text-field
								label="Quantidade"
								v-model="cadastraProd.quantidade"
								:rules="[	v => !!v || 'Preencha a quantidade!']"
								validate-on-blur
								counter
							></v-text-field>

							<v-text-field
								label="Valor"
								v-model="cadastraProd.valor"
								:rules="[	v => !!v || 'Preencha o valor!']"
								validate-on-blur
								counter
							></v-text-field>
						</v-flex>
					</v-layout>

					<v-layout row wrap mt-2>
						<v-flex text-xs-right>
							<v-btn @click="novoProdutoDlg = false">cancelar</v-btn>
							<v-btn 
								color="primary"
								@click="cadastraProduto"
							>Cadastrar</v-btn>
						</v-flex>
					</v-layout>

				</v-container>
			</v-form>
		</v-card>
	</v-dialog>

	
        <v-dialog
            :value="aviso || avisoErro" 
            @input="aviso = $event; avisoErro = $event"  
            max-width="390">
            <v-alert :value="true" :type="(avisoErro) ? 'error' : 'success'" class="ma-0">
                {{avisoMsg}}
            </v-alert>    
        </v-dialog>


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
			
			cadastrando: false,

			aviso: false,
			avisoErro: false,
			avisoMsg: "",

            novoProdutoDlg: false,
            	cadastraProd: {
					codigo: "",
					descricao: "",
					quantidade: "",
					valor:"",
			}
        }
    },
    
    created() {
        if (this.$cookies.get("het_perfil") == "Cliente") {
            this.$router.push("Painel")
        }
    },

    methods: {
		cadastraProduto: function() {
			this.cadastrando = true;
			if (!this.$refs.cadastrarProdutoForm.validate()) return

			var json = {
				codigo:		this.cadastraProd.codigo,
				descricao:	this.cadastraProd.descricao,
				quantidade:	this.cadastraProd.quantidade,
				valor:		this.cadastraProd.valor
			};

			this.novoProduto(json,
				(projeto) => {
					this.aviso = true;
					this.avisoMsg = "Produto cadastrado com sucesso!";
					this.novoProdutoDlg = false;
					this.$refs.cadastrarProdutoForm.reset();
					this.cadastrando = false;
				},
				(error) => {
					this.cadastrando = false;
					this.avisoErro = true;
					this.avisoMsg = error;
				})
            	this.$router.push("PainelAdmin")
       				
		}
    }

}
</script>