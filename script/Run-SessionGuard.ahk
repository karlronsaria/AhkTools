;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Global Variables --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__MINUTE := 60000
__TIMEOUT := 2 * __MINUTE
__THRESHOLD := 7 * __MINUTE
__STOP_COMBO := "^c"
__DISTANCE_IN_PIXELS := 5
__IN_MESSAGE := "Session Guard on."
__OUT_MESSAGE := "Session Guard off."

;;;;;;;;;;;;;;;;;;;;;
; --- Functions --- ;
;;;;;;;;;;;;;;;;;;;;;

TwitchMouse(distance) {
	MouseGetPos, x, y
	MouseMove, % x + distance, % y + distance
	MouseMove, % x, % y
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
		Sleep, __TIMEOUT
		
		if (A_TimeIdle >= __THRESHOLD) {
			TwitchMouse(__DISTANCE_IN_PIXELS)
		}
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
	
