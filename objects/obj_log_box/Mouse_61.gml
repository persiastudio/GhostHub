var line_height = 20;
var box_top = y + 10;
var box_bottom = y + sprite_height - 10;
var visible_count = floor((box_bottom - box_top) / line_height);
var max_scroll = max(0, array_length(global.updatelog) - visible_count);

log_scroll += 3;
if (log_scroll >= max_scroll)
{
    log_scroll = max_scroll;
    log_at_bottom = true;
}