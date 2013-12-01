package unifill;

class Unifill {

	public static inline function uLength(s : String) : Int
		return InternalEncoding.codePointCount(s, 0, s.length);

	public static inline function uCharAt(s : String, index : Int) : String
		return uCodePointAt(s, index).toString();

	public static inline function uCodePointAt(s : String, index : Int) : CodePoint {
	#if (neko || php || cpp || macro)
		return cast haxe.Utf8.charCodeAt(s, index);
	#else
		var i = InternalEncoding.offsetByCodePoints(s, 0, index);
		return cast InternalEncoding.codePointAt(s, i);
	#end
	}

	public static inline function uIndexOf(s : String, value : String, startIndex : Int = 0) : Int {
		var index = s.indexOf(value, InternalEncoding.offsetByCodePoints(s, 0, startIndex));
		return (index >= 0) ? InternalEncoding.codePointCount(s, 0, index) : -1;
	}

	public static inline function uToString(codePoints : Iterable<CodePoint>) : String
		return InternalEncoding.newStringFromCodePoints(cast codePoints);

}
