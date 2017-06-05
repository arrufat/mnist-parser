// sources: src/mnist.vala

public class MnistImages : Mnist {

	public MnistImages (string path) {
		this.path = path;
		this.data = FileStream.open (path, "r");
		assert (this.data != null);
		assert (this.magic_number == 2051);
	}

	public int num_rows {
		get {
			skip_bytes (8);
			var result = parse_int (this.data);
			this.data.rewind ();
			return result;
		}
	}

	public int num_cols {
		get {
			skip_bytes (12);
			var result = parse_int (this.data);
			this.data.rewind ();
			return result;
		}
	}
	
	public double mean {
		get {
			var sum = 0.0;
			var total = this.num_elems * this.num_rows * this.num_cols;
			skip_bytes (16);
			for (var i = 0; i < total; i++) {
				var tmp = (double) this.data.getc () / 255.0;
				sum += tmp;
			}
			this.data.rewind ();
			return sum / (double) total;
		}
	}
	
	public double std {
		get {
			var sum = 0.0;
			var mean = this.mean;
			var total = this.num_elems * this.num_rows * this.num_cols;
			skip_bytes (16);
			for (var i = 0; i < total; i++) {
				var tmp = (double) this.data.getc () / 255.0;
				sum += (tmp - mean) * (tmp - mean);
			}
			this.data.rewind ();
			return Math.sqrt (sum / (double) total);
		}
	}

	public void generate (string prefix) {
			var num_rows = this.num_rows;
			var num_cols = this.num_cols;
			var num_elems = this.num_elems;
			var pixels = this.num_rows * this.num_cols;
			skip_bytes (16);
			for (var n = 0; n < num_elems; n++) {
				/* image name */
				var image = FileStream.open ("%s_%05d.pgm".printf (prefix, n), "wb");
				/* write image header */
				image.printf ("P5 %d %d %d ", num_cols, num_rows, 255);
				for (var i = 0; i < pixels; i++) {
					image.putc ((char) this.data.getc ());
				}
			}
	}

	public void info () {
		print ("\nMNIST Images Info:\n");
		print ("Size: %li bytes\n", this.size);
		print ("Magic number: %d\n", this.magic_number);
		print ("Number of images: %d\n", this.num_elems);
		print ("Number of rows: %d\n", this.num_rows);
		print ("Number of cols: %d\n", this.num_cols);
		print ("Mean: %f\n", this.mean);
		print ("Std: %f\n", this.std);
	}

}
