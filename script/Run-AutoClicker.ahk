;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Global Variables --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__DELAY := 0
__STOP_COMBO := "^c"
__IN_MESSAGE := "Auto-clicker set to click LEFT every " __DELAY " milliseconds. Click OK to start. Press CTL + C to stop."
__OUT_MESSAGE := "Auto-clicker off."

;;;;;;;;;;;;;;;;;;;;;;
; --- Main Entry --- ;
;;;;;;;;;;;;;;;;;;;;;;

Main() {
    global
    
    MsgBox,,, %__IN_MESSAGE%, 7
    CoordMode, Mouse, Screen
    Hotkey, %__STOP_COMBO%, StopScript
    
    loop {
        MouseClick, Left
        Sleep, __DELAY
    }
}

Main()
Return

;;;;;;;;;;;;;;;;;;;;;;;
; --- Subroutines --- ;
;;;;;;;;;;;;;;;;;;;;;;;

StopScript:
    MsgBox,,, %__OUT_MESSAGE%, 7
    ExitApp
    