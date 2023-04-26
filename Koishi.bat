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

Title Koishi 一键脚本

cls
echo.
echo 脚本开源地址 https://github.com/MirrorCY/Koishi-one-key
echo 最新下载地址 https://simx.elchapo.cn/Koishi/Koishi.bat
echo 此脚本 按原样 提供，请始终仅运行自己信任的脚本
echo.
echo 你可以在这里找到一些常见问题的指导
echo koishi 论坛: https://forum.koishi.xyz
echo koishi 用户手册: https://koishi.ilharper.com
echo koishi 文档: https://koishi.chat
echo novelai 插件文档: https://bot.novelai.dev

:main  
echo. 
echo ═══════════════════════════════════════
echo 【输入序号按回车】:       
echo    0.检查脚本更新
echo    1.安装/重装 koishi
echo    2.更新 koishi
echo    3.安装 ffmpeg （QQ 发语音需要）
echo    4.退出脚本
echo.
set /p n=输入操作号: 
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
echo 点击桌面上的快捷方式运行 koishi
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
echo 正在检查最新版本
echo 当前版本为 v0.10.0
curl https://simx.elchapo.cn/Koishi/Version
echo.
echo 下载地址 https://simx.elchapo.cn/Koishi/Koishi.bat
pause
cls
goto :main 

:clean 
echo 正在清理
%psRun% set-executionpolicy %executionpolicy%
pause 
exit
