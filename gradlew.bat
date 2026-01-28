@echo off
setlocal
set DIR=%~dp0
set WRAPPER_JAR=%DIR%gradle\wrapper\gradle-wrapper.jar

if not exist "%WRAPPER_JAR%" (
  echo Missing gradle-wrapper.jar at %WRAPPER_JAR%
  echo Re-generate wrapper: gradle wrapper
  exit /b 1
)

if defined JAVA_HOME (
  set JAVA_EXEC=%JAVA_HOME%\bin\java.exe
) else (
  set JAVA_EXEC=java.exe
)

"%JAVA_EXEC%" -classpath "%WRAPPER_JAR%" org.gradle.wrapper.GradleWrapperMain %*
endlocal
