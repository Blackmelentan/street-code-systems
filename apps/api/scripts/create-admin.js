/**
 * Create the first administrator on a fresh, empty database:
 *   npm run admin:create -- "Full Name" +2207xxxxxxx
 * The password is read from ADMIN_PASSWORD, or you are prompted. No password is ever printed or stored in a file.
 */
import readline from 'node:readline';
import bcrypt from 'bcryptjs';
import { openDb, run, one } from '../src/db/database.js';
import { newId, normPhone } from '../src/lib/ids.js';
import { ensureProfile } from '../src/routes/me.js';
import { audit } from '../src/services/audit.js';

const [name, phoneRaw] = process.argv.slice(2);
if (!name || !phoneRaw) { console.error('Usage: npm run admin:create -- "Full Name" +2207xxxxxxx'); process.exit(1); }
const ask = () => new Promise((res) => { const rl = readline.createInterface({ input: process.stdin, output: process.stdout }); rl.question('Password (min 12 characters): ', (a) => { rl.close(); res(a); }); });
const password = process.env.ADMIN_PASSWORD || await ask();
if (!password || password.length < 12) { console.error('Use a password of at least 12 characters.'); process.exit(1); }
openDb();
const phone = normPhone(phoneRaw);
if (one('SELECT id FROM users WHERE phone = ?', [phone])) { console.error('That phone number is already registered.'); process.exit(1); }
const id = newId('usr');
run("INSERT INTO users (id, name, phone, password_hash, platform_role) VALUES (?,?,?,?,'admin')", [id, name, phone, bcrypt.hashSync(password, 12)]);
ensureProfile(id, name);
audit({ actor: { id, label: name }, action: 'admin.bootstrap', targetType: 'user', targetId: id });
console.log(`Administrator created: ${name} (${phone}).`);
