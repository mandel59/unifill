package unifill;

class InternalEncoding {
	public static inline function internalEncodingForm() : EncodingForm
	#if (neko || php || cpp || macro)
		return EncodingForm.UTF8;
	#else
		return EncodingForm.UTF16;
	#end

	public static inline function charCodeAt(s : String, index : Int) : Int {
	#if java
		var c = s.charCodeAt(index);
		return (c < 0x10000) ? c : Surrogate.encodeHighSurrogate(c);
	#else
		return s.charCodeAt(index);
	#end
	}

	public static inline function codePointAt(s : String, index : Int) : Int {
	#if (neko || php || cpp || macro)
		return haxe.Utf8.charCodeAt(s.substr(index, 4), 0);
	#elseif java
		return s.charCodeAt(index);
	#else
		var hi = s.charCodeAt(index);
		if (Surrogate.isHighSurrogate(hi)) {
			var lo = s.charCodeAt(index + 1);
			return Surrogate.decodeSurrogate(hi, lo);
		}
		return hi;
	#end
	}

	public static function codePointCount(s : String) : Int {
	#if (neko || php || cpp || macro)
		return haxe.Utf8.length(s);
	#else
		var itr = new InternalEncodingIter(s, 0);
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
		var c = s.charCodeAt(index);
		return (c < 0x80) ? 1 : (c < 0xc0) ? 1 : (c < 0xE0) ? 2 : (c < 0xF0) ? 3 : (c < 0xF8) ? 4 : (c < 0xFC) ? 5 : (c < 0xFE) ? 6 : 1;
	#elseif java
		var c = s.charCodeAt(index);
		return (c < 0x10000) ? 1 : 2;
	#else
		var c = s.charCodeAt(index);
		return (!Surrogate.isHighSurrogate(c)) ? 1 : 2;
	#end
	}

	public static inline function offsetByCodePoints(s : String, index : Int, codePointOffset : Int) : Int {
		var itr = new InternalEncodingIter(s, index);
		var i = 0;
		while (i < codePointOffset) {
			itr.next();
			++i;
		}
		return itr.index;
	}

	public static inline function newStringFromCodePoints(codePoints : Iterable<Int>) : String {
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
				buf.addChar(Surrogate.encodeHighSurrogate(c));
				buf.addChar(Surrogate.encodeLowSurrogate(c));
			}
		}
		return buf.toString();
	#end
	}

}

