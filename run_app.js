// portableapps/scripts
wsShell = WScript.createObject("WScript.Shell");
// retCode = wsShell.Run("\"C:\\Users\\(name)\\scoop\\apps\\powershell\\current\\pwsh.exe\" -Command \"" + WScript.Arguments.Item(0)+"\"",0,true);
retCode = wsShell.run("pwsh -WindowStyle Hidden -Command " + WScript.Arguments.Item(0), 0, true);
WScript.Quit(retCode);
