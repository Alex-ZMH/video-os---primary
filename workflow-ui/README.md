# 提示词编辑窗口

这是工业视频工作流的本地提示词窗口。它把需要人工输入或修改的环节分成五步：项目输入、口播文案、视频轮播、字幕与文字、渲染导出。

## 启动

在 PowerShell 中运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\start-workflow.ps1
```

然后打开 `http://127.0.0.1:3117`。也可以指定端口：

```powershell
powershell -ExecutionPolicy Bypass -File .\start-workflow.ps1 -Port 3118
```

## 使用

- 左侧选择阶段，修改提示词或参数。
- “保存当前修改”会写入浏览器本地存储，并在服务器可写时保存为 `workflow-prompts.local.json`。
- “导出配置 JSON”可把当前提示词交给后续生成脚本或另一台电脑。
- “导入配置 JSON”可恢复一份已有配置。
- “恢复默认值”只恢复当前版本 `video-playlist-v04` 的规则，不会写入此前的中间调整。

`workflow-prompts.local.json` 是本机工作文件，不应提交到 GitHub；默认模板在 `workflow-prompts.json`。
