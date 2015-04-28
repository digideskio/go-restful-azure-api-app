@ECHO off

IF DEFINED WEBROOT_PATH (
    ECHO WEBROOT_PATH is %WEBROOT_PATH%
    GOTO :SETUP
)

ECHO set WEBROOT_PATH to D:\home\site\wwwroot
SET WEBROOT_PATH=D:\home\site\wwwroot

:SETUP
SET GOROOT=D:\Program Files\go\1.4.2
SET GOPATH=%WEBROOT_PATH%\gopath
SET GOEXE="%GOROOT%\bin\go.exe"
SET FOLDERNAME=azureapp
SET GOAZUREAPP=%WEBROOT_PATH%\gopath\src\%FOLDERNAME%

IF EXIST %GOPATH% (
    ECHO %GOPATH% already exist
    
    ECHO Removing %GOAZUREAPP%
    RMDIR /S /Q %GOAZUREAPP%
) else (
    ECHO creating %GOPATH%\bin
    MKDIR "%GOPATH%\bin"
    ECHO creating %GOPATH%\pkg
    MKDIR "%GOPATH%\pkg"
    ECHO creating %GOPATH%\src
    MKDIR "%GOPATH%\src"
)

ECHO creating %GOAZUREAPP%
MKDIR %GOAZUREAPP%

ECHO --------------------------------------------
ECHO GOROOT: %GOROOT%
ECHO GOEXE: %GOEXE%
ECHO GOPATH: %GOPATH%
ECHO GOAZUREAPP: %GOAZUREAPP%
ECHO --------------------------------------------
ECHO copying source code to %GOAZUREAPP%

CP error.go %GOAZUREAPP%
CP handlers.go %GOAZUREAPP%
CP logger.go %GOAZUREAPP%
CP main.go %GOAZUREAPP%
CP repo.go %GOAZUREAPP%
CP router.go %GOAZUREAPP%
CP routes.go %GOAZUREAPP%
CP todo.go %GOAZUREAPP%

ECHO copying resources to WEBROOT_PATH
CP %DEPLOYMENT_SOURCE%\Web.Config %WEBROOT_PATH%\Web.Config -f
CP %DEPLOYMENT_SOURCE%\apiapp.json %WEBROOT_PATH%\apiapp.json

IF EXIST "%WEBROOT_PATH%\metadata" (
    ECHO Removing "%WEBROOT_PATH%\metadata"
    RMDIR /S /Q "%WEBROOT_PATH%\metadata"
) 

ECHO creating "%WEBROOT_PATH%\metadata"
MKDIR "%WEBROOT_PATH%\metadata"

CP %DEPLOYMENT_SOURCE%\metadata\apiDefinition.swagger.json %WEBROOT_PATH%\metadata\apiDefinition.swagger.json -f

ECHO Resolving dependencies
CD "%GOPATH%\src"
%GOEXE% get %FOLDERNAME%

ECHO Building ...
%GOEXE% build -o %WEBROOT_PATH%\%FOLDERNAME%.exe %FOLDERNAME%

ECHO cleaning up ...
CD %WEBROOT_PATH%
RMDIR /S /Q %GOPATH%

ECHO DONE!