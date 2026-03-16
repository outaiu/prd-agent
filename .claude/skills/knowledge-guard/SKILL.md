---
name: knowledge-guard
description: knowledge/への書き込み後に実行する検証・メンテナンスプロトコル
context: fork
---

あなたはknowledge/の整合性を検証するガードスキルです。

## 概要
knowledge/への書き込み後に6つの検証チェックを実行し、ルール違反を検出・修正する。
`$ARGUMENTS` で対象ファイルパスまたは実行モードを受け取る。

## 実行モード

### 通常モード（デフォルト）
書き込み後のファイルを対象に検証を実行する。
`$ARGUMENTS` にチェック対象のファイルパス（複数可、カンマ区切り）を渡す。

### ヘルスチェックモード
`$ARGUMENTS` に `--health-check` が含まれる場合、knowledge/全体を走査して一括レポートを出力する。

---

## 検証チェックリスト

### 1. FILE_SIZE — ファイルサイズチェック
- 書き込み後のYAMLファイルの行数を確認する
- **200行超の場合:** ユーザーに分割案を提示し、許諾を得てから実行する
- **判定:** PASS（200行以下） / WARN（200行超）

### 2. UPDATED_AT — 日付フィールドチェック
- 書き込んだYAMLファイルに `updated_at` フィールドが存在すること
- `updated_at` の値が今日の日付（$CURRENT_DATE）であること
- **不備の場合:** 自動修正する（`updated_at: "YYYY-MM-DD"` を追加/更新）
- **判定:** PASS / AUTO-FIXED

### 3. SCHEMA_LOG — スキーマ変更ログチェック
- フォルダ構造の新規作成・名称変更、またはYAMLフィールドの追加・削除があった場合
- `knowledge/_schema-changelog.yaml` に該当する変更エントリが存在すること
- **不備の場合:** 自動でエントリを追記する
- **判定:** PASS / AUTO-FIXED / N/A（構造変更なし）

### 4. INDEX_SYNC — インデックス同期チェック
- `knowledge/{product}/_index.yaml` が存在すること
- 書き込んだfeatureが `_index.yaml` の `features` リストに記載されていること
- 各featureの `has_feature_yaml`, `has_prd_history`, `last_updated` が実態と一致すること
- **不備の場合:** `_index.yaml` を自動作成/更新する
- **判定:** PASS / AUTO-FIXED

**_index.yaml スキーマ:**
```yaml
product: "{プロダクト名}"
features:
  - name: "{機能名}"
    path: "{フォルダ名}/"
    has_feature_yaml: true/false
    has_prd_history: true/false
    last_updated: "YYYY-MM-DD"
updated_at: "YYYY-MM-DD"
```

### 5. FEATURE_COMPLETENESS — 機能フォルダ完全性チェック
- featureフォルダに `prd-history/` が存在するなら `_feature.yaml` も存在すべき
- **不備の場合:** 警告を出力し、`_feature.yaml` の作成を提案する
- **判定:** PASS / WARN

### 6. ACCESS_PATTERN — アクセスパターンチェック
- knowledge/の読み込みは全読みではなく、Glob/Grepで必要箇所を特定してからReadする
- Read toolのoffset/limitパラメータを活用して部分読み込みする
- **ナレッジ蓄積に伴うトークン浪費を防止するため、以下のプロトコルを遵守:**
  1. まず Glob で対象ファイルの存在を確認
  2. Grep で必要なキー（フィールド名）を検索し、該当行を特定
  3. Read の offset/limit で必要範囲のみ読み込む
  4. _product.yaml 全体の読み込みは初回セッションのみ許可。2回目以降は差分確認のみ
- **このチェックは書き込み前に実行し、違反時は書き込みをブロックする**
- 違反を検出した場合、Glob/Grep→Read の順に再実行してからやり直すよう指示する
- **判定:** BLOCK（全読みを検出した場合） / PASS（部分読みの場合）

---

## 実行手順

### 通常モード
1. `$ARGUMENTS` から対象ファイルパスを取得
2. 各チェックを順次実行
3. 結果を以下のフォーマットで出力:

```
## knowledge-guard 検証結果

| チェック | 結果 | 詳細 |
|---------|------|------|
| FILE_SIZE | PASS | {ファイル名}: {行数}行 |
| UPDATED_AT | AUTO-FIXED | {ファイル名}: updated_at を追加 |
| SCHEMA_LOG | N/A | 構造変更なし |
| INDEX_SYNC | AUTO-FIXED | _index.yaml に {feature} を追加 |
| FEATURE_COMPLETENESS | PASS | - |
| ACCESS_PATTERN | WARN | Glob/Grep→Read の順でアクセスしてください |
```

4. AUTO-FIXEDの項目がある場合、修正内容のサマリーを追記
5. WARNの項目がある場合、推奨アクションを追記

### ヘルスチェックモード
1. knowledge/ 配下の全プロダクトフォルダを走査
2. 各プロダクトについて:
   a. `_index.yaml` の存在と整合性を確認
   b. 全featureフォルダに対してチェック1〜5を実行
3. 一括レポートを出力:

```
## knowledge-guard ヘルスチェックレポート

### {プロダクト名}
- _index.yaml: {存在する/存在しない}
- feature数: {N}

| Feature | FILE_SIZE | UPDATED_AT | SCHEMA_LOG | INDEX_SYNC | COMPLETENESS |
|---------|-----------|------------|------------|------------|--------------|
| {name}  | PASS      | PASS       | N/A        | PASS       | PASS         |
| {name}  | WARN      | AUTO-FIXED | N/A        | AUTO-FIXED | WARN         |

### 要対応項目
- [ ] {対応が必要な項目の説明}
```

4. AUTO-FIXが発生した場合は修正を実行し、修正内容を報告
5. WARNの項目については推奨アクションをリストアップ

---

## 重要ルール
- FILE_SIZEの分割実行は**必ずユーザーの許諾を得てから**行う
- FEATURE_COMPLETENESSの `_feature.yaml` 作成も**ユーザーの許諾を得てから**行う
- UPDATED_AT、SCHEMA_LOG、INDEX_SYNCは自動修正してよい
- 修正を行った場合は、修正したファイルパスを必ず報告する
