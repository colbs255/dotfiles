function agent-sandboxed --description 'Run claude --dangerously-skip-permissions inside a bwrap sandbox confined to the current project'
    set -l project_dir (pwd)
    set -l claude_path (command -v claude)

    if test -z "$claude_path"
        echo "agent-sandboxed: claude not found on PATH" >&2
        return 1
    end

    set -l claude_bin (readlink -f $claude_path)

    # NixOS's system ssh_config Includes a systemd-ssh-proxy snippet from the
    # Nix store (for `ssh <container>` via systemd-machined) that is unrelated
    # to normal git-over-ssh. Inside an unprivileged bwrap sandbox, root-owned
    # files appear owned by the unmapped "nobody" uid, and ssh's strict
    # ownership check on Include'd files then aborts *all* ssh connections.
    # Strip the Include line and shadow the real (symlink-resolved) config
    # path so ordinary ssh usage (git, etc.) keeps working.
    set -l ssh_config_override (mktemp)
    set -l ssh_config_real /etc/ssh/ssh_config
    if test -f $ssh_config_real
        grep -viE '^\s*include\b' $ssh_config_real >$ssh_config_override
        set ssh_config_real (readlink -f $ssh_config_real)
    end

    set -l bwrap_args \
        --unshare-all --share-net \
        --die-with-parent \
        --proc /proc \
        --dev /dev \
        --tmpfs /tmp \
        --ro-bind /nix /nix \
        --ro-bind /run/current-system /run/current-system \
        --ro-bind /etc /etc \
        --ro-bind-try $ssh_config_override $ssh_config_real \
        --ro-bind-try $HOME/.nix-profile $HOME/.nix-profile \
        --ro-bind-try $HOME/.local/state/nix $HOME/.local/state/nix \
        --ro-bind-try $HOME/.local/bin $HOME/.local/bin \
        --bind $project_dir $project_dir \
        --bind-try $HOME/.claude $HOME/.claude \
        --bind-try $HOME/.claude.json $HOME/.claude.json \
        --bind-try $HOME/.cache/claude-cli-nodejs $HOME/.cache/claude-cli-nodejs \
        --ro-bind-try $HOME/.config/git $HOME/.config/git \
        --bind-try $HOME/.config/gh $HOME/.config/gh \
        --ro-bind-try $HOME/.ssh/known_hosts $HOME/.ssh/known_hosts \
        --ro-bind-try $HOME/.ssh/config $HOME/.ssh/config \
        --setenv HOME $HOME \
        --chdir $project_dir

    # A git worktree's real git dir (refs, objects, worktree admin files) lives
    # outside the worktree checkout, so bind it in too or git breaks entirely.
    if git -C $project_dir rev-parse --git-common-dir >/dev/null 2>&1
        set -l git_common_dir (realpath (git -C $project_dir rev-parse --git-common-dir))
        if not string match -q "$project_dir/*" $git_common_dir
            and test "$git_common_dir" != "$project_dir"
            set bwrap_args $bwrap_args --bind $git_common_dir $git_common_dir
        end
    end

    # Forward the ssh-agent socket instead of exposing the private key
    # material itself inside the sandbox.
    if set -q SSH_AUTH_SOCK; and test -S "$SSH_AUTH_SOCK"
        set bwrap_args $bwrap_args --bind $SSH_AUTH_SOCK $SSH_AUTH_SOCK
    end

    bwrap $bwrap_args -- $claude_bin --dangerously-skip-permissions $argv
    set -l exit_code $status
    rm -f $ssh_config_override
    return $exit_code
end
