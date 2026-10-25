# zcode-skills · 技能收藏夹

为本机 ZCode 臻选技能的唯一仓库：从三个上游逐字精选（不 fork 上游、不改技能内容），CI 每周对上游重建，变更以 PR 呈现，merge 后本机两条命令更新。

## 定位

- **选型唯一事实源**：`curation.tsv`——一行一个技能（`owner/repo`＋仓内路径＋落位名）。增删技能＝改此文件。
- **快照纪律**：逐字上游快照，仅统一剔除各技能的 `agents/`（Codex 专用配置，宿主忽略）；宿主引用（sub-agent/Skill tool）已验证与本机 ZCode 原语对应，零改字。
- **治理**：tracker 链（triage、setup-matt-pocock-skills、to-spec、wayfinder、implement、implement-spec）与 pr 在 hermes-mobile 工作区停用（TASK_MAP 规约行），防第二工单账本；本仓不裁剪这些技能，裁剪发生在使用侧。

## 更新流（更新跟随的解法）

1. 每周一 03:00 UTC（北京 11:00）`upstream-sync` workflow 克隆三个上游、按 `curation.tsv` 重建 `imported-skills/skills/`；
2. 有差异＝自动开/更新 PR（含版本号 bump）；无差异＝静默通过。上游路径重构会让 workflow 硬失败（MISSING），不静默；
3. merge PR 后本机：

```bash
zcode plugins marketplace update curated-skills
zcode plugins update imported-skills@curated-skills
```

本地手动同步：`bash scripts/sync-skills.sh`（与 CI 共用同一脚本，改完 curation.tsv 后跑）。

## 结构

```
marketplace.json        市场清单（单插件 imported-skills，市场名 curated-skills）
imported-skills/        插件本体（skills/<name>/SKILL.md＋捆绑资产）
curation.tsv            选型唯一事实源
scripts/sync-skills.sh  重建器（本地与 CI 共用）
.github/workflows/      周检 workflow（schedule＋workflow_dispatch）
```

## 许可与署名

- mattpocock/skills：MIT（LICENSE 原文随仓；本仓致谢 Matt Pocock，aihero.dev）
- heygen-com/hyperframes：Apache-2.0
- anthropics/skills（frontend-design）：Apache-2.0（许可原文随技能目录 LICENSE.txt 保留）

三个许可均允许再分发；如转公开仓，保留上述署名与随附许可文件即可。本仓默认私有。

## 本机消费

市场注册：`zcode plugins marketplace add Bryce-Peng/zcode-skills`（github 源）。
注意：本仓 ≠ 本机 `local-tools` 市场（后者只承载机器特定的 rea 插件）。
