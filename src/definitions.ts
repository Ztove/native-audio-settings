export interface NativeAudioSettingsPlugin {
  getMainVolume(): Promise<{ mainVolume: number; maxMainVolume: number }>;
  getNotificationVolume(): Promise<{ notificationVolume: number; maxNotificationVolume: number }>;
  addListener(eventName: 'notificationVolumeChange', listenerFunc: (info: { notificationVolume: number; maxNotificationVolume: number }) => void): Promise<{ remove: () => void }>;
}
