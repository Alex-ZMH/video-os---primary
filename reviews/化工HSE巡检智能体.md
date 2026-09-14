# 化工HSE巡检智能体｜审核说明

状态：已通过

用户确认日期：2026-09-14  
审核意见：用户明确确认“审核通过”。

## 成品信息

| 版本 | 文件 | 分辨率 | 时长 | 大小 | 原始文件路径 |
| --- | --- | --- | --- | --- | --- |
| v01 / 16:9 | `化工HSE巡检智能体__16x9__v01.mp4` | 1920×1080 | 77.3667 秒 | 103,626,482 字节（约 98.8 MiB） | `C:\Users\ironman\Desktop\video-sucai\output\hse-inspection-compliance-video\hse-agent-landscape\renders\化工HSE巡检智能体__16x9__v01.mp4` |
| v01 / 9:16 | `化工HSE巡检智能体__9x16__v01.mp4` | 1080×1920 | 77.3667 秒 | 96,556,825 字节（约 92.1 MiB） | `C:\Users\ironman\Desktop\video-sucai\output\hse-inspection-compliance-video\hse-agent-portrait\renders\化工HSE巡检智能体__9x16__v01.mp4` |

两条成品 MP4 均以 NTFS 硬链接进入本目录，未复制大文件。

## 自动自检

- 双项目 `verify_pair.ps1 -Runs 1` 交付门禁通过，且两条最终 MP4 均纳入检查。
- 两版均为 H.264 视频、AAC 双声道音频、30 fps，时长和目标画幅一致。
- HyperFrames runtime、layout、motion、contrast 均为 0 errors；对比度 20/20 通过。
- 三段正式口播横竖文件名和 SHA-256 一致；SenseVoice 全量转写无提示词泄漏。
- 9:16 使用独立原生竖构图素材，不是 16:9 裁切。
- 封面均从对应最终视频 4.0 秒画面抽取并完成目视检查。
- 保留非阻断 warning：三张强场景图跨相邻节拍复用；九节拍使用单轨时间线。已核对画面和时间轴，不影响成品。

## 人工审核结论

- 用户已整体确认 v01 双画幅成片通过。
- 本次通过覆盖口播、两项项目数据、横竖版画面与字幕、HSE 现场表达及人工责任边界。
