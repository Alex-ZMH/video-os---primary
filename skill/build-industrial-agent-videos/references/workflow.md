# Reusable production workflow

## Input contract

Before production, identify the case brief, target audience, brand assets, landscape project directory, portrait project directory, and whether Xiachen remains the approved voice. Preserve user-provided claims; do not invent performance numbers or customer-success evidence.

## 1. Lock the narration

Write a concise, natural capability introduction rather than slogan-heavy advertising copy. Select the closest spine in [case-archetypes.md](case-archetypes.md); do not reuse simulation-specific verbs for a quotation or workflow case.

Keep one main idea per paragraph. When narration wording is under review, show the text before regenerating all voice assets.

## 2. Generate Xiachen voice safely

Use the authorized Xiachen reference and `jarvis-b` CosyVoice3. The established reference file is `C:\Users\ironman\Downloads\晓辰.mp3`; verify it still exists rather than silently substituting another voice.

Default instruction:

```text
You are a helpful assistant. 请用明亮、自然、积极向上的中文女声口播，亲切有精神，克制而不激昂。<|endofprompt|>
```

Generate one candidate block first, with a version suffix such as `-sunny-v2`. Check it for:

- prompt leakage or extra spoken instructions;
- correct text and pronunciation;
- natural 1× pacing;
- bright, friendly energy without advertising-style shouting or a tired delivery.

Only after that candidate passes should the remaining blocks be generated with the same settings. Grouping three related paragraphs per WAV is the proven compromise between continuity and replaceability. Preserve about 0.5 seconds between blocks. Record exact `ffprobe` durations in `audio_meta.json`; never assume a regenerated take matches the previous duration.

## 3. Build scene assets

Use detailed, photorealistic industrial scenes with credible labs, CAE workstations, devices, fixtures, and engineering reviews. Avoid empty UI wireframes or generic glowing diagrams as the whole scene.

Create the landscape and portrait visual sets separately:

- landscape: compose directly for 16:9;
- portrait: generate or outpaint for 9:16 and reposition people, phones, instruments, and screens deliberately;
- do not crop the landscape image into the portrait canvas;
- use stable versioned filenames for regenerated assets.

When portrait copy obscures people, samples, instruments, or screens, keep the portrait-native photo full bleed and move copy into translucent glass overlays at the top and bottom. Reserve the middle as a text-free clear zone for faces, samples, instruments, and screens. Prefer clear glass when scene detail should stay sharp: use no background blur, a low-opacity tint, slight brightness/contrast adjustment, and edge highlights. Use frosted glass only when deliberate diffusion is requested or needed for legibility. Put the safety margin inside the bottom glass padding instead of adding a separate opaque blank strip. Use solid banded zoning only when the source image cannot support readable translucent overlays, and record the chosen safe-zone geometry in `BRIEF.md` and `frame.md`.

## 4. Assemble and retime both projects

Keep narration text, voice files, claim order, and scene meaning identical across both projects. Layout, crop, and camera movement may differ by aspect ratio.

Whenever voice duration changes, update every dependent artifact in both projects:

- root `data-duration`;
- scene `data-start` and `data-duration`;
- audio source, start, and duration;
- subtitle timings;
- brand-card start and total duration;
- progress animation and timed transitions;
- `index.motion.json`, `STORYBOARD.md`, `SUBTITLES.md`, `BRIEF.md`, and `audio_meta.json`.

Do not leave a silent hole between scene clips: let the preceding scene cover the short inter-block breathing gap. The established brand lockup is 1.2 seconds after narration ends.

## 5. Validate and obtain approval

Run `npx hyperframes@latest upgrade --project . --check` once per resumed project before the first render-affecting command. If a pin is upgraded, run `npm run check -- --json` and report the version change.

Both projects must pass HyperFrames runtime, layout, motion, and contrast checks. Then start or refresh the Studio previews and provide both URLs. Do not render until the user explicitly approves.

## 6. Render and verify

On the current workstation, render sequentially:

```powershell
npm run render -- --quality high --workers 1 --low-memory-mode --output renders/<versioned-name>.mp4
```

Do not launch two ordinary disk-capture renders in parallel. After each render, verify file existence, non-zero size, duration, resolution, frame rate, H.264 video, and AAC audio with `ffprobe`. Store final paths and known warnings in the project handoff.

The render slot is global across cases, not merely per project. Confirm no other HyperFrames render is active before starting one video; release the slot only after that MP4 has exited and passed its immediate checks.

Do not accept project snapshots as final visual evidence. Extract from the encoded MP4 every scene at `start`, `start + 0.15 s`, and `start + 0.40 s`, plus business-critical moments. Reject missing business rows, completed-state flashes, visible-to-hidden resets, frozen required background motion, or near-empty frames before rendering the paired layout.
