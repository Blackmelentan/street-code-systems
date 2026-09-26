/** Development only: loads fixtures. Production never runs this. */
import fs from 'node:fs';
import { config } from '../src/config.js';
import { openDb, closeDb, one } from '../src/db/database.js';
import { seed, DEMO_PASSWORD } from '../src/db/fixtures.js';

if (config.isProd) { console.error('Refusing to load fixtures in production.'); process.exit(1); }
if (process.argv.includes('--reset')) {
  closeDb();
  for (const suffix of ['', '-wal', '-shm']) { try { fs.rmSync(config.dbFile + suffix); } catch { /* not there */ } }
  console.log('Database reset.');
}
openDb();
if (one('SELECT COUNT(*) AS n FROM users').n > 0) { console.log('The database already has data. Run "npm run reset" to wipe it and re-seed.'); process.exit(0); }
seed({ log: console.log });
console.log(`\nFixtures loaded. Sign in with any fixture phone number and the password "${DEMO_PASSWORD}". (Development only.)`);
