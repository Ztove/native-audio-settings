import { WebPlugin } from '@capacitor/core';

import type { NativeAudioSettingsPlugin } from './definitions';

export class NativeAudioWeb extends WebPlugin implements NativeAudioSettingsPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async getMainVolume(): Promise<{ mainVolume: number; maxMainVolume: number }> {
    return { mainVolume: 0, maxMainVolume: 0 };
  }

  async getNotificationVolume(): Promise<{ notificationVolume: number; maxNotificationVolume: number }> {
    return { notificationVolume: 0, maxNotificationVolume: 0 };
  }
}
