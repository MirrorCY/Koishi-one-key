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

Title Koishi 一键脚本

cls
echo.
echo 脚本开源地址 https://github.com/MirrorCY/Koishi-one-key
echo 最新下载地址 https://simx.elchapo.cn/Koishi/Koishi.bat
echo 请始终仅运行自己信任的脚本

:main  
echo. 
echo ═══════════════════════════════════════
echo 【输入序号按回车】:       
echo    0.检查脚本更新
echo    1.一键安装/重装 koishi
echo    2.一键更新 koishi
echo    3.一键安装人人有图画插件
echo    4.卸载 koishi
echo    5.退出脚本
echo.
set /p n=输入操作号: 
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
echo 安装完成后请重启系统，再点击桌面上的快捷方式运行 koishi
echo 你可以在这里找到一些常见问题的指导
echo koishi 论坛: https://forum.koishi.xyz
echo koishi 用户手册: https://koishi.ilharper.com
echo koishi 文档: https://koishi.chat
echo novelai 插件文档: https://bot.novelai.dev
goto :clean 

:updateKoi 
echo 没做 
goto :main 

:rryth 
echo 没做 
goto :main 

:remove 
echo 没做 
goto :main 

:updateBat 
cls
echo.
@REM curl https://simx.elchapo.cn/Koishi/Version
echo 正在检查最新版本  当前版本 v0.0.1
curl https://gz-1252085975.cos.ap-guangzhou.myqcloud.com/Koishi/Version
echo.
echo 下载地址 https://simx.elchapo.cn/Koishi/Koishi.bat
pause
cls
goto :main 

:clean 
echo 正在清理
powershell set-executionpolicy %executionpolicy%
pause 
exit