@echo off

setlocal
set uac=~uac_permission_tmp_%random%
md "%SystemRoot%\system32\%uac%" 2>nul
if %errorlevel%==0 ( rd "%SystemRoot%\system32\%uac%" >nul 2>nul ) else (
    echo set uac = CreateObject^("Shell.Application"^)>"%temp%\%uac%.vbs"
    echo uac.ShellExecute "%~s0","","","runas",1 >>"%temp%\%uac%.vbs"
    echo WScript.Quit >>"%temp%\%uac%.vbs"
    "%temp%\%uac%.vbs" /f
    del /f /q "%temp%\%uac%.vbs" & exit )
endlocal

set psRun=C:\Windows\System32\WindowsPowerShell\v1.0\powershell

for /f "tokens=*" %%i in ('%psRun% get-executionpolicy') do set executionpolicy=%%i
%psRun% set-executionpolicy remotesigned

Title Koishi һ���ű�

cls
echo.
echo �ű���Դ��ַ https://github.com/MirrorCY/Koishi-one-key
echo �������ص�ַ https://simx.elchapo.cn/Koishi/Koishi.bat
echo �˽ű� ��ԭ�� �ṩ����ʼ�ս������Լ����εĽű�
echo.
echo ������������ҵ�һЩ���������ָ��
echo koishi ��̳: https://forum.koishi.xyz
echo koishi �û��ֲ�: https://koishi.ilharper.com
echo koishi �ĵ�: https://koishi.chat
echo novelai ����ĵ�: https://bot.novelai.dev

:main  
echo. 
echo �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T
echo ��������Ű��س���:       
echo    0.���ű�����
echo    1.��װ/��װ koishi
echo    2.���� koishi
echo    3.��װ ffmpeg ��QQ ��������Ҫ��
echo    4.�˳��ű�
echo.
set /p n=���������: 
if "%n%"=="" cls&goto :main 
if "%n%"=="0" call :updateBat 
if "%n%"=="1" call :installKoi 
if "%n%"=="2" call :updateKoi 
if "%n%"=="3" call :installFfmpeg 
if /i "%n%"=="4" call :clean 
goto :clean 

:installKoi 
%psRun% Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/install.ps1" -OutFile %temp%\install.ps1
%psRun% -executionpolicy remotesigned -File %temp%\install.ps1
%psRun% set-executionpolicy %executionpolicy%
echo ��������ϵĿ�ݷ�ʽ���� koishi
goto :clean 

:updateKoi 
%psRun% Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/update.ps1" -OutFile %temp%\update.ps1
%psRun% -executionpolicy remotesigned -File %temp%\update.ps1
%psRun% set-executionpolicy %executionpolicy%
goto :clean 

:installFfmpeg 
%psRun% Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/ffmpeg.ps1" -OutFile %temp%\ffmpeg.ps1
%psRun% -executionpolicy remotesigned -File %temp%\ffmpeg.ps1
%psRun% set-executionpolicy %executionpolicy%
goto :clean 

:updateBat 
cls
echo.
echo ���ڼ�����°汾
echo ��ǰ�汾Ϊ v0.10.0
curl https://simx.elchapo.cn/Koishi/Version
echo.
echo ���ص�ַ https://simx.elchapo.cn/Koishi/Koishi.bat
pause
cls
goto :main 

:clean 
echo ��������
%psRun% set-executionpolicy %executionpolicy%
pause 
exit
