var $e:=FORM Event:C1606

Case of

		// ______________________________________________________
	: ($e.code=On Load:K2:1)

		cs:C1710.ui.input.new("tag").focus()

		// ______________________________________________________
	: ($e.code=On Clicked:K2:4)

		Case of

				// ______________________________________________________
			: ($e.objectName="cancel")

				Form:C1466.me.cancel()

				// ______________________________________________________
			: ($e.objectName="ok")

				If (Length:C16(Form:C1466.tag)>0)

					Form:C1466.newTag:=True:C214
					Form:C1466.me.accept()

				Else

					BEEP:C151

				End if

				// ______________________________________________________
		End case

		// ______________________________________________________
End case
