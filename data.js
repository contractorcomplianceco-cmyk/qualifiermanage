// QualifierManageOS — canonical seed layer.
// Composes the reviewed Phase-1 base seed (data.base.js) with the procedurally
// generated bulk roster (data.bulk.js) so the Coverage Map density, gap dots,
// gamification streaks and staff leaderboard read realistically at
// production-scale volume. Same 1:1 Postgres/Supabase shape. Screening = STATUS ONLY.
//
// NOTE: data.bulk.js exports arrays that start empty ([]) but are populated at
// module load by a deterministic seeded loop. If you're reading the top of
// data.bulk.js and think it's a stub, keep scrolling — the arrays fill in.
import * as base from './data.base.js';
import * as bulk from './data.bulk.js';

export const TODAY = base.TODAY;

// Two more coordinators/fulfillment so the staff leaderboard has range.
const moreStaff = [
  { name: 'Nina Cole',  role: 'Placement Coordinator' },
  { name: 'Leo Park',   role: 'Fulfillment' },
];
export const STAFF = [...base.STAFF, ...moreStaff];

// ----- geo: city -> [lng, lat] (real coordinates, used by the Coverage Map) -----
export const CITIES = {
  'Tampa':[-82.4572,27.9506],'Austin':[-97.7431,30.2672],'Atlanta':[-84.388,33.749],
  'Charlotte':[-80.8431,35.2271],'Miami':[-80.1918,25.7617],'Houston':[-95.3698,29.7604],
  'Orlando':[-81.3792,28.5383],'San Diego':[-117.1611,32.7157],'Raleigh':[-78.6382,35.7796],
  'Brooklyn':[-73.9442,40.6782],'Phoenix':[-112.074,33.4484],'Denver':[-104.9903,39.7392],
  'Seattle':[-122.3321,47.6062],'Chicago':[-87.6298,41.8781],'Nashville':[-86.7816,36.1627],
  'Columbus':[-82.9988,39.9612],'Las Vegas':[-115.1398,36.1699],'Portland':[-122.6765,45.5231],
  'Dallas':[-96.797,32.7767],'Jacksonville':[-81.6557,30.3322],'Sacramento':[-121.4944,38.5816],
  'Boston':[-71.0589,42.3601],'Charleston':[-79.9311,32.7765],'Birmingham':[-86.8025,33.5186],
  'Detroit':[-83.0458,42.3314],'Oklahoma City':[-97.5164,35.4676],
};

// ----- additional qualifiers (Q-011..Q-022) -----
const rp = (k, pts, tone, note) => ({ k, pts, tone, note });
const moreQ = [
  { id:'Q-011', fullName:'Diego Morales', preferredName:'Diego', email:'d.morales@qmail.com', phone:'(602) 555-0110', city:'Phoenix', stateOfResidence:'AZ', timezone:'MT',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support'], minimumMonthlyCompensation:4300, openToNegotiation:true,
    internalOwner:'Carmen Delgado', lastReviewedDate:'2026-07-08', nextReviewDue:'2027-01-08',
    adminOnlyNotes:'Reliable AZ GC, strong on Grand Canyon Dev. Approved for one added AZ/NV engagement.',
    readiness:{ score:86, parts:[ rp('Verification','30/30','ok','Verified 7/8 · checks clear'), rp('License health','22/25','ok','AZ ROC current'), rp('Documents','18/20','ok','Current'), rp('Availability','9/15','warn','1 of 2 slots open'), rp('Review record','7/10','ok','Solid first cycle') ] } },
  { id:'Q-012', fullName:'Hannah Kim', preferredName:'Hannah', email:'h.kim@qmail.com', phone:'(303) 555-0121', city:'Denver', stateOfResidence:'CO', timezone:'MT',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:4000, openToNegotiation:true,
    internalOwner:'Nina Cole', lastReviewedDate:'2026-07-11', nextReviewDue:'2027-01-11',
    adminOnlyNotes:'Master electrician, CO. Fast responder. Open to a first CO/UT engagement.',
    readiness:{ score:82, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','20/25','ok','CO master current'), rp('Documents','16/20','ok','Current'), rp('Availability','11/15','ok','Available now · CO'), rp('Review record','5/10','warn','No placements yet') ] } },
  { id:'Q-013', fullName:'Wesley Boone', preferredName:'Wes', email:'w.boone@qmail.com', phone:'(206) 555-0132', city:'Seattle', stateOfResidence:'WA', timezone:'PT',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:4800, openToNegotiation:false,
    internalOwner:'Leo Park', lastReviewedDate:'2026-06-22', nextReviewDue:'2026-12-22',
    adminOnlyNotes:'At capacity on Emerald City Build. Premium WA GC — protect the relationship.',
    readiness:{ score:79, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','20/25','ok','WA GC current'), rp('Documents','17/20','ok','Current'), rp('Availability','4/15','bad','At capacity (1/1)'), rp('Review record','8/10','ok','Strong reviews') ] } },
  { id:'Q-014', fullName:'Farah Nasser', preferredName:'Farah', email:'f.nasser@qmail.com', phone:'(312) 555-0143', city:'Chicago', stateOfResidence:'IL', timezone:'CT',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support','Replacement'], minimumMonthlyCompensation:4100, openToNegotiation:true,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-14', nextReviewDue:'2027-01-14',
    adminOnlyNotes:'Excellent HVAC qualifier, IL + IN. Model communicator — 6-cycle perfect reliability streak.',
    readiness:{ score:88, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','23/25','ok','IL current · IN renewal window'), rp('Documents','19/20','ok','All approved'), rp('Availability','6/15','warn','P-408 ending 8/25'), rp('Review record','10/10','ok','5/5 across the board') ] } },
  { id:'Q-015', fullName:'Cole Jennings', preferredName:'Cole', email:'c.jennings@qmail.com', phone:'(615) 555-0154', city:'Nashville', stateOfResidence:'TN', timezone:'CT',
    status:'Under Review', verificationStatus:'In Progress', backgroundCheckStatus:'Pending', creditCheckStatus:'Pending',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:3400, openToNegotiation:true,
    internalOwner:'Dana Whitfield', lastReviewedDate:'2026-07-12', nextReviewDue:'2026-08-12',
    adminOnlyNotes:'Intake solid. TN GC license needs verification; checks in flight. Hold from sales until Verified.',
    readiness:{ score:54, parts:[ rp('Verification','14/30','warn','In progress · checks pending'), rp('License health','12/25','warn','TN GC unverified'), rp('Documents','10/20','warn','License copy in review'), rp('Availability','8/15','warn','Hold until verified'), rp('Review record','10/10','ok','References strong') ] } },
  { id:'Q-016', fullName:'Maria Santos', preferredName:'Maria', email:'m.santos@qmail.com', phone:'(614) 555-0165', city:'Columbus', stateOfResidence:'OH', timezone:'ET',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Compliance Oversight'], minimumMonthlyCompensation:3700, openToNegotiation:true,
    internalOwner:'Nina Cole', lastReviewedDate:'2026-07-09', nextReviewDue:'2027-01-09',
    adminOnlyNotes:'OH plumbing qualifier, dependable. Available for one OH/KY engagement.',
    readiness:{ score:81, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','21/25','ok','OH plumbing current'), rp('Documents','16/20','ok','Current'), rp('Availability','9/15','warn','Available now'), rp('Review record','5/10','warn','Intake refs only') ] } },
  { id:'Q-017', fullName:'Trent Alvarez', preferredName:'Trent', email:'t.alvarez@qmail.com', phone:'(702) 555-0176', city:'Las Vegas', stateOfResidence:'NV', timezone:'PT',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support'], minimumMonthlyCompensation:4600, openToNegotiation:true,
    internalOwner:'Carmen Delgado', lastReviewedDate:'2026-07-16', nextReviewDue:'2027-01-16',
    adminOnlyNotes:'Premium NV + UT GC, RMO experience. Available now — first call for NV growth.',
    readiness:{ score:90, parts:[ rp('Verification','30/30','ok','Verified 7/16 · checks clear'), rp('License health','24/25','ok','NV + UT verified current'), rp('Documents','19/20','ok','Current'), rp('Availability','9/15','ok','Available now · NV/UT'), rp('Review record','8/10','ok','Strong RMO refs') ] } },
  { id:'Q-018', fullName:'Bianca Rossi', preferredName:'Bianca', email:'b.rossi@qmail.com', phone:'(503) 555-0187', city:'Portland', stateOfResidence:'OR', timezone:'PT',
    status:'Paused', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:4400, openToNegotiation:false,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-17', nextReviewDue:'2026-08-17',
    adminOnlyNotes:'Paused for a planned sabbatical through ~9/1. Strong OR GC — keep warm, resume search early.',
    readiness:{ score:63, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','21/25','ok','OR GC current'), rp('Documents','15/20','ok','Current'), rp('Availability','0/15','bad','Paused — sabbatical'), rp('Review record','9/10','ok','Professional') ] } },
  { id:'Q-019', fullName:'Grant Feldman', preferredName:'Grant', email:'g.feldman@qmail.com', phone:'(469) 555-0198', city:'Dallas', stateOfResidence:'TX', timezone:'CT',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Backup / On-Deck'], minimumMonthlyCompensation:3900, openToNegotiation:true,
    internalOwner:'Marcus Lee', lastReviewedDate:'2026-07-06', nextReviewDue:'2027-01-06',
    adminOnlyNotes:'TX electrical, Dallas. Good backup candidate for Lonestar Mechanical region.',
    readiness:{ score:85, parts:[ rp('Verification','30/30','ok','Verified · checks clear'), rp('License health','22/25','ok','TX electrical current'), rp('Documents','17/20','ok','Current'), rp('Availability','8/15','ok','Available now'), rp('Review record','8/10','ok','Reliable') ] } },
  { id:'Q-020', fullName:'Simone Clarke', preferredName:'Simone', email:'s.clarke@qmail.com', phone:'(904) 555-0209', city:'Jacksonville', stateOfResidence:'FL', timezone:'ET',
    status:'Intake Started', verificationStatus:'Not Started', backgroundCheckStatus:'Not Started', creditCheckStatus:'Not Started',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:3000, openToNegotiation:true,
    internalOwner:'Leo Park', lastReviewedDate:null, nextReviewDue:'2026-08-08',
    adminOnlyNotes:'New FL roofing referral. ID + license verification outstanding before she can advance.',
    readiness:{ score:33, parts:[ rp('Verification','0/30','bad','Not started'), rp('License health','10/25','warn','FL roofing self-reported'), rp('Documents','6/20','bad','ID outstanding'), rp('Availability','8/15','warn','Target-ready if verified'), rp('Review record','9/10','ok','Referral') ] } },
  { id:'Q-021', fullName:'Aaron Whitfield', preferredName:'Aaron', email:'a.whitfield@qmail.com', phone:'(617) 555-0210', city:'Boston', stateOfResidence:'MA', timezone:'ET',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Replacement'], minimumMonthlyCompensation:5200, openToNegotiation:false,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-19', nextReviewDue:'2027-01-19',
    adminOnlyNotes:'Premium MA GC. Best fit for Bay State Interiors (N-212). Firm on $5,200 floor.',
    readiness:{ score:91, parts:[ rp('Verification','30/30','ok','Verified 7/19 · checks clear'), rp('License health','24/25','ok','MA GC verified current'), rp('Documents','18/20','ok','Current'), rp('Availability','11/15','ok','Available now · MA'), rp('Review record','8/10','ok','Strong references') ] } },
  { id:'Q-022', fullName:'Lena Petrov', preferredName:'Lena', email:'l.petrov@qmail.com', phone:'(843) 555-0221', city:'Charleston', stateOfResidence:'SC', timezone:'ET',
    status:'Do Not Place Pending Review', verificationStatus:'Human Review Required', backgroundCheckStatus:'Clear', creditCheckStatus:'Review Required',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:3500, openToNegotiation:true,
    internalOwner:'Dana Whitfield', lastReviewedDate:'2026-07-15', nextReviewDue:'2026-07-30',
    adminOnlyNotes:'SC GC license lapsed with an open board matter. DO NOT PLACE until reinstatement + Dana closes review. Cooperative — keep relationship warm.',
    readiness:{ score:22, parts:[ rp('Verification','6/30','bad','Human review required'), rp('License health','0/25','bad','SC GC lapsed · board matter'), rp('Documents','8/20','bad','License copy expired'), rp('Availability','0/15','bad','Do-not-place hold'), rp('Review record','8/10','ok','No performance concerns') ] } },
];
export const QUALIFIERS = [...base.QUALIFIERS, ...moreQ, ...bulk.QUALIFIERS_BULK];

// ----- additional licenses -----
const moreL = [
  { id:'L-116', qualifierId:'Q-011', state:'AZ', licenseNumber:'ROC-334120', licenseType:'Dual Building (KB-2)', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2020-05-04', expirationDate:'2027-05-04', lastVerifiedDate:'2026-07-08', verificationSource:'AZ ROC lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-117', qualifierId:'Q-012', state:'CO', licenseNumber:'CO-ME-70112', licenseType:'Master Electrician', tradeClassification:'Electrical', licenseStatus:'Active', issueDate:'2019-09-12', expirationDate:'2027-09-12', lastVerifiedDate:'2026-07-11', verificationSource:'CO DORA lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-118', qualifierId:'Q-013', state:'WA', licenseNumber:'WA-GC-882014', licenseType:'General Contractor', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2017-02-20', expirationDate:'2027-02-20', lastVerifiedDate:'2026-06-22', verificationSource:'WA L&I lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-119', qualifierId:'Q-014', state:'IL', licenseNumber:'IL-HVAC-4471', licenseType:'HVAC Contractor', tradeClassification:'HVAC', licenseStatus:'Active', issueDate:'2018-06-01', expirationDate:'2027-06-01', lastVerifiedDate:'2026-07-14', verificationSource:'IL IDFPR lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-120', qualifierId:'Q-014', state:'IN', licenseNumber:'IN-MECH-2231', licenseType:'Mechanical Contractor', tradeClassification:'HVAC', licenseStatus:'Renewal Window', issueDate:'2022-10-01', expirationDate:'2026-10-01', lastVerifiedDate:'2026-06-30', verificationSource:'IN PLA lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Renewal Window' },
  { id:'L-121', qualifierId:'Q-015', state:'TN', licenseNumber:'TN-GC-55190', licenseType:'General Contractor', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2021-04-18', expirationDate:'2027-04-18', lastVerifiedDate:null, verificationSource:'Self-reported — not yet verified', restrictions:null, canBeUsedForPlacement:false, licenseHealthStatus:'Missing Verification' },
  { id:'L-122', qualifierId:'Q-016', state:'OH', licenseNumber:'OH-PL-33108', licenseType:'Plumbing Contractor', tradeClassification:'Plumbing', licenseStatus:'Active', issueDate:'2019-03-30', expirationDate:'2027-03-30', lastVerifiedDate:'2026-07-09', verificationSource:'OH Construction Board', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-123', qualifierId:'Q-017', state:'NV', licenseNumber:'NV-GC-0079451', licenseType:'General Building (B-2)', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2016-11-14', expirationDate:'2028-11-14', lastVerifiedDate:'2026-07-16', verificationSource:'NV NSCB lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-124', qualifierId:'Q-017', state:'UT', licenseNumber:'UT-B100-6621', licenseType:'General Building (B100)', tradeClassification:'General Contracting', licenseStatus:'Renewal Window', issueDate:'2023-11-01', expirationDate:'2026-11-01', lastVerifiedDate:'2026-06-20', verificationSource:'UT DOPL lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Renewal Window' },
  { id:'L-125', qualifierId:'Q-018', state:'OR', licenseNumber:'OR-CCB-221904', licenseType:'General Contractor (CCB)', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2018-08-08', expirationDate:'2027-08-08', lastVerifiedDate:'2026-07-17', verificationSource:'OR CCB lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-126', qualifierId:'Q-019', state:'TX', licenseNumber:'TECL-51228', licenseType:'Master Electrician', tradeClassification:'Electrical', licenseStatus:'Active', issueDate:'2019-05-15', expirationDate:'2027-05-15', lastVerifiedDate:'2026-07-06', verificationSource:'TDLR lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-127', qualifierId:'Q-020', state:'FL', licenseNumber:'CCC1335540', licenseType:'Certified Roofing Contractor', tradeClassification:'Roofing', licenseStatus:'Unknown', issueDate:'2022-02-10', expirationDate:'2027-02-10', lastVerifiedDate:null, verificationSource:'Self-reported — not yet verified', restrictions:null, canBeUsedForPlacement:false, licenseHealthStatus:'Human Review Required' },
  { id:'L-128', qualifierId:'Q-021', state:'MA', licenseNumber:'MA-CSL-108812', licenseType:'Construction Supervisor (CSL)', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2015-07-22', expirationDate:'2028-07-22', lastVerifiedDate:'2026-07-19', verificationSource:'MA OPSI lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-129', qualifierId:'Q-022', state:'SC', licenseNumber:'SC-GC-44219', licenseType:'General Contractor', tradeClassification:'General Contracting', licenseStatus:'Expired', issueDate:'2018-05-30', expirationDate:'2026-05-30', lastVerifiedDate:'2026-07-15', verificationSource:'SC LLR lookup', restrictions:'Board matter open — reinstatement required', canBeUsedForPlacement:false, licenseHealthStatus:'Do Not Place Pending Review' },
];
export const LICENSES = [...base.LICENSES, ...moreL, ...bulk.LICENSES_BULK];

// ----- additional availability -----
const moreA = [
  { id:'A-011', qualifierId:'Q-011', availabilityStatus:'Limited Availability', availableStartDate:null, availableEndDate:null, preferredStates:['AZ','NV'], preferredTrades:['General Contracting'], maxActivePlacements:2, currentPlacementCount:1, remoteOk:true, inPersonRequired:false, notes:'One added AZ/NV slot open.' },
  { id:'A-012', qualifierId:'Q-012', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['CO','UT'], preferredTrades:['Electrical'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Available now — CO/UT.' },
  { id:'A-013', qualifierId:'Q-013', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['WA'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:1, remoteOk:false, inPersonRequired:true, notes:'At capacity on Emerald City Build.' },
  { id:'A-014', qualifierId:'Q-014', availabilityStatus:'Limited Availability', availableStartDate:null, availableEndDate:null, preferredStates:['IL','IN'], preferredTrades:['HVAC'], maxActivePlacements:2, currentPlacementCount:1, remoteOk:true, inPersonRequired:false, notes:'Second slot frees when P-408 ends 8/25.' },
  { id:'A-015', qualifierId:'Q-015', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['TN'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Hold until verification completes.' },
  { id:'A-016', qualifierId:'Q-016', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['OH','KY'], preferredTrades:['Plumbing'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Available now — OH/KY.' },
  { id:'A-017', qualifierId:'Q-017', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['NV','UT'], preferredTrades:['General Contracting'], maxActivePlacements:2, currentPlacementCount:1, remoteOk:true, inPersonRequired:false, notes:'First call for NV growth.' },
  { id:'A-018', qualifierId:'Q-018', availabilityStatus:'Paused', availableStartDate:'2026-09-01', availableEndDate:null, preferredStates:['OR','WA'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Sabbatical through ~9/1.' },
  { id:'A-019', qualifierId:'Q-019', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['TX'], preferredTrades:['Electrical'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Good regional backup.' },
  { id:'A-020', qualifierId:'Q-020', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['FL'], preferredTrades:['Roofing'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:false, inPersonRequired:true, notes:'Intake in progress.' },
  { id:'A-021', qualifierId:'Q-021', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['MA','RI'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Best fit for N-212.' },
  { id:'A-022', qualifierId:'Q-022', availabilityStatus:'Paused', availableStartDate:null, availableEndDate:null, preferredStates:['SC'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:false, inPersonRequired:true, notes:'Do not place — pending review (R-611).' },
];
export const AVAILABILITY = [...base.AVAILABILITY, ...moreA, ...bulk.AVAILABILITY_BULK];

// ----- additional documents -----
const moreD = [
  { id:'D-513', qualifierId:'Q-015', relatedLicenseId:'L-121', documentType:'License Copy', documentStatus:'In Review', expirationDate:'2027-04-18', fileLink:'vault://doc/D-513', internalNotes:'Blocks TN verification.' },
  { id:'D-514', qualifierId:'Q-020', relatedLicenseId:null, documentType:'ID', documentStatus:'Requested', expirationDate:null, fileLink:null, internalNotes:'Requested at intake 7/22.' },
  { id:'D-515', qualifierId:'Q-022', relatedLicenseId:'L-129', documentType:'License Copy', documentStatus:'Expired', expirationDate:'2026-05-30', fileLink:'vault://doc/D-515', internalNotes:'Superseded — awaiting reinstatement.' },
  { id:'D-516', qualifierId:'Q-017', relatedLicenseId:null, documentType:'Insurance', documentStatus:'Approved', expirationDate:'2027-05-01', fileLink:'vault://doc/D-516', internalNotes:null },
];
export const DOCUMENTS = [...base.DOCUMENTS, ...moreD, ...bulk.DOCUMENTS_BULK];

// ----- additional placement needs (some deliberately create coverage gaps) -----
const moreN = [
  { id:'N-207', companyName:'Rocky Mountain Builders', contactName:'Iris Vaughn · VP', neededState:'CO', neededTradeClassification:'General Contracting', needStatus:'Open', targetStartDate:'2026-09-10', expectedDuration:'12 months', monthlyOfferAmount:4200, setupSigningAmount:2000, urgencyLevel:'High', requiredDocuments:['License Copy','Insurance','Agreement'], placementOwner:'Nina Cole', adminReviewStatus:'In Review' },
  { id:'N-208', companyName:'Cascade Mechanical', contactName:'Owen Pratt · Owner', neededState:'WA', neededTradeClassification:'HVAC', needStatus:'Open', targetStartDate:'2026-09-20', expectedDuration:'12 months', monthlyOfferAmount:4000, setupSigningAmount:1500, urgencyLevel:'Normal', requiredDocuments:['License Copy','Agreement'], placementOwner:'Leo Park', adminReviewStatus:'In Review' },
  { id:'N-209', companyName:'Great Lakes Contracting', contactName:'Ruth Kelley · COO', neededState:'MI', neededTradeClassification:'General Contracting', needStatus:'Open', targetStartDate:'2026-08-25', expectedDuration:'18 months', monthlyOfferAmount:5000, setupSigningAmount:3000, urgencyLevel:'Emergency', requiredDocuments:['License Copy','Bonding','Agreement'], placementOwner:'Rose Martinez', adminReviewStatus:'In Review' },
  { id:'N-210', companyName:'Sooner Electric', contactName:'Cal Reeves · President', neededState:'OK', neededTradeClassification:'Electrical', needStatus:'Under Review', targetStartDate:'2026-10-05', expectedDuration:'9 months', monthlyOfferAmount:3600, setupSigningAmount:1000, urgencyLevel:'Normal', requiredDocuments:['License Copy','Agreement'], placementOwner:'Marcus Lee', adminReviewStatus:'Needs More Info' },
  { id:'N-211', companyName:'Desert Sun Roofing', contactName:'Val Ortiz · GM', neededState:'AZ', neededTradeClassification:'Roofing', needStatus:'Open', targetStartDate:'2026-09-15', expectedDuration:'12 months', monthlyOfferAmount:3400, setupSigningAmount:500, urgencyLevel:'Normal', requiredDocuments:['License Copy','Insurance'], placementOwner:'Carmen Delgado', adminReviewStatus:'In Review' },
  { id:'N-212', companyName:'Bay State Interiors', contactName:'Fiona Walsh · CFO', neededState:'MA', neededTradeClassification:'General Contracting', needStatus:'Match Proposed', targetStartDate:'2026-08-30', expectedDuration:'24 months', monthlyOfferAmount:5400, setupSigningAmount:4000, urgencyLevel:'High', requiredDocuments:['License Copy','Agreement'], placementOwner:'Rose Martinez', adminReviewStatus:'Approved to Match' },
];
export const NEEDS = [...base.NEEDS, ...moreN];

// ----- additional matches -----
const moreM = [
  { id:'M-309', placementNeedId:'N-212', qualifierId:'Q-021', qualifierLicenseId:'L-128', matchStatus:'Best Fit', fitScore:93, adminApprovalStatus:'Pending', reviewedBy:null, reviewedDate:null,
    matchReason:'Verified MA CSL, available now, clears the offer — premium fit for a 24-month replacement.', ineligibilityReason:null,
    factors:[ { k:'License', tone:'ok', v:'MA CSL-108812 · Verified Current through 7/2028' }, { k:'Availability', tone:'ok', v:'Available Now · MA preferred' }, { k:'Compensation', tone:'ok', v:'Offer $5,400 clears firm $5,200 floor' }, { k:'Documents', tone:'ok', v:'All current' }, { k:'Placement load', tone:'ok', v:'0 active' }, { k:'Risk flags', tone:'ok', v:'None open' } ] },
  { id:'M-310', placementNeedId:'N-208', qualifierId:'Q-014', qualifierLicenseId:'L-119', matchStatus:'Possible Fit', fitScore:52, adminApprovalStatus:'Pending', reviewedBy:null, reviewedDate:null,
    matchReason:'Right trade (HVAC) and open capacity soon, but no WA credential — reciprocity path unconfirmed.', ineligibilityReason:null,
    factors:[ { k:'License', tone:'warn', v:'IL/IN HVAC — no WA credential yet' }, { k:'Availability', tone:'warn', v:'Slot frees 8/25 (P-408 ends)' }, { k:'Compensation', tone:'ok', v:'Min $4,100 under offer $4,000 — slight gap' }, { k:'Documents', tone:'ok', v:'Current' }, { k:'Placement load', tone:'warn', v:'1 active' }, { k:'Risk flags', tone:'warn', v:'WA reciprocity unverified' } ] },
  { id:'M-311', placementNeedId:'N-207', qualifierId:'Q-012', qualifierLicenseId:'L-117', matchStatus:'Possible Fit', fitScore:58, adminApprovalStatus:'Needs More Info', reviewedBy:'Nina Cole', reviewedDate:'2026-07-20',
    matchReason:'CO-based and available, but need is GC and credential is electrical — confirm scope fit with client.', ineligibilityReason:null,
    factors:[ { k:'License', tone:'warn', v:'CO Master Electrician — need is GC scope' }, { k:'Availability', tone:'ok', v:'Available Now · CO' }, { k:'Compensation', tone:'ok', v:'Min $4,000 under offer $4,200' }, { k:'Documents', tone:'ok', v:'Current' }, { k:'Placement load', tone:'ok', v:'0 active' }, { k:'Risk flags', tone:'warn', v:'Scope mismatch to confirm' } ] },
];
export const MATCHES = [...base.MATCHES, ...moreM];

// ----- additional placements (map density + leaderboard) -----
const moreP = [
  { id:'P-405', companyName:'Grand Canyon Development', qualifierId:'Q-011', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2026-01-15', expectedEndDate:'2027-01-15', actualEndDate:null, monthlyFee:5800, qualifierMonthlyCompensation:4300, ccaMonthlyFee:1500, backupQualifierNeeded:true, backupQualifierIdentified:true, renewalReviewDate:'2026-10-15', internalPlacementNotes:'Healthy. Backup: Trent Alvarez (Q-017).' },
  { id:'P-406', companyName:'Mile High Partners', qualifierId:'Q-012', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2026-03-01', expectedEndDate:'2027-03-01', actualEndDate:null, monthlyFee:5400, qualifierMonthlyCompensation:4000, ccaMonthlyFee:1400, backupQualifierNeeded:false, backupQualifierIdentified:false, renewalReviewDate:'2026-12-01', internalPlacementNotes:'New this quarter — smooth onboarding.' },
  { id:'P-407', companyName:'Emerald City Build', qualifierId:'Q-013', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2025-10-01', expectedEndDate:'2026-10-01', actualEndDate:null, monthlyFee:6600, qualifierMonthlyCompensation:4800, ccaMonthlyFee:1800, backupQualifierNeeded:true, backupQualifierIdentified:false, renewalReviewDate:'2026-08-20', internalPlacementNotes:'Premium WA account. No backup identified — start search.' },
  { id:'P-408', companyName:'Windy City GC', qualifierId:'Q-014', placementNeedId:null, placementMatchId:null, placementStatus:'Ending Soon', startDate:'2025-08-25', expectedEndDate:'2026-08-25', actualEndDate:null, monthlyFee:5600, qualifierMonthlyCompensation:4100, ccaMonthlyFee:1500, backupQualifierNeeded:true, backupQualifierIdentified:true, renewalReviewDate:'2026-07-25', internalPlacementNotes:'Renewal conversation open. Farah pre-empted it — likely to renew.' },
  { id:'P-409', companyName:'Silver State Homes', qualifierId:'Q-017', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2026-02-20', expectedEndDate:'2027-02-20', actualEndDate:null, monthlyFee:6200, qualifierMonthlyCompensation:4600, ccaMonthlyFee:1600, backupQualifierNeeded:false, backupQualifierIdentified:false, renewalReviewDate:'2026-11-20', internalPlacementNotes:'Strong NV relationship.' },
  { id:'P-410', companyName:'Beacon Hill Restoration', qualifierId:'Q-021', placementNeedId:null, placementMatchId:null, placementStatus:'At Risk', startDate:'2025-12-01', expectedEndDate:'2026-12-01', actualEndDate:null, monthlyFee:7200, qualifierMonthlyCompensation:5200, ccaMonthlyFee:2000, backupQualifierNeeded:true, backupQualifierIdentified:false, renewalReviewDate:'2026-10-01', internalPlacementNotes:'Client raised a service concern (R-614). Recovering — monitor closely.' },
];
export const PLACEMENTS = [...base.PLACEMENTS, ...moreP];

// ----- additional reviews (feed reliability streaks + leaderboard) -----
const moreV = [
  { id:'V-706', qualifierId:'Q-011', relatedPlacementId:'P-405', reviewType:'Placement Review', reliabilityRating:5, communicationRating:4, documentReadinessRating:5, reviewNotes:'Grand Canyon happy — steady, responsive.', adminOnly:false, reviewedBy:'Carmen Delgado', reviewDate:'2026-07-08' },
  { id:'V-707', qualifierId:'Q-014', relatedPlacementId:'P-408', reviewType:'Communication Review', reliabilityRating:5, communicationRating:5, documentReadinessRating:5, reviewNotes:'Model qualifier — six clean cycles running.', adminOnly:false, reviewedBy:'Rose Martinez', reviewDate:'2026-07-14' },
  { id:'V-708', qualifierId:'Q-017', relatedPlacementId:'P-409', reviewType:'Placement Review', reliabilityRating:5, communicationRating:5, documentReadinessRating:4, reviewNotes:'Silver State pleased. Reliable, proactive.', adminOnly:false, reviewedBy:'Nina Cole', reviewDate:'2026-07-16' },
  { id:'V-709', qualifierId:'Q-021', relatedPlacementId:'P-410', reviewType:'Risk Review', reliabilityRating:4, communicationRating:4, documentReadinessRating:5, reviewNotes:'Service concern is client-side scheduling, not performance. Coaching underway.', adminOnly:true, reviewedBy:'Rose Martinez', reviewDate:'2026-07-19' },
  { id:'V-710', qualifierId:'Q-013', relatedPlacementId:'P-407', reviewType:'Placement Review', reliabilityRating:5, communicationRating:4, documentReadinessRating:4, reviewNotes:'Emerald City values him. Backup search is the only open item.', adminOnly:false, reviewedBy:'Leo Park', reviewDate:'2026-06-22' },
];
export const REVIEWS = [...base.REVIEWS, ...moreV];

// ----- additional risks -----
const moreR = [
  // R-609/R-610 reserved for 0009 additive Resolved/Dismissed demo rows — do not reuse.
  { id:'R-613', relatedQualifierId:'Q-020', relatedPlacementNeedId:null, relatedActivePlacementId:null, riskType:'Missing Documents', riskLevel:'Medium', riskStatus:'Open', owner:'Leo Park', dueDate:'2026-08-08', resolutionNotes:'ID outstanding — blocks Jacksonville intake verification.' },
  { id:'R-614', relatedQualifierId:'Q-021', relatedPlacementNeedId:null, relatedActivePlacementId:'P-410', riskType:'Client Service Concern', riskLevel:'High', riskStatus:'In Review', owner:'Rose Martinez', dueDate:'2026-08-05', resolutionNotes:'Beacon Hill flagged scheduling. Recovery plan in place; re-check 8/5.' },
  { id:'R-611', relatedQualifierId:'Q-022', relatedPlacementNeedId:null, relatedActivePlacementId:null, riskType:'Human Review Required', riskLevel:'Critical', riskStatus:'Escalated', owner:'Dana Whitfield', dueDate:'2026-07-30', resolutionNotes:'SC GC lapsed + open board matter. DNP hold until reinstatement + review closes.' },
  { id:'R-612', relatedQualifierId:null, relatedPlacementNeedId:'N-209', relatedActivePlacementId:null, riskType:'No Coverage In Region', riskLevel:'High', riskStatus:'Open', owner:'Rose Martinez', dueDate:'2026-08-12', resolutionNotes:'Emergency MI need with zero MI bench. External sourcing required.' },
];
export const RISKS = [...base.RISKS, ...moreR];

// ----- coverage gaps: deliberate under-covered regions for the map's pulsing dots -----
// Each: state with open/urgent demand but no (or blocked) local available qualifier.
export const COVERAGE_GAPS = [
  { state:'MI', city:'Detroit',       reason:'Emergency GC need, zero MI bench', openNeeds:1, severity:'high',   needId:'N-209' },
  { state:'OK', city:'Oklahoma City', reason:'Electrical need under review, no OK coverage', openNeeds:1, severity:'medium', needId:'N-210' },
  { state:'NY', city:'Brooklyn',      reason:'Replacement need, bench exhausted (on leave)', openNeeds:1, severity:'high',   needId:'N-206' },
  { state:'WA', city:'Seattle',       reason:'HVAC need, only GC locally available', openNeeds:1, severity:'medium', needId:'N-208' },
  { state:'AZ', city:'Phoenix',       reason:'Roofing need, only GC locally available', openNeeds:1, severity:'medium', needId:'N-211' },
];
