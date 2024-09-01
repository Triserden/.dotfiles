# Dotfiles? What's that?
Dotfiles are files that configure a system to a user's liking. In this case, it configures the OS, homedir, packages, disk partitions, and anything else I can with NixOS and home-manager.

# How do you choose your hostnames?
I choose them from my favorite anime characters.
 - Yuki (Laptop): [Yuki Suou](https://anilist.co/character/243404/Yuki-Suou), A cute but chaotic one that made twitter spit their beverages a few times. No real connection with my laptop.
 - Futaba (Hetzner box): [Rio Futaba](https://anilist.co/character/88748/Megumi-Katou), A quiet eccentric that is knowlegable about things. Used on my main server with all it's services.

# What is missing?
 - Docker
 - fail2ban
 - Private keys in secrets
 - `age` keys in .sops.yaml
 - Rebuild script with [nix-output-monitor](https://github.com/maralorn/nix-output-monitor)
 - Unified styles and fonts with [stylix](https://stylix.danth.me/index.html)
 - AGS bar, greeter, and lockscreen

# How do I install?
1. Make a tmp dir with `temp=$(mkdir -d)`
2. Generate SSH key for device with `ssh-keygen` to tempdir
3. Generate AGE key with `nix-shell -p ssh-to-age --run 'cat /tmp/tmp.xkNjloVAv5/etc/ssh/id_ed25519.pub | ssh-to-age'`
4. Add AGE key to `.sops.yaml`

