; Source:
;    https://www.autohotkey.com/boards/viewtopic.php?f=6&t=9656
;    https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=77
;    
; Retrieved:
;    2020_05_02

;;;;;;;;;;;;;;;;;;;;
; --- Function --- ;
;;;;;;;;;;;;;;;;;;;;

ScriptInfo(Command) {
    static hEdit := 0, pfn, bkp
    
    if !hEdit {
        hEdit := DllCall("GetWindow", "ptr", A_ScriptHwnd, "uint", 5, "ptr")
        user32 := DllCall("GetModuleHandle", "str", "user32.dll", "ptr")
        pfn := [], bkp := []
        
        for i, fn in ["SetForegroundWindow", "ShowWindow"] {
            pfn[i] := DllCall("GetProcAddress", "ptr", user32, "astr", fn, "ptr")
            DllCall("VirtualProtect", "ptr", pfn[i], "ptr", 8, "uint", 0x40, "uint*", 0)
            bkp[i] := NumGet(pfn[i], 0, "int64")
        }
    }
 
    if (A_PtrSize = 8) {  ; Disable SetForegroundWindow and ShowWindow.
        NumPut(0x0000C300000001B8, pfn[1], 0, "int64")  ; return TRUE
        NumPut(0x0000C300000001B8, pfn[2], 0, "int64")  ; return TRUE
    } else {
        NumPut(0x0004C200000001B8, pfn[1], 0, "int64")  ; return TRUE
        NumPut(0x0008C200000001B8, pfn[2], 0, "int64")  ; return TRUE
    }
 
    static cmds := { ListLines : 65406, ListVars : 65407, ListHotkeys : 65408, KeyHistory : 65409 }
    cmds[Command] ? DllCall("SendMessage", "ptr", A_ScriptHwnd, "uint", 0x111, "ptr", cmds[Command], "ptr", 0) : 0
 
    NumPut(bkp[1], pfn[1], 0, "int64")  ; Enable SetForegroundWindow.
    NumPut(bkp[2], pfn[2], 0, "int64")  ; Enable ShowWindow.
 
    ControlGetText, text,, ahk_id %hEdit%
    return text
}

;;;;;;;;;;;;;;;;
; --- Test --- ;
;;;;;;;;;;;;;;;;

:*:;ListLines;::
    MsgBox, % ScriptInfo("ListLines")
    return
    
:*:;ListVars;::
    MsgBox, % ScriptInfo("ListVars")
    return
    
:*:;ListHotkeys;::
    MsgBox, % ScriptInfo("ListHotkeys")
    return
    
:*:;KeyHistory;::
    MsgBox, % ScriptInfo("KeyHistory")
    return
	