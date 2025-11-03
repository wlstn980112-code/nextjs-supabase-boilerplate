# Vercel 환경 변수 설정 PowerShell 스크립트
# 실행 방법: .\setup-vercel-env.ps1

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Vercel 환경 변수 설정" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# .env 파일이 있으면 값을 자동으로 읽어옵니다
$envFile = ".env"
if (Test-Path $envFile) {
    Write-Host ".env 파일을 찾았습니다. 값을 자동으로 읽어옵니다..." -ForegroundColor Green
    
    $envVars = @{}
    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^([^=#\s]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim().Trim('"').Trim("'")
            $envVars[$key] = $value
        }
    }
    
    # Clerk 환경 변수
    if ($envVars.ContainsKey("NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY")) {
        Write-Host "`nNEXT_PUBLIC_CLERK_PUBLISHABLE_KEY 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY"] | vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY production preview development
    }
    
    if ($envVars.ContainsKey("CLERK_SECRET_KEY")) {
        Write-Host "CLERK_SECRET_KEY 설정 중..." -ForegroundColor Yellow
        $envVars["CLERK_SECRET_KEY"] | vercel env add CLERK_SECRET_KEY production preview development
    }
    
    if ($envVars.ContainsKey("NEXT_PUBLIC_CLERK_SIGN_IN_URL")) {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_IN_URL 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_CLERK_SIGN_IN_URL"] | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production preview development
    } else {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_IN_URL 설정 중 (기본값: /sign-in)..." -ForegroundColor Yellow
        "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production preview development
    }
    
    if ($envVars.ContainsKey("NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL")) {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL"] | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production preview development
    } else {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL 설정 중 (기본값: /)..." -ForegroundColor Yellow
        "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production preview development
    }
    
    if ($envVars.ContainsKey("NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL")) {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL"] | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production preview development
    } else {
        Write-Host "NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL 설정 중 (기본값: /)..." -ForegroundColor Yellow
        "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production preview development
    }
    
    # Supabase 환경 변수
    if ($envVars.ContainsKey("NEXT_PUBLIC_SUPABASE_URL")) {
        Write-Host "`nNEXT_PUBLIC_SUPABASE_URL 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_SUPABASE_URL"] | vercel env add NEXT_PUBLIC_SUPABASE_URL production preview development
    }
    
    if ($envVars.ContainsKey("NEXT_PUBLIC_SUPABASE_ANON_KEY")) {
        Write-Host "NEXT_PUBLIC_SUPABASE_ANON_KEY 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_SUPABASE_ANON_KEY"] | vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production preview development
    }
    
    if ($envVars.ContainsKey("SUPABASE_SERVICE_ROLE_KEY")) {
        Write-Host "SUPABASE_SERVICE_ROLE_KEY 설정 중..." -ForegroundColor Yellow
        $envVars["SUPABASE_SERVICE_ROLE_KEY"] | vercel env add SUPABASE_SERVICE_ROLE_KEY production preview development
    }
    
    if ($envVars.ContainsKey("NEXT_PUBLIC_STORAGE_BUCKET")) {
        Write-Host "NEXT_PUBLIC_STORAGE_BUCKET 설정 중..." -ForegroundColor Yellow
        $envVars["NEXT_PUBLIC_STORAGE_BUCKET"] | vercel env add NEXT_PUBLIC_STORAGE_BUCKET production preview development
    } else {
        Write-Host "NEXT_PUBLIC_STORAGE_BUCKET 설정 중 (기본값: uploads)..." -ForegroundColor Yellow
        "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET production preview development
    }
    
} else {
    Write-Host ".env 파일을 찾을 수 없습니다." -ForegroundColor Red
    Write-Host "수동으로 환경 변수를 설정하거나 .env 파일을 생성하세요." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "수동 설정 예시:" -ForegroundColor Cyan
    Write-Host '  echo "your_value" | vercel env add VARIABLE_NAME production preview development' -ForegroundColor White
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "환경 변수 설정 완료!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "설정된 환경 변수 확인:" -ForegroundColor Cyan
vercel env ls
Write-Host ""
Write-Host "재배포 명령어:" -ForegroundColor Cyan
Write-Host "  vercel --prod" -ForegroundColor White

