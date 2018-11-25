Class Model.proc.UsuariosPROC Extends (%RegisteredObject)
{

	ClassMethod editarUsuario(ID,
							  Perfil,
							  Contato As %String,
							  Cidade,
							  eMail,
							  Nome) As %DynamicObject {
							  
	if (ID = "") {
		return ##class(Model.helper.APIHelper).ErroPROC("Usuario vazio")
	}

	s usuario = ##class(Model.db.Usuarios).%OpenId(ID)
	
	if ('usuario) {
		
		return ##class(Model.helper.APIHelper).ErroPROC("Usuario n„o existe")
	}
	
	s ok = ..comparaNome(Nome,usuario.%Id())
	
	if (ok)
	{
		return ##class(Model.helper.APIHelper).ErroPROC("Nome j· existe")
	}
	
	
	
	if (Perfil '="")
	{
		s perfil = ##class(Model.db.Perfis).%OpenId(Perfil)
		
		if ('perfil) 
		{
		
			return ##class(Model.helper.APIHelper).ErroPROC("Perfil n„o existe")
		}
	
	}
	
	if (Nome = "") {
		s Nome = usuario.Nome
	}
	
	if (Contato = "") {
		s Contato = usuario.Contato
	}
	
	if (eMail = "") {
		s eMail = usuario.eMail
	}
	
	if (Cidade = "") {
		s Cidade = usuario.Cidade
	}
	
	if (Perfil = "") 
	{
		s perfil = usuario.Perfil
	}

	s usuario.Perfil = perfil
	s usuario.Contato = Contato
	s usuario.Cidade = Cidade
	s usuario.eMail = eMail
	s usuario.Nome = Nome
	
	
	s status = usuario.%ValidateObject()
	
	if ($$$ISERR(status)) {
	
		quit ##class(Model.helper.APIHelper).ErroPROC($system.Status.GetErrorText(status))
	}
		
	d usuario.%Save()
	s json = {}
	s json.usuario = usuario.ToJSON()
	
	q ##class(Model.helper.APIHelper).SucessoPROC(json)
	
	}

	
	ClassMethod validarLogin(username As %String, Senha As %String) As %DynamicObject
	{
		
		if (username = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Por favor preencha o username!")
		}
		
		if (Senha = "") {
			q ##class(Model.helper.APIHelper).ErroPROC("Por favor preencha a senha!")
		}
		
		s usuario = ..getUsuario(username)
		
		if ('usuario) {
			q ##class(Model.helper.APIHelper).ErroPROC("Esse usu·rio n„o existe!")
		}
		
		if (usuario.Bloqueado) {
			q ##class(Model.helper.APIHelper).ErroPROC("Esse usu·rio esta bloqueado!")
		}
		
		
		set Senha = $System.Encryption.Base32Encode(Senha)
		
		if usuario.Senha '= Senha {
			s usuario.TotalFalhasLogin = usuario.TotalFalhasLogin + 1
			if usuario.TotalFalhasLogin > ##class(Model.db.Parametros).get("LimiteFalhasLogin") {
				s usuario.Bloqueado = 1
			}
			d usuario.%Save()
			
			if (usuario.TotalFalhasLogin > 2) {
				q ##class(Model.helper.APIHelper).ErroPROC("Senha incorreta! Tentativas: "_(usuario.TotalFalhasLogin-1)_" Max: "_##class(Model.db.Parametros).get("LimiteFalhasLogin"))
			} else {
				q ##class(Model.helper.APIHelper).ErroPROC("Senha incorreta!")
			
			}
		}
		
		s usuario.TotalFalhasLogin = 0
		s usuario.UltimoLogin = $ZDATETIME($h,3,1)
		d usuario.%Save()
	
		s json = {}
		s json.usuario = usuario.ToJSON()
		q ##class(Model.helper.APIHelper).SucessoPROC(json)
	}

	ClassMethod criarUsuario(Cidade,
	 						 Contato,
	 						 Nome,
	 						 Perfil,
	 						 Senha,
	 						 Username,
	 						 eMail) as %DynamicObject
	{
		
		; ValidaÁıes
		if (Nome = "") {
			return ##class(Model.helper.APIHelper).ErroPROC("Nome vazio")
		}
		
		if (Perfil = ""){
			return ##class(Model.helper.APIHelper).ErroPROC("Perfil vazio")
		}
		
		if (Senha = "") {
			return ##class(Model.helper.APIHelper).ErroPROC("Senha vazia")
		}
		
		if ($length(Senha) < 5) {
			return ##class(Model.helper.APIHelper).ErroPROC("Senha deve conter mais de 5 caracteres")
		}
		
		if ($length(Senha) > 20) {
			return ##class(Model.helper.APIHelper).ErroPROC("Senha deve conter menos de 20 caracteres")
		}
		
		if (Username = "") {
			return ##class(Model.helper.APIHelper).ErroPROC("Username vazio")
		}
		
		if ($length(Username) < 5) {
			return ##class(Model.helper.APIHelper).ErroPROC("Username deve conter mais de 5 caracteres")
		}
		
		if ($length(Username) > 20) {
			return ##class(Model.helper.APIHelper).ErroPROC("Username deve conter menos de 20 caracteres")
		}
		
		if ($replace(Username," ", "")) '= (Username) {
		
			return ##class(Model.helper.APIHelper).ErroPROC("Username n„o deve conter espaÁos")
		
		}
		
		if (Perfil = "") {
			return ##class(Model.helper.APIHelper).ErroPROC("Perfil vazio!")
		}
		
		s Perfil =  ##class(Model.db.Perfis).%OpenId(Perfil)
		
		if (Perfil = "") {
			return ##class(Model.helper.APIHelper).ErroPROC("Perfil n„o existe!")
		}
		
		
		; Verifica se nome existe
		s valida = ..checaNomeUsuario(Nome)

		if (valida) {
			return ##class(Model.helper.APIHelper).ErroPROC("Nome j· existe")
		}
		
		; Criptografa senha
		s Senha = $System.Encryption.Base32Encode(Senha)
		
		
		; Verifica se usuario existe
		s ok = ..usuarioExiste(Username)
		
		if (ok) {
			return ##class(Model.helper.APIHelper).ErroPROC("Usuario j· existe")
		} 
		
		
		set User = ##class(Model.db.Usuarios).%New()
		set User.Cidade = Cidade
		set User.Contato = Contato
		set User.Nome = Nome
		set User.Perfil = Perfil
		set User.Senha = Senha
		set User.Username = $replace(Username," ", "")
		set User.eMail = eMail
		set User.Ativo = 1
		s status = User.%ValidateObject()
				
		if ($$$ISERR(status)) {
			quit ##class(Model.helper.APIHelper).ErroPROC($system.Status.GetErrorText(status))
		}

		d User.%Save()
		s json = {}
		s json.id = User.%Id()
		quit ##class(Model.helper.APIHelper).SucessoPROC(json)
		
	
	}
	
	ClassMethod bloquearUsuario(username As %String,usuario As %String, bloquear) As %Boolean
	{
		if (usuario = "") {
			quit ##class(Model.helper.APIHelper).ErroPROC("usuario vazio!")
		}
		
		if (username ="")
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Gestor vazio!")
		}
		
		if (bloquear = "")
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Sem valor no bloquear!")
		}
		
		if (bloquear '=0) || (bloquear '=1)
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Bloquear com valor inv·lido!")
		}
		
		s Gestor = ..getUsuario(username)	
		s Usuario = ##class(Model.db.Usuarios).%OpenId(usuario)
		
		if ('Usuario) {
			quit ##class(Model.helper.APIHelper).ErroPROC("Usuario n„o existe!")
		}
		
		if ('Gestor)
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Gestor n„o existe!")
		}
		
		if (Usuario.%Id() = Gestor.%Id())
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Gestor n„o pode se bloquear!")
		}
	
		
		set Usuario.Bloqueado = bloquear
		s status = Usuario.%ValidateObject()
		if ($$$ISERR(status))
		{
			quit ##class(Model.helper.APIHelper).ErroPROC($system.Status.GetErrorText(status))
		}
		d Usuario.%Save()
		s json = {}
		s json.id = Usuario.%Id()
		quit ##class(Model.helper.APIHelper).SucessoPROC(json)
	
	}
	
	ClassMethod redefinirSenha(Username as %String, SenhaAntiga as %String, SenhaNova as %String) As %DynamicObject
	{
		set Usuario = ..getUsuario(Username)		
		
		if (Username = "")
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Username vazio")
		}
		
		if ('Usuario)
		{
		
			quit ##class(Model.helper.APIHelper).ErroPROC("Usuario nao existe")
		}
		
		if (Usuario.PrimeiroLogin = 0)
		{
			if ($System.Encryption.Base32Encode(SenhaNova) = $System.Encryption.Base32Encode(SenhaAntiga))
			{
				quit ##class(Model.helper.APIHelper).ErroPROC("Senhas iguais")
			}
		
			if ($System.Encryption.Base32Encode(SenhaAntiga) '= Usuario.Senha)
			{
					
				quit ##class(Model.helper.APIHelper).ErroPROC("Senha atual nao condiz")
			}
		}
		
		if (($length(SenhaNova) < 5 ) || ($length(SenhaNova) > 20))
		{	
			quit ##class(Model.helper.APIHelper).ErroPROC("Senha deve conter de 5 a 20 caracteres")
			
		}		
		set SenhaAntiga = $System.Encryption.Base32Encode(SenhaAntiga)		
		set Usuario.Senha = $System.Encryption.Base32Encode(SenhaNova)
		d Usuario.%Save()
			
		s json = {}
		s json.id = Usuario.%Id()
		quit ##class(Model.helper.APIHelper).SucessoPROC(json)
	}
	
	ClassMethod resetarSenha(Username as %String, Usuario as %String, SenhaNova as %String) As %DynamicObject
	{
	
		if (Usuario = "")
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Usuario vazio")
		}
		
		set usuario = ##class(Model.db.Usuarios).%OpenId(Usuario)
		
		if (usuario = "") {
			quit ##class(Model.helper.APIHelper).ErroPROC("Usuario nao existe")
		}
		
		
		if (Username = "") {
			quit ##class(Model.helper.APIHelper).ErroPROC("Username vazio")
		}
		
		set UsuarioLogado = ..getUsuario(Username)
		
		if ('usuario)
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Usuario nao existe")
		}
		
		if (UsuarioLogado.Perfil.Nome '= "Gestor")	
		{
			quit ##class(Model.helper.APIHelper).ErroPROC("Perfil n„o È um gestor")
		}
		
		
		if (($length(SenhaNova) < 5 ) || ($length(SenhaNova) > 20))
		{	
			quit ##class(Model.helper.APIHelper).ErroPROC("A Senha deve conter de 5 a 20 caracteres")
			
		}	
		
		set usuario.Senha = $System.Encryption.Base32Encode(SenhaNova)
		set usuario.PrimeiroLogin = 0 
		d usuario.%Save()
			
		s json = {}
		s json.usuario = usuario
		quit ##class(Model.helper.APIHelper).SucessoPROC(json)
	}

	ClassMethod usuarioExiste(Usuario As %String) As %Boolean
	{
		
		if $get(Usuario) = "" quit 0	;"ERRO: Usu√°rio n√£o informado."
			
		set Usuario = $zconvert(Usuario, "C")	;Remove caracteres indesej√°veis
		
		set query = "select ID from Model_db.Usuarios where %alphaup(Username) = %alphaup('"_Usuario_"')"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		if 'rs.%Next() quit 0	;"ERRO: Usu√°rio inexistente."
		
		quit 1
	}

	ClassMethod checaNomeUsuario(Nome As %String) As %Boolean {
		
		if $get(Nome) = "" quit 0
		
		set query = 		"Select ID from Model_db.Usuarios "
		set query = query_	"where %alphaup(Nome) = %alphaup('"_Nome_"') "
		set query = query_	"and Ativo = 1"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		
		if 'rs.%Next() quit 0 ;Nome nao cadastrado
		
		
		quit 1
		
	
	
	}
	
	ClassMethod comparaNome(Nome As %String, Id as %String) As %Boolean 
	{
		
		
		set query = 		"Select ID from Model_db.Usuarios "
		set query = query_	"where %alphaup(Nome) = %alphaup('"_Nome_"') "
		set query = query_	"and Ativo = 1 having ID <> '"_Id_"'"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		if 'rs.%Next() quit 0 ;Nome nao cadastrado
		w query
	
		quit 1
		
		
	}
	
	ClassMethod usuarioAtivo(Usuario As %String) As %Boolean
	{
		
		if $get(Usuario) = "" quit 0	;"ERRO: Usu√°rio n√£o informado."
			
		set Usuario = $zconvert(Usuario, "C")	;Remove caracteres indesej√°veis
		
		set query = "select ID from Model_db.Usuarios "
		set query = query_"where %alphaup(Username) = %alphaup('"_Usuario_"') and "
		set query = query_"  Ativo = 1"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		if 'rs.%Next() quit 0	;"ERRO: Usu√°rio inexistente com Ativo."
		
		quit rs.ID.Ativo
	}
	
	/// Valida se o usu√°rio possui acesso a esta op√ß√£o
	ClassMethod possuiAcesso(usuario As %String, opcao As %String) As %Boolean
	{
		s oUsu = getUsuario(usuario)
		w oUsu.Perfil
	}

	
	ClassMethod getUsuario(Usuario As %String) As Model.db.Usuarios
	{
		set query = "select ID from Model_db.Usuarios "
		set query = query_"where %alphaup(Username) = %alphaup('"_Usuario_"') and "
		set query = query_"  Ativo = 1"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		if 'rs.%Next() quit 0	;"ERRO: Usu√°rio inexistente ou Ativo."
		
		quit rs.ID
	}
	
	ClassMethod getUsuariosPorPerfil(Perfil As %String) As %ListOfObjects
	{
		set query = 				"select ID "
		set query = query_			"FROM Model_db.Usuarios "
		set query = query_			"where Ativo = 1"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		
		set lista = ##class(%Library.ListOfObjects).%New()
		
		while rs.%Next() {
			if (rs.ID.Perfil.Nome = Perfil) {
				do lista.Insert(rs.ID)
			}
		}
		
		quit lista
	}
	
	
	ClassMethod getTodosUsuarios() As %ListOfObjects
	{
		
		set query = 				"select ID "
		set query = query_			"FROM Model_db.Usuarios "
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		set lista = ##class(%Library.ListOfObjects).%New()
		while rs.%Next() {
			
			do lista.Insert(rs.ID)
		}
		
		quit lista
	}

	ClassMethod getTodosUsuariosAtrasados() As %ListOfObjects
	{
		
	set hoje = $horolog+0
	set query = "select MAX(A.Data) as Data, U.ID as ID "
	set query = query_ "from Model_db.Usuarios U, Model_db.Apontamentos A "
	set query = query_ "where A.Usuario = U.ID AND "
	set query = query_ "datepart('weekday',Data) <> 1 AND "
	set query = query_ "datepart('weekday',Data) <> 7 group by A.Usuario"

	
		
		
	set rs = ##class(%ResultSet.SQL).%Prepare(query)
	set lista = ##class(%Library.ListOfObjects).%New()
	
	while rs.%Next()
	{
	
		s diff = 0
		for i = rs.Data:1:hoje {
			if ($zdate(i, 10) '= 0) && ($zdate(i, 10) '= 6) {
				s diff = diff + 1
			}
		}
		

		if ( diff > 3)
		{	
			do lista.Insert(rs.ID)
		}
		
		
	}
	
	quit lista
	}
	
	ClassMethod getUsuarioAtrasado(idUsuario as %Numeric) As %Boolean
	{
		
		set hoje = $horolog+0
		set query = "select MAX(A.Data) as Data, U.ID as ID "
		set query = query_ "from Model_db.Usuarios U, Model_db.Apontamentos A "
		set query = query_ "where A.Usuario = "_idUsuario_" AND "
		set query = query_ "datepart('weekday',Data) <> 1 AND "
		set query = query_ "datepart('weekday',Data) <> 7"		
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		
		s diff = 0
		if ('rs.%Next()){ 
			quit 1
		}

		for i = rs.Data:1:hoje 
		{
			if ($zdate(i, 10) '= 0) && ($zdate(i, 10) '= 6) 
			{
				s diff = diff + 1
			}
		}
		

		if ( diff > 3)
		{	
			quit 1
			
		}
		else
		{
			quit 0
		}
		
	}
	
	ClassMethod getPerfis() {
		set query = 				"select ID "
		set query = query_			"FROM Model_db.Perfis "
		set query = query_			"where Ativo = 1"
		set rs = ##class(%ResultSet.SQL).%Prepare(query)
		
		set lista = ##class(%Library.ListOfObjects).%New()
		
		while rs.%Next() {
			d lista.Insert(rs.ID)
		}
		
		q lista
	}
}