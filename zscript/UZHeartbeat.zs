class UZHeartbeat : HHHeartbeat {

	private Service _HHFunc;
	
	private transient CVar _hh_hidestatus;

	private transient CVar _hlm_posX;
	private transient CVar _hlm_posY;
	private transient CVar _hlm_scale;
	private transient CVar _nhm_posX;
	private transient CVar _nhm_posY;
	private transient CVar _nhm_scale;

	override void Tick(HCStatusbar sb) {
		if (!_HHFunc) _HHFunc = ServiceIterator.Find("HHFunc").Next();

		if (!_hh_hidestatus) _hh_hidestatus = CVar.GetCVar("hh_hidestatus", sb.CPlayer);

		if (!_hlm_posX) _hlm_posX   = CVar.GetCVar("uz_hhx_heartbeat_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY   = CVar.GetCVar("uz_hhx_heartbeat_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale = CVar.GetCVar("uz_hhx_heartbeat_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX   = CVar.GetCVar("uz_hhx_heartbeat_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY   = CVar.GetCVar("uz_hhx_heartbeat_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale = CVar.GetCVar("uz_hhx_heartbeat_nhm_scale", sb.CPlayer);
	}
	
	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);
		
		if (!hasHelmet && _hh_hidestatus.GetBool())
			return;
		if (HDSpectator(sb.hpl))
			return;

		if (sb.hpl && sb.hpl.beatmax) {
		
			float cpb   = sb.hpl.beatcount * 1. / sb.hpl.beatmax;
			float ysc   = -(3 + sb.hpl.bloodpressure * 0.05);
			color hbCol = color(int(cpb * 255), sb.sbcolour.r, sb.sbcolour.g, sb.sbcolour.b);
			
			if(!sb.hud_aspectscale.getbool()) {
				ysc *= 1.2;
			}

			if (AutomapActive) {
				sb.fill(
					hbCol,
					32,
					-24 - cpb * 3,
					4,
					ysc,
					sb.DI_BOTTOMLEFT
				);
			} else if (CheckCommonStuff(sb, state, ticFrac)) {

				int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
				int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
				float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();
				
				sb.fill(
					hbCol,
					posX,
					posY - cpb * 2,
					3 * scale,
					ysc * scale,
					sb.DI_SCREEN_CENTER_BOTTOM
				);
			}
		}
	}
}
