# Phone-first ERP material/procurement cases

Read this for a mobile enterprise-ERP simulation covering material master data, semantic search, inventory, substitutes, price history, suppliers, or purchase review.

## Canonical interaction

Keep the same human-readable state progression in both layouts:

1. A buyer enters a natural-language request with aliases, brand/model spelling, or a non-unified unit.
2. The agent returns normalized material candidates and why they match (name, specification, brand, alias, unit, and confidence).
3. Each candidate exposes current/available stock, compatible equipment, substitute models, dated historical prices, and supplier records.
4. The agent flags duplicate coding, abnormal price, over-purchase, or shortage risk for review.
5. The buyer checks the evidence, chooses or requests the material, and confirms the purchase decision. The agent must not silently create a code or authorize an order.

Use real ERP-like rows/cards and industrial context cues; do not make the entire case an empty generic AI wireframe. Keep the data relationships visible so a viewer can follow request → match → stock/substitute → price/supplier → alert → human confirmation.

## Native phone composition

- Landscape (16:9): use a legible primary phone/workspace with room for one detail panel or industrial context; avoid shrinking several phone screens into unreadable columns.
- Portrait (9:16): compose a large primary phone in the safe central column and stack detail cards/alerts below or beside it; do not squeeze the landscape side panel into the crop.
- Generate or outpaint portrait assets independently and version them (for example, `*-vertical-v2`); never present a cropped landscape frame as the portrait deliverable.
- Keep scene order, UI states, labels, narration, subtitles, voice files, and total duration equivalent. Reposition, resize, and regroup for the aspect ratio, but do not change the evidence or workflow.

## Evidence hard gate

Separate implementation evidence from planned targets in every script, subtitle, and on-screen KPI:

- **Established mechanism:** it is supportable to say the real material-governance project has established a historical baseline, semantic retrieval, and procurement review mechanism, reducing “not found,” duplicate coding, wrong purchases, and repeat purchases. Do not turn this into an unsupported percentage.
- **Construction/acceptance target:** `库存周转率提升20%` and `物料短缺造成的生产延误减少50%` are future construction indicators. Label them `建设指标`, `目标值`, or `验收目标`; never narrate or display them as achieved project results.

If a number has no source-backed result class, omit it or label it as a target. Human confirmation remains the final decision gate even when the agent recommendation is high-confidence.

For the paired deliverables, keep one shared audio/content source of truth and run the existing pair verifier after timeline changes; do not render until the approved preview passes review.
