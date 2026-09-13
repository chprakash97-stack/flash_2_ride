Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "FLASH2RIDE COMPLETE SCREEN & ROUTE AUDIT REPORT" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan

$projectRoot = $PWD
Write-Host "Project Root: $projectRoot" -ForegroundColor Yellow

# 1. ప్రాజెక్ట్ లో ఉన్న మొత్తం డార్ట్ ఫైల్స్ & విడ్జెట్ క్లాసెస్ లిస్ట్
Write-Host "`n[1. ALL EXISTING DART FILES IN LIB]" -ForegroundColor Yellow
$allDartFiles = Get-ChildItem -Path "$projectRoot\lib" -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue
Write-Host "Total Dart Files Found: $($allDartFiles.Count)" -ForegroundColor Cyan

$screenFiles = @()
foreach ($f in $allDartFiles) {
    $rel = $f.FullName.Replace($projectRoot, "").TrimStart("\")
    $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
    $classes = @()
    if ($content) {
        $foundMatches = [regex]::Matches($content, 'class\s+([A-Za-z0-9_]+)\s+extends\s+(StatefulWidget|StatelessWidget)')
        foreach ($m in $foundMatches) {
            $classes += $m.Groups.Value
        }
    }
    $classStr = if ($classes.Count -gt 0) { $classes -join ", " } else { "---" }
    $screenFiles += [PSCustomObject]@{
        "File Path" = $rel
        "Size (Bytes)" = $f.Length
        "Widget Class" = $classStr
    }
}
$screenFiles | Format-Table -AutoSize | Out-String | Write-Host

# 2. పోస్టర్ లోని 8 సెక్షన్ల (30 స్క్రీన్స్) చెక్‌లిస్ట్
Write-Host "`n[2. POSTER 30-SCREEN STATUS CHECKLIST]" -ForegroundColor Yellow

$masterScreens = @(
    # Section 1: Authentication & Onboarding (4 Screens)
    @{ Name = "1. Splash Screen"; Pattern = "splash_screen|SplashScreen" },
    @{ Name = "2. Login Screen"; Pattern = "login_screen|LoginScreen" },
    @{ Name = "3. OTP Verification Screen"; Pattern = "otp_screen|OtpScreen" },
    @{ Name = "4. Profile Setup Screen"; Pattern = "profile_setup|ProfileSetupScreen" },

    # Section 2: Home & Location Search (3 Screens)
    @{ Name = "5. Home & Live Map Screen"; Pattern = "home_screen|CustomerHomeScreen" },
    @{ Name = "6. Destination Search Screen"; Pattern = "location_search|DestinationSearch" },
    @{ Name = "7. Map Pin Picker Screen"; Pattern = "map_pin|saved_places" },

    # Section 3: Ride Booking & Categories (6 Screens)
    @{ Name = "8. Ride Category Selection (Bike/Auto/Cab)"; Pattern = "ride_selection|choose_ride" },
    @{ Name = "9. Schedule Ride Screen"; Pattern = "schedule_ride" },
    @{ Name = "10. Hourly Rentals Screen"; Pattern = "hourly_rentals|rental_selection" },
    @{ Name = "11. Flash Parcel Screen"; Pattern = "flash_parcel|parcel_booking|parcel_type" },
    @{ Name = "12. Street QR Scan Screen"; Pattern = "street_qr|qr_scan" },
    @{ Name = "13. Select Payment Method Screen"; Pattern = "payment_method" },

    # Section 4: Live Tracking, Communication & Safety (4 Screens)
    @{ Name = "14. Searching Captain (Finding Driver)"; Pattern = "finding_driver|searching_captain|searching_partner" },
    @{ Name = "15. Live Tracking Screen"; Pattern = "live_tracking" },
    @{ Name = "16. In-App Live Chat Screen"; Pattern = "in_ride_chat|driver_chat" },
    @{ Name = "17. Safety Toolkit & SOS Screen"; Pattern = "safety_toolkit|sos_emergency" },

    # Section 5: Trip Completion, Feedback & Receipt (3 Screens)
    @{ Name = "18. Ride Completion (Trip Completed)"; Pattern = "rating_tip|ride_completed" },
    @{ Name = "19. Trip Cancellation Screen"; Pattern = "cancel_ride" },
    @{ Name = "20. Trip Invoice & Receipt Screen"; Pattern = "trip_invoice|ride_details" },

    # Section 6: Wallet, Subscriptions & Rewards (3 Screens)
    @{ Name = "21. Flash Wallet Screen"; Pattern = "wallet_screen" },
    @{ Name = "22. Power Pass Screen"; Pattern = "power_pass" },
    @{ Name = "23. Refer & Earn Screen"; Pattern = "refer_earn" },

    # Section 7: Account, Saved Data & Support (4 Screens)
    @{ Name = "24. Saved Places Screen"; Pattern = "saved_places" },
    @{ Name = "25. Payment Methods Screen"; Pattern = "payment_methods|manage_payment" },
    @{ Name = "26. Help & Support Screen"; Pattern = "support_screen|help_support" },

    # Section 8: System, Settings & Legal (3 Screens)
    @{ Name = "27. Profile & Emergency Settings"; Pattern = "user_profile|profile_settings" },
    @{ Name = "28. Language Selection Screen"; Pattern = "language_screen" },
    @{ Name = "29. About Us & Legal Policy"; Pattern = "about_us|legal_policy" }
)

$allContent = @{}
foreach ($f in $allDartFiles) {
    $allContent[$f.FullName] = (Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue)
}

foreach ($item in $masterScreens) {
    $foundMatch = $null
    foreach ($path in $allContent.Keys) {
        $fileName = [System.IO.Path]::GetFileName($path)
        $text = $allContent[$path]
        if ($fileName -match $item.Pattern -or $text -match $item.Pattern) {
            $rel = $path.Replace($projectRoot, "").TrimStart("\")
            $foundMatch = $rel
            break
        }
    }
    if ($foundMatch) {
        Write-Host ("[EXISTS]  " + $item.Name.PadRight(45) + " -> " + $foundMatch) -ForegroundColor Green
    } else {
        Write-Host ("[MISSING] " + $item.Name.PadRight(45) + " -> Needs Re-backup/Restore") -ForegroundColor Red
    }
}

# 3. Flash Parcel లోని Book Parcel బటన్ కోడ్ చెక్
Write-Host "`n[3. CURRENT ONPRESSED ACTION IN FLASH PARCEL BUTTON]" -ForegroundColor Yellow
$parcelFiles = Get-ChildItem -Path "$projectRoot\lib" -Filter "*parcel*.dart" -Recurse
foreach ($pf in $parcelFiles) {
    $pLines = Get-Content $pf.FullName
    for ($i = 0; $i -lt $pLines.Count; $i++) {
        if ($pLines[$i] -match "Book Parcel") {
            Write-Host "File: $($pf.FullName)" -ForegroundColor Cyan
            $start = [Math]::Max(0, $i - 12)
            $end = [Math]::Min($pLines.Count - 1, $i + 4)
            for ($j = $start; $j -le $end; $j++) {
                Write-Host ("{0,4}: {1}" -f ($j + 1), $pLines[$j])
            }
            break
        }
    }
}

# 4. రౌట్స్ ఫైల్ చెక్ (Routes Configuration)
Write-Host "`n[4. ROUTE CONFIGURATIONS]" -ForegroundColor Yellow
$routeFiles = Get-ChildItem -Path "$projectRoot\lib" -Filter "*routes*.dart" -Recurse
foreach ($rf in $routeFiles) {
    Write-Host "Route File: $($rf.FullName)" -ForegroundColor Cyan
    Get-Content $rf.FullName | Select-String -Pattern "static const String|case " | Out-String | Write-Host
}

# 5. మీ సిస్టమ్ లో అందుబాటులో ఉన్న బ్యాకప్ జిప్ ఫైల్స్
Write-Host "`n[5. BACKUP ZIP FILES ON DESKTOP & DOWNLOADS]" -ForegroundColor Yellow
$zipLocations = @("$env:USERPROFILE\Desktop", "$env:USERPROFILE\Downloads", "$PWD")
$zips = Get-ChildItem -Path $zipLocations -Filter "*.zip" -ErrorAction SilentlyContinue
if ($zips) {
    $zips | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Host
} else {
    Write-Host "No zip backup files found in Desktop/Downloads." -ForegroundColor Yellow
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "AUDIT COMPLETE! PLEASE COPY AND PASTE THIS ENTIRE OUTPUT." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan