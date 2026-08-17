if (global.just_updated){exit;}

var ctrl = instance_find(obj_updater, 0);
if (ctrl == noone || IN_UPD_DSTATE != 0){exit;}

IN_UPD_DLPEND = [];
IN_UPD_RESULT = [];
IN_UPD_DLINDX = 0;
IN_UPD_TTPROG = 0;

var headers = ds_map_create();
ds_map_add(headers, "Cache-Control", "no-cache, no-store, must-revalidate");

IN_UPD_HTTPID = http_request(IN_UPD_URL, "GET", headers, "");
IN_UPD_DSTATE = 1;

log_add("Verificando atualizações...", c_ghblue);
ds_map_destroy(headers);