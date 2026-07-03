import test from 'node:test';
import assert from 'node:assert/strict';

import { loadSources, generate } from './generate-app-content.mjs';

test('shared content validates required keys', () => {
  const { content, contentSchema } = loadSources();
  for (const key of contentSchema.required) {
    assert.ok(key in content);
  }
});

test('shared theme validates required keys', () => {
  const { theme, themeSchema } = loadSources();
  for (const key of themeSchema.required) {
    assert.ok(key in theme);
  }
});

test('generator runs without throwing', () => {
  assert.doesNotThrow(() => generate());
});
