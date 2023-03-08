Import-Module dbatools

$SqlInstance = "sfpv-sqls090"
$Database = "HiveLLP"

$path = Split-Path -Parent $PSCommandPath;

$queries = @{
  generate_md_doc = (Get-Content "$path\generate-md-doc.sql" -Raw);
};

Invoke-DbaQuery -SqlInstance $SqlInstance -Database $Database -Query $queries.generate_md_doc | ForEach-Object {
  $full_path = $path + "/" + $_.md_path;
  $save_path = Split-Path $full_path;
  
  if (-Not (Test-Path $save_path)) {
    New-Item -Path $save_path -ItemType Directory 
  }
  $_.md | Out-File -FilePath $full_path -Force 
}
