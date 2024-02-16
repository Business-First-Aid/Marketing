
<#PSScriptInfo

.VERSION 1.0.0

.GUID 592c6337-52ab-4a63-a340-7c1ebd128087

.AUTHOR Tigran TIKSN Torosyan

.COMPANYNAME

.COPYRIGHT Copyright © Tigran TIKSN Torosyan

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

#Requires -Module PSFramework

<#

.DESCRIPTION
 Sends Marketing Email

#>
Param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({
            if (-not (Test-Path $_)) { $false }
            if (-not (Test-Path $_ -PathType Leaf -ErrorAction SilentlyContinue)) {
                $false
            }
            $true
        })]
    [string]
    $TemplatePath,
    [Parameter(Mandatory = $true)]
    [string]
    $ToEmail
)

$ErrorActionPreference = 'Stop'

[System.Net.ServicePointManager]::SecurityProtocol = 'Tls13'

$marketingEmailSettings = Import-PowerShellDataFile -Path 'MarketingEmailSettings.psd1'

$emailContent = Get-Content -Path $TemplatePath -Raw

$emailSubject = [System.IO.Path]::GetFileNameWithoutExtension($TemplatePath)

Write-PSFMessage -Level Important -Message "Sending email from '$($marketingEmailSettings.FromEmail)' to '$ToEmail' with subject '$emailSubject'"

$emailCredential = Get-Secret -Name 'BusinessFirstAid-MarketingEmailCredential'

Write-PSFMessage -Level Verbose -Message "Marketing Email Credential is $($emailCredential.UserName)"

Send-MailMessage `
    -SmtpServer $marketingEmailSettings.SmtpServerAddress `
    -Port $marketingEmailSettings.SmtpServerPort `
    -UseSsl:$marketingEmailSettings.SmtpServerSsl `
    -Credential $emailCredential `
    -From $marketingEmailSettings.FromEmail `
    -To $ToEmail `
    -Subject $emailSubject `
    -Body $emailContent -BodyAsHtml

Write-PSFMessage -Level Important -Message "Sent email from '$($marketingEmailSettings.FromEmail)' to '$ToEmail' with subject '$emailSubject'"
