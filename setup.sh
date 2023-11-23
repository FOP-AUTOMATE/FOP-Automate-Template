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
        [Yy]* ) break;;
        [Nn]* ) ;;
        * ) echo "Please answer y/n";;
    esac
done

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
        [Yy]* ) break;;
        [Nn]* ) ;;
        * ) echo "Please answer y/n";;
    esac
done

# check if repo exists on github
if gh repo view $REPO_NAME > /dev/null 2>&1; then
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

while true; do

    echo ""
    echo ""
        
    echo ""
    echo "Please enter your student id:"
    read STUDENT_ID

    echo ""
    echo "Please enter your first name:"
    read FIRST_NAME

    echo ""
    echo "Please enter your last name:"
    read LAST_NAME

    echo ""
    echo "Please enter your github username:"
    read GITHUB_USERNAME

    # Save the settings to a file
    echo "STUDENT_ID=$STUDENT_ID"
    echo "FIRST_NAME=$FIRST_NAME"
    echo "LAST_NAME=$LAST_NAME"
    echo "GITHUB_USERNAME=$GITHUB_USERNAME"

    while true; do
        echo "Is this correct? (y/n)"
        read yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) break;;
            * ) echo "Please answer y/n";;
        esac
    done

    case $yn in
        [Yy]* ) break;;
        [Nn]* ) ;;
    esac
done

# Save to settings.properties
echo "# Settings" > settings.properties
echo "" >> settings.properties
echo "STUDENT_ID=$STUDENT_ID" > settings.properties
echo "FIRST_NAME=$FIRST_NAME" >> settings.properties
echo "LAST_NAME=$LAST_NAME" >> settings.properties
echo "GITHUB_USERNAME=$GITHUB_USERNAME" >> settings.properties
echo "" >> settings.properties
echo "PROVIDER_GIT=https://github.com/FOP-2324" >> settings.properties
echo "REPO_PREFIX=TU-" >> settings.properties
echo "REPO_DIR_PREFIX=TU-" >> settings.properties

echo "Saved settings to settings.properties"

git add settings.properties
git commit -m "Added settings.properties"

gh repo create $REPO_NAME --private
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
git push --set-upstream origin main --force

chmod +x create.sh

echo ""
echo ""

echo "Created repository $REPO_NAME on your github account"
echo "See https://github.com/$GITHUB_USERNAME/$REPO_NAME"
