# Ruta de salida
#$output = "$env:TEMP\info.txt"
$output = "$env:USERPROFILE\Desktop\info.txt"


# --- Programas instalados ---
Add-Content -Path $output -Value "=== PROGRAMAS INSTALADOS ===`n"

# Desde el registro (x64 + x86)
$paths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($path in $paths) {
    Get-ItemProperty $path -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName } |
    Select-Object DisplayName, DisplayVersion |
    ForEach-Object {
        Add-Content -Path $output -Value "$($_.DisplayName) - $($_.DisplayVersion)"
    }
}

# --- Carpeta de descargas del usuario ---
Add-Content -Path $output -Value "`n=== ARCHIVOS EN DESCARGAS ===`n"

$downloads = "$env:USERPROFILE\Downloads"
if (Test-Path $downloads) {
    Get-ChildItem -Path $downloads -Recurse -ErrorAction SilentlyContinue |
    Select-Object FullName |
    ForEach-Object {
        Add-Content -Path $output -Value $_.FullName
    }
} else {
    Add-Content -Path $output -Value "No se encontró la carpeta de Descargas."
}
