#!/bin/bash

##########################################################################
# Pterodactyl Installer                                                  #
#                                                                        #
# This script is not associated with the official Pterodactyl Project    #
# Please use at your own risk.                                           #
#                                                                        #
# This script is a complete rework and remake of                         #
# https://github.com/VilhelmPrytz/pterodactyl-installer                  # 
#                                                                        #
# I made a heap of changes to it to suit myself. Then I have decided     #
# to completely rewrite the script in my own what.                       #
#                                                                        #
# For a more stable script, and one that is probably maintained better,  #
# use VilhelmPrytz's script. It also supports multiple operating systems #
# While this one just supports Ubuntu 18.04                              #
#                                                                        #
# If you wish to reuse this script or modify, feel free to do so, just   #
# provide the adaquite credit                                            #
# https://github.com/MrFlacko/                                           #
##########################################################################

# This defines the version of the script. It allows me to easily keep track of it when I'm testing the script from GitHub
Script_Version=0.02

# Some colours that are used throughout the script
LIGHT_RED='\033[1;31m'
RED='\033[0;31m'
LIGHT_BLUE='\033[0;96m'
BLUE='\033[1;34m'
DARK_GRAY='\033[0;37m'
LIGHT_GREEN='\033[1;32m'
NoColor='\033[0m'

# Global Variables
os_version="$(lsb_release -a 2> /dev/null | grep Desc | sed -e 's/.*://' -e 's/^[ \t]*//')"
pterodactyl_version="$(curl --silent "https://api.github.com/repos/pterodactyl/panel/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')"
MemTotal="$(awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | column -t | grep MemTotal | sed -e 's/.*://' -e 's/^[ \t]*//' -e 's/\..*$//')"
MemAvailable="$(awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | column -t | grep MemAvailable | sed -e 's/.*://' -e 's/^[ \t]*//' -e 's/\..*$//')"
Cores="$(lscpu | grep -E '^CPU\(s\):' | sed -e 's/.*[^0-9]\([0-9]\+\)[^0-9]*$/\1/')"
PublicIP="$(wget http://ipecho.net/plain -O - -q ; echo)"
pass=""
FQDN=""
DomainIP=""

# Initial Checks to make sure the script can run
[[ $EUID -ne 0 ]] && echo -e ""$RED"Error: Please run this script with root privileges (sudo)"$NoColor"" && exit 1
[[ -z $(echo $os_version | grep 'Ubuntu 18') ]] && echo -e ""$RED"Error: This script must be ran with Ubuntu 18.04"$NoColor"" && exit 1

# This is the OpeningMessage, it is displayed after the FQDN has been received and shows the user all the information that will need throughout the install
OpeningMessage() {
  echo -e "\n${BLUE}Pterodactyl Installation Script"
  echo -e "${DARK_GRAY}Created by MrFlacko - Inspired by Vilhelmprytz\n"
  echo -e "${LIGHT_GREEN}Hello,"
  echo "This script was designed to quickly run through the Pterodactyl" 
  echo "install with as much ease to the user as possible."
  echo "This script will set the panel with ssl on the machine."
  echo "This screen you see is the system's information, I would copy this down to use"
  echo "throughout the setup, though it is up to you. If you're happy with the information"
  echo "you see on the screen. You can press [Enter] to start the installation."
  echo -e "Best of luck - Flacko \n"
  echo -e "${DARK_GRAY}Pterodactyl Version:${LIGHT_BLUE} $pterodactyl_version"
  echo -e "${DARK_GRAY}Script Version:${LIGHT_BLUE} $Script_Version"
  echo -e "${DARK_GRAY}Ubuntu Version:${LIGHT_BLUE} $os_version"
  echo -e "${DARK_GRAY}Domain:${LIGHT_BLUE} $FQDN"
  echo -e "${DARK_GRAY}Public IP:${LIGHT_BLUE} $PublicIP"
  echo -e "${DARK_GRAY}Domain IP:${LIGHT_BLUE} $DomainIP"
  echo -e "${DARK_GRAY}Available RAM:${LIGHT_BLUE} $MemAvailable${DARK_GRAY}/${LIGHT_BLUE}$MemTotal${DARK_GRAY}MB"
  echo -e "${DARK_GRAY}Cores/Threads Available:${LIGHT_BLUE} $Cores"
  echo ''
  echo -e "${DARK_GRAY}Partitions:"
  lsblk
  echo -e "${NoColor}"
  read
}

# This installs a few programs just to run the correct tests on the system. Mainly for the DomainTester function
TestingDependencies() {
  echo 'Just need to install a few things for testing...'
  sleep 3
  apt update
  apt install -y dnsutils curl wget
  clear
}

# This is a visual loading bar funcation obtained from https://unix.stackexchange.com/questions/415421/linux-how-to-create-simple-progress-bar-in-bash
function loading_bar {
  prog() {
      local w=80 p=$1;  shift
      # create a string of spaces, then change them to dots
      printf -v dots "%*s" "$(( $p*$w/100 ))" ""; dots=${dots// /.};
      # print those dots on a fixed-width space plus the percentage etc. 
      printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
  }
  # test loop
  for x in {1..100} ; do
      prog "$x" 
      sleep .05   # do some work here
  done ; echo
}

# This runs a test on the domain to see if the IP address matches the public IP address of the machine
DomainTester() {
  read -p "Please enter the Fully Qualified Domain Name to be used (EXAMPLE: panel.testserver.com): " FQDN
  DomainIP="$(dig +short $FQDN)"
  [[ "$DomainIP" == "$PublicIP" ]] && return
  echo -e "\n${LIGHT_RED}IMPORTANT${NoColor}"
  echo -e "The Domain IP you entered $DomainIP isn't the same as your public ip $PublicIP"
  echo -e "This script may not work, make sure if you are using cloudflare you are running"
  echo -e "in dns-only mode or you know what you're doing."
  echo -e "Either way the SSL section of the script will fail, then starting NGINX will produce an error"
  echo
  read -p "Ctrl+C to stop the scipt, or you can continue by pressing [Enter]"
  clear
}

# This is where the magic happens. This is the main Pterodactyl Install
Install() {
  clear
  echo -e "\nStarting installation... This might take a while!"
  loading_bar

  ## TO-DO
  ## Everything
}

main() {
  clear
  TestingDependencies

  # User entering in the password that will be used for mysql and other things throughout the install
  echo -e "Please enter the password that is used throughout the install. (Use something strong)"
  while [[ -z "$pass" || ! $pass == $passConfirm ]]
    do
      read -sp "Password: " pass && echo 
      read -sp "Confirm Password: " passConfirm && echo
      [[ -z "$pass" ]] && echo -e "\n"$RED"Error: Password cannot be empty"$NoColor""
      [[ ! $pass == $passConfirm ]] && echo -e ""$RED"Error: Password do not match"$NoColor"\n"
    done
  
  clear
  
  DomainTester
  OpeningMessage
  Install
}

main
