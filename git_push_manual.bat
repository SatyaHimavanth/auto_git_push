@echo off
setlocal enabledelayedexpansion

set "installation_paths=C:\Program Files\Git"
set "git_bash_found=false"

for /r "%installation_paths%" %%j in (git-bash.exe) do (
    if exist "%%j" (
        set "git_bash_found=true"
    )
)

if "%git_bash_found%"=="true" (
    echo Git Bash is installed.
    goto :start_gitpush
) else (
    echo Git Bash is not installed.
    goto :no_gitbash
)

:start_gitpush

set current_path=%cd%
for %%i in ("%current_path%") do (
    set current_folder=%%~nxi
)
set repo_name=!current_folder!

:: Enter Git Credentials after "=" without space (manual)
set /p user_name="Enter your github username: "
set /p user_email="Enter your github email id: "

:: Enter Repo name if it is different from current folder name
:ask_condition

set /p condition="Is the github repo same as foldername(y or n): "

if /i "%condition%"=="n" (
    set /p repo_name="Enter Repo name: "
    goto :end
) else if /i "%condition%"=="y" (
    echo The repository name is set to: %repo_name%
    goto :end
) else (
    echo Invalid command
    goto ask_condition
)

:end

git config --global user.name "%user_name%"
git config --global user.email "%user_email%"

git init

git add .

set /p commit_message="Enter your commit message: "
git commit -m "%commit_message%"

git remote remove origin 2>nul

git remote add origin https://github.com/%user_name%/%repo_name%.git


:: Finding the current branch
for /f "delims=" %%b in ('git branch') do (
    echo %%b | findstr /b /c:"* " >nul
    if not errorlevel 1 (
        set "current_branch=%%b"
        set "current_branch=!current_branch:~2!"
    )
)

echo Current branch is: %current_branch%

set future_branch=

:perform_branch_operations

set /p branch_options="Do you want to perform any branch operations (y/n): "

if /i "!branch_options!"=="y" (
    echo Enter 1 to switch to existing branch
    echo Enter 2 to create new branch
    echo Enter 3 to create and switch to new branch
    echo Enter 4 to delete existing branch
    echo Enter 5 to see existing branchs

    set /p branch_operation="Enter your choice: "

    if /i "!branch_operation!"=="1" (

        :branch_option1
        set future_branch=
        set /p future_branch="Enter existing branch name to switch: "

        set "branch_exists=false"

        for /f "delims=" %%b in ('git branch --format="%%(refname:short)"') do (
            if "%%b"=="!future_branch!" (
                set "branch_exists=true"
            )
        )

        if !branch_exists!==true (
            git checkout !future_branch!
            echo branch changed to !future_branch!
        ) else (
            echo Branch !future_branch! does not exist!!

            goto :branch_option1
        )
        goto :end_of_branch_operations

    ) else if /i "!branch_operation!"=="2" (

        :branch_option2
        set future_branch=
        set /p future_branch="Enter new branch name to create: "

        set "branch_exists=false"

        for /f "delims=" %%b in ('git branch --format="%%(refname:short)"') do (
            if "%%b"=="!future_branch!" (
                set "branch_exists=true"
            )
        )

        if !branch_exists!==true (
            echo Branch !future_branch! already exist!!

            goto :branch_option2

        ) else (
            git branch !future_branch!
            echo !future_branch! created
        )
        goto :end_of_branch_operations

    ) else if /i "!branch_operation!"=="3" (

        :branch_option3
        set future_branch=
        set /p future_branch="Enter new branch name to create and switch: "

        set "branch_exists=false"

        for /f "delims=" %%b in ('git branch --format="%%(refname:short)"') do (
            if "%%b"=="!future_branch!" (
                set "branch_exists=true"
            )
        )

        if !branch_exists!==true (
            echo Branch !future_branch! already exist!!

            goto :branch_option3

        ) else (
            git checkout -b !future_branch!
            echo !future_branch! branch created and switched 
        )
        goto :end_of_branch_operations

    ) else if /i "!branch_operation!"=="4" (

        :branch_option4
        set future_branch=
        set /p future_branch="Enter existing branch name to delete: "

        set "branch_exists=false"

        for /f "delims=" %%b in ('git branch --format="%%(refname:short)"') do (
            if "%%b"=="!future_branch!" (
                set "branch_exists=true"
            )
        )

        if !branch_exists!==true (
            git branch -d !future_branch!
            echo !future_branch! deleted
        ) else (
            echo Branch !future_branch! doesnot exist!!

            goto :branch_option4
        )
        goto :end_of_branch_operations

    ) else if /i "!branch_operation!"=="5" (

        :branch_option5
        set future_branch=

        echo Existing branches are:

        for /f "delims=" %%b in ('git branch --format="%%(refname:short)"') do (
            echo %%b
        )

        goto :end_of_branch_operations

    ) else (
            goto :perform_branch_operations
    )

)

:end_of_branch_operations

:: Finding the current branch
for /f "delims=" %%b in ('git branch') do (
    echo %%b | findstr /b /c:"* " >nul
    if not errorlevel 1 (
        set "current_branch=%%b"
        set "current_branch=!current_branch:~2!"
    )
)

echo The changes will be updated in !current_branch! branch

set /p branch_options="Is that all right (y/n): "

if "!branch_options!"=="n" (
    goto :perform_branch_operations
)

git branch -M !current_branch!

git push -u origin !current_branch!

:no_gitbash

endlocal