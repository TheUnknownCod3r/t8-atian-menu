handle_force_map() {
    atianconfig = level.atianconfig;

    // map launcher
    if (is_multiplayer()) {
        if (isdefined(atianconfig.mp_force_gametype)) {
            gametype_force = atianconfig.mp_force_gametype;
        } else {
            gametype_force = level.gametype;
        }
        if (isdefined(atianconfig.mp_force_map)) {
            map_force = atianconfig.mp_force_map;
        } else {
            map_force = util::get_map_name();
        }

        if (util::get_map_name() != map_force || level.gametype != gametype_force) {
            if (!isvalidgametype(gametype_force)) {
                broadcase_message_wait("^1Not a valid gametype: ^6" + gametype_force, 100);
                return;
            }
            // we need to wait before loading the other map
            wait(10);
            self iPrintLn("loading " + map_force + "/" + gametype_force);

            switchmap_load(map_force, gametype_force);
            wait(1);
            switchmap_switch();
        }
    } else if (is_warzone()) {
        if (isdefined(atianconfig.force_blackout_gametype)) {
            gametype_force = atianconfig.force_blackout_gametype;
        } else {
            gametype_force = level.gametype;
        }
        if (isdefined(atianconfig.force_blackout_map)) {
            map_force = atianconfig.force_blackout_map;
        } else {
            map_force = util::get_map_name();
        }
        
        if (util::get_map_name() != map_force || level.gametype != gametype_force) {
            if (!isvalidgametype(gametype_force)) {
                broadcase_message_wait("^1Not a valid gametype: ^6" + gametype_force, 100);
                return;
            }
            // we need to wait before loading the other map
            wait(10);
            self iPrintLn("loading " + map_force + "/" + gametype_force);

            switchmap_load(map_force, gametype_force);
            if (!isdefined(atianconfig.force_blackout_noswitch) || !atianconfig.force_blackout_noswitch) {
                wait(1);
                switchmap_switch();
            }
        }
    }
}