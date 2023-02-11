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

# Conclusion
I have executed a thorough revision of the original script and modified it to align with my specific requirements. The annotations and explanations throughout the main.lua file have been updated to facilitate comprehension for novice developers. In the event that any discrepancies are identified, kindly reach out to me at Rkadia#5016. Thank you!!
