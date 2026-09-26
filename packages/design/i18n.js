/**
 * Street Code language layer.
 * Four registers: en (Standard English), st (Pavement/Street), fr (French), wo (Wolof).
 * "Street" is not a separate language — it's the same English UI in Gambian youth slang.
 * People can switch anytime in Me > Language; it is saved to their profile (lang field).
 *
 * IMPORTANT: st and wo entries here are a first pass, not verified by native/street speakers.
 * Flag anything that reads wrong before launch — see docs/GAP-ANALYSIS.md.
 */
export const LANGS = { en: 'English', st: 'Street', fr: 'Français', wo: 'Wolof' };

const DICT = {
  // ---- nav ----
  nav_garage:   { en: 'Garage',   st: 'Ride Spot',  fr: 'Garage',      wo: 'Garaas' },
  nav_feed:     { en: 'Feed',     st: 'Street Feed', fr: 'Fil',        wo: 'Feed bi' },
  nav_drive:    { en: 'Drive',    st: 'Wheels',      fr: 'Conduire',   wo: 'Dawal' },
  nav_market:   { en: 'Market',   st: 'Plug',        fr: 'Marché',     wo: 'Marse' },
  nav_wallet:   { en: 'Wallet',   st: 'Pocket',       fr: 'Portefeuille', wo: 'Wallet' },
  nav_alerts:   { en: 'Alerts',   st: 'Heads Up',     fr: 'Alertes',   wo: 'Xibaar' },
  nav_work:     { en: 'Work',     st: 'My Hustle',    fr: 'Travail',   wo: 'Liggéey' },
  nav_me:       { en: 'Me',       st: 'Me',           fr: 'Moi',       wo: 'Man' },

  // ---- garage / service engine ----
  service_due:      { en: 'Service due',       st: 'Wagon due for check',  fr: 'Entretien à faire', wo: 'Bëgg entretien' },
  on_track:         { en: 'On track',          st: 'We solid',             fr: 'En bonne voie',     wo: 'Baax na' },
  due_soon:         { en: 'Due soon',          st: 'Nearly due, no cap',   fr: 'Bientôt à faire',   wo: 'Di ñëw' },
  overdue:          { en: 'Overdue',           st: 'You sleeping on this', fr: 'En retard',         wo: 'Jàll na' },
  seriously_overdue:{ en: 'Seriously overdue', st: 'Choyi go check am now',fr: 'Très en retard',    wo: 'Jàll na lool' },
  log_service:      { en: 'Log service',       st: 'Drop the log',         fr: 'Enregistrer',       wo: 'Bind' },
  add_vehicle:      { en: 'Add vehicle',       st: 'Add your ride',        fr: 'Ajouter un véhicule', wo: 'Yokk oto' },
  finish_line:      { en: 'Finish line',       st: 'Finish line',          fr: "Ligne d'arrivée",   wo: 'Njeexit' },
  self_reported:    { en: 'Self-reported',     st: 'You said so',          fr: 'Auto-déclaré',      wo: 'Sa bopp a wax' },
  sealed:           { en: 'Sealed',            st: 'Verified fr fr',       fr: 'Certifié',          wo: 'Wóor na' },

  // ---- lending / drive ----
  lend_vehicle:  { en: 'Lend this vehicle', st: 'Put your guy on', fr: 'Prêter ce véhicule', wo: 'Jébbal oto bi' },
  start_drive:   { en: 'Start',             st: 'Pull off',        fr: 'Démarrer',           wo: 'Dawal' },
  end_drive:     { en: 'End drive',         st: 'Park am',         fr: 'Terminer le trajet', wo: 'Taxaw' },
  driving_now:   { en: 'Driving now',       st: "You're rolling",  fr: 'En conduite',        wo: 'Danga dawal' },
  take_it_back:  { en: 'Take it back',      st: 'Pull the keys back', fr: 'Reprendre',        wo: 'Jël ko' },

  // ---- police / verdict (kept plain and unambiguous on purpose) ----
  verdict_clear:  { en: 'Clear',            st: 'You good',       fr: 'Rien à signaler',    wo: 'Baax na' },
  verdict_flag:   { en: 'Flag match',       st: 'Flag match',     fr: 'Alerte signalée',    wo: 'Am na jafe-jafe' },

  // ---- marketplace / culture ----
  for_sale:        { en: 'For sale',          st: 'Up for grabs',       fr: 'À vendre',          wo: 'Ngiy jaay' },
  place_bid:       { en: 'Place bid',         st: 'Drop your bid',      fr: 'Enchérir',          wo: 'Sant lu bare' },
  make_offer:      { en: 'Make an offer',     st: 'Shoot your shot',    fr: 'Faire une offre',   wo: 'Def offer' },
  buy_now:         { en: 'Buy now',           st: 'Cop it now',         fr: 'Achat immédiat',    wo: 'Jënd léegi' },
  showcase_car:    { en: 'Showcase this car', st: 'Flex this ride',     fr: 'Mettre en avant',   wo: 'Wone oto bi' },
  build_log:       { en: 'Build log',         st: 'Build diary',        fr: 'Journal de projet', wo: 'Liggéey bi' },
  follow:          { en: 'Follow',            st: 'Rock with',          fr: 'Suivre',            wo: 'Topp' },
  track_it_down:   { en: 'Track it down',     st: 'Track it down',      fr: 'Le retrouver',      wo: 'Wut ko' },
  my_collection:   { en: 'My collection',     st: 'My whip lineup',     fr: 'Ma collection',     wo: 'Samay oto' },

  // ---- wallet ----
  balance:      { en: 'Balance',      st: 'Balance',    fr: 'Solde',       wo: 'Xaalis' },
  withdraw:     { en: 'Withdraw',     st: 'Cash out',    fr: 'Retirer',    wo: 'Génne xaalis' },
  add_number:   { en: 'Add a number', st: 'Link your number', fr: 'Ajouter un numéro', wo: 'Yokk nimero' },

  // ---- generic ----
  save:      { en: 'Save',    st: 'Lock it in', fr: 'Enregistrer', wo: 'Denc' },
  cancel:    { en: 'Cancel',  st: 'Nah',         fr: 'Annuler',     wo: 'Bàyyi' },
  loading:   { en: 'Loading…', st: 'Hol up…',    fr: 'Chargement…', wo: 'Di xaar…' },
  sign_out:  { en: 'Sign out', st: 'Dip out',    fr: 'Déconnexion', wo: 'Génn' },
};

let current = 'en';
export function setLang(lang) { current = LANGS[lang] ? lang : 'en'; document.documentElement.setAttribute('lang', current === 'wo' || current === 'st' ? 'en' : current); }
export function getLang() { return current; }
export function t(key) { const e = DICT[key]; if (!e) return key; return e[current] || e.en || key; }
