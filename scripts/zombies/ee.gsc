// func_searchentities(menu)
func_searchee(menu) {
    // clear ee
    menu.sub_menus = array();

    if (!isdefined(level._ee)) {
        return;
    }

    foreach (ee_key, ee in level._ee) {
        // create a menu for each ee
        smenu_id = "zm_ee_" + ee_key;
        smenu_id_step = "zm_ee_" + ee_key + "_step";

        started = isdefined(ee.started) && ee.started;
        completed = isdefined(ee.completed) && ee.completed;
        if (completed) {
            self add_menu(smenu_id, "" + ee_hashname_resolve(ee_key) + " (done)", menu.id, true);
        } else if (started) {
            self add_menu(smenu_id, "" + ee_hashname_resolve(ee_key) + " (start)", menu.id, true);
        } else {
            self add_menu(smenu_id, "" + ee_hashname_resolve(ee_key) + " (wait)", menu.id, true);
        }

        self add_menu_item(smenu_id, "name: " + nullable_to_str(ee_hashname_resolve(ee.name), "undefined"));
        self add_menu_item(smenu_id, "current: " + nullable_to_str(ee.current_step, "undefined"));
        self add_menu_item(smenu_id, "started: " + to_str_bool(ee.started));
        self add_menu_item(smenu_id, "completed: " + to_str_bool(ee.completed));
        
        // add one element/step
        if (isdefined(ee.steps)) {
            self add_menu(smenu_id_step, "steps: " + ee.steps.size, smenu_id, true);
            for (i = 0; i < ee.steps.size; i++) {
                step = ee.steps[i];
                if (!isdefined(step)) {
                    continue;
                }
                sstarted = isdefined(step.started) && step.started;
                scompleted = isdefined(step.completed) && step.completed;
                
                if (scompleted) {
                    self add_menu_item(smenu_id_step, "" + i + " " + nullable_to_str(ee_hashname_resolve(step.name), "") + " (done)");
                } else if (sstarted) {
                    self add_menu_item(smenu_id_step, "" + i + " " + nullable_to_str(ee_hashname_resolve(step.name), "") + " (start)");
                } else {
                    self add_menu_item(smenu_id_step, "" + i + " " + nullable_to_str(ee_hashname_resolve(step.name), "") + " (wait)");
                }
            }
        }
    }

}

ee_hashname_resolve(name) {
    if (!isdefined(name)) {
        return undefined;
    }
    switch (name) {
    case #"hash_4e21e987e2c0592d": return "(?)impaler quest";
    case #"hash_331f9ba64e2c2478": return "(?)stake knife quest";
    case #"hash_637ceeb3bef1ea35": // zm_mansion
    case #"hash_637ceeb3bef1ea35": // zm_red
        return "(?)ee song";
    case #"hash_559b7237b8acece2": return "(?)???";
    default:
        return hash_lookup(name);
    }
}

should_fail_ee_nostart(name) {
    if (!is_ee_start(name)) {
        self iPrintLnBold(guess_why_ee_not_started());
        return true;
    }
    return false;
}

is_ee_start(name) {
    return isdefined(level._ee) && isdefined(level._ee[name]) && level._ee[name].started;
}

guess_why_ee_not_started() {
    if (isdefined(level.gamedifficulty) && level.gamedifficulty === 0) {
        return "Can't be done is casual";
    }
    setting = getgametypesetting(#"hash_3c5363541b97ca3e");
    if (isdefined(setting) && !setting) {
        return "Bad settings";
    }
	if (isdefined(level.var_73d1e054) && level.var_73d1e054) {
        return "Bypass failed";
    }
    if (!SessionModeIsOnlineGame()) {
        return "Offline game";
    }
    return "Can't guess why";
}

func_complete_ee() {
    switch (level.script) {
        case "zm_office":
            level notify(#"main_quest_complete");
            break;
        default:
        self iPrintLnBold("^1Not yet implemented: ^3" + level.script);
            break;
    }
}


func_activate_narrative_room(item) {
    self thread func_activate_narrative_room_thread();
}

func_activate_narrative_room_thread() {
    // zm_red, zm_office, zm_escape
    level notify(#"fake_waittill");
    // zm_towers
	doors = getentarray("lore_room", "targetname");
    if (isdefined(doors)) {
        foreach(e_door in doors) {
            e_door delete();
        }
    }
    // zm_white
	door = getent("bread_door", "targetname");
    if (isdefined(door)) {
		doors rotateto(doors.angles + (vectorscale((0, -1, 0), 170)), 1);
		doors waittill(#"movedone");
        doors disconnectpaths();
        v_blocker = spawn("trigger_box", (-800, -1070, -132), 0, 408, 164, 132);
        v_blocker disconnectpaths();
    }
    // zm_zodt8 (thanks Serious)
	doors = getent("baphomets_entry", "targetname");
    if (isdefined(doors)) {
        foreach(e_door in doors) {
            e_door delete();
        }
    }
}