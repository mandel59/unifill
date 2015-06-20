package unifill;

class CodePointIter {

	public var string : String;
	public var index : Int;
	public var endIndex : Int;

	public inline function new(s : String) {
		string = s;
		index = 0;
		endIndex = s.length;
	}

	public inline function hasNext() : Bool {
		return index < endIndex;
	}

	var i = 0; // FIXME: blocked by HaxeFoundation/haxe#4353
	public inline function next() : CodePoint {
		i = index;
		index += InternalEncoding.codePointWidthAt(string, index);
		return cast InternalEncoding.codePointAt(string, i);
	}

}
