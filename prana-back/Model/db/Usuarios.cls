Class Model.db.Usuarios Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Usuarios ]
{

/// Username correspondente ao do dominio pois a autenticação será feita via LDAP.
Property Username As %String(MAXLEN = 20) [ Required ];

Property Senha As %String(MAXLEN = 500) [ Required ];

Property Perfil As Model.db.Perfis [ Required ];

Property Nome As %String(MAXLEN = 60) [Required ];

/// Celular
Property Contato As %String(MAXLEN = 11);

Property eMail As %String(MAXLEN = 100);

Property UltimoLogin As %TimeStamp;

Property PrimeiroLogin As %Boolean [InitialExpression = 0];

// Cidade na qual o usuário atua 

// Através da cidade do usuário serão identificados os feriados

Property Cidade As %String;

Property Ativo As %Boolean [InitialExpression = 1];


// Se o total de falhas limite for alcançado o usuário é bloqueado

Property Bloqueado As %Boolean [InitialExpression = 0];

Property TotalFalhasLogin As %Integer [ InitialExpression = 0 ];

Index UsernameIndex On Username [ Unique ];


Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
	
	Quit $$$OK
	
	// Se estÃ¡ inserindo pela primeira vez encripta o valor da variÃ¡vel em memÃ³ria
	if (insert) {
		set ##this.Senha = $System.Encryption.Base32Encode(..Senha)
	}
	else {
		// Se update e a senha foi trocada, encripta a nova senha
		if ##this.Senha '= $System.Encryption.Base32Encode(..Senha) {
			set ##this.Senha = $System.Encryption.Base32Encode(..Senha)
		}
	}
	
	Quit $$$OK
}


Method ToJSON() As %DynamicObject
{

	s usuario = {}
	
	s usuario.id = ..%Id()
	s usuario.perfil = ..Perfil.ToJSON()
	s usuario.nome = ..Nome
	s usuario.contato = ..Contato
	s usuario.eMail = ..eMail
	s usuario.ultmimoLogin = $zdate(..UltimoLogin, 4)
	s usuario.cidade = ..Cidade
	s usuario.totalFalhasLogin = ..TotalFalhasLogin
	s usuario.bloqueado = ..Bloqueado
	quit usuario
}
Storage Default
{
<Data name="UsuariosDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Username</Value>
</Value>
<Value name="3">
<Value>Senha</Value>
</Value>
<Value name="4">
<Value>Perfil</Value>
</Value>
<Value name="5">
<Value>Nome</Value>
</Value>
<Value name="6">
<Value>Contato</Value>
</Value>
<Value name="7">
<Value>eMail</Value>
</Value>
<Value name="8">
<Value>UltimoLogin</Value>
</Value>
<Value name="9">
<Value>PrimeiroLogin</Value>
</Value>
<Value name="10">
<Value>Cidade</Value>
</Value>
<Value name="11">
<Value>Ativo</Value>
</Value>
<Value name="12">
<Value>Bloqueado</Value>
</Value>
<Value name="13">
<Value>TotalFalhasLogin</Value>
</Value>
</Data>
<DataLocation>^Model.db.UsuariosD</DataLocation>
<DefaultData>UsuariosDefaultData</DefaultData>
<IdLocation>^Model.db.UsuariosD</IdLocation>
<IndexLocation>^Model.db.UsuariosI</IndexLocation>
<StreamLocation>^Model.db.UsuariosS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}