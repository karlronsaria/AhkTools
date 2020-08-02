; =====================================================================================================================
; Name:				Show me that color
; Description:		Use clipboard to display selected hex color or R,G,B text value
; Topic:           	https://www.autohotkey.com/boards/viewtopic.php?f=6&t=67586
; Sript version:	(v1.57.5 - didn't follow exactly) by rommmcek slightly modified by Speedmaster (v1.58)
; AHK Version:		1.1.24.03 (A32/U32/U64)
; Tested on:		Win 7 (x64)
; Author:			SpeedMaster
; How to use:	  	This script should be run normally or via command (for ex. f9::run, Show_Me_That_Color.ahk) 
;					in your main script. Then do one of the folowing:
;					1. Select text color values following by the F2. (copies any selected text)
;                   2. Set range with #LButton and draging the mouse following by the F2. (gets colors in the marked range)
;
;					The script copies any selected text to the variable
;                   or gets colors in the marked range (on raster spots - evry 25 pixels by default)
;                   and displays the hexadecimal colors or R,G,B colors in a GUI
;					Right click a square to copy it's value to clipboard.
;                   Shortcuts:
;                               F2    - Copy colors
;                               F3    - Open a stored color chart
;                               F4    - Change the color of the range frame
;                               F5    - Set new raster value when range is set (default: 25 pixel)
;                               F6    - Save color chart displayed via Gui
;                               Esc   - Exit or Hide GUI/Frame (set ExitOnGuiclose to true or false in settings section)
;                               +F2   - Show or Hide GUI.
;                               +F4   - Show Frame again (after it was hidden)
;                               ^Esc  - Exit application
;                               Ctrl  - When Mouse is over color: Open Color dialog
;                               Wheel - When Color dialog is opend and Edit control is focused: Increment/Decrease value
;                               Ctrl  - When Color dialog is opend: Reset Color
;                               Enter - When Color dialog is opend (or "OK" Button): Copy (current) color to Clipboard
;                               Esc   - When Color dialog is opend (or "Cancel" Button): Exit Color dialog
;=======================================================================================================================
#NoEnv  
version:=1.58

#singleinstance force
SetBatchLines, -1

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen


WM_MOUSEMOVE := 0x200
OnMessage(WM_MOUSEMOVE, "OnMouseMove")

;----------------------settings----------------------------
raster:= 25
cols:=5
rows:=30
capital_font:=false         ; if true force GUI to display all captured values with capital font.
ExitOnGuiclose:= !A_Args.1   ; if true exit application  (false = hide GUI)
;----------------------------------------------------------
SoundBeep, 400
SoundBeep, 800

if ExitOnGuiclose
    gosub, copyClr
Return

BuildGui:
gui, add, text, w10 h10 x0 y0 +border ginputbox,
gui, font, s8

Grid(ctr:="listview", clln:="color", type:=0, gpx:=10, gpy:=10, cols:=cols, rows:=rows, cllw:=50+10, cllh:=40, wsp:=55+10, hsp:=60, opt:="  -Hdr -E0x200", fill:="")

Grid(ctr:="edit", clln:="t", type:=0, gpx:=10, gpy:=51, cols:=cols, rows:=rows, cllw:=50+10, cllh:=15, wsp:=55+10, hsp:=60, opt:=" +Multi -E0x200 -0x200000 -Wrap -WantReturn +ReadOnly 0x201 ", fill:="")

loop, % cols*rows
{
	guicontrol, % "+backgroundffffff" , color%a_index%
	GuiControl, MoveDraw, color%a_index% 
	color%a_index%:=""	
	t%a_index%:=""
	drawchar("t" a_index, "")
}
Return

copyClr:
lastfound:=0
clipboard:=""
sleep, 100
send, ^c
ClipWait, 0.2, 1


Clip=%Clipboard% ; Convert clipboard to plain text

ShowClr:
lastfound:=0
Gui, Destroy
sleep, 100
gosub, BuildGui
colors:=[]
pos := 0 
m := ""
while (pos := RegExMatch(clip, "[[:xdigit:]]{6}|\b\d{1,3}\s?,\s?\d{1,3}\s?,\s?\d{1,3}\b(?CCheckRGB)", m, (instr(m,",")) ? pos + StrLen(m) : pos+1))
{
   if (instr(m,","))
	colors.push(hextorgb(rgbtohex(m),"parse"))
   else
	colors.push(m)
	guicontrol, % "+background" (instr(colors[a_index],",") ? rgbToHex(colors[a_index]) : colors[a_index]),  color%a_index%  
	GuiControl, MoveDraw, color%a_index%  
	t%a_index%:=colors[a_index]

	if capital_font
		StringUpper, t%a_index%, t%a_index%
		
	drawchar("t" a_index, t%a_index%)

	if (lastfound<(cols*rows))
	lastfound++   
}



gui, +resize

if (lastfound) && (lastfound<=(cols*rows)) 
	lfpos:=getcontrol("t" lastfound, "yh")+5
else if (lastfound) && (lastfound>cols*rows)
	lfpos:=getcontrol("t" cols*rows, "yh")+5
else 
	lfpos:=getcontrol("t" cols*5, "yh")+5

if NewCols {
    Gosub apply
    return
}
if (lfpos) && (lfpos < A_ScreenHeight)
    gui, Show, % " h" lfpos, Show Me That Color v%version%
else
    gui, Show,, Show Me That Color v%version%
return

GuiContextMenu:
;if (substr(a_guicontrol,1,5)=="color")
;{
	;picked:= "t" . substr(a_guicontrol,6)
	;textout :=  % %picked%
	;if (StrLen(textout)=6) || instr(textout, ",") {
		;StringUpper, textout, textout
            clipboard:=textout
            TrayTip, Color Copied,  % (StrLen(textout)=6) ? "#" textout : textout
    ;}
;}	
return

MouseMoveRoutine:
if (substr(a_guicontrol,1,5)=="color")
{
	picked:= "t" . substr(a_guicontrol,6)
	textout :=  % %picked%
	if (StrLen(textout)=6) || instr(textout, ",") {
		StringUpper, textout, textout
        ClrUnderM:= textout
	}
 }  else ClrUnderM:= ""
Return

~Ctrl::
    KeyWait, Ctrl
    if (WinActive("Show Me That Color v" version) && ClrUnderM!="") {
        if InStr(ClrReset:=ClrUnderM, ",")
            C:=StrSplit(ClrUnderM, ","), C:=ColorDlg(C.1, C.2, C.3, WinExist("A")), C>=0? Clipboard:=C: ""
        else C:=ColorDlg(ClrUnderM,,, WinExist("A")), C>=0? Clipboard:=C: ""
    }
return

apply:

i:=j:=k:=0

     While i++ <= z:=((rows*cols)//newcols) {
        while j++ < newcols{
			k++
			if (i=1 && j=1) {
					guicontrol, move, color%k%, % "x" 10 "y" 10
					guicontrol, move, t%k%, % "x" 10 "y" 10+41
				}
			if (i=1 && j>1)	{
					guicontrol, move, color%k%, % "x" ((a_index-1)*(wsp))+10 "y" 10
					guicontrol, move, t%k%, % "x" ((a_index-1)*(wsp))+10 "y" 10+41
				}
			if (i>1 && j=1) {
				guicontrol, move, color%k%, % "x" 10 "y" ((i-1)*60)+10
				guicontrol, move, t%k%, % "x" 10 "y" ((i-1)*60)+41+10
			}
			
			if (i>1 && j>1) {
				guicontrol, move, color%k%, % "x" ((a_index-1)*(wsp))+10 "y" ((i-1)*60)+10
				guicontrol, move, t%k%, % "x" ((a_index-1)*(wsp))+10 "y" ((i-1)*60)+41+10
			}	
			
		} j:=0
	} i:=j:=0
	gui, color


edgeX:=0
loop, % cols*rows 
{
q:=getcontrol("color" a_index, "xw"), (q>edgeX) ? (edgeX:=q) : Null
}

if (lastfound) && (getcontrol("t" lastfound, "yh") < A_ScreenHeight)
	gui, show, % "w" edgeX+10 " h" getcontrol("t" lastfound, "yh")+5, Show Me That Color v%version%
else
	gui, show, % "w" edgeX+10, Show Me That Color v%version%

return

inputbox:
oCols:=NewCols? NewCols: Cols
InputBox, NewCols, Show Me That Color, Columns,, 150, 125,,,,, % NewCols? NewCols: Cols
If !ErrorLevel
    gosub, apply
else NewCols:=oCols
return

drawchar(varname, chartodraw:="@", color:="")
{
 global
guicontrol,, %varname%, %chartodraw%
if (color)
colorcell(varname, color)
}

ColorCell(cell_to_paint, color:="red")
{
 GuiControl, +c%color%  , %cell_to_paint%
 GuiControl, MoveDraw, % cell_to_paint
}

getcontrol(crtname, what)
{
 guicontrolget, out,  Pos, %crtname%

 if (what="x")
 return % outx

 if (what="y")
 return % outy

 if (what="w")
 return % outW

 if (what="h")
 return % outH

 if (what="yh")
 return % outy + outH 

 if (what="xw")
 return % outx + outW
}

Grid(ctr:="text", clln:="", type:=1, gpx:=10, gpy:=10, cols:=30, rows:=20, cllw:=32, cllh:=32, wsp:=31, hsp:=31, opt:=" BackGroundTrans gclick -disabled border 0x201", fill:="")
{
  global
  r:=0,  c:=0, idx:=0
     While r++ < rows {
        while c++ < cols{
          idx++
                  gui 1: add, % ctr, % opt " w"cllw " h"cllh " v" ((type=1) ? (clln r "_" c " Hwndh" clln  r "_" c) : (type=2) ? (clln c "_" r " Hwndh" clln  c "_" r) : (clln idx " Hwndh" clln  a_index)) ((c=1 && r=1) ? " x"gpx " y"gpy " section"
               : (c!=1 && r=1) ? " xp+"wsp " yp" : (c=1 && r!=1) ? " xs" " yp+"hsp : " xp+"wsp " yp"), % fill
          } c:=0
     } r:=c:=idx:=0
}

;by just me
CheckRGB(Match) {
   Loop, Parse, Match, `,, %A_Space%
      If (A_LoopField > 255) {
         ;MsgBox, 16, %A_ThisFunc%, Invalid RGB value %Match%! ; for testing
         Return 1
      }
}

;by polyethene
rgbToHex(s, d = "") {

	StringSplit, s, s, % d = "" ? "," : d

	SetFormat, Integer, % (f := A_FormatInteger) = "D" ? "H" : f

	h := s1 + 0 . s2 + 0 . s3 + 0

	SetFormat, Integer, %f%

	Return,  RegExReplace(RegExReplace(h, "0x(.)(?=$|0x)", "0$1"), "0x")

}

; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=66463
HexToRGB(Color, Mode="") ; Input: 6 characters HEX-color. Mode can be RGB, Message (R: x, G: y, B: z) or parse (R,G,B)
{
   ; If df, d is *16 and f is *1. Thus, Rx = R*16 while Rn = R*1
   Rx := SubStr(Color, 1,1), Rn := SubStr(Color, 2,1)
   Gx := SubStr(Color, 3,1), Gn := SubStr(Color, 4,1)
   Bx := SubStr(Color, 5,1), Bn := SubStr(Color, 6,1)
   
   AllVars := "Rx|Rn|Gx|Gn|Bx|Bn"
   Loop, Parse, Allvars, | ; Add the Hex values (A - F)
   {
      StringReplace, %A_LoopField%, %A_LoopField%, a, 10
      StringReplace, %A_LoopField%, %A_LoopField%, b, 11
      StringReplace, %A_LoopField%, %A_LoopField%, c, 12
      StringReplace, %A_LoopField%, %A_LoopField%, d, 13
      StringReplace, %A_LoopField%, %A_LoopField%, e, 14
      StringReplace, %A_LoopField%, %A_LoopField%, f, 15
   }
   R := Rx*16+Rn
   G := Gx*16+Gn
   B := Bx*16+Bn
   
   If (Mode = "Message") ; Returns "R: 255 G: 255 B: 255"
      Out := "R:" . R . " G:" . G . " B:" . B
   else if (Mode = "Parse") ; Returns "255,255,255"
      Out := R . "," . G . "," . B
   else
      Out := R . G . B ; Returns 255255255
    return Out
}

return
 
^Esc::
    WinWait, Color Sliders,, 1
    WinClose, Color Sliders ahk_class AutoHotkeyGUI
    SoundBeep, 800
    SoundBeep, 400
exitapp 

guiclose:
~ESC::
    if (!WinActive("Show Me That Color v" version) || WinExist("outline1")) && !ExitOnGuiclose || WinActive("Show Me That Color ahk_class #32770") || WinActive("Color ahk_class #32770")
        Return
    if (ExitOnGuiclose) {
        SoundBeep, 800
        SoundBeep, 400
        ExitApp
    }
    else
        Gui, Hide
    ToggleGui:= 1
Return

F2::
    Gui, Hide
    ClrFls:= ToggleGui:= ""
    if WinExist("outline1")
        gosub PickClr
    else gosub CopyClr
Return

+F2::
    If !(!WinActive("Show Me That Color") && WinExist("Show Me That Color"))
        togglegui:=!togglegui
    if (togglegui)
        Gui, hide
    else
        gui, show
return

f3::
    ClrFls? OldClrFls:=ClrFls: ""
    FileSelectFile, ClrFls, 3,, Open a file, Color Charts (*.txt; *.clr)
    if !ClrFls {
        ClrFls:=OldClrFls
        return
    }
    FileRead, Clip, % ClrFls
    if RegExMatch(Clip, "number_of_columns_(\d+)", $)
       NewCols:=$1
    gosub ShowClr
Return

#LButton::
    Loop, 4 {
        Gui, % A_Index+95 ": -Caption +ToolWindow +AlwaysOnTop -DPIScale"
        Gui, % A_Index+95 ": Color", % Clr? Clr: Clr:="ff8080"
        Gui, % A_Index+95 ": Show", NA h0 w0, outline%A_Index%
    }   

    MouseGetPos, x1, y1
    While GetKeyState("LButton", "P") {
        MouseGetPos, x2, y2
        ;PixelGetColor, Grc, % x2, % y2, RGB
        ;rr:=Grc>>16, gg:=Grc>>8&0xff, bb:=Grc&0xff, cGrc:=sqrt(.241*rr**2+.691*gg**2+.068*bb**2)
        ;FrameColor:= cGrc<130? 0xffffff: 0x000000
        ;loop, 4
            ;Gui, % A_Index+95 ": Color", % FrameColor
        if (x1<=x2 && y1<=y2) {
            nx1:=x1+((x2-x1)>1?1:0), ny1:=y1+((y2-y1)>1?1:0), nx2:=x2-((x2-x1)>1?1:0), ny2:=y2-((y2-y1)>1?1:0)
            Gui, 96:Show, % "NA X" x1+0 " Y" y1-4 " W" x2-x1+4 " H" 4
            Gui, 97:Show, % "NA X" x2+0 " Y" y1-0 " W" 4 " H" y2-y1+4
            Gui, 98:Show, % "NA X" x1-4 " Y" y2-0 " W" x2-x1+4 " H" 4
            Gui, 99:Show, % "NA X" x1-4 " Y" y1-4 " W" 4 " H" y2-y1+4
        } else if (x1>x2 && y1<y2) {
            nx1:=x2+((x1-x2)>1?1:0), ny1:=y1+((y2-y1)>1?1:0), nx2:=x1-((x1-x2)>1?1:0), ny2:=y2-((y2-y1)>1?1:0)
            Gui, 96:Show, % "NA X" x2-4 " Y" y1-4 " W" x1-x2+4 " H" 4
            Gui, 97:Show, % "NA X" x1+0 " Y" y1-4 " W" 4 " H" y2-y1+4
            Gui, 98:Show, % "NA X" x2-0 " Y" y2-0 " W" x1-x2+4 " H" 4
            Gui, 99:Show, % "NA X" x2-4 " Y" y1+0 " W" 4 " H" y2-y1+4
        } else if (x1<x2 && y1>y2) {
            nx1:=x1+((x2-x1)>1?1:0), ny1:=y2+((y1-y2)>1?1:0), nx2:=x2-((x2-x1)>1?1:0), ny2:=y1-((y1-y2)>1?1:0)
            Gui, 96:Show, % "NA X" x1-4 " Y" y2-4 " W" x2-x1+4 " H" 4
            Gui, 97:Show, % "NA X" x2+0 " Y" y2-4 " W" 4 " H" y1-y2+4
            Gui, 98:Show, % "NA X" x1-0 " Y" y1+0 " W" x2-x1+4 " H" 4
            Gui, 99:Show, % "NA X" x1-4 " Y" y2+0 " W" 4 " H" y1-y2+4
        } else if (x1>x2 && y1>y2) {
            nx1:=x2+((x1-x2)>1?1:0), ny1:=y2+((y1-y2)>1?1:0), nx2:=x1-((x1-x2)>1?1:0), ny2:=y1-((y1-y2)>1?1:0)
            Gui, 96:Show, % "NA X" x2-4 " Y" y2-4 " W" x1-x2+4 " H" 4
            Gui, 97:Show, % "NA X" x1+0 " Y" y2-4 " W" 4 " H" y1-y2+4
            Gui, 98:Show, % "NA X" x2-0 " Y" y1+0 " W" x1-x2+4 " H" 4
            Gui, 99:Show, % "NA X" x2-4 " Y" y2-0 " W" 4 " H" y1-y2+4
        }
        Sleep, 25
    }
Return

+F4::
    Loop, 4
        Gui, % A_Index+95 ": Show", NA
Return

#IfWinExist, Enter raster
Esc::WinClose Enter raster

#IfWinExist, outline1
F4::
    if WinExist("outline1") {
        if clr=ff8080
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="80ff80"
        else if clr=80ff80
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="8080ff"
        else if clr=8080ff
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="80ffff"
        else if clr=80ffff
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="ff80ff"
        else if clr=ff80ff
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="ffff80"
        else if clr=ffff80
            loop, 4
                Gui, % A_Index+95 ": Color", % Clr:="ff8080"
    }
Return

F5::
    rx1:= (nx1>A_ScreenWidth-190)? (A_ScreenWidth-190): nx1, ry1:= (ny1>A_ScreenHeight-125)? (A_ScreenHeight-125): ny1
    mr:=(nx2-nx1>ny2-ny1)? (ny2-ny1)//2: (nx2-nx1)//2, mr<1? mr:=1: "", oraster:=raster
    InputBox, raster, Enter raster,,, 170, 105, % rx1, % ry1,,, % raster>mr? mr: raster
    if ErrorLevel
        raster:=oraster
Return

DestroyFrame:
Esc::
    Loop, 4
        Gui, % A_Index+95 ": Hide"
Return

#IfWinExist, Show Me That Color
F6::
    SetTimer, EnterFileName, -50
    FileSelectFile, SaveFls, S16,, Save File As, Color Charts (*.clr; *.txt)
    if SaveFls {
        if FileExist(ClrFls:=SaveFls? SaveFls: ClrFls)
            FileDelete, % SaveFls
            if (Clip ~= "number_of_columns_\d+")
                Clip:= RegExReplace(Clip, "number_of_columns_\d+\r\n", "number_of_columns_" (NewCols? NewCols: cols) "`r`n")
            else Clip:= "number_of_columns_" (NewCols? NewCols: cols) "`r`n" Clip
            FileAppend, % Clip, % SaveFls
    }
Return

PickClr:
    Gosub, DestroyFrame
    Clip:= "", mr:=(nx2-nx1>ny2-ny1)? (ny2-ny1)//2: (nx2-nx1)//2, mr<1? mr:=1: ""
    , ((abs(x1-x2)=1)||(abs(y1-y2)=1))?mr:=0: "", raster:= raster>mr? mr :raster
    loop, % (indH:=(ny2-ny1)//raster)>0? indH: 1 {
        aIndex:= A_Index-1
        loop, % (indW:=(nx2-nx1)//raster)>0? indW: 1 {
            PixelGetColor, clrPix, % nx1+(A_Index-1)*raster, % ny1+aIndex*raster, RGB
            if !InStr(Clip, clrPix)
                Clip.= clrPix "`r`n"
            ;MouseMove, % nx1+(A_Index-1)*raster, % ny1+aIndex*raster
            ;Sleep, 200
            if (A_Index=indW) {
                PixelGetColor, clrPix, % nx2, % ny1+aIndex*raster, RGB
                if !InStr(Clip, clrPix)
                    Clip.= clrPix "`r`n"
                ;MouseMove, % nx2, % ny1+aIndex*raster
            }
        }
        if (A_Index=IndH) {
            loop % indW {
                PixelGetColor, clrPix, % nx1+(A_Index-1)*raster, % ny2, RGB
                if !InStr(Clip, clrPix)
                    Clip.= clrPix "`r`n"
                ;MouseMove, % nx1+(A_Index-1)*raster, % ny2
                ;Sleep, 200
            }
            PixelGetColor, clrPix, % nx2, % ny2, RGB
            if !InStr(Clip, clrPix)
                Clip.= clrPix "`r`n"
            ;MouseMove, % nx2, % ny2
        }
        ;Sleep, 200
    }
    gosub ShowClr
Return

OnMouseMove() {
	global
    Gosub MouseMoveRoutine
    ClrMatch:= StrReplace(ClrUnderM, ",", "\,\s*")
    RegExMatch(Clip, "miU)^(.*" ClrMatch ".*)$", ColorName)
    IsColorname:=regexreplace(ColorName1,"#?[[:xdigit:]]{6}|\b\d{1,3}\s?,\s?\d{1,3}\s?,\s?\d{1,3}\b|\W")
    if (ClrUnderM!="" && !TT && IsColorname) {
            ToolTip, % Trim(ColorName1)
            TT:=1
            MouseGetPos,,, WinUnderM1
            SetTimer TtCheck, 50
        }
    else if (ClrUnderM="" || ClrUnderM!=oClrUnderM) {
            ToolTip
            TT:= ""
            SetTimer, TtCheck, Off
        }
    oClrUnderM:=ClrUnderM
}

TtCheck:
    MouseGetPos,,, WinUnderM2
    if (WinUnderM1!=WinUnderM2) {
        ToolTip
        TT:= "" ; , oClrUnderM:= ""
        SetTimer, TtCheck, Off
    }
Return

EnterFileName:
    SplitPath, ClrFls, ThisClrFls
    WinWaitActive, Save File As ahk_class #32770,, 3
    ControlSetText, Edit1, % ThisClrFls, Save File As ahk_class #32770
    ControlSend, Edit1, {End}^{Left}{Left}, Save File As ahk_class #32770
Return

ColorDlg(C1:=0x0, C2:="", C3:="", hGui:=0) {
    C2!=""? (C:="0x" Format("{:02X}", C1)  Format("{:02X}", C2) Format("{:02X}", C3)): (C:=InStr(C1, "0x")? C1: "0x" C1)
	VarSetCapacity(CC, 64, 0), 	NumPut(VarSetCapacity(RGB, (A_PtrSize*9), 0), RGB, 0)
	NumPut(hGui, RGB, A_PtrSize), NumPut((C&0xFF)<<16|C&0xFF00|(C>>16)&0xFF, RGB, A_PtrSize*3)
	NumPut(&CC, RGB, A_PtrSize*4), 	NumPut(0x103, RGB, A_PtrSize*5)
    if !(!DllCall("Comdlg32.dll\ChooseColor", Str, RGB) || ErrorLevel)
        Return Format("{:06X}", (C:=NumGet(RGB, A_PtrSize*3))&0xFF00|(C&0xFF0000)>>16|(C&0xFF)<<16)
    else Return -1
}

#If WinActive("Color ahk_class #32770")
WheelUp::
WheelDown::
    Critical
    if (A_TimeSincePriorHotkey < 500 && A_ThisHotkey = A_PriorHotkey)
        rNotch<=10? rNotch++: "" ;, (rNotch>10&&rNotch<=20)? rNotch+=3: "", (rNotch>20&&rNotch<=30)? rNotch+=5: ""
    else rNotch:=1
    ControlGetFocus, Cf, Color ahk_class #32770
    if InStr(Cf, "Edit") {
        ControlGetText, Ef, % Cf, Color ahk_class #32770
        Ef:=(A_ThisHotkey="WheelUp")? Ef+rNotch: Ef-rNotch
        ControlSetText % Cf, % ((Ef<0)? 0: (Ef>255)? 255: Ef), Color ahk_class #32770
    }
Return

~Ctrl::
    KeyWait, Ctrl
    if !InStr(ClrReset, ",")
        C:=[], ClrReset:=InStr(ClrReset, "0x")? ClrReset: "0x" ClrReset, C.1:=(ClrReset>>16)&0xff, C.2:=(ClrReset>>8)&0xff, C.3:=ClrReset&0xff
    ControlSetText, Edit3, 120, Color ahk_class #32770
    loop, 3
        ControlSetText, % "Edit" A_Index+3, % C[A_Index], Color ahk_class #32770
Return

#If WinActive("Show Me That Color ahk_class #32770")
WheelUp::
WheelDown::
    Critical
    if (A_TimeSincePriorHotkey < 500 && A_ThisHotkey = A_PriorHotkey)
        rNotch<=10? rNotch++: "" ;, (rNotch>10&&rNotch<=20)? rNotch+=3: "", (rNotch>20&&rNotch<=30)? rNotch+=5: ""
    else rNotch:=1
    ControlGetText, Ef, Edit1, Show Me That Color ahk_class #32770
    Ef:=(A_ThisHotkey="WheelUp")? Ef+rNotch: Ef-rNotch
    ControlSetText, Edit1, % ((Ef<1)? 1: (Ef>22)? 22: Ef), Show Me That Color ahk_class #32770
Return

#If WinActive("Enter raster ahk_class #32770")
WheelUp::
WheelDown::
    Critical
    if (A_TimeSincePriorHotkey < 500 && A_ThisHotkey = A_PriorHotkey)
        rNotch<=10? rNotch++: "" ;, (rNotch>10&&rNotch<=20)? rNotch+=3: "", (rNotch>20&&rNotch<=30)? rNotch+=5: ""
    else rNotch:=1
    ControlGetText, Ef, Edit1, Enter raster ahk_class #32770
    Ef:=(A_ThisHotkey="WheelUp")? Ef+rNotch: Ef-rNotch, mr:=(nx2-nx1>ny2-ny1)? (ny2-ny1)//2: (nx2-nx1)//2, mr<1? mr:=1: ""
    ControlSetText, Edit1, % ((Ef<1)? 1: (Ef>mr)? mr: Ef), Enter raster ahk_class #32770
Return