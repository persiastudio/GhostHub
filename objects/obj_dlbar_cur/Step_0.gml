if (parent_bg == noone){exit;}

var ctrl = instance_find(obj_updater, 0);
if (ctrl == noone || IN_UPD_DSTATE != 3)
{
	image_xscale = 0; exit;
}

if (IN_UPD_DLPROG < 0) IN_UPD_DLPROG = 0;
if (IN_UPD_DLPROG > 100) IN_UPD_DLPROG = 100;

var max_width = (parent_bg.bbox_right - 3) - x;
var target_w = (IN_UPD_DLPROG / 100.0) * max_width;
image_xscale = target_w / sprite_get_width(sprite_index);