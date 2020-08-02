#Requires AutoHotkey v2.0-

; #IncludeAgain *i %A_ScriptDir%\..\lib\Monitor.ahk
; #IncludeAgain *i %A_ScriptDir%\..\lib\Counter.ahk
#Persistent
#SingleInstance Force

;;;;;;;;;;;;;;;;;;;;;
; --- Functions --- ;
;;;;;;;;;;;;;;;;;;;;;

StringToSortedListString(str, comparator, type := "MERGE", default_delim := "", width := 0, tracking := 0) {
	return Sorts.StringToSortedListString(str, comparator, type, default_delim, width, tracking)
}

;;;;;;;;;;;;;;;;;;;;;;
; --- Hotstrings --- ;
;;;;;;;;;;;;;;;;;;;;;;

; Without Tracking
;;;;;;;;;;;;;;;;;;

; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;ascm;::
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "MERGE")
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;descm;::
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "MERGE")
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;ascql;::
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "LQUICK")
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;descql;::
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "LQUICK")
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;ascqh;::
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "HQUICK")
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;descqh;::
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "HQUICK")
    return
    
; With Tracking
;;;;;;;;;;;;;;;

; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track ascm;::
	SHOW_ARROWS := 0
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "MERGE", "", Sorts.ALIGN_LEN, 1)
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track descm;::
	SHOW_ARROWS := 0
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "MERGE", "", Sorts.ALIGN_LEN, 1)
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track ascql;::
	SHOW_ARROWS := 0
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "LQUICK", "", Sorts.ALIGN_LEN, 1)
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track descql;::
	SHOW_ARROWS := 0
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "LQUICK", "", Sorts.ALIGN_LEN, 1)
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track ascqh;::
	SHOW_ARROWS := 0
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "HQUICK", "", Sorts.ALIGN_LEN, 1)
    return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;track descqh;::
	SHOW_ARROWS := 0
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "HQUICK", "", Sorts.ALIGN_LEN, 1)
    return
    
; With Tracking & Arrows
;;;;;;;;;;;;;;;;;;;;;;;;

; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow ascm;::
	SHOW_ARROWS := 1
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "MERGE", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow descm;::
	SHOW_ARROWS := 1
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "MERGE", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow ascql;::
	SHOW_ARROWS := 1
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "LQUICK", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow descql;::
	SHOW_ARROWS := 1
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "LQUICK", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow ascqh;::
	SHOW_ARROWS := 1
	Monitor.Clip("StringToSortedListString", Clipboard, "CompareAscending", "HQUICK", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
; Hotstring: Replace clipboard with a descending sorted list of the items on the clipboard
:*?:;arrow descqh;::
	SHOW_ARROWS := 1
    Monitor.Clip("StringToSortedListString", Clipboard, "CompareDescending", "HQUICK", "", Sorts.ALIGN_LEN, 1)
    SHOW_ARROWS := 0
	return
    
	
; ;;;;;;;;;;;;;;;;
; ; --- Test --- ;
; ;;;;;;;;;;;;;;;;
; 
; list := GetList("_1234 ... _21_ - 20 - asdf 14 , 91", list, delim)
; list := SortAscending(list)
; 
; MsgBox, % "[" ListToString(list, delim) "]"
; 
; GetList("1234 ... 21 - 20 - 19 0 3 14 , 91  5 51", list, delim)
; SortAscending(list)
; 
; MsgBox, % "[" ListToString(list, delim) "]"

