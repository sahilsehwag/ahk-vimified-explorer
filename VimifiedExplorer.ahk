#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance FORCE

vimEnabled := true

NORMAL_MODE := "normal"
INSERT_MODE := "insert"
VISUAL_MODE := "visual"
VISUAL_LINE_MODE := "visual-line"
PSUEDO_VISUAL_MODE := "psuedo-visual"
PSUEDO_VISUAL_LINE_MODE := "psuedo-visual-line"

miscMode := false
windowMode := false
bookmarkMode := false
commandBarFlag := false

mode := "normal"
commandCount := 0
setMode(NORMAL_MODE)

wTransientState := false
fTransientState := false
dTransientState := false
cTransientState := false
yTransientState := false

lastMode := "normal"

lastNormalCommandCount := 0
lastNormalCommand := ""

lastVisualCommand := ""
lastVisualCommandCount := 0

lastVisualLineCommand := ""
lastVisualLineCommandCount := 0

operatorDelete := false
operatorPermanentDelete := false
operatorChange := false
operatorYank := false
operatorCut := false
ggCommand := false


iniPath = C:/Users/%A_UserName%/.verc

CommandBar :=
commandBarCommand :=


;F2::reload
;F3::suspend


#USEHOOK on
#InstallKeybdHook


;CTRL + ` TO TOGGLE ACTIVATION OF VIM MODE
#`::
	vimEnabled := !vimEnabled
	if vimEnabled {
		setMode(NORMAL_MODE) 	
	} else{
		ToolTip, 
	}
RETURN


;TO REMOVE TOOLTIP PERSISTANT AFTER EXPLORER IS NOT ACTIVE (ISSUE)
#IF (vimEnabled=false) || !(WinActive("AHK_CLASS CabinetWClass"))
	escape::
		SEND, {ESCAPE}
		resetToolTip()
		GUI, CommandBar:Destroy
	return


;COMMAND BAR
#IFWINACTIVE CommandBar
	tab::
	enter::
		GUI, CommandBar:Submit
		setMode(NORMAL_MODE)
	return



;MAIN VIM BINDINGS
#IF (vimEnabled=true) && WinActive("AHK_CLASS CabinetWClass")
	escape::
		SEND, {ESCAPE}
		setMode(NORMAL_MODE)
		commandCount := 0

		wTransientState := false
		fTransientState := false
		dTransientState := false
		cTransientState := false
		yTransientState := false

		operatorDelete := false
		operatorChange := false
		operatorYank := false
		operatorCut := false

		ggCommand := false
		windowMode := false

		ControlFocus, DirectUIHWND3
		ToolTip, ,,, 2
	Return
	
	enter::
		SEND, {ENTER}
		windowMode := false
		operatorChange := false
		setMode(NORMAL_MODE)
	return


#IF (vimEnabled=true) && WinActive("AHK_CLASS CabinetWClass") && (mode!=INSERT_MODE) && (miscMode=false) && (windowMode=false) && (bookmarkMode=false)
	+;::
		createCommandBar(":")
		WinWaitClose, CommandBar
		execCommandModeCommand()
	return

	;MODES
	i::
		setMode(INSERT_MODE)
	Return
	v::
		if (mode=VISUAL_LINE_MODE){
			setMode(PSUEDO_VISUAL_MODE)
		}else{
			setMode(VISUAL_MODE)
		}
	Return
	+v::
		if (mode=VISUAL_MODE){
			setMode(PSUEDO_VISUAL_LINE_MODE)	
		}else{
			setMode(VISUAL_LINE_MODE)
		}
	Return


	;COMMAND COUNT
	0::
		commandCount := joinNumbers(commandCount, 0)
	RETURN
	1::
		commandCount := joinNumbers(commandCount, 1)
	RETURN
	2::
		commandCount := joinNumbers(commandCount, 2)
	RETURN
	3::
		commandCount := joinNumbers(commandCount, 3)
	RETURN
	4::
		commandCount := joinNumbers(commandCount, 4)
	RETURN
	5::
		commandCount := joinNumbers(commandCount, 5)
	RETURN
	6::
		commandCount := joinNumbers(commandCount, 6)
	RETURN
	7::
		commandCount := joinNumbers(commandCount, 7)
	RETURN
	8::
		commandCount := joinNumbers(commandCount, 8)
	RETURN
	9::
		commandCount := joinNumbers(commandCount, 9)
	RETURN


	;BASIC NAVIGATION
	h::
		runVimMotion("h")
	RETURN
	l::
		runVimMotion("l")
	RETURN
	j::
		runVimMotion("j")
	RETURN
	k::
		runVimMotion("k")
	RETURN
	+j::
		runVimMotion("+j")
	return
	+k::
		runVimMotion("+k")
	return


	;SCROLL NAVIGATION
	+g::
		runVimMotion("+g")
	RETURN		
	g::
		if (ggCommand=false){
			ggCommand := true
		} else{
			runVimMotion("gg")
			ggCommand := false
		}
	RETURN	
	+h::
		runVimMotion("+h")
	RETURN
	+l::
		runVimMotion("+l")
	RETURN


	;OPERATORS
	d::
		if (operatorDelete=false){
			operatorDelete := true	
		} else {
			runVimOperator("dd")
			operatorDelete := false
		}
	return
	+d::
		if (operatorPermanentDelete=false){
			operatorPermanentDelete := true	
		} else {
			runVimOperator("DD")
			operatorPermanentDelete := false
		}
	return
	c::
		if (operatorChange=false){
			operatorChange := true	
		} else {
			runVimOperator("cc")
			setMode(INSERT_MODE)
		}
	return
	y::
		if (operatorYank=false){
			operatorYank := true	
		} else {
			runVimOperator("yy")
			operatorYank := false
		}
	return
	x::
		if (operatorCut=false){
			operatorCut := true	
		} else {
			runVimOperator("xx")
			operatorCut := false
		}
	return
	p::
		if (operatorYank=true){
			SEND, {ALT DOWN}HCP{ALT UP}
		}else{
			SEND, {CTRL DOWN}v{CTRL UP}
		}
	return
	+p::
		SEND, {ALT DOWN}{H}{P}{S}{ALT UP}
	RETURN

	;a::
		;if (operatorDelete=true){
			;runVimOperator("da")	
		;} else if(operatorYank=true){
			;runVimOperator("ya")
		;} else if (operatorCut=true){
			;runVimOperator("xa")
		;}
	;return
	;b::
		;if (operatorDelete=true){
			;runVimOperator("db")	
		;} else if (operatorYank=true){
			;runVimOperator("yb")
		;} else if (operatorCut=true){
			;runVimOperator("xb")
		;}
	;return
	;+a::
		;if (operatorDelete=true){
			;runVimOperator("dA")	
		;} else if (operatorYank=true){
			;runVimOperator("yA")
		;} else if (operatorCut=true){
			;runVimOperator("xA")
		;}
	;return
	;+b::
		;if (operatorDelete=true){
			;runVimOperator("dB")	
		;} else if(operatorYank=true){
			;runVimOperator("yB")
		;} else if (operatorCut=true){
			;runVimOperator("xB")
		;}
	;return
	t::
		if (operatorCut=true){
			runVimOperator("xt")
		}else if (operatorYank=true){
			runVimOperator("yt")
		}
		operatorCut := false
		operatorYank := false
	return

	
	;MISCELLANOUS OPERATIONS
	s::
		SEND, {CTRL DOWN}{SPACE}{CTRL UP}
	return
	s & a::
		SEND, {ALT DOWN}HSA{ALT UP}
	RETURN
	s & n::
		SEND, {ALT DOWN}HSN{ALT UP}
	RETURN
	s & i::
		SEND, {ALT DOWN}HSI{ALT UP}
	RETURN
	/::
		setMode(INSERT_MODE)
	return



	
#IF (vimEnabled=true) && WinActive("AHK_CLASS CabinetWClass") && (mode!=INSERT_MODE) && (bookmarkMode=false)
	;UI OPERATIONS
	u::
		miscMode := true
		;HotKey, f, OFF
		Input, command, L1 T1

		if (command="c"){
			SEND, {ALT DOWN}VHT{ALT UP}
		}else if(command="e"){
			SEND, {ALT DOWN}VHF{ALT UP}
		}else if(command="h"){
			SEND, {ALT}VHH
		}else if(command="f"){
			SEND, {ALT DOWN}VSF{ALT UP}
		}else if(command="p"){
			SEND, {ALT DOWN}VP{ALT UP}
		}else if(command="d"){
			SEND, {ALT DOWN}VD{ALT UP}
		}else if(command="n"){
			SEND, {ALT DOWN}VN{ALT UP}{ENTER}
		}else if (command="l"){
			SEND, {A DOWN}l{CTRL UP}
		}

		;HotKey, f, ON
		miscMode := false
	return
		

	;FILE OPERATIONS
	f::
		miscMode := true
		Input, command, L1, T1
		if (command="n"){
			SEND, {CTRL DOWN}{SHIFT DOWN}n{SHIFT UP}{CTRL UP}
			setMode(INSERT_MODE)
		}else if (command="h"){
			SEND, {ALT DOWN}{V}{H}{S}{ALT UP}
		}
		miscMode := false
	return


	;WINDOW OPERATIONS
	w::
		miscMode := true

		;HotKey, f, OFF
			
		Input, command, L1 T1

		if (command="."){
		}else if (command="h"){
			SEND, {LWIN DOWN}{LEFT}{LWIN UP}
		}else if (command="j"){
			SEND, {LWIN DOWN}{DOWN}{LWIN UP}
		}else if (command="k"){
			SEND, {LWIN DOWN}{UP}{LWIN UP}
		}else if (command="l"){
			SEND, {LWIN DOWN}{RIGHT}{LWIN UP}
		}else if (command="m"){
			SEND, {ALT DOWN}{SPACE}{ALT UP}M
			windowMode := true
			;WINGET, isMaximized, MinMax,
		}else if (command="f"){
			SEND, {SHIFT DOWN}{F11}{SHIFT UP}
		}else if (command="r"){
			SEND, {ALT DOWN}{SPACE}{ALT UP}S
			windowMode := true
		}

		;HotKey, f, ON
		miscMode := false
		wTransientState := false
	return


	;OPEN OPERATIONS
	o::
		miscMode := true
		;HotKey, w, OFF

		Input, command, L1 T1

		if (command="n"){
			SEND, {ALT DOWN}FN{ALT UP}
		}else if (command="t"){
			currentPath := getExplorerPath()
			Run, "cmd.exe", %currentPath%
		}else if (command="p"){
			SEND, {ALT DOWN}{ENTER}{ALT UP}
		}else if (command="s"){
			SEND, {ALT DOWN}VYO{ALT UP}
		}else if (command="q"){
			SEND, {ALT DOWN}F{ALT UP}
		}else if (command="w"){
			SEND, {ALT DOWN}HPEC{ALT UP}
		}else if (command="r"){
			CoordMode, Mouse, Window
			MouseClick, left, 77, 74
		}

		miscMode := false
		;HotKey, w, ON
	return

	z::
		miscMode := true
		;HotKey, z, OFF
		Input, command, L1 T1
		if (command="z"){
			SEND, {CTRL DOWN}w{CTRL UP}
		}else if (command="c"){
			SEND, {ALT DOWN}SC{ALT UP}
		}else if (command="p"){
			SEND, {ALT DOWN}HPI{ALT UP}
		}
		;HotKey, z, ON
		miscMode := false
	return

	;GOTO COMMANDS



#IF (vimEnabled=true) && WinActive("AHK_CLASS CabinetWClass") && (mode!=INSERT_MODE) && (windowMode=true) && (bookmarkMode=false)
	h::
		Loop, 10{
			Sleep, 5
			SEND, {LEFT}
		}
	return
	j::
		Loop, 10{
			Sleep, 5
			SEND, {DOWN}
		}
	return
	k::
		Loop, 10{
			Sleep, 5
			SEND, {UP}
		}
	return
	l::
		Loop, 10{
			Sleep, 5
			SEND, {RIGHT}
		}
	return
	
	+h::
		Loop, 10{
			Sleep, 1
			SEND, {LEFT}
		}
	return
	+j::
		Loop, 20{
			Sleep, 1
			SEND, {DOWN}
		}
	return
	+k::
		Loop, 20{
			Sleep, 1
			SEND, {UP}
		}
	return
	+l::
		Loop, 20{
			Sleep, 1
			SEND, {RIGHT}
		}
	return



;MARKS AND BOOKARMS
#IF (vimEnabled=true) && WinActive("AHK_CLASS CabinetWClass") && (mode!=INSERT_MODE)  && (miscMode=false)
	;MARKS/BOOKMARKS
	m::
		bookmarkMode := true
		HotKey, m, OFF
		HotKey, b, OFF
		global iniPath

		checkIniFile()

		currentPath := getExplorerPath()
		currentPath := urlDecoder(currentPath)
		Input, command, L1 T1
		if (command!=""){
			IniWrite, %currentPath%, %iniPath%, Marks, %command%

			status = MARK [%command% = %currentPath%] CREATED
			setStatus(status)
		}

		HotKey, m, ON
		HotKey, b, ON
		bookmarkMode := false
	return

	'::
		bookmarkMode := true
		HotKey, m, OFF
		HotKey, b, OFF
		global iniPath

		checkIniFile()
	
		Input, command, L1 T1
		IniRead, path, %iniPath%, Marks, %command%
		SEND, {ALT DOWN}d{ALT UP}
		SENDRAW, %path%
		SEND, {ENTER}

		HotKey, m, ON
		HotKey, b, ON
		bookmarkMode := false
	return

	b::
		bookmarkMode := true
		HotKey, m, OFF
		HotKey, b, OFF
		global iniPath

		checkIniFile()

		createCommandBar("New Bookmark >")
		WinWaitClose, CommandBar
		command := commandBarCommand
		commandBarCommand := ""
		currentPath := getExplorerPath()
		currentPath := urlDecoder(currentPath)

		if (command=""){
		}else{
			IniWrite, %currentPath%, %iniPath%, Bookmarks, %command%

			status = BOOKMARK [%command% = %currentPath%] CREATED
			setStatus(status)
		}

		HotKey, m, ON
		HotKey, b, ON
		bookmarkMode := false
	return

	+'::
		bookmarkMode := true
		HotKey, m, OFF
		HotKey, b, OFF

		global iniPath
		checkIniFile()
	
		createCommandBar("Open Bookmark >")
		WinWaitClose, CommandBar
		bookmark := commandBarCommand
		commandBarCommand := ""

		if (bookmark=""){
		}else{
			IniRead, path, %iniPath%, Bookmarks, %bookmark%
			SEND, {ALT DOWN}d{ALT UP}
			SENDRAW, %path%
			SEND, {ENTER}
		}

		HotKey, m, ON
		HotKey, b, ON
		bookmarkMode := false
	return

			


setStatus(status){
	WinGetActiveStats, title, width, height, x, y
	y := height - 4
	x := 130

	ToolTip, %status%, x, y, 2
	;SetTimer, RemoveStatus, 3000
}

removeToolTip(whichToolTip){
	;:RemoveStatus
	;SetTimer, RemoveStatus, OFF
	ToolTip, , , , 2
	;return
}

execCommandModeCommand(){
	global commandBarCommand
	if (commandBarCommand="run"){
		createCommandBar("run >")
		WinWaitClose, CommandBar

		cwd := getExplorerPath()
		runCommand := commandBarCommand
		RUN, %runCommand%, %cwd%
	}
	commandBarCommand := ""
}

showMode() {
	global mode
	global NORMAL_MODE
	global INSERT_MODE
	global VISUAL_MODE
	global VISUAL_LINE_MODE
	global PSUEDO_VISUAL_MODE
	global PSUEDO_VISUAL_LINE_MODE

	WinGetActiveStats, title, width, height, x, y
	height := height - 4
	width := 8

	if (mode=NORMAL_MODE) {
		ToolTip, NORMAL MODE, %width%, %height%, 1
	} else if (mode=INSERT_MODE){
		ToolTip, INSERT MODE, %width%, %height%, 1
	} else if (mode=VISUAL_MODE){
		ToolTip, VISUAL MODE, %width%, %height%, 1
	} else if (mode=VISUAL_LINE_MODE){
		ToolTip, VISUAL-LINE MODE, %width%, %height%, 1
	} else if (mode=PSUEDO_VISUAL_MODE){
		ToolTip, VISUAL MODE, %width%, %height%, 1
	} else if (mode=PSUEDO_VISUAL_LINE_MODE){
		ToolTip, VISUAL-LINE MODE, %width%, %height%, 1
	}
}

joinNumbers(first, second){
	RETURN first * 10 + second	
}

setMode(newMode){
	global mode
	global NORMAL_MODE
	global INSERT_MODE
	global VISUAL_MODE
	global VISUAL_LINE_MODE
	global PSUEDO_VISUAL_MODE
	global PSUEDO_VISUAL_LINE_MODE

	if (mode=NORMAL_MODE) || (newMode=NORMAL_MODE) || (newMode=PSUEDO_VISUAL_MODE) || (newMode=PSUEDO_VISUAL_LINE_MODE){
		mode := newMode
	}else if (mode=PSUEDO_VISUAL_MODE) && (newMode=VISUAL_LINE_MODE){
		mode := newMode
	}
	showMode()
}

setTransientState(state){
	global transientState
	transientState := %state%
	showTransientState()
}

showTransientState(){
	global transientState
}

enterVimTransientState(tState){
	global mode

	if (mode=NORMAL_MODE){
		if (tState="d")	{
			dTransientState := true
		} else if (tState="c") {
			cTransientState := true
		} else if (tState="y") {
			yTransientState := true
		} else if (tState="w") {
			wTransientState := true
		}
	}
}

runVimMotion(motion){
	global mode

	global NORMAL_MODE
	global INSERT_MODE
	global VISUAL_MODE
	global VISUAL_LINE_MODE
	global PSUEDO_VISUAL_MODE
	global PSUEDO_VISUAL_LINE_MODE

	global commandCount
	if (commandCount=0){
		commandCount := 1
	}

	;BASIC NAVIGATION
	if (motion="h"){
		if (mode!=INSERT_MODE) {
			SEND, {ALT DOWN}{UP %commandCount%}{ALT UP}
		}
	} else if (motion="j"){
		if (mode=NORMAL_MODE) {
			SEND, {DOWN %commandCount%}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{DOWN %commandCount%}{CTRL UP}
		} else if(mode=PSUEDO_VISUAL_MODE) {
			Loop, %commandCount%{
				SEND, {SPACE}{CTRL DOWN}{DOWN}{CTRL UP}
			}
		} else if(mode=PSUEDO_VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{DOWN %commandCount%}{CTRL UP}
		}
	} else if (motion="k"){
		if (mode=NORMAL_MODE) {
			SEND, {UP %commandCount%}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{UP %commandCount%}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{UP %commandCount%}{CTRL UP}
		} else if(mode=PSUEDO_VISUAL_MODE) {
			Loop, %commandCount%{
				SEND, {SPACE}{CTRL DOWN}{UP}{CTRL UP}
			}
		} else if(mode=PSUEDO_VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{UP %commandCount%}{CTRL UP}
		}
	} else if (motion="l"){
		if (mode!=INSERT_MODE) {
			SEND, {ENTER}
		}
	}else if (motion="+j"){
		SEND, {ALT DOWN}{LEFT %commandCount%}{ALT UP}
	}else if (motion="+k"){
		SEND, {ALT DOWN}{RIGHT %commandCount%}{ALT UP}
	}

	;SCROLL NAVIGATION
	else if (motion="gg"){
		if (mode=NORMAL_MODE) {
			SEND, {HOME}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{HOME}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{HOME}{CTRL UP}
		}
	}
	else if (motion="+g"){
		if (mode=NORMAL_MODE) {
			SEND, {END}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{END}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{END}{CTRL UP}
		}
	} else if (motion="+h"){
		if (mode=NORMAL_MODE) {
			SEND, {PGUP}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{PGUP %commandCount%}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{PGUP %commandCount%}{CTRL UP}
		}
	} else if (motion="+l"){
		if (mode=NORMAL_MODE) {
			SEND, {PGDN %commandCount%}
		} else if(mode=VISUAL_MODE) {
			SEND, {SHIFT DOWN}{PGDN %commandCount%}{SHIFT UP}
		} else if(mode=VISUAL_LINE_MODE) {
			SEND, {CTRL DOWN}{PGDN %commandCount%}{CTRL UP}
		}
	} else if (motion="+m"){
		if (mode=NORMAL_MODE) {
		} else if(mode=VISUAL_MODE) {
		} else if(mode=VISUAL_LINE_MODE) {
		}
	}

	commandCount := 0
}

runVimOperator(command){
	global mode
	global commandCount

	global operatorDelete
	global operatorPermanentDelete
	global operatorChange
	global operatorYank
	global operatorCut
	global ggCommand

	global NORMAL_MODE
	global INSERT_MODE
	global VISUAL_MODE
	global VISUAL_LINE_MODE
	global PSUEDO_VISUAL_MODE
	global PSUEDO_VISUAL_LINE_MODE

	commandCount := commandCount - 1
	
	;VIM OPERATORS
	if (command="dd"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{DELETE}
	} else if (command="da"){
	} else if (command="db"){
	} else if (command="dA"){
	} else if (command="dB"){
	}

	else if (command="DD"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{SHIFT DOWN}{DELETE}{SHIFT UP}
	} else if (command="Da"){
	} else if (command="Db"){
	} else if (command="DA"){
	} else if (command="DB"){
	}

	else if (command="cc"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{F2}
	}else if (command="c."){
	}

	else if (command="yy"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{CTRL DOWN}c{CTRL UP}
	} else if (command="ya"){
	} else if (command="yb"){
	} else if (command="yA"){
	} else if (command="yB"){
	} else if (command="yp"){
		SEND, {ALT DOWN}HCP{ALT UP}
	} else if (command="yt"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{ALT DOWN}HCF{ALT UP}
	}


	else if (command="xx"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{CTRL DOWN}x{CTRL UP}
	} else if (command="xa"){
	} else if (command="xb"){
	} else if (command="xA"){
	} else if (command="xB"){
	} else if (command="xt"){
		SEND, {SHIFT DOWN}{DOWN %commandCount%}{SHIFT UP}{ALT DOWN}HM{ALT UP}
	}

	commandCount := 0
}


createCommandBar(prompt=""){
	global CommandBar
	global commandBarCommand

	customColor := 333333
	GUI CommandBar: NEW
	GUI CommandBar: FONT, s14 cFFFFFF
	GUI CommandBar: COLOR, %customColor%, %customColor%
	GUI CommandBar: MARGIN, 12, 12

	WINSET, TRANSCOLOR, %customColor% 20, CommandBar
	GUI CommandBar: +LASTFOUND -CAPTION +ALWAYSONTOP

	;GUI CommandBar: ADD, TEXT, y13 c9966FF, %prompt%
	GUI CommandBar: ADD, TEXT, y13, %prompt%
	GUI CommandBar: ADD, EDIT, y12 h70  w600 cE6E6E6 r1 -E0x200 vcommandBarCommand
	GUI CommandBar: SHOW, xCENTER	y100, CommandBar
}


checkIniFile(){
	global iniPath
	if !(FileExist(iniPath)){
		FileOpen(initPath, w)
	}
}


GetFileCount(Directory){
	fso := ComObjCreate("Scripting.FileSystemObject")
	try
		objFiles := fso.GetFolder(Directory).Files
	catch
		return -1
	return objFiles.count
}

getExplorerPath(handler=""){
	IF (handler = "" )
  		handler := WINEXIST("A")
	WINGET process, ProcessName, ahk_id %handler%
	IF (process = "explorer.exe"){
		WINGETCLASS windowClass, ahk_id %handler%
		IF (windowClass ~= "Progman|WorkerW")
			windowPath := A_Desktop
		ELSE IF (windowClass ~= "(Cabinet|Explore)WClass"){
		 	FOR window IN ComObjCreate("Shell.Application").Windows
		    IF (window.HWnd == handler){
		       	URL := window.LocationURL
		       	BREAK
		    }
			STRINGTRIMLEFT, windowPath, URL, 8 ; remove "file:///"
			STRINGREPLACE windowPath, windowPath, /, \, All
		}
	}
	path := urlDecoder(windowPath)
	RETURN path
}

urlDecoder(string) {
	Loop
		if RegExMatch(string, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, string, string, `%%hex%, % Chr("0x" . hex), All
		else break
	return, string
}


resetOperators(){
}
resetTransientState(){
}
ressetMode(){
}
resetEverything(){
}

resetToolTip(){
	ToolTip, ,,, 1
	ToolTip, ,,, 2
}

