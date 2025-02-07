import os
import sys
from clnch import *

import subprocess
import datetime

import ctypes
import multiprocessing as mp
import urllib.parse

class Clipboard:
    def __init__(self):
        return

    @classmethod
    def get(cls):
        proc = subprocess.Popen(['win32yank.exe', '-o'], shell=True, stdout=subprocess.PIPE)
        txt = ''
        while True:
            line = proc.stdout.readline()
            if not line: break
            txt += line.decode('utf8')
        return txt

    @classmethod
    def set(cls):
        return None

# 設定処理
def configure(window):
    def message_box(title, body):
        ctypes.windll.user32.MessageBoxW(None, body, title, 0x2030)

    # --------------------------------------------------------------------
    # F1 キーでヘルプファイルを起動する
    def command_Help(info):
        print("Helpを起動 :")
        help_path = os.path.join(getAppExePath(), 'doc\\index.html')
        shellExecute(None, help_path, "", "")
        print("Done.\n")

    window.cmd_keymap["F1"] = command_Help

    # --------------------------------------------------------------------
    # Ctrl-E で、入力中のファイルパスを編集する
    # window.cmd_keymap["C-E"] = window.command.Edit

    # --------------------------------------------------------------------
    # Alt-Space で、自動補完を一時的にOn/Offする
    window.keymap["A-Space"] = window.command.AutoCompleteToggle

    # --------------------------------------------------------------------
    # テキストエディタを設定する
    window.editor = "notepad.exe"

    # --------------------------------------------------------------------
    # ファイルタイプごとの動作設定
    window.association_list += [
        (
            "*.mpg *.mpeg *.avi *.wmv",
            window.ShellExecuteCommand(
                None,
                "wmplayer.exe",
                "/prefetch:7 /Play %param%", ""
               )
       ),
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
        print(info.args)
        def callback(wnd, arg):
            process_name, class_name = arg[0], arg[1]
            if (process_name is None or wnd.getProcessName() == process_name) and (class_name is None or wnd.getClassName() == class_name):
                wnd = wnd.getLastActivePopup()
                wnd.setForeground(True)
                return False
            return True
        if info.mod==MODKEY_SHIFT:
            pyauto.Window.enum(callback, ["Nvy.exe",None])
        elif info.mod==MODKEY_CTRL:
            if len(info.args) == 0:
                subprocess.Popen(['nvy.exe', f'{APP_DIR}/CraftLaunch/config.py'], shell=True)
                return
            elif len(info.args) == 1:
                param = str.strip(info.args[0])
            print(param)
            subprocess.Popen(['start', f'{param}'], shell=True)
            # pyauto.Window.enum(callback, ["notepad.exe","Notepad"])
        elif info.mod==MODKEY_SHIFT|MODKEY_CTRL:
            pyauto.Window.enum(callback, ["mintty.exe","MinTTY"])

    window.launcher.command_list += [ ("", command_QuickActivate) ]

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
                if window.subProcessCall([ "net", "use", drive_letter+":", os.path.normpath(path), "/yes" ], cwd=None, env=None, enable_cancel=False)==0:
                    print("%s に %sドライブを割り当てました。" % (path, drive_letter))
            else:
                if window.subProcessCall([ "net", "use", drive_letter+":", "/D" ], cwd=None, env=None, enable_cancel=False)==0:
                    print("%sドライブの割り当てを解除しました。" % (drive_letter))
        else:
            print("ドライブの割り当て : NetDrive;<ドライブ名>;<パス>")
            print("ドライブの解除     : NetDrive;<ドライブ名>")

    # --- utility
    def datetime_now():
        ret = datetime.datetime.now().strftime('%Y%m%d-%H%M')
        return ret

    def vb_getstate(vmname):
        f'{VIRB_DIR}/VBoxManage.exe showvminfo {vmname}'

    def search_youtube(info):
        param = urllib.parse.quote_plus(Clipboard.get())
        start_exe('brave.exe', f'https://youtube.com/results?search_query={param}')

    def alarm(info):
        # TODO
        wait = "3m"
        if len(info.args) == 1:
            wait = info.args[0].lower

    # --- register commands
    def register_app(name='', param='', path=''):
        program = name if path == '' else f'{path}/{name}'
        return window.ShellExecuteCommand(None, program, param, path)

    def register_scoop_app(name='', param='', path=''):
        scoop_dir = 'D:/UserSetting/scoop'
        if name == '': return
        program_path = f'{scoop_dir}/apps/{name}/current' if path == '' else f'{scoop_dir}/apps/{path}'
        return window.ShellExecuteCommand(None, f'{program_path}/{name}.exe', param, program_path)

    def register_portable_app(name='', param='', path=''):
        portable_dir = 'D:/UserSetting/PortableApps'
        if name == '': return
        program_path = f'{portable_dir}/{name}' if path == '' else f'{portable_dir}/{path}'
        return window.ShellExecuteCommand(None, f'{program_path}/{name}.exe', param, program_path)

    def open_brave_url(url):
        return window.ShellExecuteCommand(None, 'brave.exe', url, '')

    # --- start exe
    # need to be extracted to class module
    def start_exe(exe, param=[], path='', start=True):
        if isinstance(exe, str): exe = [exe]
        if isinstance(param, str): param = [param]
        if start:
            command_line = ['start'] + exe + param
        else:
            command_line = exe + param
        if False: print(command_line)
        if path == '':
            subprocess.Popen(command_line, shell=True)
        else:
            subprocess.Popen(command_line, shell=True, cwd=path)

    def execute_by_parameter(info, app, switch_params, params, default, path='', start=True):
        if len(info.args) == 0:
            start_exe(app, default, path, start)
        elif len(info.args) == 1:
            subcmd = info.args[0].lower()
            if (subcmd in switch_params):
                param = switch_params[subcmd]
                start_exe(app, params(param), path, start)
        else:
            print(f'Given paramter is incorrect. {info}')
        return

    def vbmanage(vmname, info):
        app = r"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
        switch_params = {
            'up': f'startvm {vmname}',
            'down': f'controlvm {vmname} poweroff',
            'take': f'snapshot {vmname} take {datetime_now()}',
            'reload': f'controlvm {vmname} reboot',
            'status': f'showvminfo {vmname}',
        }
        params = lambda param: param.split(' ')
        default = f'showvminfo {vmname}'.split(' ')
        execute_by_parameter(info, app, switch_params, params, default, start=False)

    def vbmanage_fedora(info):
        vbmanage('fedora', info)

    def vbmanage_arch(info):
        vbmanage('arch', info)

    def vbmanage_ubuntuserver(info):
        vbmanage('ubuntu-server', info)

    def vagrant(vbname, path, info):
        app = 'cmd.exe'
        switch_params = {
            'up': 'up',
            'down': 'halt',
            'remove': 'destroy --force',
            'reload': 'reload',
            'status': 'status'
        }
        params = lambda param: ['/C'] + ['vagrant.exe ' + param + ' & timeout 10']
        default = ['status']
        execute_by_parameter(info, app, switch_params, params, default, path)
        # if given arg is not in switch_params, run vbmanage(vbname, info)

    def vagrant_manjaro(info):
         vagrant('manjaro-i3', r'D:\vagrant\manjaro', info)

    def vagrant_man2(info):
         vagrant('manjaro-2', r'D:\vagrant\man2', info)

    # infoの第1引数はVM名、第2以降にアクションなど
    def vm(info):
        if len(info.args) < 1:
            return
        else:
            # VM名が存在するか確認
            # 存在しない場合は
            # vagrantかVirtualBoxか判定する
            # if vagrant:
            #   vagrant()
            #  
            return

    def edit_file(info):
        app = 'Nvy.exe'
        switch_params = {
            'c': fr'{APP_DIR}/CraftLaunch/config.py',
            'i': fr'{APP_DIR}/CraftLaunch/clnch.ini',
            'w': fr'{HOME_DIR}/.wezterm.lua',
            'v': fr'{HOME_DIR}/AppData/Local/nvim/init.lua',
        }
        params = lambda param: [param]
        default = ['']
        execute_by_parameter(info, app, switch_params, params, default)

    def copy_as(info):
        start_exe(['/MIN', 'pwsh', '-NoProfile', '-Command', 'cp', r'D:\UserSetting\PortableApps\CraftLaunch\config.py', r'D:\shared_folder\ghq\github.com\tontoroRR\myenvs\.'])
        # start_exe('copy', [r'D:\UserSetting\PortableApps\CraftLaunch\config.py', r'D:\shared_folder\ghq\github.com\tontoroRR\myenvs\.'])

    def scr(info):
        app = fr'{CLNCH_SCR_DIR}\srm\dist\srm.exe'
        switch_params = {
            'm': '', # 61 61
            'r': '44 61',
            'h': '110 65'
        }
        params = lambda param: param.split(' ')
        default = ['']
        execute_by_parameter(info, app, switch_params, params, default)

    def ghq_explorer(info):
        app = 'pwsh.exe'
        switch_params = {
            'c': '{pwsh.exe -Noexit -Command "z $p"}',
            'e': '{explorer $p}',
        }
        params = lambda param: ['-nop', '-Command', f'Set-Variable -Name p -Value (ghq list --full-path|fzf);if ($p) {param}']
        default = ['-nop', '-Command', 'Set-Variable -Name p -Value (ghq list --full-path|fzf);if ($p) {explorer $p}']
        execute_by_parameter(info, app, switch_params, params, default)

    # --------------------------------------------------------------------
    # ショートカット 
    window.keymap['C-y'] = search_youtube
    window.keymap['C-c'] = copy_as
    # window.keymap['C-e'] = 

    # --------------------------------------------------------------------
    # 
    VIRB_DIR = r'C:\Program Files\Oracle\VirtualBox'
    APP_DIR = 'D:/UserSetting/PortableApps'
    AHK_UX_DIR = r'D:\UserSetting\scoop\apps\autohotkey\current\UX'
    GHQ_DIR = r'D:\shared_folder\ghq'
    CLNCH_SCR_DIR = fr'{GHQ_DIR}\github.com\tontoroRR\myenvs\clnch_scripts'
    HOME_DIR = fr'{os.environ["USERPROFILE"]}'
    # --------------------------------------------------------------------
    # コマンドを登録する
    window.launcher.command_list += [
        ('a1', window.ShellExecuteCommand(None, 'launcher.ahk', '', AHK_UX_DIR)),
        ('alarm', alarm),
        ('ahkspy', window.ShellExecuteCommand(None, 'windowspy.ahk', '', AHK_UX_DIR)),
        ('arch', vbmanage_arch),
        ('brave', register_app('brave.exe')),
        ('calc', register_app('calc.exe')),
        ('cmd', register_app('cmd.exe')),
        ('copy_as', copy_as),
        ('edge', register_app('msedge.exe', '--profile-directory=Default')),
        ('explorer', register_app('explorer.exe')),
        ('ef', edit_file),
        ('fedora', vbmanage_fedora),
        ('foobar2000', register_scoop_app('foobar2000')),
        ('ghq_explorer', ghq_explorer),
        ('gvim', register_scoop_app('gvim', '', 'vim-nightly/current')),
        ('greeshot_folder', register_app(f'{HOME_DIR}/Pictures/greenshots/')),
        ('hibernate', window.ShellExecuteCommand(None, 'shutdown', '/h /f', '')),
        ('manjaro', vagrant_manjaro),
        ('man2', vagrant_man2),
        ('mspaint', register_app('MSPaint.exe')),
        ('MyGames', register_app(f'D:/MyGames/MY.GAMES Launcher/MGL.exe')),
        ('neeview', register_app('neeview.exe')),
        ('notepad', register_app('notepad.exe')),
        ('nvy', register_scoop_app('Nvy')),
        ('obs-studio', register_scoop_app('obs64', '', 'obs-studio/current/bin/64bit')),
        ('peazip', register_scoop_app('peazip')), 
        ('portableapps', window.ShellExecuteCommand(None, APP_DIR, '', '')),
        ('pwsh', register_scoop_app('pwsh')),
        ('qbittorrent', register_scoop_app('qbittorrent', '', 'qbittorrent-enhanced/current')),
        ('restart', window.ShellExecuteCommand(None, 'shutdown', '', '')),
        ('sleep', window.ShellExecuteCommand(None, 'rundll32.exe', 'powrprof.dll,SetSuspendState 0,1,0', '')),
        ('sr', scr),
        ('startup', window.ShellExecuteCommand(None, 'explorer.exe', 'shell:startup', '')),
        ('shutdown', window.ShellExecuteCommand(None, 'shutdown.exe', '/r /t 1', '')),
        ('taskmgr', register_app('taskmgr.exe')),
        ('UbuntuServer', vbmanage_ubuntuserver),
        ('VirtualBox', register_app('VirtualBox.exe', '', fr'{VIRB_DIR}')),
        ('VcXsrv', register_scoop_app('VcXsrv', '-multiwindow -ac')),
        ('vlc', register_scoop_app('vlc')),
        ('vm', vm),
        ('wezterm', register_scoop_app('wezterm-gui', '', 'wezterm/current')), #wezterm),
        ('windirstat', register_scoop_app('WinDirStat')),
        ('winterm', register_scoop_app('WindowsTerminal', '', 'windows-terminal-preview/current')),

        # URL / Edge
        ('abema', window.UrlCommand('https://abema.tv', encoding = 'utf8')),
        ('amaprime', window.UrlCommand('https://www.amazon.co.jp/gp/video/storefront', encoding = 'utf8')),
        ('netflix', window.UrlCommand('https://www.netflix.com/jp/', encoding = 'utf8')),
        ('tver', window.UrlCommand('https://tver.jp', encoding = 'utf8')),
        # URL / Brave
        ('amazon', open_brave_url('https://www.amazon.co.jp')),
        ('chatgpt', open_brave_url('https://chatgpt.com')),
        ('deepL', open_brave_url('https://www.deepl.com/translator')),
        ('drive', open_brave_url('https://drive.google.com/')),
        ('discord', open_brave_url('https://discord.com/channels/@me')),
        ('ebay', open_brave_url('https://www.ebay.com')),
        ('github', open_brave_url('http://github.com/tontoroRR')),
        ('gmail', open_brave_url('https://mail.google.com/')),
        ('Google', open_brave_url('http://www.google.com/search?ie=utf8&q=%param%')),
        ('kanboard', open_brave_url('http://localhost:8080/')),
        ('links', open_brave_url('https://docs.google.com/spreadsheets/d/(sheet id)/edit?gid=0#gid=0')),
        ('mercari', open_brave_url('https://jp.mercari.com')),
        ('qiita', open_brave_url('https://qiita.com/tontoroRR')),
        ('scoop', open_brave_url('https://scoop.sh/#/apps?q=%param%')),
        ('youtube', search_youtube),
        ('twitter', open_brave_url('https://twitter.com')),
        ('zenplace', open_brave_url('https://mypage.zenplace.co.jp/mypage/schedule/')),

        # Not used
        # def execByPython(arg = ''):
        #     return f"\"python3.exe {arg}\""
        #
        # INIT_LUA = f"D:/Users/{USERNAME}/scoop/apps/nvim/init.lua"
        # NVY = "nvy --geometry=76x26 --position=1020,0 "
        # ( "afx",            window.ShellExecuteCommand( None, f"{APP_PATH}/afxw/afxw.exe", "", "") ),
        # ( "clcl",           window.ShellExecuteCommand( None, f"{APP_PATH}/clcl/clcl.exe", "", "") ),
        # ( "clcl_set",       window.ShellExecuteCommand( None, f"{APP_PATH}/clcl/clclse.exe", "", "") ),
        # ( "Edit_afxkey",    window.ShellExecuteCommand( None, register_APP, openByNvy(f"{APP_PATH}/afxw/afxw.key"), "") ),
        # ( "Deck",           window.ShellExecuteCommand( None, "python3.exe", f"{DOCS_PATH}/RR-automate/DeckStats.py", f"{DOCS_PATH}/RR-automate/") ),
        # ( "FileZilla-Server", window.ShellExecuteCommand( None, f"{APP_PATH}/FileZilla/Server/filezilla-server.exe", "", "") ),
        # ( "Imhex",          window.ShellExecuteCommand( None, f"{APP_PATH}/Imhex/Imhex-gui.exe", "", "") ),
        # ( "initlua",        window.ShellExecuteCommand( None, register_APP, openByNvy(INIT_LUA), "") ),
        # ( "LINE",           window.ShellExecuteCommand( None, f"{SCR_PATH}/LINE.lnk", "", "") ),
        # ( "RR",             window.ShellExecuteCommand( None, register_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/resetRRWindow.py"), "") ),
        # ( "scrcpy",         window.ShellExecuteCommand( None, register_APP, "scrcpy", "") ),
        # ( "SnippingTool",   window.ShellExecuteCommand( None, "snippingtool", "", "") ),
        # ( "Spy++",          window.ShellExecuteCommand( None, f"{APP_PATH}/spyxx/spyxx.exe", "", "") ),
        # ( "srr",            window.ShellExecuteCommand( None, register_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py"), "") ),
        # ( "srm",            window.ShellExecuteCommand( None, register_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py 62 62"), "") ),
        # ( "srh",            window.ShellExecuteCommand( None, register_APP, execByPython(f"{DOCS_PATH}/RR-automate/tools/screenshot.py 110 66"), "") ),
        # ( "Stirling",       window.ShellExecuteCommand( None, f"{APP_PATH}/stirling/stirling.exe", "", "") ),
        # ( "TV",             window.ShellExecuteCommand( None, f"{SCR_PATH}/SwitchBot_TV.exe", "", "") ),
        # ( "WinDirStat",     window.ShellExecuteCommand( None, f"{APP_PATH}/WinDirStat/windirstat.exe", "", "") ),
        # ( "R.Volume",      window.ShellExecuteCommand( None, AHK_EXE, f"{SCR_PATH}/RR_click_volume.txt", "") ),
        # ( "R.Summon",      window.ShellExecuteCommand( None, AHK_EXE, f"{SCR_PATH}/RR_click_summon.txt", "") ),
    ]

# リストウインドウの設定処理
def configure_ListWindow(window):
    # --------------------------------------------------------------------
    # F1 キーでヘルプファイルを表示する
    def command_Help(info):
        print("Helpを起動 :")
        help_path = os.path.join(getAppExePath(), 'doc\\index.html')
        shellExecute(None, help_path, "", "")
        print("Done.\n")
    window.keymap[ "F1" ] = command_Help
