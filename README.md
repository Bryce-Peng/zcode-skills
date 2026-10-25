# zcode-skills · 技能收藏夹（Curated Skills Shelf）

一个面向 agentic coding 环境的技能收藏夹：从活跃上游**逐字精选**技能（不 fork、不改内容），并配一套 **CI 驱动的更新跟随机制**——每周自动对照上游重建，变更以 PR 呈现，merge 即完成升级。

## 它提供什么

1. **一份精选清单**（22 个技能，来源：mattpocock/skills 17＋anthropics/skills 1＋heygen-com/hyperframes 4）：
   - 逼问组（grilling、grill-me、grill-with-docs）——动手前主动消除模糊，把设计树问到每个分支有答案；
   - 架构组（improve-codebase-architecture、codebase-design、domain-modeling）——深化模块、接口选型、领域建模；
   - 流程纪律（tdd、diagnosing-bugs、code-review、pr）——测试先行、诊断循环、双轴评审；
   - 任务链（triage、setup-matt-pocock-skills、to-spec、wayfinder、implement、implement-spec）——spec→工单→实施的发布流程；
   - 表达与创作（writing-for-agents、frontend-design、hyperframes 四件套）——agent 侧文档、UI 设计方向、HTML 渲染视频。

2. **一个可复用的收藏夹模式**：`curation.tsv` 是选型唯一事实源——一行一个技能（`owner/repo`＋仓内路径＋落位名），改一行即收录或剔除；`scripts/sync-skills.sh` 按 manifest 从上游重建；GitHub Actions 每周对上游跑同一脚本，**升级只发生在你点 merge 的时刻**。任何想"收藏上游技能但又不手动搬运"的设置都可以整套搬走。

## 纪律

- 逐字上游快照，仅统一剔除各技能的 `agents/`（Codex 专用配置，其他宿主自动忽略）；
- 上游路径重构会让 workflow **硬失败**（MISSING 报警），绝不静默降级；
- 内容无差异时判 UP-TO-DATE：不 bump 版本、不开 PR（拒绝空转）；
- 收藏夹只决定装什么，不约束怎么用——触发面治理（如停用某些技能）由使用方在使用侧自行约定。

## 更新流

1. 每周一 03:00 UTC，`upstream-sync` workflow 按当前 manifest 重建；
2. 上游有差异＝自动开/更新 PR（含版本号 bump）；
3. merge 后拉取：

```bash
zcode plugins marketplace update curated-skills
zcode plugins update imported-skills@curated-skills
```

本地手动同步：`bash scripts/sync-skills.sh`（与 CI 共用同一脚本）。

## 安装（ZCode）

```bash
zcode plugins marketplace add Bryce-Peng/zcode-skills
zcode plugins install imported-skills@curated-skills
```

技能以 `imported-skills:<名称>` 暴露（别名即裸名，如 `tdd`、`grilling`）。

## 结构

```
marketplace.json        市场清单（单插件 imported-skills，市场名 curated-skills）
imported-skills/        插件本体（skills/<name>/SKILL.md＋捆绑资产）
curation.tsv            选型唯一事实源
scripts/sync-skills.sh  重建器（本地与 CI 共用）
.github/workflows/      周检 workflow（schedule＋workflow_dispatch）
```

## 来源与许可

- mattpocock/skills：MIT（Copyright (c) 2026 Matt Pocock, aihero.dev）
- heygen-com/hyperframes：Apache-2.0
- anthropics/skills（frontend-design）：Apache-2.0（许可原文随技能目录 LICENSE.txt 保留）

三个许可均允许再分发；随附的许可与署名文件在精选时一并保留。
