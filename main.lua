--[[This file is a modified version of Mashiros' AddonQuickStart.lua. Changes and explanations are in the accompanying README. If you find any mistakes, please contact me at Rkadia#5016.]]--


--[[This table defines the plugin, and will be loaded into Minion if the code runs without errors.]]--
    Rkadia = {} 
    local self = Rkadia

--[[This is reference to the plugin's information stored for easy access later in the code..]]--
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

--[[The directories for settings and icons are stored in this section]]--
    local lua_path = GetLuaModsPath()
    local base_path = lua_path .. "\\Rkadia"

    self.Directories = {
        Module_Path = base_path,
        Settings_Path = base_path .. "\\Settings",
        Icons_Path = base_path .. "\\Icons",
        Settings_File = base_path.. "\\Settings\\Settings.ini"
    }

--[[function prints messages to the console, with my preferred formatting compared to the original version.]]--
    self.Log = function(message, type) 
        local separator = "------------------------------------------------------------------------------"
        type = type or "LOG"
        local timestamp = os.date("%c")
        local log_message = string.format("[%s] [Type: %s] Rkadia: %s", timestamp, level, message)

        if type == "ERROR" then d(separator) d(log_message) d(separator) else d(log_message) end
    end

--[[This function checks if the necessary folders exist and creates them if they do not.]]--
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
    
    --[[This function saves the settings.]]--
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
    

    --[[This imports our settings to the Rkadia_Settings table.]]--
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
    


--[[This sets up the foundation for our main UI.]]--
    self.GUI = {
        Open = false,
        Visible = true,
        OnClick = function() self.GUI.Open = not self.GUI.Open end, --Anonymous functions make the code easier to read imo, also anonymous functions can be faster to execute than loadstring because they are compiled directly into the code, rather than being interpreted at runtime.
        IsOpen = function() return self.GUI.Open end,
        ToolTip = self.Info.Description
    }

--[[This is the initialize function, which runs when Minion loads the Rkadia Table.]]--
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


--[[This is the main GUI function, the groundwork for this was established in a previous section.]]
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
