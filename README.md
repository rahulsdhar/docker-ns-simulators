# docker-ns-simulators

Run **ns-2** and **ns-3** network simulators inside Docker with GUI support on both **Windows** and **Linux** systems.  
This repository provides ready-to-use Dockerfiles and helper scripts to simplify setup, execution, and visualization.

---

## 📦 Features
- Dockerized builds for **ns-2** and **ns-3**.
- GUI support via X11 forwarding (works with VcXsrv/Xming on Windows, native X11 on Linux).
- Cross-platform automation scripts:
  - `.bat` files for Windows
  - `.sh` files for Linux
- Volume mounting of a `code/` directory for easy access to your ns simulation scripts.
- Includes **nam** (Network Animator) for ns-2 and visualization tools for ns-3.

---

## 📂 Repository Structure
```
.
├── Dockerfile.ns2        # Dockerfile for ns-2
├── Dockerfile.ns3        # Dockerfile for ns-3
├── run_ns2.bat           # Windows batch script for ns-2
├── run_ns3.bat           # Windows batch script for ns-3
├── run_ns2.sh            # Linux shell script for ns-2
├── run_ns3.sh            # Linux shell script for ns-3
└── code/                 # Place your ns simulation scripts here
```

---

## 🚀 Getting Started

### Windows
1. Install **Docker Desktop**.
2. Install an X server (e.g., [VcXsrv](https://sourceforge.net/projects/vcxsrv/)).
3. Run the batch file:
   ```cmd
   run_ns2.bat
   ```
   or
   ```cmd
   run_ns3.bat
   ```
4. Place your simulation scripts in the `code/` folder. They will be available inside the container at `/opt/ns2/code` or `/opt/ns3/code`.

---

### Linux
1. Ensure Docker is installed and running.
2. Verify your X server is active (usually already running in desktop environments).
3. Run the shell script:
   ```bash
   ./run_ns2.sh
   ```
   or
   ```bash
   ./run_ns3.sh
   ```
4. Place your simulation scripts in the `code/` folder. They will be available inside the container at `/opt/ns2/code` or `/opt/ns3/code`.

---

## 🧪 Testing GUI
Inside the container, run:
```bash
xeyes
```
If you see the eyes window, GUI forwarding works.  
For ns-2, test with:
```bash
nam
```

---

## 🤝 Contributing
Pull requests are welcome! If you find issues or want to add enhancements (e.g., NetAnim integration for ns-3), feel free to open an issue or PR.

---

## 📜 License
This project is licensed under the Apache 2.0 Licence.
```

---

This README gives users a clear overview, setup instructions for both platforms, and a professional structure.