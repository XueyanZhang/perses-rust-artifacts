This folder contains the files we experimented on which failed to reduce, and a description of why
that is the case.

- rust-63791.rs: This file failed to reduce in Perses with the slicer flags turned on, taking >8 hours.
- rust-78654.rs: This file failed to pass the parsing tests due to the Rust edition not being set properly.
		 Time permitting, we will fix the scripts to account for the different (2015 vs 2018) Rust editions.
