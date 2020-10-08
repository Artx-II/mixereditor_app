# Mixer Editor

This apps allows modifications to your mixer_paths.xml file, allowing the increase or decrease of Gain of Input/Output peripherals. You only need to add support for your device (By knowing which lines of the mixer_paths modifies the Gain of your Speaker, headphones, mic, etc...) and have root to apply such modifications to the partition containing the mixer_paths file.

## How to add support to my Device

There is a folder named "devices" on this repository, inside that you have to crease a .json file with the name of your device, for example "bacon.json" (Oneplus One). Inside that .json file you will write your device name, partition where your mixer_paths is located (For the app to mount it) and your mixer_paths file location, those are the three required parameters.

Once that is done, you can specify the exact line where the app will modifiy the Gain value of the corresponding Input/Output device, these are optional (you don't have to specify all of them) and only those that are configured in the .json file will show up in the app.

## Json file format

This is an example of how the Json file would be written:

```yaml
{
    "device": "curtana",
    "mountPartition": "/vendor",
    "filePath": "/vendor/etc/mixer_paths_wcd937x.xml",
    "headphoneLines": [ 3003, 3004 ],
    "speakerLine": 20,
    "earpieceLine": ...,
    "micBottomLine": ...,
    "micTopLine": ...,
}
```

An Example can be found in the "devices" within this project.
