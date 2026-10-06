'use strict';

const test = require('node:test');
const assert = require('node:assert');
const { formatPrice, sum, applyDiscount } = require('../src/app.js');

test('formatPrice 加上千分位與幣別', () => {
  assert.strictEqual(formatPrice(1234567), 'TWD 1,234,567');
});

test('formatPrice 拒絕非數字', () => {
  assert.throws(() => formatPrice('abc'), TypeError);
});

test('sum 計算訂單總額', () => {
  assert.strictEqual(sum([{ price: 100, qty: 2 }, { price: 50, qty: 1 }]), 250);
});

test('applyDiscount 計算折扣後金額', () => {
  assert.strictEqual(applyDiscount(1000, 15), 850);
});

test('applyDiscount 拒絕超出範圍的折扣', () => {
  assert.throws(() => applyDiscount(1000, 120), RangeError);
});
