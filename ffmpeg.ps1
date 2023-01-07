$ffPath = "C:\ffmpeg"

Write-Host -ForegroundColor Green "删除 ffmpeg"
Remove-Item -Recurse -Force $ffPath
mkdir $ffPath

Write-Host -ForegroundColor Green "下载 ffmpeg"
try {
    ipconfig.exe -flushdns
    Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/ffmpeg.7z" -OutFile $env:TEMP\ffmpeg.7z
    Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/7za.exe" -OutFile $env:TEMP\7za.exe
}
catch {
    Write-Host -ForegroundColor Red "下载失败"
    exit
}

Write-Host -ForegroundColor Green "安装 ffmpeg"
& $env:TEMP\7za.exe x -oC:\fftmp $env:TEMP\ffmpeg.7z
Move-Item -Force -Path C:\fftmp\* -Destination $ffPath

Write-Host -ForegroundColor Green "清理缓存"
Remove-Item -Force C:\fftmp
Remove-Item -Force $env:TEMP\ffmpeg.7z
Remove-Item -Force $env:TEMP\7za.exe

Write-Host -ForegroundColor Green "设置 ffmpeg 环境变量"
$OLDPATH = [System.Environment]::GetEnvironmentVariable('PATH','Machine')
$NEWPATH = "$OLDPATH;$ffPath\bin"
[Environment]::SetEnvironmentVariable("PATH", "$NEWPATH", "Machine")
Write-Host -ForegroundColor Green "ffmpeg 安装在$ffPath"
Write-Host -ForegroundColor Green "设置 ffmpeg 完成，你可以重启系统以确保能够正常使用 ffmpeg"
