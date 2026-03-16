---
description: PRD作成フローを開始する。深度を自動判定し、必要に応じてヒアリング→リサーチ→PRD生成を実行する。
---

PRD作成フローを開始します。

0. まず、利用可能なコマンド一覧をユーザーに案内する:
   📋 利用可能なコマンド:
   - /create-prd — PRD作成フローを開始
   - /update-knowledge — Knowledge（ドメイン知識）を手動で更新・確認
   - /upload-notion — PRDをNotionにアップロード・更新（要Notion MCP設定）

1. Notion MCP連携チェック:
   a. ToolSearchで "notion" を検索し、Notion MCPツールが利用可能か確認
   b. 利用可能な場合:
      - 「✅ Notion MCP連携が検出されました。PRD生成後にNotionへアップロードできます。」と案内
      - 「保存先のNotionページURLを変更しますか？」と確認
      - /upload-notion コマンドでいつでもアップロードできることを伝える
   c. 利用不可の場合:
      - 「Notion連携を設定しますか？設定するとPRDを直接Notionにアップロードできます。」と確認
      - Yesの場合:
        1. Notion Integration作成: https://www.notion.so/my-integrations でIntegration作成を案内
        2. AskUserQuestion でトークンを入力してもらう（header: "NotionトークンとページURLの入力"）
           - Notionトークン（"secret_..." から始まる文字列）
           - PRD保存先NotionページのURL
        3. 入力されたトークンを使って プロジェクトルートの .claude/settings.json の mcpServers に
           Notion MCPサーバー設定を自動で追加・保存する:
           - .claude/settings.json を読み込む（存在しない場合は空のJSONオブジェクトから開始）
           - 既存の内容にマージして mcpServers.notion エントリを追加:
             {
               "mcpServers": {
                 "notion": {
                   "command": "npx",
                   "args": ["-y", "@notionhq/notion-mcp-server"],
                   "env": {
                     "OPENAPI_MCP_HEADERS": "{\"Authorization\": \"Bearer <入力されたトークン>\", \"Notion-Version\": \"2022-06-28\"}"
                   }
                 }
               }
             }
           - 既存の mcpServers や他のキーは保持したままマージして書き戻す
        4. 「✅ 設定が完了しました。Claude Code を再起動すると Notion MCP が有効になります。」と伝える
        5. 入力されたNotionページURLをメモしておき、後のアップロード時に使用する
      - Noの場合: 通常フローに進む。「後から /upload-notion で設定・アップロードできます」と伝える

2. ユーザーの入力内容を .claude/skills/prd-orchestrator/SKILL.md の深度判定ロジックで評価してください。

3. 判定結果に応じて:
   - Minimal: AI DLC案内テキストを出力して終了（prd-orchestrator/SKILL.md の Minimal セクション参照）
   - Standard: PRD作成を推奨し、ユーザーの同意を確認
   - Comprehensive: PRD作成が必要であることを伝え、ユーザーの同意を確認

4. PRD作成に進む場合:
   a. リポジトリ確認:
      - 「ドメインのリポジトリ（ソースコード）を参照しますか？参照する場合はパスを教えてください」と確認
      - ある場合: パスと走査対象（例: 「提案機能まわり」「決済関連」など）を聞き、domain-collector に渡す
      - ない場合: 通常のヒアリングフローに進む
      - **パスは `_product.yaml` に保存しない**（チーム展開時にマシンごとにパスが異なるため）
   b. domain-collector サブエージェントを起動してドメイン知識を収集
   c. .claude/skills/prd-orchestrator/SKILL.md に基づきPRD要素をヒアリング
   c. research-analyst サブエージェントを起動してリサーチを実行
   d. prd-writer サブエージェントを起動してPRDを生成

5. 生成されたPRDをユーザーに提示し、レビューと修正を受け付ける

6. Notion連携（オプション）:
   - Notion MCPが利用可能な場合: 「NotionにPRDをアップロードしますか？」と確認し、Yesならアップロードを実行
   - Notion MCPが利用不可の場合: 「後から /upload-notion コマンドでアップロードできます」と伝える

$ARGUMENTS
