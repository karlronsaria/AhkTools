#Include %A_ScriptDir%\lib\LineReader.ahk

IsSectionHeading(line, ByRef heading) {
	what := RegExMatch(line, "O)^\s*;\s*\[\s*(?<HEADING>\w+)\s*\]", match) > 0
	heading := match.Value("HEADING")
	return what
}

IsAssignment(line, ByRef key, ByRef value) {
	what := RegExMatch(line, "O)^\s*(;\s*)?(?<KEY>\w+)\s*=\s*(?<VALUE>(\S.*)?)$", match) > 0
	key := match.Value("KEY")
	value := match.Value("VALUE")
	return what
}

line := ""
out := ""

; [Heading]
; what = the
; the =
; [EndHeading]

lines := new LineReader(A_ScriptFullPath)

while (lines.Next(line) and !IsSectionHeading(line, heading)) {
	; Do nothing, lol.
}

if (heading)
	out .= "Section: [" heading "]`r`n"
	
while (lines.Next(line) and !IsSectionHeading(line, heading)) {
	if (IsAssignment(line, key, value)) {
		out .= "'" key "' : '" value "'`r`n"
		
		%key% = %value%
		
		MsgBox, % "[" %key% "]"
	}
}

MsgBox, % "What: [" what "]"

ExitApp


prev := Clipboard
Clipboard := out

Run, notepad

Sleep, 200
Send, ^v
Sleep, 200
Clipboard := prev

ExitApp

