"use client";

import { useState, useEffect, useCallback } from "react";
import { useUser } from "@clerk/nextjs";
import { useClerkSupabaseClient } from "@/lib/supabase/clerk-client";
import { Button } from "@/components/ui/button";
import {
  LuUpload,
  LuTrash2,
  LuDownload,
  LuFile,
  LuTriangleAlert,
} from "react-icons/lu";
import Link from "next/link";

// Supabase Storage FileObject 타입 정의
interface FileObject {
  id: string;
  name: string;
  bucket_id: string;
  owner?: string;
  created_at: string;
  updated_at: string;
  last_accessed_at: string;
  metadata?: Record<string, any>;
}

const STORAGE_BUCKET = process.env.NEXT_PUBLIC_STORAGE_BUCKET || "uploads";

export default function StorageTestPage() {
  const { user, isLoaded } = useUser();
  const supabase = useClerkSupabaseClient();
  const [files, setFiles] = useState<FileObject[]>([]);
  const [uploading, setUploading] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // 파일 목록 가져오기
  const fetchFiles = useCallback(async () => {
    if (!user) return;

    try {
      setLoading(true);
      setError(null);

      const { data, error } = await supabase.storage
        .from(STORAGE_BUCKET)
        .list(user.id, {
          limit: 100,
          offset: 0,
          sortBy: { column: "created_at", order: "desc" },
        });

      if (error) {
        // 버킷이 없는 경우 특별 처리
        const errorMessage = error.message || String(error);
        const isBucketNotFound =
          errorMessage.includes("Bucket not found") ||
          errorMessage.includes("bucket") ||
          error.name === "StorageApiError";

        if (isBucketNotFound) {
          throw new Error(
            `Storage 버킷 '${STORAGE_BUCKET}'이(가) 존재하지 않습니다. ` +
              "Supabase Dashboard에서 버킷을 생성하거나 마이그레이션을 실행해주세요."
          );
        }

        throw new Error(
          errorMessage || "파일 목록을 가져오는데 실패했습니다."
        );
      }

      setFiles(data || []);
    } catch (err) {
      const errorMessage =
        err instanceof Error
          ? err.message
          : "파일 목록을 가져오는데 실패했습니다.";

      console.error("[Storage] 파일 목록 조회 실패:", errorMessage);
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  }, [user, supabase]);

  useEffect(() => {
    if (isLoaded && user) {
      fetchFiles();
    }
  }, [user, isLoaded, fetchFiles]);

  // 파일 업로드
  const uploadFile = async (event: React.ChangeEvent<HTMLInputElement>) => {
    if (!user) {
      setError("로그인이 필요합니다.");
      return;
    }

    try {
      setUploading(true);
      setError(null);

      if (!event.target.files || event.target.files.length === 0) {
        throw new Error("파일을 선택해주세요.");
      }

      const file = event.target.files[0];
      const fileExt = file.name.split(".").pop();
      const fileName = `${Date.now()}-${Math.random()
        .toString(36)
        .substring(7)}.${fileExt}`;
      const filePath = `${user.id}/${fileName}`;

      const { error: uploadError } = await supabase.storage
        .from(STORAGE_BUCKET)
        .upload(filePath, file, {
          cacheControl: "3600",
          upsert: false,
        });

      if (uploadError) {
        // 버킷이 없는 경우 특별 처리
        const errorMessage = uploadError.message || String(uploadError);
        const isBucketNotFound =
          errorMessage.includes("Bucket not found") ||
          errorMessage.includes("bucket") ||
          uploadError.name === "StorageApiError";

        if (isBucketNotFound) {
          throw new Error(
            `Storage 버킷 '${STORAGE_BUCKET}'이(가) 존재하지 않습니다. ` +
              "Supabase Dashboard에서 버킷을 생성해주세요."
          );
        }

        throw new Error(
          errorMessage || "파일 업로드에 실패했습니다."
        );
      }

      // 파일 목록 새로고침
      await fetchFiles();

      // 입력 초기화
      event.target.value = "";
    } catch (err) {
      const errorMessage =
        err instanceof Error
          ? err.message
          : "파일 업로드에 실패했습니다.";

      console.error("[Storage] 파일 업로드 실패:", errorMessage);
      setError(errorMessage);
    } finally {
      setUploading(false);
    }
  };

  // 파일 다운로드
  const downloadFile = async (fileName: string) => {
    if (!user) return;

    try {
      const filePath = `${user.id}/${fileName}`;
      const { data, error } = await supabase.storage
        .from(STORAGE_BUCKET)
        .download(filePath);

      if (error) {
        const errorMessage = error.message || String(error);
        throw new Error(
          errorMessage || "파일 다운로드에 실패했습니다."
        );
      }

      // Blob을 다운로드 링크로 변환
      const url = URL.createObjectURL(data);
      const a = document.createElement("a");
      a.href = url;
      a.download = fileName;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (err) {
      const errorMessage =
        err instanceof Error
          ? err.message
          : "파일 다운로드에 실패했습니다.";

      console.error("[Storage] 파일 다운로드 실패:", errorMessage);
      setError(errorMessage);
    }
  };

  // 파일 삭제
  const deleteFile = async (fileName: string) => {
    if (!user) return;
    if (!confirm(`${fileName} 파일을 삭제하시겠습니까?`)) return;

    try {
      const filePath = `${user.id}/${fileName}`;
      const { error } = await supabase.storage
        .from(STORAGE_BUCKET)
        .remove([filePath]);

      if (error) {
        const errorMessage = error.message || String(error);
        throw new Error(
          errorMessage || "파일 삭제에 실패했습니다."
        );
      }

      // 파일 목록 새로고침
      await fetchFiles();
    } catch (err) {
      const errorMessage =
        err instanceof Error
          ? err.message
          : "파일 삭제에 실패했습니다.";

      console.error("[Storage] 파일 삭제 실패:", errorMessage);
      setError(errorMessage);
    }
  };

  // 파일 크기 포맷팅
  const formatFileSize = (bytes: number): string => {
    if (bytes === 0) return "0 Bytes";
    const k = 1024;
    const sizes = ["Bytes", "KB", "MB", "GB"];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + " " + sizes[i];
  };

  if (!isLoaded) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p>로딩 중...</p>
      </div>
    );
  }

  if (!user) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen gap-4">
        <LuTriangleAlert className="w-16 h-16 text-yellow-500" />
        <h1 className="text-2xl font-bold">로그인이 필요합니다</h1>
        <p className="text-gray-600">
          Storage 기능을 사용하려면 먼저 로그인해주세요.
        </p>
        <Link href="/">
          <Button>홈으로 돌아가기</Button>
        </Link>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto p-8">
      <div className="mb-8">
        <Link
          href="/"
          className="text-blue-600 hover:underline mb-4 inline-block"
        >
          ← 홈으로 돌아가기
        </Link>
        <h1 className="text-4xl font-bold mb-2">Supabase Storage 테스트</h1>
        <p className="text-gray-600">
          파일 업로드, 다운로드, 삭제 기능을 테스트할 수 있습니다.
        </p>
      </div>

      {/* 에러 메시지 */}
      {error && (
        <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg flex items-start gap-2">
          <LuTriangleAlert className="w-5 h-5 text-red-600 mt-0.5" />
          <div className="flex-1">
            <h3 className="font-semibold text-red-800">에러</h3>
            <p className="text-sm text-red-700">{error}</p>
            {error.includes("버킷") || error.includes("Bucket") ? (
              <div className="mt-3 p-3 bg-yellow-50 border border-yellow-200 rounded">
                <p className="text-xs font-semibold text-yellow-800 mb-2">
                  💡 버킷 생성 방법:
                </p>
                <ol className="text-xs text-yellow-700 list-decimal list-inside space-y-1">
                  <li>
                    Supabase Dashboard → <strong>SQL Editor</strong> 메뉴
                  </li>
                  <li>
                    <code className="bg-yellow-100 px-1 rounded">
                      supabase/migrations/setup_storage.sql
                    </code>{" "}
                    파일 내용을 복사하여 실행
                  </li>
                  <li>또는 Supabase Dashboard → <strong>Storage</strong> →{" "}
                    <strong>New bucket</strong>에서 직접 생성
                  </li>
                </ol>
              </div>
            ) : null}
          </div>
          <Button
            variant="ghost"
            size="sm"
            onClick={() => setError(null)}
            className="text-red-600"
          >
            닫기
          </Button>
        </div>
      )}

      {/* 파일 업로드 */}
      <div className="mb-8 p-6 border rounded-lg">
        <h2 className="text-2xl font-bold mb-4">파일 업로드</h2>
        <div className="flex items-center gap-4">
          <label htmlFor="file-upload" className="cursor-pointer">
            <Button disabled={uploading} asChild>
              <span>
                <LuUpload className="w-4 h-4 mr-2" />
                {uploading ? "업로드 중..." : "파일 선택"}
              </span>
            </Button>
          </label>
          <input
            id="file-upload"
            type="file"
            onChange={uploadFile}
            disabled={uploading}
            className="hidden"
          />
          <p className="text-sm text-gray-500">권장: 6MB 이하 파일</p>
        </div>
      </div>

      {/* 파일 목록 */}
      <div className="border rounded-lg">
        <div className="p-6 border-b">
          <div className="flex items-center justify-between">
            <h2 className="text-2xl font-bold">업로드된 파일</h2>
            <Button
              variant="outline"
              size="sm"
              onClick={fetchFiles}
              disabled={loading}
            >
              {loading ? "로딩 중..." : "새로고침"}
            </Button>
          </div>
        </div>

        {loading ? (
          <div className="p-8 text-center text-gray-500">
            파일 목록을 불러오는 중...
          </div>
        ) : files.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            <LuFile className="w-16 h-16 mx-auto mb-4 text-gray-300" />
            <p>업로드된 파일이 없습니다.</p>
            <p className="text-sm mt-2">위에서 파일을 업로드해보세요!</p>
          </div>
        ) : (
          <div className="divide-y">
            {files.map((file) => (
              <div
                key={file.id}
                className="p-4 flex items-center justify-between hover:bg-gray-50"
              >
                <div className="flex items-center gap-3 flex-1">
                  <LuFile className="w-8 h-8 text-gray-400" />
                  <div>
                    <p className="font-medium">{file.name}</p>
                    <p className="text-sm text-gray-500">
                      {file.metadata &&
                      typeof file.metadata === "object" &&
                      "size" in file.metadata
                        ? formatFileSize(file.metadata.size as number)
                        : "크기 정보 없음"}{" "}
                      • {new Date(file.created_at).toLocaleString("ko-KR")}
                    </p>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => downloadFile(file.name)}
                  >
                    <LuDownload className="w-4 h-4" />
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => deleteFile(file.name)}
                    className="text-red-600 hover:text-red-700"
                  >
                    <LuTrash2 className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* 사용자 정보 */}
      <div className="mt-8 p-4 bg-gray-50 rounded-lg">
        <h3 className="font-semibold mb-2">현재 사용자</h3>
        <p className="text-sm text-gray-600">User ID: {user.id}</p>
        <p className="text-sm text-gray-600">
          Email: {user.emailAddresses[0]?.emailAddress}
        </p>
      </div>
    </div>
  );
}
