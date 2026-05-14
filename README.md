# cosmoseed-blog

宇宙種子 CosmoSeed 部落格。Astro 5 + Tailwind v4，內容為 Markdown，部署在 Netlify，透過 `cosmoseed.com.tw/blog/*` proxy 對外服務。

## 本機開發

```powershell
npm install
npm run dev          # http://localhost:4321/blog
npm run build        # 產出到 dist/
npm run preview      # 預覽 build 結果
```

## 寫一篇新文章

1. 在 `src/content/blog/` 加一個 `YYYY-MM-DD-slug.md`
2. Frontmatter 必填欄位（schema 在 `src/content/config.ts`）：

```yaml
---
title: "文章標題（最長 70 字）"
description: "Meta description，50–160 字，會出現在 OG 與搜尋摘要"
publishDate: 2026-05-15
author: "Din Din Wang 王宣方"
category: "AEO"            # AEO / AI 工具 / 行銷 / 創業心法 / 工作流
tags: ["AEO", "AI 搜尋"]
keywords:
  - AEO
  - AI 引用
tldr: "一句話總結，會獨立顯示在文章開頭。"
faq:                       # 對應 FAQPage JSON-LD schema
  - question: "問題一？"
    answer: "回答一。"
  - question: "問題二？"
    answer: "回答二。"
---

## H2 標題

內文 Markdown...
```

`draft: true` 的文章不會被 build 出來，但 schema 仍會被驗證。

## 一鍵發布（Claude / 本機）

```powershell
.\scripts\publish-blog.ps1 -File "C:\drafts\2026-05-20-xxx.md"
```

流程：copy 到 `src/content/blog/` → `npm run build` 驗 schema → git commit + push → Netlify auto-deploy。

## 一鍵發布（AEO 工具串接 — GitHub API）

讓你的 AEO 文章生成工具直接呼叫 GitHub Contents API 寫入 .md 檔，push 後 Netlify 會自動 deploy。

**所需準備：**

1. 在 GitHub 建 fine-grained Personal Access Token：
   - Repository access: only `kaidinwang/cosmoseed-blog`
   - Permissions: Contents → Read and write
   - 把 token 存進你工具的環境變數，例如 `GITHUB_BLOG_TOKEN`

2. 工具端呼叫範例（Node.js）：

```js
const slug = "2026-05-20-aeo-case-study";
const path = `src/content/blog/${slug}.md`;
const content = `---
title: "..."
description: "..."
publishDate: 2026-05-20
...
---

文章內容...
`;

await fetch(
  `https://api.github.com/repos/kaidinwang/cosmoseed-blog/contents/${path}`,
  {
    method: 'PUT',
    headers: {
      'Authorization': `Bearer ${process.env.GITHUB_BLOG_TOKEN}`,
      'Accept': 'application/vnd.github+json',
      'X-GitHub-Api-Version': '2022-11-28',
    },
    body: JSON.stringify({
      message: `publish: ${slug}`,
      content: Buffer.from(content, 'utf-8').toString('base64'),
      branch: 'main',
    }),
  }
);
```

Python 版本同理，用 `requests.put` + `base64.b64encode`。

**注意事項：**

- API 寫入會直接 commit 到 `main`，建議工具端先檢查 frontmatter 必填欄位再 push（不然 Netlify build 會失敗、Slack 通知會跳出）
- 已存在的同名 path 要先 GET 取得 `sha` 再 PUT，否則會 422
- 建議工具端附帶 retry：Netlify 偶爾 build 失敗（依工作日誌 5/11 經驗 UI bug 但後端會 retry）

## 部署架構

```
cosmoseed.com.tw         (toolbox, Netlify site: cosmoseed-ai-toolbox)
    └─ /blog/*  ──proxy──>  cosmoseed-blog.netlify.app
                                    │
                                    └─ Astro 5 static site
```

**toolbox repo (`cosmoseed-ai-toolbox`) 要加入 `netlify.toml`：**

```toml
[[redirects]]
  from = "/blog"
  to = "https://cosmoseed-blog.netlify.app/"
  status = 200
  force = true

[[redirects]]
  from = "/blog/*"
  to = "https://cosmoseed-blog.netlify.app/:splat"
  status = 200
  force = true
```

注意：`status = 200` 是 proxy（URL 不變），`301` 才是 redirect。`force = true` 確保即使有同名靜態檔也走 rewrite。

Astro 設定 `base: '/blog'` 讓所有內部連結都帶 `/blog/` 前綴；Netlify proxy 則負責 strip 前綴傳給 blog 站。直接訪問 `cosmoseed-blog.netlify.app/` 會看到內容但樣式破版（正常，那不是面向使用者的入口）。

## AEO 結構化資料

每篇文章自動注入：
- `Article` schema（headline / datePublished / author / image / publisher）
- `FAQPage` schema（從 frontmatter `faq` 生成）
- `BreadcrumbList` schema（CosmoSeed → Blog → 文章）

加上：
- `<link rel="canonical">` 指向 apex 網域
- OG / Twitter Card meta
- Sitemap: `https://cosmoseed.com.tw/blog/sitemap-index.xml`
- RSS: `https://cosmoseed.com.tw/blog/rss.xml`
- robots.txt 顯式允許 GPTBot / ClaudeBot / PerplexityBot / Google-Extended

## 上線檢核清單

部署完後：

- [ ] 訪問 `https://cosmoseed.com.tw/blog` 看到列表頁
- [ ] 訪問 `https://cosmoseed.com.tw/blog/2026-05-15-hello-cosmoseed-blog` 看到文章
- [ ] [Rich Results Test](https://search.google.com/test/rich-results) 驗 FAQ schema 通過
- [ ] GSC 提交 `https://cosmoseed.com.tw/blog/sitemap-index.xml`
- [ ] toolbox repo 的 `netlify.toml` rewrite 已加且部署
- [ ] 第二篇文章用 `publish-blog.ps1` 跑一次驗證自動化
