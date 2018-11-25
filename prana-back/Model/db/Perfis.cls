Class Model.db.Perfis Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Perfis ]
{

Property Nome As %String(MAXLEN = 20);

Property Ativo As %Boolean;

// Lista de todas as opções de acesso ativas associadas ao Perfil 
Property Opcoes As list Of OpcoesAcesso;

Method ToJSON() As %DynamicObject
{
	
	s perfil = {}
	
	s perfil.id = ..%Id()
	s perfil.nome = ..Nome
	
	quit perfil
}

Storage Default
{
<Data name="PerfisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nome</Value>
</Value>
<Value name="3">
<Value>Ativo</Value>
</Value>
<Value name="4">
<Value>Opcoes</Value>
</Value>
</Data>
<DataLocation>^Model.db.PerfisD</DataLocation>
<DefaultData>PerfisDefaultData</DefaultData>
<IdLocation>^Model.db.PerfisD</IdLocation>
<IndexLocation>^Model.db.PerfisI</IndexLocation>
<StreamLocation>^Model.db.PerfisS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}