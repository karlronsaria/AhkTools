;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Global Variables --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__THRESHOLD := 0
__STOP_COMBO := "^c"
__IN_MESSAGE := "Auto-clicker on."
__OUT_MESSAGE := "Auto-clicker off."

;;;;;;;;;;;;;;;;;;;;;
; --- Functions --- ;
;;;;;;;;;;;;;;;;;;;;;

ClickMouse() {
	MouseClick, Left
}

;;;;;;;;;;;;;;;;;;;;;;
; --- Main Entry --- ;
;;;;;;;;;;;;;;;;;;;;;;

Main() {
	global
	
	MsgBox,,, %__IN_MESSAGE%, 7
	CoordMode, Mouse, Screen
	Hotkey, %__STOP_COMBO%, StopScript
	
	loop {
		ClickMouse()
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
	