@ECHO OFF

:: the suffering I had to endure to make this work was IMMENSE
:: if you're reading this, I'm sorry you're in a place where you
:: believe you need to know how this works

:: I didn't know that :: started a comment until I saw https://stackoverflow.com/questions/11269338/how-to-comment-out-add-comment-in-a-batch-cmd

:: push our current working directory to the stack, so we can return here afterwards
:: this only matters if 1) you're specifically in the cmd shell, 2) invoking this script from another directory, 3) want to return to that directory when this finishes
pushd

:: %~dp0 - https://stackoverflow.com/a/3827582
:: My explanation: %~dp0 is the folder your batch file is sitting in. So if you're in Z:\homedir\batch.cmd then %~dp0 is Z:\homedir
cd %~dp0

:: delete any files that are in this folder, quietly. Protip: never attempt to guess
:: behavior of copy,move,rename,delete operations because none of the behavior makes sense. So
:: test whatever you do. I tested this line below, and got it wrong 5 times before settling here.
:: EDIT: 6 times. https://stackoverflow.com/a/7331075
RD /S /Q .\dist
:: Because batch files don't have a $ErrorActionPreference or 'set -e', I have
:: to check exit codes after every command.
IF %ERRORLEVEL% NEQ 0 GOTO Error

:: Apparently npm is some kind of batch file, not a program, so
:: if I forget to put a 'call' in front, the entire script terminates 
:: after running the command. It's not great.
::
:: What's that? Are you complaining that my build isn't deterministic because I
:: don't commit my package-lock.json? I'm sorry, I can't hear you over
:: the roaring noise of all this success I'm having and the racket from
:: all this rich living I'm doing while not worrying about npm dependencies.
call npm ci
IF %ERRORLEVEL% NEQ 0 GOTO Error

call npm run ci
IF %ERRORLEVEL% NEQ 0 GOTO Error


copy .\static\* .\dist
IF %ERRORLEVEL% NEQ 0 GOTO Error
copy .\dist\bundle.js .\dist\index.js
IF %ERRORLEVEL% NEQ 0 GOTO Error

:: I copied bundle.js to index.js, then deleted bundle.js? Why not rename? Well,
:: because REN makes me sad. I hereby declare that I'm going on strike, until
:: I am provided better working conditions (i.e. conditions not involving
:: invoking REN)
del .\dist\bundle.js
IF %ERRORLEVEL% NEQ 0 GOTO Error

popd

GOTO end

:Error

:: 1>&2 means take the 1 stream (stdout) and redirect it to 2 stream (stderr)
:: the echo command pushes to stdout, so we're saying "send this to stderr instead"
:: this only matters usually if you're running the build in CI, which treats
:: stderr VERY DIFFERENTLY from stdout. As it should!
:: for reference: https://www.robvanderwoude.com/battech_redirection.php

:: I set the color following directions at https://stackoverflow.com/a/38617204
:: - the hardest part was inserting the ^[ control code via CTRL+[, which by the
:: way does not work so great in VS Code, or anywhere else really.
echo ******************************************* 1>&2
echo *                                         * 1>&2
echo *      [91mAn error occurred. See above[0m       * 1>&2
echo *                                         * 1>&2
echo ******************************************* 1>&2

popd
exit /b %ERRORLEVEL%

:: Raymond Chen told me to do this https://devblogs.microsoft.com/oldnewthing/20120802-00/?p=6973
::
:: but seriously, I should use this instead of 'exit 0' inside of a batch file because, when
:: I call this script from deploy.cmd, I want it to continue executing deploy.cmd after finishing this
:: one. If I call exit 0, it will end both batch files.
::
:: It can be said that there is ample room for improvement in batch file scripting.
:end