package unifill;

#if (utf8 || neko || php || cpp || lua || eval || macro)
	typedef UtfX = Utf8;
#elseif (utf32 || python)
	typedef UtfX = Utf32;
#elseif (utf16 || hl || js)
	typedef UtfX = Utf16;
#else
	typedef UtfX = Utf16;
#end