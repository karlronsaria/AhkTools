WinGet, windows, List

Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle, wt, ahk_id %id%
	WinGetClass, wc, ahk_id %id%
	r .= wt . "`r`n"
	r .= wc . "`r`n" . "`r`n"
}

MsgBox %r%
ExitApp
