# UltraNoise

## What is Ultra Noise 

UltraNoise is a Node base processing tool for the Unity Editor. It has been initially designed to help with procedural map generation, and further extended to
object placement. Our team makes use of it mostly for gamejams due a few limitations described afterwards. UltraNoise contains all the logic built in 
Scriptable Objects and allows you to sample any coordinate in any dimension, it also contains different tools to handle each problem separately:

* Procedural Object Placement and Distrubuction
* Procedural Terrain Creation
* Procedural Terran Painting

| | |
|------------|-------------|
|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Sample1.png">|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Sample2.png">|
|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Sample3.png">|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Sample4.png">|

## Under the Hood

WARNING!!
The tool uses Odin Inspector… A Lot. 
Until now our main goal was to provide a tool that works and is optimized and we did not want to waste time fighting with the Unity Editor.
Therefore, for the time being in order to use this tool you would have to get the Odin Inspector.
We have considered removing it but that's not in the plans yet.

UltraNoise’s power also surges from the following awesome free frameworks and Plugins:

* [xNode](https://github.com/Siccity/xNode)
* [Procedural Noise](https://github.com/Scrawk/Procedural-Noise/)
* [OdinInspector](https://odininspector.com/)

## Features

| 27 Nodes | Terrain Forger |
|------------|-------------|
|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Nodes.png">| <img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/Terrain.png">|
|Placement Tool| Easy Code Sample |
|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/PlacementTool.png">|<img width="300" height="250" src="https://github.com/KillMobil-SA/UltraNoiseExamples/blob/main/ReadmeImages/CodeSample.png">|

## How to Use UltraNoise
1. Add Editor Coroutines in your Package Manager
2. Add Odin Inspector
3. Get the Ultra Noise Source From (https://github.com/KillMobil-SA/UltraNoiseNodeGraph)
4. You are Ready to GO!

## How to learn Ultra Noise
The Best way to get started with UltraNoise is to download the Example project we have prepared from the following [link](https://github.com/KillMobil-SA/UltraNoiseExamples)
It contains several different example scenes with graphs and nodes illustrating what can be achieved using the tool. As an extra treat it contains a great selection of Shaders from the wizard himself, mister [Harry Alisavakis](https://twitter.com/harryalisavakis)

## Who made it?
### [Sotiris](https://www.killmobil.com) and [Ycaro](https://github.com/ycarowr)
