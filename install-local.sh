#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
package_name="$(awk -F'"' '/^name[[:space:]]*=/{print $2; exit}' "$repo_root/typst.toml")"
package_version="$(awk -F'"' '/^version[[:space:]]*=/{print $2; exit}' "$repo_root/typst.toml")"

if [[ -z "$package_name" || -z "$package_version" ]]; then
  echo "Could not read package name or version from typst.toml" >&2
  exit 1
fi

typst_data_home="${XDG_DATA_HOME:-$HOME/.local/share}/typst"
target_dir="$typst_data_home/packages/local/$package_name/$package_version"

rm -rf "$target_dir"
mkdir -p "$target_dir"

tar -C "$repo_root" \
  --exclude-vcs \
  --exclude='*.pdf' \
  -cf - . | tar -C "$target_dir" -xf -

echo "Installed $package_name v$package_version to $target_dir"
