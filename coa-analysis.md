# COA Analysis: BTCU & Exponent Learn — Learning Platform Strategy
**Prepared by**: CTO Office
**Date**: 2026-02-20
**Subject**: Three Divergent Courses of Action for Learning Platform Deployment
**Codebase**: Open Notebook v1.7.4

---

## Logical Framework Reference

Before presenting the COAs, the following formalisms are used throughout this document:

| Symbol | Meaning |
|--------|---------|
| `∀x` | For all x (universal quantification) |
| `∃x` | There exists an x (existential quantification) |
| `∧` | Logical AND (conjunction) |
| `∨` | Logical OR (disjunction) |
| `¬` | Logical NOT (negation) |
| `→` | Implies |
| `↔` | If and only if |
| `□P` | Necessarily P (modal — true in all possible worlds) |
| `◇P` | Possibly P (modal — true in some possible world) |
| `K(x)` | Kolmogorov complexity of x (minimum description length) |
| **FOL** | First-Order Logic — quantifies over individuals |
| **SOL** | Second-Order Logic — quantifies over predicates and sets |
| **TOL** | Third-Order Logic — quantifies over sets of predicates |

---

## System State Audit (Pre-COA)

Open Notebook v1.7.4 currently provides:

**Boolean Feature Matrix (present = TRUE / absent = FALSE)**:
```
Multi-user isolation:      FALSE
Role-based access:         FALSE
Learning progress:         FALSE
Assessment / quizzing:     FALSE
Cohort management:         FALSE
LMS integration (LTI):    FALSE
Semantic search:           TRUE
AI chat per notebook:      TRUE
Podcast generation:        TRUE
Content ingestion:         TRUE
Async job queue:           TRUE
Multi-provider AI:         TRUE
Encrypted credentials:     TRUE
Vector embeddings:         TRUE
```

**Third-Order Predicate (TOL baseline)**:
Let `Π` be the set of all feature predicates over the system. Let `Σ(Π)` denote the set of all subsets of `Π` that constitute a viable learning platform. Then:

> `□(CurrentSystem ∉ Σ(Π))` — Necessarily, the current system does not satisfy any subset of predicates sufficient for a production learning platform.

This axiom motivates all three COAs below.

---

## Kolmogorov Complexity Framework

For each COA, `K(COAₙ)` approximates the **minimum description length** — the total irreducible information required to specify the system. Lower K means the system is more compressible (simpler, more derivable from the base). Higher K means the system requires novel, irreducible specification.

> **Principle**: Among strategies with equivalent expected outcomes, prefer the one with lower K(x). Complexity compounds — every irreducible decision point multiplies operational risk.

**Baseline**: `K(OpenNotebook) = B` (the compressed description of the existing codebase).

---

---

# COA Alpha — "Launch Now"
## Minimum Viable Deployment with Zero Custom Code

> **Strategic Posture**: Deploy what exists. Configure, not code. Teach to the tool's shape.

**Kolmogorov Complexity**: `K(Alpha) ≈ B + ε`
The system description is nearly isomorphic to the existing README. The delta `ε` encodes only environment variable choices — not novel architectural decisions. This is the **minimum complexity path**.

---

### Logical Characterization

**Propositional (Decision Logic)**:
```
Let D = "Deploy Open Notebook as-is"
Let C = "Configure LLM credentials via Settings UI"
Let O = "Onboard users with shared password"
Let V = "Value is delivered"

(D ∧ C ∧ O) → V
```
Three binary propositions are sufficient to produce value. No branching on novel system design.

**Predicate Logic (FOL)**:
```
∀u ∈ Users: CanAccess(u, instance) ↔ KnowsPassword(u)
∀n ∈ Notebooks: ∃instructor: Created(instructor, n) ∧ IsCourseMaterial(n)
∃model ∈ LLMProviders: Configured(model) → SystemOperational
```
Users are undifferentiated — the instance is a shared workspace. Notebooks serve as course containers.

**Second-Order Logic (SOL)**:
```
∃P [P = λx. IsNotebook(x) ∧ ContainsSources(x) ∧ HasChat(x)]
∀x: P(x) → SufficientForLearning(x)
```
The predicate `P` (notebook-as-course) can be defined over existing primitives. No new object classes are required. SOL confirms the learning primitive already exists in the type system.

**Third-Order Logic (TOL)**:
```
Let Φ = { P : P is a predicate definable over OpenNotebook primitives }
Let Ψ = { Q : Q is a predicate required for minimal learning delivery }
□(Ψ ⊆ Φ)  — Necessarily, minimum learning predicates are a subset of existing predicates
```
The existing system's predicate space **already contains** the predicates needed for minimal viable learning. No new ontology is required.

**Modal Logic**:
```
□(DeployInDays → ValueDeliveredThisWeek)
◇(UserFeedback → RequirementsClarification → BetterCOA)
¬□(Alpha → LongTermScalability)
```
Delivery is **necessarily** fast. Scalability is **not necessarily** achievable from this path. Feedback is **possibly** gathered to inform future COAs.

---

### Implementation Plan

**Day 1: Infrastructure**
1. Clone repo, run `docker compose --profile multi up` with `.env` configured:
   ```
   OPEN_NOTEBOOK_ENCRYPTION_KEY=<generate via: python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())">
   OPEN_NOTEBOOK_PASSWORD=<shared classroom password>
   SURREAL_NAMESPACE=btcu_learn
   SURREAL_DATABASE=btcu_learn
   ```
2. Open `http://localhost:3000/settings/api-keys` → configure OpenAI or Anthropic key
3. Validate with `/api/health` and `/docs` Swagger UI

**Day 2: Content Loading**
1. Create one Notebook per course (e.g., "CS101 — Algorithms")
2. Upload PDFs, papers, URLs as Sources via UI
3. AI-generated insights appear automatically via async embedding pipeline
4. Podcast generation available per notebook for audio learners

**Day 3: Student Onboarding**
1. Distribute the URL + shared password to students
2. Students use AI Chat (per notebook) as their study assistant
3. Students use Semantic Search across all content
4. Students generate their own Notes from AI conversations

**Teaching Model**:
- Instructor = Notebook creator / source curator
- Student = Notebook reader / AI conversation partner
- Assessment = External (exams administered separately)

---

### Risk Analysis

| Risk | Severity | Probability | Mitigation |
|------|----------|-------------|------------|
| No user isolation — students see each other's notes | High | Certain | Acceptable for cohort model; or use separate instances per cohort |
| No progress tracking | Medium | Certain | Accept; add external LMS for gradebook |
| Single password leaks | Medium | Low | Rotate password per cohort; use VPN |
| AI cost spikes from student usage | Medium | Medium | Set usage monitoring via provider dashboard |

---

### Kolmogorov Complexity Assessment

```
K(Alpha) = K(docker-compose.yml)
         + K(.env configuration)
         + K(notebook structure conventions)
         ≈ B + ~200 bits of novel information
```

**Conclusion**: Alpha is the **irreducibly simplest** description. Any alternative path necessarily has `K > K(Alpha)`.

---

---

# COA Beta — "Learning Overlay"
## Structured Learning Layer on Open Notebook Core

> **Strategic Posture**: Extend, don't replace. Add learning semantics through thin wrappers, naming conventions, and one new backend service.

**Kolmogorov Complexity**: `K(Beta) = B + K(LearningLayer)` where `K(LearningLayer)` is bounded and additive — not multiplicative.

---

### Logical Characterization

**Propositional (System Composition)**:
```
Let ON = "Open Notebook core deployed"
Let AL = "Assessment layer added (quiz generation)"
Let PT = "Progress tracking service added"
Let UI = "Learning-specific UI skin deployed"
Let AM = "Admin/instructor mode implemented"

Beta ↔ (ON ∧ AL ∧ PT ∧ UI ∧ AM)
Beta → ¬(Full_LMS) ∧ ¬(Multi_Tenant)
```
Beta is a conjunction of the base with bounded additions. It is **not** a full LMS and **not** multi-tenant.

**Predicate Logic (FOL)**:
```
∀u ∈ Users: Role(u, instructor) ∨ Role(u, student)
∀n ∈ Notebooks: ∃c ∈ Courses: Maps(n, c)
∀s ∈ Sources: ∃q ∈ Quizzes: GeneratedFrom(q, s) ∧ AttachedTo(q, n)
∃p ∈ ProgressRecords: ∀u: Tracks(p, u, n, CompletionStatus)
```
Two roles are introduced (instructor, student). Notebooks map to courses. Sources generate quizzes. Progress records track per-user completion.

**Second-Order Logic (SOL)**:
```
∃R [R = λ(u,x). Role(u) = instructor → CanCreate(u,x) ∧ CanConfigure(u,x)]
∃S [S = λ(u,x). Role(u) = student → CanRead(u,x) ∧ CanChat(u,x) ∧ ¬CanDelete(u,x)]
∀x: R(instructor, x) ∨ S(student, x) — every resource has a role policy
```
SOL introduces **predicates over predicates** — role policies are second-order functions that map (user, resource) pairs to permission sets.

**Third-Order Logic (TOL)**:
```
Let Γ = { P : P is a role policy predicate }
Let Δ = { Q : Q is a learning outcome predicate }
∃F: Γ → Δ — there exists a mapping from role policies to learning outcomes
□(∀P ∈ Γ: ∃Q ∈ Δ: F(P) = Q) — necessarily, every role policy maps to a learning outcome
```
TOL frames the **meta-question**: does the structure of permissions necessarily produce learning outcomes? The answer is conditional: only if `F` is well-specified, motivating Beta's need for careful role design.

**Modal Logic**:
```
□(Beta → UserIsolation)        — Multi-user isolation is necessarily achieved
◇(Beta → QuizGeneration)       — Quiz generation is possibly achievable via LLM transformation
¬□(Beta → Accreditation)       — Beta does not necessarily support formal accreditation
□(Beta → MoreComplexThanAlpha) — Beta is necessarily more complex than Alpha
◇(Beta → LMSIntegration)       — LTI integration with Canvas/Moodle is possible from Beta
```

---

### Implementation Plan

**Phase 1 (Week 1-2): Multi-User Auth**

Add real user authentication replacing the single-password middleware:

1. Add `User` record to SurrealDB schema (`migrations/009_users.surql`):
   ```surql
   DEFINE TABLE user SCHEMAFULL;
   DEFINE FIELD email ON user TYPE string;
   DEFINE FIELD role ON user TYPE string ASSERT $value IN ["admin","instructor","student"];
   DEFINE FIELD hashed_password ON user TYPE string;
   DEFINE FIELD created ON user TYPE datetime DEFAULT time::now();
   ```

2. Replace `api/auth.py` `PasswordAuthMiddleware` with JWT middleware:
   - `POST /api/auth/login` → returns JWT
   - `GET /api/auth/me` → returns current user + role
   - Middleware validates `Authorization: Bearer <jwt>` on every request

3. Add `owner` field to Notebook, Source, Note records:
   - Notebooks visible only to creator (instructor) + enrolled students
   - Enrollment table: `DEFINE TABLE enrollment SCHEMAFULL;`

**Phase 2 (Week 2-3): Learning Primitives**

Leverage Open Notebook's existing Transformation system (`api/routers/transformations.py`) to create:

1. **Quiz Generator Transformation**: Prompt template at `prompts/quiz_generator.jinja2`:
   ```jinja2
   Given the following content, generate {{ num_questions }} multiple-choice questions
   with 4 options each. Return JSON: [{question, options: [A,B,C,D], answer, explanation}]
   Content: {{ content }}
   ```
2. New API endpoint `POST /api/sources/{id}/generate-quiz` — runs transformation, stores quiz as a Note with `type: quiz` tag

3. **Progress Tracking**: New `progress` table in SurrealDB:
   ```surql
   DEFINE TABLE progress SCHEMAFULL;
   DEFINE FIELD user ON progress TYPE record<user>;
   DEFINE FIELD notebook ON progress TYPE record<notebook>;
   DEFINE FIELD sources_viewed ON progress TYPE array<record<source>>;
   DEFINE FIELD quiz_scores ON progress TYPE array<object>;
   DEFINE FIELD last_active ON progress TYPE datetime;
   ```

**Phase 3 (Week 3-4): Instructor Dashboard**

1. New frontend route `/dashboard/instructor`:
   - Course (Notebook) management
   - Student enrollment
   - Quiz result aggregation
   - Source progress heatmap

2. New frontend route `/dashboard/student`:
   - My courses (enrolled notebooks)
   - My progress per course
   - AI tutor chat
   - Quiz history and scores

**Phase 4 (Week 4): AI Features**

1. **Adaptive Path**: Use the Ask workflow (`open_notebook/graphs/ask.py`) to recommend which sources a student should read next based on quiz performance
2. **Podcast-as-Lecture**: Instructors generate podcast episodes per topic; students consume as async audio content (existing pipeline, zero new code)
3. **Note Synthesis**: AI-generated study summaries per notebook for exam prep

---

### Tech Debt Introduced

| Component | Debt | Priority |
|-----------|------|----------|
| JWT auth replaces password | Must audit all middleware exclusions | High |
| User model with no SSO | Will need OAuth later | Medium |
| Quiz scores in SurrealDB | No analytics export | Low |
| Enrollment model is flat | No cohort hierarchy | Medium |

---

### Kolmogorov Complexity Assessment

```
K(Beta) = K(OpenNotebook)         — base system
        + K(JWT_auth_layer)       — ~2000 lines new Python
        + K(User_schema)          — ~100 lines SurrealQL
        + K(Quiz_transformer)     — ~50 lines prompt + 150 lines Python
        + K(Progress_tracker)     — ~200 lines Python + schema
        + K(Instructor_dashboard) — ~800 lines TypeScript
        ≈ B + ~3,300 lines of novel, irreducible specification
```

**Conclusion**: Beta adds a bounded, additive complexity delta. Each component is independently describable and testable. The complexity is **linear**, not exponential — a healthy sign.

---

---

# COA Gamma — "Platform Transformation"
## Full AI-Native Learning Management System

> **Strategic Posture**: Transform Open Notebook's research primitives into a production-grade, multi-tenant, accreditation-capable learning platform. Open Notebook becomes the AI engine; a new platform layer becomes the product.

**Kolmogorov Complexity**: `K(Gamma) >> K(Beta)`. This COA introduces irreducibly novel information at every layer. The description of the final system is **not compressible** to a simple extension of Open Notebook.

---

### Logical Characterization

**Propositional (Full System Specification)**:
```
Let T  = "Multi-tenant architecture deployed"
Let M  = "Multi-user model with SSO (OAuth/SAML)"
Let R  = "Full RBAC: admin, instructor, TA, student, auditor"
Let A  = "Assessment engine (quiz, assignment, rubric)"
Let Cm = "Competency mapping and learning objectives"
Let Ap = "Adaptive learning path engine"
Let An = "Analytics and reporting dashboard"
Let Lt = "LTI 1.3 integration (Canvas, Moodle, Blackboard)"
Let Cr = "Credential and certificate issuance"

Gamma ↔ (T ∧ M ∧ R ∧ A ∧ Cm ∧ Ap ∧ An ∧ Lt ∧ Cr)
```
All nine propositions must be simultaneously true. Failure of any one produces an incomplete platform.

**Predicate Logic (FOL)**:
```
∀org ∈ Organizations: ∃tenant ∈ Tenants: Belongs(org, tenant) ∧ Isolated(tenant)
∀u ∈ Users: ∃r ∈ {admin,instructor,TA,student,auditor}: HasRole(u, r, tenant)
∀c ∈ Courses: ∃obj ∈ LearningObjectives: Maps(c, obj) ∧ Measurable(obj)
∀s ∈ Students: ∃path ∈ LearningPath: AdaptedFor(path, s) ∧ OptimizedFor(path, Outcomes(s))
∀a ∈ Assessments: ∃rubric: ScoredBy(a, rubric) ∧ MappedTo(a, Competency)
∀cert ∈ Certificates: ∃blockchain_anchor ∨ ∃registrar_record: Verifiable(cert)
```
The predicate universe expands dramatically. New entities — Organizations, Tenants, LearningObjectives, LearningPaths, Competencies, Certificates — require full ontological specification.

**Second-Order Logic (SOL)**:
```
∃RBAC [RBAC = λ(u, r, resource, action).
  HasRole(u, r) ∧ PolicyPermits(r, resource, action) → Authorized(u, resource, action)]

∃AdaptiveFn [AdaptiveFn = λ(student, history, objectives).
  ∀obj ∈ objectives: ¬Mastered(student, obj) → Recommend(NextSource(student, obj))]

∀P [PolicyPredicate(P) → ∃audit_log: ∀(u,a): P(u,a) ↔ Recorded(audit_log, u, a)]
```
SOL quantifies over **predicates as first-class values**: RBAC policies, adaptive recommendation functions, and audit predicates are themselves objects that must be specified, versioned, and tested.

**Third-Order Logic (TOL)**:
```
Let Ω  = { P : P is a policy predicate over (user, resource, action) }
Let Λ  = { F : F is a learning function over (student, objective, history) }
Let Ξ  = { Q : Q is a quality predicate over learning outcomes }

∃Eval: (Ω × Λ) → Ξ
— There exists an evaluation function from (policies × learning functions) to outcome quality predicates

□(∀ω ∈ Ω, ∀λ ∈ Λ: Eval(ω, λ) ∈ Ξ)
— Necessarily, every combination of policy and learning function maps to a measurable quality outcome

◇(∃ω* ∈ Ω, ∃λ*∈ Λ: Eval(ω*, λ*) = MaxLearningOutcome)
— It is possible to find an optimal policy-learning function pair
```
TOL frames the **architectural correctness condition**: the platform must be designed such that the composition of RBAC policies with adaptive learning functions **necessarily** maps to measurable learning outcomes. This is the formal statement of what makes Gamma non-trivial and why it cannot be compressed into Beta.

**Modal Logic**:
```
□(Gamma → Accreditation_Ready)        — Full RBAC + LTI necessarily enables accreditation compliance
□(Gamma → FERPA_Applicable)           — Multi-tenant student data necessarily triggers FERPA
□(Gamma → HigherEngineering_Cost)     — Gamma necessarily requires 6-12 months and a team
◇(Gamma → MarketDifferentiation)      — Gamma possibly creates a defensible product moat
◇(Gamma → OpenSource_Community)       — Gamma possibly spawns a contributor ecosystem
¬◇(Gamma → QuickDeployment)           — It is not possible that Gamma deploys quickly
```

---

### Architecture Additions (Beyond Beta)

```
┌──────────────────────────────────────────────────────────────┐
│              Platform Layer (NEW)                            │
├──────────────────────────────────────────────────────────────┤
│  Organization / Tenant Management (multi-tenant SurrealDB)   │
│  SAML / OAuth SSO (integrate with university IdPs)           │
│  RBAC Engine (admin, instructor, TA, student, auditor)       │
│  LTI 1.3 Provider (embed in Canvas, Moodle, Blackboard)      │
│  Competency & Curriculum Graph (learning objectives as graph)│
│  Adaptive Path Engine (LangGraph + assessment history)       │
│  Analytics Pipeline (ClickHouse or TimescaleDB for events)   │
│  Certificate Issuance (verifiable, PDF + blockchain anchor)  │
│  Gradebook API (LTI Advantage Grade Passback)                │
└──────────────────────────────────────────────────────────────┘
                         │ Uses as engine
┌──────────────────────────────────────────────────────────────┐
│  Open Notebook Core (existing)                               │
│  AI Chat, Semantic Search, Podcast, Content Ingestion       │
└──────────────────────────────────────────────────────────────┘
```

**New Services Required**:
1. **`api/routers/tenants.py`** — Org creation, tenant provisioning, domain mapping
2. **`api/routers/curriculum.py`** — Course, module, lesson, learning objective CRUD
3. **`api/routers/assessments.py`** — Quiz, assignment, rubric, submission, grading
4. **`api/routers/competencies.py`** — Competency framework, mastery tracking
5. **`api/routers/analytics.py`** — Engagement, completion, assessment analytics
6. **`api/routers/lti.py`** — LTI 1.3 launch, deep linking, grade passback
7. **`api/routers/certificates.py`** — Issuance, verification, template management
8. **`open_notebook/graphs/adaptive.py`** — New LangGraph workflow: adaptive path recommendation

**New Database Migrations**:
```
migrations/009_tenants.surql
migrations/010_users_full.surql
migrations/011_rbac.surql
migrations/012_curriculum.surql
migrations/013_assessments.surql
migrations/014_competencies.surql
migrations/015_analytics_events.surql
migrations/016_certificates.surql
```

---

### Estimated Engineering Investment

| Workstream | Team | Duration |
|------------|------|----------|
| Multi-tenant + RBAC | 2 Backend engineers | 6-8 weeks |
| Assessment engine | 1 Backend + 1 Frontend | 4-6 weeks |
| Adaptive path LangGraph | 1 AI engineer | 4-6 weeks |
| Analytics pipeline | 1 Data engineer | 4-6 weeks |
| LTI 1.3 integration | 1 Backend engineer | 3-4 weeks |
| Frontend LMS UX | 2 Frontend engineers | 8-10 weeks |
| Certificate system | 1 Backend engineer | 2-3 weeks |
| **Total** | **8 engineers** | **~20 weeks** |

---

### Kolmogorov Complexity Assessment

```
K(Gamma) = K(OpenNotebook)              — base
          + K(Multi_tenant_arch)        — new, irreducible
          + K(RBAC_engine)              — new, irreducible
          + K(LTI_1.3_protocol)         — protocol compliance, highly specified
          + K(Curriculum_graph_model)   — new ontology
          + K(Assessment_engine)        — new domain
          + K(Adaptive_path_graph)      — new LangGraph workflow
          + K(Analytics_pipeline)       — new data stack
          + K(Certificate_system)       — new trust model
          + K(Interaction_terms)        — cross-component integration complexity
          ≈ B + ~40,000-80,000 lines of novel, irreducible specification
          + compliance overhead (FERPA, WCAG, LTI spec)
```

**The interaction terms are non-negligible**: the complexity of Gamma is **superadditive** because each new component interacts with every other. This is the signature of high-K systems — their description length grows faster than the sum of parts.

---

---

## COA Comparison Matrix

| Dimension | Alpha (Launch Now) | Beta (Learning Overlay) | Gamma (Platform Transform) |
|-----------|-------------------|------------------------|---------------------------|
| **K(x) complexity** | `B + ε` | `B + ~3K lines` | `B + ~60K lines` |
| **Time to first user** | 1-3 days | 4-6 weeks | 5-6 months |
| **Team required** | 1 person | 2-3 engineers | 6-8 engineers |
| **Multi-user** | No (shared password) | Yes (JWT + roles) | Yes (SSO + RBAC) |
| **Assessment** | No | Basic AI quizzes | Full rubric engine |
| **Analytics** | None | Basic progress | Full analytics pipeline |
| **LMS Integration** | None | None | LTI 1.3 |
| **Accreditation-ready** | No | Partial | Yes |
| **FERPA compliance** | Not required | Partial consideration | Required |
| **Scalability** | Single instance | Multi-user, single tenant | Multi-tenant |
| **Modal necessity** | □(Fast) ∧ ¬□(Scale) | □(UserIsolation) ∧ ◇(LTI) | □(Compliant) ∧ □(Expensive) |

---

## Recommendation Logic

**Propositional decision tree**:
```
IF need_value_this_week THEN Alpha
ELSE IF need_multi_user ∧ ¬need_accreditation ∧ budget < $200K THEN Beta
ELSE IF need_accreditation ∨ need_lti ∨ need_multi_tenant THEN Gamma
```

**Modal recommendation**:
```
□(Alpha → immediate_value)               — Deploy Alpha today; guaranteed value
◇(Alpha → Beta) ∧ ◇(Beta → Gamma)       — Paths are composable; Alpha doesn't prevent Beta
¬□(skip_Alpha → faster_value)            — Skipping Alpha is not necessarily faster
```

**Kolmogorov recommendation**:
> The principle of **minimum description length** (MDL) argues for Alpha as the initial deployment. Alpha's description is maximally compressible — it adds near-zero irreducible information to the existing system. Beta and Gamma are best planned **after** Alpha generates user feedback, because user behavior is the irreducible oracle that determines which additional complexity is actually warranted. Premature complexity (building Gamma before validating Alpha) violates MDL and incurs **description length debt**: you specify a system whose actual utility has not yet been empirically confirmed.

**The recommended sequence**:
```
Alpha (Week 1) → gather feedback (Weeks 2-4) → Beta (Month 2-3) → evaluate Gamma (Month 4+)
```

This sequence is **modally necessary** given uncertainty:
```
□(Uncertainty(requirements) → Start_Minimal)
◇(UserFeedback(Alpha) → Compress(Gamma_requirements))
□(Alpha ⊂ Beta) ∧ □(Beta ⊂ Gamma)  — each COA is a strict subset of the next
```

---

## Open Questions Requiring Resolution

The following predicate truth values are **unknown** and must be determined before committing to Beta or Gamma:

1. `∃regulation: AppliesTo(BTCU, regulation) ∧ Requires(regulation, FERPA_compliance)` — Is FERPA required?
2. `∃LMS: CurrentlyUsed(BTCU, LMS) ∧ RequiresIntegration(LMS)` — Must we integrate with Canvas/Moodle?
3. `∃n ∈ ℕ: ExpectedStudents(BTCU) = n ∧ n > SingleTenant_Capacity` — Do we need multi-tenancy?
4. `Accreditation(BTCU) = TRUE ∨ FALSE` — Is formal accreditation tracking required?
5. `Budget(BTCU, engineering) ≥ Gamma_Cost` — Is Gamma financially viable?

**These unknowns are not resolvable through logic alone — they require empirical input from BTCU stakeholders.**

---

*This analysis was produced using the Open Notebook v1.7.4 codebase at commit `cfdf1bd` and reflects the system state as of 2026-02-20. Complexity estimates are order-of-magnitude approximations; actual implementation complexity depends on team experience, existing infrastructure, and requirement stability.*
