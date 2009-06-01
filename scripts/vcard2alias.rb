#!/usr/bin/ruby

all_emails = []

STDIN.read.gsub(/\r\n/,"\n").scan(/BEGIN:VCARD\n([^\f]+?)END:VCARD\n/).each do |vcf|
	emails = []
	fn = nil
	vcf[0].each_line do |line|
		line = line.chomp.split(/:/)
		line[0] = line[0].split(/;/).shift
		line[1].gsub!(/\\(.)/, '\1') if line[1]
		emails << line[1] if line[0] == 'EMAIL'
		fn = line[1] if line[0] == 'FN'
	end
	emails.each_with_index do |email, i|
		next if all_emails.index(email)
		puts "alias \"#{email}\" \"#{fn || email}\" <#{email}>"
		puts "alias \"#{fn.gsub(/\s+/,'')}#{i < 1 ? '' : i+1}\" \"#{fn}\" <#{email}>" if fn
		all_emails << email
	end
end
