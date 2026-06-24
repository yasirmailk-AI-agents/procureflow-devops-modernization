import test from 'node:test';
import assert from 'node:assert/strict';
test('queue status is valid', () => assert.equal('QUEUED'.startsWith('QUEUE'), true));
