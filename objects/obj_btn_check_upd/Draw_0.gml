draw_self();
draw_sprite(spr_btnico, 1, x + 28, y + 28);

draw_set_font(fnt_opnsans_11b);
draw_set_colour(image_index ? c_ghblue : c_white);
draw_set_valign(fa_middle);
draw_text(x + 48, y + sprite_height/2, "Verif. Atualizações");