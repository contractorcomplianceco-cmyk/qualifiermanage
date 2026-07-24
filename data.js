// QualifierManageOS — seed data layer (Phase 1 prototype).
// Shaped to map 1:1 onto a future Postgres/Supabase schema; swap this module
// for API calls without touching the UI. Screening data is STATUS ONLY —
// no reports or sensitive personal information are stored here by design.

export const TODAY = '2026-07-24';

export const STAFF = [
  { name: 'Rose Martinez',  role: 'Leadership' },
  { name: 'Dana Whitfield', role: 'Admin' },
  { name: 'Carmen Delgado', role: 'Placement Coordinator' },
  { name: 'Marcus Lee',     role: 'Fulfillment' },
  { name: 'Kim Sato',       role: 'Sales Viewer' },
];

export const QUALIFIERS = [
  { id:'Q-001', fullName:'Marcus Webb', preferredName:'Marc', email:'m.webb@qmail.com', phone:'(813) 555-0142', city:'Tampa', stateOfResidence:'FL', timezone:'ET',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support'], minimumMonthlyCompensation:4500, openToNegotiation:true,
    internalOwner:'Carmen Delgado', lastReviewedDate:'2026-06-30', nextReviewDue:'2026-12-30',
    adminOnlyNotes:'Strong communicator; Gulfside placement is healthy. Approved as dual-state (FL/GA). First call for FL GC needs — but GL insurance COI lapsed 7/1; hold new starts until carrier confirms.',
    readiness:{ score:84, parts:[
      { k:'Verification', pts:'30/30', tone:'ok',   note:'Verified 6/30 · checks clear' },
      { k:'License health', pts:'20/25', tone:'warn', note:'FL current · GA in renewal window' },
      { k:'Documents', pts:'12/20', tone:'warn', note:'GL insurance COI lapsed 7/1' },
      { k:'Availability', pts:'12/15', tone:'ok',   note:'1 of 2 slots open, FL/GA' },
      { k:'Review record', pts:'10/10', tone:'ok',  note:'5/5 reliability on P-402' } ] } },
  { id:'Q-002', fullName:'Elena Vasquez', preferredName:'Elena', email:'elena.v@qmail.com', phone:'(512) 555-0177', city:'Austin', stateOfResidence:'TX', timezone:'CT',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Replacement'], minimumMonthlyCompensation:3800, openToNegotiation:true,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-01', nextReviewDue:'2027-01-01',
    adminOnlyNotes:'Fast document turnaround. Wants TX-only engagements until Q1 2027. OK reciprocity application pending — do not pitch OK until board approves.',
    readiness:{ score:90, parts:[
      { k:'Verification', pts:'30/30', tone:'ok', note:'Verified 7/1 · checks clear' },
      { k:'License health', pts:'21/25', tone:'ok', note:'TX Master current · OK pending' },
      { k:'Documents', pts:'19/20', tone:'ok', note:'All approved' },
      { k:'Availability', pts:'12/15', tone:'ok', note:'Available now · TX only' },
      { k:'Review record', pts:'8/10', tone:'ok', note:'No placements yet — intake refs' } ] } },
  { id:'Q-003', fullName:'David Okafor', preferredName:'David', email:'d.okafor@qmail.com', phone:'(404) 555-0128', city:'Atlanta', stateOfResidence:'GA', timezone:'ET',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:4000, openToNegotiation:false,
    internalOwner:'Carmen Delgado', lastReviewedDate:'2026-05-15', nextReviewDue:'2026-11-15',
    adminOnlyNotes:'At max placements (1/1). FL roofing license needs re-verification before any second engagement. Communication gaps in April — coached, improving.',
    readiness:{ score:78, parts:[
      { k:'Verification', pts:'30/30', tone:'ok', note:'Verified · checks clear' },
      { k:'License health', pts:'17/25', tone:'warn', note:'GA current · FL roofing unverified 9mo' },
      { k:'Documents', pts:'17/20', tone:'ok', note:'Current' },
      { k:'Availability', pts:'6/15', tone:'bad', note:'At capacity (1/1)' },
      { k:'Review record', pts:'8/10', tone:'warn', note:'Comm. coached in April' } ] } },
  { id:'Q-004', fullName:'Sarah Lindqvist', preferredName:'Sarah', email:'s.lindqvist@qmail.com', phone:'(704) 555-0195', city:'Charlotte', stateOfResidence:'NC', timezone:'ET',
    status:'Under Review', verificationStatus:'In Progress', backgroundCheckStatus:'Pending', creditCheckStatus:'Pending',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier','Compliance Oversight'], minimumMonthlyCompensation:3200, openToNegotiation:true,
    internalOwner:'Dana Whitfield', lastReviewedDate:'2026-07-10', nextReviewDue:'2026-08-10',
    adminOnlyNotes:'Intake strong. Verification blocked on experience proof; checks in flight. Do not surface to sales until Verified.',
    readiness:{ score:58, parts:[
      { k:'Verification', pts:'14/30', tone:'warn', note:'In progress · checks pending' },
      { k:'License health', pts:'20/25', tone:'ok', note:'NC P-I current' },
      { k:'Documents', pts:'8/20', tone:'bad', note:'Experience proof outstanding' },
      { k:'Availability', pts:'8/15', tone:'warn', note:'Hold until verified' },
      { k:'Review record', pts:'8/10', tone:'ok', note:'References strong' } ] } },
  { id:'Q-005', fullName:'James Ferraro', preferredName:'Jim', email:'j.ferraro@qmail.com', phone:'(305) 555-0163', city:'Miami', stateOfResidence:'FL', timezone:'ET',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Review Required',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Backup / On-Deck'], minimumMonthlyCompensation:4200, openToNegotiation:true,
    internalOwner:'Carmen Delgado', lastReviewedDate:'2026-06-20', nextReviewDue:'2026-09-20',
    adminOnlyNotes:'Named backup for Gulfside (P-402). FL CGC renewal filed 7/18, DBPR confirmation pending. Credit re-check open — resolve before backup rider finalizes.',
    readiness:{ score:71, parts:[
      { k:'Verification', pts:'24/30', tone:'warn', note:'Verified · credit re-check open' },
      { k:'License health', pts:'15/25', tone:'warn', note:'FL CGC expires 8/30 · renewal filed' },
      { k:'Documents', pts:'12/20', tone:'warn', note:'Agreement rider in review' },
      { k:'Availability', pts:'11/15', tone:'ok', note:'Available 9/1 · backup priority' },
      { k:'Review record', pts:'9/10', tone:'ok', note:'Reliable in prior cycle' } ] } },
  { id:'Q-006', fullName:'Priya Raman', preferredName:'Priya', email:'p.raman@qmail.com', phone:'(713) 555-0119', city:'Houston', stateOfResidence:'TX', timezone:'CT',
    status:'Active', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support'], minimumMonthlyCompensation:3600, openToNegotiation:true,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-05', nextReviewDue:'2027-01-05',
    adminOnlyNotes:'Excellent on Hill Country Air. Approved for one additional TX/LA placement (2 max). Model communicator — protect the relationship.',
    readiness:{ score:88, parts:[
      { k:'Verification', pts:'30/30', tone:'ok', note:'Verified · checks clear' },
      { k:'License health', pts:'21/25', tone:'ok', note:'TX current · LA renewal window' },
      { k:'Documents', pts:'18/20', tone:'ok', note:'Current' },
      { k:'Availability', pts:'9/15', tone:'warn', note:'1 of 2 slots · P-403 ending' },
      { k:'Review record', pts:'10/10', tone:'ok', note:'5/5 across the board' } ] } },
  { id:'Q-007', fullName:'Tom Gallagher', preferredName:'Tom', email:'t.gallagher@qmail.com', phone:'(407) 555-0151', city:'Orlando', stateOfResidence:'FL', timezone:'ET',
    status:'Do Not Place Pending Review', verificationStatus:'Human Review Required', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:3000, openToNegotiation:true,
    internalOwner:'Dana Whitfield', lastReviewedDate:'2026-07-15', nextReviewDue:'2026-07-29',
    adminOnlyNotes:'FL roofing license expired 6/30 with an open board inquiry. DO NOT PLACE until reinstatement docs land and Dana closes the review. Tom is cooperative — keep the relationship warm.',
    readiness:{ score:24, parts:[
      { k:'Verification', pts:'6/30', tone:'bad', note:'Human review required' },
      { k:'License health', pts:'0/25', tone:'bad', note:'FL roofing expired · board inquiry' },
      { k:'Documents', pts:'8/20', tone:'bad', note:'License copy expired' },
      { k:'Availability', pts:'0/15', tone:'bad', note:'Do-not-place hold' },
      { k:'Review record', pts:'10/10', tone:'ok', note:'No performance concerns' } ] } },
  { id:'Q-008', fullName:'Nicole Barnes', preferredName:'Nicole', email:'n.barnes@qmail.com', phone:'(619) 555-0184', city:'San Diego', stateOfResidence:'CA', timezone:'PT',
    status:'Verified', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:true, preferredPlacementTypes:['License Qualifier','Expansion Support','Replacement'], minimumMonthlyCompensation:5500, openToNegotiation:false,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-12', nextReviewDue:'2027-01-12',
    adminOnlyNotes:'Premium profile: CA B + AZ KB-2, RMO experience. Firm on the $5,500 floor — do not pitch below it. Prefers a single premium engagement.',
    readiness:{ score:94, parts:[
      { k:'Verification', pts:'30/30', tone:'ok', note:'Verified 7/12 · checks clear' },
      { k:'License health', pts:'25/25', tone:'ok', note:'CA + AZ verified current' },
      { k:'Documents', pts:'18/20', tone:'ok', note:'Bonding renews 9/10 — quote out' },
      { k:'Availability', pts:'13/15', tone:'ok', note:'Available now · CA/AZ' },
      { k:'Review record', pts:'8/10', tone:'ok', note:'Strong RMO references' } ] } },
  { id:'Q-009', fullName:'Robert Choi', preferredName:'Rob', email:'r.choi@qmail.com', phone:'(919) 555-0136', city:'Raleigh', stateOfResidence:'NC', timezone:'ET',
    status:'Intake Started', verificationStatus:'Not Started', backgroundCheckStatus:'Not Started', creditCheckStatus:'Not Started',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:2800, openToNegotiation:true,
    internalOwner:'Marcus Lee', lastReviewedDate:null, nextReviewDue:'2026-08-05',
    adminOnlyNotes:'New referral from the NC association. ID and license verification outstanding — needed before M-305 can advance.',
    readiness:{ score:31, parts:[
      { k:'Verification', pts:'0/30', tone:'bad', note:'Not started' },
      { k:'License health', pts:'10/25', tone:'warn', note:'NC SP-L self-reported, unverified' },
      { k:'Documents', pts:'6/20', tone:'bad', note:'ID outstanding · resume received' },
      { k:'Availability', pts:'8/15', tone:'warn', note:'Target-ready by 10/1 if verified' },
      { k:'Review record', pts:'7/10', tone:'ok', note:'Association referral' } ] } },
  { id:'Q-010', fullName:'Angela Duke', preferredName:'Angela', email:'a.duke@qmail.com', phone:'(718) 555-0109', city:'Brooklyn', stateOfResidence:'NY', timezone:'ET',
    status:'Paused', verificationStatus:'Verified', backgroundCheckStatus:'Clear', creditCheckStatus:'Clear',
    availableForPlacement:false, preferredPlacementTypes:['License Qualifier'], minimumMonthlyCompensation:5000, openToNegotiation:false,
    internalOwner:'Rose Martinez', lastReviewedDate:'2026-07-18', nextReviewDue:'2026-08-18',
    adminOnlyNotes:'Paused for family leave through ~9/15 while on the Harbor Point placement. Replacement search open as N-206. Handle with care — strong long-term profile, gave 3 weeks notice.',
    readiness:{ score:66, parts:[
      { k:'Verification', pts:'30/30', tone:'ok', note:'Verified · checks clear' },
      { k:'License health', pts:'22/25', tone:'ok', note:'NYC HIC verified current' },
      { k:'Documents', pts:'16/20', tone:'ok', note:'Current' },
      { k:'Availability', pts:'0/15', tone:'bad', note:'Paused — leave through ~9/15' },
      { k:'Review record', pts:'9/10', tone:'ok', note:'Professional leave handling' } ] } },
];

export const LICENSES = [
  { id:'L-101', qualifierId:'Q-001', state:'FL', licenseNumber:'CGC1512873', licenseType:'Certified General Contractor', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2019-08-31', expirationDate:'2027-08-31', lastVerifiedDate:'2026-07-01', verificationSource:'FL DBPR portal', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-102', qualifierId:'Q-001', state:'GA', licenseNumber:'GCCO006214', licenseType:'General Contractor', tradeClassification:'General Contracting', licenseStatus:'Renewal Window', issueDate:'2022-10-15', expirationDate:'2026-10-15', lastVerifiedDate:'2026-07-01', verificationSource:'GA licensing board', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Renewal Window' },
  { id:'L-103', qualifierId:'Q-002', state:'TX', licenseNumber:'TECL-38217', licenseType:'Master Electrician', tradeClassification:'Electrical', licenseStatus:'Active', issueDate:'2018-03-14', expirationDate:'2027-03-14', lastVerifiedDate:'2026-06-28', verificationSource:'TDLR lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-104', qualifierId:'Q-002', state:'OK', licenseNumber:'OK-EL-88412', licenseType:'Electrical Contractor (reciprocity)', tradeClassification:'Electrical', licenseStatus:'Pending', issueDate:'2026-06-01', expirationDate:null, lastVerifiedDate:null, verificationSource:'OK CIB application', restrictions:'Application pending — await board approval', canBeUsedForPlacement:false, licenseHealthStatus:'Human Review Required' },
  { id:'L-105', qualifierId:'Q-003', state:'GA', licenseNumber:'GCQA004518', licenseType:'General Contractor — Qualifying Agent', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2020-01-20', expirationDate:'2028-01-20', lastVerifiedDate:'2026-05-10', verificationSource:'GA licensing board', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-106', qualifierId:'Q-003', state:'FL', licenseNumber:'CCC1327745', licenseType:'Certified Roofing Contractor', tradeClassification:'Roofing', licenseStatus:'Active', issueDate:'2021-06-11', expirationDate:'2027-06-11', lastVerifiedDate:'2025-09-02', verificationSource:'FL DBPR portal', restrictions:null, canBeUsedForPlacement:false, licenseHealthStatus:'Missing Verification' },
  { id:'L-107', qualifierId:'Q-004', state:'NC', licenseNumber:'P1-30988', licenseType:'Plumbing Contractor (P-I)', tradeClassification:'Plumbing', licenseStatus:'Active', issueDate:'2019-01-05', expirationDate:'2027-01-05', lastVerifiedDate:'2026-07-08', verificationSource:'NC State Board', restrictions:null, canBeUsedForPlacement:false, licenseHealthStatus:'Verified Current' },
  { id:'L-108', qualifierId:'Q-005', state:'FL', licenseNumber:'CGC1499020', licenseType:'Certified General Contractor', tradeClassification:'General Contracting', licenseStatus:'Expiring Soon', issueDate:'2015-08-30', expirationDate:'2026-08-30', lastVerifiedDate:'2026-07-18', verificationSource:'FL DBPR portal', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Expiring Soon' },
  { id:'L-109', qualifierId:'Q-006', state:'TX', licenseNumber:'TACLA00281C', licenseType:'HVAC Contractor — Class A', tradeClassification:'HVAC', licenseStatus:'Active', issueDate:'2017-11-02', expirationDate:'2027-11-02', lastVerifiedDate:'2026-07-02', verificationSource:'TDLR lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-110', qualifierId:'Q-006', state:'LA', licenseNumber:'LA-52117-M', licenseType:'Mechanical Contractor', tradeClassification:'HVAC', licenseStatus:'Renewal Window', issueDate:'2023-10-01', expirationDate:'2026-10-01', lastVerifiedDate:'2026-06-15', verificationSource:'LSLBC portal', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Renewal Window' },
  { id:'L-111', qualifierId:'Q-007', state:'FL', licenseNumber:'CCC1330912', licenseType:'Certified Roofing Contractor', tradeClassification:'Roofing', licenseStatus:'Expired', issueDate:'2018-06-30', expirationDate:'2026-06-30', lastVerifiedDate:'2026-07-15', verificationSource:'FL DBPR portal', restrictions:'Board inquiry open — reinstatement required', canBeUsedForPlacement:false, licenseHealthStatus:'Do Not Place Pending Review' },
  { id:'L-112', qualifierId:'Q-008', state:'CA', licenseNumber:'1088412', licenseType:'Class B — General Building', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2016-02-28', expirationDate:'2028-02-28', lastVerifiedDate:'2026-07-10', verificationSource:'CSLB lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-113', qualifierId:'Q-008', state:'AZ', licenseNumber:'ROC-KB2-33914', licenseType:'KB-2 Dual Building', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2019-06-15', expirationDate:'2027-06-15', lastVerifiedDate:'2026-07-10', verificationSource:'AZ ROC lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
  { id:'L-114', qualifierId:'Q-009', state:'NC', licenseNumber:'U-29441', licenseType:'Electrical — Limited (SP-L)', tradeClassification:'Electrical', licenseStatus:'Unknown', issueDate:'2020-04-22', expirationDate:'2027-04-22', lastVerifiedDate:null, verificationSource:'Self-reported — not yet verified', restrictions:null, canBeUsedForPlacement:false, licenseHealthStatus:'Human Review Required' },
  { id:'L-115', qualifierId:'Q-010', state:'NY', licenseNumber:'613455-HIC', licenseType:'General Contractor (NYC HIC)', tradeClassification:'General Contracting', licenseStatus:'Active', issueDate:'2015-05-19', expirationDate:'2027-05-19', lastVerifiedDate:'2026-06-01', verificationSource:'NYC DCA lookup', restrictions:null, canBeUsedForPlacement:true, licenseHealthStatus:'Verified Current' },
];

export const AVAILABILITY = [
  { id:'A-001', qualifierId:'Q-001', availabilityStatus:'Limited Availability', availableStartDate:null, availableEndDate:null, preferredStates:['FL','GA'], preferredTrades:['General Contracting'], maxActivePlacements:2, currentPlacementCount:1, remoteOk:true, inPersonRequired:false, notes:'Second slot reserved for FL/GA GC needs at $4,500+.' },
  { id:'A-002', qualifierId:'Q-002', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['TX'], preferredTrades:['Electrical'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'TX-only until Q1 2027.' },
  { id:'A-003', qualifierId:'Q-003', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['GA'], preferredTrades:['General Contracting','Roofing'], maxActivePlacements:1, currentPlacementCount:1, remoteOk:false, inPersonRequired:true, notes:'At capacity on Summit Restoration.' },
  { id:'A-004', qualifierId:'Q-004', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['NC','SC'], preferredTrades:['Plumbing'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Hold until verification completes.' },
  { id:'A-005', qualifierId:'Q-005', availabilityStatus:'Available Soon', availableStartDate:'2026-09-01', availableEndDate:null, preferredStates:['FL'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Backup commitment to P-402 takes priority if triggered.' },
  { id:'A-006', qualifierId:'Q-006', availabilityStatus:'Limited Availability', availableStartDate:null, availableEndDate:null, preferredStates:['TX','LA'], preferredTrades:['HVAC'], maxActivePlacements:2, currentPlacementCount:1, remoteOk:true, inPersonRequired:false, notes:'Open to one additional TX/LA engagement.' },
  { id:'A-007', qualifierId:'Q-007', availabilityStatus:'Paused', availableStartDate:null, availableEndDate:null, preferredStates:['FL'], preferredTrades:['Roofing'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:false, inPersonRequired:true, notes:'Do not place — pending review (R-602).' },
  { id:'A-008', qualifierId:'Q-008', availabilityStatus:'Available Now', availableStartDate:null, availableEndDate:null, preferredStates:['CA','AZ'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Single premium engagement preferred.' },
  { id:'A-009', qualifierId:'Q-009', availabilityStatus:'Not Available', availableStartDate:null, availableEndDate:null, preferredStates:['NC'], preferredTrades:['Electrical'], maxActivePlacements:1, currentPlacementCount:0, remoteOk:true, inPersonRequired:false, notes:'Intake in progress.' },
  { id:'A-010', qualifierId:'Q-010', availabilityStatus:'Paused', availableStartDate:'2026-09-15', availableEndDate:null, preferredStates:['NY','NJ'], preferredTrades:['General Contracting'], maxActivePlacements:1, currentPlacementCount:1, remoteOk:false, inPersonRequired:true, notes:'Family leave through ~9/15.' },
];

export const DOCUMENTS = [
  { id:'D-501', qualifierId:'Q-001', relatedLicenseId:null,    documentType:'ID',               documentStatus:'Approved',    expirationDate:'2029-03-12', fileLink:'vault://doc/D-501', internalNotes:null },
  { id:'D-502', qualifierId:'Q-001', relatedLicenseId:'L-101', documentType:'License Copy',     documentStatus:'Approved',    expirationDate:'2027-08-31', fileLink:'vault://doc/D-502', internalNotes:null },
  { id:'D-503', qualifierId:'Q-001', relatedLicenseId:null,    documentType:'Insurance',        documentStatus:'Needs Update', expirationDate:'2026-07-01', fileLink:'vault://doc/D-503', internalNotes:'GL COI lapsed 7/1 — carrier confirmation requested 7/20.' },
  { id:'D-504', qualifierId:'Q-002', relatedLicenseId:null,    documentType:'Resume',           documentStatus:'Approved',    expirationDate:null, fileLink:'vault://doc/D-504', internalNotes:null },
  { id:'D-505', qualifierId:'Q-002', relatedLicenseId:null,    documentType:'Background Check', documentStatus:'Approved',    expirationDate:'2027-07-01', fileLink:'vault://status-only', internalNotes:'Status only — report held by screening vendor.' },
  { id:'D-506', qualifierId:'Q-004', relatedLicenseId:'L-107', documentType:'License Copy',     documentStatus:'In Review',   expirationDate:'2027-01-05', fileLink:'vault://doc/D-506', internalNotes:null },
  { id:'D-507', qualifierId:'Q-004', relatedLicenseId:null,    documentType:'Experience Proof', documentStatus:'Requested',   expirationDate:null, fileLink:null, internalNotes:'Blocking verification — requested 7/10, reminder 7/21.' },
  { id:'D-508', qualifierId:'Q-005', relatedLicenseId:null,    documentType:'Agreement',        documentStatus:'In Review',   expirationDate:null, fileLink:'vault://doc/D-508', internalNotes:'Backup rider for P-402 attached.' },
  { id:'D-509', qualifierId:'Q-007', relatedLicenseId:'L-111', documentType:'License Copy',     documentStatus:'Expired',     expirationDate:'2026-06-30', fileLink:'vault://doc/D-509', internalNotes:'Superseded — awaiting reinstatement documentation.' },
  { id:'D-510', qualifierId:'Q-009', relatedLicenseId:null,    documentType:'ID',               documentStatus:'Requested',   expirationDate:null, fileLink:null, internalNotes:'Requested at intake 7/14.' },
  { id:'D-511', qualifierId:'Q-009', relatedLicenseId:null,    documentType:'Resume',           documentStatus:'Received',    expirationDate:null, fileLink:'vault://doc/D-511', internalNotes:null },
  { id:'D-512', qualifierId:'Q-008', relatedLicenseId:null,    documentType:'Bonding',          documentStatus:'Approved',    expirationDate:'2026-09-10', fileLink:'vault://doc/D-512', internalNotes:'Renewal quote requested 7/20.' },
];

export const NEEDS = [
  { id:'N-201', companyName:'Meridian Build Group', contactName:'Alan Pruitt · VP Ops', neededState:'FL', neededTradeClassification:'General Contracting (CGC)', needStatus:'Open', targetStartDate:'2026-08-15', expectedDuration:'12 months, renewable', monthlyOfferAmount:4500, setupSigningAmount:2500, urgencyLevel:'High', requiredDocuments:['License Copy','Insurance','Agreement'], placementOwner:'Carmen Delgado', adminReviewStatus:'Approved to Match' },
  { id:'N-202', companyName:'Lonestar Mechanical', contactName:'Dee Alvarez · Owner', neededState:'TX', neededTradeClassification:'HVAC — Class A', needStatus:'Match Proposed', targetStartDate:'2026-09-01', expectedDuration:'12 months', monthlyOfferAmount:3800, setupSigningAmount:1500, urgencyLevel:'Normal', requiredDocuments:['License Copy','Agreement'], placementOwner:'Rose Martinez', adminReviewStatus:'Approved to Match' },
  { id:'N-203', companyName:'Blue Ridge Renovations', contactName:'Sam Teller · GM', neededState:'NC', neededTradeClassification:'Electrical — Limited', needStatus:'Under Review', targetStartDate:'2026-10-01', expectedDuration:'6 months, option to extend', monthlyOfferAmount:3200, setupSigningAmount:1000, urgencyLevel:'Normal', requiredDocuments:['License Copy','Experience Proof','Agreement'], placementOwner:'Marcus Lee', adminReviewStatus:'In Review' },
  { id:'N-204', companyName:'Pacific Crest Builders', contactName:'Judith Hong · CFO', neededState:'CA', neededTradeClassification:'Class B — General Building', needStatus:'Match Approved', targetStartDate:'2026-08-01', expectedDuration:'24 months', monthlyOfferAmount:6000, setupSigningAmount:5000, urgencyLevel:'Emergency', requiredDocuments:['License Copy','Bonding','Insurance','Agreement'], placementOwner:'Rose Martinez', adminReviewStatus:'Approved to Match' },
  { id:'N-205', companyName:'Peach State Roofing', contactName:'Bo Landry · President', neededState:'GA', neededTradeClassification:'Roofing', needStatus:'Draft', targetStartDate:'2026-11-01', expectedDuration:'12 months', monthlyOfferAmount:2800, setupSigningAmount:0, urgencyLevel:'Low', requiredDocuments:['License Copy','Insurance'], placementOwner:'Carmen Delgado', adminReviewStatus:'Needs More Info' },
  { id:'N-206', companyName:'Empire Interior Systems', contactName:'Rita Moss · COO', neededState:'NY', neededTradeClassification:'General Contracting (HIC)', needStatus:'Open', targetStartDate:'2026-08-20', expectedDuration:'Replacement — through 2027', monthlyOfferAmount:5200, setupSigningAmount:3000, urgencyLevel:'High', requiredDocuments:['License Copy','Agreement'], placementOwner:'Rose Martinez', adminReviewStatus:'In Review' },
];

export const MATCHES = [
  { id:'M-301', placementNeedId:'N-201', qualifierId:'Q-001', qualifierLicenseId:'L-101', matchStatus:'Best Fit', fitScore:92, adminApprovalStatus:'Pending', reviewedBy:null, reviewedDate:null,
    matchReason:'Exact state/trade match — current FL CGC, open capacity, and a strong review record on an active FL placement.', ineligibilityReason:null,
    factors:[
      { k:'License', tone:'ok',  v:'FL CGC1512873 · Verified Current through 8/2027' },
      { k:'Availability', tone:'ok', v:'Limited — 1 of 2 slots open · FL preferred' },
      { k:'Compensation', tone:'ok', v:'Min $4,500 = offer $4,500 + $2,500 signing' },
      { k:'Documents', tone:'warn', v:'GL insurance COI lapsed 7/1 — renewal in progress' },
      { k:'Placement load', tone:'ok', v:'1 active (Gulfside Development)' },
      { k:'Risk flags', tone:'ok', v:'None open' } ] },
  { id:'M-302', placementNeedId:'N-201', qualifierId:'Q-005', qualifierLicenseId:'L-108', matchStatus:'Possible Fit', fitScore:74, adminApprovalStatus:'Pending', reviewedBy:null, reviewedDate:null,
    matchReason:'Strong FL GC profile, but the CGC renewal must confirm before an 8/15 start is safe.', ineligibilityReason:null,
    factors:[
      { k:'License', tone:'warn', v:'FL CGC expires 8/30 — renewal filed 7/18, confirmation pending' },
      { k:'Availability', tone:'warn', v:'Available Soon (9/1) — after target start 8/15' },
      { k:'Compensation', tone:'ok', v:'Min $4,200 under offer $4,500' },
      { k:'Documents', tone:'warn', v:'Agreement rider in review · credit re-check open' },
      { k:'Placement load', tone:'ok', v:'0 active · backup commitment to P-402' },
      { k:'Risk flags', tone:'warn', v:'R-601 License Expiring (Medium)' } ] },
  { id:'M-303', placementNeedId:'N-201', qualifierId:'Q-007', qualifierLicenseId:'L-111', matchStatus:'Not Recommended', fitScore:18, adminApprovalStatus:'Rejected', reviewedBy:'Dana Whitfield', reviewedDate:'2026-07-16',
    matchReason:null, ineligibilityReason:'FL roofing license expired 6/30 with an open board inquiry; qualifier is on a Do Not Place hold pending review.',
    factors:[
      { k:'License', tone:'bad', v:'Expired 6/30 — reinstatement required' },
      { k:'Risk flags', tone:'bad', v:'R-602 Critical · escalated' },
      { k:'Availability', tone:'bad', v:'Paused — do-not-place hold' } ] },
  { id:'M-304', placementNeedId:'N-202', qualifierId:'Q-006', qualifierLicenseId:'L-109', matchStatus:'Best Fit', fitScore:88, adminApprovalStatus:'Pending', reviewedBy:null, reviewedDate:null,
    matchReason:'Only verified TX Class A profile with open capacity; model review record.', ineligibilityReason:null,
    factors:[
      { k:'License', tone:'ok', v:'TX TACLA00281C · Verified Current through 11/2027' },
      { k:'Availability', tone:'ok', v:'Limited — 1 of 2 slots open · TX/LA' },
      { k:'Compensation', tone:'ok', v:'Min $3,600 under offer $3,800' },
      { k:'Documents', tone:'ok', v:'All current' },
      { k:'Placement load', tone:'warn', v:'1 active (Hill Country Air) — ends 8/25, renewal undecided' },
      { k:'Risk flags', tone:'ok', v:'None on qualifier · P-403 ending-soon flag is placement-side' } ] },
  { id:'M-305', placementNeedId:'N-203', qualifierId:'Q-009', qualifierLicenseId:'L-114', matchStatus:'Possible Fit', fitScore:61, adminApprovalStatus:'Needs More Info', reviewedBy:'Dana Whitfield', reviewedDate:'2026-07-20',
    matchReason:'Trade/state match if verification completes before the 10/1 start.', ineligibilityReason:null,
    factors:[
      { k:'License', tone:'warn', v:'NC SP-L self-reported — verification not started' },
      { k:'Documents', tone:'bad', v:'ID outstanding · experience proof not yet requested' },
      { k:'Availability', tone:'warn', v:'Intake in progress — 10/1 feasible' },
      { k:'Compensation', tone:'ok', v:'Min $2,800 under offer $3,200' },
      { k:'Placement load', tone:'ok', v:'0 active' },
      { k:'Risk flags', tone:'warn', v:'R-604 Missing Documents (Medium)' } ] },
  { id:'M-306', placementNeedId:'N-203', qualifierId:'Q-002', qualifierLicenseId:'L-103', matchStatus:'Not Recommended', fitScore:25, adminApprovalStatus:'Rejected', reviewedBy:'Rose Martinez', reviewedDate:'2026-07-14',
    matchReason:null, ineligibilityReason:'No NC electrical credential — TX Master license has no NC reciprocity path before the target start. Qualifier also prefers TX-only.',
    factors:[
      { k:'License', tone:'bad', v:'TX-only — no NC credential or reciprocity in flight' },
      { k:'Availability', tone:'ok', v:'Available Now' },
      { k:'Compensation', tone:'ok', v:'Min $3,800 over offer $3,200 — would require negotiation' } ] },
  { id:'M-307', placementNeedId:'N-204', qualifierId:'Q-008', qualifierLicenseId:'L-112', matchStatus:'Best Fit', fitScore:95, adminApprovalStatus:'Approved', reviewedBy:'Rose Martinez', reviewedDate:'2026-07-21',
    matchReason:'Premium CA profile — verified Class B, immediate availability, emergency replacement fit.', ineligibilityReason:null,
    factors:[
      { k:'License', tone:'ok', v:'CA B 1088412 · Verified Current through 2/2028' },
      { k:'Availability', tone:'ok', v:'Available Now · CA preferred' },
      { k:'Compensation', tone:'ok', v:'Offer $6,000 clears firm $5,500 floor' },
      { k:'Documents', tone:'ok', v:'Bonding current — renewal quote out (exp 9/10)' },
      { k:'Placement load', tone:'ok', v:'0 active' },
      { k:'Risk flags', tone:'ok', v:'None open' } ] },
  { id:'M-308', placementNeedId:'N-206', qualifierId:'Q-001', qualifierLicenseId:null, matchStatus:'Not Recommended', fitScore:22, adminApprovalStatus:'Hold', reviewedBy:'Dana Whitfield', reviewedDate:'2026-07-22',
    matchReason:null, ineligibilityReason:'No NY GC/HIC credential — licensed FL/GA only. NY bench is currently exhausted; external sourcing required for this need.',
    factors:[
      { k:'License', tone:'bad', v:'No NY credential — FL CGC + GA GC only' },
      { k:'Availability', tone:'ok', v:'1 of 2 slots open' },
      { k:'Risk flags', tone:'warn', v:'Need N-206 flagged — thin NY pool (R-606)' } ] },
];

export const PLACEMENTS = [
  { id:'P-401', companyName:'Summit Restoration Co', qualifierId:'Q-003', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2025-11-01', expectedEndDate:'2026-10-20', actualEndDate:null, monthlyFee:5500, qualifierMonthlyCompensation:4000, ccaMonthlyFee:1500, backupQualifierNeeded:true, backupQualifierIdentified:false, renewalReviewDate:'2026-09-15', internalPlacementNotes:'Pre-OS placement migrated in. Client ran 24 days late on the June invoice (R-607). GA GC bench is thin — no backup identified.' },
  { id:'P-402', companyName:'Gulfside Development', qualifierId:'Q-001', placementNeedId:null, placementMatchId:null, placementStatus:'Active', startDate:'2026-02-01', expectedEndDate:'2027-02-01', actualEndDate:null, monthlyFee:6200, qualifierMonthlyCompensation:4500, ccaMonthlyFee:1700, backupQualifierNeeded:true, backupQualifierIdentified:true, renewalReviewDate:'2026-11-01', internalPlacementNotes:'Healthy relationship. Backup: James Ferraro (Q-005) — agreement rider in review (D-508).' },
  { id:'P-403', companyName:'Hill Country Air', qualifierId:'Q-006', placementNeedId:null, placementMatchId:null, placementStatus:'Ending Soon', startDate:'2025-08-25', expectedEndDate:'2026-08-25', actualEndDate:null, monthlyFee:5000, qualifierMonthlyCompensation:3600, ccaMonthlyFee:1400, backupQualifierNeeded:true, backupQualifierIdentified:false, renewalReviewDate:'2026-07-15', internalPlacementNotes:'Renewal decision OVERDUE (review was 7/15). If renewed, Priya continues; if not, close cleanly and release her second slot.' },
  { id:'P-404', companyName:'Harbor Point Construction', qualifierId:'Q-010', placementNeedId:null, placementMatchId:null, placementStatus:'At Risk', startDate:'2025-12-15', expectedEndDate:'2026-12-15', actualEndDate:null, monthlyFee:7000, qualifierMonthlyCompensation:5000, ccaMonthlyFee:2000, backupQualifierNeeded:true, backupQualifierIdentified:false, renewalReviewDate:'2026-10-15', internalPlacementNotes:'Angela paused for family leave through ~9/15. Client notified; replacement search open as N-206. At risk if leave extends.' },
];

export const REVIEWS = [
  { id:'V-701', qualifierId:'Q-001', relatedPlacementId:'P-402', reviewType:'Placement Review', reliabilityRating:5, communicationRating:5, documentReadinessRating:4, reviewNotes:'Gulfside praises responsiveness. Documents occasionally lag — see insurance lapse.', adminOnly:false, reviewedBy:'Rose Martinez', reviewDate:'2026-06-30' },
  { id:'V-702', qualifierId:'Q-003', relatedPlacementId:'P-401', reviewType:'Placement Review', reliabilityRating:4, communicationRating:3, documentReadinessRating:4, reviewNotes:'Solid on-site presence. Communication gaps during April — coached. Watch for invoice-friction spillover.', adminOnly:true, reviewedBy:'Carmen Delgado', reviewDate:'2026-05-15' },
  { id:'V-703', qualifierId:'Q-006', relatedPlacementId:'P-403', reviewType:'Communication Review', reliabilityRating:5, communicationRating:5, documentReadinessRating:5, reviewNotes:'Model qualifier — pre-empted the renewal conversation with the client.', adminOnly:false, reviewedBy:'Rose Martinez', reviewDate:'2026-07-05' },
  { id:'V-704', qualifierId:'Q-010', relatedPlacementId:'P-404', reviewType:'Risk Review', reliabilityRating:4, communicationRating:4, documentReadinessRating:5, reviewNotes:'Leave handled professionally with 3 weeks notice. Availability risk only — no performance concern.', adminOnly:true, reviewedBy:'Dana Whitfield', reviewDate:'2026-07-18' },
  { id:'V-705', qualifierId:'Q-005', relatedPlacementId:null, reviewType:'Document Readiness Review', reliabilityRating:4, communicationRating:4, documentReadinessRating:2, reviewNotes:'Insurance and credit re-check dragging. 8/15 deadline set before the backup rider can finalize.', adminOnly:true, reviewedBy:'Dana Whitfield', reviewDate:'2026-07-12' },
];

export const RISKS = [
  { id:'R-601', relatedQualifierId:'Q-005', relatedPlacementNeedId:'N-201', relatedActivePlacementId:null, riskType:'License Expiring', riskLevel:'Medium', riskStatus:'Open', owner:'Carmen Delgado', dueDate:'2026-08-15', resolutionNotes:'FL CGC expires 8/30. Renewal filed 7/18 — confirm with DBPR before M-302 can clear.' },
  { id:'R-602', relatedQualifierId:'Q-007', relatedPlacementNeedId:null, relatedActivePlacementId:null, riskType:'Human Review Required', riskLevel:'Critical', riskStatus:'Escalated', owner:'Dana Whitfield', dueDate:'2026-07-29', resolutionNotes:'Expired roofing license + open board inquiry. DNP hold stands until reinstatement docs land and review closes.' },
  { id:'R-603', relatedQualifierId:'Q-006', relatedPlacementNeedId:null, relatedActivePlacementId:'P-403', riskType:'Ending Soon No Backup', riskLevel:'High', riskStatus:'In Review', owner:'Rose Martinez', dueDate:'2026-08-01', resolutionNotes:'Renewal decision overdue (7/15). If non-renewal, no backup identified for Hill Country Air.' },
  { id:'R-604', relatedQualifierId:'Q-009', relatedPlacementNeedId:'N-203', relatedActivePlacementId:null, riskType:'Missing Documents', riskLevel:'Medium', riskStatus:'Open', owner:'Marcus Lee', dueDate:'2026-08-05', resolutionNotes:'ID outstanding — blocks verification and match M-305.' },
  { id:'R-605', relatedQualifierId:'Q-003', relatedPlacementNeedId:null, relatedActivePlacementId:null, riskType:'License Not Verified', riskLevel:'Medium', riskStatus:'Open', owner:'Marcus Lee', dueDate:'2026-08-20', resolutionNotes:'FL roofing license last verified 9/2025 — re-verify before any second engagement.' },
  { id:'R-606', relatedQualifierId:'Q-010', relatedPlacementNeedId:'N-206', relatedActivePlacementId:'P-404', riskType:'Availability Conflict', riskLevel:'High', riskStatus:'In Review', owner:'Rose Martinez', dueDate:'2026-08-10', resolutionNotes:'Qualifier on leave mid-placement. Replacement need N-206 open; NY bench thin — sourcing required.' },
  { id:'R-607', relatedQualifierId:null, relatedPlacementNeedId:null, relatedActivePlacementId:'P-401', riskType:'Payment Issue', riskLevel:'Medium', riskStatus:'In Review', owner:'Carmen Delgado', dueDate:'2026-08-01', resolutionNotes:'June invoice paid 24 days late; July pending. Escalate to leadership if July slips.' },
  { id:'R-608', relatedQualifierId:null, relatedPlacementNeedId:null, relatedActivePlacementId:'P-401', riskType:'Ending Soon No Backup', riskLevel:'Medium', riskStatus:'Open', owner:'Carmen Delgado', dueDate:'2026-09-15', resolutionNotes:'Ends 10/20 with renewal review 9/15 and no backup identified. Start backup search by mid-August.' },
];
