# Vercel 환경 변수 설정 가이드

## 방법 1: 개별 설정 (대화형)

각 환경 변수를 하나씩 설정합니다:

```bash
# Clerk 환경 변수
vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY production preview development
vercel env add CLERK_SECRET_KEY production preview development
vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production preview development
# 값 입력: /sign-in

vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production preview development
# 값 입력: /

vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production preview development
# 값 입력: /

# Supabase 환경 변수
vercel env add NEXT_PUBLIC_SUPABASE_URL production preview development
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production preview development
vercel env add SUPABASE_SERVICE_ROLE_KEY production preview development
vercel env add NEXT_PUBLIC_STORAGE_BUCKET production preview development
# 값 입력: uploads
```

## 방법 2: 일괄 설정 (PowerShell 스크립트)

PowerShell에서 실행:

```powershell
# Clerk 환경 변수
echo "your_clerk_publishable_key" | vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY production preview development
echo "your_clerk_secret_key" | vercel env add CLERK_SECRET_KEY production preview development
echo "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production preview development
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production preview development
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production preview development

# Supabase 환경 변수
echo "your_supabase_url" | vercel env add NEXT_PUBLIC_SUPABASE_URL production preview development
echo "your_supabase_anon_key" | vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production preview development
echo "your_service_role_key" | vercel env add SUPABASE_SERVICE_ROLE_KEY production preview development
echo "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET production preview development
```

## 방법 3: .env 파일에서 가져오기

로컬 `.env` 파일이 있다면:

```bash
# .env 파일이 있는지 확인
if (Test-Path .env) {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            $key = $matches[1]
            $value = $matches[2]
            echo $value | vercel env add $key production preview development
        }
    }
}
```

## 환경 변수 확인

설정한 환경 변수 확인:

```bash
vercel env ls
```

## 재배포

환경 변수 설정 후 재배포:

```bash
vercel --prod
```

