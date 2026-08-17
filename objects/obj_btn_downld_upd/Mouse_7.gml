if (global.just_updated){exit;}

var ctrl = instance_find(obj_updater, 0);
if (ctrl == noone || IN_UPD_DSTATE != 2){exit;}

if (array_length(IN_UPD_DLPEND) == 0){exit;}

IN_UPD_DLINDX = 0;
IN_UPD_DSTATE = 3;
start_next_download();