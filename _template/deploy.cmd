@ECHO OFF

:: for an illuminated manuscript, see build.cmd. I don't have
:: the energy to comment this one; just going to make the magic happen.

echo *******************************************
echo *                                         *
echo *   [91mNOTE: this only works for me, Peter[0m   *
echo *                                         *
echo *******************************************

pushd

cd %~dp0

call build.cmd
IF %ERRORLEVEL% NEQ 0 GOTO Error


:: hope the files are there to copy
:: hope I never need to delete files, because this doesn't delete anything
:: hope I put that repo there, and it's still named that
:: hope I have file permissions and they're not locked
:: hope I don't have pending changes from elsewhere
:: hope I'm in the master branch
:: hope I can push
copy .\dist\* ..\..\pseale.github.io\_template
IF %ERRORLEVEL% NEQ 0 GOTO Error
cd ..\..\pseale.github.io\_template
IF %ERRORLEVEL% NEQ 0 GOTO Error

:: we don't care if git complains that we're already on master branch
:: hope git didn't error for ANY OTHER REASON
git checkout master

git add -A
IF %ERRORLEVEL% NEQ 0 GOTO Error
git commit -m "publish /"
IF %ERRORLEVEL% NEQ 0 GOTO Error
git push
IF %ERRORLEVEL% NEQ 0 GOTO Error

popd

GOTO end


:Error

echo ******************************************* 1>&2
echo *                                         * 1>&2
echo *      [91mAn error occurred. See above[0m       * 1>&2
echo *                                         * 1>&2
echo ******************************************* 1>&2

popd

exit /b 1


:end
