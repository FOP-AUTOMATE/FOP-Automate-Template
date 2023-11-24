#!/bin/bash

echo ""
echo ""

echo "###############################################"
echo "#                                             #"
echo "#  Welcome to the FOP Workspace Setup Script  #"
echo "#                                             #"
echo "###############################################"
echo ""
echo ""

# Check if REPO_NAME is given as environment variable

if [[ -n "$REPO_NAME" ]]; then
  REPO_NAME=$REPO_NAME
else

  while true; do
    echo ""
    echo ""
    echo "How should the repository be named (remotely, on github)?"
    read REPO_NAME

    echo ""
    echo ""

    echo "Repository name: $REPO_NAME"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# Check if REPO_DIR is given as environment variable

if [[ -n "$REPO_DIR" ]]; then
  REPO_DIR=$REPO_DIR
else
  while true; do
    echo ""
    echo ""
    echo "How should the repository be named (locally, on your computer)?"

    read REPO_DIR

    echo ""
    echo ""

    echo "Repository name: $REPO_DIR"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# check if repo exists on github
if gh repo view $REPO_NAME >/dev/null 2>&1; then
  echo "Repository $REPO_NAME already exists on github. Exiting."
  exit 1
fi

# check if repo exists locally
if [ -d $REPO_DIR ]; then
  echo "Repository $REPO_DIR already exists locally. Exiting."
  exit 1
fi

# Clone from github
git clone https://github.com/nsc-de/FOP-Automate-Template.git $REPO_DIR
cd $REPO_DIR
git remote rename origin from

# Get STUDENT_ID

if [[ -n "$STUDENT_ID" ]]; then
  STUDENT_ID=$STUDENT_ID
else
  while true; do
    echo ""
    echo ""
    echo "Please enter your student id:"
    read STUDENT_ID

    echo ""
    echo ""

    echo "Student id: $STUDENT_ID"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# Get FIRST_NAME

if [[ -n "$FIRST_NAME" ]]; then
  FIRST_NAME=$FIRST_NAME
else
  while true; do
    echo ""
    echo ""
    echo "Please enter your first name:"
    read FIRST_NAME

    echo ""
    echo ""

    echo "First name: $FIRST_NAME"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# Get LAST_NAME

if [[ -n "$LAST_NAME" ]]; then
  LAST_NAME=$LAST_NAME
else
  while true; do
    echo ""
    echo ""
    echo "Please enter your last name:"
    read LAST_NAME

    echo ""
    echo ""

    echo "Last name: $LAST_NAME"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# Get GITHUB_USERNAME

if [[ -n "$GITHUB_USERNAME" ]]; then
  GITHUB_USERNAME=$GITHUB_USERNAME
else
  while true; do
    echo ""
    echo ""
    echo "Please enter your github username:"
    read GITHUB_USERNAME

    echo ""
    echo ""

    echo "Github username: $GITHUB_USERNAME"
    echo "Is this correct? (y/n)"
    read yn
    case $yn in
    [Yy]*) break ;;
    [Nn]*) ;;
    *) echo "Please answer y/n" ;;
    esac
  done
fi

# Save to settings.properties
echo "# Settings" >settings.properties
echo "" >>settings.properties
echo "STUDENT_ID=$STUDENT_ID" >settings.properties
echo "FIRST_NAME=$FIRST_NAME" >>settings.properties
echo "LAST_NAME=$LAST_NAME" >>settings.properties
echo "GITHUB_USERNAME=$GITHUB_USERNAME" >>settings.properties
echo "" >>settings.properties
echo "PROVIDER_GIT=https://github.com/FOP-2324" >>settings.properties
echo "REPO_PREFIX=TU-" >>settings.properties
echo "REPO_DIR_PREFIX=TU-" >>settings.properties

echo "Saved settings to settings.properties"

git add settings.properties
git commit -m "Added settings.properties"

gh repo create $REPO_NAME --private
echo "Waiting 5 seconds for github to create the repository"
sleep 5
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# CI Fix
if [[ -n "$CI" ]]; then
  echo "Running in CI environment"

  # Set the Git remote with the GitHub token
  GITHUB_TOKEN=$GITHUB_TOKEN # This assumes you have already exported the token as an environment variable
  git remote set-url origin "https://${GITHUB_TOKEN}@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
else
  echo "Not running in CI environment"
fi

git push --set-upstream origin main --force

chmod +x create.sh

echo ""
echo ""

echo "Created repository $REPO_NAME on your github account"
echo "See https://github.com/$GITHUB_USERNAME/$REPO_NAME"
