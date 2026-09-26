/** Shared domain constants. Kept dependency-free so browsers can import them too. */

export const PLATFORM_ROLES = { USER: 'user', ADMIN: 'admin' };

/** Organisation types a person can belong to. */
export const ORG_TYPES = { GARAGE: 'garage', CARWASH: 'carwash', FLEET: 'fleet', STATION: 'station', PARTS: 'parts', DEALER: 'dealer', RENTAL: 'rental', BROKER: 'broker', CLUB: 'club', SERVICE: 'service' };

/** Roles inside an organisation. Higher rank can manage lower rank. */
export const ORG_ROLES = {
  owner:      { rank: 100, label: 'Owner' },
  manager:    { rank: 80,  label: 'Manager' },
  supervisor: { rank: 70,  label: 'Supervisor' },
  mechanic:   { rank: 50,  label: 'Mechanic' },
  attendant:  { rank: 40,  label: 'Attendant' },
  officer:    { rank: 30,  label: 'Officer' },
  driver:     { rank: 20,  label: 'Driver' },
  sales:      { rank: 45,  label: 'Sales' },
  agent:      { rank: 45,  label: 'Agent' },
  member:     { rank: 10,  label: 'Member' },
};

export const ROLES_BY_ORG = {
  garage:  ['owner', 'manager', 'mechanic', 'attendant'],
  carwash: ['owner', 'manager', 'attendant'],
  fleet:   ['owner', 'manager', 'driver'],
  station: ['owner', 'supervisor', 'officer'],
  parts:   ['owner', 'manager', 'attendant'],
  dealer:  ['owner', 'manager', 'sales'],
  rental:  ['owner', 'manager', 'attendant'],
  broker:  ['owner', 'manager', 'agent'],
  club:    ['owner', 'manager', 'member'],
  service: ['owner', 'manager', 'attendant'],
};

export const EMPLOYMENT = ['owner', 'employee', 'contractor'];

/** Flags: what the police can put on a vehicle or a person. */
export const FLAG_KINDS = {
  stolen:              { label: 'Stolen vehicle',       subject: 'vehicle', defaultLevel: 'red',   needsApproval: false },
  unauthorized_use:    { label: 'Unauthorised use',     subject: 'vehicle', defaultLevel: 'red',   needsApproval: false },
  vehicle_of_interest: { label: 'Vehicle of interest',  subject: 'vehicle', defaultLevel: 'amber', needsApproval: false },
  amber:               { label: 'Amber alert',          subject: 'vehicle', defaultLevel: 'amber', needsApproval: true },
  wanted:              { label: 'Wanted person',        subject: 'person',  defaultLevel: 'red',   needsApproval: true },
  person_of_interest:  { label: 'Person of interest',   subject: 'person',  defaultLevel: 'amber', needsApproval: true },
};

export const FLAG_INSTRUCTIONS = {
  observe:        'Observe and report. Do not approach.',
  call_dispatch:  'Call dispatch before any contact.',
  detain:         'Detain and secure the vehicle.',
  do_not_approach:'Do not approach. Armed or dangerous.',
  verify_owner:   'Verify the driver is authorised by the owner.',
};

export const CHECK_REASONS = [
  'Routine checkpoint',
  'Suspected stolen vehicle',
  'Expired documents',
  'Safety or lighting defect',
  'Traffic offence',
  'Active alert or APB',
  'Accident scene',
];

export const CHECK_OUTCOMES = ['clear', 'advisory', 'action_required', 'flag_hit'];

export const JOB_STATUS = ['requested', 'quoted', 'accepted', 'in_progress', 'ready', 'completed', 'cancelled'];

export const MAX_ODOMETER_JUMP_PER_DAY = 1500; // km/day: above this a reading is treated as suspicious

/**
 * The nine account types from the product design. One person can hold several ("Owner + Collector").
 * Business personas need an organisation and verification before they can go live.
 */
export const PERSONAS = {
  owner:     { icon: 'car',     business: false },
  collector: { icon: 'trophy',  business: false },
  fleet:     { icon: 'truck',   business: true,  orgType: 'fleet' },
  garage:    { icon: 'wrench',  business: true,  orgType: 'garage' },
  parts:     { icon: 'box',     business: true,  orgType: 'parts' },
  driver:    { icon: 'wheel',   business: false },
  dealer:    { icon: 'store',   business: true,  orgType: 'dealer' },
  rental:    { icon: 'key',     business: true,  orgType: 'rental' },
  broker:    { icon: 'shield',  business: true,  orgType: 'broker' },
};

/** Everyone who works around cars. A garage is a place; a trade is what someone is good at. */
export const TRADES = ['mechanic', 'auto_electrician', 'ac_repair', 'panel_beater', 'programmer', 'tyres', 'detailing', 'glass', 'upholstery', 'towing', 'general'];
export const SERVICE_CATEGORIES = ['fuel', 'ev_charging', 'tyres', 'towing', 'panel_beater', 'auto_electrician', 'ac_repair', 'tuner', 'detailing', 'carwash', 'glass', 'upholstery'];
export const PART_CATEGORIES = ['brakes', 'suspension', 'filters_fluids', 'engine', 'electrical', 'body', 'tyres_wheels', 'cooling_ac', 'transmission', 'accessories'];
export const PART_TIERS = ['oem', 'aftermarket', 'recycled'];
export const CURRENCIES = ['GMD', 'USD', 'EUR', 'GBP'];

/** Platform fee schedule (fractions). Shown to people before they pay; never a surprise. */
export const FEES = { escrow: 0.025, ride: 0.07, booking: 0.075, sale: 0.015 };
export const RIDE = { baseMinor: 5000, perKmMinor: 3500, minMinor: 15000, roadFactor: 1.3, acceptSeconds: 30 };
export const AUCTION = { minIncrementPct: 0.02, minIncrementMinor: 5000, extendWithinSec: 300, extendBySec: 300, payWithinHours: 48 };
