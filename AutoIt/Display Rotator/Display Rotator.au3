#include <WinAPIGdi.au3>
#include <Misc.au3>

opt( "TrayIconHide",1 ) ;I dont like having unnecessary icons on my tray. Feel free to disable.
$wintitle="Display Rotator"
_Singleton( $wintitle )
RegWrite( "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", $wintitle, "REG_SZ", @ScriptFullPath ) ;AutoStart with Windows
HotKeySet( "^!{up}",    "_Landscape" )         ; Ctrl + Alt + Up
HotKeySet( "^!{down}",  "_Landscape_flipped" ) ; Ctrl + Alt + Down
HotKeySet( "^!{left}",  "_Portrait" )          ; Ctrl + Alt + Left
HotKeySet( "^!{right}", "_Portrait_flipped" )  ; Ctrl + Alt + Right
Global Enum $screenOrientationLandscape, $screenOrientationPortrait, $screenOrientationLandscapeFlipped, $screenOrientationPortraitFlipped
Global Const $tagDEVMODE_DISPLAY2 = 'wchar DeviceName[32];ushort SpecVersion;ushort DriverVersion;ushort Size;ushort DriverExtra;dword Fields;' & $tagPOINT & ';dword DisplayOrientation;dword DisplayFixedOutput;short Color;short Duplex;short YResolution;short TTOption;short Collate;wchar Unused2[32];ushort LogPixels;dword BitsPerPel;dword PelsWidth;dword PelsHeight;dword DisplayFlags;dword DisplayFrequency'

While 1
   Sleep( 60000 )
WEnd

Func _Landscape()
   _ChangeDisplaySettings( $screenOrientationLandscape )
EndFunc   ;==>_Landscape

Func _Portrait()
   _ChangeDisplaySettings( $screenOrientationPortrait )
EndFunc   ;==>_Portrait

Func _Landscape_flipped()
   _ChangeDisplaySettings( $screenOrientationLandscapeFlipped )
EndFunc   ;==>_Landscape_flipped

Func _Portrait_flipped()
   _ChangeDisplaySettings( $screenOrientationPortraitFlipped )
EndFunc   ;==>_Portrait_flipped

Func _ChangeDisplaySettings( $orientation )
   Local $mousePos        = _WinAPI_GetMousePos()
   Local $hMonitor 	      = _WinAPI_MonitorFromPoint( $mousePos )
   Local $monitorInfo     = _WinAPI_GetMonitorInfo( $hMonitor )
   Local $deviceName      = $monitorInfo[3]

   Local $tDEVMODE        = _WinAPI_EnumDisplaySettings_v2( $deviceName, $ENUM_CURRENT_SETTINGS )
   Local $tDEVMODENew     = _SetOrientation( $tDEVMODE, $orientation )
   _WinAPI_ChangeDisplaySettingsEx( $deviceName, $tDEVMODENew )
   _SetMousePos( $hMonitor )
EndFunc   ;==>_ChangeDisplaySettings

Func _SetOrientation( $tDEVMODE, $orientation )
   $tDEVMODE.Fields             = BitOR( $tDEVMODE.Fields, $DM_DISPLAYORIENTATION )
   $tDEVMODE.DisplayOrientation = $orientation
   Select
      Case ( $orientation = 1 ) Or ( $orientation = 3 )
         If $tDEVMODE.PelsWidth  > $tDEVMODE.PelsHeight Then
            $v=$tDEVMODE.PelsWidth
            $tDEVMODE.PelsWidth  = $tDEVMODE.PelsHeight
            $tDEVMODE.PelsHeight = $v
         Else
            $tDEVMODE.PelsWidth  = $tDEVMODE.PelsWidth
            $tDEVMODE.PelsHeight = $tDEVMODE.PelsHeight
         EndIf
      Case ( $orientation = 0 ) Or ( $orientation = 2 )
         If $tDEVMODE.PelsWidth  > $tDEVMODE.PelsHeight Then
            $tDEVMODE.PelsWidth  = $tDEVMODE.PelsWidth
            $tDEVMODE.PelsHeight = $tDEVMODE.PelsHeight
         Else
            $v=$tDEVMODE.PelsWidth
            $tDEVMODE.PelsWidth  = $tDEVMODE.PelsHeight
            $tDEVMODE.PelsHeight = $v
         EndIf
   EndSelect
   Return $tDEVMODE
EndFunc   ;==>_SetOrientation

Func _SetMousePos( $hMonitor )
   Local $mousePos    = DllStructCreate( $tagPOINT )
   Local $monitorInfo = _WinAPI_GetMonitorInfo( $hMonitor )
   Local $Left        = DllStructGetData( $monitorInfo[1], 1 )
   Local $Top         = DllStructGetData( $monitorInfo[1], 2 )
   Local $Right       = DllStructGetData( $monitorInfo[1], 3 )
   Local $Bottom      = DllStructGetData( $monitorInfo[1], 4 )

   DllStructSetData($mousePos, "X", ( $Left + $Right  ) /2 )
   DllStructSetData($mousePos, "Y", ( $Top  + $Bottom ) /2 )
   _WinAPI_SetMousePos( $mousePos )
 EndFunc   ;==>_SetMousePos

Func _WinAPI_EnumDisplaySettings_v2( $sDevice, $iMode )
	Local $sTypeOfDevice = 'wstr'
	If Not StringStripWS( $sDevice, $STR_STRIPLEADING + $STR_STRIPTRAILING ) Then
		$sTypeOfDevice = 'ptr'
		$sDevice = 0
	 EndIf

	Local $tDEVMODE = DllStructCreate( $tagDEVMODE_DISPLAY2 )
	DllStructSetData( $tDEVMODE, 'Size',        DllStructGetSize( $tDEVMODE ) )
	DllStructSetData( $tDEVMODE, 'DriverExtra', 0 )

	Local $aRet = DllCall( 'user32.dll', 'bool', 'EnumDisplaySettingsW', $sTypeOfDevice, $sDevice, 'dword', $iMode, 'struct*', $tDEVMODE )
	If @error Or Not $aRet[0] Then Return SetError( @error + 10, @extended, 0 )

	Return $tDEVMODE
 EndFunc   ;==>_WinAPI_EnumDisplaySettings_v2

Func _WinAPI_ChangeDisplaySettingsEx( $deviceName, $tDevMode, $dwFlags = 0 )
   Local $aRet = DllCall( "user32.dll", "LONG", "ChangeDisplaySettingsExW", "wstr", $deviceName, "ptr", DllStructGetPtr( $tDevMode ), "hwnd", 0 , "DWORD", $dwFlags, "lparam", 0 )
   If @error Then Return SetError( @error, @extended, 0 )
   Return $aRet[0]
EndFunc   ;==>_WinAPI_ChangeDisplaySettingsEx

Func _WinAPI_SetMousePos( $mousePos )
   Local $iMode = Opt("MouseCoordMode", 1)
   Local $aRet = DllCall( "user32.dll", "Bool", "SetCursorPos", "int", $mousePos.X, "int", $mousePos.Y )
   Opt("MouseCoordMode", $iMode)
   If @error Then Return SetError( @error, @extended, 0 )
   Return $aRet[0]
EndFunc   ;==>_WinAPI_SetMousePos
