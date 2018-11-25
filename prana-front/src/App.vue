<template>
  <v-app>
    <v-navigation-drawer
      :clipped="clipped"
      v-model="$root.drawer"
      enable-resize-watcher
      fixed
	    temporary
      app
      v-show="$root.logado"
    >
    <v-toolbar flat>
      <v-list>
        <v-list-tile>
          <v-list-tile-title class="title">
            Menu
          </v-list-tile-title>
        </v-list-tile>
      </v-list>
    </v-toolbar>

    <v-divider></v-divider>

      <v-list  dense 
          class="pt-0">
        <v-list-tile
          v-for="(item, i) in $root.items"
          :key="i"
          @click="$router.push(item.link)"
        >
          <v-list-tile-action>
            <v-icon v-html="item.icon"></v-icon>
          </v-list-tile-action>

          <v-list-tile-content>
            <v-list-tile-title v-text="item.title"></v-list-tile-title>
          </v-list-tile-content>

        </v-list-tile>
      </v-list>
    </v-navigation-drawer>


    <v-toolbar 
          app
          :clipped-left="clipped"
          v-show="$root.logado"
		      class="primary-het white--text"
    >
      <v-toolbar-side-icon class="white--text" @click.stop="$root.drawer = !$root.drawer"></v-toolbar-side-icon>

      <v-toolbar-title v-text="title" class="white--text"></v-toolbar-title>

      <v-spacer></v-spacer>
      <v-toolbar-items>
        
      <v-menu 
		bottom 
		left
		offset-y>
			<v-btn flat slot="activator" class="white--text">{{$cookies.get("het_nome")}} ({{$cookies.get("het_perfil")}})</v-btn>
		
			<v-list>
				<v-list-tile @click="$root.deslogar">
					<v-list-tile-title>Sair</v-list-tile-title>
				</v-list-tile>

				<v-list-tile @click="trocarSenhaDlg = true">
					<v-list-tile-title>Trocar Senha</v-list-tile-title>
				</v-list-tile>
			</v-list>
			</v-menu>
    	</v-toolbar-items>
      
    </v-toolbar>


    <v-content style="background-color: #F5F5F5">
      <router-view></router-view>
    </v-content>

	<v-dialog
		v-model="trocarSenhaDlg"
		max-width="500px"
		persistent>
		<v-card class="pa-2">
			<v-form ref="trocaSenhaForm">
				<v-container grid-list-md class="max-container">
					<v-layout row wrap>
						<v-flex>
							<h2>Troca de Senha</h2>
						</v-flex>
					</v-layout>

					<v-layout row wrap px-4>
						<v-flex xs12>
							<v-text-field
								label="Senha Atual"
								v-model="trocaSenha.senhaAtual"
								:rules="[v => !!v || 'Preencha a senha!']"
								type="password"
								style="font-size: 20px"
							></v-text-field>

							<v-text-field
								label="Nova Senha"
								v-model="trocaSenha.novaSenha"
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
											v => v == trocaSenha.novaSenha || 'As senhas nao coincidem!']"
							></v-text-field>
						</v-flex>
					</v-layout>

					<v-layout row wrap mt-2>
						<v-flex text-xs-right>
							<v-btn @click="trocarSenhaDlg = false">cancelar</v-btn>
							<v-btn 
								color="primary"
								@click="trocarSenha"
							>trocar</v-btn>
						</v-flex>
					</v-layout>

				</v-container>
			</v-form>
		</v-card>
	</v-dialog>


	 <v-dialog 
	 	:value="aviso || avisoErro" 
		@input="aviso = $event; avisoErro = $event"  
		max-width="290">
            <v-alert :value="true" :type="(avisoErro) ? 'error' : 'success'" class="ma-0">
                {{ avisoMsg }}
            </v-alert>    
        </v-dialog>
    
  </v-app>
</template>

<script>
export default {
	name: "App",

	data() {
		return {
			clipped: false,
			fixed: false,
			miniVariant: false,
			right: true,
			rightDrawer: false,
			title: "Prana",

			aviso: false,
			avisoErro: false,
			avisoMsg: "",

			trocarSenhaDlg: false,
			trocaSenha: {
					senhaAtual: "",
					novaSenha: ""
			}
		};
	},

	created() {
    this.checaLogado();
  },


	methods: {
		checaLogado: function() {
			if (this.$cookies.get("het_username") == null || this.$cookies.get("het_token") == null) {
				this.$router.push("/login");
			}
		},

		trocarSenha: function() {
			if (!this.$refs.trocaSenhaForm.validate()) return

			this.trocarSenhaUsuario(this.trocaSenha.senhaAtual, this.trocaSenha.novaSenha,
				(msg) => {
					this.aviso = true;
					this.avisoMsg = msg;
					this.trocarSenhaDlg = false;
					this.$refs.trocaSenhaForm.reset();
				},
				(error) => {
					this.avisoErro = true;
					this.avisoMsg = error;
				})
		}
	}
  
};
</script>

