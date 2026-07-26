// QualifierManageOS — bulk seed layer.
// Deterministic synthetic roster so the Licenses register carries production-scale
// volume (1,000+ license records). Same field shape as data.js — swap for API calls.
// Generation is seeded, so every reload produces the identical dataset.

const T0 = Date.UTC(2026, 6, 24); // TODAY
const iso = d => new Date(T0 + d * 86400000).toISOString().slice(0, 10);

let _s = 20260724;
const rnd = () => { _s |= 0; _s = _s + 0x6D2B79F5 | 0; let t = Math.imul(_s ^ _s >>> 15, 1 | _s); t = t + Math.imul(t ^ t >>> 7, 61 | t) ^ t; return ((t ^ t >>> 14) >>> 0) / 4294967296; };
const ri = (a, b) => a + Math.floor(rnd() * (b - a + 1));
const pick = arr => arr[Math.floor(rnd() * arr.length)];
const weighted = pairs => { let r = rnd(), acc = 0; for (const [v, w] of pairs) { acc += w; if (r <= acc) return v; } return pairs[pairs.length - 1][0]; };

const STATES = [
  { s: 'FL', src: 'FL DBPR portal',        area: '813', cities: ['Tampa', 'Miami', 'Orlando', 'Jacksonville'], w: 0.17 },
  { s: 'TX', src: 'TDLR lookup',           area: '512', cities: ['Austin', 'Houston', 'Dallas'],               w: 0.14 },
  { s: 'GA', src: 'GA licensing board',    area: '404', cities: ['Atlanta'],                                   w: 0.08 },
  { s: 'NC', src: 'NC State Board',        area: '704', cities: ['Charlotte', 'Raleigh'],                      w: 0.07 },
  { s: 'CA', src: 'CSLB lookup',           area: '619', cities: ['San Diego', 'Sacramento'],                   w: 0.09 },
  { s: 'AZ', src: 'AZ ROC lookup',         area: '602', cities: ['Phoenix'],                                   w: 0.05 },
  { s: 'NV', src: 'NV NSCB lookup',        area: '702', cities: ['Las Vegas'],                                 w: 0.04 },
  { s: 'CO', src: 'CO DORA lookup',        area: '303', cities: ['Denver'],                                    w: 0.04 },
  { s: 'WA', src: 'WA L&I lookup',         area: '206', cities: ['Seattle'],                                   w: 0.04 },
  { s: 'OR', src: 'OR CCB lookup',         area: '503', cities: ['Portland'],                                  w: 0.03 },
  { s: 'IL', src: 'Chicago DOB lookup',    area: '312', cities: ['Chicago'],                                   w: 0.04 },
  { s: 'OH', src: 'OH OCILB lookup',       area: '614', cities: ['Columbus'],                                  w: 0.03 },
  { s: 'MI', src: 'MI LARA lookup',        area: '313', cities: ['Detroit'],                                   w: 0.03 },
  { s: 'TN', src: 'TN Board lookup',       area: '615', cities: ['Nashville'],                                 w: 0.04 },
  { s: 'AL', src: 'AL Licensing Board',    area: '205', cities: ['Birmingham'],                                w: 0.03 },
  { s: 'SC', src: 'SC LLR lookup',         area: '843', cities: ['Charleston'],                                w: 0.03 },
  { s: 'MA', src: 'MA DPL lookup',         area: '617', cities: ['Boston'],                                    w: 0.03 },
  { s: 'NY', src: 'NYC DOB lookup',        area: '718', cities: ['Brooklyn'],                                  w: 0.03 },
  { s: 'OK', src: 'OK CIB lookup',         area: '405', cities: ['Oklahoma City'],                             w: 0.02 },
  { s: 'LA', src: 'LSLBC portal',          area: '504', cities: [],                                            w: 0.01 },
];
const RESIDENT = STATES.filter(x => x.cities.length);
const stMeta = {}; STATES.forEach(x => stMeta[x.s] = x);
const pickState = () => { let r = rnd(), acc = 0; for (const x of RESIDENT) { acc += x.w; if (r <= acc) return x; } return RESIDENT[0]; };

const TZ = { FL: 'ET', GA: 'ET', NC: 'ET', SC: 'ET', MA: 'ET', NY: 'ET', MI: 'ET', OH: 'ET', TX: 'CT', TN: 'CT', AL: 'CT', IL: 'CT', OK: 'CT', LA: 'CT', CO: 'MT', AZ: 'MT', NV: 'PT', CA: 'PT', WA: 'PT', OR: 'PT' };

const TRADES = {
  'General Contracting': ['Certified General Contractor', 'General Contractor — Qualifying Agent', 'Certified Building Contractor', 'Class B — General Building', 'Commercial General Contractor', 'Residential Contractor'],
  'Electrical': ['Master Electrician', 'Electrical Contractor', 'Certified Electrical Contractor', 'Unlimited Electrical Contractor'],
  'Plumbing': ['Master Plumber', 'Plumbing Contractor (P-I)', 'Certified Plumbing Contractor'],
  'HVAC': ['HVAC Contractor — Class A', 'Mechanical Contractor', 'Certified Air Conditioning Contractor'],
  'Roofing': ['Certified Roofing Contractor', 'Roofing Contractor'],
  'Fire Protection': ['Fire Protection Contractor — Class I', 'Fire Sprinkler Contractor'],
  'Solar / PV': ['Solar Contractor', 'Photovoltaic Systems Contractor'],
  'Low Voltage': ['Limited Energy Contractor', 'Low Voltage Systems Contractor'],
};
const TRADE_W = [['General Contracting', 0.40], ['Electrical', 0.16], ['Plumbing', 0.12], ['HVAC', 0.12], ['Roofing', 0.08], ['Fire Protection', 0.05], ['Solar / PV', 0.04], ['Low Voltage', 0.03]];

const pad = (n, w) => String(n).padStart(w, '0');
function licNumber(state, trade) {
  switch (state) {
    case 'FL': return (trade === 'Roofing' ? 'CCC' : trade === 'Electrical' ? 'EC' : trade === 'Plumbing' ? 'CFC' : trade === 'HVAC' ? 'CAC' : 'CGC') + pad(ri(1200000, 1599999), 7);
    case 'GA': return (trade === 'Electrical' ? 'EN' : trade === 'Plumbing' ? 'MP' : 'GCCO') + pad(ri(1000, 9999), 6);
    case 'TX': return trade === 'Electrical' ? 'TECL-' + ri(20000, 79999) : trade === 'HVAC' ? 'TACLA' + pad(ri(1000, 99999), 5) + 'C' : trade === 'Plumbing' ? 'RMP-' + ri(30000, 49999) : 'TX-GC-' + ri(100000, 899999);
    case 'CA': return pad(ri(700000, 1199999), 7);
    case 'AZ': return 'ROC-' + ri(200000, 399999);
    case 'NV': return 'NV-' + pad(ri(10000, 99999), 5) + 'A';
    case 'NC': return (trade === 'Plumbing' ? 'P1-' : trade === 'Electrical' ? 'EL-' : 'NC-') + ri(10000, 89999);
    case 'SC': return 'SC-' + ri(10000, 79999);
    case 'CO': return 'CO-' + ri(20000, 89999);
    case 'WA': return 'WA' + pad(ri(100000, 999999), 6);
    case 'OR': return 'CCB-' + ri(100000, 299999);
    case 'IL': return 'IL-' + ri(100, 999) + '-' + ri(10000, 99999);
    case 'OH': return 'OH-' + ri(20000, 59999);
    case 'MI': return 'MI-' + ri(2100000000, 2199999999);
    case 'TN': return 'TN-' + ri(20000, 89999);
    case 'AL': return 'AL-' + ri(10000, 69999);
    case 'MA': return 'CS-' + ri(80000, 129999);
    case 'NY': return 'NYC-' + ri(600000, 899999);
    case 'OK': return 'OK-' + ri(50000, 99999);
    default: return 'LA-' + ri(30000, 79999) + '-M';
  }
}

const HEALTH_W = [
  ['Verified Current', 0.615], ['Renewal Window', 0.125], ['Expiring Soon', 0.075],
  ['Expired', 0.048], ['Missing Verification', 0.072], ['Human Review Required', 0.038], ['Do Not Place Pending Review', 0.027],
];

const RESTRICT = {
  'Human Review Required': ['Reciprocity application pending — await board approval', 'Renewal filed, board confirmation outstanding', 'Name-change filing under board review', 'Continuing-education audit in progress'],
  'Do Not Place Pending Review': ['Board complaint open — do not place until closed', 'Disciplinary matter pending — reinstatement required', 'Bond lapse reported by board — hold all placements', 'Consent order in effect — legal review required'],
  'Expired': ['Lapsed beyond grace period — reinstatement required', 'Renewal not filed — reapplication may be required', null],
};

function licenseFor(qid, state, trade, seq) {
  const health = weighted(HEALTH_W);
  const meta = stMeta[state];
  let expD, verD, status, usable = true, restrictions = null;
  const term = pick([365 * 2, 365 * 2, 365 * 3, 365 * 4]);
  switch (health) {
    case 'Verified Current': expD = ri(150, 900); verD = -ri(2, 140); status = 'Active'; break;
    case 'Renewal Window':   expD = ri(61, 149);  verD = -ri(2, 100); status = 'Renewal Window'; break;
    case 'Expiring Soon':    expD = ri(2, 60);    verD = -ri(1, 70);  status = 'Expiring Soon'; break;
    case 'Expired':          expD = -ri(3, 340);  verD = -ri(1, 150); status = 'Expired'; usable = false; restrictions = pick(RESTRICT['Expired']); break;
    case 'Missing Verification': expD = ri(120, 800); verD = rnd() < 0.25 ? null : -ri(300, 640); status = 'Active'; usable = false; break;
    case 'Human Review Required': expD = rnd() < 0.5 ? null : ri(30, 500); verD = null; status = 'Pending'; usable = false; restrictions = pick(RESTRICT['Human Review Required']); break;
    default:                 expD = ri(-120, 400); verD = -ri(5, 200); status = rnd() < 0.5 ? 'Suspended' : 'Active'; usable = false; restrictions = pick(RESTRICT['Do Not Place Pending Review']);
  }
  return {
    id: 'L-' + (2000 + seq), qualifierId: qid, state,
    licenseNumber: licNumber(state, trade), licenseType: pick(TRADES[trade]), tradeClassification: trade,
    licenseStatus: status,
    issueDate: iso((expD == null ? ri(-1400, -300) : expD - term)),
    expirationDate: expD == null ? null : iso(expD),
    lastVerifiedDate: verD == null ? null : iso(verD),
    verificationSource: verD == null && health === 'Human Review Required' ? meta.src.replace('lookup', 'application').replace('portal', 'application') : meta.src,
    restrictions, canBeUsedForPlacement: usable, licenseHealthStatus: health,
  };
}

const FIRST = ['James', 'Maria', 'Robert', 'Linda', 'Michael', 'Patricia', 'Angela', 'Kevin', 'Tanya', 'Hector', 'Priya', 'Samuel', 'Grace', 'Omar', 'Nicole', 'Wesley', 'Dana', 'Curtis', 'Yolanda', 'Trevor', 'Imani', 'Bryan', 'Rosa', 'Gerald', 'Sofia', 'Dustin', 'Leah', 'Andre', 'Camille', 'Nathan', 'Beatriz', 'Vincent', 'Hannah', 'Darius', 'Lucia', 'Preston', 'Renee', 'Malik', 'Julia', 'Craig', 'Simone', 'Otto', 'Marisol', 'Colin', 'Deshawn', 'Erika', 'Franklin', 'Naomi', 'Reuben', 'Whitney', 'Alton', 'Jasmine', 'Cody', 'Marcia', 'Ivan', 'Tessa', 'Roland', 'Bianca', 'Grant', 'Selena'];
const LAST = ['Whitaker', 'Barrera', 'Coleman', 'Nakamura', 'Okonkwo', 'Fitzgerald', 'Alvarez', 'Petrov', 'Sandoval', 'Brennan', 'Kaur', 'Holloway', 'Osei', 'Vandermeer', 'Castillo', 'Thurman', 'Nguyen', 'Sorensen', 'Ferrante', 'Boyd', 'Machado', 'Kirkland', 'Duarte', 'Ashford', 'Lindgren', 'Batista', 'Whitfield', 'Cardenas', 'Mbeki', 'Rourke', 'Salinas', 'Underwood', 'Delacroix', 'Hutchins', 'Espinoza', 'Yamada', 'Callahan', 'Rivas', 'Steinberg', 'Adeyemi', 'Marchetti', 'Prescott', 'Guzman', 'Vaughan', 'Ortega', 'Lockhart', 'Bhatt', 'Cisneros', 'Redmond', 'Tavares', 'Kowalski', 'Mendez', 'Ashworth', 'Pham', 'Grimaldi', 'Sutherland', 'Nunez', 'Faulkner', 'Ibarra', 'Winslow'];
const OWNERS = ['Carmen Delgado', 'Rose Martinez', 'Dana Whitfield', 'Marcus Lee', 'Nina Cole', 'Leo Park'];
const DOMAINS = ['qmail.com', 'buildmail.com', 'tradeinbox.com', 'proqual.net'];

const QSTATUS_W = [['Active', 0.55], ['Verified', 0.18], ['Under Review', 0.07], ['Paused', 0.05], ['Documents Requested', 0.05], ['New', 0.04], ['Intake Started', 0.03], ['Inactive', 0.02], ['Do Not Place Pending Review', 0.01]];
const AV_W = [['Available Now', 0.30], ['Limited Availability', 0.24], ['Available Soon', 0.18], ['Not Available', 0.19], ['Paused', 0.09]];
const HRANK = { 'Do Not Place Pending Review': 0, 'Expired': 1, 'Human Review Required': 2, 'Missing Verification': 3, 'Expiring Soon': 4, 'Renewal Window': 5, 'Verified Current': 6 };

export const QUALIFIERS_BULK = [];
export const LICENSES_BULK = [];
export const AVAILABILITY_BULK = [];
export const DOCUMENTS_BULK = [];

let lSeq = 0, dSeq = 0;
for (let i = 0; i < 320 && LICENSES_BULK.length < 1010; i++) {
  const qid = 'Q-' + (100 + i);
  const home = pickState();
  const city = pick(home.cities);
  const first = FIRST[(i * 7 + 3) % FIRST.length], last = LAST[(i * 13 + 5) % LAST.length];
  const name = first + ' ' + last;

  // license portfolio — most qualifiers are multi-state; a few carry deep 8–12 state books
  const nLic = weighted([[1, 0.10], [2, 0.14], [3, 0.16], [4, 0.15], [5, 0.13], [6, 0.11], [7, 0.08], [8, 0.06], [9, 0.03], [11, 0.03], [13, 0.01]]);
  const primaryTrade = weighted(TRADE_W);
  const seen = new Set();
  const mine = [];
  for (let k = 0; k < nLic; k++) {
    const st = k === 0 ? home.s : (rnd() < 0.2 ? home.s : pick(STATES).s);
    const trade = k === 0 || rnd() < 0.7 ? primaryTrade : weighted(TRADE_W);
    const key = st + '|' + trade;
    if (seen.has(key)) continue;
    seen.add(key);
    mine.push(licenseFor(qid, st, trade, ++lSeq));
  }
  if (!mine.length) mine.push(licenseFor(qid, home.s, primaryTrade, ++lSeq));
  LICENSES_BULK.push(...mine);

  const worst = mine.map(l => l.licenseHealthStatus).sort((a, b) => HRANK[a] - HRANK[b])[0];
  const usable = mine.filter(l => l.canBeUsedForPlacement).length;
  const dnp = worst === 'Do Not Place Pending Review';
  let status = dnp ? 'Do Not Place Pending Review' : weighted(QSTATUS_W);
  if (status === 'Do Not Place Pending Review' && !dnp) status = 'Under Review';
  const verif = status === 'Do Not Place Pending Review' ? 'Human Review Required'
    : ['Active', 'Verified', 'Paused', 'Inactive'].includes(status) ? 'Verified'
    : status === 'Under Review' ? (rnd() < 0.5 ? 'In Progress' : 'Needs More Info')
    : status === 'Documents Requested' ? 'In Progress'
    : status === 'New' ? 'Not Started' : 'In Progress';
  const cleared = verif === 'Verified';
  const bg = cleared ? 'Clear' : status === 'Do Not Place Pending Review' ? 'Review Required' : pick(['Pending', 'Clear']);
  const cr = cleared ? (rnd() < 0.12 ? 'Review Required' : 'Clear') : pick(['Pending', 'Clear']);
  const lastRev = -ri(4, 200), nextRev = lastRev + 183;

  // readiness — derived from the same signals staff see on the record
  const vPts = cleared ? (bg === 'Clear' && cr === 'Clear' ? 30 : 24) : verif === 'In Progress' ? 15 : verif === 'Human Review Required' ? 6 : 10;
  const hPts = { 'Verified Current': 25, 'Renewal Window': 21, 'Expiring Soon': 16, 'Missing Verification': 11, 'Human Review Required': 8, 'Expired': 4, 'Do Not Place Pending Review': 0 }[worst];
  const docFlag = rnd();
  const dPts = docFlag < 0.62 ? ri(17, 20) : docFlag < 0.86 ? ri(10, 16) : ri(3, 9);
  const av = weighted(AV_W);
  const maxP = ri(1, 3), curP = Math.min(maxP, av === 'Not Available' ? maxP : av === 'Limited Availability' ? Math.max(1, maxP - 1) : 0);
  const aPts = { 'Available Now': 15, 'Available Soon': 12, 'Limited Availability': 10, 'Paused': 5, 'Not Available': 4 }[av];
  const rPts = ri(6, 10);
  const score = vPts + hPts + dPts + aPts + rPts;
  const tone = (p, hi, mid) => p >= hi ? 'ok' : p >= mid ? 'warn' : 'bad';

  QUALIFIERS_BULK.push({
    id: qid, fullName: name, preferredName: first, email: first[0].toLowerCase() + '.' + last.toLowerCase() + '@' + DOMAINS[i % DOMAINS.length],
    phone: '(' + home.area + ') 555-' + pad(1000 + i * 3, 4), city, stateOfResidence: home.s, timezone: TZ[home.s],
    status, verificationStatus: verif, backgroundCheckStatus: bg, creditCheckStatus: cr,
    availableForPlacement: ['Available Now', 'Available Soon', 'Limited Availability'].includes(av) && cleared && !dnp,
    preferredPlacementTypes: rnd() < 0.5 ? ['License Qualifier'] : pick([['License Qualifier', 'Expansion Support'], ['License Qualifier', 'Replacement'], ['License Qualifier', 'Compliance Oversight'], ['Replacement', 'Backup / Contingency']]),
    minimumMonthlyCompensation: ri(24, 62) * 100, openToNegotiation: rnd() < 0.62,
    internalOwner: OWNERS[i % OWNERS.length], lastReviewedDate: iso(lastRev), nextReviewDue: iso(nextRev),
    adminOnlyNotes: [
      mine.length + '-state book (' + [...new Set(mine.map(l => l.state))].join('/') + ').',
      usable === mine.length ? 'All licenses usable for placement.' : (mine.length - usable) + ' license' + (mine.length - usable === 1 ? '' : 's') + ' blocked — ' + worst.toLowerCase() + '.',
      dnp ? 'DO NOT PLACE until the board matter closes.' : cleared ? 'Screening clear; safe to surface to sales.' : 'Hold from sales until verification completes.',
    ].join(' '),
    readiness: {
      score, parts: [
        { k: 'Verification', pts: vPts + '/30', tone: tone(vPts, 28, 14), note: cleared ? 'Verified ' + iso(lastRev) + ' · checks ' + bg.toLowerCase() : verif + ' · ' + bg.toLowerCase() },
        { k: 'License health', pts: hPts + '/25', tone: tone(hPts, 21, 11), note: worst + ' · ' + usable + ' of ' + mine.length + ' usable' },
        { k: 'Documents', pts: dPts + '/20', tone: tone(dPts, 17, 10), note: dPts >= 17 ? 'All approved' : dPts >= 10 ? 'One item pending' : 'Multiple items outstanding' },
        { k: 'Availability', pts: aPts + '/15', tone: tone(aPts, 12, 8), note: av + ' · ' + curP + ' of ' + maxP + ' slots used' },
        { k: 'Review record', pts: rPts + '/10', tone: tone(rPts, 9, 7), note: rPts >= 9 ? 'Strong placement reviews' : 'Limited review history' },
      ],
    },
  });

  AVAILABILITY_BULK.push({
    id: 'A-' + (100 + i), qualifierId: qid, availabilityStatus: av,
    availableStartDate: av === 'Available Soon' ? iso(ri(14, 90)) : null, availableEndDate: null,
    preferredStates: [...new Set(mine.map(l => l.state))].slice(0, 3),
    preferredTrades: [...new Set(mine.map(l => l.tradeClassification))].slice(0, 2),
    maxActivePlacements: maxP, currentPlacementCount: curP,
    remoteOk: rnd() < 0.7, inPersonRequired: rnd() < 0.25,
    notes: av === 'Available Now' ? 'Open for ' + primaryTrade.toLowerCase() + ' work in ' + home.s + '.' : av === 'Available Soon' ? 'Frees up after current engagement.' : av === 'Paused' ? 'Paused at qualifier request.' : 'At or near capacity.',
  });

  // documents only where the record actually needs staff action
  mine.filter(l => ['Missing Verification', 'Human Review Required', 'Do Not Place Pending Review', 'Expired'].includes(l.licenseHealthStatus)).forEach(l => {
    const ds = l.licenseHealthStatus === 'Expired' ? 'Needs Update' : l.licenseHealthStatus === 'Human Review Required' ? 'In Review' : 'Requested';
    DOCUMENTS_BULK.push({
      id: 'D-' + (600 + dSeq++), qualifierId: qid, relatedLicenseId: l.id, documentType: 'License Copy',
      documentStatus: ds,
      expirationDate: l.expirationDate, fileLink: ds === 'Requested' ? null : 'vault://doc/D-' + (599 + dSeq),
      internalNotes: l.state + ' ' + l.licenseNumber + ' — ' + (l.restrictions || 'copy on file is stale; re-pull from ' + stMeta[l.state].src) + '.',
    });
  });
  if (dPts < 10) DOCUMENTS_BULK.push({ id: 'D-' + (600 + dSeq++), qualifierId: qid, relatedLicenseId: null, documentType: pick(['Insurance', 'Experience Proof', 'ID', 'Resume']), documentStatus: pick(['Requested', 'Needs Update']), expirationDate: rnd() < 0.5 ? iso(ri(-40, 300)) : null, fileLink: null, internalNotes: 'Outstanding at intake — blocks readiness.' });
}
