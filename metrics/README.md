# metrics/

Cross-session aggregation of harness behavior.

These files accumulate over time. They are NOT auto-populated — the agent must append after each self-evaluation.

## Files

### `protocol-adherence.tsv`

Tab-separated. One row per closed non-trivial task.

Columns:
```
date    plan_id    mode    plan_used    subagent_count    validation_level    skipped_rules_count    xy_corrected
```

### `xy-incidents.md`

Markdown log of every detected XY risk. One entry per incident:

```
## <date> — <plan_id>
- stated: ...
- inferred: ...
- chosen framing: ...
- outcome: did the corrected framing succeed? yes | no
```

### `failure-modes.md`

Recurring failure patterns. Append when observed in self-evaluation `Failure Modes`.

### `improvement-backlog.md`

Improvement notes from self-evaluations that warrant harness changes. Reviewed when revising harness version.

## Rule

Metrics are append-only and pseudonymous (no secrets). Aggregations are advisory.
