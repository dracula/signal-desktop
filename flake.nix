{
  description = "dracula theme for signal";

  inputs = {
  };

  outputs = { self, nixpkgs }: {

    overlays = f: p: {
       signal-desktop = let 
         style = ./themes.css;
	 name = "signal-desktop-dracula";
	 version = p.signal-desktop.version;
	 src = p.signal-destkop.src;
	 asarSource = "share/signal-desktop/app.asar";
	 styleSource = "stylesheets/manifest.css";
       in {
         inherit name version src;
	 nativeBuildInputs = with pkgs; [
	    makeWrapper
	    asar
         ];
	 installPhase = ''
	   cp -r ${prev.signal-desktop}/share $out
	   asar e $out/${asarSource} $out/share/temp
	   rm ${asarSource}
	   sed -i "1i @import \"${style}\";" "$out/share/temp/${styleSource}"
	   asar p $out/share/temp ${asarSource}
	   makeWrapper '${lib.getExe prev.electron_39}' "$out/bin/signal-desktop" \
	     --add-flags "$out/app_custom.asar" \
             --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
             --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
	'';
	desktopItems = [
    (pkgs.makeDesktopItem {
      name = "signal";
      desktopName = "Signal";
      exec = "signal-desktop %U";
      type = "Application";
      terminal = false;
      icon = "signal-desktop";
      comment = "Private messaging from your desktop";
      startupWMClass = "signal";
      mimeTypes = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
    })
  ];


       };
    };
    
  };
}
