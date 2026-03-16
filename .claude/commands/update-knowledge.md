---
description: Knowledge（ドメイン知識）を手動で更新・確認するコマンド。
---

Knowledgeの手動更新モードを開始します。

1. knowledge/ 配下の現在のファイル構造をGlobで一覧表示する
2. ユーザーに更新したいファイルまたは追加したい情報を確認する
3. 変更がフォルダ構造やYAMLスキーマに及ぶ場合は、変更案を提示して許諾を得る
4. 許諾後に更新を実行し、_schema-changelog.yaml に記録する
5. knowledge-guard/SKILL.md のヘルスチェックモードを実行し、全体の整合性を報告する

$ARGUMENTS
