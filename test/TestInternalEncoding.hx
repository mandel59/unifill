package test;

import unifill.InternalEncoding;
import unifill.Unicode;

class TestInternalEncoding extends haxe.unit.TestCase {

	public function test_fromCodePoint() {
		assertEquals("𩸽", InternalEncoding.fromCodePoint(0x29E3D));
		assertEquals("あ", InternalEncoding.fromCodePoint(0x03042));
		assertEquals("ë", InternalEncoding.fromCodePoint(0x000EB));
		assertEquals("a", InternalEncoding.fromCodePoint(0x00061));
	}

	public function test_fromCodePoints() {
		assertEquals("𩸽あëa", InternalEncoding.fromCodePoints([0x29E3D, 0x03042, 0x000EB, 0x00061]));
	}

	public function test_isValidString() {
	#if (neko || php || cpp || lua || macro)
		assertTrue(InternalEncoding.isValidString("𩸽あëa"));
		assertFalse(InternalEncoding.isValidString("𩸽\xe3\x81ëa"));
		assertFalse(InternalEncoding.isValidString("\xc0"));
		assertFalse(InternalEncoding.isValidString("/\xc0\xae./"));
		assertTrue(InternalEncoding.isValidString("\xed\x9f\xbf"));
		assertFalse(InternalEncoding.isValidString("\xed\xa0\x80"));
		assertFalse(InternalEncoding.isValidString("\xed\xbf\xbf"));
		assertTrue(InternalEncoding.isValidString("\xee\x80\x80"));
		assertTrue(InternalEncoding.isValidString("\xf4\x8f\xbf\xbf"));
		assertFalse(InternalEncoding.isValidString("\xf4\x90\x80\x80"));
	#else
		assertTrue(InternalEncoding.isValidString("𩸽あëa"));
		assertFalse(InternalEncoding.isValidString(String.fromCharCode(Unicode.minHighSurrogate)));
		assertFalse(InternalEncoding.isValidString(String.fromCharCode(Unicode.minLowSurrogate)));
	#end
	}

}
