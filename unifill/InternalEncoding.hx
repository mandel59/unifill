package unifill;

class InternalEncoding {
	public static inline function internalEncodingForm() : EncodingForm
	#if (neko || php || cpp || macro)
		return EncodingForm.UTF8;
	#else
		return EncodingForm.UTF16;
	#end

	public static inline function codeUnitAt(s : String, index : Int) : Int {
		return StringTools.fastCodeAt(s, index);
	}

	public static inline function codePointAt(s : String, index : Int) : Int {
	#if (neko || php || cpp || macro)
		return haxe.Utf8.charCodeAt(s.substr(index, 4), 0);
	#else
		var hi = codeUnitAt(s, index);
		if (Surrogate.isHighSurrogate(hi)) {
			var lo = codeUnitAt(s, index + 1);
			return Surrogate.decodeSurrogate(hi, lo);
		}
		return hi;
	#end
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
		return (!Surrogate.isHighSurrogate(c)) ? 1 : 2;
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
		return (!Surrogate.isLowSurrogate(c)) ? 1 : 2;
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

