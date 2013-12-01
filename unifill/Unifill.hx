package unifill;

class Unifill {

	public static inline function uLength(s : String) : Int
		return InternalEncoding.codePointCount(s);

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

	public static inline function uToString(codePoints : Iterable<CodePoint>) : String
		return InternalEncoding.newStringFromCodePoints(cast codePoints);

}
