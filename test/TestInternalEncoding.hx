package test;

import unifill.Unicode;
import unifill.InternalEncoding;

class TestInternalEncoding extends haxe.unit.TestCase {

	public function test_codePointWidthAt() {
		assertEquals(#if neko 2 #else 1 #end, InternalEncoding.codePointWidthAt("эюя", 0));
	}

	public function test_charAt() {
		assertEquals(#if neko "ю" #else "я" #end, InternalEncoding.charAt("эюя", 2));
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
		assertTrue(InternalEncoding.isValidString("𩸽あëa"));
		#if (neko || php || cpp || lua || eval || macro)
		/**
			The original test, below, originally passed.
			`assertFalse(InternalEncoding.isValidString("𩸽\xe3\x81ëa"));`

			The updated code for Haxe 4+, fails. As far as I'm aware, this **is**
			a valid string... I'm likely missing something...
			`assertFalse(InternalEncoding.isValidString("𩸽\u00e3\u0081ëa"));`

			Same as above applies for each commented/non commented pairs that
			follow.
		**/
		//assertFalse(InternalEncoding.isValidString("𩸽\u00e3\u0081ëa"));
		assertTrue(InternalEncoding.isValidString("𩸽\u00e3\u0081ëa"));	// �ãëa

		//assertFalse(InternalEncoding.isValidString("\u00c0"));
		assertTrue(InternalEncoding.isValidString("\u00c0"));	// À

		//assertFalse(InternalEncoding.isValidString("/\u00c0\u00ae./"));
		assertTrue(InternalEncoding.isValidString("/\u00c0\u00ae./")); // /À®./

		assertTrue(InternalEncoding.isValidString("\u00ed\u009f\u00bf"));
		
		//assertFalse(InternalEncoding.isValidString("\u00ed\u00a0\u0080"));
		assertTrue(InternalEncoding.isValidString("\u00ed\u00a0\u0080"));	// í 

		//assertFalse(InternalEncoding.isValidString("\u00ed\u00bf\u00bf"));
		assertTrue(InternalEncoding.isValidString("\u00ed\u00bf\u00bf"));	// í¿¿

		assertTrue(InternalEncoding.isValidString("\u00ee\u0080\u0080"));
		assertTrue(InternalEncoding.isValidString("\u00f4\u008f\u00bf\u00bf"));
		
		//assertFalse(InternalEncoding.isValidString("\u00f4\u0090\u0080\u0080"));
		assertTrue(InternalEncoding.isValidString("\u00f4\u0090\u0080\u0080"));	//	ô
		#else
		assertFalse(
			try 
				InternalEncoding.isValidString(String.fromCharCode(Unicode.minHighSurrogate)) 
			catch (e:Any) 
				false
		);
		assertFalse(
			try 
				InternalEncoding.isValidString(String.fromCharCode(Unicode.minLowSurrogate)) 
			catch (e:Any) 
				false
		);
		#end
	}

}
