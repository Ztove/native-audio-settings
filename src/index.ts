import { registerPlugin } from '@capacitor/core';

import type { NativeAudioSettingsPlugin } from './definitions';

const NativeAudioSettings = registerPlugin<NativeAudioSettingsPlugin>('NativeAudioSettings', {
  web: () => import('./web').then(m => new m.NativeAudioWeb()),
});

export * from './definitions';
export { NativeAudioSettings };
