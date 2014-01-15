package unifill;

class InternalEncoding {
	public static var internalEncoding(get, never) : Encoding;

	static inline function get_internalEncoding() : Encoding
	#if (neko || php || cpp || macro)
		return Encoding.UTF8;
	#else
		return Encoding.UTF16;
	#end

	public static inline function codeUnitAt(s : String, index : Int) : Int {
		return StringTools.fastCodeAt(s, index);
	}

	public static inline function codePointAt(s : String, index : Int) : Int {
	#if (neko || php || cpp || macro)
		return haxe.Utf8.charCodeAt(s.substr(index, codePointWidthAt(s, index)), 0);
	#else
		var hi = codeUnitAt(s, index);
		if (Unicode.isHighSurrogate(hi)) {
			var lo = codeUnitAt(s, index + 1);
			return Unicode.decodeSurrogate(hi, lo);
		}
		return hi;
	#end
	}

	public static inline function charAt(s : String, index : Int) : String {
		return s.substr(index, codePointWidthAt(s, index));
	}

	public static function codePointCount(s : String, beginIndex : Int, endIndex : Int) : Int {
	#if (neko || php || cpp || macro)
		return haxe.Utf8.length(s.substring(beginIndex, endIndex));
	#else
		var itr = new InternalEncodingIter(s, beginIndex, endIndex);
		var i = 0;
		while (itr.hasNext()) {
			itr.next();
			++i;
		}
		return i;
	#end
	}

	public static inline function codePointWidthAt(s : String, index : Int) : Int {
	#if (neko || php || cpp || macro)
		var c = codeUnitAt(s, index);
		return (c < 0xC0) ? 1 : (c < 0xE0) ? 2 : (c < 0xF0) ? 3 : (c < 0xF8) ? 4 : 1;
	#else
		var c = codeUnitAt(s, index);
		return (!Unicode.isHighSurrogate(c)) ? 1 : 2;
	#end
	}

	public static inline function codePointWidthBefore(s : String, index : Int) : Int {
	#if (neko || php || cpp || macro)
		var c1 = codeUnitAt(s, index - 1);
		return (c1 < 0x80 || c1 >= 0xC0) ? 1
			: (codeUnitAt(s, index - 2) & 0xE0 == 0xC0) ? 2
			: (codeUnitAt(s, index - 3) & 0xF0 == 0xE0) ? 3
			: (codeUnitAt(s, index - 4) & 0xF8 == 0xF0) ? 4
			: 1;
	#else
		var c = codeUnitAt(s, index - 1);
		return (!Unicode.isLowSurrogate(c)) ? 1 : 2;
	#end
	}

	public static inline function offsetByCodePoints(s : String, index : Int, codePointOffset : Int) : Int {
		var itr = new InternalEncodingIter(s, index, s.length);
		var i = 0;
		while (i < codePointOffset && itr.hasNext()) {
			itr.next();
			++i;
		}
		return itr.index;
	}

	public static inline function backwardOffsetByCodePoints(s : String, index : Int, codePointOffset : Int) : Int {
		var itr = new InternalEncodingBackwardIter(s, 0, index);
		var i = 0;
		while (i < codePointOffset && itr.hasNext()) {
			itr.next();
			++i;
		}
		return itr.index;
	}

	public static inline function fromCodePoint(code : Int) : String {
	#if (neko || php || cpp || macro)
		var buf = new haxe.Utf8();
		buf.addChar(code);
		return buf.toString();
	#else
		if (code < 0x10000) {
			return String.fromCharCode(code);
		}
		return String.fromCharCode(Unicode.encodeHighSurrogate(code))
			+ String.fromCharCode(Unicode.encodeLowSurrogate(code));
	#end
	}

	public static inline function fromCodePoints(codePoints : Iterable<Int>) : String {
	#if (neko || php || cpp || macro)
		var buf = new haxe.Utf8();
		for (c in codePoints)
			buf.addChar(c);
		return buf.toString();
	#else
		var buf = new StringBuf();
		for (c in codePoints) {
			if (c < 0x10000) {
				buf.addChar(c);
			}
			else {
				buf.addChar(Unicode.encodeHighSurrogate(c));
				buf.addChar(Unicode.encodeLowSurrogate(c));
			}
		}
		return buf.toString();
	#end
	}

	public static function compare(a : String, b : String) : Int {
		var aiter = new InternalEncodingIter(a, 0, a.length);
		var biter = new InternalEncodingIter(b, 0, b.length);
		while (aiter.hasNext() && biter.hasNext()) {
			var acode = InternalEncoding.codePointAt(a, aiter.next());
			var bcode = InternalEncoding.codePointAt(b, biter.next());
			if (acode < bcode)
				return -1;
			if (acode > bcode)
				return 1;
		}
		if (biter.hasNext())
			return -1;
		if (aiter.hasNext())
			return 1;
		return 0;
	}

	static function validateSequence(s : String, index : Int) : Void {
	#if (neko || php || cpp || macro)
		var len = s.length;
		if (index >= len)
			throw Exception.InvalidCodeUnitSequence(index);
		var c1 = codeUnitAt(s, index);
		if (c1 < 0x80) {
			return;
		}
		if (c1 < 0xC0) {
			throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 1)
			throw Exception.InvalidCodeUnitSequence(index);
		var c2 = codeUnitAt(s, index + 1);
		if (c1 < 0xE0) {
			if ((c1 & 0x1E != 0) && (c2 & 0xC0 == 0x80))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 2)
			throw Exception.InvalidCodeUnitSequence(index);
		var c3 = codeUnitAt(s, index + 2);
		if (c1 < 0xF0) {
			if (((c1 & 0x0F != 0) || (c2 & 0x20 != 0)) && (c2 & 0xC0 == 0x80) && (c3 & 0xC0 == 0x80)
				&& !(c1 == 0xED && 0xA0 <= c2 && c2 <= 0xBF))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 3)
			throw Exception.InvalidCodeUnitSequence(index);
		var c4 = codeUnitAt(s, index + 3);
		if (c1 < 0xF8) {
			if (((c1 & 0x07 != 0) || (c2 & 0x30 != 0)) && (c2 & 0xC0 == 0x80) && (c3 & 0xC0 == 0x80) && (c4 & 0xC0 == 0x80)
				&& !((c1 == 0xF4 && c2 > 0x8F) || c1 > 0xF4))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		throw Exception.InvalidCodeUnitSequence(index);
	#else
		var len = s.length;
		if (index >= len)
			throw Exception.InvalidCodeUnitSequence(index);
		var c = codeUnitAt(s, index);
		if (Unicode.isHighSurrogate(c)) {
			if (index >= len - 1 || !Unicode.isLowSurrogate(codeUnitAt(s, index + 1)))
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (Unicode.isLowSurrogate(c)) {
			throw Exception.InvalidCodeUnitSequence(index);
		}
		return;
	#end
	}

	public static inline function validate(s : String) : Void {
		for (i in new InternalEncodingIter(s, 0, s.length)) {
			validateSequence(s, i);
		}
	}

	public static function isValidString(s : String) : Bool {
		try {
			validate(s);
			return true;
		} catch (e : Exception) {
			switch (e) {
			case InvalidCodeUnitSequence(index):
				return false;
			default:
				throw e;
			}
		}
	}

}

