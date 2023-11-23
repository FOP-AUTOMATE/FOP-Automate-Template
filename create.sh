#!/bin/bash

# Git Repository creation script

# Settings

STUDENT_ID={{YOUR_STUDENT_ID}}
FIRST_NAME={{YOUR_FIRST_NAME}}
LAST_NAME={{YOUR_LAST_NAME}}
GITHUB_USERNAME={{YOUR_GITHUB_USER_NAME}}
PROVIDER_GIT=https://github.com/FOP-2324
REPO_PREFIX=TU-
REPO_DIR_PREFIX=TU-

if [ -f "settings.properties" ]; then
    echo "Loading settings from settings.properties..."
    source settings.properties
else
    echo "Settings file not found. Using default settings."
fi

# The repository name
REPO_NAME=$1
MY_REPO_NAME=$REPO_PREFIX$REPO_NAME
REPO_DIR=$REPO_DIR_PREFIX$REPO_NAME
MY_REPO=https://github.com/$GITHUB_USERNAME/$MY_REPO_NAME.git


# Create a new repository
if [ -z "$1" ]; then
    echo "Repository name is required"
    exit 1
fi

# Clone from github
if [ ! -d "$REPO_DIR" ]; then
    git clone $PROVIDER_GIT/$REPO_NAME.git $REPO_DIR
fi

cd $REPO_DIR

# Check if git repository exists (if not, create it) (using gh)
if ! gh repo view $MY_REPO_NAME > /dev/null 2>&1; then
    gh repo create $MY_REPO_NAME --private
    # Mirror the repository
    git push --mirror git@github.com:$GITHUB_USERNAME/$MY_REPO_NAME.git
fi

# If "origin" remote exists and is not the same as the one we want, remove it
if git remote | grep -q origin && [ "$(git remote get-url origin)" != "$MY_REPO" ]; then
    git remote remove origin
fi

# Add "origin" remote
if ! git remote | grep -q origin; then
    git remote add origin $MY_REPO
fi

# Add "from" remote
if ! git remote | grep -q from; then
    git remote add from $PROVIDER_GIT/$REPO_NAME.git
fi

# If .github or workflows directory does not exist, create it
if [ ! -d ".github/workflows" ]; then
    mkdir -p .github/workflows
fi

# Copy workflow template
cp ../build-workflow-template.yml .github/workflows/build.yml

# Add and commit the workflow file if not present or has changes
if ! git ls-files --error-unmatch .github/workflows/build.yml > /dev/null 2>&1 || ! git diff --quiet .github/workflows/build.yml; then
    echo "Workflow file has changed or is not tracked. Adding and committing..."
    git add .github/workflows/build.yml
    git commit -m "Update build workflow"
    git push origin main
else
    echo "Workflow file has not changed"
fi

# Modify build.gradle.kts
if [ -f "build.gradle.kts" ]; then
    echo "Modifying build.gradle.kts..."
    
    # Replace "studentId = null" with "studentId = \"$STUDENT_ID\""
    sed -i '' 's/studentId = null/studentId = "'"$STUDENT_ID"'"/g' build.gradle.kts

    # Replace "firstName = null" with "firstName = \"$FIRST_NAME\""
    sed -i '' 's/firstName = null/firstName = "'"$FIRST_NAME"'"/g' build.gradle.kts

    # Replace "lastName = null" with "lastName = \"$LAST_NAME\""
    sed -i '' 's/lastName = null/lastName = "'"$LAST_NAME"'"/g' build.gradle.kts
    
    # And the workaround for newer versions where the line looks like this:
    # // studentId.set("")
    sed -i '' 's|// studentId.set("")|studentId.set("'"$STUDENT_ID"'")|g' build.gradle.kts
    sed -i '' 's|// firstName.set("")|firstName.set("'"$FIRST_NAME"'")|g' build.gradle.kts
    sed -i '' 's|// lastName.set("")|lastName.set("'"$LAST_NAME"'")|g' build.gradle.kts

    echo "build.gradle.kts modified successfully."
else
    echo "Error: build.gradle.kts not found!"
    exit 1
fi

# Commit and push changes
if ! git diff --quiet build.gradle.kts; then
    echo "build.gradle.kts has changed. Adding and committing..."
    git add build.gradle.kts
    git commit -m "Update student information"
    git push origin main
else
    echo "build.gradle.kts has not changed"
fi

cd ..

# Absorb if we are in a git repository
if [ -d ".git" ]; then
    git submodule add $MY_REPO $REPO_DIR
    git add $REPO_DIR
    git add .gitmodules

    # Check if there are changes to commit
    if ! git diff --quiet; then
        git commit -m "Add submodule $REPO_DIR"
    else
        echo "No changes to commit."
    fi
fi
