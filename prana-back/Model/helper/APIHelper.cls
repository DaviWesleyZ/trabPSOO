Class Model.helper.APIHelper Extends %RegisteredObject
{
	ClassMethod Sucesso(obj As %DynamicObject) As %Status
	{
		s json = {}
		s json.status = 1
		s json.data = obj
	
		write json.%ToJSON()
		quit $$$OK
	}
	
	ClassMethod Erro(msg) As %Status
	{
		s json = {}
		s json.status = 0
		s json.error = msg
	
		write json.%ToJSON()
		quit $$$OK
	}

	//quando vc quer fazer um proc retornar um json, para ter masi de uma informacao de retorno, Ex numDeInseridos = 2, numDeErros = 3
	ClassMethod SucessoPROC(obj As %DynamicObject) As %DynamicObject {
		s resposta = {}
		s resposta.status = 1
		s resposta.data = obj
		quit resposta
	}
	
	//quando vc quer fazer um proc retornar um json
	ClassMethod ErroPROC(msg) As %DynamicObject {
		s resposta = {}
		s resposta.status = 0
		s resposta.error = msg
		quit resposta
	}
	
	
	
}