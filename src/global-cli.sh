#!/bin/bash
source ./src/utils/contains_element.sh

ACTIONS=(help onboard)
GLOBAL_CLI_PATH=$HOME/repos/global-cli


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

  echo "-----Checking for ruby version-----"
  verify_ruby_version

  echo "-----Checking node version-----"
  verify_node_version

  echo "-----Checking for fastlane-----"
  verify_fastlane

  echo "DONE!"
}

verify_fastlane() {
  local TEXT_RESULT=$(which fastlane)
  if [[ -z $TEXT_RESULT ]]; then
    echo "fastlane not found, installing..."
    brew install fastlane
  fi
}

verify_brew() {
  local TEXT_RESULT=$(which brew)
  if [[ -z $TEXT_RESULT ]]; then
    echo "brew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"  
  fi
}

verify_node_version() {
  local NODE_RESULT=$(which node)
  if [[ -z $NODE_RESULT ]]; then
    echo "node not found, installing..."
    brew install node
    echo "install nvm"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  fi

  local NVM_RESULT=$(nvm use 16.13.1)
  if [[ $NVM_RESULT == *"nvm install"* ]]; then
    echo "version not found, installing..."
    nvm install "16.13.1"
  fi

  nvm use 16.13.1
}

verify_ruby_version() {

  local RVM_RESULT=$(which rvm)
  if [[ -z $RVM_RESULT ]]; then
    echo "Ruby version manager (rvm) not found, installing..."
    curl -sSL https://get.rvm.io | bash -s stable --ruby
  fi

  local RUBY_RESULT=$(rvm use 2.6.4)
  if [[ $TEXT_RESULT == *"rvm install"* ]]; then
    echo "version not found, installing..."
    rvm install "ruby-2.6.4"
  fi

  rvm use 2.6.4
}

# verify/install firebase cli if needed (only used for staging distribution)
verify_firebase_cli() {
  local TEXT_RESULT=$(which firebase)
  if [[ -z $TEXT_RESULT ]]; then
    echo "Firebase CLI not found, installing..."
    curl -sL https://firebase.tools | bash
  fi
}