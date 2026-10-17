const STORAGE_KEY = 'wellphone.app.v1';

const CATEGORIES = [
  { id: 'fitness', label: 'Fitness', icon: '🏃' },
  { id: 'education', label: 'Education / career', icon: '📚' },
  { id: 'selfcare', label: 'Self-care', icon: '🌿' },
  { id: 'social', label: 'Social', icon: '💬' },
  { id: 'creative', label: 'Creative', icon: '🎨' },
];

const TASKS = {
  fitness: [
    ['walk', 'Take a 5-minute walk', '🚶'],
    ['stretch', 'Stretch for a few minutes', '🧘'],
    ['movement', 'Do 10 bodyweight reps', '💪'],
    ['balance', 'Try a quick balance drill', '⚖️'],
  ],
  education: [
    ['read', 'Read one page for class', '📖'],
    ['assignment', 'Work on one assignment step', '✍️'],
    ['career', 'Take one step on a job application', '💼'],
    ['learn', 'Learn one new vocabulary word', '🔤'],
  ],
  selfcare: [
    ['water', 'Drink a glass of water', '💧'],
    ['teeth', 'Brush your teeth', '🪥'],
    ['skincare', 'Do one skincare step', '🫧'],
    ['breathe', 'Take a few slow breaths', '🌬️'],
  ],
  social: [
    ['text', 'Send a friend a kind message', '💌'],
    ['call', 'Call someone you care about', '📞'],
    ['checkin', 'Check in with a teammate', '🤝'],
    ['plans', 'Make a plan to see someone', '🗓️'],
  ],
  creative: [
    ['journal', 'Write one line in a journal', '📝'],
    ['sketch', 'Make a quick sketch', '✏️'],
    ['music', 'Practice an instrument for 5 minutes', '🎵'],
    ['story', 'Write one sentence of a story', '📓'],
  ],
};

const POPULAR_REDIRECTIONS = [
  { id: 'wiki', title: 'Read a fun Wikipedia page', detail: 'Pick a topic you’ve always wondered about', category: 'education', icon: '🌐' },
  { id: 'new-music', title: 'Listen to a new music release', detail: 'Put on one new song and just listen', category: 'creative', icon: '🎧' },
  { id: 'guided-stretch', title: 'Follow a quick guided stretch', detail: 'A short reset for your body', category: 'fitness', icon: '🧘' },
  { id: 'meditation', title: 'Try a short meditation', detail: 'A couple of quiet minutes, at your pace', category: 'selfcare', icon: '🌿' },
  { id: 'water-breath', title: 'Get a glass of water and take three slow breaths', detail: 'A small, screen-free reset', category: 'selfcare', icon: '💧' },
  { id: 'poem', title: 'Read a short poem', detail: 'A small change of pace', category: 'creative', icon: '📜' },
  { id: 'interesting-article', title: 'Read one interesting article', detail: 'Choose a topic you’re curious about', category: 'education', icon: '📰' },
  { id: 'voice-note', title: 'Send someone a quick voice note', detail: 'A little connection goes a long way', category: 'social', icon: '🎙️' },
  { id: 'doodle', title: 'Make a one-minute doodle', detail: 'No supplies or plan needed', category: 'creative', icon: '✏️' },
  { id: 'outside', title: 'Step outside for a few minutes', detail: 'A brief change of scenery', category: 'fitness', icon: '🌤️' },
];

const MAJOR_GOALS = [
  ['📚', 'Do better in school'], ['💼', 'Find a job'], ['🌙', 'Sleep more consistently'],
  ['💪', 'Get stronger'], ['🏠', 'Make my space feel better'], ['🎨', 'Learn a creative skill'],
  ['🌱', 'Build healthier routines'], ['🗣️', 'Learn a language'], ['📖', 'Read more'],
  ['✍️', 'Write a book'],
];

const ROUTINES = {
  morning: {
    title: 'Morning Start', icon: '🌤️', window: '4:00 AM – 11:59 AM',
    description: 'A complete morning checklist you can follow in order, adjust, or skip through.',
    steps: [
      { title: 'Get up and open the curtains', detail: 'Start the day when you’re ready.', icon: '🛏️' },
      { title: 'Set 3 goals for today', detail: 'Choose three things you want to make time for today.', icon: '🎯', action: 'setDailyGoals' },
      { title: 'Use the bathroom, brush your teeth, and wash your face', detail: 'Adjust this step to match your own morning care.', icon: '🪥' },
      { title: 'Do your morning skincare and hair routine', detail: 'Add, remove, or change the products and steps you use.', icon: '🌿' },
      { title: 'Get dressed', detail: 'Your clothes can be set out the night before.', icon: '👕' },
      { title: 'Eat breakfast or prepare something for later', detail: 'Choose what works for your day.', icon: '🥣' },
      { title: 'Collect your bag and put anything else you need by the door', detail: 'A quick check before heading out.', icon: '🎒' },
      { title: 'Check your calendar and choose your first priority', detail: 'Keep the day’s first step visible.', icon: '🗓️' },
    ],
  },
  winddown: {
    title: 'Wind Down', icon: '🌙', window: '5:00 PM – 3:59 AM',
    description: 'Your evening close-out, ready to personalize around the way you get ready for tomorrow and for bed.',
    steps: [
      { title: 'Reflect on the 3 goals you set this morning', detail: 'Mark each one met, in progress, or not today. Your day is still yours.', icon: '🌅', action: 'reflectDailyGoals' },
      { title: 'Pack your bag for tomorrow and put it by the door', detail: 'Add anything you need for school, work, or your plans.', icon: '🎒' },
      { title: 'Clean one area', detail: '', icon: '🧹', rotatesByDay: true },
      { title: 'Set out your clothes for tomorrow', detail: 'Include anything you need for the weather or your plans.', icon: '👕' },
      { title: 'Set any alarms you need for tomorrow', detail: 'Set or adjust your alarms in the Clock app.', icon: '⏰' },
      { title: 'Brush your teeth', detail: 'Add flossing, mouthwash, or other dental steps if you want them.', icon: '🪥' },
      { title: 'Do your skincare routine', detail: 'Keep the steps you use and remove the ones you don’t.', icon: '🫧' },
      { title: 'Do your nighttime hair maintenance', detail: 'For example: brush, wrap, braid, bonnet, or other care you prefer.', icon: '🪮' },
      { title: 'Close the curtains', detail: 'Set up your room the way you like it for sleep.', icon: '🪟' },
      { title: 'Plug your phone in where you want it for the night', detail: 'Choose a place that works for your morning.', icon: '🔌' },
      { title: 'Choose a quiet last activity', detail: 'Read, listen to something, or settle in for sleep.', icon: '📖' },
    ],
  },
};
const DAILY_CLEANING = [
  'reset your bedside table',
  'put laundry in its place',
  'wipe the bathroom sink',
  'clear your desk or workspace',
  'take out the trash or recycling',
  'tidy one shared surface',
  'reset your entryway',
];

const ROUTINE_SCHEMA_VERSION = 3;
const DEFAULT_STATE = { onboarded: false, goals: [], concern: '', mode: 'Structured', logs: [], routineProgress: {}, dailyGoals: {}, goalReflections: {}, routineSchemaVersion: ROUTINE_SCHEMA_VERSION };
let state = loadState();
let view = state.onboarded ? 'today' : 'onboarding';
let onboardingStep = 1;
let draftGoals = [];
let draftSelectedTasks = new Set();
let draftTaskGoalId = '';
let activeCategory = 'fitness';
let activeApp = 'TikTok';
let currentReason = '';
let currentTask = null;
let redirectSuggestions = [];
let selectedRoutine = null;
let routineEditing = false;
let routineDraft = [];
let currentReflections = {};
let currentSessionSeconds = 8 * 60;
let sessionTimer = null;
let toastTimer = null;
let app = document.querySelector('#app');

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || 'null');
    if (saved && Array.isArray(saved.goals)) {
      const loaded = { ...DEFAULT_STATE, ...saved, routines: saved.routines || cloneRoutines() };
      const oldRoutineVersion = saved.routineSchemaVersion || 0;
      if (oldRoutineVersion < 2) loaded.routines = cloneRoutines();
      if (oldRoutineVersion < ROUTINE_SCHEMA_VERSION) {
        loaded.routines = mergeRoutineDefaults(loaded.routines);
        loaded.routineProgress = {};
        loaded.routineSchemaVersion = ROUTINE_SCHEMA_VERSION;
        localStorage.setItem(STORAGE_KEY, JSON.stringify(loaded));
      }
      return loaded;
    }
    const old = JSON.parse(localStorage.getItem('wellphone-demo') || 'null');
    if (old && old.goal) {
      return {
        ...createDefaultState(), onboarded: true, mode: old.mode || 'Structured',
        goals: [{ id: uid(), title: old.goal, active: true, smallGoals: [{ id: uid(), title: old.task || 'Read one page for class', category: 'education', icon: '📚', done: false }] }],
        logs: [],
      };
    }
    return createDefaultState();
  } catch { return createDefaultState(); }
}

function cloneRoutines() { return JSON.parse(JSON.stringify(ROUTINES)); }
function mergeRoutineDefaults(routines) {
  const next = JSON.parse(JSON.stringify(routines || cloneRoutines()));
  for (const id of Object.keys(ROUTINES)) {
    next[id] ||= JSON.parse(JSON.stringify(ROUTINES[id]));
    const steps = next[id].steps || (next[id].steps = []);
    for (const required of ROUTINES[id].steps) {
      const exists = required.action ? steps.some(step => step.action === required.action) : /alarm/i.test(required.title) ? steps.some(step => /alarm/i.test(step.title)) : /curtain/i.test(required.title) ? steps.some(step => /curtain/i.test(step.title)) : false;
      if (exists) continue;
      if (required.action === 'setDailyGoals') steps.splice(Math.min(1, steps.length), 0, { ...required });
      else if (required.action === 'reflectDailyGoals') steps.unshift({ ...required });
      else if (/alarm/i.test(required.title)) steps.splice(Math.min(4, steps.length), 0, { ...required });
      else if (/curtain/i.test(required.title)) steps.splice(Math.max(0, steps.findIndex(step => /plug your phone/i.test(step.title))), 0, { ...required });
    }
  }
  return next;
}
function createDefaultState() { return { ...DEFAULT_STATE, routines: cloneRoutines() }; }
function uid() { return (globalThis.crypto?.randomUUID?.() || `${Date.now()}-${Math.random().toString(16).slice(2)}`); }
function esc(value = '') { return String(value).replace(/[&<>"']/g, c => ({ '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' }[c])); }
function save() { localStorage.setItem(STORAGE_KEY, JSON.stringify(state)); }
function category(id) { return CATEGORIES.find(item => item.id === id) || CATEGORIES[0]; }
function notify(message) {
  const toast = document.querySelector('#toast');
  toast.textContent = message; toast.classList.add('show');
  clearTimeout(toastTimer); toastTimer = setTimeout(() => toast.classList.remove('show'), 2400);
}
function setView(next) {
  clearInterval(sessionTimer); sessionTimer = null; view = next; render();
}
function header() { return `<header class="topbar"><div class="brand"><div class="logo">w</div>wellphone</div>${state.onboarded ? '<button class="link-btn" data-action="edit-plan" aria-label="Edit your plan">Your plan</button>' : ''}</header>`; }
function nav(active) {
  return `<nav class="nav" aria-label="Main navigation">
    <button data-nav="today" class="${active === 'today' ? 'active' : ''}"><b>⌂</b>Today</button>
    <button data-nav="routine" class="${active === 'routine' ? 'active' : ''}"><b>◷</b>Routine</button>
    <button data-nav="redirect" class="${active === 'redirect' ? 'active' : ''}"><b>↗</b>Redirect</button>
    <button data-nav="insights" class="${active === 'insights' ? 'active' : ''}"><b>▤</b>Insights</button>
  </nav>`;
}
function bindGlobal() {
  app.querySelectorAll('[data-nav]').forEach(button => button.addEventListener('click', () => {
    if (button.dataset.nav === 'redirect') openRedirect('TikTok');
    else { if (button.dataset.nav === 'routine') { selectedRoutine = getRoutineContext().id; routineEditing = false; routineDraft = []; } setView(button.dataset.nav); }
  }));
  app.querySelectorAll('[data-action="edit-plan"]').forEach(button => button.addEventListener('click', () => setView('plan')));
}

function render() {
  if (!state.onboarded) return renderOnboarding();
  if (view === 'today') return renderToday();
  if (view === 'redirect') return renderRedirect();
  if (view === 'choose-task') return renderChooseTask();
  if (view === 'task') return renderTask();
  if (view === 'session') return renderSession();
  if (view === 'routine') return renderRoutine();
  if (view === 'daily-goals') return renderDailyGoals();
  if (view === 'plan') return renderPlan();
  if (view === 'insights') return renderInsights();
  renderToday();
}

function renderOnboarding() {
  const pct = onboardingStep * 33.33;
  let content = '';
  if (onboardingStep === 1) content = renderOnboardingGoals();
  else if (onboardingStep === 2) content = renderOnboardingTasks();
  else content = renderOnboardingStyle();
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><div class="eyebrow">LET’S MAKE A PLAN · STEP ${onboardingStep} OF 3</div><div class="onboarding-progress"><span style="width:${pct}%"></span></div>${content}</div></section>`;
  bindGlobal();
  bindOnboarding();
}

function renderOnboardingGoals() {
  const suggestions = MAJOR_GOALS.map(([icon, title]) => `<button class="goal-suggestion ${draftGoals.some(g => g.title === title) ? 'selected' : ''}" data-suggest-goal="${esc(title)}"><span>${icon}</span>${esc(title)}</button>`).join('');
  const chips = draftGoals.map(goal => `<span class="goal-chip">${esc(goal.title)} <button aria-label="Remove ${esc(goal.title)}" data-remove-draft-goal="${goal.id}">×</button></span>`).join('');
  return `<div class="eyebrow">START WITH WHAT MATTERS TO YOU</div><h1 class="page-title">What do you want<br>more room for?</h1><p class="muted">Add one or more bigger goals. You can change them any time.</p>
    <div class="onboard-options">${suggestions}</div><div class="onboard-goal"><input class="field" id="majorGoalInput" maxlength="70" placeholder="Add another goal"><button class="btn btn-soft" data-action="add-major">Add</button></div>
    <div class="onboard-goal-list">${chips}</div><div class="actions"><button class="btn btn-primary btn-block" data-action="next-onboard" ${draftGoals.length ? '' : 'disabled'}>Choose small next steps&nbsp; →</button><p class="feedback">Your big goals can have their own small steps. Add a few big goals if several parts of life matter right now.</p></div>`;
}

function renderOnboardingTasks() {
  if (!draftTaskGoalId && draftGoals.length) draftTaskGoalId = draftGoals[0].id;
  const categories = CATEGORIES.map(item => `<button class="category-card ${activeCategory === item.id ? 'selected' : ''}" data-onboard-category="${item.id}"><span>${item.icon}</span><b>${esc(item.label)}</b><small>${TASKS[item.id].filter(([id]) => draftSelectedTasks.has(id)).length} selected</small></button>`).join('');
  const goalTaskPrefix = `${draftTaskGoalId}::`;
  const tasks = TASKS[activeCategory].map(([id, title, icon]) => `<label class="task-check"><input type="checkbox" data-onboard-task="${id}" ${draftSelectedTasks.has(`${goalTaskPrefix}${id}`) ? 'checked' : ''}><span>${icon} ${esc(title)}</span></label>`).join('');
  const goalOptions = draftGoals.map(goal => `<option value="${goal.id}" ${draftTaskGoalId === goal.id ? 'selected' : ''}>${esc(goal.title)}</option>`).join('');
  const count = [...draftSelectedTasks].filter(item => item.startsWith(goalTaskPrefix)).length;
  return `<button class="back-btn" data-action="previous-onboard">← &nbsp; Back</button><div class="eyebrow">TURN GOALS INTO SMALL STEPS</div><h1 class="page-title">What could help<br>you get there?</h1><p class="muted">Pick small actions you’d like to see when you need a redirect. They’re grouped by area.</p>
    <label class="field-label" for="taskGoalSelect">Add these steps under</label><select id="taskGoalSelect" class="select">${goalOptions}</select>
    <div class="category-grid">${categories}</div><div class="task-picker">${tasks}</div>
    <label class="field-label" for="customSmallGoal">Add a small step of your own</label><div class="inline-row"><input class="field" id="customSmallGoal" maxlength="70" placeholder="e.g. Put my gym clothes out"><button class="btn btn-soft" data-action="add-custom-small">Add</button></div>
    <div class="actions"><button class="btn btn-primary btn-block" data-action="next-onboard">Continue with ${count} step${count === 1 ? '' : 's'}&nbsp; →</button><p class="feedback">You can start with one or two. You can add more later from Your plan.</p></div>`;
}

function renderOnboardingStyle() {
  const concerns = [
    ['I lose time scrolling','I lose track of time on apps'], ['I avoid things I care about','I use my phone to put off something'],
    ['My evenings drift late','My phone gets in the way of bedtime'], ['I pick up my phone automatically','I open apps without meaning to'],
  ];
  return `<button class="back-btn" data-action="previous-onboard">← &nbsp; Back</button><div class="eyebrow">A LITTLE PERSONALIZATION</div><h1 class="page-title">What brings you<br>to WellPhone?</h1><p class="muted">There’s no wrong answer. This helps make the first check-in feel relevant.</p>
    <div class="category-grid">${concerns.map(([title, value]) => `<button class="category-card ${state.concern === value ? 'selected' : ''}" data-concern="${esc(value)}"><span>✳</span><b>${esc(title)}</b></button>`).join('')}</div>
    <label class="field-label" for="modeSelect">How much structure would feel helpful?</label><select id="modeSelect" class="select"><option ${state.mode === 'Gentle' ? 'selected' : ''}>Gentle</option><option ${state.mode === 'Structured' ? 'selected' : ''}>Structured</option><option ${state.mode === 'Strict' ? 'selected' : ''}>Strict</option></select>
    <div class="note"><span class="symbol">🌱</span><span>Your settings are yours to change. WellPhone offers support; you stay in control.</span></div><div class="actions"><button class="btn btn-primary btn-block" data-action="finish-onboard">Build my home&nbsp; →</button></div>`;
}

function bindOnboarding() {
  app.querySelectorAll('[data-suggest-goal]').forEach(button => button.addEventListener('click', () => {
    const title = button.dataset.suggestGoal;
    const found = draftGoals.find(g => g.title === title);
    if (found) draftGoals = draftGoals.filter(g => g.id !== found.id);
    else draftGoals.push({ id: uid(), title, active: true, smallGoals: [] });
    if (!draftTaskGoalId && draftGoals.length) draftTaskGoalId = draftGoals[0].id;
    renderOnboarding();
  }));
  app.querySelectorAll('[data-remove-draft-goal]').forEach(button => button.addEventListener('click', () => {
    draftGoals = draftGoals.filter(goal => goal.id !== button.dataset.removeDraftGoal);
    if (!draftGoals.some(goal => goal.id === draftTaskGoalId)) draftTaskGoalId = draftGoals[0]?.id || '';
    renderOnboarding();
  }));
  app.querySelector('[data-action="add-major"]')?.addEventListener('click', addDraftMajor);
  app.querySelector('#majorGoalInput')?.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); addDraftMajor(); } });
  app.querySelector('[data-action="next-onboard"]')?.addEventListener('click', () => {
    if (onboardingStep === 1 && !draftGoals.length) return notify('Choose or add at least one goal to begin.');
    if (onboardingStep === 2 && draftGoals.length === 0) return;
    if (onboardingStep < 3) { onboardingStep += 1; renderOnboarding(); }
  });
  app.querySelector('[data-action="previous-onboard"]')?.addEventListener('click', () => { onboardingStep -= 1; renderOnboarding(); });
  app.querySelectorAll('[data-onboard-category]').forEach(button => button.addEventListener('click', () => { activeCategory = button.dataset.onboardCategory; renderOnboarding(); }));
  app.querySelector('#taskGoalSelect')?.addEventListener('change', e => { draftTaskGoalId = e.target.value; renderOnboarding(); });
  app.querySelectorAll('[data-onboard-task]').forEach(input => input.addEventListener('change', () => {
    const token = `${draftTaskGoalId}::${input.dataset.onboardTask}`;
    if (input.checked) draftSelectedTasks.add(token); else draftSelectedTasks.delete(token);
    renderOnboarding();
  }));
  app.querySelector('[data-action="add-custom-small"]')?.addEventListener('click', addDraftSmallGoal);
  app.querySelector('#customSmallGoal')?.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); addDraftSmallGoal(); } });
  app.querySelectorAll('[data-concern]').forEach(button => button.addEventListener('click', () => { state.concern = button.dataset.concern; renderOnboarding(); }));
  app.querySelector('#modeSelect')?.addEventListener('change', e => { state.mode = e.target.value; });
  app.querySelector('[data-action="finish-onboard"]')?.addEventListener('click', finishOnboarding);
}

function addDraftMajor() {
  const input = app.querySelector('#majorGoalInput'); const title = input.value.trim();
  if (!title) return input.focus();
  if (draftGoals.some(goal => goal.title.toLowerCase() === title.toLowerCase())) return notify('That goal is already on your list.');
  draftGoals.push({ id: uid(), title, active: true, smallGoals: [] }); draftTaskGoalId ||= draftGoals[0].id; renderOnboarding();
}
function addDraftSmallGoal() {
  const input = app.querySelector('#customSmallGoal'); const title = input.value.trim();
  if (!title) return input.focus();
  const goal = draftGoals.find(item => item.id === draftTaskGoalId);
  if (goal) goal.smallGoals.push({ id: uid(), title, category: activeCategory, icon: category(activeCategory).icon, done: false });
  renderOnboarding();
}
function finishOnboarding() {
  for (const token of draftSelectedTasks) {
    const [goalId, taskId] = token.split('::');
    const goal = draftGoals.find(item => item.id === goalId);
    const match = Object.entries(TASKS).flatMap(([catId, tasks]) => tasks.map(task => ({ catId, task }))).find(item => item.task[0] === taskId);
    if (goal && match && !goal.smallGoals.some(item => item.templateId === taskId)) {
      const [, title, icon] = match.task;
      goal.smallGoals.push({ id: uid(), templateId: taskId, title, category: match.catId, icon, done: false });
    }
  }
  state.goals = draftGoals.map(goal => ({ ...goal, active: true, smallGoals: goal.smallGoals || [] }));
  state.onboarded = true; save(); setView('today');
}

function renderToday() {
  const activeGoals = state.goals.filter(goal => goal.active !== false);
  const firstGoal = activeGoals[0];
  const firstTask = activeGoals.flatMap(goal => goal.smallGoals.map(task => ({ ...task, goalTitle: goal.title, goalId: goal.id }))).find(task => !task.done);
  const routineContext = getRoutineContext();
  const apps = [['TikTok','♪'],['Instagram','◎'],['YouTube','▶'],['Maps','⌖'],['Messages','●'],['Books','▤'],['Music','♫'],['Clock','◷']];
  const goalCards = activeGoals.length ? activeGoals.map(goal => {
    const tasks = goal.smallGoals || []; const done = tasks.filter(task => task.done).length;
    return `<article class="card goal-card"><div class="goal-head"><div class="goal-emoji">${goal.emoji || '🌱'}</div><div><strong>${esc(goal.title)}</strong><small>${tasks.length ? `${done} of ${tasks.length} small steps complete` : 'Add small steps to make this goal easier to start'}</small></div></div>${tasks.length ? `<div class="progress"><span style="width:${Math.round(done / tasks.length * 100)}%"></span></div><div class="small-goal-list">${tasks.map(task => `<div class="small-goal ${task.done ? 'done' : ''}"><button data-complete-task="${task.id}" aria-label="${task.done ? 'Mark incomplete' : 'Complete'} ${esc(task.title)}">${task.done ? '✓' : ''}</button><span>${esc(task.title)}</span></div>`).join('')}</div>` : ''}</article>`;
  }).join('') : '<div class="empty-state">Add a goal in Your plan to start shaping your redirects.</div>';
  app.innerHTML = `${header()}<section class="screen active"><div class="hello"><div class="eyebrow" id="todayDate"></div><h1>Make room for<br>what matters.</h1><p class="muted">Your phone can support the life you want to live.</p></div>
    <section class="card hero"><div class="eyebrow">A GOAL YOU CHOSE</div><h2>${esc(firstGoal?.title || 'Your goals, your way')}</h2><p>${esc(state.concern || 'When an app pulls you off course, choose what you want to do next.')}</p><button class="btn btn-lime" data-action="try-app">Try an app check-in&nbsp; →</button></section>
    <div class="section-title"><h2>Open an app</h2><span class="pill">Useful apps stay available</span></div><div class="app-grid">${apps.map(([name, icon], i) => `<button class="app-tile" data-app="${name}"><span class="app-icon">${icon}</span><small>${name}</small></button>`).join('')}</div>
    <div class="note"><span class="symbol">✳</span><span><b>Your phone, your choice.</b> WellPhone makes room for the things you care about. You can continue to any app.</span></div>
    <div class="section-title"><h2>Daily rhythm</h2><button class="link-btn" data-action="open-routine">Both routines</button></div><button class="card goal-row" style="width:100%;text-align:left;border:1px solid #e8ece6" data-action="open-routine"><div class="goal-emoji">${getRoutine(routineContext.id).icon}</div><div style="flex:1"><strong>${esc(routineContext.headline)}</strong><span>${esc(getRoutine(routineContext.id).title)} · ${esc(routineContext.subline)}</span></div><span class="arr">›</span></button>
    <div class="section-title"><h2>Today’s 3 goals</h2><button class="link-btn" data-action="edit-daily-goals">Edit goals</button></div><section class="card daily-goals-card"><div class="daily-goals-list">${getDailyGoals().map((goal, i) => `<div><span>${i + 1}</span><p>${esc(goal || 'Add a goal for today')}</p></div>`).join('')}</div></section>
    <div class="section-title"><h2>Your goals</h2><button class="link-btn" data-action="edit-plan">Manage</button></div><div class="goal-stack">${goalCards}</div>
    ${firstTask ? `<div class="section-title"><h2>A small next step</h2><span class="pill">${esc(firstTask.goalTitle)}</span></div><button class="task-option" style="width:100%" data-home-task="${firstTask.id}" data-goal="${firstTask.goalId}"><span class="task-emoji">${firstTask.icon || '✨'}</span><span><b>${esc(firstTask.title)}</b><small>${esc(category(firstTask.category).label)} · picked by you</small></span><span class="arr">›</span></button>` : ''}
    </section>${nav('today')}`;
  const date = new Date(); app.querySelector('#todayDate').textContent = date.toLocaleDateString(undefined,{weekday:'long',month:'long',day:'numeric'}).toUpperCase();
  bindGlobal();
  app.querySelectorAll('[data-action="open-routine"]').forEach(button => button.addEventListener('click', () => { selectedRoutine = getRoutineContext().id; setView('routine'); }));
  app.querySelectorAll('[data-app]').forEach(button => button.addEventListener('click', () => {
    if (['TikTok','Instagram','YouTube'].includes(button.dataset.app)) openRedirect(button.dataset.app);
    else notify(`${button.dataset.app} is available in this demo.`);
  }));
  app.querySelector('[data-action="try-app"]')?.addEventListener('click', () => openRedirect('TikTok'));
  app.querySelector('[data-action="edit-daily-goals"]')?.addEventListener('click', () => setView('daily-goals'));
  app.querySelectorAll('[data-complete-task]').forEach(button => button.addEventListener('click', () => toggleTask(button.dataset.completeTask)));
  app.querySelectorAll('[data-home-task]').forEach(button => button.addEventListener('click', () => beginTask(button.dataset.goal, button.dataset.homeTask)));
}

function getDailyGoals(dayKey = localDateKey()) { return (state.dailyGoals?.[dayKey] || ['', '', '']).slice(0, 3).concat(['', '', '']).slice(0, 3); }
function renderDailyGoals() {
  const goals = getDailyGoals();
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="back-today">‹ &nbsp; Back to today</button><div class="eyebrow">AIM FOR WHAT MATTERS</div><h1 class="page-title">Set 3 goals for today.</h1><p>Choose three things you’d like to make time for. You can change them any time.</p></div><section class="card daily-goals-editor">${goals.map((goal, i) => `<label class="field-label">Goal ${i + 1}<input class="field" data-daily-goal="${i}" maxlength="120" value="${esc(goal)}" placeholder="Something you want to do today"></label>`).join('')}<div class="actions"><button class="btn btn-primary btn-block" data-action="save-daily-goals">Save today’s goals</button></div></section></section>${nav('today')}`;
  bindGlobal();
  app.querySelector('[data-action="back-today"]')?.addEventListener('click', () => setView('today'));
  app.querySelector('[data-action="save-daily-goals"]')?.addEventListener('click', () => { const values = [...app.querySelectorAll('[data-daily-goal]')].map(input => input.value.trim()); if (values.some(value => !value)) return notify('Add all three goals to continue.'); state.dailyGoals ||= {}; state.dailyGoals[localDateKey()] = values; save(); notify('Today’s goals are saved.'); setView('today'); });
}

function renderRedirect() {
  redirectSuggestions = pickRedirectSuggestions();
  const choices = [
    ['💬','See what my friends are up to'],['🔎','Find something specific'],['☁️','Take a quick break'],['✨','I opened it automatically'],
  ];
  const icon = activeApp === 'Instagram' ? '◎' : activeApp === 'YouTube' ? '▶' : '♪';
  const savedSuggestions = redirectSuggestions.filter(item => item.source === 'saved');
  const popularSuggestions = redirectSuggestions.filter(item => item.source === 'popular');
  const suggestionButton = (item, index) => `<button class="task-option" data-suggested-index="${index}"><span class="task-emoji">${item.icon || category(item.category).icon}</span><span><b>${esc(item.title)}</b><small>${esc(item.detail || `For ${item.goalTitle}`)}</small></span>${item.source === 'saved' ? '<span class="goal-tag">Your plan</span>' : '<span class="goal-tag">Quick idea</span>'}</button>`;
  const suggestionMarkup = `${savedSuggestions.length ? `<div class="category-section"><div class="category-label">FROM YOUR SAVED STEPS</div><div class="task-list">${savedSuggestions.map((item, index) => suggestionButton(item, redirectSuggestions.indexOf(item))).join('')}</div></div>` : ''}<div class="category-section"><div class="category-label">${savedSuggestions.length ? 'TRY SOMETHING DIFFERENT' : 'POPULAR QUICK IDEAS'}</div><div class="task-list">${popularSuggestions.map(item => suggestionButton(item, redirectSuggestions.indexOf(item))).join('')}</div></div>`;
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="back-home">← &nbsp; Back</button><div class="eyebrow">A MOMENT TO CHOOSE</div><h1 class="page-title">${state.mode === 'Gentle' ? `Still want to open ${esc(activeApp)}?` : `${esc(activeApp)} can wait a moment.`}</h1><p>What would feel useful right now? You’re in control.</p></div>
    <div class="app-banner"><span class="app-icon">${icon}</span><div><strong>${esc(activeApp)}</strong><small>Available after your check-in</small></div></div>
    <div class="prompt">What brought you here today?</div><div class="choice-grid">${choices.map(([emoji,label]) => `<button class="choice ${currentReason === label ? 'selected' : ''}" data-reason="${esc(label)}"><span class="emoji">${emoji}</span>${esc(label)}</button>`).join('')}</div>
    <label class="field-label" for="reasonInput">Or put it in your own words</label><textarea class="textarea" id="reasonInput" maxlength="160" placeholder="What did you have in mind when you opened ${esc(activeApp)}?">${esc(currentReason && !choices.some(c => c[1] === currentReason) ? currentReason : '')}</textarea><p class="feedback">A short phrase is enough. This stays on your device.</p>
    <div class="section-title"><h2>Try one of these</h2><button class="link-btn" data-action="refresh-suggestions">Show other ideas</button></div><section class="card goal-editor">${suggestionMarkup}<p class="feedback">Ideas are picked from your saved steps and a rotating list of quick activities.</p></section>
    <div class="actions"><button class="btn btn-primary btn-block" data-action="continue-intent">Continue to app with this intention</button><button class="btn btn-outline btn-block" data-action="choose-task">Choose my own next step</button><button class="text-btn" data-action="continue-anyway">Continue to ${esc(activeApp)} for now</button></div>
    </section>${nav('redirect')}`;
  bindGlobal();
  app.querySelectorAll('[data-reason]').forEach(button => button.addEventListener('click', () => {
    currentReason = button.dataset.reason; app.querySelectorAll('[data-reason]').forEach(b => b.classList.toggle('selected', b === button)); app.querySelector('#reasonInput').value = '';
  }));
  app.querySelector('#reasonInput').addEventListener('input', e => { currentReason = e.target.value.trim(); app.querySelectorAll('[data-reason]').forEach(b => b.classList.toggle('selected', false)); });
  app.querySelector('[data-action="back-home"]').addEventListener('click', () => setView('today'));
  app.querySelectorAll('[data-suggested-index]').forEach(button => button.addEventListener('click', () => {
    currentReason = app.querySelector('#reasonInput').value.trim() || currentReason;
    beginSuggestedTask(redirectSuggestions[Number(button.dataset.suggestedIndex)]);
  }));
  app.querySelector('[data-action="refresh-suggestions"]').addEventListener('click', () => {
    currentReason = app.querySelector('#reasonInput').value.trim() || currentReason;
    renderRedirect();
  });
  app.querySelector('[data-action="continue-intent"]').addEventListener('click', () => {
    currentReason = app.querySelector('#reasonInput').value.trim() || currentReason;
    if (!currentReason) return notify('Choose a reason or write one in your own words.');
    startSession(false);
  });
  app.querySelector('[data-action="choose-task"]').addEventListener('click', () => { currentReason = app.querySelector('#reasonInput').value.trim() || currentReason; activeCategory = CATEGORIES.find(c => state.goals.some(g => g.smallGoals?.some(t => t.category === c.id)))?.id || 'fitness'; setView('choose-task'); });
  app.querySelector('[data-action="continue-anyway"]').addEventListener('click', () => { currentReason = app.querySelector('#reasonInput').value.trim() || currentReason || 'Continue without a specific intention'; startSession(true); });
}

function shuffled(items) { return [...items].sort(() => Math.random() - 0.5); }
function pickRedirectSuggestions() {
  const saved = shuffled(state.goals.flatMap(goal => (goal.smallGoals || [])
    .filter(task => !task.done)
    .map(task => ({ ...task, goalId: goal.id, goalTitle: goal.title, source: 'saved', detail: `For ${goal.title} · ${category(task.category).label}` }))));
  const selectedSaved = saved.slice(0, saved.length ? 1 : 0);
  const selectedIds = new Set(selectedSaved.map(task => task.id));
  const popular = shuffled(POPULAR_REDIRECTIONS.filter(task => !selectedIds.has(task.id)));
  const selectedPopular = popular.slice(0, selectedSaved.length ? 2 : 3).map(task => ({ ...task, source: 'popular' }));
  return [...selectedSaved, ...selectedPopular];
}
function beginSuggestedTask(task) {
  if (!task) return notify('Choose an idea to continue.');
  currentTask = { ...task, suggested: true };
  setView('task');
}

function renderChooseTask() {
  const categories = CATEGORIES.map(item => `<button class="task-tab ${activeCategory === item.id ? 'active' : ''}" data-task-category="${item.id}">${item.icon} ${esc(item.label)}</button>`).join('');
  const matches = state.goals.flatMap(goal => (goal.smallGoals || []).filter(task => task.category === activeCategory).map(task => ({ ...task, goalTitle: goal.title, goalId: goal.id })));
  const options = matches.length ? matches.map(task => `<button class="task-option" data-pick-goal="${task.goalId}" data-pick-task="${task.id}"><span class="task-emoji">${task.icon || category(task.category).icon}</span><span><b>${esc(task.title)}</b><small>For ${esc(task.goalTitle)}</small></span><span class="arr">›</span></button>`).join('') : `<div class="empty-category">You haven’t added a ${esc(category(activeCategory).label.toLowerCase())} step yet. Add one to your plan, and it will show up here next time.</div>`;
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="back-redirect">← &nbsp; Back to check-in</button><div class="eyebrow">YOUR REDIRECTIONS</div><h1 class="page-title">Choose your own<br>next step.</h1><p>These are the small actions you chose during onboarding.</p></div><div class="task-tabs surface-gap">${categories}</div><div class="category-section"><h3>${category(activeCategory).icon} &nbsp;${esc(category(activeCategory).label)}</h3><div class="task-list">${options}</div></div><div class="note"><span class="symbol">🌱</span><span>Small actions count. You can change your plan any time.</span></div><div class="actions"><button class="btn btn-outline btn-block" data-action="edit-plan">Add or change my steps</button></div></section>${nav('redirect')}`;
  bindGlobal();
  app.querySelectorAll('[data-task-category]').forEach(button => button.addEventListener('click', () => { activeCategory = button.dataset.taskCategory; renderChooseTask(); }));
  app.querySelector('[data-action="back-redirect"]').addEventListener('click', () => setView('redirect'));
  app.querySelector('[data-action="edit-plan"]').addEventListener('click', () => setView('plan'));
  app.querySelectorAll('[data-pick-task]').forEach(button => button.addEventListener('click', () => beginTask(button.dataset.pickGoal, button.dataset.pickTask)));
}

function beginTask(goalId, taskId) {
  const goal = state.goals.find(item => item.id === goalId); const task = goal?.smallGoals?.find(item => item.id === taskId);
  if (!goal || !task) return notify('That step is no longer in your plan.');
  currentTask = { ...task, goalId, goalTitle: goal.title }; setView('task');
}
function renderTask() {
  const task = currentTask || { title: 'Take one small step', category: 'selfcare', icon: '🌱' };
  const taskContext = task.goalTitle ? `For your goal: ${esc(task.goalTitle)}` : 'A quick idea for this moment';
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="back-choose">← &nbsp; Back to choices</button><div class="eyebrow">A LITTLE TIME FOR YOU</div><h1 class="page-title">${esc(task.title)}</h1><p>Small steps count. Take the time you need.</p></div><section class="card surface-gap" style="text-align:center;padding:25px 20px"><div style="font-size:38px">${task.icon || category(task.category).icon}</div><h2 style="font-size:17px;letter-spacing:-.04em;margin:10px 0 6px">Your next step is ready</h2><p class="muted" style="font-size:12px">${taskContext}</p></section><div class="actions"><button class="btn btn-primary btn-block" data-action="complete-current">I did this&nbsp; ✓</button><button class="btn btn-outline btn-block" data-action="back-choose">Choose something else</button></div><div class="note"><span class="symbol">🌱</span><span>This time belongs to you. There’s no score and nothing to earn.</span></div></section>${nav('redirect')}`;
  bindGlobal();
  app.querySelectorAll('[data-action="back-choose"]').forEach(button => button.addEventListener('click', () => setView('choose-task')));
  app.querySelector('[data-action="complete-current"]').addEventListener('click', () => {
    const goal = state.goals.find(item => item.id === task.goalId); const savedTask = goal?.smallGoals?.find(item => item.id === task.id);
    if (savedTask) savedTask.done = true;
    state.logs.unshift({ id: uid(), date: new Date().toISOString(), type: 'redirect', task: task.title, category: task.category, reason: currentReason });
    save(); notify('Nice. You made a little room for what matters.'); setView('today');
  });
}

function startSession(override) {
  state.logs.unshift({ id: uid(), date: new Date().toISOString(), type: override ? 'continue' : 'intentional', app: activeApp, reason: currentReason }); save(); currentSessionSeconds = 8 * 60; setView('session');
}
function renderSession() {
  const fmt = sec => `${String(Math.floor(sec / 60)).padStart(2,'0')}:${String(sec % 60).padStart(2,'0')}`;
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="end-session">← &nbsp; Back to WellPhone</button><div class="eyebrow">YOUR INTENTIONAL SESSION</div><h1 class="page-title">A little time for ${esc(activeApp)}.</h1><p>You decided what you came for. Your app stays available.</p></div><div class="app-banner"><span class="app-icon">${esc(activeApp === 'Instagram' ? '◎' : activeApp === 'YouTube' ? '▶' : '♪')}</span><div><small>YOU CAME TO</small><strong>${esc(currentReason)}</strong></div><b id="countdown" style="margin-left:auto;font-variant-numeric:tabular-nums">${fmt(currentSessionSeconds)}</b></div><section class="card surface-gap"><div style="font-size:42px;text-align:center;padding:22px">🌄</div><b style="font-size:13px">Your app is ready</b><p class="muted" style="font-size:12px;margin-top:7px">In the full WellPhone app, this is where your chosen app would open with your intention kept in view.</p></section><div class="prompt">Want a little more time?</div><p class="muted" style="font-size:11px">Add only what you need. Extra time comes in small segments.</p><div class="task-tabs surface-gap">${[2,5,10].map(n => `<button class="task-tab" data-add-time="${n}">+ ${n} min</button>`).join('')}</div><div class="actions"><button class="btn btn-primary btn-block" data-action="end-session">I’m all set</button></div></section>${nav('today')}`;
  bindGlobal();
  app.querySelectorAll('[data-add-time]').forEach(button => button.addEventListener('click', () => { currentSessionSeconds += Number(button.dataset.addTime) * 60; app.querySelector('#countdown').textContent = fmt(currentSessionSeconds); notify(`${button.dataset.addTime} minutes added.`); }));
  app.querySelectorAll('[data-action="end-session"]').forEach(button => button.addEventListener('click', () => setView('today')));
  sessionTimer = setInterval(() => {
    currentSessionSeconds = Math.max(0, currentSessionSeconds - 1);
    const timer = app.querySelector('#countdown'); if (timer) timer.textContent = fmt(currentSessionSeconds);
    if (currentSessionSeconds === 0) { clearInterval(sessionTimer); sessionTimer = null; notify('Your planned time is up. You can wrap up or add a little more.'); }
  }, 1000);
}

function toggleTask(taskId) {
  for (const goal of state.goals) { const task = goal.smallGoals?.find(item => item.id === taskId); if (task) { task.done = !task.done; break; } }
  save(); renderToday();
}

function renderPlan() {
  const goals = state.goals.map(goal => `<article class="card goal-editor" data-goal-card="${goal.id}"><div class="goal-editor-top"><input class="field" data-goal-title="${goal.id}" maxlength="70" value="${esc(goal.title)}" aria-label="Major goal"><button class="remove-btn" data-remove-goal="${goal.id}" aria-label="Remove goal">×</button></div><div class="small-goal-list" style="margin-left:0">${goal.smallGoals.map(task => `<div class="small-goal ${task.done ? 'done' : ''}"><span>${task.icon || category(task.category).icon}</span><span>${esc(task.title)} <small>· ${esc(category(task.category).label)}</small></span><button class="remove-btn" style="margin-left:auto;width:25px;height:25px" data-remove-small="${goal.id}" data-task-id="${task.id}" aria-label="Remove ${esc(task.title)}">×</button></div>`).join('') || '<small class="feedback">No small steps yet. Add a few below.</small>'}</div><div class="category-label">ADD A SMALL STEP</div><div class="goal-editor-top"><select class="select" data-new-category="${goal.id}">${CATEGORIES.map(item => `<option value="${item.id}">${item.icon} ${esc(item.label)}</option>`).join('')}</select><input class="field" data-new-task="${goal.id}" maxlength="70" placeholder="Add a step"><button class="btn btn-soft" data-add-task="${goal.id}">Add</button></div></article>`).join('');
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><button class="back-btn" data-action="back-home">← &nbsp; Today</button><div class="eyebrow">YOUR PLAN</div><h1 class="page-title">Make it yours.</h1><p>Keep the goals and small steps you want WellPhone to suggest.</p></div><div class="section-title"><h2>Major goals</h2></div><div class="goal-stack">${goals || '<div class="empty-state">Add your first goal below.</div>'}</div><section class="card goal-editor"><div class="category-label">ADD A MAJOR GOAL</div><div class="inline-row"><input class="field" id="newMajorGoal" maxlength="70" placeholder="What do you want to work toward?"><button class="btn btn-soft" data-action="add-goal">Add</button></div><label class="field-label" for="planMode">Intervention style</label><select class="select" id="planMode"><option ${state.mode === 'Gentle' ? 'selected' : ''}>Gentle</option><option ${state.mode === 'Structured' ? 'selected' : ''}>Structured</option><option ${state.mode === 'Strict' ? 'selected' : ''}>Strict</option></select><div class="actions"><button class="btn btn-primary btn-block" data-action="save-plan">Save changes</button></div></section><div class="note"><span class="symbol">🌱</span><span>WellPhone supports the goals you choose. You remain in control of every app and every decision.</span></div></section>${nav('today')}`;
  bindGlobal();
  app.querySelector('[data-action="back-home"]').addEventListener('click', () => setView('today'));
  app.querySelector('[data-action="add-goal"]').addEventListener('click', addGoalFromPlan);
  app.querySelector('#newMajorGoal').addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); addGoalFromPlan(); } });
  app.querySelectorAll('[data-remove-goal]').forEach(button => button.addEventListener('click', () => { state.goals = state.goals.filter(goal => goal.id !== button.dataset.removeGoal); save(); renderPlan(); }));
  app.querySelectorAll('[data-goal-title]').forEach(input => input.addEventListener('change', () => { const goal = state.goals.find(g => g.id === input.dataset.goalTitle); if (goal) { goal.title = input.value.trim() || goal.title; save(); } }));
  app.querySelectorAll('[data-add-task]').forEach(button => button.addEventListener('click', () => addTaskToGoal(button.dataset.addTask)));
  app.querySelectorAll('[data-new-task]').forEach(input => input.addEventListener('keydown', e => { if (e.key === 'Enter') { e.preventDefault(); addTaskToGoal(input.dataset.newTask); } }));
  app.querySelectorAll('[data-remove-small]').forEach(button => button.addEventListener('click', () => { const goal = state.goals.find(g => g.id === button.dataset.removeSmall); if (goal) goal.smallGoals = goal.smallGoals.filter(t => t.id !== button.dataset.taskId); save(); renderPlan(); }));
  app.querySelector('[data-action="save-plan"]').addEventListener('click', () => { state.mode = app.querySelector('#planMode').value; save(); notify('Your plan is saved.'); setView('today'); });
}
function addGoalFromPlan() {
  const input = app.querySelector('#newMajorGoal'); const title = input.value.trim(); if (!title) return input.focus();
  state.goals.push({ id: uid(), title, active: true, smallGoals: [] }); save(); renderPlan();
}
function addTaskToGoal(goalId) {
  const input = app.querySelector(`[data-new-task="${CSS.escape(goalId)}"]`); const title = input.value.trim(); if (!title) return input.focus();
  const catId = app.querySelector(`[data-new-category="${CSS.escape(goalId)}"]`).value; const goal = state.goals.find(g => g.id === goalId);
  goal.smallGoals.push({ id: uid(), title, category: catId, icon: category(catId).icon, done: false }); save(); renderPlan();
}

function getRoutineContext(date = new Date()) {
  const hour = date.getHours();
  if (hour >= 4 && hour < 12) return { id: 'morning', headline: 'A routine for your morning', subline: 'A gentle start for today' };
  if (hour >= 17 || hour < 4) return { id: 'winddown', headline: 'A routine for your evening', subline: 'Wind down at your own pace' };
  return { id: 'winddown', headline: 'Your next routine is tonight', subline: 'Wind Down is ready whenever you are' };
}
function getRoutine(id) { return state.routines?.[id] || ROUTINES[id]; }
function routineDate(id, date = new Date()) {
  const adjusted = new Date(date);
  if (id === 'winddown' && adjusted.getHours() < 4) adjusted.setDate(adjusted.getDate() - 1);
  return adjusted;
}
function resolveRoutineStep(step, date = new Date()) {
  if (!step?.rotatesByDay) return step;
  const cleaningTask = DAILY_CLEANING[date.getDay()];
  return { ...step, title: `Clean one area: ${cleaningTask}`, detail: 'The suggested area changes each day. Edit or remove this step any time.' };
}
function localDateKey(date = new Date()) {
  return `${date.getFullYear()}-${String(date.getMonth()+1).padStart(2,'0')}-${String(date.getDate()).padStart(2,'0')}`;
}
function getRoutineProgress(id) {
  const day = localDateKey(routineDate(id));
  const progress = state.routineProgress?.[day]?.[id];
  return progress || { index: 0, completed: [], skipped: [], finished: false };
}
function renderGoalReflection(dayKey) {
  const goals = getDailyGoals(dayKey).filter(Boolean);
  const tomorrowDate = new Date(`${dayKey}T12:00:00`); tomorrowDate.setDate(tomorrowDate.getDate() + 1);
  const tomorrowKey = localDateKey(tomorrowDate);
  const tomorrowGoals = getDailyGoals(tomorrowKey);
  const saved = state.goalReflections?.[dayKey]?.statuses || [];
  currentReflections = Object.fromEntries(goals.map((_, i) => [i, saved[i] || '']));
  const reflection = goals.length ? `<p class="routine-step-detail">Take a moment to notice how today went. Every answer is okay.</p><div class="reflection-list">${goals.map((goal, i) => `<div class="reflection-row"><strong>${esc(goal)}</strong><div class="reflection-options">${[['met','Met'],['in-progress','In progress'],['not-today','Not today']].map(([key,label]) => `<button class="reflection-option ${currentReflections[i] === key ? 'selected' : ''}" data-goal-index="${i}" data-reflection-choice="${key}">${label}</button>`).join('')}</div></div>`).join('')}</div>` : '<p class="routine-step-detail">No goals were saved for today. That’s okay. You can still start planning for tomorrow.</p>';
  return `${reflection}<div class="tomorrow-goals"><div class="eyebrow">OPTIONAL · TOMORROW</div><p class="routine-step-detail">Start adding goals for tomorrow. You can add one, two, or all three now, then finish them in Morning Start.</p><div class="daily-goals-editor">${tomorrowGoals.map((goal, i) => `<label class="field-label">Goal ${i + 1}<input class="field" data-tomorrow-goal="${i}" maxlength="120" value="${esc(goal)}" placeholder="Add a goal for tomorrow"></label>`).join('')}</div></div><div class="actions"><button class="btn btn-primary btn-block" data-action="save-goal-reflection">${goals.length ? 'Save reflection &amp; continue' : 'Save &amp; continue'}</button><button class="text-btn" data-routine-step="skip">Skip this step</button></div>`;
}

function renderRoutine() {
  const context = getRoutineContext();
  selectedRoutine ||= context.id;
  const routine = getRoutine(selectedRoutine) || getRoutine(context.id);
  const progress = getRoutineProgress(selectedRoutine);
  const routineDay = routineDate(selectedRoutine);
  const step = resolveRoutineStep(routine.steps[progress.index], routineDay);
  const doneCount = progress.completed.length;
  const tabs = Object.keys(ROUTINES).map(id => { const item = getRoutine(id); return `<button class="task-tab ${id === selectedRoutine ? 'active' : ''}" data-select-routine="${id}">${item.icon} ${esc(item.title)}${id === context.id ? ' · now' : ''}</button>`; }).join('');
  const progressWidth = Math.round((Math.min(progress.index, routine.steps.length) / routine.steps.length) * 100);
  const progressFinished = progress.finished || progress.index >= routine.steps.length;
  const goalDayKey = localDateKey(routineDay);
  const stepContent = !progressFinished && step?.action === 'setDailyGoals' ? `<p class="routine-step-detail">Choose three things you want to make time for today. You can edit them later.</p><div class="daily-goals-editor routine-goal-editor">${getDailyGoals(goalDayKey).map((goal, i) => `<label class="field-label">Goal ${i + 1}<input class="field" data-routine-goal="${i}" maxlength="120" value="${esc(goal)}" placeholder="Something you want to do today"></label>`).join('')}</div><div class="actions"><button class="btn btn-primary btn-block" data-action="save-routine-goals">Save goals &amp; continue</button><button class="text-btn" data-routine-step="skip">Skip this step</button></div>` : !progressFinished && step?.action === 'reflectDailyGoals' ? renderGoalReflection(goalDayKey) : `<div class="actions"><button class="btn btn-primary btn-block" data-routine-step="complete">Done with this step&nbsp; →</button><button class="text-btn" data-routine-step="skip">Skip this step</button></div>`;
  const stepBody = routineEditing ? `<div class="routine-editor"><div class="routine-editor-note">Add, remove, and rename steps to match your real routine. The daily cleaning suggestion rotates automatically.</div><div class="routine-edit-list">${routineDraft.map((item,index) => `<div class="routine-edit-row"><span>${item.icon || '✓'}</span><input class="field" data-edit-step="${index}" maxlength="100" value="${esc(item.title)}" aria-label="Routine step"><button class="remove-btn" data-remove-routine-step="${index}" aria-label="Remove ${esc(item.title)}">×</button>${item.rotatesByDay ? '<small class="daily-tag">Changes daily</small>' : ''}</div>`).join('')}</div><div class="inline-row routine-add-row"><input id="newRoutineStep" class="field" maxlength="100" placeholder="Add a step"><button class="btn btn-soft" data-action="add-routine-step">Add</button></div><p class="feedback">You can keep the full routine here and skip steps that don’t fit a particular day.</p><div class="actions"><button class="btn btn-primary btn-block" data-action="save-routine">Save routine</button><button class="text-btn" data-action="cancel-routine-edit">Cancel</button></div></div>` : progressFinished ? `<div class="routine-finished"><div class="routine-finished-icon">${routine.icon}</div><h2>You’ve reached the end of this routine.</h2><p>You completed ${doneCount} of ${routine.steps.length} steps. You can leave it here or start fresh another time.</p><button class="btn btn-outline btn-block" data-action="restart-routine">Start again</button></div>` : `<div class="routine-step-count">STEP ${progress.index + 1} OF ${routine.steps.length}</div><div class="routine-progress"><span style="width:${progressWidth}%"></span></div><div class="routine-step-icon">${step.icon}</div><h2 class="routine-step-title">${esc(step.title)}</h2>${step.action === 'setDailyGoals' || step.action === 'reflectDailyGoals' ? '' : `<p class="routine-step-detail">${esc(step.detail)}</p>`}${stepContent}`;
  const localTime = new Date().toLocaleTimeString(undefined,{hour:'numeric',minute:'2-digit'});
  const timingMessage = context.id === 'morning' ? 'It’s morning where you are.' : context.id === 'winddown' && (new Date().getHours() >= 17 || new Date().getHours() < 4) ? 'It’s wind-down time where you are.' : 'It’s daytime. Your evening routine will be here when you need it.';
  const overview = routine.steps.map((item,index) => { const resolved = resolveRoutineStep(item, routineDay); return `<div class="routine-list-step ${index < progress.index ? 'past' : ''} ${progress.completed.includes(index) ? 'complete' : ''}"><span class="routine-list-icon">${progress.completed.includes(index) ? '✓' : resolved.icon}</span><span><b>${esc(resolved.title)}</b><small>${index === progress.index && !progressFinished ? 'Up next' : (progress.skipped.includes(index) ? 'Skipped for now' : `${index + 1} of ${routine.steps.length}`)}</small></span></div>`; }).join('');
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><div class="eyebrow">YOUR DAILY RHYTHM · ${localTime}</div><h1 class="page-title">A routine that<br>fits right now.</h1><p>${esc(timingMessage)} Both routines are on this page, and you can start either one whenever you like.</p></div><div class="task-tabs surface-gap">${tabs}</div><section class="card routine-card"><div class="routine-card-head"><div><div class="eyebrow">${esc(routine.window)}</div><h2>${routine.icon} &nbsp;${esc(routine.title)}</h2></div>${selectedRoutine === context.id ? '<span class="pill">Suggested now</span>' : ''}</div><p class="routine-description">${esc(routine.description)}</p>${stepBody}${!routineEditing ? '<button class="link-btn edit-routine-btn" data-action="edit-routine">Edit this routine</button>' : ''}</section>${!routineEditing ? `<section class="card routine-overview"><div class="eyebrow">THE WHOLE ROUTINE</div><div class="routine-list">${overview}</div></section><div class="note"><span class="symbol">🌱</span><span>These are full everyday tasks, not a timer or a test. Complete or skip steps and adjust the routine to fit your life.</span></div>` : ''}</section>${nav('routine')}`;
  bindGlobal();
  app.querySelectorAll('[data-select-routine]').forEach(button => button.addEventListener('click', () => { selectedRoutine = button.dataset.selectRoutine; routineEditing = false; routineDraft = []; renderRoutine(); }));
  app.querySelector('[data-action="save-routine-goals"]')?.addEventListener('click', () => { const values = [...app.querySelectorAll('[data-routine-goal]')].map(input => input.value.trim()); if (values.some(value => !value)) return notify('Add all three goals to continue.'); state.dailyGoals ||= {}; state.dailyGoals[goalDayKey] = values; save(); advanceRoutineStep(true); });
  app.querySelectorAll('[data-reflection-choice]').forEach(button => button.addEventListener('click', () => { currentReflections[button.dataset.goalIndex] = button.dataset.reflectionChoice; button.parentElement.querySelectorAll('[data-reflection-choice]').forEach(choice => choice.classList.toggle('selected', choice === button)); }));
  app.querySelector('[data-action="save-goal-reflection"]')?.addEventListener('click', () => { const goals = getDailyGoals(goalDayKey).filter(Boolean); if (goals.length && goals.some((_, i) => !currentReflections[i])) return notify('Choose a reflection for each goal.'); if (goals.length) { state.goalReflections ||= {}; state.goalReflections[goalDayKey] = { goals, statuses: goals.map((_, i) => currentReflections[i]) }; } const tomorrow = new Date(`${goalDayKey}T12:00:00`); tomorrow.setDate(tomorrow.getDate() + 1); const tomorrowValues = [...app.querySelectorAll('[data-tomorrow-goal]')].map(input => input.value.trim()).filter(Boolean); state.dailyGoals ||= {}; if (tomorrowValues.length) state.dailyGoals[localDateKey(tomorrow)] = tomorrowValues; else delete state.dailyGoals[localDateKey(tomorrow)]; save(); advanceRoutineStep(true); });
  app.querySelector('[data-routine-step="complete"]')?.addEventListener('click', () => advanceRoutineStep(true));
  app.querySelector('[data-routine-step="skip"]')?.addEventListener('click', () => advanceRoutineStep(false));
  app.querySelector('[data-action="edit-routine"]')?.addEventListener('click', startEditingRoutine);
  app.querySelector('[data-action="add-routine-step"]')?.addEventListener('click', addRoutineDraftStep);
  app.querySelector('#newRoutineStep')?.addEventListener('keydown', event => { if (event.key === 'Enter') { event.preventDefault(); addRoutineDraftStep(); } });
  app.querySelectorAll('[data-edit-step]').forEach(input => input.addEventListener('change', () => {
    const step = routineDraft[Number(input.dataset.editStep)];
    step.title = input.value.trim() || step.title;
    if (step.rotatesByDay) step.rotatesByDay = false;
  }));
  app.querySelectorAll('[data-remove-routine-step]').forEach(button => button.addEventListener('click', () => {
    if (routineDraft.length < 2) return notify('Keep at least one step in the routine.');
    routineDraft.splice(Number(button.dataset.removeRoutineStep), 1); renderRoutine();
  }));
  app.querySelector('[data-action="save-routine"]')?.addEventListener('click', saveRoutineDraft);
  app.querySelector('[data-action="cancel-routine-edit"]')?.addEventListener('click', () => { routineEditing = false; routineDraft = []; renderRoutine(); });
  app.querySelector('[data-action="restart-routine"]')?.addEventListener('click', () => {
    const day = localDateKey(routineDate(selectedRoutine)); if (state.routineProgress?.[day]) delete state.routineProgress[day][selectedRoutine]; save(); renderRoutine();
  });
}
function advanceRoutineStep(completed) {
  const day = localDateKey(routineDate(selectedRoutine)); state.routineProgress ||= {}; state.routineProgress[day] ||= {};
  const progress = state.routineProgress[day][selectedRoutine] ||= { index: 0, completed: [], skipped: [], finished: false };
  if (completed) progress.completed.push(progress.index); else progress.skipped.push(progress.index);
  progress.index += 1;
  if (progress.index >= getRoutine(selectedRoutine).steps.length) {
    progress.index = getRoutine(selectedRoutine).steps.length; progress.finished = true;
    state.logs.unshift({ id: uid(), date: new Date().toISOString(), type: 'routine', routine: getRoutine(selectedRoutine).title, completed: progress.completed.length, skipped: progress.skipped.length });
    notify('Routine finished for now. Nice work making time for yourself.');
  }
  save(); renderRoutine();
}
function startEditingRoutine() {
  routineEditing = true; routineDraft = JSON.parse(JSON.stringify(getRoutine(selectedRoutine).steps)); renderRoutine();
}
function addRoutineDraftStep() {
  const input = app.querySelector('#newRoutineStep'); const title = input.value.trim(); if (!title) return input.focus();
  routineDraft.push({ title, detail: '', icon: '✓' }); renderRoutine();
}
function saveRoutineDraft() {
  const nextSteps = routineDraft.map(step => ({ ...step, title: step.title.trim() })).filter(step => step.title);
  if (!nextSteps.length) return notify('Keep at least one step in the routine.');
  state.routines ||= cloneRoutines();
  state.routines[selectedRoutine] = { ...getRoutine(selectedRoutine), steps: nextSteps };
  const day = localDateKey(routineDate(selectedRoutine)); state.routineProgress ||= {}; state.routineProgress[day] ||= {};
  delete state.routineProgress[day][selectedRoutine];
  state.routineSchemaVersion = ROUTINE_SCHEMA_VERSION;
  save(); routineEditing = false; routineDraft = []; notify('Your routine is updated.'); renderRoutine();
}

function renderInsights() {
  const redirects = state.logs.filter(log => log.type === 'redirect'); const sessions = state.logs.filter(log => log.type === 'intentional' || log.type === 'continue');
  const latest = state.logs.slice(0, 8).map(log => {
    const title = log.type === 'redirect' ? esc(log.task) : log.type === 'routine' ? `Finished ${esc(log.routine)}` : `${esc(log.app)} · ${esc(log.reason)}`;
    const detail = log.type === 'redirect' ? esc(category(log.category).label) : log.type === 'routine' ? `${log.completed} steps completed · ${log.skipped} skipped` : (log.type === 'continue' ? 'Continued with choice' : 'Intentional session');
    const icon = log.type === 'redirect' ? '🌱' : log.type === 'routine' ? '🌙' : '📱';
    return `<div class="insight-line"><i>${icon}</i><div><strong>${title}</strong><small>${new Date(log.date).toLocaleDateString(undefined,{month:'short',day:'numeric'})} · ${detail}</small></div></div>`;
  }).join('');
  const reflections = Object.entries(state.goalReflections || {}).sort(([a],[b]) => b.localeCompare(a)).map(([day, entry]) => {
    const date = new Date(`${day}T12:00:00`).toLocaleDateString(undefined,{month:'short',day:'numeric',year:'numeric'});
    const rows = entry.goals.map((goal, i) => { const status = { met:'Met', 'in-progress':'In progress', 'not-today':'Not today' }[entry.statuses[i]] || 'Reflected'; return `<div class="reflection-insight-row"><span>${esc(goal)}</span><small>${status}</small></div>`; }).join('');
    return `<article class="reflection-insight"><div class="eyebrow">${date}</div>${rows}</article>`;
  }).join('');
  app.innerHTML = `${header()}<section class="screen active"><div class="page-head"><div class="eyebrow">YOUR WEEK, YOUR WAY</div><h1 class="page-title">Attention with intention.</h1><p>A private record of the choices you make in WellPhone.</p></div><div class="category-grid surface-gap"><section class="card"><div class="eyebrow">REDIRECTIONS</div><h2 style="font-size:25px;letter-spacing:-.05em;margin:8px 0 0">${redirects.length}</h2><small class="feedback">small steps you chose</small></section><section class="card"><div class="eyebrow">APP CHECK-INS</div><h2 style="font-size:25px;letter-spacing:-.05em;margin:8px 0 0">${sessions.length}</h2><small class="feedback">intentional or continued</small></section></div><div class="section-title"><h2>Goal reflections</h2></div><section class="card reflection-insights">${reflections || '<div class="empty-state">Your evening goal reflections will show up here.</div>'}</section><div class="section-title"><h2>Recent choices</h2></div><section class="card">${latest || '<div class="empty-state">Your choices will show up here as you use WellPhone.</div>'}</section><div class="note"><span class="symbol">🔒</span><span>This activity is saved on this device. WellPhone does not make a diagnosis or judge your choices.</span></div></section>${nav('insights')}`;
  bindGlobal();
}

app.addEventListener('click', event => {
  const button = event.target.closest('[data-action]'); if (!button || !app.contains(button)) return;
  // Screen-specific handlers are attached during render.
});

function openRedirect(appName) { activeApp = appName; currentReason = ''; setView('redirect'); }

if (state.onboarded && !state.goals.length) { state.onboarded = false; view = 'onboarding'; }
render();

if ('serviceWorker' in navigator && location.protocol.startsWith('http')) {
  window.addEventListener('load', () => navigator.serviceWorker.register('./service-worker.js').catch(() => {}));
}
