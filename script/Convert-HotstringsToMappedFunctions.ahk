#Include %A_ScriptDir%\..\lib\LineReader.ahk


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; --- Parameters & Constants --- ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ADD_ALL := 1
INCLUDE_ORIGINAL := 0
SINGLE_INSTANCE_FORCE := 1
PERSISTENT := 1
RETURN_LAST_LINE := 1
ADD_MAIN := 1
ADD_HOTSTRINGS := 1
STRING_CASE_SENSE := 1
OVERWRITE := 0
ENCODING := "UTF-16"

for index, param in A_Args {
    StringUpper, what, param
    
    if      (what = "--ALLCONTENT" or what = "--ALL" or what = "-A")
    
        ADD_ALL := !(ADD_ALL)
        
    else if (what = "--INCLUDEORIGINAL" or what = "--INCLUDE" or what = "-I")
    
        INCLUDE_ORIGINAL := !(INCLUDE_ORIGINAL)
        
    else if (what = "--SINGLEINSTANCE" or what = "--SINGLE" or what = "-S")
    
        SINGLE_INSTANCE_FORCE := !(SINGLE_INSTANCE_FORCE)
        
    else if (what = "--PERSISTENT" or what = "-P")
    
        PERSISTENT := !(PERSISTENT)
        
    else if (what = "--RETURNLASTLINE" or what = "-R")
    
        RETURN_LAST_LINE := !(RETURN_LAST_LINE)
        
    else if (what = "--MAINENTRY" or what = "--MAIN" or what = "-M")
    
        ADD_MAIN := !(ADD_MAIN)
        
    else if (what = "--HOTSTRINGS" or what = "-H")
    
        ADD_HOTSTRINGS := !(ADD_HOTSTRINGS)
        
    else if (what = "--CASESENSE" or what = "-C")
    
        STRING_CASE_SENSE := !(STRING_CASE_SENSE)
        
    else if (what = "--OVERWRITE" or what = "-O")
    
        OVERWRITE := !(OVERWRITE)
        
    else
        if (StrLen(INFILE) > 0)
            OUTFILE := param
        else
            INFILE := param
}

INDENT := "    "
MAP_NAME := "__names"
HELP_NAME := "__help"
SUFFIX := "_Map"
OUTFILE := (StrLen(OUTFILE) = 0) ? GetOutFileName(INFILE, SUFFIX) : OUTFILE
PROGRESS_CONTROL_NAME := "MyProgress"

MAIN_ENTRY_STRING =
(
Call(key) {
    global
    Func(%MAP_NAME%.item(key)).Call()
}

Show(command, key) {
    global
    <STRING_UPPER_COMMAND>
    if (command = "HELP") {
        MsgBox, `% %HELP_NAME%.item(key)
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
)

STRING_UPPER_COMMAND := "StringUpper, command, command"
replace_str := STRING_CASE_SENSE ? "" : STRING_UPPER_COMMAND "`r`n"
MAIN_ENTRY_STRING := StrReplace(MAIN_ENTRY_STRING, "<STRING_UPPER_COMMAND>", replace_str)


;;;;;;;;;;;;;;;;;;;;;;;
; --- Table Class --- ;
;;;;;;;;;;;;;;;;;;;;;;;

class Table {
    static __INVALID_OBJECT_VALUE := "<Null>"
    
    __table := __INVALID_OBJECT_VALUE
    __keys := __INVALID_OBJECT_VALUE
    
    InstanceMethod() {
        if (this.__table = Table.__INVALID_OBJECT_VALUE)
            throw Exception("OBJECT NOT INITIALIZED")
    }
    
    __New() {
        this.__table := {}
        this.__keys := []
        return this
    }
    
    Get(section) {
        this.InstanceMethod()
        return this.__table[section]
    }
    
    Add(section, content) {
        this.InstanceMethod()
        
        if (!this.__table[section]) {
            this.__table[section] := []
            this.__keys.Push(section)
        }
        
        if (IsObject(content)) {
            for index, line in content {
                this.__table[section].Push(line)
            }
        } else {
            this.__table[section].Push(content)
        }
        
        return this
    }
    
    Remove(section) {
        this.InstanceMethod()
        lines := this.__table.Delete(section)
        
        index := 1
        while (index <= this.__keys.MaxIndex() and this.__keys[index] != section) {
            index := index + 1
        }
        
        if (index <= this.__keys.MaxIndex()) {
            this.__keys.RemoveAt(index)
        }
        
        return lines
    }
    
    Keys() {
        this.InstanceMethod()
        return this.__keys
    }
    
    MaxIndex() {
        this.InstanceMethod()
        return this.__keys.MaxIndex()
    }
    
    Any() {
        this.InstanceMethod()
        return this.__keys.MaxIndex() > 0
    }
}


;;;;;;;;;;;;;;;;;;;;;
; --- Functions --- ;
;;;;;;;;;;;;;;;;;;;;;

GetShortName(filename) {
    return RegExReplace(filename, ".*\\")
}

GetOutFileName(filename, suffix) {
    filename := GetShortName(filename)
    filename := RegExReplace(filename, "\.ahk$", suffix . ".ahk")
    filename := RegExReplace(filename, "^Hk-")
    return A_ScriptDir . "\" . filename
}

HelpSequence(line, ByRef out) {
    position := RegExMatch(line, "O)^\s*;\s*(?<TYPE>\w+):", match)
    out := match.Value("TYPE")
    return position > 0
}

HotstringSequence(line, ByRef out) {
    position := RegExMatch(line, "O)^:[^:]*:;(?<NAME>[^:]+);:[^:]*:", match)
    out := match.Value("NAME")
    return position > 0
}

ReturnSequence(line) {
    return line ~= "^\s*return(\W|$)"
}

ListToString(list, delim := ", ") {
    str := ""
    index := 1
    
    while (index < list.MaxIndex()) {
        str .= list[index] . delim
        index := index + 1
    }
    
    if (list.MaxIndex() > 0) {
        str .= list[index]
    }
    
    return str
}

Any(list) {
    return list.MaxIndex() > 0
}

GetIndex(number) {
    return SubStr("0000" . number, -3)
}

GetFunctionName(number) {
    return "function_" . GetIndex(number)
}

GetDefinition(commands, name) {
    global
    str := name . "() {`r`n"
    str .= INDENT . "global`r`n"
    str .= ListToString(commands, "`r`n")
    str .= "`r`n}"
    return str
}

GetAddToMapCommand(map_name, hotstring, function_name) {
    return map_name . ".item(""" . hotstring . """) := """ . "" . function_name . """"
}

GetTestString(map_name, hotstring_name) {
    return "Func(" . map_name . "[""" . hotstring_name . """]).Call()"
}

GetIncludeString(filename) {
    return "#Include %A_ScriptDir%\" . GetShortName(filename)
}

GetMainEntryString() {
    global
    str := MAIN_ENTRY_STRING
    str := StrReplace(str, "__MAP_NAME__", MAP_NAME)
    str := StrReplace(str, "__HELP_NAME__", HELP_NAME)
    return str
}

IsCommentLine(line) {
    return line ~= "^\s*`;"
}

IsCommentBarLine(line) {
    return line ~= "^\s*`;`;+\s*$"
}

IsHeader(line) {
    return line ~= "^\s*\#"
}

IsUnnecessaryDirective(line) {
    return line ~= "^\s*(\#SingleInstance|\#Persistent)"
}

SubtractWhiteSpace(lines, ByRef start, ByRef end) {
    start := 1
    while (start <= lines.MaxIndex() and IsWhiteSpace(lines[start])) {
        start := start + 1
    }
    
    end := lines.MaxIndex()
    while (end >= 1 and IsWhiteSpace(lines[end])) {
        end := end - 1
    }
}

GetSectionHeading(ByRef it, ByRef str, ByRef lines) {
    lines := []
    lines.Push(it.Current())
    
    it.Next(line)
    lines.Push(it.Current())
    position := RegExMatch(it.Current(), "O)--- (?<NAME>.+) ---", match)
    
    if (position > 0) {
        str := match.Value("NAME")
        StringUpper, str, str
        it.Next(line)
        lines.Push(it.Current())
    }
    
    return position
}

GetDocString(it) {
    str := ""
    line := it.Current()
    
    while (it.Any() and IsCommentLine(line)) {
        line := RegExReplace(line, "^\s*`;\s*|\s*$", "")
        line := RegExReplace(line, """", """""")
        str := (str = "") ? line : str " " line
        it.Next(line)
    }
    
    return str
}

GetRangeHeight(names, sections, defs, lines) {
    size := 0
    size += 2 * names.MaxIndex()
    
    for index, key in sections.Keys() {
        size += sections.Get(key).MaxIndex()
    }
    
    size += def.MaxIndex()
    size += lines.MaxIndex()
    return size
}

StartProgress(height) {
    Gui, Add, Progress, Horizontal W500 H20 Range0-%height% v%PROGRESS_CONTROL_NAME%
    Gui, Show
}

IncrProgress(step) {
    GuiControl,, %PROGRESS_CONTROL_NAME%, +%step%
}

EndProgress() {
    Progress, Off
    Gui, Destroy
}


;;;;;;;;;;;;;;;;;;;;;;
; --- Main Entry --- ;
;;;;;;;;;;;;;;;;;;;;;;

Main(infile, outfile) {
    global
    has_header := 0
    out := FileOpen(outfile, (OVERWRITE ? "w" : "a"), ENCODING)
    
    if (INCLUDE_ORIGINAL) {
        has_header := 1
        out.WriteLine(GetIncludeString(infile))
    }
    
    if (SINGLE_INSTANCE_FORCE) {
        has_header := 1
        out.WriteLine("#SingleInstance Force")
    }
    
    if (PERSISTENT) {
        has_header := 1
        out.WriteLine("#Persistent")
    }
    
    it := New LineReader(infile)
    
    while (it.NextNonWhiteSpace(line) and IsHeader(line)) {
        if (!IsUnnecessaryDirective(line)) {
            has_header := 1
            out.WriteLine(line)
        }
    }
    
    if (has_header) {
        out.WriteLine("`r`n")
    }
    
    map := ComObjCreate("Scripting.Dictionary")
    help := ComObjCreate("Scripting.Dictionary")
    hotstrings_per_def := []
    hotstring_lines := []
    hotstring_names := []
    commands := []
    definitions := []
    other := []
    number := 0
    help_str := ""
    
    sections := New Table
    
    while (it.Any()) {
        if (IsCommentBarLine(line) and GetSectionHeading(it, section_heading, lines) > 0) {
        
            for index, line in lines {
                sections.Add(section_heading, line)
            }
            
            it.Next(line)
            
        } else if (HelpSequence(line, result)) {
        
            help_str := GetDocString(it)
            line := it.Current()
            
        } else if (HotstringSequence(line, result)) {
        
            hotstrings_per_def.Push(result)
            hotstring_names.Push(result)
            hotstring_lines.Push(line)
            help.item(result) := help_str
            it.Next(line)
            
        } else if (Any(hotstrings_per_def)) {
        
            if (ReturnSequence(line)) {
                if (RETURN_LAST_LINE) {
                    last := line . " " . RegExReplace(commands[commands.MaxIndex()], "^\s+")
                    commands[commands.MaxIndex()] := last
                } else {
                    commands.Push(line)
                }
                
                function_name := GetFunctionName(number)
                function_def := GetDefinition(commands, function_name)
                
                for index, hotstring in hotstrings_per_def {
                    map.item(hotstring) := function_name
                }
                
                definitions.Push(function_def)
                hotstrings_per_def := []
                commands := []
                number := number + 1
            } else {
                commands.Push(line)
            }
            
            it.Next(line)
            
        } else if (ADD_ALL) {
        
            sections.Add(section_heading, line)
            it.Next(line)
        }
    }
    
    step := 1
    size := GetRangeHeight(hotstring_names, sections, definitions, hotstring_lines)
    StartProgress(size)
    
    out.WriteLine("`; **********************")
    out.WriteLine("`; * --- DICTIONARY --- *")
    out.WriteLine("`; **********************`r`n")
    
    ; I actually don't necessarily want this line, since I plan on compiling many files together.
    ; 
    ;    2019-10-25: I disagree.
    
    out.WriteLine("if (!" MAP_NAME ") {`r`n`t" MAP_NAME " := ComObjCreate(""Scripting.Dictionary"")`r`n}")
    out.WriteLine("if (!" HELP_NAME ") {`r`n`t" HELP_NAME " := ComObjCreate(""Scripting.Dictionary"")`r`n}")
    
    for index, hotstring in hotstring_names {
        out.WriteLine(GetAddToMapCommand(MAP_NAME, hotstring, map.item(hotstring)))
        
        IncrProgress(step)
    }
    
    for index, hotstring in hotstring_names {
        out.WriteLine(GetAddToMapCommand(HELP_NAME, hotstring, help.item(hotstring)))
        
        IncrProgress(step)
    }
    
    if (ADD_ALL) {
        out.WriteLine("`r`n")
        
        for index, line in sections.Get("GLOBAL VARIABLES") {
            out.WriteLine(line)
            
            IncrProgress(step)
        }
        
        sections.Remove("GLOBAL VARIABLES")
    }
    
    if (ADD_MAIN) {
        out.WriteLine("`r`n")
        out.WriteLine("; **********************")
        out.WriteLine("; * --- MAIN ENTRY --- *")
        out.WriteLine("; **********************`r`n")
        out.WriteLine(MAIN_ENTRY_STRING)
    }
    
    if (ADD_ALL and sections.Any()) {
        out.WriteLine("`r`n")
        out.WriteLine("; *******************")
        out.WriteLine("; * --- CONTENT --- *")
        out.WriteLine("; *******************`r`n")
        
        for index, key in sections.Keys() {
            for subindex, line in sections.Get(key) {
                out.WriteLine(line)
                
                IncrProgress(step)
            }
        }
    }
    
    out.WriteLine("`r`n")
    out.WriteLine("; ***********************")
    out.WriteLine("; * --- DEFINITIONS --- *")
    out.WriteLine("; ***********************")
    
    for index, definition in definitions {
        out.WriteLine("")
        out.WriteLine(definition)
        
        IncrProgress(step)
    }
    
    if (ADD_HOTSTRINGS) {
        out.WriteLine("`r`n")
        out.WriteLine("; **********************")
        out.WriteLine("; * --- HOTSTRINGS --- *")
        out.WriteLine("; **********************`r`n")
        
        for index, line in hotstring_lines {
            out.WriteLine(line)
            
            IncrProgress(step)
        }
        
        MAIN_CALL_STRING := INDENT "Call(Trim(Monitor.GetHotkeyName(A_ThisHotkey), ""`;""))`r`n"
        MAIN_CALL_STRING .= INDENT "return"
        out.WriteLine(MAIN_CALL_STRING)
    }
    
    out.Close()
    EndProgress()
}

Main(INFILE, OUTFILE)
ExitApp
