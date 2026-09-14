# Failure ledger and hard gates

## Independent reruns need evidence

- For a workflow rerun or stability test, initialize a new versioned empty run directory. Preserve source facts, but do not copy old HTML, scene images, or voice assets.
- Record the source lock, asset provenance, per-layout hashes, and cross-layout voice equality. Never claim an independent rerun without filesystem and hash evidence.

## Protect the portrait subject

- When top and bottom space exists, never put key copy over faces, samples, instruments, or screens.
- Keep the portrait-native image full bleed; place the title at the top, explanation or data at the bottom, and leave the center text-free.
- Put bottom safety padding inside the glass. Do not add an opaque blank strip. Use rigid bands only when the source image cannot support readable glass overlays.

## Clear glass is not frosted glass

- Clear or transparent glass keeps the underlying image sharp: no `blur()` and no `backdrop-filter: blur`; use a low-opacity tint, subtle brightness/contrast, edge highlights, and restrained internal reflections.
- Use frosted glass only when the user asks for deliberate diffusion or when legibility genuinely requires it.
- Audit the authored layout for zero text in the central subject region and zero blur rules on clear-glass containers; then inspect opening, midpoint, and result frames extracted from the rendered MP4.

## Keep approvals separate

- Preview approval authorizes rendering.
- A request to render authorizes encoding only; it does not approve, publish, submit, or archive the result.
- Only explicit wording such as “审核通过” or “批准归档” authorizes placement in `01_已通过`.
- Track `preview approved`, `render generated`, and `review approved` as separate states. Do not rerender when the user asks only for status or archival.

## Avoid render and version traps

- Probe HyperFrames immediately before the first render-affecting command, apply the available upgrade once, rerun checks, and record the actual from/to versions returned by the upgrade rather than an earlier probe result.
- Render the two layouts sequentially with `--quality high --workers 1 --low-memory-mode`; do not run paired renders in parallel on this workstation.
- Use versioned output names and never overwrite an approved render.

## Serialize shared resources

- Submit Jarvis-B TTS only through the shared Provider/flock queue. A waiting job is already queued; do not retry it or bypass the Provider with a parallel SSH command.
- Treat local HyperFrames rendering as one global single-video slot across all cases. Check active render processes and free disk before granting a slot, run only one orientation, validate it, release the slot, then schedule the next orientation or case.

## Make render-critical UI seek-safe

- If Studio looks correct but the encoded MP4 loses rows or cards, do not accept `ffprobe` as proof of quality. Critical UI must have a deterministic default state and must not rely only on asynchronous initialization, query parameters, or delayed cascade tweens.
- Refresh composition caches with an explicit build marker when render capture can reuse stale DOM state. Extract the business-critical timestamp and every scene `start/+0.15/+0.40` from the final MP4 before accepting the render.

## Keep one canonical handoff per task

- Never copy a later task's title, paths, status, or metrics into an earlier task-root handoff. At closeout, reconcile task name, project directories, final MP4s, approved review note, and library directory.
- When records disagree, use this precedence: verified final files and hashes, approved review note, task-root handoff, then child handoffs and historical logs.

## Verify the delivered files

- Use `ffprobe` on each MP4 to verify dimensions, frame rate, duration, H.264 video, and AAC audio. Inspect frames extracted from the MP4 itself, not only composition snapshots.
- Run the pair gate once after a revision and three times for a workflow baseline or stability claim. Include both MP4 paths for the delivery gate.
- Update artifact hashes and require zero mismatches.
- Stage only explicit final files. On the same NTFS volume, use hard links for approved MP4s, verify `LinkType=HardLink` plus matching source/destination hashes, and preserve the source project and renders.
