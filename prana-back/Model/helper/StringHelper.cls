Class Model.helper.StringHelper Extends %RegisteredObject
{

ClassMethod sanitizeString(str As %String) As %String
{
	
	s str = $REPLACE(str, "'", "")
	s str = $REPLACE(str, """", "")
	s str = $REPLACE(str, $c(10), "")
	s str = $REPLACE(str, $c(12), "")
	s str = $REPLACE(str, $c(13), "")
	
	quit str
	
}

}