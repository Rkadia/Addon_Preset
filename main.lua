--[[This file is an edited version of Mashiros' AddonQuickStart.lua. Changes and explanations can be found in the accompanying README.]]--


--[[This table defines the plugin, and will be loaded into Minion if the code runs without errors.]]--
    Rkadia = {} 
    local self = Rkadia

--[[Information about our plugin that we can reference multiple times throughout the rest of the code if we need to.]]--
    self.Info = {
        Author = "Rkadia",
        AddonName = "Rkadia",
        ClassName = "Rkadia",
        Version = 1,
        StartDate = os.time({year = 2023, month = 2, day = 10}),
        LastUpdate = os.time({year = 2023, month = 2, day = 10}),
        Description = "Rkadia",
        Changelog = {
            [1] = {
                Version = 1,
                Description = "Development Started."
            },
        },
    }

    local DefaultSettings = {
        ["My Settings"] = {
            Key1 = "yeah!",
            Key2 = "No!",
            Key3="Maybe?!"
        },
        ["Other Settings"] = {
            Key1 = "Testing Stuff",
            Key2 = "Again and Again"
        }
    }

--[[This is where we put the directories for various things like Settings and Icons.]]--
    local lua_path = GetLuaModsPath()
    local base_path = lua_path .. "\\Rkadia"

    self.Directories = {
        Module_Path = base_path,
        Settings_Path = base_path .. "\\Settings",
        Icons_Path = base_path .. "\\Icons",
        Settings_File = base_path.. "\\Settings\\Settings.ini"
    }

--[[This will print messages to the console. After the debug phase of your code is over I highly recommend removing the ----------
    so console doesnt get cluttered.]]--
    self.Log = function(message, level) -- This is just formatted in a way that I prefer.
        local separator = "------------------------------------------------------------------------------"
        level = level or "NOTICE"
        local timestamp = os.date("%c")
        local log_message = string.format("[%s] [Type: %s] Rkadia: %s", timestamp, level, message)

        if level == "ERROR" then d(separator) d(log_message) d(separator) else d(log_message) end
    end

--[[This function will see if the folders we need are created, and if not it will create them.]]--
    local function create_folder(path)
        self.Log('Checking if folder exists...', "LOG")
        cmd = "if exist " .. path .. " echo exists"
        handle = io.popen(cmd)
        local result = handle:read("*a")
        handle:close()
    
        if result:match("exists") then
            self.Log('Folder found.', "LOG")
        else
            self.Log('Folder does not exist, creating one now...', "NOTICE")
            local cmd = "if not exist " .. path .. " md " .. path
            local handle = io.popen(cmd)
            handle:close()
        end
    end
    
    function Export_Settings(t, file)
        local file = io.open(file, "w")
        for section, values in pairs(t) do
            file:write("[" .. section .. "]\n")
            for key, value in pairs(values) do
                file:write(key .. "=" .. value .. "\n")
            end
        end
        file:close()
    end
    
    function Import_Settings(file)
        local t = {}
        local section
        for line in io.lines(file) do
            local s = line:match("^%[([^%[%]]+)%]$")
            if s then
                section = s
                t[section] = {}
            end
            local key, value = line:match("^([^=]+)=(.+)$")
            if key and value then
                t[section][key] = value
            end
        end
        return t
    end
    


--[[This sets up the groundwork for a GUI to be drawn.]]--
    self.GUI = {
        Open = false,
        Visible = true,
        OnClick = function() self.GUI.Open = not self.GUI.Open end, --Anonymous functions make the code easier to read imo, also anonymous functions can be faster to execute than loadstring because they are compiled directly into the code, rather than being interpreted at runtime.
        IsOpen = function() return self.GUI.Open end,
        ToolTip = self.Info.Description
    }

--[[This is our initialize function. When the bot loads our Rkadie Table on Line 5, this code will execute.]]--
    Rkadia.Init = function()
        create_folder(self.Directories.Settings_Path)
        create_folder(self.Directories.Icons_Path)
        if not io.open(self.Directories.Settings_File) then
            Export_Settings(DefaultSettings, self.Directories.Settings_File)
            Rkadia_Settigns = Import_Settings(self.Directories.Settings_File)
        else
            Rkadia_Settings = Import_Settings(self.Directories.Settings_File)
        end

        self.Log("Rkadia loaded successfully.", "LOG")

        --[[This adds our plugin to the dropdown menu of minion.]]--
        local ModuleTable = self.GUI
        ml_gui.ui_mgr:AddMember({
        id      = self.Info.ClassName,
        name    = self.Info.AddonName,
        onClick = ModuleTable.OnClick,
        tooltip = ModuleTable.ToolTip,
        texture = ""
    }, "FFXIVMINION##MENU_HEADER")
    end


--[[This is the function of our main GUI. We set the groundwork for this earlier on Line <line>.]]
    Rkadia.MainWindow = function()

        --[[Draws our main window]]--
        if self.GUI.Open then
            GUI:SetNextWindowSize(400,400, GUI.SetCond_Always)
            self.GUI.Visible, self.GUI.Open = GUI:Begin(self.Info.AddonName, self.GUI.Open, GUI.WindowFlags_NoScrollbar+GUI.WindowFlags_NoResize)
            GUI:Text("hello world!");

            GUI:End()
        end
    end

--[[This section of the code is registering event handlers to specific events. Event handlers are
    functions that are executed when a defined event is triggered.]]--
    RegisterEventHandler('Gameloop.Draw', Rkadia.MainWindow, 'Rkadia.MainWindow')
    RegisterEventHandler('Module.Initalize', Rkadia.Init, 'Rkadia.Init')