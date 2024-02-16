
<#PSScriptInfo

.VERSION 1.0.0

.GUID dc61d42c-f53f-4b73-ad31-46581f4dc023

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
    [ValidateScript({
            if (-not (Test-Path $_)) { $false }
            if (-not (Test-Path $_ -PathType Leaf -ErrorAction SilentlyContinue)) {
                $false
            }
            $true
        })]
    [string]
    $ContactsPath
)

$contacts = Import-Csv -Path $ContactsPath

foreach ($contact in $contacts) {
    if (-not $contact.Contacted) {
        if ($contact.Email) {
            .\Send-MarketingEmail.ps1 -TemplatePath '.\.trash\templates\Collaboration Proposal.html' -ToEmail $contact.Email
            Start-Sleep -Seconds 5
        }
    }
}
