# Addon_Preset
This is a preconfigured template designed to assist users in the creation of add-ons for Minion. It offers insightful explanations of various functions and endeavors to promote good coding practices while avoiding negative habits.

# What's the purpose? Why not use mash's quickstart addon?
This was tailored for fresh users. It offers better readability compared to mash's and removes the mash library dependency.

# What was changed?
A decent amount. One thing I did was enhance the code to be more performance friendly and safer. 

An example of this is here:
```
self.GUI = {
    Open    = false,
    Visible = true,
    OnClick = loadstring(self.Info.ClassName .. [[.GUI.Open = not ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    IsOpen  = loadstring([[return ]] .. self.Info.ClassName .. [[.GUI.Open]]),
    ToolTip = self.Info.Description
}
```

```    
self.GUI = {
    Open = false,
    Visible = true,
    OnClick = function() self.GUI.Open = not self.GUI.Open end,
    ToolTip = self.Info.Description
}
```
The original code by mash has several issues. First, the use of loadstring is considered a security risk and should be avoided whenever possible. this is because it allows arbitrary code execution which can be dangerous if malicious code is executed. second reason is performance. using loadstring to set values is not optimal and can lead to decreased performance which is significant given how awful lua's default performance is. It's better to use anonymous functions like I have instead to increase the performance of the script.

Other things I've done include:
* Removed mash's library dependency. You no longer need it for this.
* Use cmd commands instead of pre-made minion-lua functions.
* Comments spread throughout the code to help new users understand what everything does.

# Installation
Installing is very easy. Drag and drop the Rkadia folder to your LuaMods Directory ( Default: C:\MINIONAPP\Bots\FFXIVMinion64\LuaMods )

If it installed correctly, you should have a new dropdown member from the UI Manager. Note that if you edited the name of your plugin it won't say Rkadia.

![image](https://user-images.githubusercontent.com/125116570/218248420-a351f703-dea3-4f74-a239-a2f8eb1c286f.png)
![image](https://user-images.githubusercontent.com/125116570/218248389-776d2b1c-59b0-4954-8c3f-39ebb321d728.png)

Successfully loading it in game will create two new folders in the Rkadia directory and give you a basic settings.ini file.
![image](https://user-images.githubusercontent.com/125116570/218248492-dfee1e90-aeca-4f39-9c60-30578302fbb2.png)
![image](https://user-images.githubusercontent.com/125116570/218248499-813bdf63-6d8b-46ec-8703-f016bc412375.png)

# Conclusion
I have executed a thorough revision of the original script and modified it to align with my specific requirements. The annotations and explanations throughout the main.lua file have been updated to facilitate comprehension for novice developers. In the event that any discrepancies are identified, kindly reach out to me at Rkadia#5016. Thank you!!
