# 工业智能体双画幅视频工作流

这是从 10 个已审核通过的工业智能体视频任务中固化出的可复用工作流。每个任务同时交付 16:9 与 9:16，使用同一套事实、晓辰口播和时间线，但分别进行原生构图。

## 项目谱系

- 母版：“生成两种手机仿真视频”／多零件产品仿真自动化智能体。
- 8 个母版衍生任务：工业经验传承、制造日报、关键设备故障诊断、化工 HSE 巡检、工业采购、订单履约风险、订单经营、非标制造报价。
- 独立复跑验证：材料配方优化 Run 01。

10 个工业任务均于 2026-09-14 完成最终渲染、交付验证和用户审核。

## 仓库内容

- `handoff.md`：全项目统一交接、坑点总表和下一任务完成定义。
- `handoffs/`：10 个任务的 canonical 最终交接。
- `reviews/`：成品索引、审核说明和成品库规则，仅保留文本证据。
- `skill/build-industrial-agent-videos/`：可安装的 Codex Skill、参考规则和 `verify_pair.ps1`。

## 使用

将 `skill/build-industrial-agent-videos` 复制到 Codex skills 目录，然后在工业双画幅视频任务中调用 `$build-industrial-agent-videos`。运行前先阅读 Skill 路由要求的参考文件。

## 媒体说明

已审核 MP4、JPG、WAV、生成素材和 HyperFrames 缓存保留在本地成品库及源工程中，不上传 GitHub。本仓库只保存工作流、最终交接和审核元数据，避免大文件、重复硬链接和客户素材进入代码仓库。

本地成品根目录：`C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过`。
