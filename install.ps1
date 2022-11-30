$koiPath = "$env:ProgramFiles\Koishi1"

Write-Host "清理旧版本"
rm -Recurse -Force $koiPath
mkdir $koiPath

Write-Host "设置权限"
$NewAcl = Get-Acl -Path $koiPath
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$NewAcl.ResetAccessRule($AccessRule)
Set-Acl -Path $koiPath -AclObject $NewAcl

Write-Host "下载 Koishi-desktop"
try{
    Invoke-WebRequest -Uri "https://k.ilharp.cc/win.zip" -OutFile $env:TEMP\koi.zip
}catch{
    Write-Host "下载失败"
    exit
}
Write-Host "安装 Koishi-desktop"
Expand-Archive -LiteralPath $env:TEMP\koi.zip -DestinationPath $koiPath
rm -Force $env:TEMP\koi.zip

Write-Host "创建桌面快捷方式"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$Home\Desktop\Koishi.lnk")
$Shortcut.TargetPath = "$koiPath\koi.exe"
$Shortcut.Save()

Write-Host "启动 Koishi-desktop"
& "$Home\Desktop\Koishi.lnk"