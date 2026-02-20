# YouLearn-Style AI Learning App — Product Requirements Document

Specific copy, micro‑interactions, layout nuances, and notes that rely on NotebookLM / Google stack.

---

## 1. Product Overview

YouLearn is:

- An **AI-first learning companion** that:
  - Pulls in content (esp. YouTube lectures) and their **transcripts**.
  - Generates **multi-modal study assets**: quizzes, exams, flashcards, podcasts, AI videos, summaries, notes.
  - Provides a **context-aware chat** (“chat with AI”) grounded in that content.
- Has a **3‑zone layout** around a piece of content:
  1. Video (YouTube embed).
  2. Chapters/Transcript (navigation and text).
  3. Right-hand “Learn” zone with generators + artifacts + chat.
- Is likely built on **NotebookLM SDK** and **Google Enterprise** infra:
  - “Generate” section maps almost 1:1 to NotebookLM “experiments” (summary, quiz, flashcards, podcast, video, etc.).
  - “My Sets” behaves like NotebookLM’s saved experiments.
- Has a **product-led onboarding** with a guided tour of features using **Screen Studio** videos (no audio).

We are referencing UX patterns, then later adapting them for BTCU / Exponent Learn.

---

## 2. User Types & Journeys (with Observed Friction/Patterns)

### 2.1 Primary User: Student (Ayden archetype)

Characteristics:

- Already uses:
  - **Lecture replays**.
  - **Practice problems** given by professor.
  - **AI tools** *surgically* for hard concepts (Hamming codes, satellite latency, etc.).
- Trusts:
  - Credible YouTubers.
  - Institutions (Harvard-style).
  - Is **skeptical** of random “gurus” / overpriced courses.

Desired flows YouLearn supports:

1. See **ready-made courses** on landing (“solves chicken‑and‑egg”):
   - Many built from **YouTube content**.
   - **No “upload content” friction** needed to get initial value.

2. For a lecture he finds himself:
   - Paste or open YouTube link → app:
     - Scrapes transcript, segments into chapters.
     - Offers **pre-baked artifacts** (summary, quiz, flashcards, podcast).
   - Use **chat** to ask concept questions.
   - Use **quiz/flashcards** to drill before exam.

3. For exam prep:
   - Upload professor’s **printed review sheet** / practice problem set.
   - Ask app to **generate similar problems with small variations**.
   - Use **quiz/exam mode** to test knowledge.

### 2.2 Secondary Personas (Inferred from UI)

- **Workers**:
  - Upskill / career transitions / certifications.
- **Personal learners**:
  - Hobbies, curiosity-driven learning.
- **Teachers**:
  - Lesson planning, engaging students, professional development.

UI differences are **purely onboarding questions and suggestion defaults**, not different core functionality.

---

## 3. Information Architecture (More Granular)

### 3.1 Global Shell

- **Viewport split**:
  - Left: collapsible vertical sidebar.
  - Middle-left: content (video + chapters/transcript).
  - Right: “Learn” panel (artifacts & chat).
- **Key CTAs**:
  - **Upgrade**: Big, bright button in top-right.
  - **Add Content**: Primary action in left sidebar when no content is selected.
- **Personalization**:
  - Uses **Google OAuth profile**:
    - Displays “Welcome, Rocky” or similar at top of main area.
    - “Rocky’s Space” as default Space name.

### 3.2 Landing / Dashboard (Post-Onboarding, Pre-Content)

Observed behavior:

- Immediately after onboarding + product tour, user sees:
  - **Personalized greeting**: “Welcome, Rocky”.
  - **Upgrade button** top-right.
  - **Prebuilt course tiles** in main content:
    - e.g., “Advanced Algorithms” with a thumbnail.
    - Likely curated by platform or popular user-created sets.
  - Left sidebar visible.

UX insight:

- This solves the **cold-start**: user doesn’t need to upload anything to try the app.
- Many courses are built on **popular YouTube videos** (seen later).

---

## 4. Content View: Three-Zone Layout in Detail

When user clicks a course such as “Advanced Algorithms”:

### 4.1 Zone 1 — Video Embed (Top-Left)

- Embeds **YouTube player** via iframe:
  - Native YouTube controls: play/pause, scrub bar, quality, playback speed, full-screen.
- **Controls above or near player**:
  - “Close video” icon/button:
    - Collapses/hides the video to free vertical space.
  - When auto-scroll is on, transcript scrolls in sync with playback.

Observed detail:

- Clicking a **transcript line** or **chapter** (Zone 2) jumps the video’s time.
- When video is hidden (by a button near Auto scroll), user can bring it back.

### 4.2 Zone 2 — Chapters & Transcripts (Bottom-Left)

Tabs:

1. **Chapters Tab**
   - Each chapter entry:
     - Short title summarizing the segment.
     - Approx. duration or timestamp range.
   - Behavior:
     - Click → seeks video to that segment.
   - Chapters appear auto-generated: likely summary of every 1–2 minute slice.

2. **Transcript Tab**
   - Full **word-by-word transcript**, broken into lines/paragraphs with timestamps.
   - UI controls:
     - **Copy Transcript** button:
       - Copies entire transcript into clipboard.
       - Useful for manual export into other tools.
     - **Auto-scroll toggle**:
       - When ON: transcript scrolls to current speaking line.
       - When OFF: user can scroll manually while video continues.
       - Possibly a small toggle button near the top-right of transcript area.
     - **Show/hide video**:
       - A button (near Auto-scroll) toggles whether Zone 1 is visible.
   - Interaction:
     - Clicking a transcript line jumps to that time in the video (verified in meeting).

Microcopy we saw (paraphrased but directionally accurate):

- For transcripts, near top:
  - “Copy transcript”
  - “Auto scroll” label next to a toggle.

### 4.3 Zone 3 — Right-Side “Learn” Panel

This is the **power center**: generation + artifacts + chat. It can:

- Sit to the right as a normal panel, **or**
- Expand to full width (hiding Zones 1 & 2) via an expand icon.

#### 4.3.1 Layout of Learn Panel

Vertical stacking:

1. **Top Horizontal Bar — Learn Tabs**
2. **Generate Section** (buttons/tiles)
3. **My Sets** (list of saved / precomputed items)
4. **Chat Input Area** (bottom fixed)

---

## 5. Learn Tabs (Top of Right Panel)

- Horizontal row of tabs, each representing an **open artifact or chat**:
  - Tab types:
    - Summary
    - Quiz
    - Flashcards
    - Notes
    - Podcast
    - Video
    - Chat
  - Tab label = type + short title (e.g. “Quiz: Predecessor…”).
- Behavior:
  - Clicking a **My Sets** item opens a new tab or focuses existing.
  - Only one tab is “active” at a time; its content fills the right panel.
  - Tabs have **close “x”** on each (we infer typical tab pattern).
- This is conceptually similar to NotebookLM’s “Experiments” tabs.

---

## 6. Generate Section (Inside Learn Panel)

Positioned just below Learn Tabs.

### 6.1 Generator Buttons

Buttons, each with icon + label:

- **Podcast**
- **Video**
- **Summary**
- **Quiz**
- **Flashcards**
- **Notes**

Behavior:

- On click:
  - If not previously generated:
    - Show loading indicator on button or inline spinner.
    - After generation completes:
      - Artifact appears as a new **Learn Tab**.
      - Entry is added under **My Sets** with matching type icon.
  - If previously generated:
    - Either regenerate, or open existing (implementation decision).

Implementation note:

- Under the hood, each is a different NotebookLM “producer” type (if using that SDK).

---

## 7. My Sets (Inside Learn Panel)

Below Generate section.

### 7.1 Filter Control

- A **filter dropdown** right-aligned on the My Sets header row:
  - Values:
    - All
    - Summaries
    - Flashcards
    - Quizzes
    - Podcasts
    - Videos
    - Notes
  - Also a **“Clear filter”** control.

### 7.2 List Items

Each row:

- **Type icon**:
  - Quiz icon.
  - Flashcard icon.
  - Headphones for podcast.
  - Video icon.
  - Document icon for notes/summary.
- **Title**:
  - Example items observed:
    - Quiz: “Predecessor Data Structures and Sorting”
    - Flashcards: “Fusion Trees and Data Structures”
    - Podcast: “Advanced Algorithms” (topic).
    - Summary: “Detailed summary” of course.
- **Click behavior**:
  - Opens that artifact in a **new Learn Tab** (or focuses if already open).
- Observed nuance:
  - Some artifacts are **pre-generated** by the platform for that course:
    - When clicking “Detailed summary”, it opened instantly, no visible generation delay.
  - This is slightly different from raw NotebookLM behavior where you must explicitly trigger generation.

---

## 8. Chat with AI (Bottom of Right Panel)

The **chat input bar** is collapsed until focused.

### 8.1 Collapsed State

- Single line:
  - Input placeholder: **“Learn anything”**.
  - Right‑aligned button: **“Voice”** with mic icon.
    - Tooltip on hover: **“Talk with AI”**.

### 8.2 Expanded State (on click/focus)

Within the chat bar’s expanded control row:

#### 8.2.1 Model Selector

- Combo box labeled **“Auto”** by default.
- Dropdown options (with upgrade gating):

  - Auto (default)
  - Gemini 3 Flash
  - Claude Sonnet 4.6 — **requires upgrade** (badge/text).
  - GPT 5.2 — **requires upgrade**.
  - Gemini 3.1 Pro — **requires upgrade**.
  - Grok 4.1 — **requires upgrade**.

- UX pattern:
  - Paid models show an “Upgrade” tag or lock icon.
  - Selecting them prompts “Upgrade” dialog if user not Pro/Max.

#### 8.2.2 Add Context Button

- Button labeled e.g. **“Add context”** with dropdown.
- Dropdown menu groups:

  - **Learn + Search**
    - Tells model to use both ingested content and web search.
  - **Study mode**
    - Likely toggles more pedagogy-focused responses (Socratic, spaced recall, etc.).
  - **Other tools / Study tools**
    - Might include calculators, code interpreters, etc.
  - **Chat instructions**
    - Opens a small dialog where user can type **custom system prompt** for this chat.

#### 8.2.3 Attach File

- **Paperclip icon** with tooltip **“Attach file”**.
- Opens file selection dialog to attach more context documents to that conversation.

#### 8.2.4 Dictate Button

- **Mic icon** (distinct from Voice button).
- Behavior:
  - Click to **record speech-to-text**.
  - Output appears as plain text in input field.
  - Does *not* start an AI voice conversation; only converts your speech to text.

#### 8.2.5 Voice Mode Button

- Big button labeled **“Voice”** with mic icon, right-aligned.
- Tooltip: **“Talk with AI”**.
- Behavior:
  - Activates **two-way voice mode**:
    - Speaks responses using TTS (like 11 Labs).
    - Likely holds conversation until user stops.

Chat area above the input:

- Standard chat UI:
  - Bubbles with question/answer.
  - AI icon vs user avatar.
  - Possibly shows which **model** was used for each response.

---

## 9. Left Sidebar: Expanded Behavior & States

### 9.1 Collapsing

- **Chevron icon** at top-left to collapse/expand sidebar.
- When collapsed:
  - Show only icons.
  - Tooltips on hover.

### 9.2 Sections (Order and Labels)

Top → bottom:

1. **Logo + App Name**
2. **Add Content** (primary action)
3. **Search**
4. **History**
5. **Spaces**
   - Label: **“Spaces”**.
   - Items:
     - “New Space” button.
     - Default: “Rocky’s space”.
     - Additional spaces (e.g., “Exponent Learn”) below.
6. **Recents**
   - Label: **“Recents”**.
   - 3–5 recently used courses/artifacts.
7. **Help and Tools**
   - Label: **“Help and Tools”**.
   - Items:
     - Feedback.
     - Quick Guide.
     - Chrome extension.
     - Discord (or community).
     - Changelog / New features.
8. **Profile / Account Menu** (footer)
   - Click shows dropdown.

---

## 10. Help & Tools — UI Details

### 10.1 Feedback

- Modal:
  - Title: “Send feedback”
  - Textarea: “Tell us what you think or what’s not working.”
  - Optional email field (if not tied to auth).
  - Submit button.

### 10.2 Quick Guide

- Large modal, center of screen, with its own **nested sidebar**.
- Left column:
  - Sections:
    - Add content
    - Chat with AI
    - Summaries
    - Flashcards
    - Quizzes
    - Podcasts
    - Voice mode
    - Exams
    - Spaces (create/use/share)
    - Languages & models
- Right column:
  - For each section:
    - Short text instructions.
    - **Screen Studio video GIF** (no audio) demonstrating the feature step-by-step.

UX pattern:

- The Quick Guide is basically **embedded docs** instead of linking to docs site.
- It never navigates away from current page; always modal.

### 10.3 Chrome Extension

- Opens Chrome Web Store:
  - `chromewebstore.google.com` link with app-specific extension.
- Feature in Quick Guide:
  - “Add content in one click from Chrome.”

### 10.4 Discord / Community

- Sidebar entry labeled “Discord”.
- Clicking:
  - Opens new tab to Discord invite link.
  - For us: would later be replaced or supplemented with “School” link.

### 10.5 Changelog / New Features

Two surfaces:

1. **Menu item “New features” / “Changelog”**
   - Opens modal with:
     - Title: “What’s new”
     - List or **carousel** of features:
       - Example shown: “Create interactive visualizations”.
       - Each feature card has:
         - Title.
         - Short copy.
         - Embedded Screen Studio clip.
     - Auto-scroll / auto-advance of cards (slow).
2. **Mini-banner “New” on main UI**
   - Small popover at bottom right:
     - Badge: **“New”**.
     - Short text about new feature.
     - Buttons:
       - “Play” / “Learn more”: opens same modal.
       - “Dismiss”: closes permanently (until next feature).

---

## 11. Profile / Account Menu & Settings (Extended)

### 11.1 Profile Menu

- Click on profile name/avatar at bottom of sidebar:
  - Menu items:
    - **Settings**
    - **Pricing**
    - **Invite & Earn**
    - Dark mode / Light mode toggle.
    - **Log out**.

### 11.2 Settings Modal — More Detail

Tabs:

1. **Account**
   - Fields (mostly read-only except name):
     - Name.
     - Email.
     - Date created.
     - “Learning streak”: counter for consecutive active days.
     - “Content count”: how many content items or artifacts.
   - Referral block:
     - Text: e.g., “Invite friends for 15% off their first month.”
     - Referral link + **Copy link** button.

2. **Personalization**
   - **Language** dropdown (UI language).
   - **Theme**:
     - Radio: Light / Dark / System.
   - **Chat Model**:
     - Dropdown listing same models as chat:
       - Auto, Gemini 3 Flash, Claude Sonnet 4.6 (Upgrade), GPT 5.2 (Upgrade), Gemini 3.1 Pro (Upgrade), Grok 4.1 (Upgrade).
     - Some have lock/badge.

3. **Plan & Billing**
   - Shows current plan:
     - “You are currently on the Free plan.”
   - Large **Upgrade Plan** button (primary color).

4. **Members** (if team plan)
   - Table:
     - Email, Role, Status.
   - Actions:
     - **Invite member** (opens email modal).
     - Remove (trash icon).

5. **Data Controls**
   - Section “Delete Account”.
   - Big red outline button: “Delete account”.
   - On click:
     - Confirmation modal: “Type DELETE to confirm”.

---

## 12. Pricing Page — Additional Nuances

- Accessed from:
  - Sidebar profile menu → Pricing.
  - “Upgrade” CTA → Pricing.
- Layout:
  - **Tabs** or toggle for:
    - Individual.
    - Teams.
  - Cards for:
    - Free.
    - Pro ($20/mo).
    - Max ($60/mo).
- Each card shows:
  - Quotas:
    - Tokens/month.
    - Number of podcasts/day (e.g. 12).
    - Number of AI videos/day (e.g. 12).
    - Characters read aloud (e.g. 200k).
    - Max file size limits.
  - “Upgrade” or “Current plan” CTA.

---

## 13. Content Types — More Detailed UIs

### 13.1 Quiz

- Top:
  - Title: “Quiz: [Topic]”.
  - Maybe label: “Based on [Content Title]”.
- Body:
  - Single question panel with:
    - Question text.
    - 3–5 options (radio buttons).
  - Buttons:
    - “Next” / “Previous”.
    - “Submit” once at final question.
- After submission:
  - Score summary.
  - Each question can be expanded to see:
    - Correct answer.
    - Explanation.

### 13.2 Flashcards

- Centered card view:
  - “Front” side:
    - Term / question.
  - Interaction:
    - Click or “Flip” button.
  - “Back” side:
    - Definition / answer.
- Controls:
  - “Next card”.
  - Possibly skip or mark: “Got it” / “Need review” (future SRS).

### 13.3 Summary

- Document-like view:
  - Title: “Detailed summary”.
  - Body:
    - Headings (e.g., H2 for major topics).
    - Bulleted or short paragraphs.
- Controls:
  - “Copy summary”.
  - “Save to [Space]”.

### 13.4 Podcasts

- List or single:
  - Title: “Podcast: [Topic]”.
  - Metadata: “2 speakers”, approx duration, creation date.
- Player:
  - Play/pause.
  - Scrubber.
  - Speed control (1x, 1.25x, 1.5x, 2x).
- Optionally shows a **segment list**.

### 13.5 AI Videos

- Thumbnail grid or single video view.
- Click:
  - Opens player similar to YouTube embed (but presumably their own).
- Info:
  - Title.
  - Duration.
  - Short description.

### 13.6 Notes

- Rich-text panel:
  - Inline editing.
  - Standard toolbar: bold, italic, underline, headings, bullets, links.
- By default, auto-generated note summary.

---

## 14. Spaces — Additional Behavior

- Each Space acts like a **folder + knowledge graph**:
  - Contains:
    - Original sources (YouTube, PDFs, text).
    - Derivative artifacts (quizzes, flashcards, etc.).
- In a Space view:
  - Top actions:
    - “Add content”.
    - “Generate exam” (phase 2).
  - List of:
    - Content items.
    - Generated artifacts grouped by type.

Future (beyond YouLearn, but relevant to us):

- Exams across multiple sources in a Space.
- Progress tracking: which content you’ve completed.

---

## 15. Observed / Inferred Implementation Stack

(Not productized in UI, but helpful constraints for clone design.)

- **Backend**:
  - Likely Firebase Auth for Google sign-in.
  - Firestore/RTDB or similar for Spaces / artifacts.
- **AI**:
  - NotebookLM SDK inside Google Workspace / Enterprise.
  - Multi-model options (Gemini, Claude, GPT, Grok) aggregated via some broker.
- **Frontend**:
  - SPA (React-like), heavy use of modals and side-panels.
  - Screen Studio for help/changelog clips.

We are cloning the UI/UX and leaving underlying stack open (we’ll use Open Notebook AI fork).

---

## 16. Left Sidebar Breakdown

### 16.1 V1 (MVP for BTCU/Exponent Learn)

- Left sidebar:
  - Add Content, Search, History, Spaces, Recents, Help & Tools, Profile.
- Three-zone content view:
  - Video embed (YouTube).
  - Chapters + Transcript with:
    - Copy transcript.
    - Auto scroll.
    - Click-to-seek.
  - Learn panel:
    - Tabs.
    - Generate (Summary, Quiz, Flashcards, Notes).
    - My Sets.
    - Chat with:
      - Model selector.
      - Attach file.
      - Dictate.
      - Voice (may simply call 11 Labs).
- Onboarding wizard + product tour with Screen Studio-style videos.
- Settings: Account, Personalization, Plan/Billing, Delete account.
- Pricing page (Free + one paid tier) with dummy quotas.

### 16.2 V2+ (After MVP)

- Pod/Vid generation (Podcast, AI Videos).
- Exams.
- Chrome extension.
- Members/team workspace.
- New-feature banners & interactive visualizations.
- Social/community tab (Reddit-style comments, upvotes).
- Personalization quiz for priors (interests, learning style) triggered after some usage.

---

This PRD encodes most of the UX and behavior we observed and discussed, at a level where designers and engineers can recreate the product 1:1 before layering in BTCU/Exponent Learn-specific changes.
