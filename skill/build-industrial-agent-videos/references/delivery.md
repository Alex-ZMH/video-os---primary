# Local review-library staging

Use this only when the user asks to place verified candidates in the workstation review library.

- Target `C:\Users\ironman\Desktop\video-sucai\成品库\00_待审核\<case-name>` unless the user names another review folder.
- Keep only the two final MP4s, one representative cover per video, and `审核说明.md` in that case folder. Do not collect project sources, snapshots, keyframes, temporary encodes, or failed candidates.
- Use versioned names such as `<case-name>__16x9__v01.mp4`, `<case-name>__9x16__v01.mp4`, and `<case-name>__16x9__封面__v01.jpg`. Never overwrite an existing version.
- On the same NTFS volume, create hard links for the MP4s instead of copying them. Verify the source and destination resolve to the expected case paths before creating links.
- Write `审核说明.md` with status `待用户审核`, versions, dimensions, duration, size, source paths, automated checks, and the remaining human-review points.
- Do not edit a library-wide index or move candidates into an approved folder until the user explicitly approves them.
- After explicit approval, update the review note to `已通过` with the confirmation date and decision, move the whole five-file case directory to `01_已通过`, then update the library index. Preserve hard links and never reconstruct or re-encode approved media during this move.
- Keep one canonical task-root `handoff.md`. On completion, reconcile its title, project paths, current version, final MP4 paths, review status, and library directory against the approved review note; child-project handoffs may retain layout-specific evidence but cannot override the task-root status.
