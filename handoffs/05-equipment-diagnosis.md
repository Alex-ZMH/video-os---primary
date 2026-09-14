# 02-2 关键设备故障诊断智能体｜会话交接

## 当前状态

**双版最终渲染与交付门禁已完成，用户已于 2026-09-14 审核通过，成品已进入“01_已通过”。**

已完成一套内容一致、构图分别适配 16:9 和 9:16 的石化关键设备故障诊断智能体视频工程。两个项目共用同一份口播、同一条 92.88 秒时间线和同一组结论；竖版使用 9 张独立生成的原生竖图，没有裁切横版画面。

## 项目与成片

- 横版项目：`C:\Users\ironman\Desktop\video-sucai\output\equipment-diagnosis-agent-video\hyperframes-landscape`
- 横版成片：`C:\Users\ironman\Desktop\video-sucai\output\equipment-diagnosis-agent-video\hyperframes-landscape\renders\equipment-diagnosis-agent-landscape-v01.mp4`
- 竖版项目：`C:\Users\ironman\Desktop\video-sucai\output\equipment-diagnosis-agent-video\hyperframes-portrait`
- 竖版成片：`C:\Users\ironman\Desktop\video-sucai\output\equipment-diagnosis-agent-video\hyperframes-portrait\renders\equipment-diagnosis-agent-portrait-v01.mp4`
- 已通过目录：`C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过\石化关键设备故障诊断智能体`

## 内容与时间线

9 个镜头依次是：异常出现、线索分散、时间线还原、多源关联、原因排序、夜班初判、工单闭环、安全边界、项目成效。

只使用用户提供的项目数据：诊断准确率 90% 以上、处置效率提升 80%、连续运行 60 天、完整判断从人工约 2–3 小时缩短至系统约 1 分 11 秒。停机、设备切换和控制参数调整仍明确保留授权人员确认。

口播使用 `jarvis-b` 的晓辰参考声纹，通过共享 `createJarvisVoiceTransport` 生成，正常 1× 语速，三段之间各保留 0.5 秒：

- `narration-01-sunny-v2.wav`：30.76 秒，SHA-256 `8DFC32EFBA9BE2160E3768E6D68D2A66CCA99205641F83EA88DEDCF2BF781326`
- `narration-02-sunny-v2.wav`：27.52 秒，SHA-256 `EF7FF1A3A3DD2137A6B52D1FAFEE5FEC5F402076371B5820980110D64C99B8A0`
- `narration-03-sunny-v2.wav`：32.40 秒，SHA-256 `FB31C0827EECAC73C248F1C69BA4C184F15C2247ED013F17989DF659AD405BD7`

三段都已经 SenseVoice 转写检查；横竖项目的三个 WAV 文件名与 SHA-256 一致。`sunny-v1` 第一段仅是未通过的发音候选，没有被时间线引用，也没有复制到竖版项目。

## 验证证据

- HyperFrames 版本：`0.8.34`，两个项目都是最新固定版本。
- 横竖版 `check --snapshots` 都通过：runtime、layout、motion、contrast 错误均为 0，各 20/20 文字对比度检查通过。
- `verify_pair.ps1 -Runs 1` 最终通过：画幅、总时长、口播数量/文件名/SHA-256、横竖原生图片方向均一致。
- 带双版最终 MP4 路径的 `verify_pair.ps1 -Runs 1` 交付门禁通过：`ok=true`，两支视频均已纳入检查。
- 横版 `ffprobe`：H.264/AAC、1920×1080、30 fps、92.900 秒、103,101,284 字节。
- 竖版 `ffprobe`：H.264/AAC、1080×1920、30 fps、92.900 秒、98,229,436 字节。
- 第一次成对验证中横版 HyperFrames 浏览器检查出现过一次非零退出，随后横版独立完整检查与一次完整成对验证都通过。这次瞬时信号已保留在交接中，不宣称为三次重复稳定性通过。
- 唯一非阻断警告为 `timeline_track_too_dense`（9 个场景放在同一轨道）；根据已固化工作流，不仅为消除该警告做大规模拆分。
- 已人工检视横竖场景素材联系表与组装抽帧；画面为可信的石化控制室、泵/压缩机和现场检修场景，未添加品牌、可读伪数据或未经支持的结论。

## 审核结果

用户于 2026-09-14 明确确认“审核通过”。已确认的人工审核点包括：

1. 晓辰口播的明亮程度、语速和石化术语发音。
2. 9 个镜头的画面、大字和口播含义是否一致。
3. 9:16 字幕安全区、底部文字大小和人物/设备构图。
4. 第 8 镜的人工授权边界，以及第 9 镜的四项效果数据。

## 已完成的交付路径

1. 已按总任务槽位依次渲染 16:9、9:16，均使用 `--quality high --workers 1 --low-memory-mode`，没有并发或重试。
2. 两支 MP4 已通过 `ffprobe` 与带最终视频路径的 `verify_pair.ps1`。
3. 已从每支成片第 82.0 秒抽取代表性封面并目视检查。
4. 已通过目录严格只有两支最终 MP4、两张 JPG 封面和 `审核说明.md`；两支 MP4 为 NTFS 硬链接，SHA-256 与源文件一致。
5. `成品索引.md` 已登记 v01 通过状态。

## 可复用 Skill

- Skill：`C:\Users\ironman\.codex\skills\build-industrial-agent-videos`
- 调用：`$build-industrial-agent-videos`
- 本次已在 `references/case-archetypes.md` 增加“Critical equipment fault diagnosis”叙事原型，并在 Skill 描述中增加 fault-diagnosis 路由。
- `quick_validate.py` 验证通过。

上一个已完成的 01-2 手机多零件仿真项目交接已归档到 `C:\Users\ironman\Desktop\video-sucai\output\multi-part-simulation-video\handoff.md`。
