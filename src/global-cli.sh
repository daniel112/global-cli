#!/bin/bash

ACTIONS=(help onboard)
GLOBAL_CLI_PATH=$HOME/repos/global-cli

source $GLOBAL_CLI_PATH/src/utils/contains_element.sh


global() {
  if [[ -z "$1" ]]; then
    navigate_and_source
    return
  fi

  match=$(contains_element "$1" "${ACTIONS[@]}")

  if [[ $match == "false" ]]; then
    echo "Invalid argument $1"
    echo "The accepted argument must be one of: ${ACTIONS[@]}"
    return
  fi

  # execute the command, cmd must match the function name
  # pass the rest of the params down (if exists)
  $1 "${@:2}"
}

# navigate to this repo and re-source this script file
navigate_and_source() {
  echo "Moving to $GLOBAL_CLI_PATH"
  cd $GLOBAL_CLI_PATH
  source $GLOBAL_CLI_PATH/src/global-cli.sh
  echo "global-cli sourced."
}

onboard() {
  echo "-------start onboarding install process--------"
  echo "-----Checking for brew-----"
  verify_brew

  echo "-----Checking for firebase cli-----"
  verify_firebase_cli

  echo "-----Checking for cocoapods-----"
  verify_cocoapods
  # echo "-----Checking for ruby version-----"
  # verify_ruby_version

  echo "-----Checking node version-----"
  verify_node_version

  echo "-----Checking for fastlane-----"
  verify_fastlane

  echo "DONE!"
}

verify_cocoapods() {
local TEXT_RESULT=$(which pod)
  if [[ -z $TEXT_RESULT  || $TEXT_RESULT =~ "not found" ]]; then
    echo "cocoapod not found, installing..."
    sudo gem install cocoapods
  fi

  echo "\Cocoapod is installed"
  pod --version
}

verify_fastlane() {
  local TEXT_RESULT=$(which fastlane)
  if [[ -z $TEXT_RESULT  || $TEXT_RESULT =~ "not found" ]]; then
    echo "fastlane not found, installing..."
    brew install fastlane
  fi

  echo "\nFastlane is installed"
  fastlane --version
}

verify_brew() {
  local TEXT_RESULT=$(which brew)
  if [[ -z $TEXT_RESULT  || $TEXT_RESULT =~ "not found" ]]; then
    echo "brew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

verify_node_version() {
  local NODE_RESULT=$(which node)
  if [[ -z $NODE_RESULT  || $NODE_RESULT =~ "not found" ]]; then
    echo "node not found, installing..."
    brew install node
    echo "---install nvm---"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zprofile
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.zprofile
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> $HOME/.zprofile
    source $HOME/.zprofile
  fi

  echo "\nNode and nvm is installed"
  local NODE_VERSION=$(node -v)
  echo "Current Node Version:$NODE_VERSION\n"
  
}

# verify/install firebase cli if needed (only used for staging distribution)
verify_firebase_cli() {
  local TEXT_RESULT=$(which firebase)
  if [[ -z $TEXT_RESULT  || $TEXT_RESULT =~ "not found" ]]; then
    echo "Firebase CLI not found, installing..."
    curl -sL https://firebase.tools | bash
  fi

  echo "\nFirebase CLI is installed"
  local VERSION=$(firebase --version)
  echo "Current Firebase CLI Version:$VERSION\n"
}

# bugs exist for apple silicon rvm install
# verify_ruby_version() {

#   local RVM_RESULT=$(which rvm)
#   if [[ -z $RVM_RESULT  || $RVM_RESULT =~ "not found" ]]; then
#     echo "Ruby version manager (rvm) not found, installing..."
#     curl -sSL https://get.rvm.io | bash -s stable --ruby
#     echo "source $HOME/.rvm/scripts/rvm" >> $HOME/.zprofile
#     source $HOME/.rvm/scripts/rvm
#   fi

#   # Some rvm version install is not supported on apple silicon
#   local RUBY_RESULT=$(rvm use 2.6.4)
#   if [[ $RUBY_RESULT == *"rvm install"* ]]; then
#     echo "version not found, installing..."
#     rvm install "ruby-2.6.4"
#   fi

#   rvm use 2.6.4
# }