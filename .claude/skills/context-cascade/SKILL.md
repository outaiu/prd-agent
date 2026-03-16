---
name: context-cascade
description: サブエージェント間のコンテキスト受け渡しルール。オーケストレーターが参照する。
user-invocable: false
---

# コンテキストカスケード スキル

サブエージェント間のコンテキスト受け渡しルール。
AIPO（miyatti777/aipo）の Context Cascade 設計思想に基づく。

## 基本原則

### コンテキスト最小化の原則
- 全文を渡さず、**サマリーのみ**受け渡す
- ファイルパスで参照し、サブエージェント側で**必要分だけ読む**
- 前段の出力を丸ごと次段に渡さない

### Sense → Focus → Discover → Deliver サイクル

PRD作成フローの4段階はAIPOのサイクルに対応:

| AIPOサイクル | PRDフロー | 担当 |
|-------------|----------|------|
| **Sense** | ドメイン知識収集 | domain-collector |
| **Focus** | PRD要素ヒアリング | Orchestrator |
| **Discover** | 競合・市場リサーチ | research-analyst |
| **Deliver** | PRD生成 | prd-writer |

## 委譲プロトコル

### 1. Orchestrator → domain-collector

**渡すコンテキスト:**
```yaml
task: "domain_collection"
input:
  user_request: "{ユーザーの元の発言}"
  product: "{プロダクト名}"  # デフォルト: ランサーズ
  estimated_feature_category: "{推定カテゴリ}"
  repository_path: "{リポジトリパス}"  # ユーザーが提供した場合のみ。未提供なら null
  scan_target: "{走査対象}"  # ユーザーが指定した機能領域やキーワード。未指定なら null
  knowledge_paths:
    - "knowledge/{product}/_product.yaml"
    - "knowledge/{product}/{feature}/_feature.yaml"  # 存在する場合
  instructions:
    - "既存Knowledgeを確認し、不足分のみヒアリング"
    - "domain-interviewer/SKILL.md の質問票に従う"
    - "AskUserQuestion tool を使用して構造化ヒアリング"
    - "構造変更が必要な場合はユーザーに許諾を得る"
    - "repository_path がある場合は Step 0 でリポジトリ走査を実施"
```

**返却物:**
```yaml
result:
  domain_summary: "{300字以内のドメインサマリー}"
  updated_files: ["{更新ファイルパス}"]
  feature_context: "{機能コンテキスト要約}"
  ost_structure:
    desired_outcome: "{期待成果}"
    opportunities:
      - opportunity: "{機会}"
        why: "{理由}"
        solutions: ["{ソリューション}"]
    high_uncertainty_items: ["{不確実性の高いソリューション}"]
  evidence_items:
    - issue: "{課題}"
      evidence_type: "data|image|voice|unconfirmed"
      content: "{根拠内容/URL/ファイルパス}"
  unanswered_questions: ["{未回答の質問}"]
```

### 2. Orchestrator → research-analyst

**渡すコンテキスト:**
```yaml
task: "research"
input:
  feature_name: "{機能名}"
  feature_summary: "{機能概要}"
  domain_summary: "{domain-collectorからのサマリー}"
  evidence_items: [...]  # domain-collector が収集したエビデンス（補足対象の特定用）
  hypotheses: ["{ヒアリングで得た仮説}"]
  knowledge_paths:
    - "knowledge/{product}/_product.yaml"  # 競合情報参照用
    - "knowledge/{product}/{feature}/competitors.yaml"  # 存在する場合
  instructions:
    - "competitor-analysis/SKILL.md のフレームワークに従う"
    - "market-research/SKILL.md のフレームワークに従う"
    - "Knowledge更新はユーザー許諾不要（追記のみ）"
```

**返却物:**
```yaml
result:
  competitor_summary: "{競合分析サマリー}"
  market_summary: "{市場動向サマリー}"
  differentiation_opportunities: ["{差別化機会}"]
  supplementary_evidence:
    - issue: "{対応するペイン・課題}"
      evidence_type: "data|report|case_study"
      content: "{根拠内容}"
      source: "{出典URL/レポート名}"
  updated_files: ["{更新ファイルパス}"]
```

### 3. Orchestrator → prd-writer

**渡すコンテキスト:**
```yaml
task: "prd_generation"
input:
  feature_name: "{機能名}"
  domain_summary: "{ドメインサマリー}"
  hearing_results:
    hypotheses: [...]
    scope: { in: [...], out: [...] }
    kpi: [...]
    nsm: [...]
    user_stories: [...]
    requirements: { must: [...], want: [...] }
    risks: [...]
    exit_criteria: [...]
  research_summary:
    competitors: "{競合サマリー}"
    market: "{市場サマリー}"
    differentiation: [...]
    supplementary_evidence: [...]  # research-analyst が発見した補足根拠
  knowledge_paths:
    - "knowledge/{product}/_product.yaml"
    - "knowledge/{product}/{feature}/_feature.yaml"
  instructions:
    - "prd-template/SKILL.md のフォーマットに従う"
    - "value-proposition/SKILL.md で仮説を強化"
    - "user-stories/SKILL.md でストーリーを強化"
    - "quality-checker/SKILL.md で品質チェック"
    - "outputs/{機能名}_{YYYY-MM-DD}.md に出力"
```

**返却物:**
```yaml
result:
  prd_path: "outputs/{機能名}_{YYYY-MM-DD}.md"
  quality_check:
    passed: true|false
    score: "{PASS数}/{全項目数}"
    failed_items: ["{FAIL項目}"]
    needs_confirmation: ["{要確認項目}"]
  prd_summary_path: "knowledge/{product}/{feature}/prd-history/{YYYY-MM-DD}.yaml"
```

## Fractal Decomposition（再帰分解）

Comprehensive 判定時、要件が大きすぎる場合は再帰的に分解:

```
大きな要件
├── サブ要件1
│   ├── ユーザーストーリー1.1
│   └── ユーザーストーリー1.2
├── サブ要件2
│   ├── ユーザーストーリー2.1
│   └── ユーザーストーリー2.2
└── サブ要件3（Phase2に先送り）
```

分解の判断基準:
- 1つの要件に3つ以上のステークホルダーが関わる → 分解
- 1つの要件の実装見積もりが1スプリントを超える → 分解
- 1つの要件に独立した2つ以上のユーザーフローが含まれる → 分解

## エラーハンドリング

### サブエージェントがタイムアウトした場合
- 部分的な結果があれば活用する。判定基準は prd-orchestrator の Gate 条件に準拠:
  - **research-analyst:** competitor_summary が存在すればPRD生成に進行可能（market_summary は空でも許容）
  - **domain-collector:** domain_summary が存在すれば次ステップに進行可能
  - **prd-writer:** PRDファイルが出力されていれば品質チェック結果に関わらず提示可能
- 不足分を Orchestrator が補完
- ユーザーに状況を報告（どの情報が取得できなかったかを明示）

### サブエージェントの出力が不十分な場合
- 不足項目を特定
- 追加の指示で再実行を試みる
- 3回失敗したら Orchestrator が直接実行

## AIPO設計思想の適用（miyatti777/aipo より）

### Context情報の二層構造

AIPOのContext管理は2層で構成される。PRDエージェントでもこれを適用:

1. **Knowledge/フォルダ（実体）** — 収集したドメイン知識のYAMLファイル群
2. **サマリー（Index）** — 各段階で生成される300字以内の要約

**なぜこの構造が重要か:**
- サブエージェント間でサマリーのみ渡すことで、コンテキスト消費を最小化
- 詳細が必要な場合はKnowledgeファイルを直接参照
- 各フェーズで蓄積したKnowledgeが次のPRDでも再利用可能

### HITL（Human In The Loop）統合

AIPOの「HITL統合型コマンド」の考え方を反映:

- **AI自動実行Phase:** Knowledge読み込み、分析、生成など
- **HITL Phase:** ユーザーの判断・確認が必要な箇所

PRDフローにおけるHITLポイント:
1. **深度判定後:** PRD作成に進むかの確認
2. **ドメインヒアリング中:** AskUserQuestion による構造化質問（Call A-1, A-2, B-1, B-2）
3. **PRD要素ヒアリング中:** AskUserQuestion による構造化質問（Call P-1〜P-4）
4. **PRD生成後:** レビューと修正指示

### セッション管理ルール

大規模PRD（Comprehensive判定）の場合、セッション管理が重要になる。

#### 分割トリガー（いずれか1つで発動）
- **ヒアリング応答量:** domain-collector または Orchestrator のヒアリング応答が合計8回を超えた
- **ターン消費率:** サブエージェントの turn 消費が maxTurns の 70% を超えた（domain-collector: 11/15, research-analyst: 14/20, prd-writer: 18/25）
- **Knowledgeサイズ:** 単一 _feature.yaml が 200行を超えた → knowledge-guard の FILE_SIZE チェックをトリガー

#### 分割提案の方式
- 分割トリガーに該当した時点で、**システム側から能動的に**「ここまでの内容を保存して次回に続けますか？」とユーザーに提案する
- ユーザーの「ここまでで止めて」等の明示的な要求を待たない

#### 分割時のプロトコル
1. ユーザーに「ここまでの内容を保存して次回に続けますか？」と確認
2. Yes の場合:
   - 中間結果を `knowledge/{product}/{feature}/_session.yaml` に保存
   - 保存内容: 完了ステップ、ヒアリング回答、サブエージェント出力サマリー、未完了タスク
3. 再開時:
   - `_session.yaml` が存在すれば自動検出し、「前回の続きから再開しますか？」と確認
   - Yes なら保存済みの中間結果をロードし、未完了ステップから再開
   - No なら `_session.yaml` を削除して最初から開始

#### _session.yaml フォーマット
```yaml
session:
  created_at: "YYYY-MM-DD HH:mm"
  last_step_completed: "step_1|step_2|step_3|step_4"
  depth: "Minimal|Standard|Comprehensive"
  domain_summary: "{300字以内}"
  hearing_results:
    completed_calls: ["P-1", "P-2"]  # 完了済みCall
    answers: { ... }                  # 回答内容
  research_summary: "{リサーチ結果要約}"  # Step 3完了時のみ
  pending_tasks: ["{未完了タスク}"]
```
