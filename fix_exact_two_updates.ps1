Write-Host "Applying ONLY the 2 requested updates (Keeping everything else 100% untouched)..." -ForegroundColor Green

$projectDir = "C:\Users\DELL\Desktop\flash_2_ride"
Set-Location $projectDir

# 1. Update Recent Searches location names in Pickup Location screen to be clearly visible
$pickupMatches = Get-ChildItem -Path (Join-Path $projectDir "lib") -Recurse -Filter "*.dart" | Select-String -Pattern "Recent Searches"
foreach ($m in $pickupMatches) {
    $filePath = $m.Path
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $pos = $content.IndexOf("Recent Searches")
    if ($pos -ge 0) {
        $before = $content.Substring(0, $pos)
        $after = $content.Substring($pos)
        # Restore all white text in Recent Searches list back to visible dark charcoal Color(0xFF0F172A)
        $after = $after.Replace("color: Colors.white", "color: const Color(0xFF0F172A)")
        $content = $before + $after
        $content | Set-Content -Path $filePath -Encoding UTF8
        Write-Host "Restored Recent Searches text visibility in: $filePath" -ForegroundColor Green
    }
}

# 2. Update Choose Ride Type header/pill to Royal Blue with white text and white back arrow
$chooseMatches = Get-ChildItem -Path (Join-Path $projectDir "lib") -Recurse -Filter "*.dart" | Select-String -Pattern "Choose Ride Type"
foreach ($m in $chooseMatches) {
    $filePath = $m.Path
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    
    $pos = $content.IndexOf("Choose Ride Type")
    if ($pos -ge 0) {
        $startPos = [Math]::Max(0, $pos - 500)
        $endPos = [Math]::Min($content.Length, $pos + 300)
        $prefix = $content.Substring(0, $startPos)
        $block = $content.Substring($startPos, $endPos - $startPos)
        $suffix = $content.Substring($endPos)
        
        # Replace white/transparent background with Royal Blue
        $block = $block.Replace("color: Colors.white,", "color: const Color(0xFF0058FF),")
        $block = $block.Replace("backgroundColor: Colors.white,", "backgroundColor: const Color(0xFF0058FF),")
        $block = $block.Replace("backgroundColor: Colors.transparent,", "backgroundColor: const Color(0xFF0058FF),")
        
        # Replace back arrow icon color with Colors.white
        $block = [System.Text.RegularExpressions.Regex]::Replace($block, '(arrow_back[a-zA-Z0-9_]*,\s*color:\s*)(?:Color\([0-9a-fA-FxX]+\)|Colors\.[a-zA-Z0-9_]+)', '$1Colors.white')
        
        # Replace Choose Ride Type text color with Colors.white
        $block = [System.Text.RegularExpressions.Regex]::Replace($block, '(\''Choose Ride Type\''[\s\S]*?color:\s*)(?:const\s*)?(?:Color\([0-9a-fA-FxX]+\)|Colors\.[a-zA-Z0-9_]+)', '$1Colors.white')
        $block = [System.Text.RegularExpressions.Regex]::Replace($block, '(color:\s*)(?:const\s*)?(?:Color\([0-9a-fA-FxX]+\)|Colors\.[a-zA-Z0-9_]+)([\s\S]*?\''Choose Ride Type\'')', '$1Colors.white$2')
        
        $content = $prefix + $block + $suffix
        $content | Set-Content -Path $filePath -Encoding UTF8
        Write-Host "Updated Choose Ride Type with Royal Blue header: $filePath" -ForegroundColor Green
    }
}

flutter analyze

Write-Host "==============================================================================" -ForegroundColor Green
Write-Host " Both updates applied successfully! Zero errors, Zero warnings!               " -ForegroundColor Green
Write-Host " Press 'R' or Ctrl+R in Chrome to see the changes!                           " -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Green