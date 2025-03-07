#IncludeAgain *i %A_ScriptDir%\..\lib\Monitor.ahk
#IncludeAgain *i %A_ScriptDir%\..\lib\Command.ahk
#IncludeAgain *i %A_ScriptDir%\..\lib\Date.ahk
#IncludeAgain *i %A_ScriptDir%\..\lib\String.ahk
; #IncludeAgain *i %A_ScriptDir%\..\lib\Subroutine.ahk
; #SingleInstance Force
; #Persistent

; **********************
; * --- DICTIONARY --- *
; **********************

if (!__names) {
	__names := ComObjCreate("Scripting.Dictionary")
}
if (!__help) {
	__help := ComObjCreate("Scripting.Dictionary")
}
__names.item("stop") := () => return Monitor.Disable()
__names.item("start") := () => return Monitor.Enable()
__names.item("kill") := () => {
	global
	master_proc := Monitor.MasterProcessName()  
    processes := ["AutoHotkey.exe", master_proc]
    msg := Commands.GetKillAllMessage(processes)
    return Monitor.OverrideMethod(Commands, "KillAllProcesses", processes, master_proc, msg)
}
__names.item("panic") := () => {
    global
    return Monitor.OverrideMethod(Commands, "KillAllProcesses", BROWSER_PROCESS_NAMES)
}
__names.item("help") := () => {
    global
    return Monitor.OverrideMethod(Commands, "DisplayHelpMessage")
}
__names.item("ppane") := () => {
    global
	if (Monitor.Available())
		SendNotification("Deprecated - 2020-07-02", "Use Alt + P")
		
    return Monitor.OverrideMethod(Commands, "TogglePaneInExplorer", "p")
}
__names.item("preview") := () => {
    global
	if (Monitor.Available())
		SendNotification("Deprecated - 2020-07-02", "Use Alt + P")
		
    return Monitor.OverrideMethod(Commands, "TogglePaneInExplorer", "p")
}
__names.item("dpane") := () => {
    global
	if (Monitor.Available())
		SendNotification("Deprecated - 2020-07-02", "Use Alt + Shft + P")
		
    return Monitor.OverrideMethod(Commands, "TogglePaneInExplorer", "d")
}
__names.item("details") := () => {
    global
	if (Monitor.Available())
		SendNotification("Deprecated - 2020-07-02", "Use Alt + Shft + P")
		
    return Monitor.OverrideMethod(Commands, "TogglePaneInExplorer", "d")
}
__names.item("calendar") := () => return Monitor.LockAndGo("ShowCalendar")
__names.item("swap") := () => return Monitor.LockAndGo("ShowSwapBox")
__names.item("formats") := () => return Monitor.LockAndGo("ShowTitleFormatListView")
__names.item("listhk") := () => return Monitor.Override("ListHotkeys", !A_ThisHotkey)
__names.item("listvar") := () => return Monitor.Override("ListVariables", !A_ThisHotkey)
__names.item("listline") := () => return Monitor.Override("ListLines", !A_ThisHotkey)
__names.item("listkey") := () => return Monitor.Override("ListKeyHistory", !A_ThisHotkey)
__names.item("t") := () => return Monitor.RunMethod(Strings, "ToTitleCase", Clipboard)
__names.item("titlecase") := () => return Monitor.RunMethod(Strings, "ToTitleCase", Clipboard)
__names.item("randomcase") := () => "function_0015"
__names.item("tounix") := () => "function_0016"
__names.item("todos") := () => "function_0017"
__names.item("tojson") := () => "function_0018"
__names.item("tab2space") := () => "function_0019"
__names.item("unders") := () => "function_0020"
__names.item("block") := () => "function_0021"
__names.item("block_tab4") := () => "function_0022"
__names.item("block_tab8") := () => "function_0023"
__names.item("condense") := () => "function_0024"
__names.item("condense_tab4") := () => "function_0025"
__names.item("condense_tab8") := () => "function_0026"
__names.item("last") := () => "function_0027"
__names.item("top") := () => "function_0028"
__names.item("rem") := () => "function_0029"
__names.item("date") := () => return Monitor.RunMethod(Dates, "GetStdDate")
__names.item("prettydate") := () => return Monitor.RunMethod(Dates, "GetPrettyDate")
__names.item("time") := () => "function_0032"
__names.item("datetime") := () => "function_0033"
__names.item("title") := () => "function_0034"
__names.item("d_title") := () => "function_0035"
__names.item("dt_title") := () => "function_0036"
__names.item("d_-_title") := () => "function_0037"
__names.item("dt_-_title") := () => "function_0038"
__names.item("last_Sun") := () => "function_0039"
__names.item("lSun") := () => "function_0039"
__names.item("last_Mon") := () => "function_0040"
__names.item("lMon") := () => "function_0040"
__names.item("last_Tue") := () => "function_0041"
__names.item("lTue") := () => "function_0041"
__names.item("last_Wed") := () => "function_0042"
__names.item("lWed") := () => "function_0042"
__names.item("last_Thu") := () => "function_0043"
__names.item("lThu") := () => "function_0043"
__names.item("last_Fri") := () => "function_0044"
__names.item("lFri") := () => "function_0044"
__names.item("last_Sat") := () => "function_0045"
__names.item("lSat") := () => "function_0045"
__names.item("next_Sun") := () => "function_0046"
__names.item("nSun") := () => "function_0046"
__names.item("next_Mon") := () => "function_0047"
__names.item("nMon") := () => "function_0047"
__names.item("next_Tue") := () => "function_0048"
__names.item("nTue") := () => "function_0048"
__names.item("next_Wed") := () => "function_0049"
__names.item("nWed") := () => "function_0049"
__names.item("next_Thu") := () => "function_0050"
__names.item("nThu") := () => "function_0050"
__names.item("next_Fri") := () => "function_0051"
__names.item("nFri") := () => "function_0051"
__names.item("next_Sat") := () => "function_0052"
__names.item("nSat") := () => "function_0052"
__help.item("stop") := "Hostring: Temporarily disable this script"
__help.item("start") := "Hostring: Re-enable this script"
__help.item("kill") := "Hostring: Terminate AutoHotkey and the expected compiled version of this script"
__help.item("panic") := "Hostring: Kill all Web browser applications"
__help.item("help") := "Hostring: Display Help Message"
__help.item("ppane") := "Hostring: Toggle Preview Pane in Windows Explorer"
__help.item("preview") := "Hostring: Toggle Preview Pane in Windows Explorer"
__help.item("dpane") := "Hostring: Toggle Details Pane in Windows Explorer"
__help.item("details") := "Hostring: Toggle Details Pane in Windows Explorer"
__help.item("calendar") := "Hostring: Open a date-select calendar, allowing the user to choose a date to replace this hotstring with"
__help.item("swap") := "Hotstring: Open an input box to perform a string swap on the clipboard"
__help.item("formats") := "Hotstring: Open a list of title formats, allowing the user to choose one to replace this hotstring with"
__help.item("listhk") := "Hotstring: List all hotkeys"
__help.item("listvar") := "Hotstring: List all variables"
__help.item("listline") := "Hotstring: List all most-recently executed lines"
__help.item("listkey") := "Hotstring: List most recent key strokes"
__help.item("t") := "Hotstring: Replace with the title-case version of the clipboard string"
__help.item("titlecase") := "Hotstring: Replace with the title-case version of the clipboard string"
__help.item("randomcase") := "Hotstring: Replace with the random-case version of the clipboard string"
__help.item("tounix") := "Hotstring: Replace backslashes with slashes"
__help.item("todos") := "Hotstring: Replace slashes with backslashes"
__help.item("tojson") := "Hotstring: Replace backslashes with double-backslashes"
__help.item("tab2space") := "Hotstring: Replace all tabs with spaces on the clipboard"
__help.item("unders") := "Hotstring: Replace all tabs with underscores on the clipboard"
__help.item("block") := "Hotstring: Add word-wrapped line breaks to text on the clipboard; (default tab size is 4)"
__help.item("block_tab4") := "Hotstring: Add word-wrapped line breaks to text on the clipboard; (make sure the tab size is 4)"
__help.item("block_tab8") := "Hotstring: Add word-wrapped line breaks to text on the clipboard; (make sure the tab size is 8)"
__help.item("condense") := "Hotstring: Combine consecutive lines of content to a single line on the clipboard; (default tab size is 4)"
__help.item("condense_tab4") := "Hotstring: Combine consecutive lines of content to a single line on the clipboard; (make sure the tab size is 4)"
__help.item("condense_tab8") := "Hotstring: Combine consecutive lines of content to a single line on the clipboard; (make sure the tab size is 8)"
__help.item("last") := "Hotstring: Copy to clipboard the latest datetime string occurring in the currently active explorer window"
__help.item("top") := "Hotstring: Replace with the device ID of the last local fixed disk drive"
__help.item("rem") := "Hotstring: Replace with the device ID of the first removable disk drive"
__help.item("date") := "Hotstring: Replace with current date in standard ""yyyy-MM-dd"" format" ; Uses DateTimeFormat
__help.item("prettydate") := "Hotstring: Replace with current date in pretty ""d MMMM yyyy"" format"
__help.item("time") := "Hotstring: Replace with current time"
__help.item("datetime") := "Hotstring: Replace with current date and time"
__help.item("title") := "Hotstring: Replace with a title-corrected string from the Clipboard"
__help.item("d_title") := "Hotstring: Replace with current date and title string"
__help.item("dt_title") := "Hotstring: Replace with current date and time and title string"
__help.item("d_-_title") := "Hotstring: Replace with current date and title string"
__help.item("dt_-_title") := "Hotstring: Replace with current date and time and title string"
__help.item("last_Sun") := "Hostring: Replace with last Sunday's date"
__help.item("lSun") := "Hostring: Replace with last Sunday's date"
__help.item("last_Mon") := "Hostring: Replace with last Monday's date"
__help.item("lMon") := "Hostring: Replace with last Monday's date"
__help.item("last_Tue") := "Hostring: Replace with last Tuesday's date"
__help.item("lTue") := "Hostring: Replace with last Tuesday's date"
__help.item("last_Wed") := "Hostring: Replace with last Wednesday's date"
__help.item("lWed") := "Hostring: Replace with last Wednesday's date"
__help.item("last_Thu") := "Hostring: Replace with last Thursday's date"
__help.item("lThu") := "Hostring: Replace with last Thursday's date"
__help.item("last_Fri") := "Hostring: Replace with last Friday's date"
__help.item("lFri") := "Hostring: Replace with last Friday's date"
__help.item("last_Sat") := "Hostring: Replace with last Saturday's date"
__help.item("lSat") := "Hostring: Replace with last Saturday's date"
__help.item("next_Sun") := "Hostring: Replace with next Sunday's date"
__help.item("nSun") := "Hostring: Replace with next Sunday's date"
__help.item("next_Mon") := "Hostring: Replace with next Monday's date"
__help.item("nMon") := "Hostring: Replace with next Monday's date"
__help.item("next_Tue") := "Hostring: Replace with next Tuesday's date"
__help.item("nTue") := "Hostring: Replace with next Tuesday's date"
__help.item("next_Wed") := "Hostring: Replace with next Wednesday's date"
__help.item("nWed") := "Hostring: Replace with next Wednesday's date"
__help.item("next_Thu") := "Hostring: Replace with next Thursday's date"
__help.item("nThu") := "Hostring: Replace with next Thursday's date"
__help.item("next_Fri") := "Hostring: Replace with next Friday's date"
__help.item("nFri") := "Hostring: Replace with next Friday's date"
__help.item("next_Sat") := "Hostring: Replace with next Saturday's date"
__help.item("nSat") := "Hostring: Replace with next Saturday's date"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Global Variables --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DATE_FORMAT := "yyyy-MM-dd" ; Uses DateTimeFormat
PRETTY_DATE_FORMAT := "d MMMM yyyy"
SECND_SEPARATOR := "_-_"  ; "_"
TEXT_SPACE := "   "
TAB_SIZE := 4
NOTE_WIDTH := 85

; As of 2020-03-28
BROWSER_PROCESS_NAMES := [
    , "chrome.exe"
    , "firefox.exe"
    , "MicrosoftEdge.exe"
    , "iexplore.exe"
    , "brave.exe"]
    


; **********************
; * --- MAIN ENTRY --- *
; **********************

Call(key) {
    global
	__names.item(key)()
}

Show(command, key) {
    global
    
    if (command = "HELP") {
        MsgBox, % __help.item(key)
    }
}

Main() {
    params := []

    for index, param in A_Args {
        if (StrLen(param) > 0) {
            params.Push(param)
        }
    }

    if (params.MaxIndex() = 1) {
        Call(params[1])
        Monitor.Exit()
    } else if (params.MaxIndex() > 1) {
        Show(params[1], params[2])
        Monitor.Exit()
    }
}

Main()


; *******************
; * --- CONTENT --- *
; *******************


;;;;;;;;;;;;;;;;;;;
; --- Hotkeys --- ;
;;;;;;;;;;;;;;;;;;;


#IfWinActive ahk_class CabinetWClass ; Windows Explorer
    #Space::
        ControlFocus, DirectUIHWND3, A
        SendInput, {Space}
        return
#IfWinActive

; ; DISABLED: 2020-06-24
; 
; ; Hotkey: Oh this? Just a little, *experiment*.
; >!RCtrl::AppsKey
; >^RAlt::AppsKey

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Command Strings --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    
    
    
    
#IfWinActive ahk_class CabinetWClass
    
#IfWinActive

    
    
    
    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- String Replacers --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Send keystrokes from clipboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    
    
    
; Alter content on the clipboard
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    
    
    
    
    
    
#IfWinActive ahk_class CabinetWClass ; Windows Explorer
#IfWinActive

; Replace hotstring
;;;;;;;;;;;;;;;;;;;
    
    
    
    
    
    
    
    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Replace With Last Weekday's Date --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    
    
    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Replace With Next Weekday's Date --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    
    
    
    
    
    


; ***********************
; * --- DEFINITIONS --- *
; ***********************

function_0014() {
    global
    return Monitor.RunMethod(Strings, "ToTitleCase", Clipboard)
}

function_0015() {
    global
    return Monitor.RunMethod(Strings, "ToRandomCase", Clipboard)
}

function_0016() {
    global
    return Monitor.RunMethod(Strings, "ToUnixString", Clipboard)
}

function_0017() {
    global
    return Monitor.RunMethod(Strings, "ToDosString", Clipboard)
}

function_0018() {
    global
    return Monitor.RunMethod(Strings, "ToJsonString", Clipboard)
}

function_0019() {
    global
    return Monitor.ClipMethod(Strings, "ReplaceTabsShowingProgress", Clipboard, A_Space)
}

function_0020() {
    global
    return Monitor.ClipMethod(Strings, "ReplaceTabsAndSpacesShowingProgress", Clipboard, "_")
}

function_0021() {
    global
    return Monitor.RunMethod(Strings, "PasteBlockText", Clipboard, TAB_SIZE, NOTE_WIDTH)
}

function_0022() {
    global
    return Monitor.RunMethod(Strings, "PasteBlockText", Clipboard, 4, NOTE_WIDTH)
}

function_0023() {
    global
    return Monitor.RunMethod(Strings, "PasteBlockText", Clipboard, 8, NOTE_WIDTH)
}

function_0024() {
    global
    return Monitor.RunMethod(Strings, "PasteCondensedBlockText", Clipboard, TAB_SIZE, NOTE_WIDTH)
}

function_0025() {
    global
    return Monitor.RunMethod(Strings, "PasteCondensedBlockText", Clipboard, 4, NOTE_WIDTH)
}

function_0026() {
    global
    return Monitor.RunMethod(Strings, "PasteCondensedBlockText", Clipboard, 8, NOTE_WIDTH)
}

function_0027() {
    global
    previous := Monitor.SetNotifyClipboardEvents(1)
    Monitor.Lock()
    Monitor.ClipMethod(Commands, "GetLatestDatedItemNameInExplorerWindow")
    Monitor.Spin()
    return Monitor.SetNotifyClipboardEvents(previous)
}

function_0028() {
    global
    return Monitor.RunMethod(Commands, "GetLogicalDiskId", 3, 0)
}

function_0029() {
    global
    return Monitor.RunMethod(Commands, "GetLogicalDiskId", 2, 1)
}

function_0030() {
    global
    return Monitor.RunMethod(Dates, "GetStdDate")
}

function_0032() {
    global
    return Monitor.RunMethod(Dates, "GetTime")
}

function_0033() {
    global
    return Monitor.RunMethod(Dates, "GetDateAndTime")
}

function_0034() {
    global
    ; Run("ToUpperCamelCase", Clipboard)
    return Monitor.RunMethod(Strings, "GetSubtitle", Clipboard, SECND_SEPARATOR)
}

function_0035() {
    global
    return Monitor.RunMethod(Strings, "GetTitle", Dates.GetStdDate(), Clipboard, "_", SECND_SEPARATOR)
}

function_0036() {
    global
    return Monitor.RunMethod(Strings, "GetTitle", Dates.GetDateAndTime(), Clipboard, "_", SECND_SEPARATOR)
}

function_0037() {
    global
    return Monitor.RunMethod(Strings, "GetTitle", Dates.GetStdDate(), Clipboard, "_-_", SECND_SEPARATOR)
}

function_0038() {
    global
    return Monitor.RunMethod(Strings, "GetTitle", Dates.GetDateAndTime(), Clipboard, "_-_", SECND_SEPARATOR)
}

function_0039() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 1)
}

function_0040() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 2)
}

function_0041() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 3)
}

function_0042() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 4)
}

function_0043() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 5)
}

function_0044() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 6)
}

function_0045() {
    global
    return Monitor.RunMethod(Dates, "GetLastDate", 7)
}

function_0046() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 1)
}

function_0047() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 2)
}

function_0048() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 3)
}

function_0049() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 4)
}

function_0050() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 5)
}

function_0051() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 6)
}

function_0052() {
    global
    return Monitor.RunMethod(Dates, "GetNextDate", 7)
}


; **********************
; * --- HOTSTRINGS --- *
; **********************

:?:;stop;::
:?:;start;::
:?:;kill;::
:?:;panic;::
:?:;help;::
:*b0?:;ppane;::
:*b0?:;preview;::
:*b0?:;dpane;::
:*b0?:;details;::
:?:;calendar;::
:?:;swap;::
:?:;formats;::
:?:;listhk;::
:?:;listvar;::
:?:;listline;::
:?:;listkey;::
:*?:;t;::
:*?:;titlecase;::
:*?:;randomcase;::
:*?:;tounix;::
:*?:;todos;::
:*?:;tojson;::
:*?:;tab2space;::
:*?:;unders;::
:*?:;block;::
:*?:;block_tab4;::
:*?:;block_tab8;::
:*?:;condense;::
:*?:;condense_tab4;::
:*?:;condense_tab8;::
:*b0?:;last;::
:*?:;top;::
:*?:;rem;::
:*?:;date;::
:*?:;prettydate;::
:*?:;time;::
:*?:;datetime;::
:*?:;title;::
:*?:;d_title;::
:*?:;dt_title;::
:*?:;d_-_title;::
:*?:;dt_-_title;::
:*?:;last_Sun;::
:*?:;lSun;::
:*?:;last_Mon;::
:*?:;lMon;::
:*?:;last_Tue;::
:*?:;lTue;::
:*?:;last_Wed;::
:*?:;lWed;::
:*?:;last_Thu;::
:*?:;lThu;::
:*?:;last_Fri;::
:*?:;lFri;::
:*?:;last_Sat;::
:*?:;lSat;::
:*?:;next_Sun;::
:*?:;nSun;::
:*?:;next_Mon;::
:*?:;nMon;::
:*?:;next_Tue;::
:*?:;nTue;::
:*?:;next_Wed;::
:*?:;nWed;::
:*?:;next_Thu;::
:*?:;nThu;::
:*?:;next_Fri;::
:*?:;nFri;::
:*?:;next_Sat;::
:*?:;nSat;::
    Call(Trim(Monitor.GetHotkeyName(A_ThisHotkey), ";"))
    return
