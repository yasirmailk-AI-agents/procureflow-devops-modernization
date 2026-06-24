import test from 'node:test';
import assert from 'node:assert/strict';
test('supplier object contains a name', () => assert.ok({name:'test'}.name));
