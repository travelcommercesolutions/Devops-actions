$moduleJsonPath = $env:MODULE_JSON_PATH
$module_manifest_path = $env:MODULE_MANIFEST_PATH
$packageUrl = $env:PACKAGE_URL
$version = $env:VERSION

$module_manifest = [XML](Get-Content -Path $module_manifest_path)
$module_name = $module_manifest.module.id
$data = Get-Content -Path $moduleJsonPath | ConvertFrom-Json
$module = $data | Where-Object -Property "id" -Value $module_name -EQ
$module.packageUrl = $packageUrl
$module.version = $version
$dependencies = @()
  foreach ($dependency in $module_manifest.module.dependencies.dependency) {
    $dependencies += @{
      id = $dependency.id
      version = $dependency.version
    }
  }
  $module.dependencies = $dependencies
$data | ConvertTo-Json -Depth 3 | Out-File $moduleJsonPath
