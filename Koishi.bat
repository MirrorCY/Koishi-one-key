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

for /f "tokens=*" %%i in ('powershell get-executionpolicy') do set executionpolicy=%%i
powershell set-executionpolicy remotesigned

Title Koishi һ���ű�

cls
echo.
echo �ű���Դ��ַ https://github.com/MirrorCY/Koishi-one-key
echo �������ص�ַ https://simx.elchapo.cn/Koishi/Koishi.bat
echo ��ʼ�ս������Լ����εĽű�

:main  
echo. 
echo �T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T
echo ��������Ű��س���:       
echo    0.���ű�����
echo    1.һ����װ/��װ koishi
echo    2.һ������ koishi
echo    3.һ����װ������ͼ�����
echo    4.ж�� koishi
echo    5.�˳��ű�
echo.
set /p n=���������: 
if "%n%"=="" cls&goto :main 
if "%n%"=="0" call :updateBat 
if "%n%"=="1" call :install 
if "%n%"=="2" call :updateKoi 
if "%n%"=="3" call :rryth 
if "%n%"=="4" call :remove 
if /i "%n%"=="5" call :clean 
goto :clean 

:install 
powershell Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/install.ps1" -OutFile %temp%\install.ps1
powershell -executionpolicy remotesigned -File %temp%\install.ps1
powershell set-executionpolicy %executionpolicy%
echo ��װ��ɺ�������ϵͳ���ٵ�������ϵĿ�ݷ�ʽ���� koishi
echo ������������ҵ�һЩ���������ָ��
echo koishi ��̳: https://forum.koishi.xyz
echo koishi �û��ֲ�: https://koishi.ilharper.com
echo koishi �ĵ�: https://koishi.chat
echo novelai ����ĵ�: https://bot.novelai.dev
goto :clean 

:updateKoi 
echo û�� 
goto :main 

:rryth 
echo û�� 
goto :main 

:remove 
echo û�� 
goto :main 

:updateBat 
cls
echo.
@REM curl https://simx.elchapo.cn/Koishi/Version
echo ���ڼ�����°汾  ��ǰ�汾 v0.0.1
curl https://gz-1252085975.cos.ap-guangzhou.myqcloud.com/Koishi/Version
echo.
echo ���ص�ַ https://simx.elchapo.cn/Koishi/Koishi.bat
pause
cls
goto :main 

:clean 
echo ��������
powershell set-executionpolicy %executionpolicy%
pause 
exit