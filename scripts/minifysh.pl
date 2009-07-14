#!/usr/bin/perl

$_ = do {
	local $/;
	<>;
};
s/^#[^!].+//gm;
s/\s+#.+//g;
s/\t/ /g;
s/^\s+//gm;
s/[\r\n]+/\n/g;
print;
