'use strict';

const test = require('node:test');
const assert = require('node:assert');
const { formatPrice, sum } = require('../src/app.js');

test('formatPrice 加上千分位與幣別', () => {
  assert.strictEqual(formatPrice(1234567), 'TWD 1,234,567');
});

test('formatPrice 拒絕非數字', () => {
  assert.throws(() => formatPrice('abc'), TypeError);
});

test('sum 計算訂單總額', () => {
  assert.strictEqual(sum([{ price: 100, qty: 2 }, { price: 50, qty: 1 }]), 250);
});
