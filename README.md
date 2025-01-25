# FSAC
=======================================================================================================================================
FS Audio Converter is a FrameServer based CLI Tool for audio encoding. You need an installed Avisynth+ Frameserver for using this tool.
Encoding engine is FFMPEG (for Atmos files Dolby Reference Player + FFMPEG). 
Supported Output Codecs: PCM (WAV)
                         LPCM (WAVE 64 / CAF)
                         FLAC
                         AC3
                         E-AC3 (UNSIGNED)
                         AAC

==============================
FS_Audio_Converter_Options.cmd
==============================
Options script for settings.
------------------------------

-Mono wavs Layout             = Channel naming of mono wav files. DTS-HD Master Suite renames all files correctly for the DTS-HD Master Suite.
-WAV Bitdepth / Auto Bitdepth = Set the standard Bitdepth for PCM files. If Auto Bitdepth is set and the tool found bitdepth
                                in source file this bitdepth will be used. Atmos bitdepth will set seperatly in menu.
-Dolby Atmos Demuxing         = Supports demuxing from Atmos files in following Layouts: 9.1.6/7.1.4/7.1.2/5.1.4/5.1.2.
                                FOR ATMOS DEMUXING YOU NEED DOLBY REFERENCE PLAYER INSTALLED ON YOUR SYSTEM!
-Dolby Atmos Priority         = If Dolby Atmos Demuxing is enabled the tool changes the first channel layout to 9.1.6 with Atmos files.
-Dolby Atmos Nameset          = Nameset for the Channel Layout for Atmos demuxing in Mono WAVs. Example Templates:
                                FFMPEG preset:
                                FL,FR,FC,LFE,SL,SR,BL,BR,WL,WR,TFL,TFR,TSL,TSR,TBL,TBR

                                shebdabe preset:
                                L,R,C,LFE,SL,SR,BL,BR,WL,WR,T_FL,T_FR,T_SL,T_SR,T_BL,T_BR

                                Numeric preset:
                                01_FL,02_FR,03_FC,04_LFE,05_SL,06_SR,07_BL,08_BR,09_WL,10_WR,11_TFL,12_TFR,13_TSL,14_TSR,15_TBL,16_TBR
-LPCM Container               = WAV/CAF You can set the Container for Multichannel LPCM encoding. WAV = WAVE 64 Container.
-Standard Loudness            = ORIGINAL - No changes
                                DIALNORM -31dB - Analysing dialnorm in file and raise volume x dB till dialnorm -31dB is reached.
                                NORMALIZED - raised volume till highest peak reaches -1dB.
-Short Filenames              = Removes all infos from output filenames for smaller filenames.
-Logfile                      = Create logfile or not.
-Create Shell Extensions      = Create Shell Extensions for right click menu of a file.
                                WITH ACTIVATED UAC START THE SCRIPT AS ADMINISTRATOR OTHERWHISE THE REGISTRY SETTINGS CANNOT BE WRITE!

======================
FS_Audio_Converter.cmd
======================
Mainscript.
----------------------

Support:                        All FFMPEG compatible audio codecs and following container: MKV/MKA/M2TS/TS/AVI/EVO/VOB
Usage:                          Open a file/container with this script (FS_Audio_Converter.cmd mymovie.mkv) or drag and drop a file over
                                this script or use Shell Extension menu.

-Stream                       = If input is a container file select the stream for encoding.
-DRC                          = Removes DRC (Dynamic range compression) from files. Standard: OFF.
-Codec                        = Choose your encoding codec.
-Channel Layout               = Only available for Atmos demuxing. Set here the Atmos Channel Layout.
-Sample Rate                  = Sample rate for output file. Standard: ORIGINAL.
-Tempo                        = You can change the tempo of the output file. Supported framerates: 25fps/24fps/23,976fps
-Pitch Correction             = If tempo changed you can set the pitch correction on/off. If tempo not changed, you can
                                change the pitch without tempo changes. Supported framerates: 25fps/24fps/23,976fps
-Delay                        = You can set a Delay in ms for output file. For negative delay use -x ms.
-Amplify                      = Set Amplify of target file. For negative Amplify use -x dB. You can also use some pre defined options:
                                ORIGINAL - No changes (will be set if Amplify is set to 0).
                                DIALNORM -31dB - Analysing dialnorm in file and raise volume x dB till dialnorm -31dB is reached.
                                NORMALIZED - raised volume till highest peak reaches -1dB.
-Save Settings                = Saves all settings. This is helpful for TV-shows, if u must encode many files with same settings.
