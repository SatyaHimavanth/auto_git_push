@echo off
setlocal enabledelayedexpansion

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
        echo !branch_exists!

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
        echo !branch_exists!

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
        echo !branch_exists!

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
        echo !branch_exists!

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