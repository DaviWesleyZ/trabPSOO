Class Model.db.Parametros Extends (%Persistent, %XML.Adaptor)
{

Property Chave As %String [ Required ];

Property Valor As %String;


ClassMethod get(chave As %String) As %String {
	
	if $get(chave) = "" quit "ERRO: parametro nao informado."
	
	set query = "select ID from Model_db.Parametros where Chave = '"_chave_"'"
	set rs = ##class(%ResultSet.SQL).%Prepare(query)
	set ret = rs.%Next()
	if 'ret quit "ERRO: parametro nao existe!"
	
	quit rs.ID.Valor
}

Method ToJSON() As %DynamicObject
{
	s parametro = {}
	
	s parametro.id = ..%Id()
	s parametro.chave = ..Chave
	s paramentro.valor = ..Valor

	
	quit parametro
	
	
}

Storage Default
{
<Data name="ParametrosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Chave</Value>
</Value>
<Value name="3">
<Value>Valor</Value>
</Value>
</Data>
<DataLocation>^Model.db.ParametrosD</DataLocation>
<DefaultData>ParametrosDefaultData</DefaultData>
<IdLocation>^Model.db.ParametrosD</IdLocation>
<IndexLocation>^Model.db.ParametrosI</IndexLocation>
<StreamLocation>^Model.db.ParametrosS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}