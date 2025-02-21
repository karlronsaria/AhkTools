Gui, +LastFound
WinSet, Transparent, 180
Gui, Color, 808080
Gui, Margin, 0, 0
Gui, Font, s11 cD0D0D0 Bold
Gui, Add, Progress, x-1 y-1 w212 h31 Background404040 Disabled hwndHPROG
Control, ExStyle, -0x20000, , ahk_id %HPROG% ; propably only needed on Win XP
Gui, Add, Text, x0 y0 w210 h30 BackgroundTrans Center 0x200 gGuiMove vCaption, Example
Gui, Font, s8
Gui, Add, Text, x7 y+10 w196 r1 +0x4000 vTX1 gJohn, John Lennon
Gui, Add, Text, x7 y+10 w196 r1 +0x4000 vTX2 gPaul, Paul McCartney
Gui, Add, Text, x7 y+10 w196 r1 +0x4000 vTX3 gRingo, Ringo Starr
Gui, Add, Text, x7 y+10 w196 r1 +0x4000 vTX4 gClose, Close
Gui, Add, Text, x7 y+10 w196 h5 vP
GuiControlGet, P, Pos
H := PY + PH
Gui, -Caption
WinSet, Region, 0-0 w210 h%H% r6-6
Gui, Show, w210 NA
WinSet AlwaysOnTop
Return

GuiMove:
   PostMessage, 0xA1, 2
return

John:
MsgBox, You clicked John.
return

Paul:
MsgBox, You clicked Paul.
return

Ringo:
MsgBox, You clicked Ringo.
return

Close:
ExitApp
