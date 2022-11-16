
-- ░█████╗░██████╗░███████╗░█████╗░████████╗███████╗██████╗░  ██████╗░██╗░░░██╗  ██╗░░██╗░█████╗░███████╗
-- ██╔══██╗██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗  ██╔══██╗╚██╗░██╔╝  ██║░██╔╝██╔══██╗██╔════╝
-- ██║░░╚═╝██████╔╝█████╗░░███████║░░░██║░░░█████╗░░██║░░██║  ██████╦╝░╚████╔╝░  █████═╝░██║░░██║█████╗░░
-- ██║░░██╗██╔══██╗██╔══╝░░██╔══██║░░░██║░░░██╔══╝░░██║░░██║  ██╔══██╗░░╚██╔╝░░  ██╔═██╗░██║░░██║██╔══╝░░
-- ╚█████╔╝██║░░██║███████╗██║░░██║░░░██║░░░███████╗██████╔╝  ██████╦╝░░░██║░░░  ██║░╚██╗╚█████╔╝███████╗
-- ░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═════╝░  ╚═════╝░░░░╚═╝░░░  ╚═╝░░╚═╝░╚════╝░╚══════╝

-- ░██████╗░█████╗░██████╗░██╗██████╗░████████╗░██████╗
-- ██╔════╝██╔══██╗██╔══██╗██║██╔══██╗╚══██╔══╝██╔════╝
-- ╚█████╗░██║░░╚═╝██████╔╝██║██████╔╝░░░██║░░░╚█████╗░
-- ░╚═══██╗██║░░██╗██╔══██╗██║██╔═══╝░░░░██║░░░░╚═══██╗
-- ██████╔╝╚█████╔╝██║░░██║██║██║░░░░░░░░██║░░░██████╔╝
-- ╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░░░░░░░╚═╝░░░╚═════╝░



Config = {

    Policeraid = {
        Jobs = {
            {job = "police", grade = 1},				---Set the name of your police and the minimum grade to breach the unit
        },
    },
}

--General Options
Config.Target		= 'qtarget'							-- 'ox_target' for Ox Target | 'qtarget' for qtarget

Config.UnitPrice    = 35000                            ---Price of the units to buy
Config.SellPrice    = 20000                            ---Price of the unit when sold 
Config.RentPrice    = 2000
Config.Notify 		= 'ox_lib'							--- 'okok' for okokNotify(paid), 'swt' for swt_notifications(free), 'esx' Default esx notify, 'ox_lib' for ox_lib, and 'custom' if custom is selected you must go through client and server lua to add the trigger 
Config.Slots 		= 25								---ONLY IF USING OX_INVENTORY
Config.Weight		= 100000							---ONLY IF USING OX_INVENTORY



--Add your locations below! This uses qtarget. Make sure the ID is in order and its also in the database when you add a new unit. 
Config.Storages = {
	--9043 is the postal if you use postals map
	{ name = 'storageunit1', id = 1, coords = vector3(-73.26, -1196.35, 27.66), bt_length = 2, bt_width = 5.4, bt_minZ = 25.86, bt_maxZ = 29.86, bt_heading = 0 },
	{ name = 'storageunit2', id = 2, coords = vector3(-66.61, -1198.67, 27.74), bt_length = 2, bt_width = 5.4, bt_minZ = 25.94, bt_maxZ = 29.94, bt_heading = 314 },
	{ name = 'storageunit3', id = 3, coords = vector3(-60.88, -1204.31, 27.79), bt_length = 2, bt_width = 5.4, bt_minZ = 25.99, bt_maxZ = 29.99, bt_heading = 313 },
	{ name = 'storageunit4', id = 4, coords = vector3(-55.63, -1209.76, 28.28), bt_length = 2, bt_width = 5.4, bt_minZ = 26.48, bt_maxZ = 30.48, bt_heading = 314 },
	{ name = 'storageunit5', id = 5, coords = vector3(-51.84, -1216.39, 28.7), bt_length = 2, bt_width = 5.4, bt_minZ = 26.9, bt_maxZ = 30.9, bt_heading = 270 },
	{ name = 'storageunit6', id = 6, coords = vector3(-55.88, -1229.75, 28.76), bt_length = 2, bt_width = 5.4, bt_minZ = 26.96, bt_maxZ = 30.96, bt_heading = 227 },
	{ name = 'storageunit7', id = 7, coords = vector3(-60.08, -1234.31, 28.89), bt_length = 2, bt_width = 5.4, bt_minZ = 27.09, bt_maxZ = 31.09, bt_heading = 226 },
	{ name = 'storageunit8', id = 8, coords = vector3(-65.34, -1240.06, 29.03), bt_length = 2, bt_width = 5.4, bt_minZ = 27.23, bt_maxZ = 31.23, bt_heading = 226 },
	{ name = 'storageunit9', id = 9, coords = vector3(-73.77, -1243.99, 29.11), bt_length = 2, bt_width = 5.4, bt_minZ = 27.31, bt_maxZ = 31.31, bt_heading = 179 },
	{ name = 'storageunit10', id = 10, coords = vector3(-73.07, -1233.18, 29.02), bt_length = 2, bt_width = 5.4, bt_minZ = 27.22, bt_maxZ = 31.22, bt_heading = 51 },
	{ name = 'storageunit11', id = 11, coords = vector3(-67.51, -1226.06, 28.86), bt_length = 2, bt_width = 5.4, bt_minZ = 27.06, bt_maxZ = 31.06, bt_heading = 51 },
	{ name = 'storageunit12', id = 12, coords = vector3(-66.55, -1212.4, 28.31), bt_length = 2, bt_width = 5.4, bt_minZ = 26.51, bt_maxZ = 30.51, bt_heading = 316 },
	{ name = 'storageunit13', id = 13, coords = vector3(-71.74, -1207.16, 27.89), bt_length = 2, bt_width = 5.4, bt_minZ = 25.94, bt_maxZ = 29.94, bt_heading = 316 },
	{ name = 'storageunit14', id = 14, coords = vector3(-78.6, -1205.21, 27.63), bt_length = 2, bt_width = 5.4, bt_minZ = 25.94, bt_maxZ = 29.94, bt_heading = 0 },
	--9386 is the postal if you use postals map
	{ name = 'storageunit15', id = 15, coords = vector3(1722.26, -1545.74, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit16', id = 16, coords = vector3(1725.99, -1534.33, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit17', id = 17, coords = vector3(1729.97, -1522.98, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit18', id = 18, coords = vector3(1733.94, -1511.72, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit19', id = 19, coords = vector3(1737.77, -1500.37, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit20', id = 20, coords = vector3(1741.65, -1488.89, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit21', id = 21, coords = vector3(1719.35, -1481.14, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit22', id = 22, coords = vector3(1715.48, -1492.54, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit23', id = 23, coords = vector3(1711.31, -1503.96, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit24', id = 24, coords = vector3(1707.48, -1515.4, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit25', id = 25, coords = vector3(1703.6, -1526.7, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	{ name = 'storageunit26', id = 26, coords = vector3(1699.71, -1538.06, 113.95), bt_length = 2, bt_width = 4.4, bt_minZ = 112.35, bt_maxZ = 116.35, bt_heading = 250 },
	--3030 is the postal if you use postals map
	{ name = 'storageunit27', id = 27, coords = vector3(913.98, 3562.73, 33.8), bt_length = 2, bt_width = 4.4, bt_minZ = 31.58, bt_maxZ = 35.58, bt_heading = 269 },
	{ name = 'storageunit28', id = 28, coords = vector3(913.99, 3567.38, 33.78), bt_length = 2, bt_width = 4.4, bt_minZ = 31.58, bt_maxZ = 35.58, bt_heading = 269 },
	--8218 is the postal if you use postals map
	{ name = 'storageunit29', id = 29, coords = vector3(-1203.82, -1311.17, 4.86), bt_length = 3.4, bt_width = 1, bt_minZ = 3.86, bt_maxZ = 6.26, bt_heading = 295 },
	{ name = 'storageunit30', id = 30, coords = vector3(-1207.98, -1313.14, 4.76), bt_length = 3.4, bt_width = 1, bt_minZ = 3.76, bt_maxZ = 6.16, bt_heading = 295 },
	{ name = 'storageunit31', id = 31, coords = vector3(-1212.37, -1315.15, 4.68), bt_length = 3.4, bt_width = 1, bt_minZ = 3.68, bt_maxZ = 6.08, bt_heading = 295 },
	--10032 is the postal if you use postals map
	{ name = 'storageunit32', id = 32, coords = vector3(-1135.46, -1962.32, 13.16), bt_length = 1.8, bt_width = 1, bt_minZ = 12.16, bt_maxZ = 14.76, bt_heading = 270 },
	{ name = 'storageunit33', id = 33, coords = vector3(-1128.81, -1962.43, 13.16), bt_length = 1.8, bt_width = 1, bt_minZ = 12.16, bt_maxZ = 14.76, bt_heading = 270 },
	{ name = 'storageunit34', id = 34, coords = vector3(-1120.23, -1962.43, 13.16), bt_length = 1.8, bt_width = 1, bt_minZ = 12.16, bt_maxZ = 14.76, bt_heading = 270 },
	{ name = 'storageunit35', id = 35, coords = vector3(-1113.57, -1962.44, 13.16), bt_length = 1.8, bt_width = 1, bt_minZ = 12.16, bt_maxZ = 14.76, bt_heading = 270 },
	--6179 is the postal if you use postals map
	{ name = 'storageunit37', id = 37, coords = vector3(-250.06, 306.28, 92.1), bt_length = 3.4, bt_width = 1, bt_minZ = 91.1, bt_maxZ = 94.5, bt_heading = 270 },
	{ name = 'storageunit38', id = 38, coords = vector3(-246.2, 305.98, 92.09), bt_length = 3.4, bt_width = 1, bt_minZ = 91.09, bt_maxZ = 94.49, bt_heading = 270 },
	{ name = 'storageunit39', id = 39, coords = vector3(-242.37, 306.25, 92.11), bt_length = 3.4, bt_width = 1, bt_minZ = 91.11, bt_maxZ = 94.51, bt_heading = 270 },
	{ name = 'storageunit40', id = 40, coords = vector3(-238.58, 306.31, 92.12), bt_length = 3.4, bt_width = 1, bt_minZ = 91.12, bt_maxZ = 94.52, bt_heading = 270 },

	
}
