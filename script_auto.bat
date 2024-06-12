@echo off

:: Enable delayed expansion
setlocal enabledelayedexpansion

:: Enter Git Credentials after "=" without space
::Example
::set user_name=your_github_username
::set user_email=your_email@example.com
set user_name=
set user_email=

:: Enter Repo name
::set repo_name=your_repo_name
set repo_name=

:: Git login
git config --global user.name "%user_name%"
git config --global user.email "%user_email%"

:: Initialize a Git repository
git init

:: Add all files to the repository
git add .

:: Commit the changes
set /p commit_message="Enter your commit message: "
git commit -m "%commit_message%"

:: Remove existing remote origin if it exists
git remote remove origin 2>nul

:: Add the remote repository
git remote add origin https://github.com/%user_name%/%repo_name%.git

:: Set the branch to main
git branch -M main

:: Push the commits to the remote repository
git push -u origin main