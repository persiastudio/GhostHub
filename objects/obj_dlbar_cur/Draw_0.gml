draw_self();

draw_set_font(fnt_opnsans_11b);
draw_set_colour(c_ghblue);

draw_set_valign(fa_middle);
draw_text(parent_bg.bbox_right + 4, y + sprite_height/2,string(IN_UPD_DLPROG) + "%");
draw_set_valign(fa_top);
draw_text(x, y - 20, "Atual:");