package unifill;

class InternalEncodingIter {

	public var string : String;
	public var index : Int;

	public function new(s : String, i : Int) {
		string = s;
		index = i;
	}

	public inline function hasNext() : Bool {
		return index < string.length;
	}

	public inline function next() : Int {
		var i = index;
		index += InternalEncoding.codePointWidthAt(string, index);
		return i;
	}

}
