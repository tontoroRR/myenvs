Basic editing functions
=======================

Key              Function            Description
---              --------            -----------
Enter            AcceptLine          Accept the input or move to the next line if input is missing a closing token.
Shift+Enter      AddLine             Move the cursor to the next line without attempting to execute the input
Backspace        BackwardDeleteChar  Delete the character before the cursor
Ctrl+h           BackwardDeleteChar  Delete the character before the cursor
Ctrl+Home        BackwardDeleteInput Delete text from the cursor to the start of the input
Ctrl+Backspace   BackwardKillWord    Move the text from the start of the current or previous word to the cursor to the k
                                     ill ring
Ctrl+w           BackwardKillWord    Move the text from the start of the current or previous word to the cursor to the k
                                     ill ring
Ctrl+C           Copy                Copy selected region to the system clipboard.  If no region is selected, copy the w
                                     hole line
Ctrl+c           CopyOrCancelLine    Either copy selected text to the clipboard, or if no text is selected, cancel editi
                                     ng the line with CancelLine.
Ctrl+x           Cut                 Delete selected region placing deleted text in the system clipboard
Delete           DeleteChar          Delete the character under the cursor
Ctrl+End         ForwardDeleteInput  Delete text from the cursor to the end of the input
Ctrl+Enter       InsertLineAbove     Inserts a new empty line above the current line without attempting to execute the i
                                     nput
Shift+Ctrl+Enter InsertLineBelow     Inserts a new empty line below the current line without attempting to execute the i
                                     nput
Alt+d            KillWord            Move the text from the cursor to the end of the current or next word to the kill ri
                                     ng
Ctrl+Delete      KillWord            Move the text from the cursor to the end of the current or next word to the kill ri
                                     ng
Ctrl+v           Paste               Paste text from the system clipboard
Shift+Insert     Paste               Paste text from the system clipboard
Ctrl+y           Redo                Redo an undo
Escape           RevertLine          Equivalent to undo all edits (clears the line except lines imported from history)
Ctrl+z           Undo                Undo a previous edit
Alt+.            YankLastArg         Copy the text of the last argument to the input

Cursor movement functions
=========================

Key             Function        Description
---             --------        -----------
LeftArrow       BackwardChar    Move the cursor back one character
Ctrl+LeftArrow  BackwardWord    Move the cursor to the beginning of the current or previous word
Home            BeginningOfLine Move the cursor to the beginning of the line
End             EndOfLine       Move the cursor to the end of the line
RightArrow      ForwardChar     Move the cursor forward one character
Ctrl+]          GotoBrace       Go to matching brace
Ctrl+RightArrow NextWord        Move the cursor forward to the start of the next word

History functions
=================

Key       Function              Description
---       --------              -----------
Alt+F7    ClearHistory          Remove all items from the command line history (not PowerShell history)
Ctrl+s    ForwardSearchHistory  Search history forward interactively
F8        HistorySearchBackward Search for the previous item in the history that starts with the current input - like Pr
                                eviousHistory if the input is empty
Shift+F8  HistorySearchForward  Search for the next item in the history that starts with the current input - like NextHi
                                story if the input is empty
DownArrow NextHistory           Replace the input with the next item in the history
UpArrow   PreviousHistory       Replace the input with the previous item in the history
Ctrl+r    ReverseSearchHistory  Search history backwards interactively

Completion functions
====================

Key           Function            Description
---           --------            -----------
Ctrl+@        MenuComplete        Complete the input if there is a single completion, otherwise complete the input by se
                                  lecting from a menu of possible completions.
Ctrl+Spacebar MenuComplete        Complete the input if there is a single completion, otherwise complete the input by se
                                  lecting from a menu of possible completions.
Tab           TabCompleteNext     Complete the input using the next completion
Shift+Tab     TabCompletePrevious Complete the input using the previous completion

Prediction functions
====================

Key Function                  Description
--- --------                  -----------
F4  ShowFullPredictionTooltip Show the full tooltip of the selected list-view item in the terminal's alternate screen bu
                              ffer.
F2  SwitchPredictionView      Switch between the inline and list prediction views.

Miscellaneous functions
=======================

Key           Function              Description
---           --------              -----------
Ctrl+l        ClearScreen           Clear the screen and redraw the current line at the top of the screen
Alt+0         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+1         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+2         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+3         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+4         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+5         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+6         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+7         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+8         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+9         DigitArgument         Start or accumulate a numeric argument to other functions
Alt+-         DigitArgument         Start or accumulate a numeric argument to other functions
PageDown      ScrollDisplayDown     Scroll the display down one screen
Ctrl+PageDown ScrollDisplayDownLine Scroll the display down one line
PageUp        ScrollDisplayUp       Scroll the display up one screen
Ctrl+PageUp   ScrollDisplayUpLine   Scroll the display up one line
F1            ShowCommandHelp       Shows help for the command at the cursor in an alternate screen buffer.
Ctrl+Alt+?    ShowKeyBindings       Show all key bindings
Alt+h         ShowParameterHelp     Shows help for the parameter at the cursor.
Alt+?         WhatIsKey             Show the key binding for the next chord entered

Selection functions
===================

Key                   Function              Description
---                   --------              -----------
Ctrl+a                SelectAll             Select the entire line. Moves the cursor to the end of the line
Shift+LeftArrow       SelectBackwardChar    Adjust the current selection to include the previous character
Shift+Home            SelectBackwardsLine   Adjust the current selection to include from the cursor to the start of the
                                            line
Shift+Ctrl+LeftArrow  SelectBackwardWord    Adjust the current selection to include the previous word
Alt+a                 SelectCommandArgument Make visual selection of the command arguments.
Shift+RightArrow      SelectForwardChar     Adjust the current selection to include the next character
Shift+End             SelectLine            Adjust the current selection to include from the cursor to the end of the li
                                            ne
Shift+Ctrl+RightArrow SelectNextWord        Adjust the current selection to include the next word

Search functions
================

Key      Function                Description
---      --------                -----------
F3       CharacterSearch         Read a character and move the cursor to the next occurrence of that character
Shift+F3 CharacterSearchBackward Read a character and move the cursor to the previous occurrence of that character

