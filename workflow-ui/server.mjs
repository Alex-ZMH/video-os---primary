import http from 'node:http';
import fs from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const portArg = process.argv.find((arg) => arg.startsWith('--port='));
const port = Number(portArg?.slice(7) || process.env.WORKFLOW_UI_PORT || 3117);
const defaults = path.join(root, 'workflow-prompts.json');
const localConfig = path.join(root, 'workflow-prompts.local.json');

const mime = {
  '.html': 'text/html; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8'
};

async function readConfig() {
  try { return JSON.parse(await fs.readFile(localConfig, 'utf8')); }
  catch { return JSON.parse(await fs.readFile(defaults, 'utf8')); }
}

function send(res, status, body, type = 'application/json; charset=utf-8') {
  res.writeHead(status, {'Content-Type': type, 'Cache-Control': 'no-store'});
  res.end(typeof body === 'string' ? body : JSON.stringify(body, null, 2));
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, `http://${req.headers.host}`);
    if (req.method === 'GET' && url.pathname === '/api/config') return send(res, 200, await readConfig());
    if (req.method === 'POST' && url.pathname === '/api/config') {
      let body = '';
      for await (const chunk of req) body += chunk;
      const config = JSON.parse(body);
      config.savedAt = new Date().toISOString();
      await fs.writeFile(localConfig, JSON.stringify(config, null, 2) + '\n', 'utf8');
      return send(res, 200, {ok: true, savedAt: config.savedAt});
    }
    if (req.method !== 'GET') return send(res, 405, {error: 'method_not_allowed'});
    const requested = url.pathname === '/' ? '/index.html' : url.pathname;
    const file = path.resolve(root, `.${requested}`);
    if (!file.startsWith(root + path.sep)) return send(res, 403, {error: 'forbidden'});
    const data = await fs.readFile(file);
    res.writeHead(200, {'Content-Type': mime[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'no-store'});
    res.end(data);
  } catch (error) {
    if (error.code === 'ENOENT') return send(res, 404, {error: 'not_found'});
    send(res, 400, {error: error.message});
  }
});

server.listen(port, '127.0.0.1', () => {
  console.log(`Prompt workflow window: http://127.0.0.1:${port}`);
  console.log(`Saved edits: ${localConfig}`);
});
