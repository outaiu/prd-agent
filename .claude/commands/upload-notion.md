---
description: PRDをNotionにアップロード・更新するコマンド。
---

PRDのNotionアップロード/更新を実行します。

1. Notion MCP連携チェック:
   - ToolSearchで "notion" を検索し、Notion MCPツールが利用可能か確認
   - 利用不可の場合: 簡易セットアップガイドを表示し、設定完了後に再実行を案内して終了
     - Notion Integration作成: https://www.notion.so/my-integrations でIntegration作成
     - トークン取得
     - Claude Code MCP設定にNotion MCPサーバーを追加（JSON例を表示）
     - 対象ページのURL確認

2. アップロード対象の選択:
   - outputs/ 配下のPRDファイル一覧をGlobで取得
   - ユーザーにアップロードするPRDファイルを選択してもらう（AskUserQuestion）

3. アップロード方式の確認:
   - 「新規作成」または「既存ページ更新」を選択してもらう
   - 新規作成: 保存先のNotionページURLを確認（前回の設定があれば提示）
   - 既存更新: Notion上で該当ページを検索し、対象を確認

4. 画像エビデンスの処理:
   - PRD内の `![...](...)` 画像参照を検出
   - ローカルファイルパスの場合: Notion MCPの画像ブロック機能で埋め込み
   - URLの場合: 外部画像ブロックとして埋め込み
   - 画像が含まれる場合、アップロード前にユーザーに確認

5. 実行:
   - 選択されたPRDファイルをReadで読み込む
   - Notion MCPツールを使用してアップロード/更新を実行
   - 完了後、NotionページのURLをユーザーに表示

$ARGUMENTS
