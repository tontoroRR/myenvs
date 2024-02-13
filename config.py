import os
import sys
from clnch import *

# 設定処理
def configure(window):

    # --------------------------------------------------------------------
    # F1 キーでヘルプファイルを起動する
    def command_Help(info):
        print( "Helpを起動 :" )
        help_path = os.path.join( getAppExePath(), 'doc\\index.html' )
        shellExecute( None, help_path, "", "" )
        print( "Done.\n" )

    window.cmd_keymap[ "F1" ] = command_Help

    # --------------------------------------------------------------------
    # Ctrl-E で、入力中のファイルパスを編集する
    window.cmd_keymap[ "C-E" ] = window.command.Edit

    # --------------------------------------------------------------------
    # Alt-Space で、自動補完を一時的にOn/Offする
    window.keymap[ "A-Space" ] = window.command.AutoCompleteToggle

    # --------------------------------------------------------------------
    # テキストエディタを設定する
    window.editor = "notepad.exe"

    # --------------------------------------------------------------------
    # ファイルタイプごとの動作設定
    window.association_list += [
        ( "*.mpg *.mpeg *.avi *.wmv", window.ShellExecuteCommand( None, "wmplayer.exe", "/prefetch:7 /Play %param%", "" ) ),
    ]

    # --------------------------------------------------------------------
    # 非アクティブ時の時計の形式
    if 1:
        # 年と秒を省略した短い形式
        window.clock_format = "%m/%d(%a) %H:%M"
    else:
        # 年月日(曜日) 時分秒 の全てを表示する
        window.clock_format = "%Y/%m/%d(%a) %H:%M:%S"

    # --------------------------------------------------------------------
    # 空欄コマンド
    #   コマンド名なしでEnterを押したときに実行されるコマンドです。
    #   この例では、ほかのアプリケーションをフォアグラウンド化するために使います。
    def command_QuickActivate(info):

        def callback( wnd, arg ):
            process_name, class_name = arg[0], arg[1]
            if (process_name==None or wnd.getProcessName()==process_name) and (class_name==None or wnd.getClassName()==class_name):
                wnd = wnd.getLastActivePopup()
                wnd.setForeground(True)
                return False
            return True

        if info.mod==MODKEY_SHIFT:
            pyauto.Window.enum( callback, ["cfiler.exe",None] )
        elif info.mod==MODKEY_CTRL:
            pyauto.Window.enum( callback, ["notepad.exe","Notepad"] )
        elif info.mod==MODKEY_SHIFT|MODKEY_CTRL:
            pyauto.Window.enum( callback, ["mintty.exe","MinTTY"] )

    window.launcher.command_list += [ ( "", command_QuickActivate ) ]

    # --------------------------------------------------------------------
    # "NetDrive" コマンド
    #   ネットワークドライブを割り当てるか解除を行います。
    #    NetDrive;L;\\server\share : \\machine\public を Lドライブに割り当てます
    #    NetDrive;L                : Lドライブの割り当てを解除します
    def command_NetDrive(info):
        
        if len(info.args)>=1:
            drive_letter = info.args[0]
            if len(info.args)>=2:
                path = info.args[1]
                checkNetConnection(path)
                if window.subProcessCall( [ "net", "use", drive_letter+":", os.path.normpath(path), "/yes" ], cwd=None, env=None, enable_cancel=False )==0:
                    print( "%s に %sドライブを割り当てました。" % ( path, drive_letter ) )
            else:
                if window.subProcessCall( [ "net", "use", drive_letter+":", "/D" ], cwd=None, env=None, enable_cancel=False )==0:
                    print( "%sドライブの割り当てを解除しました。" % ( drive_letter ) )
        else:
            print( "ドライブの割り当て : NetDrive;<ドライブ名>;<パス>" )
            print( "ドライブの解除     : NetDrive;<ドライブ名>" )


    def cmd():
        return "notepad"

    # --------------------------------------------------------------------
    # パスなど登録
    USERNAME = '()'
    DESKTOP_PATH = f"D:/Users/{USERNAME}/Desktop"
    DOCS_PATH = f"D:/Users/{USERNAME}/Documents"
    APP_PATH = f"{DESKTOP_PATH}/Application"
    SCR_PATH = f"{APP_PATH}/scripts"
    RUN_APP = f"{SCR_PATH}/run_app.js"
    RUN_DBG = f"{SCR_PATH}/run_app_debug.js"
    CONFIG_INI = f"{APP_PATH}/clnch/config.py"
    AHK_EXE = f"{APP_PATH}/AutoHotKey/AutoHotkey64.exe"
    INIT_LUA = f"D:/Users/{USERNAME}/scoop/apps/nvim/init.lua"
    NVY = "nvy --geometry=76x26 --position=1020,0 "

    def rep():
        return CC

    def openByNvy(arg = ''):
        return f"\"{NVY} {arg}\""

    def execByPython(arg = ''):
        return f"\"python3.exe {arg}\""

    # --------------------------------------------------------------------
    # コマンドを登録する
    window.launcher.command_list += [
        # ( "NetDrive",  command_NetDrive ),
        # ( "        ",            window.ShellExecuteCommand( None, , "", "") ),
        ( "afx",            window.ShellExecuteCommand( None, f"{APP_PATH}/afxw/afxw.exe", "", "") ),
        ( "AhkSpy",         window.ShellExecuteCommand( None, f"{APP_PATH}/AutoHotKey/AutoHotKey64.exe", f"{APP_PATH}/AutoHotKey/WindowSpy.ahk", "") ),
        ( "alacritty",      window.ShellExecuteCommand( None, RUN_APP, "alacritty", "") ),
        ( "BlueStacks",     window.ShellExecuteCommand( None, f"D:/Users/{USERNAME}/AppData/BlueStacks/BlueStacks X/BlueStacks X.exe", "", "D:/Users/{USERNAME}/AppData/BlueStacks/BlueStacks X/") ),
        ( "Brave",          window.ShellExecuteCommand( None, RUN_APP, "brave", "") ),
        ( "Calc",           window.ShellExecuteCommand( None, "calc.exe", "", "") ),
        ( "Chrome",         window.ShellExecuteCommand( None, "chrome.exe", "", "") ),
        ( "clcl",           window.ShellExecuteCommand( None, f"{APP_PATH}/clcl/clcl.exe", "", "") ),
        ( "clcl_set",       window.ShellExecuteCommand( None, f"{APP_PATH}/clcl/clclse.exe", "", "") ),
        ( "Deck",           window.ShellExecuteCommand( None, "python3.exe", f"{DOCS_PATH}/RR-automate/DeckStats.py", f"{DOCS_PATH}/RR-automate/") ),
        ( "Edge",           window.ShellExecuteCommand( None, "msedge.exe", "", "") ),
        ( "Edit_AlacrittyYml",
                            window.ShellExecuteCommand( None, RUN_APP, openByNvy("%APPDATA%/alacritty/alacritty.yml"), "") ),
        ( "Edit_afxkey",    window.ShellExecuteCommand( None, RUN_APP, openByNvy(f"{APP_PATH}/afxw/afxw.key"), "") ),
        ( "Edit_Config",    window.ShellExecuteCommand( None, RUN_APP, openByNvy(CONFIG_INI), "") ),
        ( "Edit_RunApp",    window.ShellExecuteCommand( None, RUN_APP, openByNvy(RUN_APP), "") ),
        ( "Explorer",       window.ShellExecuteCommand( None, "explorer.exe", "", "") ),
        ( "FileZilla-Server",
                            window.ShellExecuteCommand( None, f"{APP_PATH}/FileZilla/Server/filezilla-server.exe", "", "") ),
        ( "Greenshot.png",  window.ShellExecuteCommand( None, f"{DESKTOP_PATH}/greenshot/", "", "") ),
        ( "Gnumeric",       window.ShellExecuteCommand( None, f"{APP_PATH}/Gnumeric/GnumericPortable.exe", "", "") ),
        ( "Imhex",          window.ShellExecuteCommand( None, f"{APP_PATH}/Imhex/Imhex-gui.exe", "", "") ),
        ( "initlua",        window.ShellExecuteCommand( None, RUN_APP, openByNvy(INIT_LUA), "") ),
        ( "LINE",           window.ShellExecuteCommand( None, f"{SCR_PATH}/LINE.lnk", "", "") ),
        ( "MSPaint",        window.ShellExecuteCommand( None, "MSPaint.exe", "", "") ),
        ( "MyGames",        window.ShellExecuteCommand( None, "C:/MY.GAMES/MY.GAMES Launcher/MGL.exe", "", "") ),
        ( "Notepad",        window.ShellExecuteCommand( None, "notepad.exe", "", "") ),
        ( "Nvy",            window.ShellExecuteCommand( None, RUN_APP, openByNvy(), "") ),
        ( "OBS",            window.ShellExecuteCommand( None, f"{APP_PATH}/obs-studio/bin/64bit/obs64.exe", "", f"{APP_PATH}/obs-studio/bin/64bit") ),
        ( "Peazip",         window.ShellExecuteCommand( None, f"{APP_PATH}/peazip/peazip.exe", "", "") ),
        ( "RR",             window.ShellExecuteCommand( None, RUN_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/resetRRWindow.py"), "") ),
        ( "scrcpy",         window.ShellExecuteCommand( None, RUN_APP, "scrcpy", "") ),
        ( "SendAnywhere",   window.ShellExecuteCommand( None, f"{APP_PATH}/shortcuts/Send AnyWhere.lnk", "", "") ),
        ( "SnippingTool",   window.ShellExecuteCommand( None, "snippingtool", "", "") ),
        ( "Spy++",          window.ShellExecuteCommand( None, f"{APP_PATH}/spyxx/spyxx.exe", "", "") ),
        ( "srr",            window.ShellExecuteCommand( None, RUN_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py"), "") ),
        ( "srm",            window.ShellExecuteCommand( None, RUN_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py 62 62"), "") ),
        ( "srh",            window.ShellExecuteCommand( None, RUN_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py 110 66"), "") ),
        ( "Stirling",       window.ShellExecuteCommand( None, f"{APP_PATH}/stirling/stirling.exe", "", "") ),
        ( "TV",             window.ShellExecuteCommand( None, f"{SCR_PATH}/SwitchBot_TV.exe", "", "") ),
        ( "WinDirStat",     window.ShellExecuteCommand( None, f"{APP_PATH}/WinDirStat/windirstat.exe", "", "") ),

        # RushRoyale -----------------------------------------------------
        ( "R.Volume",      window.ShellExecuteCommand( None, AHK_EXE, f"{SCR_PATH}/RR_click_volume.txt", "") ),
        ( "R.Summon",      window.ShellExecuteCommand( None, AHK_EXE, f"{SCR_PATH}/RR_click_summon.txt", "") ),
        # ( "Edit_init.lua", 

        # URL ------------------------------------------------------------
        ( "Amazon",         window.UrlCommand( "https://www.amazon.co.jp/", encoding="utf8" ) ),
        ( "AliExpress",     window.UrlCommand( "https://ja.aliexpress.com/", encoding="utf8" ) ),
    ]


# リストウインドウの設定処理
def configure_ListWindow(window):

    # --------------------------------------------------------------------
    # F1 キーでヘルプファイルを表示する

    def command_Help(info):
        print( "Helpを起動 :" )
        help_path = os.path.join( getAppExePath(), 'doc\\index.html' )
        shellExecute( None, help_path, "", "" )
        print( "Done.\n" )

    window.keymap[ "F1" ] = command_Help

