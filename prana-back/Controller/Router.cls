Class Controller.Router Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

XData UrlMap
{
<Routes>
			<Map Prefix="/usuarios" 	Forward="Controller.UsuariosREST"/>
			<Map Prefix="/menus" 		Forward="Controller.MenusREST"/>
			<Map Prefix="/produtos"     Forward="Controller.ProdutosREST"/>
		</Routes>
}

}