# Automating the hell out of FOP using github actions

_I got tired of cloning the git repositories manually. It took me nearly one minute a time. So i took a few hours and automated it._


## Prerequisites

You need a github account (https://github.com/) and in best case the github education pack (https://education.github.com/pack)
(We wan't to run workflows on private repositories, so github for education makes sence)

Also you need to install gh client (https://github.com/cli/cli#installation)

We use it to automatically create the repository (even less work, lazy sock 😉)


## "Installation"

The `create.sh` needs to be placed inside of a folder. 

Open it with the text editor of your choice. In line 7 you wan't to change the {INSERT_YOUR_GITHUB_USERNAME_HERE} to your github user name.

Now we need to make the script executable:

```sh
chmod +x create.sh
```

## Additional
In this gist we also provide a build workflow. This workflow automatically builds the submission using github actions. 
So if you commit and push changes to github, it automatically builds them. It creates a new release on your repository. 
So you can just download the submission. Even less work 💪

To use this you just need to put the `build-workflow-template.yml` file into the same directory as the `create.sh` file

You will find the release on your github repo's site

<img width="1405" alt="image" src="https://user-images.githubusercontent.com/64435955/285269979-b727ae67-c181-47aa-a4d1-11731691d1f7.png">

Click on the latest release and under `assets` download the jar. Note that after a push it will take about a minute for the 
release to show up.

## Usage
From the terminal we just type

```sh
./create.sh [Exercise]
```

e.g.
```sh
./create.sh FOP-2324-H00-Student
```

The git repository wil be created as `TU-FOP-2324-H00-Student` in this case and locally will be put inside 
`TU-FOP-2324-H00-Student` (You can change the prefix `TU-` inside the settings section of the create.sh file)

Now just import the local repository using IntelliJ


## Technical
The local repository has to remotes registered, `origin` and `from`. In case you need to Merge changes done to the exercise
after you cloned it, you can do this via the from origin.
