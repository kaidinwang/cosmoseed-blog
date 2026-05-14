---
title: "Claude Skills 跟 Projects 到底差在哪？一張表搞懂 AI 工作流的兩塊核心"
description: "Claude Projects 是長期記憶的工作空間，Claude Skills 是隨叫隨用的能力模組。把這兩個搞清楚，AI 工作流會直接升一個級別。從 AEO 內容生產的實戰角度拆解差異。"
publishDate: 2026-05-15
author: "Din Din Wang 王宣方"
category: "AI 工具"
tags: ["Claude", "Claude Projects", "Claude Skills", "AI 工作流", "AEO", "Prompt Engineering"]
keywords:
  - Claude Projects
  - Claude Skills
  - Claude 教學
  - Claude 工作流
  - AI 工作流
  - Anthropic
  - Claude Skills 教學
  - Claude Projects 用法
  - AI 內容生產
tldr: "Claude Projects 解決「跨對話記憶」的問題，Skills 解決「重複任務自動化」的問題。一個是空間，一個是能力。會用 Projects 的人比只用對話的人快 3 倍，會配 Skills 的人比只用 Projects 的人再快 5 倍。"
faq:
  - question: "Claude Projects 是什麼？跟一般對話有什麼不同？"
    answer: "Claude Projects 是 Anthropic 推出的工作空間功能，可以把相關的對話、檔案、系統指令封裝在同一個 Project 裡。Project 內的所有對話共享同一份背景知識（custom instructions + 上傳的檔案），不需要每次重新貼資料。實務上適合用來分專案管理：客戶 A 一個 Project、自媒體營運一個 Project、寫程式一個 Project，每個 Project 都記得自己的脈絡。"
  - question: "Claude Skills 是什麼？跟 Projects 有什麼差別？"
    answer: "Claude Skills 是可重複呼叫的「能力模組」，把一段複雜的工作流（含步驟、範本、輸出格式）封裝起來，需要時 Claude 會自動載入並執行。例如把「寫 IG 輪播貼文」做成一個 Skill，之後只要說「幫我做這主題的輪播」，Claude 就會按 Skill 定義好的步驟產出。Projects 是「空間」（橫向），Skills 是「能力」（縱向）。一個 Project 內可以有多個 Skills，Skill 也可以跨 Project 使用。"
  - question: "我已經有 ChatGPT 了，還需要學 Claude 嗎？"
    answer: "看用途。寫長文、做結構化內容、跟著明確 SOP 工作的場景，Claude 在台灣使用者圈是公認的首選——Projects 的記憶持續性、Skills 的可重用性、長 context window（200K+），這三件事 ChatGPT 目前還沒有完整對應的功能。如果你只是用 AI 偶爾查資料、寫短文，ChatGPT 就夠。如果你要把 AI 變成持續性的工作夥伴，Claude 的架構更扎實。"
  - question: "Claude Skills 跟 Custom GPTs 有什麼不同？"
    answer: "Custom GPTs 是「整包打包的助理」，使用者要選擇切換到那個 GPT 才能用。Claude Skills 是「能力外掛」，Claude 會根據你的請求自動判斷要不要載入哪個 Skill，使用者不需要明確指定。實務上 Skills 的觸發體感更接近「Claude 學會了這件事」，而 Custom GPTs 比較像「我打開另一個 ChatGPT」。"
  - question: "Claude Projects 適合做 AEO 內容嗎？"
    answer: "非常適合。AEO 內容生產有幾個重複特性：品牌資訊一致性、語氣調性、結構化資料格式（FAQ schema、Article schema）、目標關鍵字。把這些塞進 Project 的 custom instructions + knowledge files，Claude 之後產出的每篇文章都會自動符合 AEO 規格，不用每次重新交代。再搭配一個「AEO 文章寫作」Skill 處理結構步驟，產文速度可以從一天一篇變成一天三到五篇。"
  - question: "新手要從哪裡開始？"
    answer: "三步驟：(1) 先建一個 Project，把你最常做的工作脈絡丟進去（品牌資訊、寫作風格範本、過去的好作品），跑兩週純對話。(2) 觀察哪些任務重複度高，把那種任務改寫成 Skill 指令檔（系統 prompt + 步驟 + 輸出格式）。(3) Skill 跑順之後再開第二個 Project，把工作流分類管理。5/18 宇宙種子 AI 共學聚會帶完整實戰示範，免費報名：event.cosmoseed.com.tw"
---

## 為什麼 Claude 不是「另一個 ChatGPT」

打開 Claude 的網頁版第一眼，介面看起來跟 ChatGPT 沒什麼兩樣。對話框、訊息列、模型選單。

很多人停在這裡，然後說「Claude 跟 ChatGPT 用起來差不多嘛」。

差很多。**Claude 把 AI 工作流拆成「空間」跟「能力」兩個維度**，分別對應 Projects 跟 Skills。這兩個東西搞清楚之前，你用 Claude 的方式跟用 ChatGPT 沒兩樣；搞清楚之後，產出效率不是兩倍，是五倍十倍。

## 什麼是 Claude Projects

Claude Projects 是 Anthropic 設計的**工作空間**。一個 Project 裡可以放：

- **Custom instructions**：這個專案的所有對話都會帶入的系統 prompt（品牌調性、寫作風格、輸出格式偏好）
- **Knowledge files**：上傳 PDF、Markdown、文字檔，Claude 在這個 Project 內回答時會引用
- **多輪對話歷史**：每次新對話都自動承襲這個 Project 的脈絡

實務上的用法是這樣：

開一個叫「CosmoSeed 自媒體營運」的 Project，custom instructions 寫清楚我的品牌定位、慣用詞彙、不能用的字眼。Knowledge files 丟進去過去寫過的好貼文、品牌手冊、TA 輪廓。

從此之後，這個 Project 裡的任何對話，Claude 都記得「我是誰、要寫給誰、用什麼調性」。我不需要在每次對話開頭重新貼這些。

**Projects 解決的核心問題是「跨對話記憶」**。一般對話結束就忘了，Project 不會忘。

## 什麼是 Claude Skills

Claude Skills 是另一個維度的東西。如果 Projects 是橫向的「空間」，Skills 就是縱向的「能力」。

Skill 是一段封裝好的工作流：包含觸發條件、執行步驟、所需的範本、輸出格式。當你的請求符合 Skill 的觸發條件，Claude 會自動載入並按 SOP 執行。

舉個我自己用的 Skill：「IG 輪播貼文製作」。

這個 Skill 規定的步驟是：(1) 確認主題與目標 → (2) 寫出 8 張圖的內容架構 → (3) 給我確認 → (4) 用 HTML/CSS 生成高畫質視覺 → (5) 寫對應的 IG 貼文文案 → (6) 出 3 則限動文案。

我只要說「幫我做一組關於 AEO 的輪播」，Claude 就會按這套 SOP 跑。不用每次解釋我要什麼。

**Skills 解決的核心問題是「重複任務自動化」**。同一種事做第二次就是浪費生命，包成 Skill 就是把工作流變成程式。

## Projects vs Skills 一張表搞懂

| 面向 | Projects | Skills |
|---|---|---|
| 性質 | 工作空間（橫向） | 能力模組（縱向） |
| 解決問題 | 跨對話記憶 | 重複任務自動化 |
| 內容 | 背景知識、檔案、調性 | 步驟、範本、輸出格式 |
| 觸發 | 進入該 Project 就帶入 | Claude 自動判斷是否載入 |
| 用法比喻 | 一間有裝潢的辦公室 | 辦公室裡的專業工具箱 |
| 範圍 | 局限在該 Project 內 | 可跨 Project 使用 |
| 適合場景 | 分專案管理脈絡 | 流程化的重複任務 |

兩者不是二選一，是**疊加**。一個 Project 裡可以呼叫多個 Skills，同一個 Skill 也可以在不同 Project 裡被觸發。

## 為什麼這對 AEO 內容生產特別重要

AEO 內容有三個特性，剛好對應 Projects + Skills 的設計：

**一、品牌資訊一致性**——同一個品牌的所有文章，作者、發行方、調性、目標關鍵字必須一致。這放在 Project 的 custom instructions + knowledge files 裡，永久生效。

**二、結構化資料規格**——每篇 AEO 文章都要有 FAQ schema、Article schema、清楚的 H2/H3 階層、TL;DR、可見 FAQ 區塊。這個是流程，做成 Skill 一次設定一次到位。

**三、產量壓力**——AEO 不是寫一篇就完了，是要持續產出累積。每篇都從零來會死人，Project 記憶住脈絡 + Skill 處理結構，產文時間從每篇 4 小時降到每篇 40 分鐘。

我自己現在的部落格（你正在看的這個）就是用這套流程在跑。Project 裡放品牌資訊、過去文章、AEO 設定準則；Skill 處理「AEO 文章寫作」的完整 SOP（含 frontmatter 必填欄位、FAQ 結構、JSON-LD 對應、TL;DR 字數限制）。

每一篇文章從想題目到 push 上 GitHub 的時間，現在大約是一小時內。

## 從零開始的最小可行路徑

新手不要一開始就想做完整工作流，會卡。三步驟漸進：

**第一步：先開一個 Project，做兩週純對話**
把你最常做的工作脈絡丟進去——品牌資訊、寫作風格範本、過去的好作品。每次工作就在這個 Project 內對話。光是這一步，效率就會明顯提升，因為不用一直貼脈絡。

**第二步：觀察哪些任務你做第三次以上**
做第一次第二次的東西不要包 Skill，那是學習。做到第三次以上、流程穩定的，才值得封裝。包成 Skill 的關鍵不是把指令寫長，是把**步驟順序**跟**輸出格式**寫死。

**第三步：開第二個 Project，分類管理**
當你的工作跨多個領域（例如自媒體 + 客戶顧問 + 寫部落格），開不同 Project 才不會互相污染脈絡。

## 不要把 AI 工具當 ChatGPT 用

最後一個觀點。

很多人覺得「我用 ChatGPT 用得好好的，幹嘛換 Claude」。這沒錯，**前提是你只把 AI 當作問答機器人**。

但如果你想把 AI 當成一個能跟你長期合作的工作夥伴——記得你的偏好、知道你的客戶、按你的 SOP 做事——那 Projects + Skills 的架構就是目前市場上最完整的方案。

ChatGPT 的 Custom GPTs 比較像「打包好的助理」，每個都是獨立的單位。Claude 的 Projects + Skills 比較像「組織架構」，可以橫向縱向擴展。

差別不在工具本身，差別在你想用 AI 做什麼程度的事。

如果你也想完整實戰學會這套，5/18（週一）晚上 8 點宇宙種子 AI 共學聚有完整示範。**免費線上聚會**，報名 [event.cosmoseed.com.tw](https://event.cosmoseed.com.tw)。
