package test;

import unifill.CodePoint;
import unifill.Exception;
import unifill.Unicode;

class TestCodePoint extends haxe.unit.TestCase {

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
		assertEquals("𩸽あëa", new CodePoint(0x29E3D) + "あëa");
		assertEquals("あëa𩸽", "あëa" + new CodePoint(0x29E3D));
	}

}
