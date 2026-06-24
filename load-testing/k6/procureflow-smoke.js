import http from 'k6/http';
import { check, sleep } from 'k6';
export const options = { vus: 5, duration: '30s', thresholds: { http_req_failed: ['rate<0.01'], http_req_duration: ['p(95)<500'] } };
export default function () {
  const base = __ENV.BASE_URL || 'http://localhost:18080';
  const response = http.get(`${base}/api/orders`);
  check(response, { 'status is 200': r => r.status === 200 });
  sleep(1);
}
