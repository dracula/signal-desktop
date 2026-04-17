### [Signal desktop](https://signal.org)

#### Install using Git

If you are a git user, you can install the theme and keep up to date by cloning the repo:

```bash
git clone https://github.com/dracula/signal-desktop.git
```

The stylesheet you need is at [`sample/themes.css`](sample/themes.css).

#### Install manually

Download using the [GitHub `.zip` download](https://github.com/dracula/signal-desktop/archive/main.zip) option and unzip it. Copy `sample/themes.css` from the archive.

#### Activating theme

##### Windows

1. Install [7-Zip](https://www.7-zip.org/) and its asar7z plugin.
2. Open `C:\Users\user_name\AppData\Local\Programs\signal-desktop\resources\app.asar` with 7-Zip.
3. Go into the `stylesheets` directory.
4. Copy `themes.css` into that directory (use the file from `sample/themes.css` in this repository, named `themes.css` next to the other stylesheets).
5. Edit `manifest.css` and add this import at the top: `@import "themes.css";`
6. Save, close your editor, and restart Signal if it is running.

##### Linux (Nix flake)

Add the input:

```nix
dracula.url = "github:dracula/signal-desktop";
```

Add overlays:

```nix
overlays = [
  inputs.dracula.overlays
];
```

Use your NixOS or Home Manager integration for `signal-desktop` as usual with the overlaid package.

##### Linux (other)

Install `@electron/asar` from npm, for example:

```bash
npm install -g @electron/asar
```

Set variables (adjust `SIGNAL_DIR` for your install or Flatpak layout):

```bash
TEMP=$(mktemp -d)
SIGNAL_DIR="/usr/lib/signal-desktop/resources"
```

> [!NOTE]
> If you use the Flatpak version, try:
>
> `SIGNAL_DIR="/var/lib/flatpak/app/org.signal.Signal/current/active/files/Signal/resources"`

Extract the asar into the temporary directory:

```bash
asar e "${SIGNAL_DIR}/app.asar" "${TEMP}"
```

Download the theme file into the unpacked stylesheets folder:

```bash
curl -fsSL "https://raw.githubusercontent.com/dracula/signal-desktop/main/sample/themes.css" -o "${TEMP}/stylesheets/themes.css"
```

Add the import at the start of `manifest.css`:

```bash
sed -i "1i @import \"themes.css\";" "${TEMP}/stylesheets/manifest.css"
```

Repack `app.asar` (you may need `sudo` to write under `/usr/lib`):

```bash
sudo asar p "${TEMP}" "${SIGNAL_DIR}/app.asar"
```
