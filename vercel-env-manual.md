# Vercel 환경 변수 수동 설정 가이드

## 올바른 명령어 형식

Vercel CLI에서는 각 환경(production, preview, development)에 개별적으로 환경 변수를 추가해야 합니다.

```powershell
vercel env add <변수명> <환경>
```

## 각 환경 변수 설정 (순서대로 실행)

### Clerk 환경 변수

각 변수를 3번씩 실행 (production, preview, development):

```powershell
# 1. NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY production
vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY preview
vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY development
# 각각 실행 시 값 입력 프롬프트에 Clerk Publishable Key 입력

# 2. CLERK_SECRET_KEY
vercel env add CLERK_SECRET_KEY production
vercel env add CLERK_SECRET_KEY preview
vercel env add CLERK_SECRET_KEY development
# 각각 실행 시 값 입력 프롬프트에 Clerk Secret Key 입력

# 3. NEXT_PUBLIC_CLERK_SIGN_IN_URL
echo "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production
echo "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL preview
echo "/sign-in" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL development

# 4. NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL preview
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL development

# 5. NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL preview
echo "/" | vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL development
```

### Supabase 환경 변수

```powershell
# 6. NEXT_PUBLIC_SUPABASE_URL
vercel env add NEXT_PUBLIC_SUPABASE_URL production
vercel env add NEXT_PUBLIC_SUPABASE_URL preview
vercel env add NEXT_PUBLIC_SUPABASE_URL development
# 각각 실행 시 값 입력 프롬프트에 Supabase URL 입력 (예: https://xxxxx.supabase.co)

# 7. NEXT_PUBLIC_SUPABASE_ANON_KEY
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY preview
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY development
# 각각 실행 시 값 입력 프롬프트에 Supabase Anon Key 입력

# 8. SUPABASE_SERVICE_ROLE_KEY
vercel env add SUPABASE_SERVICE_ROLE_KEY production
vercel env add SUPABASE_SERVICE_ROLE_KEY preview
vercel env add SUPABASE_SERVICE_ROLE_KEY development
# 각각 실행 시 값 입력 프롬프트에 Supabase Service Role Key 입력

# 9. NEXT_PUBLIC_STORAGE_BUCKET
echo "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET production
echo "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET preview
echo "uploads" | vercel env add NEXT_PUBLIC_STORAGE_BUCKET development
```

## 확인 및 재배포

```powershell
# 환경 변수 확인
vercel env ls

# 재배포
vercel --prod
```

