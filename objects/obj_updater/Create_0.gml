if (variable_global_exists("just_updated") && global.just_updated){state = 0; exit;}

global.updatelog = [];

//Locais primeiro
state = 0;			//Downloader State
pend_updt = [];		//Pending Updates [{name, version_raw, version_ofc, link}]
results = [];		//Applied Results [{name, version_raw, version_ofc, success}]
dl_index = 0;		//Download index
dl_name = "";		//Download Name
dl_progress = 0;	
dl_total_mb = 0;
dl_done_mb = 0;
dl_speed_mbps = 0;
total_progress = 0;
http_id = -1;

/*|		  Definição de Macros		|*/
/*|		     IN = Interna			|*/
/*|	  DD = DLL Define (external_)	|*/
/*|	   DC = DLL Call (external_)	|*/
/*|		    GHB = GhostHub			|*/
/*|		     UPD = Updater			|*/

#macro IN_GHB_VER	 "0.0.0.2"
#macro IN_UPD_URL	 "https://pastebin.com/raw/55zJ9xpH"
#macro IN_UPD_DLL	 "UpdateCore.dll"
#macro IN_UPD_DSTATE obj_updater.state
#macro IN_UPD_DLPEND obj_updater.pend_updt
#macro IN_UPD_RESULT obj_updater.results
#macro IN_UPD_HTTPID obj_updater.http_id
#macro IN_UPD_DLINDX obj_updater.dl_index
#macro IN_UPD_DLNAME obj_updater.dl_name
#macro IN_UPD_DLPROG obj_updater.dl_progress
#macro IN_UPD_TOTLMB obj_updater.dl_total_mb
#macro IN_UPD_DONEMB obj_updater.dl_done_mb
#macro IN_UPD_DSPEED obj_updater.dl_speed_mbps
#macro IN_UPD_TTPROG obj_updater.total_progress

IN_UPD_DSTATE = 0;

//DLL External Define
#macro DD_UPD_DSTART external_define(IN_UPD_DLL, "StartDownload",        dll_cdecl, ty_real, 2, ty_string, ty_string)
#macro DD_UPD_FINISH external_define(IN_UPD_DLL, "IsDownloadFinished",   dll_cdecl, ty_real, 0						)
#macro DD_UPD_DLPROG external_define(IN_UPD_DLL, "GetDownloadProgress",  dll_cdecl, ty_real, 0						)
#macro DD_UPD_DLSIZE external_define(IN_UPD_DLL, "GetDownloadSizeMB",    dll_cdecl, ty_real, 0						)
#macro DD_UPD_DBYTES external_define(IN_UPD_DLL, "GetBytesDownloadedMB", dll_cdecl, ty_real, 0						)
#macro DD_UPD_DSPEED external_define(IN_UPD_DLL, "GetDownloadSpeedMBps", dll_cdecl, ty_real, 0						)
#macro DD_UPD_DERROR external_define(IN_UPD_DLL, "GetLastErrorDLL",      dll_cdecl, ty_real, 0						)
#macro DD_UPD_CANCEL external_define(IN_UPD_DLL, "CancelDownload",       dll_cdecl, ty_real, 0						)
#macro DD_UPD_DRESET external_define(IN_UPD_DLL, "ResetState",           dll_cdecl, ty_real, 0						)

//DLL External Call
#macro DC_UPD_FINISH external_call(DD_UPD_FINISH)
#macro DC_UPD_DLPROG external_call(DD_UPD_DLPROG)
#macro DC_UPD_DLSIZE external_call(DD_UPD_DLSIZE)
#macro DC_UPD_DBYTES external_call(DD_UPD_DBYTES)
#macro DC_UPD_DSPEED external_call(DD_UPD_DSPEED)
#macro DC_UPD_DERROR external_call(DD_UPD_DERROR)
#macro DC_UPD_CANCEL external_call(DD_UPD_CANCEL)
#macro DC_UPD_DRESET external_call(DD_UPD_DRESET)