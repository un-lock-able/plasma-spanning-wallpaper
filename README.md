# Plasma Spanning Wallpaper

A Plasma 6 wallpaper plugin that spans one wide image across multiple
monitors, instead of showing the same full image on every screen.

## How it works

1. The plugin reads the virtual geometry of every monitor and computes the
   bounding box that contains all of them (e.g. two 1920x1080 monitors side
   by side give a 3840x1080 box).
2. Your source image is **scaled up** just enough to fully cover that box
   while keeping its aspect ratio, then **center-cropped**: any leftover
   width or height is trimmed evenly from both edges.
3. Each monitor then shows only the slice of that scaled, cropped image that
   falls within its own position in the bounding box — so the picture reads
   as one continuous scene across all your screens.

Because the crop is centered, you can control framing yourself by
pre-cropping the source image to roughly match your combined monitors'
aspect ratio before using it — the plugin will have little or nothing left
to crop. If the image's aspect ratio doesn't match, it still works, but the
plugin (not you) decides what gets trimmed off each edge.

## Install / uninstall

```bash
./install.sh install     # installs the plugin, or upgrades it if already installed
./install.sh uninstall   # removes it
./install.sh status      # reports whether it's currently installed
```

After installing, set it on **each** monitor: right-click the desktop →
"Configure Desktop and Wallpaper" → change the wallpaper type to
"Spanning Wallpaper" → pick the same source image on every monitor.

After editing the plugin's source, just run `./install.sh install` again to
pick up the changes (it upgrades in place).

## License

GPLv2+. See [LICENSE](LICENSE).
