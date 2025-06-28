# Github-DeployKey-Setup Script

This is an interactive Bash script to help you generate SSH deploy keys, configure GitHub SSH access using a custom alias, and optionally clone private repositories securely.

---

## ✅ Features

- Generates a secure RSA SSH key for use as a GitHub Deploy Key
- Adds the key configuration to your local `~/.ssh/config`
- Prints the public key so you can copy and paste it into GitHub
- Optionally clones the repository after setup
- Prevents accidental overwrite of existing keys or clone directories

---

## ⚙️ Requirements

- Bash (Linux/macOS or WSL)
- `git`
- `ssh` and `ssh-keygen` (usually preinstalled)

---

## 🚀 Usage

```bash
chmod +x deploykey-setup.sh
./deploy-key.sh
```

The script will prompt you for:

1. The SSH URL of your GitHub repository (e.g., `git@github.com:your-org/your-repo.git`)
2. A name for the private key file (default suggested)
3. A custom SSH alias for use in `~/.ssh/config`
4. Whether you want to immediately clone the repository
5. If cloning, the destination path (and it will warn before overwriting anything)

After running the script, copy the printed public key and add it as a **Deploy Key** in your GitHub repository settings.

---

## 🔐 Security

This script stores SSH keys locally in `~/.ssh/`. It does **not** upload or share your private key. Your `.gitignore` should already exclude all key files.

---

## 📦 Download only the script

If you want to download just the script without cloning the full repository:

```bash
curl -O https://raw.githubusercontent.com/smarttecrd/github-deploykey-setup/main/deploykey-setup.sh
chmod +x deploykey-setup.sh
./deploy-key.sh
```

---

## 👋 About

Made with love from the Dominican Republic by **SmartTec**  
Visit us at [smarttec.com.do](https://smarttec.com.do)