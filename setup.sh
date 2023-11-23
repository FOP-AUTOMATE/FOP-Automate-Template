#!/bin/bash

while true; do
        
    echo "Please enter your student id:"
    read STUDENT_ID

    echo "Please enter your first name:"
    read FIRST_NAME

    echo "Please enter your last name:"
    read LAST_NAME

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


