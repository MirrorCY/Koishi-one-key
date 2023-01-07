$koiPath = "$env:ProgramFiles\Koishi1"
$koiBackupPath = "C:\koishi-one-key-backup"
$ShortcutPath = "$env:Public\Desktop\Koishi.lnk"
# $ProgressPreference = "SilentlyContinue" # https://github.com/PowerShell/PowerShell/issues/2138
# 因为下载有时太慢了，还是保留进度条吧

Write-Host -ForegroundColor Green "停止 koishi 进程"
for ($i = 0; $i -lt 3; $i++) {
    Stop-Process -Name "koi*"
    Start-Sleep 2
}# 应该有一万种比这个好的方法，但这个能用。

Write-Host -ForegroundColor Green "备份实例"
try {
    Remove-Item -Recurse -Force $koiBackupPath
    Move-Item -Path $koiPath -Destination $koiBackupPath
    New-Item -Path $koiPath -ItemType "directory"
}
catch {
    Write-Host -ForegroundColor Red "未通过一键脚本安装 koishi。"
    exit
}

Write-Host -ForegroundColor Green "下载 Koishi-desktop"
try {
    ipconfig.exe -flushdns
    Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/kd.7z" -OutFile $env:TEMP\kd.7z
    Invoke-WebRequest -Uri "https://simx.elchapo.cn/Koishi/7za.exe" -OutFile $env:TEMP\7za.exe
}
catch {
    Write-Host -ForegroundColor Red "下载失败"
    exit
}

Write-Host -ForegroundColor Green "更新 Koishi-desktop"
& $env:TEMP\7za.exe x $env:TEMP\kd.7z -oC:\kdtmp -y
Move-Item -Force -Path C:\kdtmp\* -Destination $koiPath

Remove-Item -Force C:\kdtmp
Remove-Item -Force $env:TEMP\kd.7z
Remove-Item -Force $env:TEMP\7za.exe
Write-Host -ForegroundColor Green "koishi 安装在$koiPath"

Write-Host -ForegroundColor Green "还原实例中"
Remove-Item -Recurse -Force "$koiPath\data\instances"
Copy-Item -Path "$koiBackupPath\data\instances" -Destination "$koiPath\data" -Recurse

Write-Host -ForegroundColor Green "设置权限"
$NewAcl = Get-Acl -Path $koiPath
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$NewAcl.ResetAccessRule($AccessRule)
Set-Acl -Path $koiPath -AclObject $NewAcl

Write-Host -ForegroundColor Green "创建桌面快捷方式"
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "$koiPath\koi.exe"
$Shortcut.Save()
Write-Host -ForegroundColor Green "快捷方式创建在桌面及$ShortcutPath"
Write-Host -ForegroundColor Green "备份文件位于$koiBackupPath，确认更新无误后可以手动删除。"

Write-Host -ForegroundColor Green "启动 Koishi-desktop"
& $ShortcutPath
