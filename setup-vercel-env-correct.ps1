# Vercel 환경 변수 설정 스크립트 (수정된 버전)
# 각 환경 변수를 production, preview, development 환경에 모두 추가합니다.

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Vercel 환경 변수 설정 (각 환경별 추가)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "각 명령어 실행 시 값 입력 프롬프트가 나타납니다." -ForegroundColor Yellow
Write-Host ""

$environments = @("production", "preview", "development")

# Clerk 환경 변수
Write-Host "`n[1/9] Clerk 환경 변수 설정 중..." -ForegroundColor Green

Write-Host "`n  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중..." -ForegroundColor Gray
    vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY $env
}

Write-Host "`n  CLERK_SECRET_KEY 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중..." -ForegroundColor Gray
    vercel env add CLERK_SECRET_KEY $env
}

Write-Host "`n  NEXT_PUBLIC_CLERK_SIGN_IN_URL 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중 (값: /sign-in)..." -ForegroundColor Gray
    echo "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL $env
}

Write-Host "`n  NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중 (값: /)..." -ForegroundColor Gray
    echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL $env
}

Write-Host "`n  NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중 (값: /)..." -ForegroundColor Gray
    echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL $env
}

# Supabase 환경 변수
Write-Host "`n[2/9] Supabase 환경 변수 설정 중..." -ForegroundColor Green

Write-Host "`n  NEXT_PUBLIC_SUPABASE_URL 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중..." -ForegroundColor Gray
    vercel env add NEXT_PUBLIC_SUPABASE_URL $env
}

Write-Host "`n  NEXT_PUBLIC_SUPABASE_ANON_KEY 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중..." -ForegroundColor Gray
    vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY $env
}

Write-Host "`n  SUPABASE_SERVICE_ROLE_KEY 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중..." -ForegroundColor Gray
    vercel env add SUPABASE_SERVICE_ROLE_KEY $env
}

Write-Host "`n  NEXT_PUBLIC_STORAGE_BUCKET 설정..." -ForegroundColor Cyan
foreach ($env in $environments) {
    Write-Host "    - $env 환경에 추가 중 (값: uploads)..." -ForegroundColor Gray
    echo "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET $env
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "환경 변수 설정 완료!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "설정 확인: vercel env ls" -ForegroundColor Cyan
Write-Host "재배포: vercel --prod" -ForegroundColor Cyan

