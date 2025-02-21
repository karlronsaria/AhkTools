Gui, -Caption +e0x80 +Toolwindow
TransColor = D4D1C8
Gui, Color, %transColor%
Gui, Add, Button, x2 y2 w100 h24 , Test1
Gui, Add, Button, x104 y2 w100 h24 , Test2
Gui, Add, Button, x206 y2 w100 h24 , Test3
Gui, Show, x500 y500 w308 h28

WinGet, k_ID, ID, A   ; Get its window ID.
WinSet, AlwaysOnTop, On, ahk_id %k_ID%
WinSet, TransColor, %TransColor% 100, ahk_id %k_ID%

Gui, 2:-Caption +e0x80 +Toolwindow
Gui, 2:Color, white
Gui, 2:Add, Progress, x2 y2 w100 h24 cFFFF66, 100
Gui, 2:Add, Progress, x104 y2 w100 h24 c87BBFF, 100
Gui, 2:Add, Progress, x206 y2 w100 h24 c00B050, 100
Gui, 2:Show, x500 y500 w308 h28

Return

ButtonTest1:
MsgBox You clicked Test1.
Return

ButtonTest2:
MsgBox You clicked Test2.
Return

ButtonTest3:
MsgBox You clicked Test3.
Return

Esc::ExitApp
