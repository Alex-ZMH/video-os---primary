# Industrial case narrative archetypes

Choose the smallest spine that preserves the source brief. A case may omit a beat when the source has no support for it. Never fill an empty beat with invented evidence.

## Simulation or engineering automation

1. Outcome or risk hook.
2. Inputs the agent reads or compares.
3. Verified settings or engineering knowledge it reuses.
4. Relationships, conditions, or process state it migrates.
5. Work that still must be rebuilt or recalculated.
6. Engineer confirmation gate.
7. Results the agent extracts.
8. Variants or cases it processes in batches.
9. Higher-value engineering work unlocked.

## Critical equipment fault diagnosis

1. Risk hook: vibration, temperature, pressure, or energy use turns abnormal on a pump, compressor, reactor, or other critical asset.
2. Fragmented evidence: DCS live points and trends, equipment ledger, maintenance history, work-order notes, and operating manuals.
3. Reconstruct the operating timeline before and after the alarm; a single alarm is never presented as a root-cause explanation.
4. Correlate equipment structure, process parameters, historical failures, and repair experience, while keeping every conclusion traceable to evidence.
5. Rank candidate causes and attach the check location, validation method, and recommended investigation order to each one.
6. Support night-shift preliminary triage when experts are absent; do not imply that the agent replaces expert review.
7. After human confirmation, generate or update the maintenance work order and track inspection, treatment, and verification results when the source brief authorizes it.
8. Keep shutdown, equipment switchover, and control-parameter changes behind explicit authorized-person confirmation.
9. Close with only source-supported accuracy, efficiency, runtime, and diagnosis-time evidence; distinguish project results from targets.

Show the evidence chain and human authorization gate as product behavior, not as disclaimer text. Do not visualize an alarm as if it were already a confirmed root cause, and do not imply autonomous control action.

## Materials formulation optimization

1. Trial cost or development-cycle hook.
2. Candidate ingredients, historical formulations, material properties, process conditions, and measured outcomes.
3. The coupled performance and cost objectives that make manual trial-and-error unreliable.
4. Prediction and multi-objective optimization that rank high-value candidates.
5. Explanations of which ingredients drive each target property.
6. A human experiment gate: the agent proposes, engineers validate.
7. Results fed back to update the model and narrow the search space.
8. Only source-supported outcome or target numbers, clearly labeled as achieved results versus project targets.
9. Fewer low-value experiments and a shorter path to scale-up.

## Manufacturing quotation

1. Profit-risk hook: one missed operation or outsourced fee can erase margin.
2. Intake: PDF, CAD, and scanned drawings.
3. Structured extraction: material, dimensions, tolerances, quantity, heat treatment, surface treatment, and inspection requirements.
4. Enterprise grounding: material library, process library, equipment capability, supplier prices, and historical quotations.
5. Similar-part retrieval and reuse of validated pricing bases.
6. Preliminary BOM, process route, cost detail, and quotation draft.
7. Cost-completeness check across material, machining, outsourced processing, and inspection.
8. One engineer review queue for unclear or low-confidence fields; corrections feed the enterprise quotation knowledge loop.
9. Only source-supported outcomes, followed by the higher-value work unlocked for technical staff.

For quotation cases, keep cost rows explicit and visually connected to the source drawing. Do not show an autonomous final commercial price when the brief still requires engineering confirmation.

## Production daily report and multi-system collaboration

1. Visibility hook: the daily report arrives after the production problem has already been running for hours.
2. Fragmented inputs: MES, ERP, DCS, equipment systems, spreadsheets, and manual shift records.
3. Reconciliation problem: metric definitions differ, so staff copy, compare, and recheck before the report is usable.
4. Unified extraction: read production, work orders, energy, quality, process, and downtime under one explicit metric definition while retaining source and time.
5. Direct inquiry: answer source-grounded questions such as which line missed target or which work order is abnormal.
6. Scheduled report: generate the daily report at the agreed time from the same governed data view.
7. Exception workflow: convert missed-target, downtime, and quality exceptions into tasks with owner, action, review result, and closure state.
8. Evidence: show only source-backed improvements for report generation, information retrieval, and cross-system queries; preserve qualifiers such as “about” and “from real industrial projects.”
9. Operational value: managers see deviation earlier, teams close the loop faster, and shift staff spend more time on root-cause judgment and production improvement.

Keep the source systems as systems of record unless the brief explicitly authorizes write-back. Do not imply that the agent changes MES, ERP, DCS, process setpoints, quality dispositions, or work orders merely because it can read, correlate, report, and create follow-up tasks.

## Knowledge inheritance and troubleshooting

1. Knowledge-continuity hook: critical process judgment is concentrated in a few senior employees.
2. Fragmentation: manuals, process files, work orders, training material, field notes, and interviews.
3. Extract the source-supported judgment logic; do not present generic document search as the whole capability.
4. Organize equipment, products, symptoms, checks, actions, cases, and sources into a role knowledge map.
5. Let the worker identify the equipment, product, and abnormal symptom at the point of work.
6. Return an ordered check path, response guidance, similar cases, and traceable sources.
7. Route low-confidence or unsupported questions to an expert instead of guessing.
8. Feed expert corrections back into the knowledge base and training system.
9. End with only source-supported parsing and retrieval metrics, then the operational shift from finding a veteran to searchable, traceable, maintainable knowledge.

For knowledge-inheritance cases, show the human learning loop as part of the product. A document ingestion montage without the expert correction path is incomplete.

## Order operations and profit (automotive repair parts)

1. Risk hook: ERP documents are split by department, so the owner cannot quickly see where an order is, whether stock is reliable, or what a payable belongs to.
2. Read-only ERP sync and data mapping; preserve the existing ERP as the system of record.
3. Make the customer order the primary thread and map its sales, procurement, inbound/receiving, processing/assembly, inventory, shipping, payables (应付款), and collections (回款) records.
4. Show one order view with status and upstream/downstream relationships, including inventory movements attributed to the customer order.
5. Trace a payable amount back to its purchase record and the related sales/order business; do not present an amount without its business link.
6. Reconcile price, inventory, payment, and delivery checkpoints and surface mismatches or exceptions.
7. Send proactive anomaly message cards (异常消息卡片) to the responsible person; the agent alerts and explains evidence but does not silently edit ERP records or approve transactions.
8. Keep a management review/confirmation gate for ambiguous price, stock, payment, and delivery decisions.
9. Claim only implemented outcomes supported by the brief: an order full-chain operating dashboard, payable traceability, and basic proactive anomaly reminders. Do not invent or imply achieved quantitative profit improvement/profit growth, cost reduction, or fewer repeat orders; label any such figures as targets only when explicitly supplied as targets.
