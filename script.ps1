# GridPulse — ENTSO-E smoke requests (PowerShell 5.1+, robust)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Load-DotEnv {
  param([Parameter(Mandatory = $true)][string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    throw ".env not found at: $Path. Copy .env.example to .env and set ENTSOE_API_KEY."
  }

  Get-Content -LiteralPath $Path -Encoding UTF8 | ForEach-Object {
    $line = $_.Trim()
    if ($line.Length -eq 0) { return }
    if ($line.StartsWith("#")) { return }

    $m = [regex]::Match($line, '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$')
    if (-not $m.Success) { return }

    $key = $m.Groups[1].Value
    $val = $m.Groups[2].Value

    if (($val.StartsWith('"') -and $val.EndsWith('"')) -or ($val.StartsWith("'") -and $val.EndsWith("'"))) {
      $val = $val.Substring(1, $val.Length - 2)
    }

    Set-Item -Path ("Env:{0}" -f $key) -Value $val
  }
}

function Build-EntsoeUrl {
  param([Parameter(Mandatory=$true)][hashtable]$Query)

  $builder = New-Object System.UriBuilder("https://web-api.tp.entsoe.eu/api")
  $nv = [System.Web.HttpUtility]::ParseQueryString("")
  foreach ($k in $Query.Keys) {
    $nv[$k] = [string]$Query[$k]
  }
  $builder.Query = $nv.ToString()
  return $builder.Uri.AbsoluteUri
}

function Curl-Xml {
  param([Parameter(Mandatory=$true)][string]$Url)
  & curl.exe -L $Url
}

# --- Load .env (local only) ---
$envPath = Join-Path -Path $PSScriptRoot -ChildPath ".env"
Load-DotEnv -Path $envPath

# --- PS 5.1-safe token retrieval (no ?? operator) ---
$token = $env:ENTSOE_API_KEY
if ($null -eq $token) { $token = "" }
$token = $token.Trim()

if ([string]::IsNullOrWhiteSpace($token)) {
  throw "ENTSOE_API_KEY is missing/empty in .env."
}

# --- Domains / bidding zones ---
$FR   = "10YFR-RTE------C"
$DELU = "10Y1001A1001A82H"
$BE   = "10YBE----------2"
$ES   = "10YES-REE------0"
$IT   = "10YIT-GRTN-----B"
$CH   = "10YCH-SWISSGRIDZ"

# --- Time window (UTC) ---
$start = "202312010000"
$end   = "202312020000"

Write-Host "=== (1) LOAD - A65 + A16 + outBiddingZone_Domain (FR, 24h) ==="
$u = Build-EntsoeUrl @{
  documentType = "A65"
  processType  = "A16"
  outBiddingZone_Domain = $FR
  periodStart  = $start
  periodEnd    = $end
  securityToken = $token
}
Curl-Xml $u

Write-Host "`n=== (2) GENERATION by type (Actual) - A75 + A16 + in_Domain (FR, 24h) ==="
$u = Build-EntsoeUrl @{
  documentType = "A75"
  processType  = "A16"
  in_Domain    = $FR
  periodStart  = $start
  periodEnd    = $end
  securityToken = $token
}
Curl-Xml $u

Write-Host "`n=== (3) FLOWS - A09 (FR -> DE-LU, 24h) ==="
$u = Build-EntsoeUrl @{
  documentType = "A09"
  out_Domain   = $FR
  in_Domain    = $DELU
  periodStart  = $start
  periodEnd    = $end
  securityToken = $token
}
Curl-Xml $u

Write-Host "`n=== (4) FLOWS - A09 (DE-LU -> FR, 24h) ==="
$u = Build-EntsoeUrl @{
  documentType = "A09"
  out_Domain   = $DELU
  in_Domain    = $FR
  periodStart  = $start
  periodEnd    = $end
  securityToken = $token
}
Curl-Xml $u

Write-Host "`n=== Done ==="
