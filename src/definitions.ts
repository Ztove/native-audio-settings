export interface NativeAudioSettingsPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
  getMainVolume(): Promise<{ mainVolume: number; maxMainVolume: number }>;
  getNotificationVolume(): Promise<{ notificationVolume: number; maxNotificationVolume: number }>;
  addListener(eventName: 'notificationVolumeChange', listenerFunc: (info: { notificationVolume: number }) => void): Promise<{ remove: () => void }>;
}
