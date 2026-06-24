import express from 'express';
import client from 'prom-client';

const app = express();
const port = Number(process.env.PORT || 8080);
app.use(express.json());
client.collectDefaultMetrics({ prefix: 'procureflow_supplier_' });
const suppliers = [
  { id: 1, name: 'Nordic Components', status: 'APPROVED', risk: 'LOW' },
  { id: 2, name: 'Baltic Logistics', status: 'REVIEW', risk: 'MEDIUM' }
];
app.get('/api/suppliers/health', (_req, res) => res.json({ status: 'UP', service: 'supplier-service' }));
app.get('/api/suppliers', (_req, res) => res.json({ count: suppliers.length, suppliers }));
app.post('/api/suppliers', (req, res) => { const supplier = { id: suppliers.length + 1, status: 'REVIEW', risk: 'UNKNOWN', ...req.body }; suppliers.push(supplier); res.status(201).json(supplier); });
app.get('/metrics', async (_req, res) => { res.type(client.register.contentType); res.send(await client.register.metrics()); });
app.listen(port, '0.0.0.0', () => console.log(`supplier-service listening on ${port}`));
