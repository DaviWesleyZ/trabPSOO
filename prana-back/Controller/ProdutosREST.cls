Class Controller.ProdutosREST Extends %CSP.REST
{
	
	Parameter HandleCorsRequest = 1;
	
	XData UrlMap
	{
		<Routes>
			<Route  Url= "/novo" 					Method ="POST" 	Call="novoProduto" 			Cors="false"/>
			<Route  Url= "/" 						Method ="GET" 	Call="getProdutos" 			Cors="false"/>
			<Route  Url= "/editar" 					Method ="POST" 	Call="editarProdutos" 		Cors="false"/>
		</Routes>
	}

	ClassMethod novoProduto() As %Status
	{
	    s input = ##class(%DynamicObject).%FromJSON(%request.Content)

	    
	    s result = ##class(Model.proc.ProdutosPROC).novoProduto(input.username,
	    														input.codigo, 
	    														input.descricao,
	    														input.quantidade,
	    														input.valor)	
	    if ('result.status) {
			quit ##class(Model.helper.APIHelper).Erro(result.error)
		}
			    
	    s produto = ##class(Model.db.Produtos).%OpenId(result.data.produto.id)
	    s json = {}
	    s json.produto = produto.ToJSON()
	    
	    quit ##class(Model.helper.APIHelper).Sucesso(json)
    }
    
ClassMethod getProdutos() As %Status
	{
		
		s json = {}
		set produtos = ##class(%DynamicArray).%New()
		set produtosArray = ##class(Model.proc.ProdutosPROC).getProdutos()
		set produtosLengh = produtosArray.Count()
		
		for i = 1:1:produtosLengh 
		{
			s produto = produtosArray.GetAt(i)
			d produtos.%Push(produto.ToJSON())
		}

		s json.produtos = produtos
		d ##class(Model.helper.APIHelper).Sucesso(json)
		quit $$$OK
	}
	
}