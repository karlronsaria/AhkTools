#NoEnv
SetWorkingDir, %A_ScriptDir%
RE_Dll := DllCall("LoadLibrary", "Str", "Msftedit.dll", "Ptr")

Gui, +hwndhGui
Gui, Margin, 10, 10
Gui, Font, s10, Arial
Gui, Add, Custom, ClassRICHEDIT50W w400 h400 vRE hwndHRE +VScroll +0x0804 ; ES_MULTILINE | ES_READONLY
Gui, Show, , RichEdit

TomDoc := GetTomDoc(hRE)
TomFile := "Test-Gui_RichEdit_MyRTF.rtf"
TomDoc.Open(TomFile, 0x01, 0)
Return

GuiClose:
ExitApp

GetTomDoc(HRE) {
   ; Get the document object of the specified RichEdit control
   Static IID_ITextDocument := "{8CC497C0-A1DF-11CE-8098-00AA0047BE5D}"
   DocObj := 0
   If DllCall("SendMessage", "Ptr", HRE, "UInt", 0x043C, "Ptr", 0, "PtrP", IRichEditOle, "UInt") { ; EM_GETOLEINTERFACE
      DocObj := ComObject(9, ComObjQuery(IRichEditOle, IID_ITextDocument), 1) ; ITextDocument
      ObjRelease(IRichEditOle)
   }
   Return DocObj
}
