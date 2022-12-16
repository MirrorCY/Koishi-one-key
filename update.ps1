$koiPath = "$env:ProgramFiles\Koishi1"
$koiBackupPath = "C:\koishi-one-key-backup"
$ShortcutPath = [Environment]::GetFolderPath("CommonDesktopDirectory") + "\Koishi.lnk"
$ProgressPreference = "SilentlyContinue" # https://github.com/PowerShell/PowerShell/issues/2138

Write-Host "停止 koishi 进程"
for ($i = 0; $i -lt 3; $i++) {
    Stop-Process -Name "koi*"
    Start-Sleep 2
}

Write-Host "备份实例"
try {
    Remove-Item -Recurse -Force $koiBackupPath
    Move-Item -Path $koiPath -Destination $koiBackupPath
    New-Item -Path $koiPath -ItemType "directory"
}
catch {
    Write-Host "未通过一键脚本安装 koishi。"
    exit
}

Write-Host "设置权限"
$NewAcl = Get-Acl -Path $koiPath
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$NewAcl.ResetAccessRule($AccessRule)
Set-Acl -Path $koiPath -AclObject $NewAcl

Write-Host "下载 Koishi-desktop"
try {
    Invoke-WebRequest -Uri "https://k.ilharp.cc/win.zip" -OutFile $env:TEMP\koi.zip
}
catch {
    Write-Host "下载失败"
    exit
}

Write-Host "更新 Koishi-desktop"
Expand-Archive -LiteralPath $env:TEMP\koi.zip -DestinationPath $koiPath
Remove-Item -Force $env:TEMP\koi.zip
Write-Host "koishi 安装在$koiPath"

Write-Host "还原实例中"
Remove-Item -Recurse -Force "$koiPath\data\instances"
Copy-Item -Path "$koiBackupPath\data\instances" -Destination "$koiPath\data" -Recurse

Write-Host "创建桌面快捷方式"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "$koiPath\koi.exe"
$Shortcut.Save()
Write-Host "快捷方式创建在桌面及$ShortcutPath"
Write-Host "备份文件位于$koiBackupPath，确认更新无误后可以手动删除。"

Write-Host "启动 Koishi-desktop"
& $ShortcutPath