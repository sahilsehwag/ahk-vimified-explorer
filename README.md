## INTRODUCTION

Finally the virus of _**VIM**_ has reached _**WINDOWS**_ 😈. _**VimifiedExplorer**_ is an _**AHK script**_ which provides _**VIM/Vifm**_ like bindings for _**Windows FileExplorer**_, and other features like _bookmarks, marks etc..._
<br/>
**Note:** _**Executable**_ file is provided along with AHK script.


## OVERVIEW

- [Features](#features)
- [Installation](#installation)
- [Screenshots](#screenshots)
- [Documentation](#documentation)
- [Limitations](#limitations)
- [Known Issues](#known-issues)
- [Contribution](#contribution)
- [Todo](#todo)


## FEATURES

- _**VIM/VIFM like bindings**_
- _**Marks**_
- _**Bookmarks**_
- _**Integration with QTTabBar**_
- _**Colon Commands (currently only one)**_
- _**Displays current mode**_
- _**Currently works on Windows 10 and probably Windows 8(most features should work) too (Only tested on Windows 10)**_
- _**Persistent Marks and Bookmarks (creates .verc in HOME directory to store your marks and bookmarks)**_


## INSTALLATION

- Download _VimifiedExplorer.exe_. 
- Install AHK and run the _VimifiedExplorer.ahk_ script.


## SCREENSHOTS



## DOCUMENTATION
### MODES

| Mode | KeyBinding | Description |
|------|------------|-------------|
| NORMAL | `<Escape>` | Default mode where you will be spending most of your time |
| INSERT | `i` | Mode in which all VimifiedExplorer bindings are disabled |
| VISUAL | `v` | Like VIM's VISUAL-LINE mode, Files/Folders will be selected as you move UP and Down|
| VISUAL-SELECT | `V` | Moving around won't select any File/Folder to select a File/Folder press `<Space>` or `s`.


### NAVIGATION

__Note:__<br/>
>General syntax for motion is `<COUNT><MOTION>`.<br/>
>Almost all motions accept COUNT as argument (except MOTIONS like gg etc..)<br/>
>In table below `n` refers to the count passed to command.<br/>
>Default value for count is 1<br/>

| KeyBinding | Description 								| Takes COUNT 	|
|------------|------------------------------------------|---------------|
| `j`  		 | To move `n` DOWN 						| yes 			|
| `k`  		 | To move `n` UP 							| yes 			|
| `h`  		 | To go `n` Directories back 				| yes 			|
| `l`  		 | To open selected File(s)/Directory(s)  	| no  			|
| `J`  		 | To go `n` locations back in history 		| yes 			|
| `K`  		 | To go `n` locations forward in history 	| yes 			|
| `gg` 		 | To go to FIRST file 			 			| no  			|
| `G`  		 | To go to LAST file 						| no  			|
| `H`  		 | To go to TOP of the visible screen 		| yes 			|
| `L`  		 | To go to BOTTOM of the visible screen 	| yes 			|


### FILE/FOLDER OPERATIONS

**Note:** COUNT `n` to file operations selects Current item + `n-1` items down

| KeyBinding | Description | Takes COUNT |
|------------|-------------|-------------|
| `dd` | Delete currently selected items | yes |
| `DD` | Delete currently selected items permanently | yes |
| `cc` | Rename currently selected item | no |
| `yy` | Yank(Copy) currently selected items | yes |
| `yp` | Yank(Copy) path of current folder | no |
| `yt` | Yank(Copy) selected items to a folder(select using _CopyTo_ menu) | no |
| `xx` | Cut currently selected items | yes |
| `xx` | Cut currently selected items to a folder(select using _MoveTo_ menu) | yes |
| `p`  | Paste files/folders | no |
| `P`  | Paste shortcut of files/folders | no |
| `fn`  | Create new folder | no |
| `fh`  | Hide/Unhide selected items | no |


### MARKS

| Keybinding | Description |
|------------|-------------|
| `m<CHARACTER>` | Creates a mark of current directory |
| `'<CHARACTER>` | Opens mark <CHARACTER>(i.e goes to the location binded with \<CHARACTER\>) |


### BOOKMARKS

**Note:** A bar is opened to enter Bookmark `NAME`

| Keybinding | Description |
|------------|-------------|
| `b NAME` | Creates a bookmark of current directory |
| `" NAME` | Opens a bookmark (i.e goes to the location binded with NAME) |


### UI OPERATIONS

| Keybinding | Description |
|------------|-------------|
| `uh` | Show/Hide hidden items |
| `ue` | Show/Hide file extensions |
| `uc` | Show/Hide checkboxes |
| `uf` | Change column widths to fit its contents |
| `up` | Show/Hide Preview Pane |
| `ud` | Show/Hide Details Pane |
| `un` | Show/Hide Navigation Pane |
| `ul` | Select the location bar |


### MISCELLANOUS OPERATIONS

| Keybinding | Description |
|------------|-------------|
| `/` | Incremental search (selects item as you type) |
| `zc` | Compress selected items |
| `zu` | UnCompress selected zip file(_**NOT IMPLEMENTED**_) |
| `zp` | Pin selected item to QuickAccess |
| `zq` | Close current explorer window |

##### SELECT OPERATIONS
| Keybinding | Description |
|------------|-------------|
| s | Select/Deselect current item | 
| sa | Select all items | 
| sn | Deselect all currently selected elements | 
| si | Inverse selection (Deselects currently selected items and selects remaining items | 

##### OPEN OPERATIONS
| Keybinding | Description |
|------------|-------------|
| `ot` | Opens *__Command Prompt__* in current folder |
| `on` | Opens selected folders in *__New Window__* (If selected item is a file opens current folder) |
| `op` | Opens *__Properties__* dialog of selected items |
| `os` | Opens *__Settings__* dialog of selected items |
| `or` | Opens *__Recent Locations__* menu(In TOP-LEFT corner, use j,k to move DOWN/UP in the list)(_**Experimental**_) |
| `ow` | Opens *__Open With__* menu |
| `oq` | Opens explorer's *__QuickAccess__* menu(Press highlighted number to select) |

##### WINDOW OPERATIONS
| Keybinding | Description |
|------------|-------------|
| `wh` | Pin window to left |
| `wj` | Minimize/Pin to bottom |
| `wk` | Maximize/Pin to top |
| `wl` | Pin window to right |
| `wm` | Move current window around(_`h,j,k,l`_ to move _left,down,up,right_ and `esc,enter` to cancel,confirm) |
| `wr` | Resize current window(_`h,j,k,l`_ to increase/decrease in _left,down,up,right_ direction and `esc,enter` to cancel,confirm) |

##### TAB OPERATIONS (QTTabBar)
| Keybinding | Description |
|------------|-------------|
| `tn` | Create new tab |
| `tl` | Goto next tab |
| `th` | Goto previous tab |
| `tt` | Toggle tab lock |
| `tq` | Close current tab |


### COMMANDS

| Command | Description |
|---------|-------------|
| `:run<ENTER\|TAB><CMD Command>` |	Runs command-line commands in current explorer directory |


## LIMITATIONS

- Currently only works in _List View_ (i.e. Only UP/DOWN motions are supported)


## KNOWN ISSUES

- Mode tooltip doesn't automatically disappears when switching to other applications. (Use `<Escape>` to remove it)
- When using `J,K` to navigate history, system(keyboard) language is automatically cycled left,right (for people with more than 1 language installed)
- When resizing a window in *__left/top__* direction causes wierd shaking.


## CONTRIBUTION

Contributors are welcomed.


## TODO

- Fix known issues
- Implement motions for views other than _DETAIL VIEW_
- Implementing History Features (Ex. Jumping to last location)
- Implement operations to perform operations like delete on `n` items up etc...
- Implement *__HELP DOCUMENTATION__* in application itself
- Complete rewrite to provide a more composable architecture, to provide features like _**Custom Commands, Extensibility, Custom Mappings, Customizability etc..**_)






