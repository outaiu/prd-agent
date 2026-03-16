# PRD Agent

ランサーズ PdM チーム向けの PRD 自動生成エージェント。
`/create-prd` を実行するだけで、対話式ヒアリングに答えるだけでエージェントが自動的にドメイン知識の探索・競合リサーチ・PRD の構築まで一気通貫で実行します。

## 何ができるか

- **対話式ヒアリング** — エージェントが質問を投げかけ、回答するだけでインプットが整理される
- **ドメイン知識の自動探索** — `knowledge/` に蓄積された既存のプロダクト知識・機能情報を自動で参照し、不足分だけヒアリングで補完
- **競合・市場リサーチ** — Web 検索で競合動向・市場トレンドを自動調査し、PRD に反映
- **PRD 自動生成** — 全 14 セクションのフォーマットに沿った PRD を `outputs/` に出力
- **Notion アップロード** — 生成した PRD をワンコマンドで Notion ページに反映
- **リポジトリからのドメイン知識補完** — 必要に応じてプロダクトのリポジトリを入力し、コードベースからドメイン知識を読み取って補完

## Quick Start

```bash
# 1. リポジトリをクローン
git clone git@github.com:outaiu/prd-agent.git
cd prd-agent

# 2. Claude Code をインストール
npm install -g @anthropic-ai/claude-code

# 3. Notion API Key を設定
export NOTION_API_KEY="your-notion-api-key"

# 4. Claude Code を起動して PRD 作成開始
claude
> /create-prd ランサーズの検索機能にAIレコメンドを追加したい
```

あとはエージェントの質問に答えていくだけで、PRD が自動生成されます。

## 利用シーン

### 新機能の企画を PRD にまとめたい

```
/create-prd ランサーズにAI提案機能を追加したい
```

エージェントが深度を自動判定。ヒアリングで要件を整理し、競合リサーチを実行、PRD を生成します。

### 既存機能の改善を検討したい

```
/create-prd 提案選定フローのUXを改善したい
```

`knowledge/` に蓄積されたドメイン知識を活用し、既存の機能構造を踏まえた PRD を生成します。

### 作成した PRD を Notion に共有したい

```
/upload-notion outputs/AI提案機能_2026-03-14.md
```

PRD を指定の Notion ページにアップロードします。チームへの共有がワンコマンドで完了します。

### ドメイン知識を更新・確認したい

```
/update-knowledge
```

`knowledge/` 配下の現在のドメイン知識を一覧表示し、追加・修正できます。
プロダクトのリポジトリを指定すれば、コードベースからドメイン知識を読み取って補完することも可能です。

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

## コマンド一覧

| コマンド | 説明 |
|---------|------|
| `/create-prd` | PRD 作成フローを開始（ヒアリング → リサーチ → PRD 生成） |
| `/update-knowledge` | ドメイン知識（knowledge/）を手動で更新・確認 |
| `/upload-notion` | 生成した PRD を Notion にアップロード |

## ディレクトリ構成

```
prd-agent/
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
