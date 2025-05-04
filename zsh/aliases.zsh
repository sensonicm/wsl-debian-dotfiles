# Start Nvim
alias n=nvim

# Open current directory in Windows Explorer
alias open=explorer.exe

# Pretty display of file contents in terminal
alias bat="batcat"

# List directory with EZA
alias ll="/home/mad/.cargo/bin/eza --tree --level=1 --icons=always --color=always --long --no-filesize --no-time --no-user --no-permissions"

# Start Yazi file manager
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}