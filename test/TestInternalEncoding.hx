package test;

import unifill.Unicode;
import unifill.InternalEncoding;

class TestInternalEncoding extends haxe.unit.TestCase {

	public function test_codePointWidthAt() {
		assertEquals(#if (target.unicode) 1 #else 2 #end, InternalEncoding.codePointWidthAt("эюя", 0));
	}

	public function test_charAt() {
		assertEquals(#if (target.unicode) "я" #else "ю" #end, InternalEncoding.charAt("эюя", 2));
	}

	public  function test_charAtCodePoint() {
		assertEquals("ю", InternalEncoding.charAt("эюя", InternalEncoding.codePointWidthAt("эюя", 0)));
	}

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
	#if (python || target.utf16)
		assertTrue(InternalEncoding.isValidString("𩸽あëa"));
		#if (!cs && !hl)
			// String.fromCharCode of cs and hl check if
			// the given char code is a valid unicode
			// scalar value, so these lines are ignored.
			assertFalse(InternalEncoding.isValidString(String.fromCharCode(Unicode.minHighSurrogate)));
			assertFalse(InternalEncoding.isValidString(String.fromCharCode(Unicode.minLowSurrogate)));
		#end
		#if (target.utf16)
			assertFalse(InternalEncoding.isValidString("𩸽".substr(0, 1)));
			assertFalse(InternalEncoding.isValidString("𩸽".substr(1, 1)));
		#end
	#else
		function fromArrayOfBytes(a : Array<Int>) {
			var bytes = haxe.io.Bytes.alloc(a.length);
			for (i in 0 ... a.length) bytes.set(i, a[i]);
			return bytes.toString();
		}
		assertTrue(InternalEncoding.isValidString("𩸽あëa"));
		/* "\xe3\x81" is an ill-formed UTF-8 sequence (missing a trailed code unit) */
		assertFalse(InternalEncoding.isValidString("𩸽" + fromArrayOfBytes([0xe3, 0x81]) + "ëa"));
		/* "\xc0" is an ill-formed UTF-8 sequence */
		assertFalse(InternalEncoding.isValidString(fromArrayOfBytes([0xc0])));
		/* "\xc0\xae" is a redundant UTF-8 sequence of "." U+002E FULL STOP (an ill-formed UTF-8 sequence) */
		assertFalse(InternalEncoding.isValidString("/" + fromArrayOfBytes([0xc0, 0xae]) + "./"));
		/* "\xed\x9f\xbf" is U+D7FF in UTF-8 (a well-formed UTF-8 sequence) */
		assertTrue(InternalEncoding.isValidString(fromArrayOfBytes([0xed, 0x9f, 0xbf])));
		/* "\xed\xa0\x80" is U+D800 in WTF-8 (an ill-formed UTF-8 sequence) */
		assertFalse(InternalEncoding.isValidString(fromArrayOfBytes([0xed, 0xa0, 0x80])));
		/* "\xed\xbf\xbf" is U+DFFF in WTF-8 (an ill-formed UTF-8 sequence) */
		assertFalse(InternalEncoding.isValidString(fromArrayOfBytes([0xed, 0xbf, 0xbf])));
		/* "\xee\x80\x80" is U+E000 in UTF-8 (a well-formed UTF-8 sequence) */
		assertTrue(InternalEncoding.isValidString(fromArrayOfBytes([0xee, 0x80, 0x80])));
		/* "\xf4\x8f\xbf\xbf" is U+10FFFF in UTF-8 (a well-formed UTF-8 sequence) */
		assertTrue(InternalEncoding.isValidString(fromArrayOfBytes([0xf4, 0x8f, 0xbf, 0xbf])));
		/* "\xf4\x90\x80\x80" is U+110000 in UTF-8, but out of Unicode, so now obsolete (an ill-formed UTF-8 sequence) */
		assertFalse(InternalEncoding.isValidString(fromArrayOfBytes([0xf4, 0x90, 0x80, 0x80])));
	#end
	}

}
