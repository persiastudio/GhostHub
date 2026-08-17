draw_self();
draw_sprite(spr_btnico, 6, x + 28, y + 28);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(fnt_opnsans_11b);
draw_set_colour(image_index ? c_ghblue : c_white);

draw_text(x + sprite_width/2, y + sprite_height/2, "Voltar");

draw_set_halign(fa_left);
draw_set_valign(fa_top);