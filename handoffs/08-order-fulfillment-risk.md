# 订单履约风险智能体视频交接

状态：v01、v04 与 v05 均已审核归档；v05 为当前推荐版本，v04 作为用户明确通过的历史版本保留。

## 预览

- 16:9：http://localhost:3022/#project/hyperframes-cut-short
- 9:16：http://localhost:3023/#project/hyperframes-cut-vertical-short

## 项目

- 16:9：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-short`
- 9:16：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-vertical-short`

## 已完成自检

- 两项目 HyperFrames check 均通过：运行时、布局错误、动效错误均为 0，90/90 文本通过 WCAG AA。
- 已检查 10 个关键时间点及片尾；横竖版均为原生构图。
- 晓辰口播只生成一次并复制到另一画幅；三段音频已做 SHA-256 一致性校验和转写检查。
- 仿真订单、物料和设备字段已标注“仿真演示数据”。
- 98% OTD 与生产延误减少 50% 均明确标为建设与验收目标，未表达为已实现结果。
- 16:9 最终文件：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-short\renders\order-fulfillment-risk-agent-16x9-v01.mp4`。
- 16:9 媒体校验：1920×1080、30 fps、H.264/AAC、92.266667 秒、54,545,919 字节。
- 9:16 最终文件：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-vertical-short\renders\order-fulfillment-risk-agent-9x16-v01.mp4`。
- 9:16 媒体校验：1080×1920、30 fps、H.264/AAC、92.266667 秒、48,100,108 字节。
- 交付级成对验证：`ok=true`、共同编排时长 92.24 秒、3 条配音轨一致、两支最终视频均通过检查。
- 已通过目录：`C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过\订单履约风险智能体`；保留 v01、v04、v05 三组历史通过成片，共 6 支 MP4、6 张封面和 `审核说明.md`，v05 为当前推荐版本。

## 已知非阻断提示

- 每个项目有 3 条结构提示：复用背景图和单轨 9 场景；不影响运行、布局、可读性或渲染。
- 背景 Ken Burns 动效产生容器溢出信息项，属于裁切容器内的预期效果。

## v02 布局修复

- 根因：手机白色面板使用固定高度，空白区域覆盖了工业背景主体。
- 修复：横版面板改为右侧内容自适应；竖版面板改为中上部内容自适应，保留中部照片窗口及底部文案安全区。
- 未改动：场景时长、口播、音频、业务字段与已归档 v01 成品。
- 计划输出：`order-fulfillment-risk-agent-16x9-v02.mp4`、`order-fulfillment-risk-agent-9x16-v02.mp4`。

## v03 浏览器批注修复

- 按 16:9 预览批注，将手机信息层移到画面下方，并同步适配 9:16。
- 外壳及全部内部白色卡片改为半透明深蓝玻璃层；业务字段、风险色、口播、场景时长和动效均未改变。
- 双版 HyperFrames check 均 `ok=true`：runtime、layout、motion、contrast 错误为 0，文本对比度 90/90；关键帧保存在两个项目的 `snapshots-v03`。
- 计划输出：`order-fulfillment-risk-agent-16x9-v03.mp4`、`order-fulfillment-risk-agent-9x16-v03.mp4`。

## v04 可读性与占比重制

- 横版面板缩至 510 px，竖版缩至 780 px；隐藏非必要状态栏并压缩 padding/gap，以较小占比容纳更大的信息字号。
- 玻璃外层透明度提高至 alpha≈0.24、blur 5 px，内卡 alpha≈0.42；第 7 场空态不再显示大块玻璃。
- HyperFrames 项目固定版本已由 0.8.35 升至 0.8.36；双版最终 check 均 `ok=true`，runtime/layout/motion/contrast 错误为 0，文本对比度 80/80。
- 16:9 v04：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-short\renders\order-fulfillment-risk-agent-16x9-v04.mp4`；1920×1080、30 fps、H.264/AAC、92.266667 秒、69,611,301 字节。
- 9:16 v04：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-vertical-short\renders\order-fulfillment-risk-agent-9x16-v04.mp4`；1080×1920、30 fps、H.264/AAC、92.266667 秒、84,696,882 字节。
- v04 交付级成对验证：`ok=true`、共同编排时长 92.24 秒、3 条配音轨一致、两支最终视频均通过流与时长检查。
- 最终关键帧保存在两个项目的 `snapshots-v04`；用户于 2026-09-14 明确审核通过，双版 MP4 与封面已归档至 `C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过\订单履约风险智能体`。

## v05 场景入场修复

- 根因：手机面板在 CSS 中默认为完成态可见，但 GSAP 在场景开始后才把它重置到 `opacity: 0`，造成“完成态闪现 → 透明重置 → 再淡入”；竖版第 7 场透明外壳把问题放大成近似空屏。
- 修复：双版手机面板增加隐藏初始态，面板和主文案均从场景切点立即入场；内部数据卡仍保持分层渐进，不恢复大块玻璃。
- HyperFrames 已升级到 0.8.38；双版最终 check 均 `ok=true`，runtime、motion、contrast 错误为 0。
- 修复回归帧：59.16、59.30、59.50、59.80、87.10 秒；横竖版接触表分别位于两个项目的 `snapshots-v05/contact-sheet.jpg`。
- 16:9 v05：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-short\renders\order-fulfillment-risk-agent-16x9-v05.mp4`；1920×1080、30 fps、H.264/AAC、92.266667 秒、69,552,813 字节。
- 9:16 v05：`C:\Users\ironman\Desktop\video-sucai\output\order-fulfillment-risk-video\hyperframes-cut-vertical-short\renders\order-fulfillment-risk-agent-9x16-v05.mp4`；1080×1920、30 fps、H.264/AAC、92.266667 秒、84,595,770 字节。
- v05 交付级成对验证：`ok=true`、共同编排时长 92.24 秒、3 条配音轨一致、两支最终视频均通过流、尺寸、时长和音频检查。
- 已从最终 9:16 MP4 抽查 59.16、59.30、59.50、59.80 秒：入场为连续渐显，无完成态闪现、透明重置或大块玻璃；证据位于 `hyperframes-cut-vertical-short/snapshots-v05-rendered`。
- 已通过目录：`C:\Users\ironman\Desktop\video-sucai\成品库\01_已通过\订单履约风险智能体`；保留 v01 历史版本，并新增 2 支 v05 MP4、2 张 v05 封面，`审核说明.md` 已标记 v05 为当前推荐版本。
- 原待审核目录现为空；v04 已从项目 `review-archive/v04` 归档为历史通过版本，v05 待审核说明保存在项目 `review-archive/v05`，所有源成片均未删除。

## 待执行

v04 与 v05 均已审核通过并归档，无待执行项；v05 仍为当前推荐版本。
