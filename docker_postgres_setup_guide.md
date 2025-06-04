# 🚀 Docker + PostgreSQL Setup Guide for Students

This guide walks you through setting up Docker and running a PostgreSQL container using `docker-compose`, depending on your system (Windows, Ubuntu, or macOS).

---

## 🪟 1. For Windows Users (WSL2 + Docker Desktop)

### Step 1: Install Ubuntu on WSL
1. Open PowerShell as Administrator:
   ```bash
   wsl --install
   ```
2. Restart your computer if prompted.
3. Ubuntu installs automatically after reboot. Set up username/password.

### Step 2: Install Docker Desktop
- Download: https://www.docker.com/products/docker-desktop/
- During setup, check “Enable WSL 2 integration”.

### Step 3: Enable Docker WSL Integration
- Open Docker Desktop → Settings → Resources → WSL Integration
- Toggle on for Ubuntu

### Step 4: Confirm Installation
In Ubuntu terminal:
```bash
docker --version
docker-compose --version
docker info
```

---

### Step 5: Create docker-compose.yml
```bash
mkdir pgtest && cd pgtest
nano docker-compose.yml
```
Paste:
```yaml
version: "3.8"
services:
  db:
    image: postgres:14
    container_name: bootcamp_postgres
    environment:
      POSTGRES_USER: student
      POSTGRES_PASSWORD: studentpass
      POSTGRES_DB: bootcamp_db
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

---

### Step 6: Bring Container Up
```bash
docker compose up -d
```

### Step 7: Check Container
```bash
docker ps
```

### Step 8: Bring Container Down
```bash
docker compose down
```

---

## 🐧 2. For Ubuntu Linux Users

### Step 1: Install Docker
```bash
sudo apt update
sudo apt install docker.io docker-compose -y
```

### Step 2: Enable Docker
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### Step 3: Confirm Installation
```bash
docker --version
docker-compose --version
docker info
```

### Step 4 to 8: Same as Windows (above)

---

## 🍎 3. For Mac Users (Intel or Apple Silicon)

### Step 1: Install Docker Desktop
- Download: https://www.docker.com/products/docker-desktop/
- Install and grant necessary permissions

### Step 2: Confirm Installation
```bash
docker --version
docker-compose --version
docker info
```

### Step 3 to 6: Same as Windows (above)

---

## ✅ Final Notes
- PostgreSQL exposed at **localhost:5432**
- Connect via GUI (e.g. DBeaver):
  - Host: `localhost`
  - User: `student`
  - Password: `studentpass`
  - DB: `bootcamp_db`
