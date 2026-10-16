$sourceTags = Join-Path (Split-Path -Parent $PSScriptRoot) 'tags'
$destinationTags = 'E:\Games\Steam\steamapps\common\Enshrouded\mods\Minor CN Fixes\src\tags'

New-Item -ItemType Directory -Path $destinationTags -Force | Out-Null

Get-ChildItem -Path $sourceTags -File -Filter '*.json' |
	Where-Object { $_.BaseName -match '(?i)mistranslation.*tags|tags.*mistranslation|notranslation.*tags|tags.*notranslation' } |
	Copy-Item -Destination $destinationTags -Force
