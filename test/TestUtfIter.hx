package test;

import unifill.UtfIter;
import unifill.Utf;
import unifill.Utf8;
import unifill.Utf16;
import unifill.Utf32;

class TestUtfIter extends haxe.unit.TestCase {

	function utfIter<S : Utf>(s : S, index : Array<Int>) {
		var itr = new UtfIter<S>(s, 0, s.length);
		var i = 0;
		while (i < index.length - 1) {
			assertTrue(itr.hasNext());
			assertEquals(index[i++], itr.next());
		}
		assertFalse(itr.hasNext());
		assertEquals(index[i], itr.index);
	}

	public function test_UtfIter_Utf8() {
		utfIter(Utf8.fromString("𩸽あëa"), [0, 4, 7, 9, 10]);
	}

	public function test_UtfIter_Utf16() {
		utfIter(Utf16.fromString("𩸽あëa"), [0, 2, 3, 4, 5]);
	}

	public function test_UtfIter_Utf32() {
		utfIter(Utf32.fromString("𩸽あëa"), [0, 1, 2, 3, 4]);
	}

}
