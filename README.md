# iPhone-Content-Backup

A PowerShell script to automate the process of copying media files from an iPhone's Internal Storage to a designated folder on your PC. This script ensures all files are copied, verifies their existence, and can copy any missing files if required.

## Features
- Automatically detects your connected iPhone.
- Copies media files from iPhone's `Internal Storage`, including:
  - Images: `.jpg`, `.png`, `.HEIC`
  - Videos: `.mp4`, `.mov`, `.3gp`
- Ensures file integrity by verifying copied files.
- Handles folder structure to keep files organized.
- Displays detailed logs, including file counts and folder sizes.
- Copies any missing files automatically.

## Supported File Types
The script supports the following file types:
- Images: `.jpg`, `.png`, `.HEIC`
- Videos: `.mp4`, `.mov`, `.3gp`

## Prerequisites
1. A Windows PC running PowerShell (Windows 10 or 11 recommended).
2. An iPhone connected to the PC via USB.
3. The iPhone must be unlocked, and you must allow access to the device when prompted.
4. Ensure you have sufficient storage space in the destination folder.

## How to Use

1. **Download the Script**
   - Clone the repository:
     ```bash
     git clone https://github.com/pswamis/iPhone-Content-Backup.git
     ```
   - Or download the script directly as a ZIP file and extract it.

2. **Connect Your iPhone**
   - Connect your iPhone to the PC via USB.
   - Unlock the iPhone and allow the PC to access the device's storage.

3. **Run the Script**
   - Open PowerShell in the directory where the script is located.
   - Modify the `$destinationPath` as per your local machine path
   - Execute the script:
     ```powershell
     .\verify_iphone_files.ps1
     ```
   - Follow the on-screen instructions.

4. **Review Logs**
   - The script provides detailed logs, including:
     - Number of files found in the source folder.
     - Size of each folder and total size of files.
     - Missing files, if any.
     - Confirmation of successfully copied files.

## Example Output
- Found 3 folders in source with 120 files (Total size: 1.2 GB)
- Found 2 folders in destination with 100 files (Total size: 1.0 GB)
- Missing files: 20 Copying missing files... Missing files
- copied: 20


## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contribution
Feel free to fork this repository and submit pull requests. Contributions are welcome!

