package unifill;

class Surrogate {

	public static inline function decodeSurrogate(hi : Int, lo : Int) : Int
		return (hi - 0xD7C0 << 10) | (lo & 0x3FF);

	public static inline function encodeHighSurrogate(c : Int) : Int
		return (c >> 10) + 0xD7C0;

	public static inline function encodeLowSurrogate(c : Int) : Int
		return (c & 0x3FF) | 0xDC00;

	public static inline function isHighSurrogate(code : Int) : Bool {
		var c : CodePoint = cast code;
		return Unicode.minHighSurrogate <= c && c <= Unicode.maxHighSurrogate;
	}

	public static inline function isLowSurrogate(code : Int) : Bool {
		var c : CodePoint = cast code;
		return Unicode.minLowSurrogate <= c && c <= Unicode.maxLowSurrogate;
	}

}
