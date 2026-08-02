#!/usr/bin/env bash

if [[ "${1-}" == "key" && "$#" -eq 1 ]]; then
  echo "ctrl+meta"
  echo "meta+ctrl"
  echo "ctrl+super"
  echo "super+ctrl"

  echo "ctrl+meta+right"
  echo "meta+ctrl+right"
  echo "ctrl+super+right"
  echo "super+ctrl+right"

  echo "ctrl+meta+left"
  echo "meta+ctrl+left"
  echo "ctrl+super+left"
  echo "super+ctrl+left"

  echo "meta+a"
  echo "super+a"

  echo "meta+s"
  echo "super+s"

  echo "ctrl+alt+y"

  exit 0
fi

qdbus() {
  if command -v qdbus6 >/dev/null 2>&1; then
    command -v qdbus6
  elif command -v qdbus >/dev/null 2>&1; then
    command -v qdbus
  else
    return 1
  fi
}

kwin_shortcut() {
  local shortcut="$1"
  local qdbus="$(qdbus)"

  "${qdbus}" \
    org.kde.kglobalaccel \
    /component/kwin \
    org.kde.kglobalaccel.Component.invokeShortcut \
    "${shortcut}"
}

if [[ "${1-}" == "key" && "$#" -ge 2 ]]; then
  combo="${2,,}"

  case "$combo" in
  ctrl+meta | meta+ctrl | ctrl+super | super+ctrl)
    echo "key-local"
    exit 0
    ;;

  ctrl+meta+right | meta+ctrl+right | ctrl+super+right | super+ctrl+right)
    kwin_shortcut "Switch to Next Desktop"
    echo "key-local"
    exit 0
    ;;

  ctrl+meta+left | meta+ctrl+left | ctrl+super+left | super+ctrl+left)
    kwin_shortcut "Switch to Previous Desktop"
    echo "key-local"
    exit 0
    ;;

  meta+a | super+a)
    kwin_shortcut "ExposeAll"
    echo "key-local"
    exit 0
    ;;

  meta+s | super+s)
    kwin_shortcut "Overview"
    echo "key-local"
    exit 0
    ;;

  ctrl+alt+y)
    kwin_shortcut "Overview"
    echo "key-local"
    exit 0
    ;;
  esac
fi

if [[ "${1-}" == "xevent" && "$#" -eq 1 ]]; then
  echo "__disabled__"
  exit 0
fi

exit 1
