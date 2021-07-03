#!/usr/bin/tclsh
package require http
package require tls
package require autoproxy

set usage {
Usage: qai [option] [article_url]

Options:
	-h,	--help		show help
	-V,	--version	show version
}
set version 1.0.0

# no argument
if {$argc == 0} {puts stdout $usage; exit}

# option
set first [lindex $argv 0]
while {$argc > 0} {
	switch -regexp -- $first {
		"^(-h|--help)$" {
			puts stdout $usage; exit
		}
		"^(-V|--version)$" {
			puts stdout $version; exit
		}
		"^(-.+)$" {
			puts stderr "illegal option -- $first"
			puts stderr $usage
			exit
		}
		default {
			break
		}
	}
}

# info qiita url
proc detail_article {url} {
	if {$url == ""} {puts stderr "no url"; exit}

	# register https
	::http::register https 443 [list ::tls::socket -ssl2 0 -ssl3 0 -tls1 1]

	# request url
	set token [::http::geturl "$url.md"]
	set data [::http::data $token]
	::http::cleanup $token

	# get title
	regexp -line {title: (.+)} $data -> title

	# get all image_url
	set image_matches [regexp -all -inline -line {!\[.+\]\((.+)\)} $data]
	set image_list [lsearch -all -inline -not $image_matches "!*"]

	# show article info
	puts "title $title"
	set i 0
	foreach {im} $image_list {
		incr i
		puts "image$i $im"
	}

}

detail_article $first
