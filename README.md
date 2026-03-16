# PRD Agent

ランサーズ PdM チーム向けの PRD 自動生成エージェント。
Claude Code を使い、対話式ヒアリング → ドメイン知識蓄積 → リサーチ → PRD 生成のフローを実行します。

## セットアップ

### 1. Claude Code のインストール

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Notion MCP の設定

Notion API Key を環境変数として設定してください。

```bash
# .zshrc や .bashrc に追加
export NOTION_API_KEY="your-notion-api-key"
```

Notion API Key の取得方法:
1. [Notion Integrations](https://www.notion.so/my-integrations) でインテグレーションを作成
2. PRD アップロード先のページにインテグレーションを接続
3. 発行されたキーを環境変数にセット

### 3. Pencil MCP の設定（任意）

UI デザイン関連の PRD を作成する場合は、Pencil MCP の設定が必要です。
詳細は Pencil のドキュメントを参照してください。

## 使い方

Claude Code を起動し、以下のコマンドを実行します。

| コマンド | 説明 |
|---------|------|
| `/create-prd` | PRD 作成フローを開始（ヒアリング → リサーチ → PRD 生成） |
| `/update-knowledge` | ドメイン知識（knowledge/）を手動で更新・確認 |
| `/upload-notion` | 生成した PRD を Notion にアップロード |

## ディレクトリ構成

```
prd-master/
├── .claude/
│   ├── agents/       # サブエージェント定義
│   ├── skills/       # スキル定義
│   └── commands/     # スラッシュコマンド定義
├── knowledge/        # 永続化ドメイン知識
│   └── lancers/
│       ├── _product.yaml   # プロダクト概要・ビジネスモデル
│       ├── _index.yaml     # 機能カタログ
│       └── {機能名}/
│           └── feature.yaml
├── outputs/          # 生成された PRD（.gitignore で除外）
└── CLAUDE.md         # エージェント設定
```

## knowledge/ の運用方針

- **push するもの（チーム共通）**: プロダクト概要、機能カタログ、各機能の基礎知識（`feature.yaml`）
- **push しないもの（個人ローカル）**: PRD 履歴（`prd-history/`）、生成された PRD（`outputs/`）

ドメイン知識の構造を変更する場合は、チームで合意の上で行ってください。
