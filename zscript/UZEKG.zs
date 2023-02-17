class UZEKG : HHEKG {

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

		if (!_hlm_posX) _hlm_posX   = CVar.GetCVar("uz_hhx_ekg_hlm_posX", sb.CPlayer);
		if (!_hlm_posY) _hlm_posY   = CVar.GetCVar("uz_hhx_ekg_hlm_posY", sb.CPlayer);
		if (!_hlm_scale) _hlm_scale = CVar.GetCVar("uz_hhx_ekg_hlm_scale", sb.CPlayer);
		if (!_nhm_posX) _nhm_posX   = CVar.GetCVar("uz_hhx_ekg_nhm_posX", sb.CPlayer);
		if (!_nhm_posY) _nhm_posY   = CVar.GetCVar("uz_hhx_ekg_nhm_posY", sb.CPlayer);
		if (!_nhm_scale) _nhm_scale = CVar.GetCVar("uz_hhx_ekg_nhm_scale", sb.CPlayer);
	}

	override void DrawHUDStuff(HCStatusbar sb, int state, double ticFrac) {
		bool hasHelmet = _HHFunc && _HHFunc.GetIntUI("GetShowHUD", objectArg: sb.hpl);

		if (!hasHelmet && _hh_hidestatus.GetBool())
			return;
		if (HDSpectator(sb.hpl))
			return;
			
		int debugTran = sb.hpl.health > 70
			? Font.CR_OLIVE
			: (sb.hpl.health > 33
				? Font.CR_GOLD
				: Font.CR_RED
			  );
		Vector2 debugScale = (0.5, 0.5);

		if (AutomapActive) {
			if(hd_debug){
				sb.drawstring(
					sb.pnewsmallfont,
					sb.FormatNumber(sb.hpl.health),
					(34,-24),
					sb.DI_BOTTOMLEFT|sb.DI_TEXT_ALIGN_CENTER,
					debugTran,
					scale:debugScale
				);
			} else {
				sb.drawHealthTicker((40,-24),sb.DI_BOTTOMLEFT);
			}
		} else if (CheckCommonStuff(sb, state, ticFrac)) {
			int   posX  = hasHelmet ? _hlm_posX.GetInt()    : _nhm_posX.GetInt();
			int   posY  = hasHelmet ? _hlm_posY.GetInt()    : _nhm_posY.GetInt();
			float scale = hasHelmet ? _hlm_scale.GetFloat() : _nhm_scale.GetFloat();

			if(hd_debug) {
				sb.drawstring(
					sb.pnewsmallfont,
					sb.FormatNumber(sb.hpl.health),
					(0,sb.mxht),
					sb.DI_TEXT_ALIGN_CENTER|sb.DI_SCREEN_CENTER_BOTTOM,
					debugTran,
					scale: debugScale
				);
			} else {
				sb.drawHealthTicker((posX, posY));
			}
		}
	}
}
