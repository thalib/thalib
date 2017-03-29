---
layout: post
title:  "How to Add Audio sound card support in Android"
date:   2017-03-27 11:55:26
categories: Notes
tags: android audio hal driver linux
---

This notes explains how to add audio sound card support in Android OS.

It is assued that you have a working ALSA driver for your sound card and it is getting listed as a alsa sound card.

Here is the output of registed card in a IMX6 SBC.

```
# cat /proc/asound/cards
 0 [imxaudiobtlsr  ]: imx-audio-btlsr - imx-audio-btlsr
                      imx-audio-btlsr
 1 [wm8750audio    ]: wm8750-audio - wm8750-audio
                      wm8750-audio
 2 [imxhdmisoc     ]: imx-hdmi-soc - imx-hdmi-soc
                      imx-hdmi-soc
```

My aim is to integrate the wm8750audio sound card with Android OS and get it working.

### Testing the sound cards

In android there two command for testing audio in command line mode

- tinyplay
- tinycap

To play a audio file

```
# tinyplay OORVASI_OORVASI_KADHALAN_1.wav -D 1
Playing sample: 2 ch, 44100 hz, 16 bit
```

To record a audio file

```
# tinycap rec.wav -D 1
Capturing sample: 2 ch, 44100 hz, 16 bit
Captured 102400 frames
```
### Android Audio HAL

The Audio HAL is a wrapper for the ALSA device nodes, The Audio HAL for imx6 is found in ```<android_src>/hardware/imx/alsa```.

The contents of alsa HAL
```
.
|-- Android.mk
|-- audio_hardware.h
|-- config_hdmi.h
|-- config_nullcard.h
|-- config_spdif.h
|-- config_usbaudio.h
|-- config_wm8750.h       <-- config file for our sound card
|-- control.c
|-- control.h
`-- tinyalsa_hal.c        <-- Audio HAL

```

* The files that start with ```config_``` are configuration file detailing the sound card information.

We have created a file ```config_wm8750.h``` with below contents, the file is simple and self explainatory

```
#ifndef ANDROID_INCLUDE_IMX_CONFIG_WM8750_H
#define ANDROID_INCLUDE_IMX_CONFIG_WM8750_H

#include "audio_hardware.h"

#define MIXER_WM8750_SPEAKER_VOLUME                 "Speaker Playback Volume"
#define MIXER_WM8750_HEADPHONE_VOLUME               "Headphone Playback Volume"
#define MIXER_WM8750_PLAYBACK_VOLUME                "Playback Volume"
#define MIXER_WM8750_CAPTURE_VOLUME                 "Capture Volume"

static struct route_setting speaker_output_wm8750[] = {
    {
        .ctl_name = MIXER_WM8750_PLAYBACK_VOLUME,
        .intval = 230,
    },
    {
        .ctl_name = MIXER_WM8750_SPEAKER_VOLUME,
        .intval = 120,
    },
    {
        .ctl_name = MIXER_WM8750_HEADPHONE_VOLUME,
        .intval = 120,
    },
    {
        .ctl_name = NULL,
    },
};

static struct route_setting mm_main_mic_input_wm8750[] = {
    {
        .ctl_name = MIXER_WM8750_CAPTURE_VOLUME,
        .intval = 60,
    },
    {
        .ctl_name = NULL,
    },
};


/* ALSA cards for IMX, these must be defined according different board / kernel config*/
static struct audio_card  wm8750_card = {
    .name = "wm8750-audio",
    .driver_name = "wm8750-audio",
    .supported_out_devices = (
            AUDIO_DEVICE_OUT_SPEAKER |
            AUDIO_DEVICE_OUT_WIRED_HEADPHONE |
            AUDIO_DEVICE_OUT_AUX_DIGITAL |
            AUDIO_DEVICE_OUT_DEFAULT ),
    .supported_in_devices = (
            AUDIO_DEVICE_IN_BUILTIN_MIC |
            AUDIO_DEVICE_IN_BACK_MIC |
            AUDIO_DEVICE_IN_DEFAULT),
    .defaults            = NULL,
    .bt_output           = NULL,
    .speaker_output      = speaker_output_wm8750,
    .hs_output           = NULL,
    .earpiece_output     = NULL,
    .vx_hs_mic_input     = NULL,
    .mm_main_mic_input   = mm_main_mic_input_wm8750,
    .vx_main_mic_input   = NULL,
    .mm_hs_mic_input     = NULL,
    .vx_bt_mic_input     = NULL,
    .mm_bt_mic_input     = NULL,
    .card                = 0,
    .out_rate            = 0,
    .out_channels        = 0,
    .out_format          = 0,
    .in_rate             = 0,
    .in_channels         = 0,
    .in_format           = 0,
};

#endif  /* ANDROID_INCLUDE_IMX_CONFIG_WM9750_H */
```

Then add below modification in ```tinyalsa_hal.c``` to include the config file

```
...
...
#include "config_wm8750.h"
...
...
...
...
/*"null_card" must be in the end of this array*/
struct audio_card *audio_card_list[SUPPORT_CARD_NUM] = {
    &hdmi_card,
    &usbaudio_card,
    &spdif_card,
    &wm8750_card,   //<-- our card
    &null_card,
};
...
...
```

We have completed the source level modification, you can compile the HAL

```
mmm hardware/imx/alsa/
```

**[or]**

compile the entire Androi source using make

```
make -j12
```

After compilaction load the binares to target device and boot

### Testing

In android the sound are primaryly classified into to Notification and Music

* To test the notification go to ```Setting>Sound``` trying adjusting the volume slider or change the notification/ring tone this will play the notification tone to our device.
* To play music copy some Music file (mp3), then you can play it using Music app in Android
* To record install some audio recording app and do a test record.

### audio_policy.conf

There is one more config file named ```audio_policy.conf``` , this file can located in ```device/``` folder.

```
$ find device/ | grep audio_policy.conf
device/fsl/evk_6sl/audio_policy.conf
device/fsl/evk_6ul/audio_policy.conf
device/fsl/sabresd_6dq/audio_policy.conf
device/fsl/sabreauto_6q/audio_policy.conf
device/fsl/sabreauto_6sx/audio_policy.conf
device/fsl/sabresd_6sx/audio_policy.conf
device/fsl/sabresd_7d/audio_policy.conf
```

Default file work good for our case, So I didn't modify it.

Here is the ```audio_policy.conf``` that worked for me, more about this file can be found on [source.android.com](https://source.android.com/devices/audio/implement-policy.html)

```
global_configuration {
  attached_output_devices AUDIO_DEVICE_OUT_SPEAKER
  default_output_device AUDIO_DEVICE_OUT_SPEAKER
  attached_input_devices AUDIO_DEVICE_IN_BUILTIN_MIC|AUDIO_DEVICE_IN_REMOTE_SUBMIX
}

audio_hw_modules {
  primary {
    outputs {
      primary {
        sampling_rates 44100
        channel_masks AUDIO_CHANNEL_OUT_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_SPEAKER|AUDIO_DEVICE_OUT_WIRED_HEADSET|AUDIO_DEVICE_OUT_WIRED_HEADPHONE|AUDIO_DEVICE_OUT_AUX_DIGITAL|AUDIO_DEVICE_OUT_DGTL_DOCK_HEADSET
        flags AUDIO_OUTPUT_FLAG_PRIMARY
      }
      hdmi {
        sampling_rates dynamic
        channel_masks dynamic
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_AUX_DIGITAL
        flags AUDIO_OUTPUT_FLAG_DIRECT
      }
    }
    inputs {
      primary {
        sampling_rates 8000|11025|16000|22050|24000|32000|44100|48000
        channel_masks AUDIO_CHANNEL_IN_MONO|AUDIO_CHANNEL_IN_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_IN_BUILTIN_MIC|AUDIO_DEVICE_IN_WIRED_HEADSET|AUDIO_DEVICE_IN_USB_DEVICE|AUDIO_DEVICE_IN_DGTL_DOCK_HEADSET
      }
    }
  }
  a2dp {
    outputs {
      a2dp {
        sampling_rates 44100
        channel_masks AUDIO_CHANNEL_OUT_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_ALL_A2DP
      }
    }
    inputs {
     a2dp {
       sampling_rates 44100
       channel_masks AUDIO_CHANNEL_IN_STEREO
       formats AUDIO_FORMAT_PCM_16_BIT
       devices AUDIO_DEVICE_IN_BLUETOOTH_A2DP
     }
    }
  }
  r_submix {
    outputs {
      submix {
        sampling_rates 48000
        channel_masks AUDIO_CHANNEL_OUT_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_REMOTE_SUBMIX
      }
    }
    inputs {
      submix {
        sampling_rates 48000
        channel_masks AUDIO_CHANNEL_IN_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_IN_REMOTE_SUBMIX
      }
    }
  }
 usb {
    outputs {
      usb_accessory {
        sampling_rates 44100
        channel_masks AUDIO_CHANNEL_OUT_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_USB_ACCESSORY
      }
      usb_device {
        sampling_rates 44100
        channel_masks AUDIO_CHANNEL_OUT_STEREO
        formats AUDIO_FORMAT_PCM_16_BIT
        devices AUDIO_DEVICE_OUT_USB_DEVICE
      }
    }
  }
}
```

### Headphone JACK detection

As explained in [source.android.com](https://source.android.com/devices/accessories/headset/jack-headset-spec.html) we need to register the gpio as SW_JACK_PHYSICAL_INSERT switch event. We are doing things with the gpio-keys driver. All we have to is to add below entires in under gpio-keys node in dts file.

```
gpio-keys {
  ...
  ...
  ...
  headphone {
    label = "HeadphoneJack";
    gpios = <&gpio3 3 GPIO_ACTIVE_HIGH>;
    linux,code = <0x07>;
    linux,input-type = <0x05>;
  };
  ...
  ...
};
```

You can test the event with ```getevent``` command. Below log show the getevent output for jack insert and disconnect

```
# getevent
add device 1: /dev/input/event0
  name:     "gpio-keys"
/dev/input/event0: 0005 0007 00000001
/dev/input/event0: 0000 0000 00000000

/dev/input/event0: 0005 0007 00000000
/dev/input/event0: 0000 0000 00000000
```
