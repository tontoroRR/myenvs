# zoxide
# zoxide init nushell | save -f $"($nu.default-config-dir)\\.zoxide.nu"
source $"($nu.default-config-dir)/.zoxide.nu"

# starship
# starship init nu | save -f $"($nu.default-config-dir)/starship.nu"
use $"($nu.default-config-dir)/starship.nu"

# git complition
source $"($nu.default-config-dir)/nu_scripts/custom-completions/git/git-completions.nu"
