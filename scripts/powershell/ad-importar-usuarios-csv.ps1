<#
.SYNOPSIS
    Importa usuarios en Active Directory desde un fichero CSV.
.EXAMPLE
    .\ad-importar-csv.ps1 -FicheroCSV ".\usuarios-ejemplo.csv" -Servidor "IP-DC"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$FicheroCSV,
    [Parameter(Mandatory=$false)]
    [string]$Servidor = "IP-DE-TU-DC"
)

Import-Module ActiveDirectory

if (-not (Test-Path $FicheroCSV)) {
    Write-Error "No se encuentra el fichero: $FicheroCSV"
    exit 1
}

$dominio  = (Get-ADDomain -Server $Servidor).DistinguishedName
$passTemp = ConvertTo-SecureString "Practica2024!" -AsPlainText -Force
$usuarios = Import-Csv -Path $FicheroCSV
$creados  = 0
$errores  = 0

Write-Host "=== Importando $($usuarios.Count) usuarios desde $FicheroCSV ==="

foreach ($u in $usuarios) {
    $rutaOU = "OU=$($u.OU),$dominio"

    if (Get-ADUser -Filter "SamAccountName -eq '$($u.Usuario)'" -Server $Servidor -ErrorAction SilentlyContinue) {
        Write-Warning "  $($u.Usuario) ya existe — omitido"
        continue
    }

    try {
        New-ADUser `
            -Server               $Servidor `
            -Name                 "$($u.Nombre) $($u.Apellido)" `
            -GivenName            $u.Nombre `
            -Surname              $u.Apellido `
            -SamAccountName       $u.Usuario `
            -UserPrincipalName    "$($u.Usuario)@lab.local" `
            -Path                 $rutaOU `
            -Department           $u.Departamento `
            -AccountPassword      $passTemp `
            -ChangePasswordAtLogon $true `
            -Enabled              $true

        Write-Host "  OK: $($u.Usuario) - $($u.Nombre) $($u.Apellido) ($($u.Departamento))" -ForegroundColor Green
        $creados++
    } catch {
        Write-Host "  ERROR: $($u.Usuario): $_" -ForegroundColor Red
        $errores++
    }
}

Write-Host "=== Resultado ==="
Write-Host "  Creados : $creados"
Write-Host "  Errores : $errores"
Write-Host "  Omitidos: $($usuarios.Count - $creados - $errores)"
