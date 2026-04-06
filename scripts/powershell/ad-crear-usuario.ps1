<#
.SYNOPSIS
    Crea un usuario en Active Directory y lo asigna a una OU.
.EXAMPLE
    .\ad-crear-usuario.ps1 -Nombre "Juan Garcia" -Usuario "jgarcia" -OU "Usuarios" -Departamento "Informatica"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Nombre,
    [Parameter(Mandatory=$true)]
    [string]$Usuario,
    [Parameter(Mandatory=$false)]
    [string]$OU = "Usuarios",
    [Parameter(Mandatory=$false)]
    [string]$Departamento = "General",
    [Parameter(Mandatory=$false)]
    [string]$Servidor = "IP-DE-TU-DC"
)

Import-Module ActiveDirectory -ErrorAction Stop

$partes   = $Nombre.Split(" ")
$nombre   = $partes[0]
$apellido = if ($partes.Count -gt 1) { $partes[1..($partes.Count-1)] -join " " } else { "" }
$dominio  = (Get-ADDomain -Server $Servidor).DistinguishedName
$rutaOU   = "OU=$OU,$dominio"
$passTemp = ConvertTo-SecureString "Practica2024!" -AsPlainText -Force

if (Get-ADUser -Filter "SamAccountName -eq '$Usuario'" -Server $Servidor -ErrorAction SilentlyContinue) {
    Write-Warning "El usuario '$Usuario' ya existe en el dominio."
    exit 1
}

try {
    New-ADUser `
        -Server               $Servidor `
        -Name                 $Nombre `
        -GivenName            $nombre `
        -Surname              $apellido `
        -SamAccountName       $Usuario `
        -UserPrincipalName    "$Usuario@lab.local" `
        -Path                 $rutaOU `
        -Department           $Departamento `
        -AccountPassword      $passTemp `
        -ChangePasswordAtLogon $true `
        -Enabled              $true

    Write-Host "Usuario '$Usuario' creado en OU '$OU'" -ForegroundColor Green
    Write-Host "   Nombre      : $Nombre"
    Write-Host "   Departamento: $Departamento"
    Write-Host "   Password    : Practica2024! (debe cambiarla al primer login)"
} catch {
    Write-Error "Error al crear el usuario: $_"
    exit 1
}
