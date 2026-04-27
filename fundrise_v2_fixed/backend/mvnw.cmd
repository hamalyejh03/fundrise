@REM ----------------------------------------------------------------------------
@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM    http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@REM ----------------------------------------------------------------------------

@REM ----------------------------------------------------------------------------
@REM Apache Maven Wrapper startup batch script, version 3.2.0
@REM
@REM Optional ENV vars
@REM JAVA_HOME - location of a JDK home dir, required when JAVA is not on PATH
@REM MVNW_REPOURL - repo to use for downloading maven distribution
@REM MVNW_USERNAME / MVNW_PASSWORD - credentials for downloading maven
@REM MVNW_VERBOSE - true: enable verbose log; others: silent
@REM ----------------------------------------------------------------------------

@IF "%__MVNW_ARG0_NAME__%"=="" (SET "__MVNW_ARG0_NAME__=%~nx0")
@SET __MVNW_CMD__=
@SET __MVNW_ERROR__=
@SET __MVNW_SAVE_ERRORLEVEL__=
@SET __MVNW_SAVE_CD__=

@SETLOCAL

@SET DIRNAME=%~dp0
@IF "%DIRNAME%"=="" SET DIRNAME=.
@SET APP_BASE_NAME=%~n0
@SET APP_HOME=%DIRNAME%

@REM Resolve any "." and ".." in APP_HOME to make it shorter.
@FOR /F "delims=" %%i IN ("%APP_HOME%") DO @SET APP_HOME=%%~fi

@REM Add default JVM options here. You can also use JAVA_OPTS and MAVEN_OPTS
@REM to pass JVM options to this script.
@SET DEFAULT_JVM_OPTS=

@REM Find java.exe
@IF DEFINED JAVA_HOME GOTO findJavaFromJavaHome

@SET JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
@IF %ERRORLEVEL% EQU 0 GOTO execute

@ECHO.
@ECHO ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
@ECHO.
@ECHO Please set the JAVA_HOME variable in your environment to match the
@ECHO location of your Java installation.

@GOTO error

:findJavaFromJavaHome
@SET JAVA_HOME=%JAVA_HOME:"=%
@SET JAVA_EXE=%JAVA_HOME%/bin/java.exe

@IF EXIST "%JAVA_EXE%" GOTO execute

@ECHO.
@ECHO ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
@ECHO.
@ECHO Please set the JAVA_HOME variable in your environment to match the
@ECHO location of your Java installation.

@GOTO error

:execute
@REM Setup the command line

@SET CLASSPATH=

@REM -- Find basedir, i.e., where .mvn folder is ---------------------------------
@SET MAVEN_PROJECTBASEDIR=%APP_HOME%

:baseCheckLoop
@IF EXIST "%MAVEN_PROJECTBASEDIR%\.mvn" GOTO baseCheckLoopEnd
@CD "%MAVEN_PROJECTBASEDIR%"
@CD ..
@IF "%MAVEN_PROJECTBASEDIR%"=="%CD%" GOTO baseCheckLoopEnd
@SET MAVEN_PROJECTBASEDIR=%CD%
@GOTO baseCheckLoop
:baseCheckLoopEnd

@REM -- Read wrapper properties -------------------------------------------------
@SET WRAPPER_PROPERTIES="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.properties"
@SET WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"

@REM If maven-wrapper.jar exists, skip download; otherwise fetch it
@IF EXIST %WRAPPER_JAR% GOTO runMavenWithWrapper

@REM -- Download maven-wrapper.jar using PowerShell or certutil -----------------
@SET DOWNLOAD_URL=
@FOR /F "usebackq tokens=1,* delims==" %%A IN (%WRAPPER_PROPERTIES%) DO (
  @IF "%%A"=="wrapperUrl" SET DOWNLOAD_URL=%%B
)

@REM Trim whitespace from URL
@FOR /F "tokens=* delims= " %%A IN ("%DOWNLOAD_URL%") DO SET DOWNLOAD_URL=%%A

@IF DEFINED MVNW_VERBOSE (
  @ECHO Downloading from: %DOWNLOAD_URL%
)

@ECHO Downloading Maven Wrapper...

@REM Try PowerShell first (available on Windows 7+)
powershell -Command "&{"^
  "$webclient = new-object System.Net.WebClient;"^
  "if (-not ([string]::IsNullOrEmpty('%MVNW_USERNAME%') -and [string]::IsNullOrEmpty('%MVNW_PASSWORD%'))) {"^
  "$webclient.Credentials = new-object System.Net.NetworkCredential('%MVNW_USERNAME%', '%MVNW_PASSWORD%');"^
  "}"^
  "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;"^
  "$webclient.DownloadFile('%DOWNLOAD_URL%', %WRAPPER_JAR%)"^
"}" 2>NUL
@IF %ERRORLEVEL% EQU 0 GOTO runMavenWithWrapper

@REM Fallback to certutil
certutil.exe -urlcache -f "%DOWNLOAD_URL%" %WRAPPER_JAR% >NUL 2>NUL
@IF %ERRORLEVEL% EQU 0 GOTO runMavenWithWrapper

@ECHO.
@ECHO ERROR: Failed to download %DOWNLOAD_URL%
@ECHO Please check your internet connection or manually download maven-wrapper.jar
@ECHO from %DOWNLOAD_URL%
@ECHO and place it in the .mvn\wrapper directory.
@GOTO error

:runMavenWithWrapper
@SET MAVEN_OPTS=%MAVEN_OPTS%

@FOR /F "usebackq tokens=1,* delims==" %%A IN (%WRAPPER_PROPERTIES%) DO (
  @IF "%%A"=="distributionUrl" SET DISTRIBUTION_URL=%%B
)

@"%JAVA_EXE%" ^
  %DEFAULT_JVM_OPTS% ^
  %JAVA_OPTS% ^
  %MAVEN_OPTS% ^
  "-Dmaven.multiModuleProjectDirectory=%MAVEN_PROJECTBASEDIR%" ^
  "-Dmaven.home=%M2_HOME%" ^
  "-Dmaven.conf=%MAVEN_PROJECTBASEDIR%\.mvn" ^
  "-Dclassworlds.conf=" ^
  "-Dmaven.repo.local=%MAVEN_REPO_LOCAL%" ^
  "-Dmvnw.repourl=%MVNW_REPOURL%" ^
  -jar %WRAPPER_JAR% ^
  %*

@IF %ERRORLEVEL% NEQ 0 GOTO error
@GOTO end

:error
@SET ERROR_CODE=%ERRORLEVEL%
@IF %ERROR_CODE% EQU 0 (SET ERROR_CODE=1)

:end
@ENDLOCAL & SET CMD_LINE_ARGS=%*

@EXIT /B %ERROR_CODE%
