if (parent_bg == noone)
{
    exit;
}

var ctrl = instance_find(obj_updater, 0);
if (ctrl == noone)
{
    image_xscale = 0;
    exit;
}

if (IN_UPD_DSTATE == 3)
{
    pct = IN_UPD_TTPROG;
}
else if (IN_UPD_DSTATE == 4 || IN_UPD_DSTATE == 5)
{
    pct = 100;
}
else
{
    pct = 0;
}

var max_width = (parent_bg.bbox_right - 3) - x;
var target_w = (pct / 100.0) * max_width;
image_xscale = target_w / sprite_get_width(sprite_index);