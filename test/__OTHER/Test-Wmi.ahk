; strComputer := "."
; objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . strComputer . "\root\cimv2")
; 
; colPings := objWMIService.ExecQuery("Select * From Win32_PingStatus where Address = 'www.google.com'")._NewEnum ;or ip address like 192.168.1.1
; 
; While colPings[objStatus]
; {
;     If (objStatus.StatusCode="" or objStatus.StatusCode<>0)
;         MsgBox Computer did not respond.
;     Else
;         MsgBox Computer responded.
; }



WinGetHandles() {
	WinGet, windowIds, List  ; ,% "ahk_exe " . executableName
	out := ""
	
	Loop, %windowIds% {
		WinGet, id, ControlListHwnd  ; , % "ahk_id " . windowIds%A_Index%
		
		if (id)
			out .= id . "`r`n"
	}
	
	return out
}

; MsgBox, % "Handles: [" WinGetHandles() "]"


strComputer := "."
objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . strComputer . "\root\cimv2")

my_list := objWMIService.ExecQuery("Select * From Win32_Process")._NewEnum

WinGet, hwnds, ControlListHwnd, A

table := ""

Loop, %hwnds%
{
	WinGetTitle, title, % "ahk_id " . hwnds%A_Index%
	table .= title "`t`t" hwnds%A_Index% "`r`n"
}

MsgBox, % table
; MsgBox, % "HWND: [" hwnds "]"

return

while my_list[item] {
	what := item.CommandLine
	
	if what
		MsgBox, % "[" what "]"
}

ExitApp
