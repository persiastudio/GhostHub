draw_self();

//Título
draw_set_font(fnt_opnsans_24b);	draw_set_colour(c_ghblue);
draw_set_halign(fa_center);	draw_set_valign(fa_middle);
draw_text(x + sprite_width/2,y - 24, "Updater");
draw_set_halign(fa_left);	draw_set_valign(fa_top);

var line_height = 20;
var box_top = y + 10;
var box_bottom = y + sprite_height - 10;
var visible_count = floor((box_bottom - box_top) / line_height);
var max_scroll = max(0, array_length(global.updatelog) - visible_count);

// Auto-stick: se está no fundo, acompanha novas entries
if (log_at_bottom)
{
    log_scroll = max_scroll;
}

// Clamp por segurança (caso o array tenha encolhido)
if (log_scroll > max_scroll) log_scroll = max_scroll;
if (log_scroll < 0) log_scroll = 0;

// Render top-to-bottom
var line_y = box_top;
var end_index = min(array_length(global.updatelog), log_scroll + visible_count);

for (var i = log_scroll; i < end_index; i++)
{
    var item = global.updatelog[i];
    draw_set_color(item.color);
	draw_set_font(fnt_opnsans_11b);
    draw_text(x + 12, line_y, item.text);
    line_y += line_height;
}

// Indicador visual de scroll (opcional, mas ajuda UX)
if (max_scroll > 0)
{
    draw_set_color(c_white);
    draw_set_alpha(0.4);
    
    // Barra de scroll lateral
    var scroll_bar_x = x + sprite_width - 6;
    var scroll_bar_h = box_bottom - box_top;
    var thumb_h = max(20, scroll_bar_h * (visible_count / array_length(global.updatelog)));
    var thumb_y = box_top + (scroll_bar_h - thumb_h) * (log_scroll / max_scroll);
    
    draw_rectangle(scroll_bar_x, thumb_y, scroll_bar_x + 6, thumb_y + thumb_h, false);
    
    draw_set_alpha(1);
    
    // Setinhas pra indicar que tem mais
    if (log_scroll > 0)
    {
        draw_text(scroll_bar_x - 14, box_top - 4, "^");
    }
    if (log_scroll < max_scroll)
    {
        draw_text(scroll_bar_x - 14, box_bottom - 16, "v");
    }
}

if (IN_UPD_DSTATE == 3)
{
    var speed_kbps = IN_UPD_DSPEED * 1024;
    var line = "Baixando " + IN_UPD_DLNAME + "... [" +
               global.fmt_num(IN_UPD_DONEMB, 2) + "MB/" +
               global.fmt_num(IN_UPD_TOTLMB, 2) + "MB] - " +
               global.fmt_num(speed_kbps, 2) + "KB/s";
    draw_set_color(c_white);
    draw_text(50, 330, line);
}