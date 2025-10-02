# Features
	Auto-detects Linux distribution (Debian/Ubuntu or CentOS/RHEL).
	Installs & configures Apache/HTTPD.
    Installs & configures MariaDB (MySQL alternative).
	Creates a database, user, and grants privileges.
	Installs PHP with required modules.
	Creates a phptest.php file to verify PHP setup.
	Starts & enables all services automatically.

# Project Structure
 lamp_installer/
 
  lamp_install.sh   # Main installation script
  
  README.md         # Project documentation

# Prerequisites

Linux server (Ubuntu/Debian or CentOS/RHEL).

root or sudo privileges.

Internet access for package installation.

 Installation & Usage
1. Clone this repository:
git clone https://github.com/<your-username>/lamp_installer.git
cd lamp_installer

2. Make script executable:
chmod +x lamp_install.sh

3. Run the installer:
./lamp_install.sh
 Verification

4. After installation:

	Open a browser  http://<server-ip>/  Apache default page.
	Visit  http://<server-ip>/phptest.php  PHP info page.

5. Learning Outcomes
	Automating package management with apt, yum, dnf.
	Service management with systemctl.
	Database automation with MariaDB SQL scripts.
	Writing portable & reusable Bash scripts.
