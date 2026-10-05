'use strict';

// 將金額加上千分位與幣別，例如 1234567 → TWD 1,234,567
function formatPrice(amount, currency = 'TWD') {
  if (typeof amount !== 'number' || Number.isNaN(amount)) {
    throw new TypeError('amount 必須是數字');
  }
  const text = Math.round(amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  return `${currency} ${text}`;
}

// 計算訂單總額：每個品項為 { price, qty }
function sum(items) {
  return items.reduce((total, item) => total + item.price * item.qty, 0);
}

// 依百分比計算折扣後金額，例如 applyDiscount(1000, 15) → 850
function applyDiscount(amount, percent) {
  if (percent < 0 || percent > 100) {
    throw new RangeError('percent 必須介於 0 到 100');
  }
  return Math.round(amount * (100 - percent) / 100);
}

module.exports = { formatPrice, sum, applyDiscount };
