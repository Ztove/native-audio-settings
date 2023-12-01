# native-audio-settings

This Capacitor plugin allows retrieving the current media volume level on a device. The plugin includes methods to read the volume level on both Android and iOS platforms.

## Install

```bash
npm install native-audio-settings
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`getMainVolume()`](#getmainvolume)
* [`getNotificationVolume()`](#getnotificationvolume)
* [`addListener('notificationVolumeChange', ...)`](#addlistenernotificationvolumechange)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### getMainVolume()

```typescript
getMainVolume() => Promise<{ mainVolume: number; maxMainVolume: number; }>
```

**Returns:** <code>Promise&lt;{ mainVolume: number; maxMainVolume: number; }&gt;</code>

--------------------


### getNotificationVolume()

```typescript
getNotificationVolume() => Promise<{ notificationVolume: number; maxNotificationVolume: number; }>
```

**Returns:** <code>Promise&lt;{ notificationVolume: number; maxNotificationVolume: number; }&gt;</code>

--------------------


### addListener('notificationVolumeChange', ...)

```typescript
addListener(eventName: 'notificationVolumeChange', listenerFunc: (info: { notificationVolume: number; }) => void) => Promise<{ remove: () => void; }>
```

| Param              | Type                                                            |
| ------------------ | --------------------------------------------------------------- |
| **`eventName`**    | <code>'notificationVolumeChange'</code>                         |
| **`listenerFunc`** | <code>(info: { notificationVolume: number; }) =&gt; void</code> |

**Returns:** <code>Promise&lt;{ remove: () =&gt; void; }&gt;</code>

--------------------

</docgen-api>
