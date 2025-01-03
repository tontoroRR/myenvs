# create $profile
if (-not (test-path $profile)) {
  New-Item -Path $profile -Type File -Force
}

# scoop install
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

# install apps
scoop install git
scoop bucket add extras
scoop install neovim zoxide sudo which ripgrep wget python wezterm win32yank peazip
scoop install Maple-Mono-SC-NF Maple-Mono-NF
scoop install vcredist

# zoxide 設定
if (-not (Test-Path $profile)) {
  New-Item -path $profile -type file –force
}
echo "Invoke-Expression (& { (zoxide init powershell | Out-String) })" >> $profile

# fzfはこのあたり参考に https://zenn.dev/mebiusbox/articles/b922c7e6ded49a したいが難しすぎてよくわからない

# package manager + programing languages
## node version manager
scoop install nvm
nvm install latest
npm install -f yarn@latest
yarn -v # > 1.22.22

## ruby env
# https://github.com/RubyMetric/rbenv-for-windows
$env:RBENV_ROOT = "C:\Ruby-on-Windows"
iwr -useb "https://github.com/RubyMetric/rbenv-for-windows/raw/main/tool/install.ps1" | iex
### $profile setting
echo '# rbenv for Windows
$env:RBENV_ROOT = "C:\Ruby-on-Windows"
& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init' >> $profile

## lua, rustup, rust, cc:q

## java
scoop bucket add java
scoop install temurin-lts-jdk

# nvim checkstatus
# - ERROR {C:/Users/(name)/AppData/Local/nvim-data/lazy-rocks/hererocks/bin/luarocks} not installed
# - WARNING `tree-sitter` executable not found (parser generator, only needed for :TSInstallFromGrammar, not required for :TSInstall)
# - ERROR `cc` executable not found.
# - WARNING Missing "neovim" npm (or yarn, pnpm) package.
#   - ADVICE:
#     - Run in shell: npm install -g neovim
# - WARNING No perl executable found
#   - ADVICE:
#     - See :help |provider-perl| for more information.
#     - You may disable this provider (and warning) by adding `let g:loaded_perl_provider = 0` to your init.vim
# - ERROR Detected pip upgrade failure: Python executable can import "pynvim" but not "neovim":
#   - ADVICE:
#     - Use that Python version to reinstall "pynvim" and optionally "neovim".
#     -  -m pip uninstall pynvim neovim
#     -  -m pip install pynvim
#     -  -m pip install neovim  # only if needed by third-party software
# Ruby provider (optional) ~
# - Ruby: ruby 3.3.4-1 (set by C:\Ruby-on-Windows\global.txt)
# - WARNING `neovim-ruby-host` not found.
#   - ADVICE:
#     - Run `gem install neovim` to ensure the neovim RubyGem is installed.
#     - Run `gem environment` to ensure the gem bin directory is in $PATH.
#     - If you are using rvm/rbenv/chruby, try "rehashing".
#     - See :help |g:ruby_host_prog| for non-standard gem installations.
#     - You may disable this provider (and warning) by adding `let g:loaded_ruby_provider = 0` to your init.vim
# checking for overlapping keymaps ~
# - WARNING In mode `n`, <o> overlaps with <ot>, <on>, <od>, <os>, <om>, <oc>, <og>:
#   - <o>: show_help
#   - <ot>: order_by_type
#   - <on>: order_by_name
#   - <od>: order_by_diagnostics
#   - <os>: order_by_size
#   - <om>: order_by_modified
#   - <oc>: order_by_created
#   - <og>: order_by_git_status
# - WARNING In mode `n`, <g> overlaps with <g%>, <gc>, <gcc>, <gt>, <gx>, <g!>, <g!!>, <gd>, <gr>, <g=>, <g==>:
#   - <g%>: Cycle backwards through results
#   - <gc>: Toggle comment
#   - <gcc>: Toggle comment line
#   - <gt>: Go to next tab page
#   - <gx>: Opens filepath or URI under cursor with the system handler (file explorer, web browser, …)
# - WARNING In mode `n`, <z> overlaps with <zS>, <zz>:
#   - <z>: close_all_nodes
#   - <zz>: Center this line
# - WARNING In mode `n`, <.> overlaps with <..>:
#   - <.>: set_root
# - WARNING In mode `n`, <g=> overlaps with <g==>:
#
# - WARNING In mode `n`, <g!> overlaps with <g!!>:
#
# - WARNING In mode `n`, <gc> overlaps with <gcc>:
#   - <gc>: Toggle comment
#   - <gcc>: Toggle comment line

# craftlaunchからnvy起動時にnodeがないと怒られる、pwsh起動も同じ
# Ctrl+EからだとOK、どこからその設定が導かれる？

# torrent
