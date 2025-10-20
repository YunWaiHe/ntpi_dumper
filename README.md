# NTPI Dumper

[![Build and Release](https://github.com/YunWaiHe/ntpi_dumper/actions/workflows/build-release.yml/badge.svg)](https://github.com/YunWaiHe/ntpi_dumper/actions/workflows/build-release.yml)
[![Latest Release](https://img.shields.io/github/v/release/YunWaiHe/ntpi_dumper)](https://github.com/YunWaiHe/ntpi_dumper/releases/latest)
[![License](https://img.shields.io/github/license/YunWaiHe/ntpi_dumper)](LICENSE)

NTPI firmware extraction tool for Nothing Phone with multi-threaded optimization for large files.

**Supports:** NTPI version 1.3.0

**💬 Issues, Pull Requests, and Forks are welcome!**

## Quick Start

### 1. Download

Get the latest release from [Releases](https://github.com/YunWaiHe/ntpi_dumper/releases/latest):

- **ntpi_dumper_x86_64.exe** - For 64-bit Windows (Recommended)
- **ntpi_dumper_x86.exe** - For 32-bit Windows (Compatible with both 32-bit and 64-bit)

### 2. Extract Firmware

**Method 1: Drag & Drop**
- Simply drag your `.ntpi` file onto the executable

**Method 2: Command Line**
```bash
ntpi_dumper_x86_64.exe firmware.ntpi
```

**Method 3: Custom Options**
```bash
# Custom output directory and 4 parallel processes
ntpi_dumper_x86_64.exe -f firmware.ntpi -o output_dir -p 4
```

### 3. Verify Download (Optional)

```powershell
(Get-FileHash -Algorithm SHA256 ntpi_dumper_x86_64.exe).Hash
```
Compare with the SHA256 checksum in the release notes.

## Features

- ✅ NTPI firmware file parsing and extraction
- ✅ Multi-process parallel processing for large files
- ✅ AES-CBC encrypted data decryption
- ✅ LZMA2 compressed data decompression
- ✅ Progress indicators with colored output
- ✅ Standalone executable - no installation required

## Command Line Options

```bash
ntpi_dumper_x86_64.exe [options] <file.ntpi>

Options:
  -f, --file PATH       Input NTPI file path
  -o, --output DIR      Output directory (default: <filename>_extracted)
  -p, --processes NUM   Number of parallel processes (default: 2)
  --keep-temp           Keep temporary files for debugging
  -v, --version         Show version information
  -h, --help            Show help message
```

## Building from Source

**Requirements:** Python 3.11+

```bash
# Clone repository
git clone https://github.com/YunWaiHe/ntpi_dumper.git
cd ntpi_dumper

# Install dependencies
pip install -r requirements.txt

# Run directly
python ntpi_main.py firmware.ntpi

# Build executable (optional)
pip install pyinstaller
pyinstaller ntpi_main.spec
```

## Known Limitations

- Currently supports NTPI version 1.3.0 only
- Some extracted files may require further processing
- Windows only (Linux/macOS support planned)

## 🚨 Critical Issues - Help Needed

We are actively seeking solutions for the following critical issues:

### 1. Performance Issues
- **Large file processing** - Extraction speed degrades significantly with files > 2GB
- **Memory usage** - High memory consumption during parallel processing
- **I/O bottleneck** - Disk write operations become bottleneck on slower drives

**Contributions welcome:** Optimization strategies, alternative algorithms, or architectural improvements.

### 2. Version Compatibility Issues
- **NTPI version detection** - Need automatic version detection mechanism
- **Multi-version support** - Currently only supports v1.3.0, need support for other versions
- **Format changes** - Different NTPI versions may have different encryption/compression schemes

**Contributions welcome:** Version detection code, decryption keys for other versions, or documentation about NTPI format variations.

If you have expertise in these areas or access to different NTPI versions for testing, please open an issue or submit a PR!

## The 'Don't Blame Us' Disclaimer

This code/project comes with zero warranties and even fewer guarantees.

We are not responsible for anything that happens, including—but definitely not limited to—your keyboard catching fire, your impending existential crisis, or the total implosion of the planet Earth.

If you sue us, I will LMAO.

## License

See [LICENSE](LICENSE) for details.
