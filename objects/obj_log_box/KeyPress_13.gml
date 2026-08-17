if (global.just_updated)
{
    global.just_updated = false;
    global.updatelog = [];
    room_goto(rm_update);
    exit;
}

var ctrl = instance_find(obj_updater, 0);
if (ctrl != noone && IN_UPD_DSTATE == 5)
{
    global.updatelog = [];
    room_goto(rm_update);
}