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
		return InternalEncoding.codePointCount(s, 0, InternalEncoding.length(s));

	/**
	   Returns the character at position `index` by code points of String `s`.
	 **/
	public static inline function uCharAt(s : String, index : Int) : String {
	#if (!target.unicode || lua || target.utf16)
		var i = InternalEncoding.offsetByCodePoints(s, 0, index);
		return InternalEncoding.charAt(s, i);
	#else
		return InternalEncoding.fromCodePoint(s.charCodeAt(index));
	#end
	}

	/**
	   Returns the code point as Int at position `index` by code points of String `s`.
	 **/
	public static inline function uCharCodeAt(s : String, index : Int) : Int {
	#if (!target.unicode || lua || target.utf16)
		var i = InternalEncoding.offsetByCodePoints(s, 0, index);
		return InternalEncoding.codePointAt(s, i);
	#else
		return s.charCodeAt(index);
	#end
	}

	/**
	   Returns the code point at position `index` by code points of String `s`.
	 **/
	public static inline function uCodePointAt(s : String, index : Int) : CodePoint {
		return cast uCharCodeAt(s, index);
	}

	/**
	   Returns the position of the leftmost occurence of the str within String `s`.

	   `startIndex` is counted by code points.
	 **/
	public static inline function uIndexOf(s : String, value : String, startIndex : Int = 0) : Int {
	#if (!target.unicode || target.utf16)
		var index = s.indexOf(value, InternalEncoding.offsetByCodePoints(s, 0, startIndex));
		return if (index >= 0) InternalEncoding.codePointCount(s, 0, index) else -1;
	#else
		return s.indexOf(value, startIndex);
	#end
	}

	/**
	   Returns the position of the rightmost occurence of the str within String `s`.

	   `startIndex` is counted by code points.
	 **/
	public static inline function uLastIndexOf(s : String, value : String, ?startIndex : Int) : Int {
	#if (!target.unicode || target.utf16)
		if (startIndex == null) startIndex = Unifill.uLength(s) - 1;
		var offset = InternalEncoding.offsetByCodePoints(s, 0, startIndex);
		
		var index = s.lastIndexOf(value, offset);
		return if (index >= 0) InternalEncoding.codePointCount(s, 0, index) else -1;
	#else
		return s.lastIndexOf(value, startIndex);
	#end
	}

	/**
	   Splits String `s` at each occurence of `delimiter`.
	 **/
	public static inline function uSplit(s : String, delimiter : String) : Array<String> {
		return if (InternalEncoding.length(delimiter) == 0) {
			[for (i in new InternalEncodingIter(s, 0, InternalEncoding.length(s))) InternalEncoding.charAt(s, i)];
		} else {
			s.split(delimiter);
		}
	}

	/**
	   Returns `length` characters of String `s`, starting at position `startIndex`.

	   `startIndex` and `length` are counted by code points.
	 **/
	public static inline function uSubstr(s : String, startIndex : Int, ?length : Int) : String {
		var si = InternalEncoding.offsetByCodePoints(s,
			if (startIndex >= 0) 0 else InternalEncoding.length(s),
			startIndex);
		var ei = if (length == null) InternalEncoding.length(s)
			else if (length < 0) si
			else InternalEncoding.offsetByCodePoints(s, si, length);
		return InternalEncoding.substring(s, si, ei);
	}

	/**
	   Returns the part of String `s` from `startIndex` to `endIndex`.

	   `startIndex` and `endIndex` are counted by code points.
	 **/
	public static inline function uSubstring(s : String, startIndex : Int, ?endIndex : Int) : String {
		var si = if (startIndex < 0) 0
			else InternalEncoding.offsetByCodePoints(s, 0, startIndex);
		var ei = if (endIndex == null) InternalEncoding.length(s)
			else if (endIndex < 0) 0
			else InternalEncoding.offsetByCodePoints(s, 0, endIndex);
		return InternalEncoding.substring(s, si, ei);
	}

	/**
	   Returns an iterator of the code points of String `s`.
	 **/
	public static inline function uIterator(s : String) : CodePointIter {
		return new CodePointIter(s);
	}

	/**
	   Compares String `a` and `b`.
	 **/
	public static function uCompare(a : String, b : String) : Int {
		var aiter = new InternalEncodingIter(a, 0, InternalEncoding.length(a));
		var biter = new InternalEncodingIter(b, 0, InternalEncoding.length(b));
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

	/**
	   Appends the character `c` to StringBuf `sb`.
	 **/
	public static inline function uAddChar(sb : StringBuf, c : CodePoint) : Void {
		#if (target.unicode)
			sb.addChar(c);
		#else
			InternalEncoding.encodeWith(function(c) sb.addChar(c), c.toInt());
		#end
	}

}
