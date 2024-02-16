-- ETインストールディレクトリ(末尾の/まで記述)
etdir = "/home/ogp_agent/OGP_User_Files/41/"
-- ミラーサーバアドレス
mirror_addr = "148.251.46.49:27615"
-- ログファイル名
logname = "connect.log"
-- モジュール名
modname = "connect.lua"

function et_ClientConnect(cno, firsttime, isbot)

	local max_clients
	local max_prv_clients
	local prv_password
	local password
	local players
	local prv_players
	local is_private
	local i
	local buf

	-- 最大クライアント数を取得
	max_clients = tonumber(et.trap_Cvar_Get("sv_maxclients"))
	-- プライベート枠数を取得
	max_prv_clients = tonumber(et.trap_Cvar_Get("sv_privateclients"))
	-- プライベート枠パスワードを取得
	prv_password = et.trap_Cvar_Get("sv_privatepassword")
	-- 接続プレイヤーのパスワードを取得
	password = et.Info_ValueForKey(et.trap_GetUserinfo(cno), "password")
	-- 一般枠の場合
	if password ~= prv_password then
		-- プライベートフラグOFF
		is_private = 0
	-- プライベート枠の場合
	else
		-- プライベートフラグON
		is_private = 1
	end
-- writeLog(cno, "max_clients     :: " .. max_clients)
-- writeLog(cno, "max_prv_clients :: " .. max_prv_clients)
-- writeLog(cno, "prv_password    :: " .. prv_password)
-- writeLog(cno, "password        :: " .. password)
-- writeLog(cno, "is_private      :: " .. is_private)
	-- 現在プレイヤー数を初期化
	players = 0
	prv_players = 0
	-- クライアントの最大人数分ループ
	for i = 0, max_clients - 1, 1 do
		-- 設定情報を取得できたプレイヤーの数をカウント
		if et.trap_GetConfigstring(689 + i) ~= "" then
			-- プレイヤーのパスワードを取得
			buf = et.Info_ValueForKey(et.trap_GetUserinfo(i), "password")
			-- 一般枠の場合
			if buf ~= prv_password then
				-- 一般プレイヤー数を加算
				players = players + 1
			-- プライベート枠の場合
			else
				-- プライベートプレイヤー数を加算
				prv_players = prv_players + 1
			end
		end
	end
-- writeLog(cno, "players         :: " .. players)
-- writeLog(cno, "prv_players     :: " .. prv_players)

	-- 一般枠の場合
	if (is_private == 0) then
		-- 枠が埋まっている場合
		if (players >= (max_clients - max_prv_clients)) then
			-- ミラーサーバに接続
-- writeLog(cno, "reconnect to => " .. mirror_addr)
			et.trap_SendServerCommand(cno, "password " .. password)
			et.trap_SendServerCommand(cno, "connect " .. mirror_addr)
		end
	-- プライベート枠の場合
	else
		-- 枠が埋まっている場合
		if (prv_players >= max_prv_clients) then
			-- ミラーサーバに接続
-- writeLog(cno, "reconnect to => " .. mirror_addr)
			et.trap_SendServerCommand(cno, "password " .. password)
			et.trap_SendServerCommand(cno, "connect " .. mirror_addr)
		end
	end
end

function writeLog(cno, msg)
	local homepath
	local logfile
	local fd_log
	local emsg
	local ecode
	local cap
	local name
	local guid

	-- fs_homepathを取得
	homepath = et.trap_Cvar_Get("fs_homepath")
	-- 取得できた場合、fs_homepath配下のetproディレクトリを設定
	if (string.len(homepath) > 0) then
		homepath = homepath .. "/etpro/"
	-- 取得できなかった場合、ETインストールディレクトリを代用
	else
		homepath = etdir
	end
	-- ログファイル名を編集
	logfile = homepath .. logname
	-- ログファイルを追加書き込みモードでオープン
	fd_log, emsg, ecode = io.open(logfile, "a")
	if (fd_log == nil) then
		error("[" .. modname .. "] logfile open error", 1)
	end
	-- 日付をログ用の書式で取得
	cap = os.date("%Y-%m-%d %H:%M:%S")
	-- プレイヤーの名前を取得
	name = et.Info_ValueForKey(et.trap_GetUserinfo(cno), "name")
	-- プレイヤーのGUIDを取得
	guid = et.Info_ValueForKey(et.trap_GetUserinfo(cno), "cl_guid")
	-- ログを記録
	fd_log:write("[" .. modname .. "]" .. cap .. " " .. name .. "<" .. guid .. "> " .. msg .. "\n")
end
