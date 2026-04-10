# AI Governance & Safety Protocol
## Rihla Internal Specification v2.1

### 1. Intent
To define the guardrails for AI-generated trajectories ensuring zero-risk guidance for international and local explorers.

### 2. Mandatory Data Points
Every AI response MUST include the following telemetry fields:
- `safety_score`: Continuous float [0.0 - 5.0]
- `emergency_contacts`: Localized mapping for the specific Wilaya.
- `verified_flag`: Boolean indicating whether the coordinates have been manually audited by regional partners.

### 3. Edge Case: Connectivity Loss
In 4G/5G dead-zones, the `AiService` will immediately switch to the **Local Heritage Database (LHD)**.
- **LHD Storage**: Optimized JSON binary in assets.
- **LHD Coverage**: 58 Wilayas with 10+ core nodes each.

### 4. Ethical Considerations
Algorithms must prioritize sustainable tourism and historical preservation sites over high-traffic commercial zones and are prohibited from suggesting non-verified hiking trails in high-risk terrains.
