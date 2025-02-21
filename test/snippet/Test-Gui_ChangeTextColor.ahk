Gui, Margin, 10, 10
Gui, Add, Text, xm ym w80, Black Text
Gui, Add, Text, xm y+20 w80 vRed, Black Text
Gui, Add, Text, xm y+20 w80, Black Text
Gui, Add, Button, xm y+20 w80 gRed, Red
Gui, Add, Button, x+10 yp w80 gBlack, Black
Gui, Show, AutoSize
return

Red:
    GuiControl, +cDA4F49, Red
    GuiControl,, Red, Red Text
return

Black:
    GuiControl, +c000000, Red
    GuiControl,, Red, Black Text
return
