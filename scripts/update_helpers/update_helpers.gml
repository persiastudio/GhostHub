function log_add(text, color)
{
    array_push(global.updatelog, { text: text, color: color });
};

function fmt_num(n, dec)
{
    var s = string_format(n, 1, dec);
    return string_replace_all(s, ".", ",");
};

// Gera sufixo seguro para nome de arquivo: "1.3.2.25" -> "1_3_2_25"
function ver_suffix(ver_str)
{
    return string_replace_all(ver_str, ".", "_");
};

// Único lugar que sabe que data.win usa global. Tudo resto = versions.ini.
function get_local_ver(filename)
{
    if (filename == "data.win")
    {
        return IN_GHB_VER;
    }
	
    var v = "0.0.0.0";
    if (file_exists(program_directory + "versions.ini"))
    {
        ini_open(program_directory + "versions.ini");
        v = ini_read_string("FILES", filename, "0.0.0.0");
        ini_close();
    }
    return v;
};

// Comparação em cadeia: major.minor.build.correction
// Retorna true se remote > local (em qualquer nível superior)
function is_newer(remote, local)
{
    var r = string_split(remote, ".");
    var l = string_split(local, ".");
    var max_len = max(array_length(r), array_length(l));

    for (var i = 0; i < max_len; i++)
    {
        var rv = (i < array_length(r)) ? real(r[i]) : 0;
        var lv = (i < array_length(l)) ? real(l[i]) : 0;
        if (rv > lv) return true;
        if (rv < lv) return false;
    }
    return false; // exatamente iguais
};

function start_next_download()
{
    IN_UPD_DLPROG = 0;	IN_UPD_TOTLMB = 0;
	IN_UPD_DONEMB = 0;	IN_UPD_DSPEED = 0;

    var item = IN_UPD_DLPEND[IN_UPD_DLINDX];
    IN_UPD_DLNAME = item.name;
    var save_path = program_directory + item.name + "." + ver_suffix(item.version_raw);

    DC_UPD_DRESET;
    var ok = external_call(DD_UPD_DSTART, item.link, save_path);

    if (ok == 1.0)
    {
        log_add("Baixando " + item.name + "...", c_ghblue);
    }
    else
    {
        log_add("DLL recusou iniciar download de " + item.name, c_red);
        array_push(IN_UPD_RESULT, 
		{
            name: item.name,
            version_raw: item.version_raw,
            version_ofc: item.version_ofc,
            success: 0
        });
		
        IN_UPD_DLINDX++;
        if (IN_UPD_DLINDX >= array_length(IN_UPD_DLPEND))
        {
            finish_downloads();
        }
        else
        {
            start_next_download();
        }
    }
};

function apply_downloaded_file(item)
{
    // data.win NÃO é auto-aplicado — fica como .sufixo pro updater
    if (item.name == "data.win")
    {
        array_push(IN_UPD_RESULT, 
		{
            name: item.name,
            version_raw: item.version_raw,
            version_ofc: item.version_ofc,
            success: -1
        });
        log_add("Reinicie para concluir a atualização do GhostHub.", c_yellow);
        return;
    }

    var src = program_directory + item.name + "." + ver_suffix(item.version_raw);
    var dst = program_directory + item.name;

    if !file_exists(src)
    {
        array_push(IN_UPD_RESULT, 
		{
	        name	   : item.name		 ,
	        version_raw: item.version_raw,
	        version_ofc: item.version_ofc,
	        success    : 0
	    });
        log_add("Falha ao atualizar " + item.name + ": arquivo não encontrado.", c_red);
        return;
    }

    if file_exists(dst){file_delete(dst);}

    var ok = file_rename(src, dst);
    var applied = false;
    if (ok && file_exists(dst) && !file_exists(src))
    {
        applied = true;
    }
    else
    {
        file_copy(src, dst);	file_delete(src);
        applied = (file_exists(dst) && !file_exists(src));
    }

    if (applied)
    {
        // Atualiza versions.ini com a nova versão (string)
        ini_open(program_directory + "versions.ini");
        ini_write_string("Versions", item.name, item.version_raw);
        ini_close();

        array_push(IN_UPD_RESULT, 
		{
	        name	   : item.name		 ,
	        version_raw: item.version_raw,
	        version_ofc: item.version_ofc,
	        success	   : 1
		});
        log_add(item.name + " atualizado para a versão " + item.version_ofc + "!", c_lime);
    }
    else
    {
        array_push(IN_UPD_RESULT, 
		{
            name: item.name,
            version_raw: item.version_raw,
            version_ofc: item.version_ofc,
            success: 0
        });
        log_add("Falha ao atualizar " + item.name + ".", c_red);
    }
};

function finish_downloads()
{
    //Verifica se data.win está pendente (success == -1)
    var needs_restart = false;
    for (var i = 0; i < array_length(IN_UPD_RESULT); i++)
    {
        if (IN_UPD_RESULT[i].name == "data.win" && IN_UPD_RESULT[i].success == -1)
        {
            needs_restart = true;
            break;
        }
    }

    // Escreve UPDATED.ini — uma seção por arquivo, sem MANIFEST
    ini_open(program_directory + "UPDATED.ini");
    for (var i = 0; i < array_length(IN_UPD_RESULT); i++)
    {
        var r = IN_UPD_RESULT[i];
        ini_write_string(r.name, "version", r.version_raw);
        ini_write_real(r.name, "success", r.success);
    }
    ini_close();

    IN_UPD_TTPROG = 100;

    if (needs_restart)
    {
        IN_UPD_DSTATE = 4;
    }
    else
    {
        log_add("Atualização concluída! Pressione ENTER para continuar.", c_lime);
        IN_UPD_DSTATE = 5;
    }
};

function err_msg(code)
{
    switch (code)
    {
        case  1: return "URL inválida"				 ;
        case  2: return "Falha de rede"				 ;
        case  3: return "Erro HTTP (404/500)"		 ;
        case  4: return "Disco cheio / sem permissão";
        case  5: return "Cancelado"					 ;
        case  6: return "Timeout"					 ;
        default: return "Erro desconhecido"			 ;
    }
};