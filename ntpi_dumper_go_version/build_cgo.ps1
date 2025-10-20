# Build script for NTPI Dumper Go with CGO (using bundled xz_source)
# Windows PowerShell

Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Building NTPI Dumper Go with CGO Support       ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Change to project directory
Set-Location $PSScriptRoot

# Check for GCC
Write-Host "[1/5] Checking for GCC compiler..." -ForegroundColor Yellow
if (-not (Get-Command gcc -ErrorAction SilentlyContinue)) {
    Write-Host "✗ GCC not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "To install GCC on Windows:" -ForegroundColor Yellow
    Write-Host "  1. Install MSYS2 from: https://www.msys2.org/" -ForegroundColor White
    Write-Host "  2. Run: pacman -S mingw-w64-x86_64-gcc" -ForegroundColor White
    Write-Host "  3. Add to PATH: C:\msys64\mingw64\bin" -ForegroundColor White
    Write-Host ""
    exit 1
}
Write-Host "✓ GCC found: $(gcc --version | Select-Object -First 1)" -ForegroundColor Green
Write-Host ""

# Set up xz_source paths
$xzSourceDir = Join-Path $PSScriptRoot "xz_source"
$xzIncludeDir = Join-Path $xzSourceDir "include"
$xzBinDir = Join-Path $xzSourceDir "bin_x86-64"
$xzDllPath = Join-Path $xzBinDir "liblzma.dll"

# Verify xz_source files
Write-Host "[2/5] Checking xz_source directory..." -ForegroundColor Yellow
if (-not (Test-Path $xzIncludeDir)) {
    Write-Host "✗ xz_source/include directory not found!" -ForegroundColor Red
    exit 1
}
if (-not (Test-Path $xzDllPath)) {
    Write-Host "✗ xz_source/bin_x86-64/liblzma.dll not found!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ xz_source files found" -ForegroundColor Green
Write-Host "  - Include: $xzIncludeDir" -ForegroundColor Gray
Write-Host "  - Library: $xzDllPath" -ForegroundColor Gray
Write-Host ""

# Download Go dependencies
Write-Host "[3/5] Downloading Go dependencies..." -ForegroundColor Yellow
go mod tidy
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to download dependencies!" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencies ready" -ForegroundColor Green
Write-Host ""

# Set CGO environment variables
Write-Host "[4/5] Configuring CGO build environment..." -ForegroundColor Yellow

# Convert to absolute paths with forward slashes for CGO
$xzIncludeAbs = (Resolve-Path $xzIncludeDir).Path.Replace('\', '/')
$xzBinAbs = (Resolve-Path $xzBinDir).Path.Replace('\', '/')

$env:CGO_ENABLED = "1"
$env:CGO_CFLAGS = "-I$xzIncludeAbs"
$env:CGO_LDFLAGS = "-L$xzBinAbs -llzma"

Write-Host "✓ CGO environment configured" -ForegroundColor Green
Write-Host "  - CGO_ENABLED: $env:CGO_ENABLED" -ForegroundColor Gray
Write-Host "  - CGO_CFLAGS: $env:CGO_CFLAGS" -ForegroundColor Gray
Write-Host "  - CGO_LDFLAGS: $env:CGO_LDFLAGS" -ForegroundColor Gray
Write-Host ""

# Build with CGO
Write-Host "[5/5] Compiling with CGO..." -ForegroundColor Yellow
$buildStart = Get-Date

go build -tags cgo -ldflags="-s -w" -o ntpi-dumper-cgo.exe ./cmd/ntpi-dumper

$buildEnd = Get-Date
$buildTime = ($buildEnd - $buildStart).TotalSeconds

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Build successful!" -ForegroundColor Green
Write-Host ""

# Copy DLL to output directory
Write-Host "Copying liblzma.dll to output directory..." -ForegroundColor Yellow
Copy-Item $xzDllPath -Destination "." -Force
Write-Host "✓ liblzma.dll copied" -ForegroundColor Green
Write-Host ""

# Show build results
Write-Host "╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║            Build Completed Successfully!         ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

$exeSize = (Get-Item ntpi-dumper-cgo.exe).Length / 1MB
$dllSize = (Get-Item liblzma.dll).Length / 1KB

Write-Host "Output files:" -ForegroundColor Cyan
Write-Host "  • ntpi-dumper-cgo.exe  : $([math]::Round($exeSize, 2)) MB" -ForegroundColor White
Write-Host "  • liblzma.dll          : $([math]::Round($dllSize, 2)) KB" -ForegroundColor White
Write-Host ""
Write-Host "Build mode  : CGO (High-Performance)" -ForegroundColor Cyan
Write-Host "Build time  : $([math]::Round($buildTime, 2)) seconds" -ForegroundColor Cyan
Write-Host "Performance : 10-20x faster LZMA2 decompression vs Pure Go" -ForegroundColor Green
Write-Host ""

Write-Host "Usage:" -ForegroundColor Yellow
Write-Host "  .\ntpi-dumper-cgo.exe <file.ntpi>" -ForegroundColor White
Write-Host ""
Write-Host "Note: Keep liblzma.dll in the same directory as the executable!" -ForegroundColor Yellow
Write-Host ""
