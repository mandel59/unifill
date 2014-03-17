package test;

import unifill.CodePoint;
import unifill.Exception;
import unifill.Unicode;

class TestCodePoint extends haxe.unit.TestCase {

	public function test_Unicode_isCodePoint() {
		assertTrue(Unicode.isCodePoint(Unicode.minCodePoint));
		assertTrue(Unicode.isCodePoint(Unicode.maxCodePoint));
		assertFalse(Unicode.isCodePoint(Unicode.minCodePoint - 1));
		assertFalse(Unicode.isCodePoint(Unicode.maxCodePoint + 1));
		assertFalse(Unicode.isCodePoint(Unicode.minLowSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.maxLowSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.minHighSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.maxHighSurrogate));
	}

	public function test_CodePoint_cons_and_snoc() {
		assertEquals("𩸽あëa", new CodePoint(0x29E3D) + "あëa");
		assertEquals("あëa𩸽", "あëa" + new CodePoint(0x29E3D));
	}

}
