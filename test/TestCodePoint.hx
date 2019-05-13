package test;

import unifill.Unicode;
import unifill.CodePoint;
import unifill.CodePointIter;

class TestCodePoint extends haxe.unit.TestCase {

	public function test_CodePoint_fromInt() {
		assertEquals("🍻", CodePoint.fromInt(0x1F37B));
	}

	public function test_CodePointIterator() {
		var itr = new CodePointIter("𩸽あëa");
		assertEquals(true, itr.hasNext());
		assertEquals(0x29E3D, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(0x03042, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(0x000EB, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(0x00061, itr.next());
		assertEquals(false, itr.hasNext());

		var itr = new CodePointIter("x\u3042\u{12345}\u{20A0}");
		assertEquals(true, itr.hasNext());
		assertEquals(120, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(12354, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(74565, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(8352, itr.next());
	}

	public function test_Unicode_isScalar() {
		assertTrue(Unicode.isScalar(Unicode.minCodePoint));
		assertTrue(Unicode.isScalar(Unicode.maxCodePoint));
		assertFalse(Unicode.isScalar(Unicode.minCodePoint - 1));
		assertFalse(Unicode.isScalar(Unicode.maxCodePoint + 1));
		assertFalse(Unicode.isScalar(Unicode.minLowSurrogate));
		assertFalse(Unicode.isScalar(Unicode.maxLowSurrogate));
		assertFalse(Unicode.isScalar(Unicode.minHighSurrogate));
		assertFalse(Unicode.isScalar(Unicode.maxHighSurrogate));
	}

	public function test_CodePoint_cons_and_snoc() {
		assertEquals("𩸽あëa", CodePoint.fromInt(0x29E3D) + "あëa");
		assertEquals("あëa𩸽", "あëa" + CodePoint.fromInt(0x29E3D));
	}

}
