package unifill;

class Unicode {

	public static inline var minCodePoint : CodePoint = cast 0x0000;
	public static inline var maxCodePoint : CodePoint = cast 0x10FFFF;
	public static inline var minHighSurrogate : CodePoint = cast 0xD800;
	public static inline var maxHighSurrogate : CodePoint = cast 0xDBFF;
	public static inline var minLowSurrogate : CodePoint = cast 0xDC00;
	public static inline var maxLowSurrogate : CodePoint = cast 0xDFFF;

	public static inline var replacementCharacter : CodePoint = cast 0xFFFD;

}
