Write-Host ""
Write-Host ""
Write-Host "###############################################"
Write-Host "#                                             #"
Write-Host "#  Welcome to the FOP Workspace Setup Script  #"
Write-Host "#                                             #"
Write-Host "###############################################"
Write-Host ""
Write-Host ""

while ($true) {
    Write-Host ""
    Write-Host ""
    $REPO_NAME = Read-Host "How should the repository be named (remotely, on github)?"

    Write-Host ""
    Write-Host ""
    Write-Host "Repository name: $REPO_NAME"
    $confirmation = Read-Host "Is this correct? (y/n)"
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        break
    }
}

while ($true) {
    Write-Host ""
    Write-Host ""
    $REPO_DIR = Read-Host "How should the repository be named (locally, on your computer)?"

    Write-Host ""
    Write-Host ""
    Write-Host "Repository name: $REPO_DIR"
    $confirmation = Read-Host "Is this correct? (y/n)"
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        break
    }
}

# Check if repo exists on github
if (gh repo view $REPO_NAME -q) {
    Write-Host "Repository $REPO_NAME already exists on github. Exiting."
    exit 1
}

# Check if repo exists locally
if (Test-Path $REPO_DIR) {
    Write-Host "Repository $REPO_DIR already exists locally. Exiting."
    exit 1
}

# Clone from github
git clone https://github.com/nsc-de/FOP-Automate-Template.git $REPO_DIR
cd $REPO_DIR
git remote rename origin from

while ($true) {
    Write-Host ""
    Write-Host ""
        
    $STUDENT_ID = Read-Host "Please enter your student id:"
    $FIRST_NAME = Read-Host "Please enter your first name:"
    $LAST_NAME = Read-Host "Please enter your last name:"
    $GITHUB_USERNAME = Read-Host "Please enter your github username:"

    # Save the settings to a file
    Write-Host "STUDENT_ID=$STUDENT_ID"
    Write-Host "FIRST_NAME=$FIRST_NAME"
    Write-Host "LAST_NAME=$LAST_NAME"
    Write-Host "GITHUB_USERNAME=$GITHUB_USERNAME"

    $confirmation = Read-Host "Is this correct? (y/n)"
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        break
    }
}

# Save to settings.properties
@"
# Settings
STUDENT_ID=$STUDENT_ID
FIRST_NAME=$FIRST_NAME
LAST_NAME=$LAST_NAME
GITHUB_USERNAME=$GITHUB_USERNAME
PROVIDER_GIT=https://github.com/FOP-2324
REPO_PREFIX=TU-
REPO_DIR_PREFIX=TU-
"@ | Out-File -FilePath "settings.properties" -Encoding utf8

Write-Host "Saved settings to settings.properties"

git add settings.properties
git commit -m "Added settings.properties"

gh repo create $REPO_NAME --private
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
git push --set-upstream origin main --force

Write-Host ""
Write-Host ""
Write-Host "Created repository $REPO_NAME on your github account"
Write-Host "See https://github.com/$GITHUB_USERNAME/$REPO_NAME"
