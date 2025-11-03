# 배포 가이드

## 1. GitHub 리포지토리 생성 및 연결

### GitHub에서 리포지토리 생성
1. https://github.com/new 접속
2. Repository name: `nextjs-supabase-boilerplate` (또는 원하는 이름)
3. **Public** 또는 **Private** 선택
4. **Initialize this repository with a README** 체크 해제 (이미 로컬에 있음)
5. **Create repository** 클릭

### 로컬 저장소 연결 및 푸시
```bash
# GitHub 리포지토리 URL로 교체 (예: https://github.com/wlstn/nextjs-supabase-boilerplate.git)
git remote add origin <YOUR_GITHUB_REPO_URL>
git branch -M main
git push -u origin main
```

## 2. Vercel 배포

### 방법 1: Vercel Dashboard에서 배포 (권장)
1. https://vercel.com 접속 및 로그인 (GitHub 계정으로 연동)
2. **New Project** 클릭
3. GitHub 리포지토리 선택
4. 프로젝트 설정:
   - **Framework Preset**: Next.js (자동 감지)
   - **Root Directory**: `./`
   - **Build Command**: `pnpm build` (자동 감지)
   - **Output Directory**: `.next` (자동 감지)
5. **Environment Variables** 추가:
   ```
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
   CLERK_SECRET_KEY=your_clerk_secret_key
   NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
   NEXT_PUBLIC_CLERK_SIGN_IN_FALLBACK_REDIRECT_URL=/
   NEXT_PUBLIC_CLERK_SIGN_UP_FALLBACK_REDIRECT_URL=/
   
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
   SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
   NEXT_PUBLIC_STORAGE_BUCKET=uploads
   ```
6. **Deploy** 클릭

### 방법 2: Vercel CLI로 배포
```bash
# Vercel CLI 설치
npm i -g vercel

# 로그인
vercel login

# 배포
vercel

# 프로덕션 배포
vercel --prod
```

## 3. 배포 후 확인사항

### Clerk 설정
1. Clerk Dashboard → **Configure** → **Domains**
2. Vercel 배포 URL 추가 (예: `your-app.vercel.app`)
3. **Save** 클릭

### Supabase 설정
1. Supabase Dashboard → **Settings** → **API**
2. **Project URL** 및 **API keys** 확인
3. Vercel 환경 변수에 정확히 입력했는지 확인

### 환경 변수 확인
- Vercel Dashboard → **Settings** → **Environment Variables**
- 모든 환경 변수가 올바르게 설정되었는지 확인

## 4. 도메인 설정 (선택사항)

### 커스텀 도메인 추가
1. Vercel Dashboard → **Settings** → **Domains**
2. 원하는 도메인 추가
3. DNS 설정 안내에 따라 도메인 등록 기관에서 DNS 레코드 추가
4. Clerk에서도 커스텀 도메인 추가

## 문제 해결

### 빌드 에러
- Vercel 로그 확인: **Deployments** → 해당 배포 → **Build Logs**
- 로컬에서 `pnpm build` 실행하여 에러 확인

### 환경 변수 관련
- `.env.local`은 Vercel에 업로드되지 않음
- Vercel Dashboard에서 환경 변수를 직접 설정해야 함

### 인증 에러
- Clerk Dashboard에서 배포 URL이 허용 목록에 있는지 확인
- Vercel 환경 변수가 올바르게 설정되었는지 확인

