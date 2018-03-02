################################################################
# SCRIPT: Deploy-FortiVMFirewall.ps1
# AUTHOR: Josh Ellis - Josh@JoshEllis.NZ
# Website: JoshEllis.NZ
# VERSION: 1.0
# DATE: 06/03/2016
# DESCRIPTION: Copys the Fortigate VM files and deploys to a Hyper-V VM.
################################################################

[CmdletBinding()]
Param(
[Parameter(Mandatory=$True,Position=1)]
[string]$FWName
     )
# Source Files
$FortigateOSVHD = "E:\Fortinet Virtual Firewall\fortios.vhd"
$FortigateDataVHD = "E:\Fortinet Virtual Firewall\DATADRIVE.vhd"

# Hyper-V Files Location
$HyperVDisks = 'C:\HyperV\Disks\'
$HyperVFiles = 'C:\HyperV\Config\'

# Virtual Machine Config
$CPU = 1 #Eval mode only supports 1vCPU
$RAM = 1GB #Eval mode only supports 1024mb ram
$VHDPath = ($HyperVDisks+"\$FWName")
$OSVHDPath = ($VHDPath+"\$FWName-OS.vhd")
$DataVHDPath = ($VHDPath+"\$FWName-Data.vhd")
$LANSwitch = "Private-LAN" 
$WANSwitch = "Bridged-WAN"
$VMGeneration = 1
$AutomaticStartAction = "Nothing" #Nothing,StartifRunning,Start
$AutomaticStopAction = "ShutDown" #TurnOff,Save,Shutdown


#Clone Fortigate VHD File
New-Item -Path $VHDPath -ItemType Directory -Force | Out-Null
Copy-Item -Path $FortigateOSVHD -Destination $OSVHDPath -Force
Copy-Item -Path $FortigateDataVHD -Destination $DataVHDPath -Force

#Create VM
New-VM -ComputerName $Env:Computername -Name $FWName -MemoryStartupBytes $RAM -SwitchName $LANSwitch -VHDPath $OSVHDPath -Path $HyperVFiles -Generation $VMGeneration | Out-Null
Add-VMHardDiskDrive -ComputerName $Env:Computername -VMName $FWName -Path $DataVHDPath | Out-Null
Add-VMNetworkAdapter -ComputerName $Env:Computername -VMName $FWName -SwitchName $WANSwitch  | Out-Null

#Set CPU and Memory
Set-VM -Name $FWName -ProcessorCount $CPU
Set-VMMemory -VMName $FWName -DynamicMemoryEnabled $false

#Set Start and Stop Action
Set-VM -Name $FWName -AutomaticStartAction $AutomaticStartAction -AutomaticStopAction $AutomaticStopAction

#Start VM
Start-VM $FWName
