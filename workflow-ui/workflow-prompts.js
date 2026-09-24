window.workflowDefaults = {
  version: "video-playlist-v04",
  project: {
    inputRoot: "C:\\Users\\z97\\Desktop\\tushengshipin\\成品视频",
    outputRoot: "C:\\Users\\z97\\Desktop\\tushengshipin\\剪辑配音后",
    logoPath: "C:\\Users\\z97\\Desktop\\jianji\\公司logo.jpg",
    renderVersion: "v04"
  },
  stages: [
    {
      id: "brief",
      name: "项目输入",
      hint: "锁定素材目录、事实边界和交付范围。",
      prompts: [{
        id: "briefPrompt",
        label: "项目提示词",
        value: "你是工业智能体视频导演。请根据输入目录中的真实素材和文案，提炼项目事实、受众、叙事主线和可验证的建设目标。只使用来源支持的内容，不把规划指标写成既有成绩；输出前标记需要人工确认的事实。"
      }],
      fields: [
        {id: "inputRoot", label: "视频输入目录", type: "text", value: "C:\\Users\\z97\\Desktop\\tushengshipin\\成品视频"},
        {id: "outputRoot", label: "导出目录", type: "text", value: "C:\\Users\\z97\\Desktop\\tushengshipin\\剪辑配音后"},
        {id: "logoPath", label: "片尾 logo", type: "text", value: "C:\\Users\\z97\\Desktop\\jianji\\公司logo.jpg"}
      ]
    },
    {
      id: "narration",
      name: "口播文案",
      hint: "先修改口播提示词，再生成或替换口播。",
      prompts: [{
        id: "narrationPrompt",
        label: "口播提示词",
        value: "请用明亮、自然、积极向上的中文女声口播，语气亲切、克制、清晰，保持自然 1×。文案围绕问题、工作流、人工确认和结果展开；不得使用“对不对”“是不是”“这是”“但是”等反问或强转折表达，不新增未经来源支持的数字。"
      }],
      fields: [
        {id: "voiceStyle", label: "音色", type: "select", value: "xiachen", options: ["xiachen", "xiaoxiao", "xiaoyi", "yunfeng", "yunhao"]},
        {id: "breathGap", label: "段间停顿（秒）", type: "number", value: "0.5"}
      ]
    },
    {
      id: "playlist",
      name: "视频轮播",
      hint: "所有视频先完成首轮，再从第一个视频循环。",
      prompts: [{
        id: "playlistPrompt",
        label: "画面播放提示词",
        value: "将同一画幅下的所有源视频按清单顺序组成播放列表。每个视频先完整播放一次；如果口播还未结束，从第一个视频重新开始并继续同样顺序。视频保持自然 1×，静音源视频，不在首轮重复分配视频，不插入静态图片作为场景画面。"
      }],
      fields: [
        {id: "landscapeSize", label: "横版尺寸", type: "text", value: "1920x1080"},
        {id: "portraitSize", label: "竖版尺寸", type: "text", value: "1080x1920"},
        {id: "playlistMode", label: "轮播策略", type: "select", value: "first-pass-then-loop", options: ["first-pass-then-loop"]}
      ]
    },
    {
      id: "overlays",
      name: "字幕与文字",
      hint: "修改画面文字、底框和遮挡控制。",
      prompts: [{
        id: "overlayPrompt",
        label: "字幕与文字提示词",
        value: "标题、编号、说明和字幕使用高透明灰色底框，底框按内容宽度自适应；编号贴近标题，避免右上角大面积遮挡；字幕字号按内容做小幅变化。文字尽量放在安全区，保留人物、设备、样品和屏幕的可见性。"
      }],
      fields: [
        {id: "captionBackground", label: "底框颜色", type: "text", value: "rgba(45,45,45,.72)"},
        {id: "captionSizeMode", label: "字号策略", type: "select", value: "content-varied", options: ["content-varied", "fixed"]}
      ]
    },
    {
      id: "render",
      name: "渲染导出",
      hint: "按源文件夹顺序串行导出并验证。",
      prompts: [{
        id: "renderPrompt",
        label: "渲染提示词",
        value: "按成品视频目录中的主题文件夹顺序依次渲染横版和竖版。全局单槽，使用高质量、单 worker、低内存模式；每支成片完成后立即检查 H.264、AAC、30 fps、尺寸和时长。使用版本化 v04 文件名，不覆盖旧版本。"
      }],
      fields: [
        {id: "renderVersion", label: "渲染版本", type: "text", value: "v04"},
        {id: "workers", label: "渲染 workers", type: "number", value: "1"},
        {id: "quality", label: "质量", type: "select", value: "high", options: ["high"]}
      ]
    }
  ]
};
