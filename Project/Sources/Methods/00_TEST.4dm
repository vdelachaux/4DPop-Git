//%attributes = {}
C_OBJECT:C1216($o)
C_COLLECTION:C1488($c)

$o:=git 

$o.execute("log --abbrev-commit --oneline")
$o.execute("log --abbrev-commit --format=%s,%an,%h,%aD")

$c:=Split string:C1554($o.result;"\n")