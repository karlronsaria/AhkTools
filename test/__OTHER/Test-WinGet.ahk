
; WinGet, Path, ProcessPath, A
; MsgBox, % "Path: [" Path "]"


; WinGet pid, PID, A
; wmi := ComObjGet("winmgmts:")
; 
; queryEnum := wmi.ExecQuery(""
; 	. "Select * from Win32_Process where ProcessId=" . pid)
; 	._NewEnum()
; 	
; if queryEnum[process] {
; 	MsgBox, % "[" process.CommandLine "]"
; }


Gui, Add, ListView, x2 y0 w1000 h800 +Resize, Process PID|Name|Handle|Command Line
for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process")
    LV_Add("", proc.ProcessID, proc.Name, proc.Handle, proc.CommandLine)
Gui, Show,, Process List
; ExitApp

DetectHiddenWindows On

WinGet, all, List ;get all hwnd
out := ""

Loop, %all%
{
	WinGet, process, ProcessName, % "ahk_id " all%A_Index%
	WinGet, id, ID, % "ahk_id " all%A_Index%
	; WinGet, pid, PID, % "ahk_id " all%A_Index%
	; out .= process "`t`t" pid "`r`n"
	out .= process "`t`t" id "`r`n"
}

MsgBox, % out






