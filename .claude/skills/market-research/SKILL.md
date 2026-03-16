---
name: market-research
description: 市場規模算出と業界トレンド調査のフレームワーク。research-analystサブエージェントが参照する。
user-invocable: false
---

# 市場調査 スキル

市場規模の算出と業界トレンド調査のフレームワーク。

## 市場規模算出（TAM / SAM / SOM）

### TAM（Total Addressable Market）: 獲得可能な最大市場規模
- 対象市場全体の規模
- トップダウンアプローチ: 業界レポート・統計データから算出
- 算出式: `市場全体のユーザー数 × 平均単価`

### SAM（Serviceable Addressable Market）: 実際にサービス提供可能な市場
- 地理的・技術的・ビジネスモデル的な制約を反映
- TAMからの絞り込み条件を明示
- 算出式: `TAM × 対象セグメント比率`

### SOM（Serviceable Obtainable Market）: 現実的に獲得可能な市場
- 競合シェア、自社リソース、成長率を考慮
- ボトムアップアプローチ: 現在の顧客数 × 成長率
- 算出式: `SAM × 想定シェア率`

### 算出の進め方

1. **データ収集:**
   - 公開統計データ（政府統計、業界団体レポート）
   - IR資料・決算説明資料
   - 市場調査レポート（矢野経済研究所、IDC等）
   - Web検索による最新データ

2. **前提条件の明示:**
   - 使用したデータソースと時点
   - 採用した定義（「フリーランス」の範囲等）
   - 為替レート（グローバルデータの場合）

3. **感度分析:**
   - 楽観/基準/悲観の3シナリオ
   - 主要パラメータの変動による影響

## 業界トレンド調査

### 調査観点

1. **マクロトレンド:**
   - 政策・規制の変化（働き方改革、インボイス制度等）
   - 技術トレンド（AI、リモートワーク等）
   - 社会的変化（副業解禁、ギグエコノミー等）

2. **業界トレンド:**
   - 市場成長率と予測
   - 新規参入・撤退プレイヤー
   - M&A・資金調達の動向
   - ビジネスモデルの変化

3. **ユーザートレンド:**
   - 行動パターンの変化
   - ニーズの変化
   - チャネルの変化

4. **テクノロジートレンド:**
   - 対象機能に関連する技術進化
   - 競合の技術投資動向
   - 新技術の適用可能性

### Web検索クエリ例
- `{業界名} 市場規模 {年} 予測`
- `フリーランス 市場 トレンド {年}`
- `{業界名} industry report {年}`
- `クラウドソーシング 市場調査 レポート`

## 出力フォーマット

### 市場規模サマリー

```yaml
market_sizing:
  target_market: "{市場名}"
  analyzed_at: "{YYYY-MM-DD}"
  tam:
    value: "{金額}"
    unit: "円|ドル"
    source: "{データソース}"
    year: "{対象年}"
  sam:
    value: "{金額}"
    filters: ["{絞り込み条件}"]
  som:
    value: "{金額}"
    assumptions: ["{前提条件}"]
  growth_rate:
    cagr: "{%}"
    period: "{期間}"
  scenarios:
    optimistic: "{金額}"
    base: "{金額}"
    pessimistic: "{金額}"
```

### トレンドサマリー

```yaml
market_trends:
  analyzed_at: "{YYYY-MM-DD}"
  macro_trends:
    - trend: "{トレンド名}"
      impact: "high|medium|low"
      relevance: "{PRD対象機能との関連性}"
  industry_trends:
    - trend: "{トレンド名}"
      direction: "growing|stable|declining"
      implication: "{自社への示唆}"
  technology_trends:
    - trend: "{技術名}"
      maturity: "emerging|growing|mature"
      applicability: "{適用可能性}"
```

### Knowledge保存

`knowledge/{product}/{feature}/market-research.yaml` に保存:

```yaml
market_research:
  feature: "{機能名}"
  market_sizing: { ... }
  trends: [ ... ]
  implications_for_prd: "{PRDへの示唆}"
  updated_at: "{YYYY-MM-DD}"
```

## 分析ステップ詳細（pm-skills market-sizing より）

### 7段階分析プロセス

1. **Market Definition（市場定義）**
   - 問題空間と顧客ニーズ
   - 地理的・セグメント的境界
   - 主要な制約やスコーピング判断

2. **Top-Down Estimation（トップダウン推定）**
   - 業界全体のサイズから関連スライスに絞り込む
   - ソースと根拠を明示

3. **Bottom-Up Estimation（ボトムアップ推定）**
   - ユニットエコノミクス（顧客数 × 単価 × 頻度）から積み上げ
   - クロスバリデーション用

4. **SAM Scoping（SAM定義）**
   - TAMのうち現実的にサービス提供可能な部分
   - 制約: 地理、言語、チャネル、プロダクト能力、価格帯

5. **SOM Estimation（SOM推定）**
   - 1〜3年で現実的に獲得可能なシェア
   - 根拠: 競争ポジション、GTM能力、現在のトラクション

6. **Growth Projection（成長予測）**
   - 市場を拡大・縮小しうる主要要因
   - 技術、規制、人口動態、行動のシフト

7. **Assumption Mapping（前提マッピング）**
   - 各推定の背後にある重要な前提を番号付きでリスト化
   - 各前提の信頼度（高/中/低）を評価
   - 最も不確実な前提の検証方法を提案

### Market Summary Table テンプレート

```markdown
| 指標 | 現在の推定値 | 2-3年予測 |
|------|------------|----------|
| TAM  |            |          |
| SAM  |            |          |
| SOM  |            |          |
```

## ベストプラクティス
- 常にトップダウンとボトムアップの両方を提示して三角測量する
- 市場データにはWeb検索でアナリストレポート・業界ベンチマークを活用
- データソースを引用する（裏付けのない数字を避ける）
- 推定値とデータを明示的に区別する
- 金額ベース（収益）と数量ベース（ユーザー/ユニット）のサイジングを区別する
- 信頼区間が広い箇所にはフラグを立てる
- 推定を精緻化するための具体的なデータソースや調査を推奨する
