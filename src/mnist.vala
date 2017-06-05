public abstract class Mnist : Object {
	protected string path;
	protected FileStream data;

	protected int parse_int (FileStream data) {
		var result = 0;
		for (var i = 0; i < 4; i++) {
			result |= (int) this.data.getc () << (2 * (12 - 4 * i));
		}
		return result;
	}

	protected void skip_bytes (int n) {
		this.data.seek (n, FileSeek.CUR);
	}

	public long size {
		get {
			this.data.seek (0, FileSeek.END);
			var result = this.data.tell ();
			this.data.rewind ();
			return result;
		}
	}

	public int magic_number {
		get {
			var result = parse_int (this.data);
			this.data.rewind ();
			return result;
		}
	}

	public int num_elems {
		get {
			skip_bytes (4);
			var result = parse_int (this.data);
			this.data.rewind ();
			return result;
		}
	}
}
