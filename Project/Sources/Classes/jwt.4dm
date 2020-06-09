/*————————————————————————————————————————————————————————
Construct a jwt object.

cs.jwt.new( settings) -> jwt

settings.type: "RSA" or "ECDSA" to generate new keys. "PEM" to load an existing key from settings.pem
settings.size: size of RSA key to generate (2048 by default)
settings.curve: curve of ECDSA to generate ("prime256v1" for ES256 (default), "secp384r1" for ES384, "secp521r1" for ES512)
settings.pem: PEM definition of an encryption key to load
settings.secret: default password to use for HS@ algorithm
——————————————————————————*/
Class constructor
	
	C_OBJECT:C1216($1)
	
	If (Count parameters:C259()>0)
		
		This:C1470.secret:=String:C10($1.secret)  // for HMAC
		This:C1470.key:=4D:C1709.CryptoKey.new($1)  // load a pem or generate a new ECDSA/RSA key
		
	Else 
		
		This:C1470.secret:=""
		This:C1470.key:=Null:C1517
		
	End if 
	
/*————————————————————————————————————————————————————————
Builds a JSON Web token from its payload.
	
jwt.sign( payloadObject ; options) -> tokenString
	
options.algorithm: a JWT algorithm ES256, ES384, RS256, HS256, etc...
options.secret : password for HS@ algorithms
——————————————————————————*/
Function sign
	
	C_OBJECT:C1216($1)  // Payload
	C_OBJECT:C1216($2)  // Options
	C_TEXT:C284($0)  // Token
	
	C_TEXT:C284($tHeader;$tPayload;$tSignature;$tHashAlgorittm)
	C_OBJECT:C1216($o;$oOptions;$oSignOptions)
	
	$oOptions:=$2
	
	$o:=New object:C1471(\
		"typ";"JWT";\
		"alg";$oOptions.algorithm)
	
	BASE64 ENCODE:C895(JSON Stringify:C1217($o);$tHeader;*)
	
	BASE64 ENCODE:C895(JSON Stringify:C1217($1);$tPayload;*)
	
	$tHashAlgorittm:=This:C1470._hashFromAlgorithm($oOptions.algorithm)
	
	Case of 
			
			  //________________________________________
		: ($oOptions.algorithm="ES@")\
			 | ($oOptions.algorithm="RS@")\
			 | ($oOptions.algorithm="PS@")
			
			  // need a private key
			If (Asserted:C1132(This:C1470.key#Null:C1517))
				
				$oSignOptions:=New object:C1471(\
					"hash";$tHashAlgorittm;\
					"pss";$oOptions.algorithm="PS@";\
					"encoding";"Base64URL")
				
				$tSignature:=This:C1470.key.sign($tHeader+"."+$tPayload;$oSignOptions)
				
			End if 
			
			  //________________________________________
		: ($oOptions.algorithm="HS@")
			
			C_TEXT:C284($tSecret)
			
			$tSecret:=Choose:C955($oOptions.secret=Null:C1517;String:C10(This:C1470.secret);String:C10($oOptions.secret))
			$tSignature:=This:C1470.HMAC($tSecret;$tHeader+"."+$tPayload;$tHashAlgorittm)
			
			  //________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"unknown algorithm")
			
			  //________________________________________
	End case 
	
	$0:=$tHeader+"."+$tPayload+"."+$tSignature
	
/*————————————————————————————————————————————————————————
Verify and decode a JSON Web token.
	
jwt.verify( tokenString ; options) -> status
	
options.secret : password for HS@ algorithms
	
status.success : true if token is valid
status.header: token header object
status.payload : token payload object
——————————————————————————*/
Function verify
	
	C_OBJECT:C1216($0)  // Status
	C_TEXT:C284($1)  // Token
	C_OBJECT:C1216($2)  // Options
	
	C_TEXT:C284($tToken;$tHeader;$tPayload;$tSignature;$tHashAlgorittm;$tAlgorithm)
	C_TEXT:C284($tHeaderDecoded;$tPayloadDecoded;$tVerifiedSignature)
	C_LONGINT:C283($start;$end)
	C_OBJECT:C1216($oHeader;$oPayload;$oOptions;$oSignOptions)
	C_BOOLEAN:C305($success)
	
	$tToken:=$1
	$oOptions:=$2
	$start:=Position:C15(".";$tToken;*)
	
	If ($start>0)
		
		$tHeader:=Substring:C12($tToken;1;$start-1)
		$end:=Position:C15(".";$tToken;$start+1;*)
		
		If ($end>0)
			
			$tPayload:=Substring:C12($tToken;$start+1;$end-$start-1)
			$tSignature:=Substring:C12($tToken;$end+1;Length:C16($tToken))
			
		End if 
	End if 
	
	BASE64 DECODE:C896($tHeader;$tHeaderDecoded;*)
	BASE64 DECODE:C896($tPayload;$tPayloadDecoded;*)
	
	$oHeader:=JSON Parse:C1218($tHeaderDecoded)
	$oPayload:=JSON Parse:C1218($tPayloadDecoded)
	
	If (Value type:C1509($oHeader)=Is object:K8:27)\
		 & (Value type:C1509($oPayload)=Is object:K8:27)
		
		$tAlgorithm:=String:C10($oHeader.alg)
		$tHashAlgorittm:=This:C1470._hashFromAlgorithm($tAlgorithm)
		
		Case of 
				
				  //________________________________________
			: ($tAlgorithm="HS@")  // HMAC
				
				C_TEXT:C284($tSecret)
				$tSecret:=Choose:C955($oOptions.secret=Null:C1517;String:C10(This:C1470.secret);String:C10($oOptions.secret))
				$tVerifiedSignature:=This:C1470.HMAC($tSecret;$tHeader+"."+$tPayload;$tHashAlgorittm)
				$success:=(Length:C16($tSignature)=Length:C16($tVerifiedSignature)) & (Position:C15($tSignature;$tVerifiedSignature;*)=1)
				
				  //________________________________________
			: ($tAlgorithm="ES@")\
				 | ($tAlgorithm="RS@")\
				 | ($tAlgorithm="PS@")
				
				If (Asserted:C1132(This:C1470.key#Null:C1517))
					
					$oSignOptions:=New object:C1471(\
						"hash";$tHashAlgorittm;\
						"pss";$tAlgorithm="PS@";\
						"encoding";"Base64URL")
					
					$success:=This:C1470.key.verify($tHeader+"."+$tPayload;$tSignature;$oSignOptions).success
					
				End if 
				
				  //________________________________________
		End case 
	End if 
	
	$0:=New object:C1471(\
		"success";$success;\
		"header";$oHeader;\
		"payload";$oPayload)
	
/*————————————————————————————————————————————————————————*/
Function HMAC
	
	C_VARIANT:C1683($1;$2)  // Key and message
	C_TEXT:C284($3)  // 'SHA1' 'SHA256' or 'SHA512'
	C_TEXT:C284($0)  // Hexa result
	
	  // accept blob or text for key and message
	C_BLOB:C604($xKey;$xMessage)
	
	Case of 
			
			  //________________________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			TEXT TO BLOB:C554($1;$xKey;UTF8 text without length:K22:17)
			
			  //________________________________________
		: (Value type:C1509($1)=Is BLOB:K8:12)
			
			$xKey:=$1
			
			  //________________________________________
	End case 
	
	Case of 
			
			  //________________________________________
		: (Value type:C1509($2)=Is text:K8:3)
			
			TEXT TO BLOB:C554($2;$xMessage;UTF8 text without length:K22:17)
			
			  //________________________________________
		: (Value type:C1509($2)=Is BLOB:K8:12)
			
			$xMessage:=$2
			
			  //________________________________________
	End case 
	
	C_BLOB:C604($xOuterKey;$xInnerKey;$x)
	C_LONGINT:C283($lBlockSize;$i;$lByte;$lAlgorithm)
	C_TEXT:C284($tAlgorithm)
	
	$tAlgorithm:=$3
	
	Case of 
			
			  //________________________________________
		: ($tAlgorithm="SHA1")
			
			$lAlgorithm:=SHA1 digest:K66:2
			$lBlockSize:=64
			
			  //________________________________________
		: ($tAlgorithm="SHA256")
			
			$lAlgorithm:=SHA256 digest:K66:4
			$lBlockSize:=64
			
			  //________________________________________
		: ($tAlgorithm="SHA512")
			
			$lAlgorithm:=SHA512 digest:K66:5
			$lBlockSize:=128
			
			  //________________________________________
		Else 
			
			ASSERT:C1129(False:C215;"bad hash algo")
			
			  //________________________________________
	End case 
	
	If (BLOB size:C605($xKey)>$lBlockSize)
		
		BASE64 DECODE:C896(Generate digest:C1147($xKey;$lAlgorithm;*);$xKey;*)
		
	End if 
	
	If (BLOB size:C605($xKey)<$lBlockSize)
		
		SET BLOB SIZE:C606($xKey;$lBlockSize;0)
		
	End if 
	
	ASSERT:C1129(BLOB size:C605($xKey)=$lBlockSize)
	
	SET BLOB SIZE:C606($xOuterKey;$lBlockSize)
	SET BLOB SIZE:C606($xInnerKey;$lBlockSize)
	
	  //%R-
	For ($i;0;$lBlockSize-1;1)
		
		$lByte:=$xKey{$i}
		$xOuterKey{$i}:=$lByte ^| 0x005C
		$xInnerKey{$i}:=$lByte ^| 0x0036
		
	End for 
	
	  //%R+
	
	  // Append $message to $innerKey
	COPY BLOB:C558($xMessage;$xInnerKey;0;$lBlockSize;BLOB size:C605($xMessage))
	BASE64 DECODE:C896(Generate digest:C1147($xInnerKey;$lAlgorithm;*);$x;*)
	
	  // Append hash(innerKey + message) to outerKey
	COPY BLOB:C558($x;$xOuterKey;0;$lBlockSize;BLOB size:C605($x))
	
	$0:=Generate digest:C1147($xOuterKey;$lAlgorithm;*)
	
/*————————————————————————————————————————————————————————*/
Function _hashFromAlgorithm
	
	C_TEXT:C284($0;$1)
	
	Case of 
			
			  //________________________________________
		: ($1="@256")
			
			$0:="SHA256"
			
			  //________________________________________
		: ($1="@384")
			
			$0:="SHA384"
			
			  //________________________________________
		: ($1="@512")
			
			$0:="SHA512"
			
			  //________________________________________
	End case 
	
/*————————————————————————————————————————————————————————*/