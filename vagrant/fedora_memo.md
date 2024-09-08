1. Vagrantfileでつかうのは"bento/fedora-latest"
1. vagrant-vbguestプラグインを使うが、たぶん途中でエラーになる
1. VMは立ち上がっているので、vagrant sshで入る
   ```
   sudo dnf update
   sudo dnf install kernel-devel
   ```
1. exitで抜ける
1. vagrant reloadする
1. 次のような出力がでてとまるかもしれないので、Ctrl+Cで止める
   ```
   VirtualBox Guest Additions: Running kernel modules will not be replaced until
   the system is restarted or 'rcvboxadd reload' triggered
   VirtualBox Guest Additions: reloading kernel modules and services
   VirtualBox Guest Additions: kernel modules and services 7.0.20 r163906 reloaded
   VirtualBox Guest Additions: NOTE: you may still consider to re-login if some
   user session specific services (Shared Clipboard, Drag and Drop, Seamless or
   Guest Screen Resize) were not restarted automatically
   ```
1. VMは起動しているはずなので、vagrant sshではいる
   ```
   sudo dnf update
   sudo /mnt/VBoxLinuxAdditions.run
   ```
1. exitで抜けて、vagrant haltで止める。
1. 1.もしrubyが起動しているというようなエラーがでたばあ、タスクマネージャーでrubyのプロセスをKILLする
1. vagrant upする

sudo dnf install neovim

### ssh設定
vagrantに入ったらssh-keygenする。特に何も指定せずEnter、Enterでよい
~/.ssh/のしたにできるはず
cat ~/.ssh/id_*.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
privateキーをホストOSに持ってくる
ファイルの権限をかえて所有者しか見れないようにする
参考： https://qiita.com/tatsuya_koizumi/items/8c9e8b3432279b2c6461
Vagrantfileに以下の設定を追加する
```
  # ssh
  config.ssh.guest_port = 2222
  config.ssh.private_key_path = "./id_ed25519"
```
vagrant ssh-config > C:/Users/(名前)/.ssh/configとして、Host名をdefaultから適当なのに変更する

### DISPLAY設定
~/.bashrcに以下を追加
```
export DISPLAY=$(echo $SSH_CLIENT|cut -f1 -d" "):0.0
```

### X Serverの起動
scoopでvcxsrvをインストール
vcxsrv -multiwindow -acで起動しておく

### 今後やるべきは
1. 開発環境を構築（neovimあれこれできるように）
   * asdf
   * rust製ツール
   * python、ruby、nodeなど入れる
   * tree-sitter
   * cocではなく、DAPを使うようにする
3. dockerをいれる
