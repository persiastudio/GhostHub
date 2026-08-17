if (IN_UPD_DSTATE != 3){exit;}

if (array_length(IN_UPD_DLPEND) > 0)
{
    var sum = IN_UPD_DLINDX + (IN_UPD_DLPROG / 100.0);
    IN_UPD_TTPROG = (sum / array_length(IN_UPD_DLPEND)) * 100.0;
    if (IN_UPD_TTPROG > 100) IN_UPD_TTPROG = 100;
}

if (DC_UPD_FINISH)
{
    var item = IN_UPD_DLPEND[IN_UPD_DLINDX];
    log_add("Download concluído - " + item.name, c_lime);
    apply_downloaded_file(item);

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
else if (DC_UPD_FINISH == -1.0)
{
    var item = IN_UPD_DLPEND[IN_UPD_DLINDX];
    log_add("Erro ao baixar " + item.name + ": " + err_msg(DC_UPD_DERROR), c_red);

    var partial = program_directory + item.name + "." + ver_suffix(item.version_raw);
    file_delete(partial);

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