Class Model.db.Mensagens Extends (%Persistent, %XML.Adaptor)
{

Property Mensagem As %String;

Property Codigo As %String;

Property Tipo As %String(DISPLAYLIST = ";ERRO;ALERTA;MENS", VALUELIST = ";E;A;M");

/// Com base no código informado, retorna a mensagem de erro correpondente
ClassMethod getMensagem(codigo As %String) As %String
{

	if $get(codigo) = "" quit ""

	set query = "select ID, Mensagem, %EXTERNAL(Tipo) as Tipo from Model.db.Mensagens "
	set query = query_"where %alphaup(Codigo) = %alphaup('"_codigo_"')"
	set rs = ##class(%ResultSet.SQL).%Prepare(query)
	
	if rs.%Next() quit rs.Tipo_": "_rs.Mensagem
	
	quit ""
}

Method ToJSON() As %DynamicObject
{
	s mensagem = {}
	
	s mensagem.mensagem = ..Mensagem
	s mensagem.codigo = ..Codigo
	s mensagem.tipo = ..TipoLogicalToDisplay(..Tipo)
	
	quit mensagem
	
	
}

Storage Default
{
<Data name="MensagensDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Mensagem</Value>
</Value>
<Value name="3">
<Value>Codigo</Value>
</Value>
<Value name="4">
<Value>Tipo</Value>
</Value>
</Data>
<DataLocation>^Model.db.MensagensD</DataLocation>
<DefaultData>MensagensDefaultData</DefaultData>
<IdLocation>^Model.db.MensagensD</IdLocation>
<IndexLocation>^Model.db.MensagensI</IndexLocation>
<StreamLocation>^Model.db.MensagensS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}