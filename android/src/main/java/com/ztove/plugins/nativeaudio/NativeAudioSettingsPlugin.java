package com.ztove.plugins.nativeaudio;

import com.getcapacitor.JSObject;
import com.getcapacitor.Bridge;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import android.content.Context;
import android.media.AudioManager;
import android.util.Log;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;

@CapacitorPlugin(name = "NativeAudioSettings")
public class NativeAudioSettingsPlugin extends Plugin {
    private AudioManager audioManager;
    private int lastKnownVolume = -1;

    private NativeAudioSettings implementation = new NativeAudioSettings();

    @Override
    public void load() {
        audioManager = (AudioManager) bridge.getActivity().getSystemService(Context.AUDIO_SERVICE);

        BroadcastReceiver listener = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if ("android.media.VOLUME_CHANGED_ACTION".equals(intent.getAction())) {
                    int notificationVolume = audioManager.getStreamVolume(AudioManager.STREAM_NOTIFICATION);
                    int maxNotificationVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION);

                    if (notificationVolume != lastKnownVolume) {
                        lastKnownVolume = notificationVolume;
                        JSObject eventData = generateNotificationVolumeChangeEvent(notificationVolume, maxNotificationVolume);
                        notifyListeners("notificationVolumeChange", eventData);
                    }
                }
            }
        };
        bridge.getActivity().registerReceiver(listener, new IntentFilter("android.media.VOLUME_CHANGED_ACTION"));
    }


    @PluginMethod
    public void echo(PluginCall call) {
        String value = call.getString("value");

        JSObject ret = new JSObject();
        ret.put("value", implementation.echo(value));
        call.resolve(ret);
    }

    @PluginMethod()
    public void getNotificationVolume(PluginCall call) {
        Context context = this.bridge.getActivity();

        AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int notificationVolume = audioManager.getStreamVolume(AudioManager.STREAM_NOTIFICATION);
        int maxNotificationVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION);
    
        JSObject ret = new JSObject();
        ret.put("notificationVolume", notificationVolume);
        ret.put("maxNotificationVolume", maxNotificationVolume);
    
        call.resolve(ret);
    }

    @PluginMethod()
    public void getMainVolume(PluginCall call) {
        Context context = this.bridge.getActivity();

        AudioManager audioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        int mainVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
        int maxMainVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);

        JSObject ret = new JSObject();
        ret.put("mainVolume", mainVolume);
        ret.put("maxMainVolume", maxMainVolume);

        call.resolve(ret);
    }

    private JSObject generateNotificationVolumeChangeEvent(int volume, int maxVolume) {
        var ret = new JSObject();
        ret.put("notificationVolume", volume);
        ret.put("maxNotificationVolume", maxVolume);
        return ret;
    }
}
