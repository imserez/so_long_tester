# So Long Tester: Automated Map Validation Suite

![Language](https://img.shields.io/badge/Language-Bash-4EAA25.svg)
![Type](https://img.shields.io/badge/Type-Integration_Test-blue.svg)
![Target](https://img.shields.io/badge/Target-so__long-orange.svg)

## 📖 Overview

**So Long Tester** is a lightweight automation script designed to streamline the verification process of the *so_long* graphical project.

From a **Systems Engineering** perspective, relying on manual execution for testing is inefficient and prone to human error. This tool automates the integration testing phase by batch-processing map assets, executing the binary, and analyzing system exit codes to ensure robust parsing and execution stability.

It serves as a sanity check for valid maps, ensuring the game engine initializes memory, renders the window, and shuts down correctly (Exit Code 0) without segmentation faults or leaks.

## 🛠 Functional Logic

The script operates as a harness for the main executable:

1.  **Environment Validation:** Checks for the existence of the binary and asset directories before execution.
2.  **Batch Iteration:** Loops through a defined directory of map files (`.ber`).
3.  **Process Execution & Monitoring:** Runs the game binary for each map, redirecting `stderr` to `stdout` to capture runtime errors.
4.  **Exit Code Analysis:** Captures the return status (`$?`) of the process.
    * `0`: Success (Game loaded and closed gracefully).
    * `!= 0`: Failure (Crash, segfault, or improper error handling).
5.  **Aggregated Reporting:** Collects failed cases into an array and presents a final summary, eliminating the need to scroll through logs.

## 📂 Project Structure

To use this tester effectively, your directory should look like this:

```text
.
├── tester.sh          # This script
├── so_long            # Your compiled game binary
└── maps_valid/        # Directory containing valid .ber maps
    ├── map1.ber
    ├── map2.ber
    └── ...
```
## 🚀 Usage

### 1. Setup

Ensure the script has execution permissions:

```bash
chmod +x tester.sh
```

### 2. Configuration (Optional)

Open the script and adjust the top variables if your binary name or map folder differs:

```bash
EXECUTABLE="./so_long"
MAPS_DIR="maps_valid"
```
### 3. Execution

Run the tester from your project root:

```bash
./tester.sh
```
> **Note:** Since this tests valid maps on a graphical project, you will need to manually close the game window for each test to proceed to the next one. The script monitors the exit code generated upon closure.

## 📊 Output Example

The script provides colored output for immediate visual feedback:


## 👨‍💻 Author

**Sergi Juarez** *Systems Software Engineer | RISC-V & Kernel Enthusiast*

- **GitHub:** [imserez](https://github.com/imserez)
- **LinkedIn:** [sergijuarez](https://www.linkedin.com/in/sergijuarez)

---
*This project is part of the 42 Barcelona curriculum.*

