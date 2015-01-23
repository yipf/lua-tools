local SCRIPT_PATH="/home/yipf/LUA/"
--~ local CLIB_PATH="~/LUA/libs/"

package.path=SCRIPT_PATH.."?.lua;"..package.path
--~ package.cpath=CLIB_PATH.."?.so;"..package.cpath

local UI_LIB_PAT="/usr/lib/lib?51.so;/usr/lib/lib?.so;"

package.cpath=UI_LIB_PAT..package.cpath