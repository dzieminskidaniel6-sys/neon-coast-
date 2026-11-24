#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v python >/dev/null 2>&1; then
  echo "Python is not installed. Install it with: sudo pacman -S python python-pip"
  exit 1
fi
if [ ! -d .venv ]; then
  python -m venv .venv
fi
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
exec python main.py
