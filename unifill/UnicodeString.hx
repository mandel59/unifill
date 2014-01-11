package unifill;

abstract UnicodeString(String) {

	public var length(get, never) : Int;

	inline function new(str : String) : Void {
		this = str;
	}

	inline function get_length() : Int {
		return Unifill.uLength(this);
	}

	public inline function toUpperCase() : UnicodeString {
		return cast this.toUpperCase();
	}

	public inline function toLowerCase() : UnicodeString {
		return cast this.toLowerCase();
	}

	public inline function charAt(index : Int) : UnicodeString {
		return cast Unifill.uCharAt(this, index);
	}

	public inline function charCodeAt(index : Int) : Null<Int> {
		return cast Unifill.uCodePointAt(this, index);
	}

	public inline function indexOf(str : UnicodeString, ?startIndex : Int) : Int {
		return Unifill.uIndexOf(this, str.toString(), startIndex);
	}

	public inline function lastIndexOf(str : UnicodeString, ?startIndex : Int) : Int {
		return Unifill.uLastIndexOf(this, str.toString(), startIndex);
	}

	public inline function split(delimiter : UnicodeString) : Array<UnicodeString> {
		return cast Unifill.uSplit(this, delimiter.toString());
	}

	public inline function substr(pos : Int, ?len : Int) : UnicodeString {
		return cast Unifill.uSubstr(this, pos, len);
	}

	public inline function substring(startIndex : Int, ?endIndex : Int) : UnicodeString {
		return cast Unifill.uSubstring(this, startIndex, endIndex);
	}

	public inline function toString() : String {
		return this;
	}

	public static inline function fromCharCode(code : Int) : UnicodeString {
		return cast InternalEncoding.fromCodePoint(code);
	}

	@:op(A + B)
	public static inline function concat(a : UnicodeString, b : UnicodeString) : UnicodeString {
		return cast (a.toString() + b.toString());
	}

	@:op(A == B) public static function eq(a : UnicodeString, b : UnicodeString) : Bool;
	@:commutative @:op(A == B) public static function eqString(a : UnicodeString, b : String) : Bool;
	@:op(A != B) public static function ne(a : UnicodeString, b : UnicodeString) : Bool;
	@:commutative @:op(A != B) public static function neString(a : UnicodeString, b : String) : Bool;

}
