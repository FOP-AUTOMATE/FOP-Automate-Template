# Automating the hell out of FOP using github actions

_I got tired of cloning the git repositories manually. It took me nearly one minute a time. So i took a few hours and automated it._

## Prerequisites

**This is based on a shell script and therefore will not work with windows. It is tested with mac and should work with linux as well**

You need a github account (https://github.com/) and in best case the github education pack (https://education.github.com/pack)
(We wan't to run workflows on private repositories, so github for education makes sence)

Also you need to install gh client (https://github.com/cli/cli#installation)

We use it to automatically create the repository (even less work, lazy sock 😉)

## _"Installation"_

- Clone the repository
- Open it with the text editor of your choice. In line 7-10 you wan't to change the information to match your information
  
  e.g.
  
  ```sh
  STUDENT_ID=hp81pfui
  FIRST_NAME=Harry
  LAST_NAME=Potter
  GITHUB_USERNAME=harry-potter
  ```

- Now we need to make the script executable:
  
  ```sh
  chmod +x create.sh
  ```

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

After committing and pushing to GitHub _(origin)_, you will find the release on your github repo's site
_it will take about a minute to build the submission_, be patient.

<img width="1405" alt="image" src="https://user-images.githubusercontent.com/64435955/285269979-b727ae67-c181-47aa-a4d1-11731691d1f7.png">

Click on the latest release and under `assets` download the jar. Note that after a push it will take about a minute for the
release to show up.

## Technical

The local repository has to remotes registered, `origin` and `from`. In case you need to Merge changes done to the exercise
after you cloned it, you can do this via the from origin.

Also note that the github action will create a release for every commit pushed.
