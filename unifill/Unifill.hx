package unifill;

/**
   Unifill provides Unicode-code-point-wise methods on Strings. It is
   ideally used with 'using Unifill' and then acts as an extension to
   the String class.
 **/
class Unifill {

	/**
	   Returns the number of Unicode code points of String `s`.
	 **/
	public static inline function uLength(s : String) : Int
		return InternalEncoding.codePointCount(s, 0, s.length);

	/**
	   Returns the character at position `index` of String `s`.
	 **/
	public static inline function uCharAt(s : String, index : Int) : String {
	#if (neko || php || cpp)
		return InternalEncoding.fromCodePoint(haxe.Utf8.charCodeAt(s, index));
	#else
		var i = InternalEncoding.offsetByCodePoints(s, 0, index);
		return InternalEncoding.charAt(s, i);
	#end
	}

	/**
	   Returns the code point at position `index` of String `s`.
	 **/
	public static inline function uCodePointAt(s : String, index : Int) : CodePoint {
	#if (neko || php || cpp || macro)
		return cast haxe.Utf8.charCodeAt(s, index);
	#else
		var i = InternalEncoding.offsetByCodePoints(s, 0, index);
		return cast InternalEncoding.codePointAt(s, i);
	#end
	}

	/**
	   Returns the position of the leftmost occurence of the str within String `s`.
	 **/
	public static inline function uIndexOf(s : String, value : String, startIndex : Int = 0) : Int {
		var index = s.indexOf(value, InternalEncoding.offsetByCodePoints(s, 0, startIndex));
		return (index >= 0) ? InternalEncoding.codePointCount(s, 0, index) : -1;
	}

	/**
	   Returns the position of the rightmost occurence of the str within String `s`.
	 **/
	public static inline function uLastIndexOf(s : String, value : String, ?startIndex) : Int {
		if (startIndex == null)
			startIndex = s.length - 1;
		var index = s.lastIndexOf(value, InternalEncoding.offsetByCodePoints(s, 0, startIndex));
		return (index >= 0) ? InternalEncoding.codePointCount(s, 0, index) : -1;
	}

	/**
	   Splits String `s` at each occurence of `delimiter`.
	 **/
	public static inline function uSplit(s : String, delimiter : String) : Array<String> {
		return if (delimiter.length == 0) {
			[for (i in new InternalEncodingIter(s, 0, s.length)) InternalEncoding.charAt(s, i)];
		} else {
			s.split(delimiter);
		}
	}

	/**
	   Returns `length` characters of String `s`, starting at position `startIndex`.
	 **/
	public static inline function uSubstr(s : String, startIndex : Int, ?length : Int) : String {
		var si = (startIndex >= 0) ? InternalEncoding.offsetByCodePoints(s, 0, startIndex) : InternalEncoding.backwardOffsetByCodePoints(s, s.length, -startIndex);
		var ei = (length == null) ? s.length : (length < 0) ? si : InternalEncoding.offsetByCodePoints(s, si, length);
		return s.substring(si, ei);
	}

	/**
	   Returns the part of String `s` from `startIndex` to `endIndex`.
	 **/
	public static inline function uSubstring(s : String, startIndex : Int, ?endIndex : Int) : String {
		var si = (startIndex < 0) ? 0 : InternalEncoding.offsetByCodePoints(s, 0, startIndex);
		var ei = (endIndex == null) ? s.length : (endIndex < 0) ? 0 : InternalEncoding.offsetByCodePoints(s, 0, endIndex);
		return s.substring(si, ei);
	}

	/**
	   Returns an iterator of the code points of String `s`.
	 **/
	public static inline function uIterator(s : String) : Iterator<CodePoint> {
		var itr = new InternalEncodingIter(s, 0, s.length);
		return {
			hasNext: itr.hasNext,
			next: function() return cast InternalEncoding.codePointAt(s, itr.next())
		};
	}

	/**
	   Compares String `a` and `b`.
	 **/
	public static function uCompare(a : String, b : String) : Int {
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

	/**
	   Converts `codePoints` to string.
	 **/
	public static inline function uToString(codePoints : Iterable<CodePoint>) : String
		return InternalEncoding.fromCodePoints(cast codePoints);

}
