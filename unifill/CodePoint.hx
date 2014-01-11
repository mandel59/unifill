package unifill;

abstract CodePoint(Int) {

	@:op(A + B)
	public static inline function addInt(a : CodePoint, b : Int) : CodePoint
		return cast ((cast a : Int) + b);

	@:op(A - B)
	public static inline function sub(a : CodePoint, b : CodePoint) : Int
		return (cast a : Int) - (cast b : Int);

	@:op(A - B)
	public static inline function subInt(a : CodePoint, b : Int) : CodePoint
		return cast ((cast a : Int) - b);

	@:op(A == B) public static function eq(a : CodePoint, b : CodePoint) : Bool;
	@:op(A != B) public static function ne(a : CodePoint, b : CodePoint) : Bool;
	@:op(A < B) public static function lt(a : CodePoint, b : CodePoint) : Bool;
	@:op(A <= B) public static function lte(a : CodePoint, b : CodePoint) : Bool;
	@:op(A > B) public static function gt(a : CodePoint, b : CodePoint) : Bool;
	@:op(A >= B) public static function gte(a : CodePoint, b : CodePoint) : Bool;

	public static inline function fromInt(code : Int) : CodePoint {
		if (Unicode.isCodePoint(code))
			return cast code;
		throw Exception.InvalidCodePoint(code);
	}

	public inline function toString() : String
		return InternalEncoding.newStringFromCodePoints([(cast this : Int)]);

	public inline function toInt() : Int
		return cast this;
}
