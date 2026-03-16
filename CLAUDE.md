# PRD Agent プロジェクト

## プロジェクト概要
PdM向けPRD自動生成エージェント。対話式ヒアリング → ドメイン知識蓄積 → リサーチ → PRD生成のフローを実行する。

## ユーザー
- ランサーズのプロダクトマネージャー（PdM）が使用

## ディレクトリ規約
- `knowledge/` : 永続化ドメイン知識。プロダクト > 機能の階層で管理。デフォルトプロダクトは「ランサーズ」
- `outputs/` : 生成されたPRD成果物
- `.claude/agents/` : サブエージェント定義
- `.claude/skills/` : スキル定義
- `.claude/commands/` : スラッシュコマンド定義

## Knowledge管理ルール
- knowledge/ 配下のフォルダ名・ファイル名・YAMLスキーマは固定ではない
- ヒアリング中にドメインの実態に合わせて構造を変更してよいが、**必ずユーザーに提案し許諾を得てから変更する**
- 書き込み後の検証・メンテナンスルールは `.claude/skills/knowledge-guard/SKILL.md` に定義

## サブエージェントの使い方
- domain-collector: ドメイン知識収集時に起動。knowledge/ を読み書きする
- research-analyst: 競合分析・市場調査時に起動。WebSearch/WebFetchを使う
- prd-writer: PRD生成時に起動。全インプットを統合してPRDを書く

## 出力ファイル命名規約
- PRD本体: `outputs/{機能名}_{YYYY-MM-DD}.md`（例: `outputs/AI提案機能_2026-03-14.md`）
- 機能名は日本語で、PRDのタイトルに合わせる

## 言語
ユーザーとの対話、PRD、Knowledge、すべて日本語で行う
