# Define parameters
$ControlPlaneVMs = 3
$ClusterVMs = 1
$ControlPlaneName = "RKE2 Server"
$ClusterName = "RKE2 Agent"
$MemoryControlPlane = 4 * 1GB # 2 GB in bytes
$MemoryCluster = 4 * 1GB      # 4 GB in bytes
$CPUControlPlane = 4
$CPUCluster = 4
$VMPath = "D:\hyper-V\vm_drives" # Path to store VMs and VHDs
$VHDSize = 50GB                 # Size of the virtual hard disk
$UbuntuISOPath = "D:\ISO\ubuntu-24.04-live-server-amd64.iso" # Path to Ubuntu Server ISO

# Ensure the VM path exists
if (-not (Test-Path -Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# Function to create a VM
function Create-VM {
    param (
        [string]$Name,
        [string]$Path,
        [int64]$Memory, # Use Int64 for larger values
        [int]$CPU
    )
    $VMPath = Join-Path $Path $Name
    $VHDPath = Join-Path $VMPath "$Name.vhdx"

    # Create VM directory
    if (-not (Test-Path -Path $VMPath)) {
        New-Item -ItemType Directory -Path $VMPath | Out-Null
    }

    # Create VHD
    New-VHD -Path $VHDPath -SizeBytes $VHDSize -Dynamic | Out-Null

    # Create VM
    $VM = New-VM -Name $Name -MemoryStartupBytes $Memory -Generation 2 -Path $VMPath -SwitchName "Default Switch"
    Set-VMProcessor -VMName $Name -Count $CPU
    Add-VMHardDiskDrive -VMName $Name -Path $VHDPath | Out-Null

    # Attach Ubuntu ISO
    Add-VMDvdDrive -VMName $Name -Path $UbuntuISOPath | Out-Null

    # Disable Secure Boot
    Set-VMFirmware -VMName $Name -EnableSecureBoot Off
    Write-Host "Secure Boot disabled for VM: $Name"

    Write-Host "Created VM and attached Ubuntu ISO: $Name"
}

# Create Control-Plane VMs
for ($i = 1; $i -le $ControlPlaneVMs; $i++) {
    $VMName = "$ControlPlaneName-$i"
    Create-VM -Name $VMName -Path $VMPath -Memory $MemoryControlPlane -CPU $CPUControlPlane
}

# Create Cluster VMs
for ($i = 1; $i -le $ClusterVMs; $i++) {
    $VMName = "$ClusterName-$i"
    Create-VM -Name $VMName -Path $VMPath -Memory $MemoryCluster -CPU $CPUCluster
}

Write-Host "All VMs created successfully with Ubuntu Server ISO attached, Secure Boot disabled, and DVD Drive set as the first boot device."
