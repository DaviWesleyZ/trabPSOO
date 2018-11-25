<template>
    <v-container fluid fill-height grid-list-xs>
        <v-layout row wrap align-center justify-center>

			<v-flex xs12 sm8 md4 style="margin-top: -60px">
				<v-alert class="mb-3" :value="error" type="error">
					{{error}}
				</v-alert>

				<v-card class="elevation-12">
					<v-toolbar dark color="primary-het">
						<v-toolbar-title>Login</v-toolbar-title>
						<v-spacer></v-spacer>
					</v-toolbar>
					<v-form v-model="valid" >
						<v-card-text>

							<v-text-field  
								:rules="[v => !!v || 'Preencha o Username!']" 
								prepend-icon="person" 
								name="login" 
								v-model="username" 
								label="Username" 
								type="text"></v-text-field>

							<v-text-field 
								:rules="[ v => !!v || 'Preencha a Senha!']"  
								id="password" 
								prepend-icon="lock" 
								v-model="password" 
								name="password" 
								label="Password" 
								type="password"
								@keyup.enter="clickLogar"></v-text-field>
							
							
						</v-card-text>
						<v-card-actions>
							<v-spacer></v-spacer>
							<v-btn 
								:disabled="!valid" 
								:class="{ primary: !logando }" 
								@click="clickLogar" 
								:loading="logando"
								id="botao">
								LOGAR
							</v-btn>
							<v-btn 
								:class="{primary: !registrando}"
                                 @click="novoUsuarioDlg = true"						
								id="botao2">
								REGISTRAR
							</v-btn>
						</v-card-actions>
					</v-form>
				</v-card>

				

			</v-flex>
        </v-layout>



<v-dialog
		v-model="novoUsuarioDlg"
		max-width="500px"
		persistent>
		<v-card class="pa-2">
			<v-form ref="cadastrarUsuarioForm">
				<v-container grid-list-md class="max-container">
					<v-layout row wrap>
						<v-flex>
							<h2>Cadastro de Usuario</h2>
						</v-flex>
					</v-layout>

					<v-layout row wrap px-4>
						<v-flex xs12>
							<v-text-field
								label="Cidade"
								v-model="cadastraUser.cidade"
								:rules="[v => !!v || 'Preencha a cidade!']"
								style="font-size: 20px"
								maxlength="25"
							></v-text-field>

							<v-text-field
								label="Contato"
								v-model="cadastraUser.contato"
								:rules="[	v => !!v || 'Preencha o contato!']"
								validate-on-blur
							></v-text-field>

							<v-text-field
								label="Nome"
								v-model="cadastraUser.nome"
								:rules="[	v => !!v || 'Preencha o nome!']"
								validate-on-blur
								counter
							></v-text-field>

							<v-text-field
								label="Senha"
								v-model="cadastraUser.senha"
								:rules="[	v => !!v || 'Preencha a senha!',
											v => v && v.length >= 5 || 'Mínimo de 5 caracteres!']"
								validate-on-blur
								counter
								maxlength="20"
								hint="Mínimo de 5 caracteres"
								type="password"
							></v-text-field>

							<v-text-field
								label="Username"
								v-model="cadastraUser.username"
								:rules="[	v => !!v || 'Preencha o nome!']"
								validate-on-blur
								counter
							></v-text-field>

							<v-text-field
								label="Email"
								v-model="cadastraUser.eMail"
								:rules="[	v => !!v || 'Preencha o email!']"
								validate-on-blur
								counter
							></v-text-field>

						</v-flex>
					</v-layout>

					<v-layout row wrap mt-2>
						<v-flex text-xs-right>
							<v-btn @click="novoUsuarioDlg = false">cancelar</v-btn>
							<v-btn 
								color="primary"
								@click="novoUsuario"
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

export default {
    data() {
        return {									
			valid: true,
        	username: "",
			password: "",
			logando: false,
			registrando: false,
			error: "",

			aviso: false,
			avisoErro: false,
			avisoMsg: "",

            novoUsuarioDlg: false,
            	cadastraUser: {
					cidade: "",
					contato: "",
					nome: "",
					perfil:"",
					senha:"",
					username:"",
					eMail:"",
			}

		}

    },

    mounted() {
        this.$root.logado = false;
		   this.$root.drawer = false;
    },

    methods: {

		novoUsuario: function() {
			this.registrando = true;
			if (!this.$refs.cadastrarUsuarioForm.validate()) return

			var json = {
				cidade:		this.cadastraUser.cidade,
				contato:	this.cadastraUser.contato,
				nome:		this.cadastraUser.nome,
				perfil:		1,
				senha:		this.cadastraUser.senha,
				username:	this.cadastraUser.username,
				eMail:		this.cadastraUser.eMail
			};

			this.ciarUsuario(json,
				(usuario) => {
					this.aviso = true;
					this.avisoMsg = "Usuário cadastrado com sucesso!";
					this.novoUsuarioDlg = false;
					this.$refs.cadastrarUsuarioForm.reset();
					this.registrando = false;
				},
				(error) => {
					this.registrando = false;
					this.avisoErro = true;
					this.avisoMsg = error;
				})
       				
		},


        clickLogar: function() {
			this.logando = true;

			this.logar(this.username, this.password, 
				() => {
					this.logando = false;
					
				}, (error) => {
					this.logando = false;
					this.error = error;
				})

        }
    }
}
</script>

