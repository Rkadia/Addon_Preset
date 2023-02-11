--[[Core]]--
    Rkadia = {} 
    local self = Rkadia

--[[Info]]--
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

--[[Tables and Variables]]--
    local lua_path = GetLuaModsPath()
    local base_path = lua_path .. "\\Rkadia"

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

    self.Directories = {
        Module_Path = base_path,
        Settings_Path = base_path .. "\\Settings",
        Icons_Path = base_path .. "\\Icons",
        Settings_File = base_path.. "\\Settings\\Settings.ini"
    }

--[[Functions]]--
    self.Log = function(message, type) 
        local separator = "------------------------------------------------------------------------------"
        type = type or "LOG"
        local timestamp = os.date("%c")
        local log_message = string.format("[%s] [Type: %s] Rkadia: %s", timestamp, level, message)

        if type == "ERROR" then d(separator) d(log_message) d(separator) else d(log_message) end
    end


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
    

--[[UI Components]]--
    self.GUI = {
        Open = false,
        Visible = true,
        OnClick = function() self.GUI.Open = not self.GUI.Open end,
        ToolTip = self.Info.Description
    }


--[[Plugin Execution]]--
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

        local ModuleTable = self.GUI
        ml_gui.ui_mgr:AddMember({
        id      = self.Info.ClassName,
        name    = self.Info.AddonName,
        onClick = ModuleTable.OnClick,
        tooltip = ModuleTable.ToolTip,
        texture = ""
    }, "FFXIVMINION##MENU_HEADER")
    end

    Rkadia.MainWindow = function()
        if self.GUI.Open then
            GUI:SetNextWindowSize(400,400, GUI.SetCond_Always)
            self.GUI.Visible, self.GUI.Open = GUI:Begin(self.Info.AddonName, self.GUI.Open, GUI.WindowFlags_NoScrollbar+GUI.WindowFlags_NoResize)
            GUI:Text("hello world!");

            GUI:End()
        end
    end

--[[Event Handlers]]--
    RegisterEventHandler('Gameloop.Draw', Rkadia.MainWindow, 'Rkadia.MainWindow')
    RegisterEventHandler('Module.Initalize', Rkadia.Init, 'Rkadia.Init')