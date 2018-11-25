Class Controller.MenusREST Extends %CSP.REST
{

	Parameter HandleCorsRequest = 1;
	
	XData UrlMap
	{
	<Routes>
	    <Route Url="/" Method="POST" Call="getMenu" Cors="false"/>
	
	</Routes>
	}
	
	ClassMethod getMenu() As %Status
	{
		s input = ##class(%DynamicObject).%FromJSON(%request.Content)
	
		if (input.username = "") {
			do ##Class(Model.helper.APIHelper).Erro("usuario vazio")
		} else { 
			set perfil = ##class(Model.proc.UsuariosPROC).usuarioExiste(input.username)
			
			if (perfil) { 
			
				set usuario = ##class(Model.proc.UsuariosPROC).getUsuario(input.username)
				
				s json = {}
				
				s menus = ##class(%DynamicArray).%New()
			
				if (usuario.Perfil.Nome = "Cliente") {
					
					d menus.%Push({"icon": "view_list", "title": "Painel", "link": "/painel"})	
					
				} else {
					d menus.%Push({"icon": "dashboard", "title": "PainelAdmin", "link": "/paineladmin"})
					d menus.%Push({"icon": "person", "title": "Usuários", "link": "/usuarios"})
				}
				
				s json.menus = menus
				
				do ##Class(Model.helper.APIHelper).Sucesso(json) 
			} else {
				do ##Class(Model.helper.APIHelper).Erro("Perfil Invalido") 
			}
		}
		
		Quit $$$OK
	}
}