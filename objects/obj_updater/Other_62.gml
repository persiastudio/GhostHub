var rid = ds_map_find_value(async_load, "id");
if (rid != http_id)
{
    exit;
}

var status = ds_map_find_value(async_load, "status");

if (status != 0)
{
    log_add("[!]Falha ao conectar-se ao servidor de atualização.[!]", c_maroon);
    IN_UPD_DSTATE = 0;
	
    IN_UPD_HTTPID = -1;
    exit;
}

var raw = string_trim(ds_map_find_value(async_load, "result"));
IN_UPD_HTTPID = -1;

var data = json_parse(raw);
if (is_undefined(data) || !is_array(data))
{
    log_add("JSON inválido recebido do servidor.", c_maroon);
    IN_UPD_DSTATE = 0;
    exit;
}

if (array_length(data) == 0)
{
    log_add("Servidor retornou lista vazia.", c_maroon);
    IN_UPD_DSTATE = 0;
    exit;
}

IN_UPD_DLPEND = [];
IN_UPD_RESULT = [];
var updates_found = 0;

for (var i = 0; i < array_length(data); i++)
{
    var entry = data[i];

    // Validação mínima
    if (!variable_struct_exists(entry, "name"))         continue;
    if (!variable_struct_exists(entry, "version_raw"))  continue;
    if (!variable_struct_exists(entry, "version_ofc"))  continue;
    if (!variable_struct_exists(entry, "link"))         continue;

    var remote_raw = string(entry.version_raw);
    var local_raw  = get_local_ver(entry.name);

    if (is_newer(remote_raw, local_raw))
    {
        array_push(IN_UPD_DLPEND, 
		{
            name:        string(entry.name),
            version_raw: remote_raw,
            version_ofc: string(entry.version_ofc),
            link:        string(entry.link)
        });
		if entry.name == "data.win"
		{
			log_add("Atualização do GhostHub encontrada! V" + entry.version_ofc, c_ghblue);
		}
		else
		{
			log_add("Atualização encontrada: " + entry.name + " V" + entry.version_ofc, c_ghblue);
		}
        updates_found++;
    }
}

if (updates_found == 0)
{
    log_add("Nenhuma atualização encontrada.", c_gray);
    IN_UPD_DSTATE = 0;
}
else
{
    if updates_found < 2
	{
		log_add(string(updates_found) + " atualização encontrada. Clique em \"Baixar\" para aplicá-la.", c_ghblue);
	}
	else
	{
		log_add(string(updates_found) + " atualizações encontradas. Clique em \"Baixar\" para aplicá-las.", c_ghblue);
	}
    IN_UPD_DSTATE = 2; //json parsed
}