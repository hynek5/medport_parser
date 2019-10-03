#!/bin/bash
which pdftotext 2>/dev/null
if [ $? != 0 ] || [ "$1" == "-f" ]; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null ; brew install caskroom/cask/brew-cask 2> /dev/null
  brew cask install pdftotext
else
  echo "pdftotext is installed, exiting."
  echo "run with parameter -f to force installation"
  exit 0
fi
