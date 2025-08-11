---
layout: post
title: "Comprehensive Linux Command Cheat Sheet"
date: 2025-08-11
categories: linux
author: Dan.C
tags: [linux, terminal, cheat-sheet, command-line, sysadmin, devops]
---
![Cover Image](/assets/images/linux-cheatsheet.jpg)

# 🐧 Linux Command Cheat Sheet

A curated reference guide to the most essential Linux commands — ideal for system administrators, developers, DevOps engineers, and cybersecurity professionals. Whether you're a beginner or brushing up your skills, this categorized cheat sheet will help streamline your command-line workflow.

---

## 🔍 File and Directory Operations

| Command | Description |
|--------|-------------|
| `ls` | List contents of the current directory |
| `ls -l` | List with detailed (long) format |
| `cd /path/to/dir` | Change current directory |
| `pwd` | Display present working directory |
| `mkdir new_folder` | Create a new directory |
| `rm file.txt` | Remove a file |
| `rm -r folder/` | Recursively remove a directory and its contents |
| `touch file.txt` | Create a new, empty file |
| `cp source dest` | Copy a file or directory |
| `mv old new` | Move or rename a file or directory |

---

## 🛠️ Viewing & Editing Files

| Command | Description |
|--------|-------------|
| `cat file.txt` | Output file contents to the terminal |
| `less file.txt` | View file one screen at a time (scrollable) |
| `head file.txt` | Show the first 10 lines of a file |
| `tail file.txt` | Show the last 10 lines of a file |
| `nano file.txt` | Edit file using Nano (beginner-friendly) |
| `vim file.txt` | Edit file using Vim (advanced editor) |

---

## 📁 Permissions & Ownership

| Command | Description |
|--------|-------------|
| `chmod +x script.sh` | Make a script executable |
| `chmod 755 file` | Set read/write/execute permissions (owner), and read/execute (group, others) |
| `chown user:group file` | Change file ownership |

---

## 🧠 System Information

| Command | Description |
|--------|-------------|
| `uname -a` | Show system and kernel information |
| `top` / `htop` | Real-time process and system monitoring |
| `df -h` | Display disk space usage (human-readable) |
| `free -h` | Show memory usage |
| `uptime` | Show how long the system has been running |

---

## 🔐 User & Process Management

| Command | Description |
|--------|-------------|
| `whoami` | Display current logged-in user |
| `id` | Show user ID (UID), group ID (GID), and groups |
| `ps aux` | List all running processes |
| `kill PID` | Terminate a process by its PID |
| `sudo command` | Run command with superuser privileges |
| `adduser username` | Add a new user |
| `passwd username` | Change a user's password |

---

## 🌐 Networking Commands

| Command | Description |
|--------|-------------|
| `ip a` | Display network interfaces and IP addresses |
| `ping domain.com` | Send ICMP packets to test connectivity |
| `curl https://example.com` | Fetch data from a URL |
| `netstat -tulpn` | Show active listening ports and services (legacy; use `ss` for modern systems) |
| `ssh user@host` | Connect to a remote host via SSH |

---

## 🧹 Package Management

### 📦 Debian/Ubuntu (APT)

| Command | Description |
|--------|-------------|
| `sudo apt update` | Update package lists |
| `sudo apt upgrade` | Upgrade installed packages |
| `sudo apt install package` | Install a new package |
| `sudo apt remove package` | Remove a package |

### 📦 Red Hat/CentOS (YUM/DNF)

| Command | Description |
|--------|-------------|
| `sudo yum install package` | Install package (YUM) |
| `sudo dnf upgrade` | Upgrade packages (DNF, successor to YUM) |

---

## 📝 Searching Files

| Command | Description |
|--------|-------------|
| `find / -name file.txt` | Search for a file by name starting from root |
| `grep 'pattern' file.txt` | Search for a text pattern in a file |
| `locate file.txt` | Quickly find file paths using an indexed database (`updatedb` required) |

---

## 💡 Keyboard Shortcuts & History

| Shortcut | Description |
|----------|-------------|
| `Ctrl + C` | Cancel the current running process |
| `Ctrl + D` | Logout of terminal or send EOF (End of File) |
| `Ctrl + R` | Search command history interactively |
| `!!` | Repeat the last command |
| `!abc` | Run the most recent command starting with `abc` |

---

## 📎 Notes

- Most of these commands are compatible across major Linux distributions.
- Prefix commands with `sudo` where administrative privileges are required.
- Consider bookmarking this page or exporting it as a printable PDF for offline reference.

*Stay efficient. Stay secure.*

\#Linux #SysAdmin #CommandLine #DevOps #CyberSecurity #TechTips
