import express from 'express';
import client from 'prom-client';

const app = express();
const port = Number(process.env.PORT || 8080);
client.collectDefaultMetrics({ prefix: 'procureflow_frontend_' });
const requests = new client.Counter({ name: 'procureflow_frontend_http_requests_total', help: 'Frontend HTTP requests', labelNames: ['path', 'status'] });

app.use(express.json());
app.use((req, res, next) => { res.on('finish', () => requests.inc({ path: req.path, status: String(res.statusCode) })); next(); });
app.get('/health', (_req, res) => res.json({ status: 'UP', service: 'procureflow-frontend' }));
app.get('/metrics', async (_req, res) => { res.type(client.register.contentType); res.send(await client.register.metrics()); });
app.get('/', (_req, res) => res.type('html').send(`<!doctype html><html><head><title>ProcureFlow</title><style>body{font-family:Arial;margin:40px;max-width:900px}code{background:#eee;padding:3px}</style></head><body><h1>ProcureFlow</h1><p>Local procurement platform modernization lab is running.</p><h2>Routes</h2><p><code>/api/suppliers</code> <code>/api/orders</code> <code>/api/approvals</code> <code>/api/integration</code> <code>/api/notifications</code></p></body></html>`));
app.listen(port, '0.0.0.0', () => console.log(`frontend listening on ${port}`));
