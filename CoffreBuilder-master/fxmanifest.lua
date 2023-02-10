fx_version 'cerulean'
games { 'gta5' };

name 'core';


-- Libs
client_scripts {
    "src/RMenu.lua",
	"src/menu/RageUI.lua",
	"src/menu/Menu.lua",
	"src/menu/MenuController.lua",
	"src/components/*.lua",
	"src/menu/elements/*.lua",
	"src/menu/items/*.lua",
	"src/menu/panels/*.lua",
}



client_scripts {
	"client/*.lua",
	"config.lua",
}

server_scripts {
	"server/*.lua",
}
