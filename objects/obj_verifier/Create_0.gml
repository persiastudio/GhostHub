global.just_updated = false;
#macro c_ghblue #00B6FF

if (!file_exists(program_directory + "UPDATED.ini"))
{
    room_goto(rm_update);
    exit;
}

// Passo 1: descobrir nomes das seções (arquivos) com parser texto
var names = [];
var f = file_text_open_read(program_directory + "UPDATED.ini");

while (!file_text_eof(f))
{
    var line = string_trim(file_text_read_string(f));
    file_text_readln(f);
    
    if (line == "")
    {
        continue;
    }
    
    if (string_char_at(line, 1) == "[")
    {
        var name = string_copy(line, 2, string_length(line) - 2);
        array_push(names, name);
    }
}
file_text_close(f);

// Passo 2: ler valores com ini_read_*
var results = [];
ini_open(program_directory + "UPDATED.ini");

for (var i = 0; i < array_length(names); i++)
{
    var name = names[i];
    var ver = ini_read_string(name, "version", "?");
    var success = ini_read_real(name, "success", 0);
    array_push(results, { name: name, version_raw: ver, success: success });
}

ini_close();

file_delete(program_directory + "UPDATED.ini");
// Passo 3: popular log
global.updatelog = [];

for (var i = 0; i < array_length(results); i++)
{
    var r = results[i];
    
    if (r.name == "data.win")
    {
        if (r.success == 1)
        {
            array_push(global.updatelog, {
                text: "GhostHub atualizado para a versão " + r.version_raw + "!",
                color: c_green
            });
        }
        else
        {
            array_push(global.updatelog, {
                text: "Erro ao atualizar o GhostHub. Tente novamente.",
                color: c_red
            });
        }
        continue;
    }
    
    var msg = r.name + " V" + r.version_raw + " - ";
    var color;
    if (r.success == 1)
    {
        msg += "Atualização concluída!";
        color = c_green;
    }
    else
    {
        msg += "Erro ao atualizar. Tente novamente.";
        color = c_red;
    }
    array_push(global.updatelog, { text: msg, color: color });
}

array_push(global.updatelog, { text: "", color: c_white });
array_push(global.updatelog, { text: "Pressione ENTER para continuar.", color: c_gray });

global.just_updated = true;
room_goto(rm_update);