---
name: value-proposition
description: JTBD型バリュープロポジション設計フレームワーク。prd-writerサブエージェントが参照する。
user-invocable: false
---

# バリュープロポジション スキル

JTBD（Jobs-to-be-Done）型のバリュープロポジション設計フレームワーク。
PRDの「仮説」セクションの基盤となる。

## JTBD型 6パートフレームワーク

### 1. Who（誰が）
- ターゲットユーザーの具体的な特定
- ペルソナとの紐付け（Knowledge参照）
- セグメント別の分類

### 2. Why（なぜ）
- ユーザーが達成したいJob（仕事・目標）
- 機能的Job: 実用的に達成したいこと
- 感情的Job: どう感じたいか
- 社会的Job: 他者からどう見られたいか

### 3. What before（現状）
- 現在のソリューション（既存の解決策）
- 現状の課題・ペインポイント
- 我慢している不満・妥協点
- 代替手段とその限界

### 4. How（どのように解決するか）
- 提案するソリューションの概要
- 既存ソリューションとの違い
- 独自の価値提供メカニズム

### 5. What after（解決後の状態）
- ユーザーが得られる具体的なベネフィット
- 定量的な改善指標
- 感情的・社会的な変化

### 6. Alternatives（代替手段）
- 競合プロダクト
- 代替手段（手動作業、内製等）
- スイッチングコスト・障壁
- なぜ自社ソリューションが選ばれるか

## PRD「仮説」セクションとの対応

JTBD 6パートを PRDの仮説構造に変換する:

```
{Who} の、{What before = Pain} という課題を、
{How} することで {What after = Gain} できる
```

### ステークホルダー別の変換

各ステークホルダー（クライアント、ランサー、運営）について:

1. **Who → ステークホルダー特定**
   - Knowledge のペルソナ情報を活用
   - 最も影響を受けるセグメントを特定

2. **Why + What before → Pain 構造化**
   - 機能的Pain: 「〇〇ができない」「〇〇に時間がかかる」
   - 感情的Pain: 「〇〇が不安」「〇〇にストレスを感じる」
   - 定量的Pain: 「〇〇が〇〇%低い」「〇〇件の問い合わせ」

3. **How + What after → Gain 構造化**
   - 機能的Gain: 「〇〇が可能になる」「〇〇が〇〇%短縮される」
   - 感情的Gain: 「〇〇が安心できる」
   - 定量的Gain: 「〇〇が〇〇%向上する」

## 検証可能性チェック

仮説は以下の基準で検証可能性を確認:

1. **測定可能:** 数値で測れるか
2. **期限設定:** いつまでに検証するか
3. **判定基準:** 何をもって検証成功/失敗とするか
4. **検証方法:** どのようにデータを収集するか

## 仮説の優先度評価（Impact × Risk マトリクス）

| | 高Impact | 低Impact |
|---|---|---|
| **高Risk（不確実）** | 最優先で検証 | 検証コスト次第 |
| **低Risk（確実）** | 実装優先 | 優先度低 |

## 具体例: Canva（pm-skills より）

| パート | 内容 |
|--------|------|
| **Who** | デザイナーではないがマーケティンググラフィックを作る必要がある人 |
| **Why** | プロフェッショナルなデザインが必要だが、デザイナーを雇えず、複雑なツールも使えない |
| **What Before** | PowerPoint（限定的）、Photoshop（難しすぎる）、デザイナーに外注（高価で遅い） |
| **How** | ドラッグ&ドロップテンプレート、組み込みデザイン要素、AIデザイン支援、直感的UI |
| **What After** | 数分でプロ品質のデザインを作成、キャンペーンを素早く立ち上げ、デザインコスト削減 |
| **Alternatives** | Photoshop（複雑）、Fiverr（遅い・高価）、競合ツール（テンプレート少・UX劣る） |

## このテンプレート vs Strategyzer's Value Proposition Canvas

Strategyzer のキャンバス（Alexander Osterwalder）は広く使われているが構造的限界がある。
この6パート JTBD テンプレート（Paweł Huryn & Aatir Abdul Rauf）はそれを改善:

1. **顧客ファースト:** Who/Whyから始めてソリューションへ進む（Strategyzerはプロダクト側から始めがち）
2. **1セグメントずつ:** 1回のパスで1セグメントに集中（Strategyzerは複数同時で焦点がぼける）
3. **代替手段の明示:** セクション6で代替手段と直接対決（Strategyzerには同等のものがない）
4. **シンプル構造:** 「What before → How → What after」は Jobs/Pains/Gains/Pain Relievers/Gain Creators の分離より直感的
5. **アクショナブルな出力:** 最終的な Value Proposition Statement はマーケティング・営業・オンボーディングにそのまま使える

## 出力フォーマット

```yaml
value_proposition:
  feature: "{機能名}"
  stakeholder: "{ステークホルダー}"
  jtbd:
    who: "{具体的なユーザー像}"
    why:
      functional_job: "{機能的Job}"
      emotional_job: "{感情的Job}"
      social_job: "{社会的Job}"
    what_before:
      current_solution: "{現在の解決策}"
      pain_points:
        - pain: "{Pain1}"
          evidence: ["{根拠1}", "{根拠2}"]
        - pain: "{Pain2}"
          evidence: []  # 根拠なしの場合
    how: "{ソリューション概要}"
    what_after:
      benefits: ["{Benefit1}", "{Benefit2}"]
      metrics: ["{改善指標}"]
    alternatives: ["{代替手段}"]
  hypothesis: "{Who}の、{Pain}という課題を、{How}することで{Gain}できる"
  validation:
    metric: "{検証指標}"
    target: "{目標値}"
    deadline: "{期限}"
    method: "{検証方法}"
  value_prop_statement: "{1-2文の簡潔なバリュープロポジション文}"
```

## 注意事項
- JTBD は人口統計ではなく、顧客が達成しようとしている進歩に焦点を当てる
- バリュープロポジションはセグメント固有。顧客グループごとに異なるバリュープロポジションが必要
- 確定前に実際の顧客でテストすること
- **Value Curve**（Blue Ocean Strategy）を使って、主要要素ごとに競合との差を視覚化する
