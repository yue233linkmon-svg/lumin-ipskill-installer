Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$package = Get-ChildItem -LiteralPath $root -Filter 'lumin-ipskill-v*-public.zip' -File | Select-Object -First 1
if (-not (Test-Path -LiteralPath $package)) {
    [System.Windows.MessageBox]::Show('安装包内容不完整，请重新下载。','Lumin ipskill', 'OK', 'Error') | Out-Null
    exit 2
}

function New-Text([string]$value, [int]$size = 14) {
    $t = New-Object Windows.Controls.TextBlock
    $t.Text = $value
    $t.FontSize = $size
    $t.TextWrapping = 'Wrap'
    $t.Margin = '0,6,0,6'
    return $t
}

$window = New-Object Windows.Window
$window.Title = 'Lumin ipskill 安装向导'
$window.Width = 680
$window.Height = 500
$window.MinWidth = 620
$window.MinHeight = 440
$window.WindowStartupLocation = 'CenterScreen'
$window.ResizeMode = 'CanResize'

$outer = New-Object Windows.Controls.Grid
$outer.Margin = '28'
$outer.RowDefinitions.Add((New-Object Windows.Controls.RowDefinition))
$outer.RowDefinitions.Add((New-Object Windows.Controls.RowDefinition))
$outer.RowDefinitions[1].Height = 'Auto'
$window.Content = $outer

$content = New-Object Windows.Controls.StackPanel
[Windows.Controls.Grid]::SetRow($content,0)
$outer.Children.Add($content) | Out-Null

$buttons = New-Object Windows.Controls.StackPanel
$buttons.Orientation = 'Horizontal'
$buttons.HorizontalAlignment = 'Right'
[Windows.Controls.Grid]::SetRow($buttons,1)
$outer.Children.Add($buttons) | Out-Null

$back = New-Object Windows.Controls.Button
$back.Content = '上一步'
$back.Width = 90
$back.Margin = '6,22,6,0'
$back.IsEnabled = $false
$buttons.Children.Add($back) | Out-Null
$next = New-Object Windows.Controls.Button
$next.Content = '下一步'
$next.Width = 110
$next.Margin = '6,22,6,0'
$buttons.Children.Add($next) | Out-Null
$cancel = New-Object Windows.Controls.Button
$cancel.Content = '取消'
$cancel.Width = 90
$cancel.Margin = '6,22,0,0'
$buttons.Children.Add($cancel) | Out-Null

$pages = @()
function Add-Page($panel) { $script:pages += $panel; $content.Children.Add($panel) | Out-Null }

$p0 = New-Object Windows.Controls.StackPanel
$p0.Children.Add((New-Text '欢迎使用 Lumin ipskill 安装向导' 26)) | Out-Null
$p0.Children.Add((New-Text '这个向导会自动完成安装。你只需要选择需要的能力，然后连续点击“下一步”。' 16)) | Out-Null
$p0.Children.Add((New-Text '安装过程中不需要打开 PowerShell，也不需要手动输入安装命令。')) | Out-Null
Add-Page $p0

$p1 = New-Object Windows.Controls.StackPanel
$p1.Children.Add((New-Text '选择要安装的能力' 24)) | Out-Null
$p1.Children.Add((New-Text '建议普通用户选择 AVG；需要飞书完整能力时再勾选 CLI。安装后仍可再次运行本向导添加其他能力。')) | Out-Null
$checks = @{}
foreach($item in @(@('avg','Lumin AVG / NPC / 任务配置'),@('cli','飞书文档、表格、消息、日历等完整能力'),@('voice','Lumin 配音需求表'),@('food','竹笋点餐提醒'))) {
    $c = New-Object Windows.Controls.CheckBox
    $c.Content = $item[1]
    $c.Tag = $item[0]
    $c.FontSize = 15
    $c.Margin = '8,8,8,8'
    $c.IsChecked = ($item[0] -eq 'avg')
    $checks[$item[0]] = $c
    $p1.Children.Add($c) | Out-Null
}
Add-Page $p1

$p2 = New-Object Windows.Controls.StackPanel
$p2.Children.Add((New-Text '正在安装，请稍候…' 24)) | Out-Null
$status = New-Text '正在准备安装文件…'
$p2.Children.Add($status) | Out-Null
$bar = New-Object Windows.Controls.ProgressBar
$bar.Height = 18
$bar.IsIndeterminate = $true
$bar.Margin = '0,16,0,16'
$p2.Children.Add($bar) | Out-Null
Add-Page $p2

$p3 = New-Object Windows.Controls.StackPanel
$p3.Children.Add((New-Text '安装完成' 26)) | Out-Null
$done = New-Text ''
$p3.Children.Add($done) | Out-Null
$p3.Children.Add((New-Text '现在可以打开 Codex，直接描述你要完成的任务。')) | Out-Null
Add-Page $p3

$script:current = 0
function Show-Page([int]$index) {
    for($i=0;$i -lt $pages.Count;$i++){ $pages[$i].Visibility = if($i -eq $index){'Visible'}else{'Collapsed'} }
    $back.IsEnabled = ($index -gt 0 -and $index -lt 2)
    $next.Content = if($index -eq 3){'完成'}else{'下一步'}
    $cancel.Content = if($index -eq 3){'关闭'}else{'取消'}
}
Show-Page 0

$cancel.Add_Click({ $window.Close() })
$back.Add_Click({ if($script:current -gt 0){$script:current--; Show-Page $script:current} })
$next.Add_Click({
    if($script:current -eq 0){ $script:current=1; Show-Page $script:current; return }
    if($script:current -eq 1){
        $selected = @($checks.GetEnumerator() | Where-Object {$_.Value.IsChecked} | ForEach-Object {$_.Key})
        if($selected.Count -eq 0){ [System.Windows.MessageBox]::Show('请至少选择一个安装项。','Lumin ipskill','OK','Warning') | Out-Null; return }
        $script:current=2; Show-Page $script:current
        $window.Dispatcher.Invoke([action]{}, 'Render')
        $temp = Join-Path ([System.IO.Path]::GetTempPath()) ('lumin-ipskill-install-' + [guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $temp | Out-Null
        try {
            $status.Text = '正在解压安装文件…'
            Expand-Archive -LiteralPath $package -DestinationPath $temp -Force
            $installRoot = Join-Path $temp 'ipskill'
            $install = Join-Path $installRoot 'install.ps1'
            $profileArgs = ($selected -join ',')
            $outFile = Join-Path $temp 'install.out.txt'
            $errFile = Join-Path $temp 'install.err.txt'
            $status.Text = '正在安装选中的 Profile…'
            $proc = Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoLogo','-NoProfile','-ExecutionPolicy','Bypass','-File',('"'+$install+'"'),'-Profile',$profileArgs,'-InstallUpdateMonitor','-Apply') -WorkingDirectory $installRoot -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $outFile -RedirectStandardError $errFile
            if($proc.ExitCode -ne 0){
                $detail = (Get-Content -Raw -LiteralPath $errFile -ErrorAction SilentlyContinue)
                if([string]::IsNullOrWhiteSpace($detail)){ $detail = (Get-Content -Raw -LiteralPath $outFile -ErrorAction SilentlyContinue) }
                throw ('安装失败（退出码 {0}）。{1}' -f $proc.ExitCode,$detail)
            }
            $done.Text = '已安装：' + ($selected -join '、') + '。'
            $script:current=3; Show-Page $script:current
        } catch {
            $script:current=1; Show-Page $script:current
            [System.Windows.MessageBox]::Show($_.Exception.Message,'Lumin ipskill 安装失败','OK','Error') | Out-Null
        } finally {
            if(Test-Path -LiteralPath $temp){ Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
        }
        return
    }
    if($script:current -eq 3){ $window.Close() }
})

$window.ShowDialog() | Out-Null
