$path = $Env:PATH_TO_ARCHIVE
$archive_name = $Env:ARCHIVE_NAME

function ArchiveFiles($path) {
  $compress = @{
    Path             = $path
    CompressionLevel = "Fastest"
    DestinationPath  = $archive_name
  }

  Compress-Archive @compress
  if (Test-Path $archive_name) {
    Write-Output "archive-name=$archive_name" >> $githubOutput
    Write-Host "$archive_name was created successfully"
  } else {
    Write-Host "Archive file was not created"
  }
}

if ($path.Split("`n").Length -gt 1) {
  $resultList = @()
  $pathList = $path.Split("`n")
  foreach ($item in $pathList) {
    $item = $item.Trim()
    $pathExists = Test-Path $item
    if ($pathExists) {
      $resultList += $item
    } else {
      Write-Host "Path '$item' does not exists"
    }
  }
  if ($resultList) {
    ArchiveFiles($resultList)
  } else {
    Write-Host "Nothing to archive"
  }
} else {
  $pathExists = Test-Path $path
  if ($pathExists) {
    ArchiveFiles($path)
  } else {
    Write-Host "Path '$path' does not exists"
  }
}