function et_ConsoleCommand()

    if string.lower(et.trap_Argv(0)) == "advstatus" then        --chech if advstatus is called
    advstatus()
    return 1
    end
return 0
end


function advstatus()


    delim="-|||||||||||||-"
    for i=0, tonumber(et.trap_Cvar_Get("sv_maxclients"))-1, 1 do
        guis = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "cl_guid" )
        GUID = string.upper( guis )
        local cname = et.Info_ValueForKey( et.trap_GetUserinfo( i ), "name" )
        local name = et.Q_CleanStr( cname )
        ip = string.upper(et.Info_ValueForKey( et.trap_GetUserinfo( i ), "ip" ))


        LINE = i .. delim .. GUID .. delim .. name .. delim .. ip .. "\n"  
        mylen = string.len(LINE)
            if (mylen > 50)
            then
                et.G_Print( LINE )
            end

    end
end