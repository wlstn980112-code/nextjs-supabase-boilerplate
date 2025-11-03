#!/bin/bash

# Vercel 환경 변수 설정 스크립트
# 각 환경 변수를 대화형으로 추가합니다.

echo "Vercel 환경 변수 설정을 시작합니다."
echo "각 변수에 대한 값을 입력하세요."
echo ""

# Clerk 환경 변수
vercel env add NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY production preview development
vercel env add CLERK_SECRET_KEY production preview development
vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_URL production preview development <<< "/sign-in"
vercel env add NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL production preview development <<< "/"
vercel env add NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL production preview development <<< "/"

# Supabase 환경 변수
vercel env add NEXT_PUBLIC_SUPABASE_URL production preview development
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production preview development
vercel env add SUPABASE_SERVICE_ROLE_KEY production preview development
vercel env add NEXT_PUBLIC_STORAGE_BUCKET production preview development <<< "uploads"

echo ""
echo "환경 변수 설정이 완료되었습니다!"
echo "배포를 다시 시도하세요: vercel --prod"

