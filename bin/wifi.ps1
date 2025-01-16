#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = "Props")]
param (
	[Parameter(Mandatory = $true, ParameterSetName = "Props")]
	[string]$Ssid,
	[Parameter(Mandatory = $true, ParameterSetName = "Props")]
	[securestring]$Password,
	[Parameter(ParameterSetName = "Config")]
	[string]$Config = "$PSScriptRoot\..\etc\wifi.config"
)

Set-StrictMode -Off

Import-Module -Name "$PSScriptRoot\..\lib\config"
Import-Module -Name "$PSScriptRoot\..\lib\file"

if ($PSCmdlet.ParameterSetName -eq "Props") {
	$WlanProfile = Join-Path -Path $Env:TEMP -ChildPath $($(New-Guid).Guid + ".xml")
	@"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
	<name>$Ssid</name>
	<SSIDConfig>
		<SSID>
			<hex>$([string]::Concat($($Ssid.ToCharArray() | ForEach-Object { [System.String]::Format("{0:X}", [System.Convert]::ToUInt32($_)) })))</hex>
			<name>$Ssid</name>
		</SSID>
	</SSIDConfig>
	<connectionType>ESS</connectionType>
	<connectionMode>auto</connectionMode>
	<MSM>
		<security>
			<authEncryption>
				<authentication>WPA2PSK</authentication>
				<encryption>AES</encryption>
				<useOneX>false</useOneX>
			</authEncryption>
			<sharedKey>
				<keyType>passPhrase</keyType>
				<protected>false</protected>
				<keyMaterial>$([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)))</keyMaterial>
			</sharedKey>
		</security>
	</MSM>
	<MacRandomization xmlns="http://www.microsoft.com/networking/WLAN/profile/v3">
		<enableRandomization>false</enableRandomization>
	</MacRandomization>
</WLANProfile>
"@ | file\Out-File -FilePath $WlanProfile
	netsh.exe wlan add profile filename=$WlanProfile user=all
	Remove-Item -Path $WlanProfile -Force
}

elseif ($PSCmdlet.ParameterSetName -eq "Config") {
	$Wifi = Convert-Config -Object $Config
	if ($Wifi.Count -ne 0) {
		$Wifi | ForEach-Object {
			$Props = @{
				Ssid     = $_.ssid
				Password = $_.password | ConvertTo-SecureString -AsPlainText -Force
			}
			& $PSCommandPath @Props
		}
	}
}
