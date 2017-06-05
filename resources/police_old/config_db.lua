db = {
	driver = "mysql-async",
	--[[
	* "mysql" : use classic mysql library (not recommended, this version break your server with errors related to "DataReader" or "connection not open" )
	* "mysql-async" : use a beta mysql library (it's in beta test so it can have some issues, please report any problem here : https://forum.fivem.net/t/beta-mysql-async-library-v0-2-0/21881)
	* "couchdb" : (SOON) use db system support by essentialmode >= 3(nosql)
	]]
	
	--SQL's credential (only for mysql)
	sql_host = "127.0.0.1",
	sql_database = "gta5_gamemode_essential",
	sql_user = "root",
	sql_password = "toor"
}