# 🚀 LAMP Installer Script

Automate your **LAMP stack setup** on Linux servers with **one click**! This script installs and configures **Apache, MariaDB, and PHP**, making server setup fast, reliable, and reproducible.  

![Linux](https://img.shields.io/badge/Linux-Compatible-blue) ![Bash](https://img.shields.io/badge/Shell-Bash-green) ![MariaDB](https://img.shields.io/badge/DB-MariaDB-orange) ![PHP](https://img.shields.io/badge/PHP-8.x-purple) ![License](https://img.shields.io/badge/License-MIT-blue)

---

## 🌟 Features

✅ Auto-detects Linux distribution (**Debian/Ubuntu** or **CentOS/RHEL**)  
✅ Installs & configures **Apache/HTTPD**  
✅ Installs & configures **MariaDB** (MySQL alternative)  
✅ Creates **databases & users** with proper privileges  
✅ Installs **PHP** with required modules  
✅ Creates `phptest.php` to verify PHP setup  
✅ Automatically **starts & enables all services**

---

## 📁 Project Structure

```
├─ lamp_install.sh # Main installation script
├─ README.md # Project documentation
└─ lamp_install.log # Installation log file   
```

---

## ⚙️ Prerequisites

- Linux server (Ubuntu/Debian or CentOS/RHEL)  
- Root or sudo privileges  
- Internet access for package installation  

---

## 🛠 Installation & Usage

### 1️⃣ Clone the repository

```bash
git clone https://github.com/<your-username>/lamp_installer.git
cd lamp_installer
```

### 2️⃣ Make the script executable

```bash
chmod +x lamp_install.sh
```

### 3️⃣ Run the installer

```bash
./lamp_install.sh
```

### 4️⃣ Verify installation

- Apache default page: `http://<server-ip>/`  
- PHP info page: `http://<server-ip>/phptest.php`  

> 💡 Tip: Replace `<server-ip>` with your server's public or private IP address.

---

## 🎯 Learning Outcomes

- Automating package management with **apt**, **yum**, or **dnf**  
- Service management with **systemctl**  
- Database automation using **MariaDB SQL scripts**  
- Writing **portable & reusable Bash scripts** for Linux  

---

## 💡 Pro Tips

- Extendable for **more PHP modules or web services**  
- Perfect for **development environments** or **quick server setups**  
- Great hands-on project for **Linux sysadmin & DevOps practice**  

---
