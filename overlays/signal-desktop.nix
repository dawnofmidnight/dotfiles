_final: prev:
prev.signal-desktop.overrideAttrs (prevAttrs: {
  # patch came from https://github.com/signalapp/Signal-Desktop/issues/6368
  patches = prevAttrs.patches ++ [ ./signal-desktop-show-window.patch ];
})
