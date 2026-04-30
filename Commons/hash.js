function strToUtf8Bytes(str) {
	const bytes = [];
	for (let i = 0; i < str.length; i++) {
		let charCode = str.charCodeAt(i);
		if (charCode < 0x80)
			bytes.push(charCode); // 1-byte character
		else if (charCode < 0x800)
			bytes.push(0xc0 | (charCode >> 6), 0x80 | (charCode & 0x3f)); // 2-byte character
		else if (charCode < 0xd800 || charCode >= 0xe000)
			bytes.push(
				0xe0 | (charCode >> 12),
				0x80 | ((charCode >> 6) & 0x3f),
				0x80 | (charCode & 0x3f),
			); // 3-byte character not including surrogate pairs
		else {
			// surrogate pair
			i++; // Including next code point (low surrogate)
			charCode =
				0x10000 + // Combine high and low surrogate to get the actual code point
				(((charCode & 0x3ff) << 10) | // high surrogate's 10 bits
					(str.charCodeAt(i) & 0x3ff)); // low surrogate's 10 bits
			bytes.push(
				0xf0 | (charCode >> 18),
				0x80 | ((charCode >> 12) & 0x3f),
				0x80 | ((charCode >> 6) & 0x3f),
				0x80 | (charCode & 0x3f),
			);
		}
	}
	return bytes;
}

function bytesToHex(bytes, col, base = 8) {
	console.log("Total Bytes Length (including padding):", bytes.length);
	console.log("Padded Message Bytes:");
	for (let i = 0; i < bytes.length / col; i++) {
		console.log(
			i.toString().padStart(2),
			bytes
				.slice(i * col, i * col + col)
				.map((b) => b.toString(2).padStart(base, "0"))
				.join(" "),
		);
	}
}

function uint32ToBigEndian(uint) {
	const bytes = new Array(8).fill(0); // Initialize an array of 8 bytes (64 bits) with zeros

	const high = Math.floor(uint / 0x100000000); // Get the high 32 bits
	const low = uint % 0x100000000; // Get the low 32 bits

	// High byte of the high 32 bits
	bytes[0] = (high >> 24) & 0xff;
	bytes[1] = (high >> 16) & 0xff;
	bytes[2] = (high >> 8) & 0xff;
	bytes[3] = high & 0xff;
	// Low byte of the high 32 bits
	bytes[4] = (low >> 24) & 0xff;
	bytes[5] = (low >> 16) & 0xff;
	bytes[6] = (low >> 8) & 0xff;
	bytes[7] = low & 0xff;

	return bytes;
}

function rightRotate(value, amount) {
	return ((value >>> amount) | (value << (32 - amount))) >>> 0;
}

function sha256(message) {
	// Initialize round constants (k)
	const K = [
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
		0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
		0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
		0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
		0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
		0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
		0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
		0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
	];

	// Initialize hash values (h)
	let h0 = 0x6a09e667;
	let h1 = 0xbb67ae85;
	let h2 = 0x3c6ef372;
	let h3 = 0xa54ff53a;
	let h4 = 0x510e527f;
	let h5 = 0x9b05688c;
	let h6 = 0x1f83d9ab;
	let h7 = 0x5be0cd19;

	const msgBytes = strToUtf8Bytes(message); // convert string to UTF-8 bytes

	// Calculate padding
	// MSG + 1 bit (0x80) + padding zeros + 64 bits length = multiple of 64 bytes (512 bits)
	const totalBitsLength = msgBytes.length * 8 + 1 + 64; // +1 for the 0x80 bit, +64 bits for the length
	const totalBitsNeeded = Math.ceil(totalBitsLength / 512) * 512; // Round up to the multiple of 512
	const totalBytesNeeded = totalBitsNeeded / 8; // Convert bits to bytes
	const bitLengthToBytes = uint32ToBigEndian(msgBytes.length * 8); // Length in bits as a 64-bit big-endian integer

	const paddedMsg = new Array(totalBytesNeeded).fill(0); // Initialize with zeros
	for (let i = 0; i < msgBytes.length; i++) {
		paddedMsg[i] = msgBytes[i]; // Copy original message bytes
	}
	paddedMsg[msgBytes.length] = 0x80; // Append the '1' bit (0x80)
	for (let i = 0; i < bitLengthToBytes.length; i++) {
		paddedMsg[totalBytesNeeded - 8 + i] = bitLengthToBytes[i]; // Append the length in bits at the end
	}

	// Process the message in successive 512-bit (64-byte) chunks
	for (let chunk = 0; chunk < paddedMsg.length; chunk += 64) {
		const w = new Array(64); // Message schedule array (w)

		// Break chunk into sixteen 32-bit big-endian words w[0..15]
		for (let i = 0; i < 16; i++) {
			const byteIndex = chunk + i * 4;
			w[i] =
				(paddedMsg[byteIndex] << 24) |
				(paddedMsg[byteIndex + 1] << 16) |
				(paddedMsg[byteIndex + 2] << 8) |
				paddedMsg[byteIndex + 3];
			w[i] = w[i] >>> 0; // Ensure unsigned 32-bit integer
		}

		// Extend the first 16 words into the remaining 48 words w[16..63] of the message schedule array:
		for (let i = 16; i < 64; i++) {
			const s0 =
				rightRotate(w[i - 15], 7) ^
				rightRotate(w[i - 15], 18) ^
				(w[i - 15] >>> 3);
			const s1 =
				rightRotate(w[i - 2], 17) ^
				rightRotate(w[i - 2], 19) ^
				(w[i - 2] >>> 10);
			w[i] = (w[i - 16] + s0 + w[i - 7] + s1) >>> 0;
		}

		// Initialize working variables to current hash value:
		let a = h0,
			b = h1,
			c = h2,
			d = h3,
			e = h4,
			f = h5,
			g = h6,
			h = h7;

		// Compression function main loop:
		for (let i = 0; i < 64; i++) {
			const S1 = rightRotate(e, 6) ^ rightRotate(e, 11) ^ rightRotate(e, 25);
			const ch = (e & f) ^ (~e & g);
			const temp1 = (h + S1 + ch + K[i] + w[i]) >>> 0;
			const S0 = rightRotate(a, 2) ^ rightRotate(a, 13) ^ rightRotate(a, 22);
			const maj = (a & b) ^ (a & c) ^ (b & c);
			const temp2 = (S0 + maj) >>> 0;

			h = g;
			g = f;
			f = e;
			e = (d + temp1) >>> 0;
			d = c;
			c = b;
			b = a;
			a = (temp1 + temp2) >>> 0;
		}

		// Modify the hash values (h0..h7) with the results of this chunk:
		h0 = (h0 + a) >>> 0;
		h1 = (h1 + b) >>> 0;
		h2 = (h2 + c) >>> 0;
		h3 = (h3 + d) >>> 0;
		h4 = (h4 + e) >>> 0;
		h5 = (h5 + f) >>> 0;
		h6 = (h6 + g) >>> 0;
		h7 = (h7 + h) >>> 0;
	}

	return [h0, h1, h2, h3, h4, h5, h6, h7]
		.map((h) => h.toString(16).padStart(8, "0"))
		.join("");
}
