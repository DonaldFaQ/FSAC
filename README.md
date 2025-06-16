# FSAC

**FSAC** (_**FS** **A**udio **C**onverter_) is a Frameserver based CLI tool for audio encoding.
You need an installed AviSynth+ frameserver to be able to use this tool.  
Encoding engine is FFmpeg. For Atmos files, Dolby Reference Player is needed additionally.

_Supported output codecs:_
* PCM (WAV)
* LPCM (WAVE 64 / CAF)
* FLAC
* AC3 (Dolby Digital)
* E-AC3 (Dolby Digital Plus ⚠️ _UNSIGNED_)
* AAC

_Supported input:_  
* all FFmpeg compatible audio codecs
* the following containers: `MKV` `MKA` `M2TS` `TS` `AVI` `EVO` `VOB`

❗REQUIRED 3RD PARTY TOOLS MUST BE DOWNLOAD HERE:❗  
[![Tools Download on MEGA](https://i.ibb.co/CzHqWx9/MEGA.png)](https://mega.nz/folder/NhdS3aTD#W97ktr4bpBkUbB5c2WOxqw)

## FSAC_Options.cmd

A script for setting the general options of FSAC.

| Category                      | Option                       | Description |
|------------------------------ |------------------------------|-------------|
| FOLDERS                       | `O` `T` `R`                  | Set the local paths for: **O**utputs of the tool, its **T**emp folder, and the installed Dolby **R**eference Player.|
| SETTINGS: Mono WAVs Layout    | `L`                          | Channel naming of splitted mono WAV files. `DTS-HD Master Audio Suite` renames all files correctly for that DTS Suite.|
| BITRATES menu: `1`            | WAV: Bitdepth / Auto Bitdepth| Set the standard Bit depth for PCM files. If `Auto Bitdepth` is set, the tool will use the bit depth found in the source file.|
|                               | other codecs                 | Set bit depths, bit rates or quality for a variety of common audio codecs.|
| MISC menu: `2`                | Dolby Atmos Demuxing         | `ENABLED` supports demuxing of Atmos files with following Layouts: `9.1.6` `7.1.4` `7.1.2` `5.1.4` `5.1.2`.<br>⚠️For Atmos demuxing, you need Dolby Reference Player installed on your system❗|
|                               | Dolby Atmos Priority         | When `ENABLED`, FSAC automatically changes the preselected channel layout to `9.1.6 [ATMOS]` when demuxing a file (and only if Dolby Atmos Demuxing is also `ENABLED`). Channel layout can still be changed afterwards.|
|                               | Dolby Atmos Nameset          | Nameset for the Channel Layouts for Atmos demuxing to Mono WAVs.<br>_Example Templates:_<br>* FFmpeg preset: `FL FR FC LFE SL SR BL BR WL WR TFL TFR TSL TSR TBL TBR`<br>* shebdabe preset: `L R C LFE SL SR BL BR WL WR T_FL T_FR T_SL T_SR T_BL T_BR`<br>* Numeric preset: `01_FL 02_FR 03_FC 04_LFE 05_SL 06_SR 07_BL 08_BR 09_WL 10_WR 11_TFL 12_TFR 13_TSL 14_TSR 15_TBL 16_TBR`|
|                               | LPCM Container               | Set the container for Multichannel LPCM encoding to `WAV` (WAVE 64 Container) or `CAF`.|
|                               | Standard Loudness            | `ORIGINAL`: no changes<br>`NORMALIZED`: raise volume until highest peak reaches −1 dB<br>`DIALNORM -31dB`: Analyze [DialNorm](https://en.wikipedia.org/wiki/Dialnorm) of source file, then raise volume (dB) until DialNorm −31 dB is reached.|
|                               | Short Filenames              | `ENABLED`: Removes all additional info from output filenames for shorter output file names. Helpful if path is too long or file names get confusing. |
|                               | Logfile                      | `ENABLED`: Writes an additional log file next to the output file (identical naming).|
|  Shell Extensions             | Create (`3`) / Delete (`4`)  | Create system-wide right click context menu items for files to use FSAC.<br>⚠️With activated Windows UAC, start the script as administrator, otherwhise the registry settings cannot be written❗ |


## FSAC.cmd

The main FSAC script.

### Usage with CLI Gui
* Open a file/container with this script (`FS_Audio_Converter.cmd MyMovie.mkv`)
* _OR_ drag and drop a file over this script
* _OR_ use Shell Extension menu

### Settings
| Setting                  | Options |
|--------------------------|---------|
| Stream                   | If the input is a container with multiple streams, select the stream you want to encode.|
| DRC                      | Remove [Dynamic range compression](https://en.wikipedia.org/wiki/Dynamic_range_compression) (DRC) from files. Default `OFF` ≙ removes DRC.|
| Codec                    | Choose your output codec.|
| Channel Layout           | Can only be changed when demuxing Atmos. Sets the Atmo Channel Layout..|
| Sample Rate              | Sample rate in kHz for output files. Default `ORIGINAL`. Options `48000` `44100` `22050`.|
| Tempo                    | Change the tempo of the output file. Supported framerates: Slow-down or speed-up between `25` `24` `23,976` fps.|
| Pitch Correction         | Along with the tempo change, you can opt to use pitch correction:<br>`YES`: resulting pitch will be identical with source, but the tempo is changed<br>`NO`: resulting pitch will be higher/lower than source file (depending on the tempo change).<br>If no tempo change is applied above, you can still change the pitch without tempo change. Supported framerates (fps): `25` `24` `23,976` slow-down or speed-up.|
| Delay                    | Set a Delay in Milliseconds for output file. Just type the number without "ms". For negative delay use `-` before the number.
| Amplify                  | Set amplification in dB for output file. Just type the number without "dB". For negative amplification, use `-` before the number.<br>There are also some predefined options:<br>`ORIGINAL`: No changes (same result as Amplify `0`).<br>`DIALNORM`: Analyze DialNorm of source file, then raise volume (dB) until DialNorm −31 dB is reached.<br>`NORMALIZED`: raise volume until highest peak reaches −1 dB.|
| Save Settings            | Saves all settings. This is helpful e.g. for TV shows where you have to encode many files with the same adjusted settings.|

### Usage with Cammand Lines (v0.70 and higher).
* Open a file/container with this script (`FSAC.cmd MyMovie.mkv`) and the switch(es) behind.
* Open this script (`FSAC.cmd`) and see all available switches.
* Example:
* FSAC.cmd MyMovie.mkv `--index-1` `--DRC-off` `--Tempo25to23976p` `--Dir-C:\MyAudio`

### Settings
| Switches                 | Options |
|--------------------------|---------|
| --Index-`NUMBER`         | Number of Index in container you would decode. Leave empty for the first valid audio stream. ❗SELECT ONLY ONE INDEX❗|
| --DRC-`ON` `OFF`         | Remove [Dynamic range compression](https://en.wikipedia.org/wiki/Dynamic_range_compression) (DRC) from files. Default `OFF` ≙ removes DRC.|
| --Tempo-`25to23976` `p`  | Change the tempo of the output file. Supported framerates: Slow-down or speed-up between `25` `24` `23,976` fps. `p` means with Pitch correction.|
|         `25to24` `p`     |
|         `24to23976` `p`  |
|         `23976to25` `p`  |
|         `24to25` `p`     |
|         `23976to24` `p`  |
| --Pitch-`25to23976`<br>`25to24`      | Change pitch without speed changes. ❗DO NOT USE THE SWITCH --Tempo and --Pitch TOGETHER❗|
|         `25to24`         |
|         `23976to25`      |
|         `24to25`         |
| --Codec-`LPCM`           | Choose your output codec. [] Codecs only available for Atmos decoding.|
|         `MONOWAVs`       |
|         `FLAC`           |
|         `AC3`            |
|         `EAC3`           |
|         `AAC`            |
|         `Atmos-LPCM`     | ❗ONLY FOR ATMOS DECODING WITH INSTALLED DOLBY REFERENCE PLAYER❗|
|         `Atmos-MONOWAVs` | ❗ONLY FOR ATMOS DECODING WITH INSTALLED DOLBY REFERENCE PLAYER❗|
| --Delay-`ms`             | Set a Delay in Milliseconds for output file. Just type the number without "ms". For negative delay use `-` before the number.|
| --Amplify-`dB`           | Set amplification in dB for output file. Just type the number without "dB". For negative amplification, use `-` before the number.|
|	        `ORIGINAL`     | No changes (same result as Amplify `0`).|
|			`DIALNORM`     | Analyze DialNorm of source file, then raise volume (dB) until DialNorm −31 dB is reached.|
|           `NORMALIZED`   | Raise volume until highest peak reaches −1 dB.|
| --Dir-`<Path>`           | Set output directory ❗WITHOUT `""`❗|

* For Multindexing and start from a own batch file, take a look at the file `multiindex_example.cmd`.