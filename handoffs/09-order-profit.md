# 03-3 订单经营与利润智能体｜交接

## 范围

为汽车维修零部件项目制作两支内容锁定、构图分别原生适配 16:9 与 9:16 的手机经营界面仿真视频。保留原 ERP，以客户订单为主线映射销售、采购、入库、加工装配、库存、发货、应付款和回款，并以消息卡片提醒价格、库存、付款或交付异常。

## 项目

- 16:9：`hyperframes-landscape`，1920×1080。
- 9:16：`hyperframes-portrait`，1080×1920；使用独立竖版仓库素材 `auto-parts-warehouse-portrait-v1.png`，不是横版裁切。
- 两版总时长均为 82.00 秒，口播、场景顺序、数据边界和三条 WAV 完全一致。

## 口播

- 声音：`jarvis-b` CosyVoice3 / 晓辰参考音色。
- 版本：`order-profit-v1`，正常 1× 语速，无 `atempo` 或 `data-playback-rate`。
- 时长：28.32s、25.28s、26.20s；段间各保留 0.5s 自然呼吸，片尾 1.2s。
- 首段候选通过 SenseVoice 转写检查，无提示词串入。

## 成果边界

- 已实现：订单全链路经营看板、应付款业务追溯、基础异常主动提醒。
- 未作为已实现量化成果：利润提升、成本下降、减少重复订货。
- 手机内金额、编号和数量均标注为示例数据，不代表客户真实经营指标。

## 当前状态

- 用户于 2026-09-14 明确确认 v04 双版审核通过；当前状态为“已通过”。
- v01、v02 因正式成片手机明细未显现而判定不合格；仅保留为失败记录，不进入成品库。
- v03 修复了业务明细捕获，但已被补齐九套独立工业背景及背景运动的 v04 取代；v03 仅保留在项目 `renders/` 用于回滚。
- v04 两版 HyperFrames 检查通过；runtime、motion、contrast 无错误，唯一 `timeline_track_too_dense` 为非阻断提示。
- 最终配对门禁 `verify_pair.ps1 -Runs 1` 通过：`ok=true`、82 秒、三条口播同名同 SHA-256、横竖容器均已检查、竖版独立素材正确、无播放速率覆盖。
- 已从两支 v04 最终 MP4 检查九个场景的中间帧和全部 `start / +0.15 / +0.40` 入场帧；业务内容完整，九套工业背景不同，背景运动持续，无空白、闪现或横版裁切。
- 16:9 v04：`hyperframes-landscape\renders\order-profit-agent__16x9__v04.mp4`，7,131,830 bytes，SHA-256 `7E7FEF642E50229789BDBBBC3D78A53982BCEB7DC1C41C852E8E7958A5E8FB4C`。
- 9:16 v04：`hyperframes-portrait\renders\order-profit-agent__9x16__v04.mp4`，8,673,682 bytes，SHA-256 `E5F81DD11A423D7E2FA548DD92DD0EA3C479D6D265D6211045597CE5B3FFDF0B`。
- 已通过库：`C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过\订单经营智能体`。
- 16:9 预览：<http://localhost:3016/#project/hyperframes-landscape>
- 9:16 预览：<http://localhost:3017/#project/hyperframes-portrait>

## 关键坑点与交付约束

- Studio/项目快照正常不代表最终捕获正常；v01、v02 的 52.8 秒应付款明细在编码后为空，因此关键业务场景必须从最终 MP4 抽帧。
- 对渲染捕获敏感的业务明细采用 seek-safe 初始化；不要让关键内容只依赖异步查询参数或延迟行级 cascade tween。
- 最终高质量渲染必须串行执行：`npm run render -- --quality high --workers 1 --low-memory-mode --output <versioned.mp4>`。
- 已通过目录只放 v04 两支 MP4、两张代表性封面和 `审核说明.md`；视频使用 NTFS 硬链接，不复制临时文件或失败版本。
- 成品索引已登记 v04 为当前通过版本。

## 沉淀 Skill

- `C:\Users\ironman\.codex\skills\build-industrial-agent-videos`
- 已增加订单经营/利润类叙事 archetype，并通过 `quick_validate.py`。
