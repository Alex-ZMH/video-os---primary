# Stability and repeatability checks

## Verification levels

Use the cheapest level that answers the request:

1. **Revision gate:** one `verify_pair.ps1` run after every timing, voice, or scene change.
2. **Repeatability gate:** three runs when the user asks to test stability or before treating a workflow revision as the new baseline.
3. **Delivery gate:** provide both final MP4 paths so the script also checks container streams, dimensions, duration, and audio.
4. **Encode repeatability:** render multiple MP4s only when explicitly requested. Do not compare binary hashes because container metadata can differ; compare duration, stream layout, resolution, frame rate, and visual samples instead.

## Commands

Run from any PowerShell directory:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\verify_pair.ps1" `
  -LandscapeDir "<landscape-project>" `
  -PortraitDir "<portrait-project>" `
  -Runs 1
```

For a three-pass stability campaign with delivered videos:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\verify_pair.ps1" `
  -LandscapeDir "<landscape-project>" `
  -PortraitDir "<portrait-project>" `
  -Runs 3 `
  -LandscapeVideo "<landscape.mp4>" `
  -PortraitVideo "<portrait.mp4>"
```

The script gates on:

- landscape 1920×1080 and portrait 1080×1920;
- equal composition duration;
- no authored media playback-rate override;
- equal voice-track count, filenames, and SHA-256 content across both projects;
- equal, non-empty scene-image references resolved from the root and its sub-compositions;
- landscape and portrait scene images using native aspect dimensions with no cross-layout file reuse;
- every HyperFrames check run returning `ok: true`;
- optional MP4s containing the expected H.264 video and AAC audio streams with matching duration.

## Interpretation

- A one-off HyperFrames failure followed by passes is still instability; retain the failing output and investigate before calling the workflow stable.
- `timeline_track_too_dense` can be a non-gating warning for a deliberately dense flat composition. Do not refactor solely to remove it.
- A landscape `duplicate_media_discovery_risk` can be intentional when one source is used for both blurred background and foreground. Treat it as non-gating only after confirming the rendered frame is correct.
- Prompt leakage, wrong voice, dull or shouty emotion, and portrait crops are human-review failures even when automated checks pass.
- A valid container and clean Studio snapshot do not prove visual correctness. Critical UI can disappear only in the encoded MP4 when it depends on asynchronous initialization, query-string cache behavior, or delayed row cascades; use seek-safe defaults and inspect the final file.
- If normal rendering reports roughly 20+ GB of temporary space while the system disk is low, switch to the proven low-memory command; do not delete broad directories to make room.

## Scene-entry first-frame gate

- Any element animated from a hidden state after a clip starts must already have the matching hidden base state in CSS or an initialization set. Never combine a visible base style with a delayed `fromTo(... opacity: 0 ...)` and `immediateRender: false`; that renders the finished state for a frame, resets it to transparent, then fades it in.
- Review every scene boundary at `start`, `start + 0.15 s`, and `start + 0.40 s`. Reject completed-state flashes, visible-to-hidden resets, or near-empty portrait frames before approving a render.
- Treat portrait scenes with transparent outer shells as the strictest regression case: at least one intentional visual anchor must remain visible during the entrance without restoring a large opaque or frosted panel.
