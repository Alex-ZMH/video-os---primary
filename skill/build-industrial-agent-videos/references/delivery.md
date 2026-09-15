# Local review-library staging

Use this only when the user asks to place verified candidates in the workstation review library.

- Target `C:\Users\ironman\Desktop\video-sucai\成品库\00_待审核\<case-name>` unless the user names another review folder.
- Keep only the two final MP4s, one representative cover per video, and `审核说明.md` in that case folder. Do not collect project sources, snapshots, keyframes, temporary encodes, or failed candidates.
- Use versioned names such as `<case-name>__16x9__v01.mp4`, `<case-name>__9x16__v01.mp4`, and `<case-name>__16x9__封面__v01.jpg`. Never overwrite an existing version.
- On the same NTFS volume, create hard links for the MP4s instead of copying them. Verify the source and destination resolve to the expected case paths before creating links.
- Write `审核说明.md` with status `待用户审核`, versions, dimensions, duration, size, source paths, automated checks, and the remaining human-review points.
- Do not edit a library-wide index or move candidates into an approved folder until the user explicitly approves them.
- After explicit approval, update the review note to `已通过`, move the five-file review package to `01_已通过`, then expand it into `01_终版视频`, `02_满意原图/{16x9,9x16,品牌素材}`, `03_口播语音`, `04_口播文案`, `05_字幕`, and `06_审核资料`. Archive only scene images and voice files actually referenced by the approved final HTML; keep layout-specific scripts or subtitles only when their contents differ.
- Verify every archived asset against its source with SHA-256 and re-run `ffprobe` on both archived MP4s. On the same NTFS volume, hard links are preferred for large media; approved archive links must remain usable if an old source path is removed.
- Keep only the current approved binary version. Once the categorized archive passes validation, preserve older decisions and pitfalls in the canonical task-root `handoff.md`, then remove superseded MP4s, covers, old snapshots, and `review-archive` entries using an exact, workspace-scoped cleanup list. Never delete the current project source, current final renders, or current final QC evidence.
- Keep one canonical task-root `handoff.md`. On completion, reconcile its title, project paths, current version, final MP4 paths, review status, and library directory against the approved review note; child-project handoffs may retain layout-specific evidence but cannot override the task-root status.
