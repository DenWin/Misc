#include <Array.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Local $hWindow, $vWinStyle, $aWinNormal[1][3]
Local $aWinList = WinList("[REGEXPTITLE:(?i)(.+)]")
For $i = $aWinList[0][0] To 1 Step - 1
   If $aWinList[$i][0] = "" Then ContinueLoop
   $hWindow = WinGetHandle($aWinList[$i][1], "")
   If Not $hWindow Then ContinueLoop
   $vWinStyle = _WinAPI_GetWindowLong($hWindow, $GWL_STYLE)
   ConsoleWrite( $aWinList[$i][0] & ": " & WinGetState($aWinList[$i][1]) & "; " & BitAND(WinGetState($aWinList[$i][1]), 4) & @LF )

   If 	     BitAND(WinGetState($aWinList[$i][1]), 4) = 4 _
		 And BitAND($vWinStyle, $WS_VISIBLE) = $WS_VISIBLE _
		 And BitAND($vWinStyle, $WS_MINIMIZE) <> $WS_MINIMIZE _
		 And BitAND($vWinStyle, $WS_MINIMIZEBOX) = $WS_MINIMIZEBOX _
		 And BitAND($vWinStyle, $WS_MAXIMIZEBOX) = $WS_MAXIMIZEBOX Then _ArrayAdd($aWinNormal, $aWinList[$i][0] & "|" & $aWinList[$i][1] & "|" & $aWinList[$i][1])
Next
$aWinNormal[0][0] = UBound($aWinNormal) - 1
;_ArrayDisplay($aWinNormal)