class Sorts {
	static NUMERIC := true
	static CASE_SENSITIVE := false
	static CASE_INSENSITIVE_LOCAL := false
	static UNIQUE := false
	static REVERSE := false
	static RANDOM := false
	static COMPARATOR :=
	static DELIMITER := " "
	
	static options := ""
	
	BuildOptions() {
		Sorts.options := Sorts.GetOptions(""
			, Sorts.NUMERIC
			, Sorts.CASE_SENSITIVE
			, Sorts.CASE_INSENSITIVE_LOCAL
			, Sorts.UNIQUE
			, Sorts.REVERSE
			, Sorts.RANDOM
			, Sorts.COMPARATOR
			, Sorts.DELIMITER)
	}
	
	GetOptions(dummy, numeric, case_sensitive, case_insensitive_local, unique, reverse, random, comparator, delimiter) {
		options := ""
		
		options .= numeric ? "N " : " "
		options .= case_sensitive ? "C " : " "
		options .= case_insensitive_local ? "CL " : " "
		options .= unique ? "U " : " "
		options .= reverse ? "R " : " "
		options .= random ? "Random " : " "
		options .= comparator ? "F " comparator : " "
		options .= delimiter ? "D" delimiter : ""
		
		return options
	}
	
	GetSortedString(str, options) {
		__string_to_be_sorted := str
		Sort, __string_to_be_sorted, % options
		return __string_to_be_sorted
	}
	
	Sort(str) {
		if StrLen(Sorts.options) = 0 {
			Sorts.BuildOptions()
		}
		
		return Sorts.GetSortedString(str, Sorts.options)
	}
	
	SortReverse(str) {
		options := Sorts.GetOptions(""
			, Sorts.NUMERIC
			, Sorts.CASE_SENSITIVE
			, Sorts.CASE_INSENSITIVE_LOCAL
			, Sorts.UNIQUE
			, !Sorts.REVERSE
			, Sorts.RANDOM
			, Sorts.COMPARATOR
			, Sorts.DELIMITER)
			
		return Sorts.GetSortedString(str, options)
	}
}


;;;;;;;;;;;;;;;;
; --- TEST --- ;
;;;;;;;;;;;;;;;;

str := "12, 32, 3, 3, -1, 13"
str := "12 32 3 3 -1 13"

MsgBox, % "[" Sorts.Sort(str) "]"

Clipboard := str

