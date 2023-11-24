# Git Repository creation script

# Settings
$STUDENT_ID="{{YOUR_STUDENT_ID}}"
$FIRST_NAME="{{YOUR_FIRST_NAME}}"
$LAST_NAME="{{YOUR_LAST_NAME}}"
$GITHUB_USERNAME="{{YOUR_GITHUB_USER_NAME}}"
$PROVIDER_GIT="https://github.com/FOP-2324"
$REPO_PREFIX="TU-"
$REPO_DIR_PREFIX="TU-"

# Function to read properties file and set variables
function Read-PropertiesFileAndSetVariables {
    param (
        [string]$FilePath
    )

    # Read the content of the properties file
    $propertiesContent = Get-Content -Path $FilePath

    # Iterate through each line in the file
    foreach ($line in $propertiesContent) {
        # Skip comment lines (lines starting with #)
        if ($line -notmatch '^\s*#') {
            # Check if the line contains the '=' character
            if ($line -match '=') {
                # Split the line into key and value using the '=' character
                $key, $value = $line -split '=', 2

                # Remove leading and trailing whitespaces from key and value
                $key = $key.Trim()
                $value = $value.Trim()

                # Set variable in the local scope
                Set-Variable -Name $key -Value $value -Scope Script
            }
            else {
                Write-Host "Invalid line in properties file: $line"
            }
        }
    }
}

# Git Repository creation script

# Settings file path
$SettingsFilePath = ".\settings.properties"

if (Test-Path $SettingsFilePath) {       
    # Load settings from properties file
    Read-PropertiesFileAndSetVariables -FilePath $SettingsFilePath
}

# The repository name
$REPO_NAME = $args[0]
$MY_REPO_NAME = $REPO_PREFIX + $REPO_NAME
$REPO_DIR = $REPO_DIR_PREFIX + $REPO_NAME
$MY_REPO = "https://github.com/$GITHUB_USERNAME/$MY_REPO_NAME.git"

# CI Fix
if ($env:CI) {
    Write-Host "Running in CI environment"

    # Set the Git remote with the GitHub token
    $GITHUB_TOKEN = $env:GITHUB_TOKEN  # This assumes you have already exported the token as an environment variable
    $MY_REPO = "https://$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$MY_REPO_NAME.git"
}

# Create a new repository
if (-not $REPO_NAME) {
    Write-Host "Repository name is required"
    exit 1
}

# Clone from GitHub
if (-not (Test-Path $REPO_DIR)) {
    git clone "$PROVIDER_GIT/$REPO_NAME.git" $REPO_DIR
}

cd $REPO_DIR

# If "origin" remote exists and is not the same as the one we want, remove it
if ((git remote | Select-String -Pattern 'origin' -Quiet) -and ((git remote get-url origin) -ne $MY_REPO)) {
    git remote remove origin
}

# Add "origin" remote
if (-not (git remote | Select-String -Pattern 'origin' -Quiet)) {
    git remote add origin $MY_REPO
}

# Add "from" remote
if (-not (git remote | Select-String -Pattern 'from' -Quiet)) {
    git remote add from "$PROVIDER_GIT/$REPO_NAME.git"
}

# Check if git repository exists (if not, create it) (using gh)
if (-not (gh repo view $MY_REPO_NAME)) {
    gh repo create $MY_REPO_NAME --private
    # Mirror the repository
    git push --mirror
}

# If .github or workflows directory does not exist, create it
if (-not (Test-Path ".\github\workflows")) {
    New-Item -ItemType Directory -Path ".\github\workflows" | Out-Null
}

# Copy workflow template
Copy-Item "..\build-workflow-template.yml" -Destination ".\github\workflows\build.yml" -Force

# Add and commit the workflow file if not present or has changes
if ((-not (git ls-files --error-unmatch ".\github\workflows\build.yml" -Quiet)) -or (-not (git diff --quiet ".\github\workflows\build.yml"))) {
    Write-Host "Workflow file has changed or is not tracked. Adding and committing..."
    git add ".\github\workflows\build.yml"
    git commit -m "Update build workflow"
    git push origin main
} else {
    Write-Host "Workflow file has not changed"
}

# Modify build.gradle.kts
if (Test-Path "build.gradle.kts") {
    Write-Host "Modifying build.gradle.kts..."

    $OS = $env:OS

    # Set the sed command based on the operating system
    if ($OS -eq "Darwin") {

        # Replace "studentId = null" with "studentId = \"$STUDENT_ID\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'studentId = null', "studentId = ""$STUDENT_ID"""} | Set-Content "build.gradle.kts"

        # Replace "firstName = null" with "firstName = \"$FIRST_NAME\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'firstName = null', "firstName = ""$FIRST_NAME"""} | Set-Content "build.gradle.kts"

        # Replace "lastName = null" with "lastName = \"$LAST_NAME\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'lastName = null', "lastName = ""$LAST_NAME"""} | Set-Content "build.gradle.kts"

        # And the workaround for newer versions where the line looks like this:
        # // studentId.set("")
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// studentId.set("")', "studentId.set(""\""$STUDENT_ID""\"")"} | Set-Content "build.gradle.kts"
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// firstName.set("")', "firstName.set(""\""$FIRST_NAME""\"")"} | Set-Content "build.gradle.kts"
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// lastName.set("")', "lastName.set(""\""$LAST_NAME""\"")"} | Set-Content "build.gradle.kts"

    } else {

        # Replace "studentId = null" with "studentId = \"$STUDENT_ID\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'studentId = null', "studentId = ""$STUDENT_ID"""} | Set-Content "build.gradle.kts"

        # Replace "firstName = null" with "firstName = \"$FIRST_NAME\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'firstName = null', "firstName = ""$FIRST_NAME"""} | Set-Content "build.gradle.kts"

        # Replace "lastName = null" with "lastName = \"$LAST_NAME\""
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace 'lastName = null', "lastName = ""$LAST_NAME"""} | Set-Content "build.gradle.kts"

        # And the workaround for newer versions where the line looks like this:
        # // studentId.set("")
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// studentId.set("")', "studentId.set(""\""$STUDENT_ID""\"")"} | Set-Content "build.gradle.kts"
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// firstName.set("")', "firstName.set(""\""$FIRST_NAME""\"")"} | Set-Content "build.gradle.kts"
        (Get-Content "build.gradle.kts") | ForEach-Object {$_ -replace '// lastName.set("")', "lastName.set(""\""$LAST_NAME""\"")"} | Set-Content "build.gradle.kts"

    }

    Write-Host "build.gradle.kts modified successfully."
} else {
    Write-Host "Error: build.gradle.kts not found!"
    exit 1
}

# Commit and push changes
if ((-not (git diff --quiet "build.gradle.kts"))) {
    Write-Host "build.gradle.kts has changed. Adding and committing..."
    git add "build.gradle.kts"
    git commit -m "Update student information"
    git push origin main
} else {
    Write-Host "build.gradle.kts has not changed"
}

cd ..

# Absorb if we are in a git repository
if (Test-Path ".git") {
    git submodule add $MY_REPO $REPO_DIR
    git add $REPO_DIR
    git add ".gitmodules"

    # Check if there are changes to commit
    if ((-not (git diff --quiet))) {
        git commit -m "Add submodule $REPO_DIR"
    } else {
        Write-Host "No changes to commit."
    }
}
