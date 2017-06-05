// modules: gio-2.0
// sources: src/mnist.vala src/mnist-images.vala src/mnist-labels.vala subprojects/optionguess/src/optionguess.vala

using GLib;
using OG;

public class Main : Object {

	private static string? images = null;
	private static string? labels = null;
	private static string? output = null;
	private static string? prefix = null;
	private static bool force = false;

	private const OptionEntry[] options = {
		{ "images", 'i', 0, OptionArg.FILENAME, ref images, "MNIST Images data file", "FILE" },
		{ "labels", 'l', 0, OptionArg.FILENAME, ref labels, "MNIST Labels data file", "FILE" },
		{ "output", 'o', 0, OptionArg.FILENAME, ref output, "Output directory", "DIRECTORY" },
		{ "prefix", 'p', 0, OptionArg.FILENAME, ref prefix, "Image name prefix", "STRING" },
		{ "force", 0, 0, OptionArg.NONE, ref force, "Force output overwrite", null },
		{ null } // list terminator
	};

	public static int main (string[] args) {
		var args_length = args.length;
		string help;
		try {
			var opt_context = new OptionContext (" - MNIST Data Parser");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			opt_context.parse (ref args);
			help = opt_context.get_help (true, null);
		} catch (OptionError e) {
			var opt_guess = new OptionGuess (options, e);
			opt_guess.print_message ();
			return 0;
		}

		if (args_length == 1) {
			print (help + "\n");
			return 0;
		}

		if (images != null) {
			var mnist_images = new MnistImages (images);
			mnist_images.info ();
			if (output != null && prefix != null) {
				File output_dir = File.new_for_commandline_arg (output);
				try {
					output_dir.make_directory_with_parents ();
				} catch (Error e) {
					print ("** WARNING **: %s\n", e.message);
					if (force) {
						print ("** MESSAGE **: Overwriting %s...\n", output);
						remove_dir_recursively (output);
					} else {
						print ("** MESSAGE **: Use --force to overwrite existing files.\n");
						return 0;
					}
				}
				mnist_images.generate(output + "/" + prefix);
			}
		}
		if (labels != null) {
			var mnist_labels = new MnistLabels (labels);
			mnist_labels.info ();
		}

		if (images != null && labels != null && prefix != null) {
			var mnist_images = new MnistImages (images);
			var mnist_labels = new MnistLabels (labels);
			assert (mnist_images.num_elems == mnist_labels.num_elems);
			var ground_truth = FileStream.open (output + "/ground_truth.txt", "w");
			var labs = mnist_labels.labels;
			var n = 0;
			foreach (var l in labs) {
				ground_truth.printf ("%s_%05d.pgm\t%d\n", prefix, n++, l);
			}
		}
		return 0;
	}

	private static void remove_dir_recursively (string path) {
		string content;
		try {
			var directory = Dir.open (path);
			while ((content = directory.read_name ()) != null) {
				var content_path = path + Path.DIR_SEPARATOR_S + content;
				if (FileUtils.test (path + Path.DIR_SEPARATOR_S + content, FileTest.IS_DIR)) {
					remove_dir_recursively (content_path);
					FileUtils.remove (content_path);
				} else {
					FileUtils.remove (content_path);
				}
			}
		} catch (FileError e) {
			error ("%s\n", e.message);
		}
	}

}
