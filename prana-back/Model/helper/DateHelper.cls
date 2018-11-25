Class Model.helper.DateHelper Extends %RegisteredObject
{

ClassMethod getMes(Mes As %String) As %String
{
	
	s mesC("jan") = "01"
	s mesC("fev") = "02"
	s mesC("mar") = "03"
	s mesC("abr") = "04"
	s mesC("mai") = "05"
	s mesC("jun") = "06"
	s mesC("jul") = "07"
	s mesC("ago") = "08"
	s mesC("set") = "09"
	s mesC("out") = "10"
	s mesC("nov") = "11"
	s mesC("dev") = "12"

	quit mesC(Mes)
}

//converte 01/abr para 01/04/{ano atual}
ClassMethod dataExcelFormat(data) As %String {
	s diaCru 			= $PIECE(data, "/", 1)
	s mesCru 			= ##class(Model.helper.DateHelper).getMes($PIECE(data, "/", 2)) 	
	s anoAtual 			= $PIECE(##class(%Library.UTC).NowLocal(), "-", 1)

	quit diaCru_"/"_mesCru_"/"_anoAtual
}

}
