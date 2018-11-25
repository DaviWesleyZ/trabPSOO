Class Controller.UsuariosREST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;


	XData UrlMap
	{
	<Routes>

		<Route Url="/logar" 			Method="POST" 	Call="Logar" 						Cors="false"/>
		<Route Url="/perfil" 			Method="POST" 	Call="GetPerfil" 					Cors="false"/>
		<Route Url="/perfis/" 			Method="GET" 	Call="getPerfis" 					Cors="false"/>
		<Route Url="/" 					Method="GET" 	Call="todosUsuarios" 				Cors="false"/>
		<Route Url="/atrasados" 		Method="GET" 	Call="getTodosUsuariosAtrasados" 	Cors="false"/>
		<Route Url="/usuarioAtrasado" 	Method="POST" 	Call="usuarioAtrasado" 				Cors="false"/>
		<Route Url="/porPerfil" 		Method="POST" 	Call="getPorPerfil" 				Cors="false"/>
		<Route Url="/novo" 				Method="POST" 	Call="NovoUsuario" 					Cors="false"/>
		<Route Url="/redefinirSenha" 	Method="POST" 	Call="redefinirSenha" 				Cors="false"/>
		<Route Url="/editar"		 	Method="POST" 	Call="editarUsuario" 				Cors="false"/>
		<Route Url="/bloquear" 			Method="POST" 	Call="bloquearUsuario" 				Cors="false"/>		
		<Route Url="/resetarSenha"	 	Method="POST" 	Call="resetarSenha" 				Cors="false"/>	
	</Routes>
	}
	
	ClassMethod editarUsuario() As %Status {
		
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		
		s valida = ##class(Model.proc.UsuariosPROC).editarUsuario(input.usuario,
																	input.perfil,
																	input.contato,
																	input.cidade,
																	input.eMail,
																	input.nome)
		if (valida.status) {
		
			q ##class(Model.helper.APIHelper).Sucesso(valida.data)	
		} else {
		
			q ##class(Model.helper.APIHelper).Erro(valida.error)
			}
	
	}
	
	ClassMethod bloquearUsuario() As %Status

	{
		s input =##class(%DynamicObject).%FromJSON(%request.Content)
		s username = ##class(Model.proc.UsuariosPROC).bloquearUsuario(input.username,input.usuario, input.bloquear)
		
		if (username.status)
		{
			s Usuario = ##class(Model.db.Usuarios).%OpenId(username.data.id)
			s json = {}
			s json.usuario = Usuario.ToJSON()
			quit ##class(Model.helper.APIHelper).Sucesso(json)
		}
		else
		{
			quit ##class(Model.helper.APIHelper).Erro(username.error)
		}
		
	}
	
	ClassMethod NovoUsuario() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		s valida = ##class(Model.proc.UsuariosPROC).criarUsuario(input.cidade,
																input.contato,
																input.nome,
																input.perfil,
																input.senha,
																input.username,
																input.eMail)
																
				
																
		if (valida.status) 
		{
			s User = ##class(Model.db.Usuarios).%OpenId(valida.data.id)
			s json = {}
			s json.usuario = User.ToJSON()
			quit ##class(Model.helper.APIHelper).Sucesso(json)
		} 
		else 
		{
			quit ##class(Model.helper.APIHelper).Erro(valida.error)
		}
 
	}
	
	ClassMethod redefinirSenha() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		
		s valida = ##class(Model.proc.UsuariosPROC).redefinirSenha(input.username,input.senhaA,input.senhaN)
		
		if (valida.status) 
		{
		
			q ##class(Model.helper.APIHelper).Sucesso(valida.data)	
		} 
		else 
		{
		
			q ##class(Model.helper.APIHelper).Erro(valida.error)
		}
		
	}
	
	ClassMethod resetarSenha() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		
		s valida = ##class(Model.proc.UsuariosPROC).resetarSenha(input.username,input.usuario,input.senhaN)
		
		if (valida.status) 
		{
		
			q ##class(Model.helper.APIHelper).Sucesso(valida.data.usuario.ToJSON())	
		} 
		else 
		{
		
			q ##class(Model.helper.APIHelper).Erro(valida.error)
		}
		
	}
		
		
	
	
	ClassMethod Logar() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)

		s result = ##class(Model.proc.UsuariosPROC).validarLogin(input.username, input.senha)
	 
		if ('result.status) {
			q ##class(Model.helper.APIHelper).Erro(result.error)
		}
	 			
		set %session.Data("Token", 1) = %session.SessionId
		set %session.Data("Username",1) = input.username
		
		s json = {}
		s json.token = %session.SessionId
		s json.usuario = result.data.usuario
	 
		q ##class(Model.helper.APIHelper).Sucesso(json)

	 
	}


	ClassMethod GetPerfil() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		s json = {}
		if (input.username = "")
			{
				do ##Class(Model.helper.APIHelper).Erro("vazio")
			}
		else
			{	
				set perfil = ##class(Model.proc.UsuariosPROC).usuarioExiste(input.username)
					if (perfil)
					{	
						set usuario = ##class(Model.proc.UsuariosPROC).getUsuario(input.username)
							s json = {}
							set json.perfil = usuario.Perfil.Nome
							do ##Class(Model.helper.APIHelper).Sucesso(json)	
					}
					else
					{	
						do ##Class(Model.helper.APIHelper).Erro("Perfil Invalido")					
					}
			}
		Quit $$$OK
	}
	
	ClassMethod todosUsuarios() As %Status
	{
		set json = {}
		set usuariosArray = ##class(Model.proc.UsuariosPROC).getTodosUsuarios()
		set usuarios = ##class(%DynamicArray).%New()
		set usuariosLengh = usuariosArray.Count()
		for i = 1:1:usuariosLengh 
					{
						s usuarioAtual = usuariosArray.GetAt(i)
						d usuarios.%Push(usuarioAtual.ToJSON())
					}
					
					s json.usuarios = usuarios
					d ##Class(Model.helper.APIHelper).Sucesso(json)
			
			Quit $$$OK
	}
	
	ClassMethod getTodosUsuariosAtrasados() As %Status
	{
			s json = {}
			set usuario = ##class(Model.proc.UsuariosPROC).getTodosUsuariosAtrasados()
			set usuarios = ##class(%DynamicArray).%New()
			set usuariolength = usuario.Count()

			for i = 1:1:usuariolength
			{
				
				set usuarioAtrasado = usuario.GetAt(i)
				set apontamento = ##class(Model.proc.ApontamentosPROC).getUltimoApontamento(usuarioAtrasado.%Id())
				

				set usuarioAtrasadoJSON = usuarioAtrasado.ToJSON()
				
				if (apontamento '= "")
				{
					set usuarioAtrasadoJSON.apontamentoAtrasado = apontamento.ToJSON()				
				}
				
				d usuarios.%Push(usuarioAtrasadoJSON)
					
			}
			set json.usuarioAtrasado = usuarios
			d ##class(Model.helper.APIHelper).Sucesso(json)		
			Quit $$$OK
		
	
		
	}
	
	ClassMethod usuarioAtrasado() As %Status
	{
		set json = {}
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		
		if ( input.username '= "")
		{	
			s ObjetoUser = ##class(Model.proc.UsuariosPROC).getUsuario(input.username)
			
			s apontamentos = {}
			
			set usuarioAtrasado = ##class(Model.proc.UsuariosPROC).getUsuarioAtrasado(ObjetoUser.%Id())

			if (usuarioAtrasado) {
			 	s apontamentos.atrasado = 1
			} else {
				s apontamentos.atrasado = 0
			}
			s json = apontamentos
			d ##class(Model.helper.APIHelper).Sucesso(json)	
		
		}else{
			d ##class(Model.helper.APIHelper).Erro("Usuário não existe!")	
		}
		
		Quit $$$OK
	}
	
	
	ClassMethod getPorPerfil() As %Status {
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
		s perfil = input.perfil
		
		if (perfil = "") {
			quit ##class(Model.helper.APIHelper).Erro("perfil vazio")
		}
		
		s usus = ##class(Model.proc.UsuariosPROC).getUsuariosPorPerfil(perfil)
		
		s json = {}
		s ususVetor = ##class(%DynamicArray).%New()
		
		for i = 1:1:usus.Count() {
			d ususVetor.%Push(usus.GetAt(i).ToJSON())
		}
		
		s json.usuarios = ususVetor
		quit ##class(Model.helper.APIHelper).Sucesso(json)
	}
	
	ClassMethod getPerfis() As %Status {
		s perfis = ##class(Model.proc.UsuariosPROC).getPerfis()
		s vetor = ##class(%DynamicArray).%New()
		
		for i = 1:1:perfis.Count() {
			d vetor.%Push(perfis.GetAt(i).ToJSON())
		}
		
		s json = {}
		s json.perfis = vetor
		
		q ##class(Model.helper.APIHelper).Sucesso(json)	
	}



	
}
