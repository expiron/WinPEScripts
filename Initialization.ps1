
$BaseOSVHDFile = "$PSScriptRoot\SYSBASE.vhdx"
$SoftwareVHDFile = "$PSScriptRoot\SOFTWARE.vhdx"
$DiskPartScriptFile = "$PSScriptRoot\CreatePartitions-OSVHD.txt"

# $SWVHD = (New-VHD -Path $SoftwareVHDFile -BlockSizeBytes 4MB -LogicalSectorSizeBytes 4KB -SizeBytes (250.5GB+16MB) -Dynamic | Mount-VHD -Passthru | Initialize-Disk -PartitionStyle GPT -Passthru)
$SWVHD = (New-VHD -Path $SoftwareVHDFile -BlockSizeBytes 4MB -LogicalSectorSizeBytes 4KB -SizeBytes (250.5GB) -Dynamic)
# New-Partition -InputObject $SWVHD -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "SOFTWARE" -Compress -Confirm:$false
# Dismount-VHD -Path $SoftwareVHDFile -Confirm:$false

# $OSVHD = (New-VHD -Path $BaseOSVHDFile -BlockSizeBytes 4MB -LogicalSectorSizeBytes 4KB -SizeBytes (260MB+32MB+250.5GB+1028MB) -Dynamic | Mount-VHD -Passthru | Initialize-Disk -PartitionStyle GPT -Passthru)
$OSVHD = (New-VHD -Path $BaseOSVHDFile -BlockSizeBytes 4MB -LogicalSectorSizeBytes 4KB -SizeBytes (260MB+16MB+250.5GB+1028MB) -Dynamic)
# EFI Partition
# New-Partition -InputObject $OSVHD -Size 260MB -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}" -DriveLetter S | Format-Volume -FileSystem FAT32 -NewFileSystemLabel "ESP" -Confirm:$false
# MSR Partition
# New-Partition -InputObject $OSVHD -Size 16MB -GptType "{e3c9e316-0b5c-4db8-817d-f92df00215ae}"
# Windows Partition
# New-Partition -InputObject $OSVHD -Size 250.5GB -DriveLetter W | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Windows" -ShortFileNameSupport:$true -Confirm:$false
# Recovery Partition
# New-Partition -InputObject $OSVHD -Size 1028MB -GptType "{de94bba4-06d1-4d40-a16a-bfd50179d6ac}" -IsHidden:$true -DriveLetter R | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Recovery" -Confirm:$false

# $DiskPartScript = '
# Select Disk {0}
# Clean
# Convert GPT
# Create Partition EFI Size=260
# Format Quick FS=FAT32 Label="ESP"
# Assign Letter="S"
# Create Partition MSR Size=16
# Create Partition Primary
# Shrink Minimum=1028
# Format Quick FS=NTFS Label="Windows"
# Assign Letter="W"
# Create Partition Primary
# Format Quick FS=NTFS Label="Recovery"
# Assign Letter="R"
# Set ID="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
# GPT Attributes=0x8000000000000001
# Detail Disk
# List Volume
# Exit
# ' -F $OSVHD.DiskNumber
# $DiskPartScript | Out-File -FilePath $DiskPartScriptFile
# Write-Host $DiskPartScript

# Start-Process -FilePath "diskpart.exe" -ArgumentList "/s",$DiskPartScriptFile -NoNewWindow -Wait
