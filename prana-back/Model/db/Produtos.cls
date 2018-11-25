Class Model.db.Produtos Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Produtos ]
{

Property codigo As %String(MAXLEN = 30) [ Required ];

Property descricao As %String(MAXLEN = 500) [ Required ];

Property quantidade As %Integer [Required];

Property valor As %Numeric [Required];

Property criadoEm As %TimeStamp;

Property criadoPor As Usuarios;

Method ToJSON() As %DynamicObject
{

	s produto = {}
	
	s produto.id = ..%Id()
	s produto.codigo = ..codigo
	s produto.descricao = ..descricao
	s produto.quantidade = ..quantidade
	s produto.valor = ..valor
	
	quit produto
}
Storage Default
{
<Data name="ProdutosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>codigo</Value>
</Value>
<Value name="3">
<Value>descricao</Value>
</Value>
<Value name="4">
<Value>quantidade</Value>
</Value>
<Value name="5">
<Value>valor</Value>
</Value>
<Value name="6">
<Value>criadoEm</Value>
</Value>
<Value name="7">
<Value>criadoPor</Value>
</Value>
</Data>
<DataLocation>^Model.db.ProdutosD</DataLocation>
<DefaultData>ProdutosDefaultData</DefaultData>
<IdLocation>^Model.db.ProdutosD</IdLocation>
<IndexLocation>^Model.db.ProdutosI</IndexLocation>
<StreamLocation>^Model.db.ProdutosS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}