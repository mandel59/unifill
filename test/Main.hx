package test;

import unifill.CodePoint;
import unifill.InternalEncoding;
import unifill.Unicode;
import unifill.Exception;
import unifill.Utf32;

using unifill.Unifill;

class TestUnifill extends haxe.unit.TestCase {

	public function test_CodePoint() {
		assertTrue(Unicode.isCodePoint(Unicode.minCodePoint));
		assertTrue(Unicode.isCodePoint(Unicode.maxCodePoint));
		assertFalse(Unicode.isCodePoint(Unicode.minCodePoint - 1));
		assertFalse(Unicode.isCodePoint(Unicode.maxCodePoint + 1));
		assertFalse(Unicode.isCodePoint(Unicode.minLowSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.maxLowSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.minHighSurrogate));
		assertFalse(Unicode.isCodePoint(Unicode.maxHighSurrogate));
		assertEquals(cast Unicode.minCodePoint, new CodePoint(Unicode.minCodePoint));
		assertEquals(cast Unicode.maxCodePoint, new CodePoint(Unicode.maxCodePoint));
		#if !flash
		assertTrue(try {
				new CodePoint(Unicode.minCodePoint - 1);
				false;
			} catch(e : Exception) {
				switch (e) {
					case InvalidCodePoint(c) if (c == Unicode.minCodePoint - 1): true;
					default: false;
				}
			});
		assertTrue(try {
				new CodePoint(Unicode.maxCodePoint + 1);
				false;
			} catch(e : Exception) {
				switch (e) {
					case InvalidCodePoint(c) if (c == Unicode.maxCodePoint + 1): true;
					default: false;
				}
			});
		#end
	}

	public function test_CodePoint_cons_and_snoc() {
		assertEquals("𩸽あëa", new CodePoint(0x29E3D) + "あëa");
		assertEquals("あëa𩸽", "あëa" + new CodePoint(0x29E3D));
	}

	public function test_Unicode_decodeSurrogate() {
		assertEquals(0x10000, Unicode.decodeSurrogate(Unicode.minHighSurrogate, Unicode.minLowSurrogate));
		assertEquals(0x10FFFF, Unicode.decodeSurrogate(Unicode.maxHighSurrogate, Unicode.maxLowSurrogate));
		assertEquals(0x29E3D, Unicode.decodeSurrogate(0xD867, 0xDE3D));
	}

	public function test_InternalEncoding_fromCodePoint() {
		assertEquals("𩸽", InternalEncoding.fromCodePoint(0x29E3D));
		assertEquals("あ", InternalEncoding.fromCodePoint(0x03042));
		assertEquals("ë", InternalEncoding.fromCodePoint(0x000EB));
		assertEquals("a", InternalEncoding.fromCodePoint(0x00061));
	}

	public function test_InternalEncoding_fromCodePoints() {
		assertEquals("𩸽あëa", InternalEncoding.fromCodePoints([0x29E3D, 0x03042, 0x000EB, 0x00061]));
	}

	public function test_InternalEncoding_isValidString() {
	#if (neko || php || cpp || macro)
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

	public function test_Unifill_uLength() {
		assertEquals(4, "𩸽あëa".uLength());
	}

	public function test_Unifill_uCharAt() {
		assertEquals("𩸽", "𩸽あëa".uCharAt(0));
		assertEquals("あ", "𩸽あëa".uCharAt(1));
		assertEquals("ë", "𩸽あëa".uCharAt(2));
		assertEquals("a", "𩸽あëa".uCharAt(3));
	}

	public function test_Unifill_uCodePointAt() {
		assertEquals(cast 0x29E3D, "𩸽あëa".uCodePointAt(0));
		assertEquals(cast 0x03042, "𩸽あëa".uCodePointAt(1));
		assertEquals(cast 0x000EB, "𩸽あëa".uCodePointAt(2));
		assertEquals(cast 0x00061, "𩸽あëa".uCodePointAt(3));
	}

	public function test_Unifill_uIndexOf() {
		assertEquals(0, "𩸽あëa".uIndexOf("𩸽"));
		assertEquals(1, "𩸽あëa".uIndexOf("あ"));
		assertEquals(2, "𩸽あëa".uIndexOf("ë"));
		assertEquals(3, "𩸽あëa".uIndexOf("a"));
		assertEquals(-1, "𩸽あëa".uIndexOf("z"));
		assertEquals(-1, "𩸽あëa".uIndexOf("𩸽", 1));
		assertEquals(1, "𩸽あëa".uIndexOf("あ", 1));
	}

	public function test_Unifill_uLastIndexOf() {
		assertEquals(0, "𩸽あëa".uLastIndexOf("𩸽"));
		assertEquals(1, "𩸽あëa".uLastIndexOf("あ"));
		assertEquals(2, "𩸽あëa".uLastIndexOf("ë"));
		assertEquals(3, "𩸽あëa".uLastIndexOf("a"));
		assertEquals(-1, "𩸽あëa".uLastIndexOf("z"));
		assertEquals(0, "𩸽あëa".uLastIndexOf("𩸽", 1));
		assertEquals(1, "𩸽あëa".uLastIndexOf("あ", 1));
		assertEquals(-1, "𩸽あëa".uLastIndexOf("ë", 1));
	}

	public function test_Unifill_uSplit() {
		assertEquals("𩸽,あ,ë,a", "𩸽あëa".uSplit("").join(","));
		assertEquals(",あ,ë,a,,", "𩸽あ𩸽ë𩸽a𩸽𩸽".uSplit("𩸽").join(","));
		assertEquals(",𩸽,ë,a,,", "あ𩸽あëあaああ".uSplit("あ").join(","));
		assertEquals(",𩸽,あ,a,,", "ë𩸽ëあëaëë".uSplit("ë").join(","));
		assertEquals(",𩸽,あ,ë,,", "a𩸽aあaëaa".uSplit("a").join(","));
	}

	public function test_Unifill_uSubstr() {
		assertEquals("𩸽", "𩸽あëa".uSubstr(0, 1));
		assertEquals("ë", "𩸽あëa".uSubstr(2, 1));
		assertEquals("a", "𩸽あëa".uSubstr(-1, 3));
		assertEquals("あë", "𩸽あëa".uSubstr(-3, 2));
		assertEquals("ëa", "𩸽あëa".uSubstr(2));
		assertEquals("", "𩸽あëa".uSubstr(4));
	}

	public function test_Unifill_uSubstring() {
		assertEquals("𩸽", "𩸽あëa".uSubstring(0, 1));
		assertEquals("あ", "𩸽あëa".uSubstring(2, 1));
		assertEquals("𩸽あë", "𩸽あëa".uSubstring(-1, 3));
		assertEquals("ëa", "𩸽あëa".uSubstring(2));
		assertEquals("", "𩸽あëa".uSubstring(4));
	}

	public function test_Unifill_uIterator() {
		var itr = "𩸽あëa".uIterator();
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x29E3D, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x03042, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x000EB, itr.next());
		assertEquals(true, itr.hasNext());
		assertEquals(cast 0x00061, itr.next());
		assertEquals(false, itr.hasNext());
	}

	public function test_Unifill_uCompare() {
		assertTrue("𩸽あëa".uCompare("𩸽あëa") == 0);
		assertTrue("𩸽あëaa".uCompare("𩸽あëa") > 0);
		assertTrue("𩸽あëa".uCompare("𩸽あëaa") < 0);
		assertTrue("𩸽あëa".uCompare("𩸽あëb") < 0);
		assertTrue("𩸽あëb".uCompare("𩸽あëa") > 0);
		assertTrue("𩸽".uCompare("�") > 0);
	}

	public function test_Unifill_uToString() {
		//assertEquals("𩸽あëa", (cast [0x29E3D, 0x03042, 0x000EB, 0x00061] : Array<CodePoint>).uToString());
		assertEquals("𩸽あëa", [cast 0x29E3D, cast 0x03042, cast 0x000EB, cast 0x00061].uToString());
		assertEquals("𩸽あëa", {iterator: "𩸽あëa".uIterator}.uToString());
	}

	public function test_Utf32_length() {
		assertEquals(4, new Utf32("𩸽あëa").length);
	}

	public function test_Utf32_concat() {
		assertEquals("𩸽あëa𩸽あëa", (new Utf32("𩸽あëa") + new Utf32("𩸽あëa")).toString());
	}

	public function test_Utf32_eq() {
		assertTrue(new Utf32("𩸽あëa") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") == new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") == new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") == new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") == new Utf32("�"));
	}

	public function test_Utf32_lt() {
		assertFalse(new Utf32("𩸽あëa") < new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") < new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëa") < new Utf32("𩸽あëaa"));
		assertTrue(new Utf32("𩸽あëa") < new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") < new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") < new Utf32("�"));
	}

	public function test_Utf32_lte() {
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëaa") <= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëaa"));
		assertTrue(new Utf32("𩸽あëa") <= new Utf32("𩸽あëb"));
		assertFalse(new Utf32("𩸽あëb") <= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽") <= new Utf32("�"));
	}

	public function test_Utf32_gt() {
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëaa") > new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") > new Utf32("𩸽あëb"));
		assertTrue(new Utf32("𩸽あëb") > new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽") > new Utf32("�"));
	}

	public function test_Utf32_gte() {
		assertTrue(new Utf32("𩸽あëa") >= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽あëaa") >= new Utf32("𩸽あëa"));
		assertFalse(new Utf32("𩸽あëa") >= new Utf32("𩸽あëaa"));
		assertFalse(new Utf32("𩸽あëa") >= new Utf32("𩸽あëb"));
		assertTrue(new Utf32("𩸽あëb") >= new Utf32("𩸽あëa"));
		assertTrue(new Utf32("𩸽") >= new Utf32("�"));
	}

	public function test_Utf32_cons_and_snoc() {
		var c = new CodePoint(0x29E3D);
		assertTrue(new Utf32("𩸽あëa") == c + new Utf32("あëa"));
		assertTrue(new Utf32("あëa𩸽") == new Utf32("あëa") + c);
	}

}

class Main {

	static function main() {
		var r = new haxe.unit.TestRunner();
		r.add(new TestUnifill());
		r.run();
	}

}

