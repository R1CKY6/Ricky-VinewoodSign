Config = {}

Config.Framework = 'autodetect' -- esx, qbcore, standalone or autodetect

Config.Command = 'vinewood' -- Command to open the menu

Config.AuthorizedGroups = {
    group = { -- Only for esx and qbcore
        'admin'
    },
    identifier = { -- Only for standalone
        'discord:638415863682170881'
    }
}

Config.Locales = {
    ['vinewood'] = "Vinewood",
    ['sign'] = "Sign",
    ['text'] = "Text",
    ['color'] = "Color",
    ['text_edited'] = "Text edited!",
    ['type_text'] = "Vinewood"
}

Config.FileName = 'textSettings.json'

Config.Coords = {
    [1] = {
        coordinate = vector3(668.46820000, 1211.08500000, 326.05880000),
        heading = 343.5
    },
    [2] = {
        coordinate = vector3(681.39440000, 1204.17500000, 326.28830000),
        heading = 344.99996948242
    },
    [3] = {
        coordinate = vector3(696.22340000, 1199.10800000, 326.36760000),
        heading = 344.99996948242
    },
    [4] = {
        coordinate = vector3(711.22370000, 1196.96700000, 326.22170000),
        heading = 344.99996948242
    },
    [5] = {
        coordinate = vector3(728.87360000, 1194.60300000, 326.56200000),
        heading = 344.99996948242
    },
    [6] = {
        coordinate = vector3(745.75310000, 1187.6, 327.80650000),
        heading = 344.99996948242
    },
    [7] = {
        coordinate = vector3(763.69390000, 1184.89400000, 329.14790000),
        heading = 344.99996948242
    },
    [8] = {
        coordinate = vector3(776.69390000, 1174.89400000, 326.14790000),
        heading = 344.99996948242
    },
}
