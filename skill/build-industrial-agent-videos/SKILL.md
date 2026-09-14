---
name: build-industrial-agent-videos
description: Build, revise, validate, render, or stability-test paired landscape and portrait Chinese industrial AI-agent case videos with HyperFrames, Xiachen Jarvis voice, portrait-native scenes, synchronized timing, and repeatability gates. Use for simulation, engineering-workflow, critical-equipment fault diagnosis, production-operations/daily-report, knowledge-inheritance, material/procurement, ERP order-operations/profit, and quotation-agent cases; not for unrelated general videos.
---

# Industrial agent video workflow

Produce one content-locked industrial case video in two native layouts: 1920×1080 and 1080×1920. Keep narration, claims, voice assets, and timing equivalent; adapt scene composition independently for each aspect ratio.

Use the existing HyperFrames, media-use, imagegen, and relevant HyperFrames domain skills for their owned operations. This skill adds the workflow-specific decisions and gates learned from the established phone-simulation project.

## Required behavior

- Default to the authorized Xiachen reference voice on `jarvis-b` unless the user overrides it.
- Use natural 1× speech. Never shorten delivery with audio tempo, playback-rate, or removed breathing pauses.
- Target a bright, natural, positive tone with restrained energy: friendly and alert, neither shouty nor dull.
- Generate or outpaint portrait-native scenes. Never pass a cropped landscape frame off as the portrait deliverable.
- Use versioned voice and render filenames. Do not overwrite an approved candidate before the replacement passes review.
- Render only after the user approves the final preview.
- On this workstation, prefer sequential `--low-memory-mode --workers 1` renders because normal frame capture may require more than 20 GB of temporary disk.
- Treat local HyperFrames rendering as one global single-video slot across tasks. Jarvis-B voice jobs must use the shared Provider queue; waiting is not permission to submit duplicates or bypass its lock.

## Routing

- Before any matching task, read [references/pitfalls.md](references/pitfalls.md) and enforce its provenance, portrait-layout, approval, render, and delivery gates.
- Before planning a new case, read [references/case-archetypes.md](references/case-archetypes.md) and select the closest narrative spine. If none fits, keep the generic problem → workflow → human checkpoint → outcome structure and do not force case-specific verbs.
- For an ERP order-operations/profit case, keep the system read-only, make the customer order the primary thread, and use only source-backed outcome language from the selected archetype.
- For an order-fulfillment risk phone simulation, also read [references/order-risk-phone-simulation.md](references/order-risk-phone-simulation.md).
- For a phone-first enterprise ERP or material/procurement case, also read [references/mobile-erp-materials.md](references/mobile-erp-materials.md) before writing scenes or claims.
- For creation or revision, read [references/workflow.md](references/workflow.md) before acting.
- For chemical-production HSE inspection and compliance agents, also read [references/hse-inspection.md](references/hse-inspection.md).
- For validation, repeatability testing, or delivery verification, read [references/stability.md](references/stability.md) and use `scripts/verify_pair.ps1`.
- When final files must be staged in the local review library, read [references/delivery.md](references/delivery.md) after render verification.
- For a task combining revision and stability testing, read both references.

The current proven reference implementation and final artifact locations are recorded in `C:\Users\ironman\Desktop\video-sucai\handoff.md`.
