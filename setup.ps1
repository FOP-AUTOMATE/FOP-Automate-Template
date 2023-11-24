Write-Host ""
Write-Host ""

Write-Host "###############################################"
Write-Host "#                                             #"
Write-Host "#  Welcome to the FOP Workspace Setup Script  #"
Write-Host "#                                             #"
Write-Host "###############################################"
Write-Host ""
Write-Host ""

# Check if REPO_NAME is given as environment variable
if ($env:REPO_NAME) {
    $REPO_NAME = $env:REPO_NAME
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $REPO_NAME = Read-Host "How should the repository be named (remotely, on github)?"

        Write-Host ""
        Write-Host ""

        Write-Host "Repository name: $REPO_NAME"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
    }
}

# Check if REPO_DIR is given as environment variable
if ($env:REPO_DIR) {
    $REPO_DIR = $env:REPO_DIR
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $REPO_DIR = Read-Host "How should the repository be named (locally, on your computer)?"

        Write-Host ""
        Write-Host ""

        Write-Host "Repository name: $REPO_DIR"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
    }
}

# check if repo exists on github
if (gh repo view $REPO_NAME 2>$null) {
    Write-Host "Repository $REPO_NAME already exists on github. Exiting."
    exit 1
}

# check if repo exists locally
if (Test-Path $REPO_DIR -PathType Container) {
    Write-Host "Repository $REPO_DIR already exists locally. Exiting."
    exit 1
}

# Clone from github
git clone https://github.com/nsc-de/FOP-Automate-Template.git $REPO_DIR
cd $REPO_DIR
git remote rename origin from

# Get STUDENT_ID
if ($env:STUDENT_ID) {
    $STUDENT_ID = $env:STUDENT_ID
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $STUDENT_ID = Read-Host "Please enter your student id:"

        Write-Host ""
        Write-Host ""

        Write-Host "Student id: $STUDENT_ID"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
    }
}

# Get FIRST_NAME
if ($env:FIRST_NAME) {
    $FIRST_NAME = $env:FIRST_NAME
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $FIRST_NAME = Read-Host "Please enter your first name:"

        Write-Host ""
        Write-Host ""

        Write-Host "First name: $FIRST_NAME"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
    }
}

# Get LAST_NAME
if ($env:LAST_NAME) {
    $LAST_NAME = $env:LAST_NAME
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $LAST_NAME = Read-Host "Please enter your last name:"

        Write-Host ""
        Write-Host ""

        Write-Host "Last name: $LAST_NAME"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
    }
}

# Get GITHUB_USERNAME
if ($env:GITHUB_USERNAME) {
    $GITHUB_USERNAME = $env:GITHUB_USERNAME
} else {
    while ($true) {
        Write-Host ""
        Write-Host ""
        $GITHUB_USERNAME = Read-Host "Please enter your github username:"

        Write-Host ""
        Write-Host ""

        Write-Host "Github username: $GITHUB_USERNAME"
        $yn = Read-Host "Is this correct? (y/n)"
        switch ($yn.ToLower()) {
            'y' { break }
            'n' { }
            default { Write-Host "Please answer y/n" }
        }
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
"@ | Set-Content -Path "settings.properties"

Write-Host "Saved settings to settings.properties"

git add settings.properties
git commit -m "Added settings.properties"

gh repo create $REPO_NAME --private
git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git

# CI Fix
if ($env:CI) {
    Write-Host "Running in CI environment"

    # Set the Git remote with the GitHub token
    $GITHUB_TOKEN = $env:GITHUB_TOKEN # This assumes you have already exported the token as an environment variable
    git remote set-url origin "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
}

git push --set-upstream origin main --force

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force

Write-Host ""
Write-Host ""

Write-Host "Created repository $REPO_NAME on your github account"
Write-Host "See https://github.com/$GITHUB_USERNAME/$REPO_NAME"
