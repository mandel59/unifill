package test;

class Main {

	static function main() {
		trace( unifill.InternalEncoding.internalEncoding );
		trace ( targetName() );
		var r = new haxe.unit.TestRunner();
		r.add(new TestUnifill());
		r.add(new TestUtf8());
		r.add(new TestUtf16());
		r.add(new TestUtf32());
		r.add(new TestInternalEncoding());
		r.add(new TestInternalEncodingIter());
		r.add(new TestCodePoint());
		r.run();
	}

	macro static function targetName() {
		return macro $v{ haxe.macro.Context.definedValue("target.name") }
	}

}
