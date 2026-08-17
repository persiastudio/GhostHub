if (global.just_updated){exit;}

var ctrl = instance_find(obj_updater, 0);
if (ctrl == noone || IN_UPD_DSTATE != 4){exit;}

game_change("/./", "-game updater.win");