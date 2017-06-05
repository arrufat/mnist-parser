// sources: src/mnist.vala

public class MnistLabels : Mnist {
	public MnistLabels (string path) {
		this.path = path;
		this.data = FileStream.open (path, "r");
		assert (this.data != null);
		assert (this.magic_number == 2049);
	}

	public int[] labels {
		owned get {
			var result = new int[this.num_elems];
			skip_bytes (8);
			for (var i = 0; i < result.length; i++) {
				result[i] = this.data.getc ();
			}
			return result;
		}
	}

	public void info () {
		print ("\nMNIST Labels Info:\n");
		print ("Size: %li bytes\n", this.size);
		print ("Magic number: %d\n", this.magic_number);
		print ("Number of labels: %d\n", this.num_elems);
	}
}
