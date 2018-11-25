Class Model.proc.ProdutosPROC Extends %RegisteredObject
{

ClassMethod getProdutos() As %ListOfObjects {

		set query = 				"select ID as chave "
		set query = query_			"FROM Model_db.Produtos"
	
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		
		set lista = ##class(%Library.ListOfObjects).%New()
		
		while rs.%Next() {
			
			do lista.Insert(rs.chave)
		}
		
		quit lista
}

ClassMethod novoProduto(username As %String,
						codigo As %String,
						descricao As %String,
						quantidade As %Integer,
						valor As %Numeric) As %DynamicObject {
						   
   if (codigo = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Preencha o codigo!")
	} 
   if (descricao = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Preencha o descricao!")
	} 
   if (quantidade = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Preencha a quantidade!")
	} 
   if (valor = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Preencha o valor!")
	}
	
	s usuario = ##class(Model.proc.UsuariosPROC).getUsuario(username)
	if ('usuario) {
		return ##class(Model.helper.APIHelper).ErroPROC("usuario nao existe!")
	}   
	
	s produto = ##class(Model.db.Produtos).%New()
	
	s produto.codigo     = codigo
	s produto.descricao  = descricao
	s produto.quantidade = quantidade
	s produto.valor      = valor
	s produto.criadoEm   = $ZDATETIME($h,3,1)
	s produto.criadoPor  = usuario
	
		set status = produto.%ValidateObject()
						
		if ($$$ISERR(status)) {
			quit ##class(Model.helper.APIHelper).ErroPROC($system.Status.GetErrorText(status))
		}
		
		d produto.%Save()
		
		s json = {}
		s json.produto = produto.ToJSON()
		
		quit ##class(Model.helper.APIHelper).SucessoPROC(json)	
	
}

ClassMethod alterarProduto(codigo As %String,
						   username As %String,
						   descricao As %String,
						   quantidade As %Integer,
						   valor As %Numeric) As %DynamicObject {
						
	if (username = "") {
		return ##class(Model.helper.APIHelper).ErroPROC("username vazio!")
	}
	s usuario = ##class(Model.proc.UsuariosPROC).getUsuario(username)
			
	if ('usuario) {
		return ##class(Model.helper.APIHelper).ErroPROC("usuario nao existe!")
	}   
	
    if (codigo = "") { 
			return ##class(Model.helper.APIHelper).ErroPROC("Produto vazio")
	}
	
	set produto = ##class(Model.db.Produtos).%OpenId(codigo)
	
	if (produto = "") { 
	 		return ##class(Model.helper.APIHelper).ErroPROC("Produto não existe!")
	}
	
	if (descricao '= "") {
		s produto.descricao = descricao
	}
	if (quantidade '= "") {
		s produto.quantidade = quantidade
	}
	if (valor '= "") {
		s produto.valor = valor
	}
	s produto.AlteradoPor = gestorLogado
	s produto.AlteradoEm = $ZDATETIME($h,3,1)
	set statusProduto = produto.%ValidateObject()

	
	if '$$$ISERR(statusProduto) {
		d produto.%Save()
	
		s json = {}
		s json.produto = produto.ToJSON()
		q ##class(Model.helper.APIHelper).SucessoPROC(json)
			
	} else {
		q ##class(Model.helper.APIHelper).ErroPROC("Erro na validação: "_$system.Status.GetErrorText(statusProduto))
		
	}				   
						    
}





}