Class Model.db.OpcoesAcesso Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Opcoes ]
{

Property Nome As %String(MAXLEN = 20);

Property Descricao As %String(MAXLEN = 80);

Property Ativo As %Boolean;

Method ToJSON() As %DynamicObject
{
	s opcoesacesso = {}
	
	s opcoesacesso.nome = ..Nome
	s opcoesacesso.desc = ..Descricao
		
	quit opcoesacesso
	
	
}


Storage Default
{
<Data name="OpcoesAcessoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nome</Value>
</Value>
<Value name="3">
<Value>Descricao</Value>
</Value>
<Value name="4">
<Value>Ativo</Value>
</Value>
</Data>
<DataLocation>^Model.db.OpcoesAcessoD</DataLocation>
<DefaultData>OpcoesAcessoDefaultData</DefaultData>
<IdLocation>^Model.db.OpcoesAcessoD</IdLocation>
<IndexLocation>^Model.db.OpcoesAcessoI</IndexLocation>
<StreamLocation>^Model.db.OpcoesAcessoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}