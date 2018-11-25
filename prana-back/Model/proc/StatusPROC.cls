Class Model.proc.StatusPROC Extends (%RegisteredObject)
{

/// Formata a propriedade Mensagem
Method MensagemGet() As %String
{
	
	;Não foi sucesso
	if i%Status '= 1 {
		
		;Houve um erro registrado que precisa ser tratado
		if %objlasterror '= "" {
			quit "ERRO: "_$system.Status.GetErrorText(i%Mensagem)
		}
		else  {
			quit "ERRO: "_i%Mensagem
		}
	}
	
	quit i%Mensagem
}

/// Retorna a mensagem de erro formatada
ClassMethod getErro(status As %Numeric, mensagemIntegridade As %String, mensagemNegocio As %String) As %String
{
	set obj = ##class(Model.proc.Status).%New()
	set obj.Status = $get(status)
	set obj.Mensagem = $get(mensagem)
	
	quit obj
}

}