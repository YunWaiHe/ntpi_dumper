
"""
PyInstaller spec file for NTPI Firmware Extraction Tool
Optimized for Windows distribution with multiprocessing support
"""

block_cipher = None

# Import version information
import sys
import os
sys.path.insert(0, os.path.abspath('.'))
from version import __version__, VERSION_TUPLE, __product_name__, __description__, __author__, __copyright__

a = Analysis(
    ['ntpi_main.py'],
    pathex=[],
    binaries=[],
    datas=[
      
    ],
    hiddenimports=[
        'version',
        'multiprocessing',
        'multiprocessing.pool',
        'multiprocessing.managers',
        'multiprocessing.spawn',
        'multiprocessing.synchronize',
        'multiprocessing.process',
        'multiprocessing.reduction',
        'multiprocessing.util',
        'colorama',
        'tqdm',
        'Crypto',
        'Crypto.Cipher',
        'Crypto.Cipher.AES',
        'Crypto.Util',
        'Crypto.Util.Padding',
        'utils',
        'utils.structures',
        'utils.crypto',
        'utils.parser',
        'utils.extractor',
        'ctypes',
        'lzma',
        'hashlib',
        'xml.etree.ElementTree',
        'argparse',
        'pathlib',
        'shutil',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'test',
        'unittest',
        'pydoc',
        'doctest',
        'setuptools',
        'pip',
        'wheel',
        'distutils',
        'email',
        'http',
        'urllib',
        'xmlrpc',
        'concurrent.futures',
        'IPython',
        'jupyter',
        'notebook',
        'matplotlib',
        'numpy',
        'pandas',
        'scipy',
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)


pyz = PYZ(
    a.pure,
    a.zipped_data,
    cipher=block_cipher
)


exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='ntpi_dumper',
    debug=False,
    bootloader_ignore_signals=False,
    strip=True,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=None,
    version='version_info.txt',  # Use version info file
)
