package unifill;

/**
   InternalEncoding provides primitive API to deal with strings across
   all platforms. You should consider adopting Unifill before this.
 **/
class InternalEncoding {

#if (neko || php || cpp || macro)

	static inline function code_point_width(c : Int) : Int {
		return (c < 0xC0) ? 1 : (c < 0xE0) ? 2 : (c < 0xF0) ? 3 : (c < 0xF8) ? 4 : 1;
	}

	static inline function find_prev_code_point(accessor : Int -> Int, index : Int) : Int {
		var c1 = accessor(index - 1);
		return (c1 < 0x80 || c1 >= 0xC0) ? 1
			: (accessor(index - 2) & 0xE0 == 0xC0) ? 2
			: (accessor(index - 3) & 0xF0 == 0xE0) ? 3
			: (accessor(index - 4) & 0xF8 == 0xF0) ? 4
			: 1;
	}

	static function decode_code_point(accessor : Int -> Int, index : Int) : Int {
		var c1 = accessor(index);
		if (c1 < 0x80) {
			return c1;
		} else if (c1 < 0xC0) {
			throw Exception.InvalidCodeUnitSequence(index);
		} else if (c1 < 0xE0) {
			var c2 = accessor(index + 1);
			return ((c1 & 0x3F) << 6) | (c2 & 0x7F);
		} else if (c1 < 0xF0) {
			var c2 = accessor(index + 1);
			var c3 = accessor(index + 2);
			return ((c1 & 0x1F) << 12) | ((c2 & 0x7F) << 6) | (c3 & 0x7F);
		} else if (c1 < 0xF8) {
			var c2 = accessor(index + 1);
			var c3 = accessor(index + 2);
			var c4 = accessor(index + 3);
			return ((c1 & 0x0F) << 18) | ((c2 & 0x7F) << 12) | ((c3 & 0x7F) << 6) | (c4 & 0x7F);
		} else {
			throw Exception.InvalidCodeUnitSequence(index);
		}
	}

	static function encode_code_point(addUnit : Int -> Void, codePoint : Int) : Void {
		if (codePoint <= 0x7F) {
			addUnit(codePoint);
		} else if (codePoint <= 0x7FF) {
			addUnit(0xC0 | (codePoint >> 6));
			addUnit(0x80 | (codePoint & 0x3F));
		} else if (codePoint <= 0xFFFF) {
			addUnit(0xE0 | (codePoint >> 12));
			addUnit(0x80 | ((codePoint >> 6) & 0x3F));
			addUnit(0x80 | (codePoint & 0x3F));
		} else if (codePoint <= 0x10FFFF) {
			addUnit(0xF0 | (codePoint >> 18));
			addUnit(0x80 | ((codePoint >> 12) & 0x3F));
			addUnit(0x80 | ((codePoint >> 6) & 0x3F));
			addUnit(0x80 | (codePoint & 0x3F));
		} else {
			throw Exception.InvalidCodePoint(codePoint);
		}
	}

	static function validate_sequence(len : Int, accessor : Int -> Int, index : Int) : Void {
		if (index >= len)
			throw Exception.InvalidCodeUnitSequence(index);
		var c1 = accessor(index);
		if (c1 < 0x80) {
			return;
		}
		if (c1 < 0xC0) {
			throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 1)
			throw Exception.InvalidCodeUnitSequence(index);
		var c2 = accessor(index + 1);
		if (c1 < 0xE0) {
			if ((c1 & 0x1E != 0) && (c2 & 0xC0 == 0x80))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 2)
			throw Exception.InvalidCodeUnitSequence(index);
		var c3 = accessor(index + 2);
		if (c1 < 0xF0) {
			if (((c1 & 0x0F != 0) || (c2 & 0x20 != 0)) && (c2 & 0xC0 == 0x80) && (c3 & 0xC0 == 0x80)
				&& !(c1 == 0xED && 0xA0 <= c2 && c2 <= 0xBF))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (index >= len - 3)
			throw Exception.InvalidCodeUnitSequence(index);
		var c4 = accessor(index + 3);
		if (c1 < 0xF8) {
			if (((c1 & 0x07 != 0) || (c2 & 0x30 != 0)) && (c2 & 0xC0 == 0x80) && (c3 & 0xC0 == 0x80) && (c4 & 0xC0 == 0x80)
				&& !((c1 == 0xF4 && c2 > 0x8F) || c1 > 0xF4))
				return;
			else
				throw Exception.InvalidCodeUnitSequence(index);
		}
		throw Exception.InvalidCodeUnitSequence(index);
	}

#else

	static inline function code_point_width(c : Int) : Int {
		return (!Unicode.isHighSurrogate(c)) ? 1 : 2;
	}

	static inline function find_prev_code_point(accessor : Int -> Int, index : Int) : Int {
		var c = accessor(index - 1);
		return (!Unicode.isLowSurrogate(c)) ? 1 : 2;
	}

	static function decode_code_point(accessor : Int -> Int, index : Int) : Int {
		var hi = accessor(index);
		if (Unicode.isHighSurrogate(hi)) {
			var lo = accessor(index + 1);
			return Unicode.decodeSurrogate(hi, lo);
		} else {
			return hi;
		}
	}

	static function encode_code_point(addUnit : Int -> Void, codePoint : Int) : Void {
		if (codePoint <= 0xFFFF) {
			addUnit(codePoint);
		} else {
			addUnit(Unicode.encodeHighSurrogate(codePoint));
			addUnit(Unicode.encodeLowSurrogate(codePoint));
		}
	}

	static function validate_sequence(len : Int, accessor : Int -> Int, index : Int) : Void {
		if (index >= len)
			throw Exception.InvalidCodeUnitSequence(index);
		var c = accessor(index);
		if (Unicode.isHighSurrogate(c)) {
			if (index >= len - 1 || !Unicode.isLowSurrogate(accessor(index + 1)))
				throw Exception.InvalidCodeUnitSequence(index);
		}
		if (Unicode.isLowSurrogate(c)) {
			throw Exception.InvalidCodeUnitSequence(index);
		}
		return;
	}

#end

	/**
	   Returns Encoding strings on the platform are encoded in.
	 **/
	public static var internalEncoding(get, never) : String;

	static inline function get_internalEncoding() : String
	#if (neko || php || cpp || macro)
		return "UTF-8";
	#else
		return "UTF-16";
	#end

	/**
	   Returns the UTF-8/16 code unit at position `index` of
	   String `s`.
	 **/
	public static inline function codeUnitAt(s : String, index : Int) : Int {
		return StringTools.fastCodeAt(s, index);
	}

	/**
	   Returns the Unicode code point at position `index` of
	   String `s`.
	 **/
	public static function codePointAt(s : String, index : Int) : Int {
		var accessor = function(i) { return codeUnitAt(s, i); };
		return decode_code_point(accessor, index);
	}

	/**
	   Returns the character as a String at position `index` of
	   String `s`.
	 **/
	public static inline function charAt(s : String, index : Int) : String {
		return s.substr(index, codePointWidthAt(s, index));
	}

	/**
	   Returns the number of Unicode code points from `beginIndex`
	   to `endIndex` in String `s`.
	 **/
	public static function codePointCount(s : String, beginIndex : Int, endIndex : Int) : Int {
		var itr = new InternalEncodingIter(s, beginIndex, endIndex);
		var i = 0;
		while (itr.hasNext()) {
			itr.next();
			++i;
		}
		return i;
	}

	/**
	   Returns the number of units of the code point at position
	   `index` of String `s`.
	 **/
	public static inline function codePointWidthAt(s : String, index : Int) : Int {
		var c = codeUnitAt(s, index);
		return code_point_width(c);
	}

	/**
	   Returns the number of units of the code point before
	   position `index` of String `s`.
	 **/
	public static inline function codePointWidthBefore(s : String, index : Int) : Int {
		var accessor = function(i) { return codeUnitAt(s, i); };
		return find_prev_code_point(accessor, index);
	}

	/**
	   Returns the index within String `s` that is offset from
	   position `index` by `codePointOffset` code points.
	 **/
	public static inline function offsetByCodePoints(s : String, index : Int, codePointOffset : Int) : Int {
		var itr = new InternalEncodingIter(s, index, s.length);
		var i = 0;
		while (i < codePointOffset && itr.hasNext()) {
			itr.next();
			++i;
		}
		return itr.index;
	}

	/**
	   Returns the index within String `s` that is offset from
	   position `index` by `codePointOffset` code points counting
	   backward.
	 **/
	public static inline function backwardOffsetByCodePoints(s : String, index : Int, codePointOffset : Int) : Int {
		var itr = new InternalEncodingBackwardIter(s, 0, index);
		var i = 0;
		while (i < codePointOffset && itr.hasNext()) {
			itr.next();
			++i;
		}
		return itr.index;
	}

	/**
	   Converts the code point `code` to a character as String.
	 **/
	public static inline function fromCodePoint(codePoint : Int) : String {
		var buf = new StringBuf();
		encode_code_point(buf.addChar, codePoint);
		return buf.toString();
	}

	/**
	   Converts `codePoints` to a String.
	 **/
	public static inline function fromCodePoints(codePoints : Iterable<Int>) : String {
		var buf = new StringBuf();
		for (c in codePoints) {
			encode_code_point(buf.addChar, c);
		}
		return buf.toString();
	}

	/**
	   Validates String `s`.

	   If the code unit sequence of `s` is invalid,
	   `Exception.InvalidCodeUnitSequence` is throwed.
	 **/
	public static inline function validate(s : String) : Void {
		var len = s.length;
		var accessor = function(i) { return codeUnitAt(s, i); };
		for (i in new InternalEncodingIter(s, 0, len)) {
			validate_sequence(len, accessor, i);
		}
	}

	/**
	   Returns if String `s` is valid.
	 **/
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

