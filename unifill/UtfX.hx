package unifill;

#if (!target.unicode)
	typedef UtfX = Utf8;
#elseif (target.utf16)
	typedef UtfX = Utf16;
#else
	typedef UtfX = Utf32;
#end